classdef AnisotropicProperty
    %ANISOTROPICPROPERTY Contains the tensor describing an
    %anisotropic property from a specific material

    properties
        tensor; % coefficients tensor
    end

    properties(Access=protected)
        main_axes= [1 0 0; 0 1 0; 0 0 1];
    end

    methods
        function obj = AnisotropicProperty(tensor)
            %ANISOTROPICPROPERTY Constructor
            %   Input: tensor 6x6 matrix expressed for the main axes
            obj.tensor = tensor;
        end

        function x= mainAxes(obj)
            %MAINAXES Returns the main Axes vectors in which the tensor is defined
            % output x(i,:)=[xi, yi, zi]
            x= obj.main_axes;

        end
    end
end

