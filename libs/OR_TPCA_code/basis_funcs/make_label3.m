function [ X,label ] = make_label3(data_dir)
X_path=sprintf('%s/X3.mat',data_dir);
%M_path=sprintf('%s/M2.mat',data_dir);
label_path=sprintf('%s/label3.mat',data_dir);
if exist(X_path,'file') && exist(label_path,'file')%&& exist(M_path,'file') 
    load(X_path);
%    load(M_path);
    load(label_path);
else
    
    database = retr_database_dir(data_dir);
    
    if isempty(database),
        error('Data directory error!');
    end
    
    bpath=database.path{1};
    img=imread(bpath);
    [n1,n3,k]=size(img);
    
    flag=1;
    
    if n1>=400 && n3>=400
        flag=0;
        n1=floor(n1/2);
        n3=floor(n3/2);
    end
    
    X=zeros(n1,n3,database.imnum);
    % X=zeros(308,database.imnum,228);
    %M=zeros(n1*n3,database.imnum);
    label=zeros(database.imnum,1);
    base=1;
    baselabel=1;
    for i = 1:database.nclass,
        label(baselabel:database.cnum(i)+baselabel-1)=ones(database.cnum(i),1)*i;
        baselabel=baselabel+database.cnum(i);
        for j=1:database.cnum(i)
            bpath=database.path{base};
            img=imread(bpath);
            [~,~,k]=size(img);
            if k>1
                img=rgb2gray(img);
            end
            if(flag==0)
                img=imresize(img,[n1,n3]);
            end
            X(:,:,base)=img;%reshape(img,[308,228]);
            %         for k=1:d
            %             X(:,base,k)=img(:,k);
            %         end
            
            %M(:,base)=reshape(img,[n1*n3,1]);
            
            base=base+1;
        end
    end
    
    % idx=randperm(database.imnum);
    % XX=X(:,idx,:);
    % MM=M(:,idx);
    % labels=label(idx);
    
    save([data_dir,'\X3.mat'],'X');
%    save([data_dir,'\M.mat'],'M');
    save([data_dir,'\label3.mat'],'label');
    % save([data_dir,'\XX.mat'],'XX');
    % save([data_dir,'\MM.mat'],'MM');
    % save([data_dir,'\labels.mat'],'labels');
end
end
