

function Wm= get_tensor_mode(T)

if isa(T,'sptensor')
    Wm  = cell( ndims(T), 1 );
    dim =  size(T);
    % mode-1
    for i =  [1,3]%:  ndims(T)
        tmp = shiftdim(T,i-1);
        Wm{i}= reshape(tmp,[size(tmp,1), size(tmp,2)*size(tmp,3)]);
        % Wm{i}= reshape(shiftdim(T,i-1), dim(i), []);
    end
    
    Wm{2}= Wm{1};
    
else
    Wm  = cell( ndims(T), 1 );
    for d = 1:ndims(T)
        temp  = tenmat(T,d);
        Wm{d} = temp.data; % the matrix that is the unfolded tensor;; NOT transposed here
    end
end




