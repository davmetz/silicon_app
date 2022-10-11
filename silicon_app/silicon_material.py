

from matplotlib import pyplot as plt
import numpy as np
from silicon_app.eulerangle import CoordinateSystem
from silicon_app.material import AnisotropicElasticity, AnisotropicPiezoresistivity, AnisotropicProperty, build_anisotropy_tensor_4_cubic_crystal

# Silicon elastic coefficients s_{11}, s_{12}, s_{44} in Pa^-1 
s =  np.array([7.68, -2.14, 12.56]) *10**(-12)
# % Silicon Piezoresitive Coefficients pi_{11}, pi_{12}, pi_{44} for p-type in Pa^-1
pi_p =  np.array([6.6, -1.1, 138.1]) *10**(-11)
# % Silicon Piezoresitive Coefficients pi_{11}, pi_{12}, pi_{44} for n-type in Pa^-1
pi_n =  np.array([-102.2, 53.4, -13.6]) *10**(-11)

class Silicon :
    name='mono-Silicon'
    elasticity= AnisotropicElasticity('elasticity',build_anisotropy_tensor_4_cubic_crystal(*s))
    piezoresistivity_ptype = AnisotropicPiezoresistivity('piezoresistivity_ptype',build_anisotropy_tensor_4_cubic_crystal(*pi_p))
    piezoresistivity_ntype = AnisotropicPiezoresistivity('epiezoresistivity_ntype',build_anisotropy_tensor_4_cubic_crystal(*pi_n))

if __name__ == "__main__":
    Si= Silicon()
    print(Silicon.elasticity.tensor)


    base_a= CoordinateSystem([1,1,0],[-1,1,0],[0,0,1])
    theta= np.arange(360)

    fig, ax = plt.subplots(ncols=5, subplot_kw={'projection': 'polar'})
    E, v, G =Si.elasticity.compute_EvG(base_a, theta)
    ax[0].plot(theta*np.pi/180, E,'b')
    ax[1].plot(theta*np.pi/180, v,'r')
    ax[2].plot(theta*np.pi/180, G,'g')

    piL, piT =Si.piezoresistivity_ptype.compute_Pi(base_a, theta)
    ax[3].plot(theta*np.pi/180, piL,'b')
    ax[3].plot(theta*np.pi/180, piT,'r')
    piL, piT =Si.piezoresistivity_ntype.compute_Pi(base_a, theta)
    ax[4].plot(theta*np.pi/180, piL,'b')
    ax[4].plot(theta*np.pi/180, piT,'r')
   
    #ax.quiver([200], [0])

    plt.show()
    