

function [W_tensor,V0,opts_syndata] = data_generator(opts_syndata,ii)

% generate synthetic data
%%
rng('default')
% opts_syndata.Input_Datalength = 200;
if ~isfield(opts_syndata, 'Input_Datalength'),  opts_syndata.Input_Datalength           = 200; end  %

%--- network parameters
if ~isfield(opts_syndata, 'N1'),                   opts_syndata.N1         = 30; end  %
if ~isfield(opts_syndata, 'K'),                     opts_syndata.K            = 5; end  %
if ~isfield(opts_syndata, 'zi'),                     opts_syndata.zi           = 10; end %
if ~isfield(opts_syndata, 'ze'),                   opts_syndata.ze           = 0; end %
if ~isfield(opts_syndata, 'Diag'),                opts_syndata.Diag        = 0; end  %
if ~isfield(opts_syndata, 'zi_min'),             opts_syndata.zi_min     = 5; end         %
if ~isfield(opts_syndata, 'zi_max'),            opts_syndata.zi_max   = 15; end  %

if ~isfield(opts_syndata, 'overlap'),                                 opts_syndata.overlap           = 1; end %
if ~isfield(opts_syndata, 'overlap_ratio'),                        opts_syndata.overlap_ratio   = .1; end %
if ~isfield(opts_syndata, 'overlap_community_pair'),      opts_syndata.overlap_community_pair = [1,2;2,3;3,4;4,5]; end   %


% [A,V0] = GGGirvanNewman(N1,K,zi,ze,Diag);
% W_tensor      = zeros(size(A,1),size(A,2),Input_Datalength); % adjacency tensor;
% All community membership ID in V0, each column is one community
% W_init_tensor00  =  zeros(size(A,1),size(A,2),opts_syndata.Input_Datalength);
for i =  1: opts_syndata.Input_Datalength
    opts_syndata.zi      =  randi([opts_syndata.zi_min,opts_syndata.zi_max],1);
    [A,V0]                     =  GGGirvanNewman(opts_syndata.N1,opts_syndata.K,opts_syndata.zi,opts_syndata.ze,opts_syndata.Diag,opts_syndata.overlap,opts_syndata.overlap_ratio,opts_syndata.overlap_community_pair);
    nonz_                     =  find(A~=0); % get all connected pairs
    Signal_init               =  zeros(size(A));
    val                          =  abs(randn(length(nonz_),1) );
    % val                         =  abs(ones(length(nonz_),1) );
    Signal_init(nonz_)       =  val/norm(val); % must be postive
    W_init_tensor(:,:,i)     =  Signal_init;
end

%+++++++++++++++ setting +++++++++++++++++++++++++++++++++++
% --- signal parameters
if ~isfield(opts_syndata, 'Input_Periods'),  opts_syndata.Input_Periods =  {[3,5,1],[3,5,7],[3,5,11],[3,5,17],[3,7,13]}; end
if ~isfield(opts_syndata, 'SNR'),                 opts_syndata.SNR                = 100; end  %


% ---local burst insertion
if ~isfield(opts_syndata, 'local_burst'),            opts_syndata.local_burst           = 0; end  %
if ~isfield(opts_syndata, 'num_burst'),            opts_syndata.num_burst           = 5; end         %
if ~isfield(opts_syndata, 'burst_size_range'),  opts_syndata.burst_size_range  = [10,15]; end  %

if ~isfield(opts_syndata, 'local_burst_ratio'),         opts_syndata.local_burst_ratio       = 0; end  %
if ~isfield(opts_syndata, 'burst_size'),                  opts_syndata.local_burst_size        = 10; end  %
if ~isfield(opts_syndata, 'mag_local_burst'),         opts_syndata.mag_local_burst       = .1; end %
if ~isfield(opts_syndata, 'visual_ll_burst'),             opts_syndata.visual_ll_burst           = 0; end   %


% global bursty insertion
if ~isfield(opts_syndata, 'global_burst'),                      opts_syndata.global_burst                   = 0; end %
if ~isfield(opts_syndata, 'global_num_burst'),             opts_syndata.global_num_burst           = 20; end %
if ~isfield(opts_syndata, 'global_burst_size_range'),    opts_syndata.global_burst_size_range = [5,5]; end   %
if ~isfield(opts_syndata, 'global_ratio_burst'),              opts_syndata.global_ratio_burst          = .1; end   %
if ~isfield(opts_syndata, 'global_burst_size'),               opts_syndata.global_burst_size           = 5; end   %

if ~isfield(opts_syndata, 'mag_gl_burst'),                    opts_syndata.mag_gl_burst                 = .01; end %
if ~isfield(opts_syndata, 'visual_gl_burst'),                  opts_syndata.visual_gl_burst                = 0; end   %

% --- outlier insertion
if ~isfield(opts_syndata, 'global_outlier'),                      opts_syndata.global_outlier                   = 0; end %
if ~isfield(opts_syndata, 'global_ratio_outlier'),              opts_syndata.global_ratio_outlier          = .1; end   %

