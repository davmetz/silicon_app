classdef AnisotropicCubicProperty < AnisotropicProperty
    %ANISOTROPICCUBICPROPERTy Contains the tensor describing an
    %anisotropic property from a specific cubic crystal materials

    methods
        function obj = AnisotropicCubicProperty(coeff)
            %ANISOTROPICCUBICPROPERT Constructor
            % Input: coeff= [c11, c12, c44]
            %   build following tensor from the passed coefficients
            %   [c11, c12, c12,   0,   0,   0;
            %    c11, c11, c12,   0,   0,   0;
            %    c11, c12, c11,   0,   0,   0;
            %      0,   0,   0, c44,   0,   0;
            %      0,   0,   0,   0, c44,   0;
            %      0,   0,   0,   0,   0, c44;]
            c11_diag= diag(ones(1,3)*coeff(1));
            c44_diag= diag(ones(1,3)*coeff(3));
            c12_mat= ones(3)*coeff(2);
            c11c12_mat=c12_mat - diag(diag(c12_mat))+c11_diag;
            zeros3x3=zeros([3 3]);
            tensor=[
                c11c12_mat, zeros3x3;
                zeros3x3, c44_diag];
            obj@AnisotropicProperty(tensor);
        end


        function c = c11(obj)
            %C11 Returns coefficient c11
            c=obj.tensor(1,1);
        end
        function c = c12(obj)
            %C12 Returns coefficient c11
            c=obj.tensor(1,2);
        end
        function c = c44(obj)
            %C44 Returns coefficient c11
            c=obj.tensor(4,4);
        end

    end
end