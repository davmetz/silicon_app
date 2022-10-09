
from silicon_app.material import AnisotropicProperty, build_anisotropy_tensor_4_cubic_crystal

# Silicon elastic coefficients s_{11}, s_{12}, s_{44} in Pa^-1 
s =  [7.68, -2.14, 12.56] *10^(-12)
# % Silicon Piezoresitive Coefficients pi_{11}, pi_{12}, pi_{44} for p-type in Pa^-1
pi_p =  [6.6, -1.1, 138.1] *10^(-11)
# % Silicon Piezoresitive Coefficients pi_{11}, pi_{12}, pi_{44} for n-type in Pa^-1
pi_n =  [-102.2, 53.4, -13.6] *10^(-11)

class Silicon :
    name='mono-Silicon'
    elasticity= AnisotropicProperty('elasticity',build_anisotropy_tensor_4_cubic_crystal(*s))
    piezoresistivity_ptype = AnisotropicProperty('piezoresistivity_ptype',build_anisotropy_tensor_4_cubic_crystal(*pi_p))
    piezoresistivity_ntype = AnisotropicProperty('epiezoresistivity_ntype',build_anisotropy_tensor_4_cubic_crystal(*pi_n))

if __name__ == "__main__":
    print(Silicon.elasticity.tensor)
    