% --- partial_period
if ~isfield(opts_syndata, 'partial_period'),                      opts_syndata.partial_period                   = 0; end %
if ~isfield(opts_syndata, 'period_percentage'),              opts_syndata.period_percentage          = 1; end   %
if ~isfield(opts_syndata, 'non_period_mag'),                 opts_syndata.non_period_mag           = 1; end   %

% NOT periodic community
if ~isfield(opts_syndata, 'no_community_id'),              opts_syndata.no_community_id          = [0]; end   %


% noise  tensor
if ~isfield(opts_syndata, 'noise_tensor'),              opts_syndata.noise_tensor          = 0; end   %
if ~isfield(opts_syndata, 'noise_tensor_ratio'),     opts_syndata.noise_tensor_ratio          = 0.1; end   %


%%
%% aggregate all data here for syn implicit nework
% random assign all element together, because we ONLY care the
% periodicity, nothing else should matter


W_tensor      =  zeros(size(A,1),size(A,2),opts_syndata.Input_Datalength); % adjacency tensor;
%global_burst  =  gen_global_burst(opts_syndata.Input_Datalength,opts_syndata.global_num_burst,opts_syndata.global_burst_size_range,opts_syndata.mag_gl_burst);
% global_burst  = gen_global_burst02(opts_syndata.Input_Datalength,opts_syndata.global_ratio_burst, opts_syndata.global_burst_size,opts_syndata.mag_gl_burst);
[global_burst,global_bursty_idx] = gen_global_burst03(opts_syndata.Input_Datalength,opts_syndata.global_ratio_burst, opts_syndata.global_burst_size,opts_syndata.mag_gl_burst);

opts_syndata.global_bursty_idx  =  global_bursty_idx;

% assign period to each community
x_mix = zeros(opts_syndata.Input_Datalength,opts_syndata.K);
for c = 1: opts_syndata.K
    [ID_c,~] = find(V0 == c); % find nodes in current community
    
    if  ~ismember(c, opts_syndata.no_community_id) % assign which community is not periodic
        % if  check(c, [0])  % assign which community is not periodic
        x_mix(:,c) = generate_periodic_signal(opts_syndata.Input_Periods{c},opts_syndata.Input_Datalength,opts_syndata.SNR);
        fprintf('The %d-th community is periodic.\n',c);
    else % if not periodic community, just assign random
        x_mix(:,c)    = abs(randn(opts_syndata.Input_Datalength,1));
        x_mix(:,c)    = x_mix(:,c)./norm(x_mix(:,c),2);
        fprintf('The %d-th community is NOT periodic.\n',c);
    end
    
    if opts_syndata.partial_period
        x_mix(:,c)   = vary_period_percentage_in_data(x_mix(:,c) , opts_syndata);
    end
    
    
    if opts_syndata.local_burst
        % x_mix(:,c) = inject_local_burst(x_mix(:,c),opts_syndata.num_burst,opts_syndata.burst_size_range, 1,0);
        [x_bursty, local_bursty_idx] = gen_local_burst(x_mix(:,c), opts_syndata.local_burst_ratio, opts_syndata.local_burst_size, opts_syndata.mag_local_burst,opts_syndata.visual_ll_burst);
        x_mix(:,c) = x_bursty;
        
        opts_syndata.local_bursty_idx_GT{c} = local_bursty_idx;
    end
    
    if opts_syndata.global_burst
        x_mix(:,c) = inject_global_burst(x_mix(:,c),global_burst, opts_syndata.visual_gl_burst);
    end
    
    Temp_tensor =  W_init_tensor(ID_c,ID_c,:);
    Temp_matrix =  reshape(Temp_tensor,[length(ID_c)^2,opts_syndata.Input_Datalength]);
    
    period_signal = Temp_matrix * diag(x_mix(:,c)); % add periodic signal to each community
    
    commu_tensor                    = zeros(size(A,1),size(A,2),opts_syndata.Input_Datalength); % adjacency tensor;
    commu_tensor(ID_c,ID_c,:) = reshape(period_signal,[length(ID_c),length(ID_c),opts_syndata.Input_Datalength]);
    
    
    W_tensor          = W_tensor + commu_tensor;
    commu_tensor = [];
end


if opts_syndata.noise_tensor>0
    [n1,n2,n3] =  size(W_tensor);
    nnz  =  floor(opts_syndata.noise_tensor_ratio*  n1*n2*n3);
    noise_tensor = generate_noise_tensor(W_tensor,nnz,opts_syndata.mag_noise_tensor);
    W_tensor      = W_tensor + noise_tensor;
end

if opts_syndata.global_outlier
    W_tensor = add_global_outlier(W_tensor,opts_syndata);
end


% % save W_tensor.mat
if ~ii
    ii    = input(prompt)
end

% prompt             = 'Input the index of synthetic data.\n';
% opts_syndata.filename           = ['syndata_',num2str(ii)];
% file_name_path     = ['data/syndata/',opts_syndata.filename ,'_.mat' ];
% save(file_name_path,'W_tensor','opts_syndata','-v7.3');