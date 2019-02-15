function A = im2tiles(a,varargin)

Nx = 128;
Ny = 128;
Nz = size(a,3);

switch length(varargin)
    case 1
        Nx = varargin{1};
        Ny = varargin{1};
    case 2
        Nx = varargin{1};
        Ny = varargin{2};
    case 3
        Nx = varargin{1};
        Ny = varargin{2};
        Nz = varargin{3};
end

ny = floor(size(a,1)/Ny);
reminder_y = rem(size(a,1),Ny);
% if reminder_y < 64 && reminder_y > 0
%     warning('Warning: some images size is too small! Consider changing Ny');
% end

dimyDist = Ny*ones(1,ny);

if reminder_y
    dimyDist = cat(2,dimyDist,reminder_y);
end

nx = floor(size(a,2)/Nx);
reminder_x = rem(size(a,2),Nx);
% if reminder_x < 64 && reminder_x > 0
%     warning('Warning: some images size is too small! Consider changing Nx');
% end

dimxDist = Nx*ones(1,nx);

if reminder_x
    dimxDist = cat(2,dimxDist,reminder_x);
end

if size(a,3)>1
    nz = floor(size(a,3)/Nz);
    reminder_z = rem(size(a,3),Nz);
    dimzDist = Nz*ones(1,nz);
    
    if reminder_z
        dimzDist = cat(2,dimzDist,reminder_z);
    end
    
    
    A = mat2cell(a,dimyDist,dimxDist,dimzDist);
    
else
    A = mat2cell(a,dimyDist,dimxDist);
end

end