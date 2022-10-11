from dataclasses import dataclass, field
from matplotlib.animation import Animation
import numpy as np

from silicon_app.eulerangle import MAIN_COORDINATE_SYSTEM, CoordinateSystem, euler_angles_utils, eulerianAngle

@dataclass
class Property:
    name:str

@dataclass
class AnisotropicProperty(Property):
    """
    Contains the tensor describing an anisotropic property from a specific material
    """
    tensor:np.ndarray
    main_base:np.ndarray=field(default=MAIN_COORDINATE_SYSTEM, init=False)

    def __post_init__(self):
        self._check_tensor()

    def _check_tensor(self):
        if not isinstance(self.tensor, np.ndarray) or self.tensor.shape != (6,6):
            raise TypeError(f'Passed tensor: {self.tensor}, is not an ndarray of shage (6,6) ')

    @property
    def c11(self)->float:
        return self.tensor[1,1]
    @property
    def c12(self)->float:
        return self.tensor[1,2]
    @property
    def c44(self)->float:
        return self.tensor[4,4]
    

@dataclass
class AnisotropicElasticity(AnisotropicProperty):

    def compute_EvG(self, new_base:CoordinateSystem, angle:np.ndarray)-> tuple[np.ndarray]:
        """
        Compute E_1, v_{12}, G_{12} in new_base (x:1, y:2, z:3), so in the plane XY for the angle starting +X


        Args:
            new_base (CoordinateSystem): _description_
            angle (np.ndarray): _description_

        Returns:
            tuple[np.ndarray]: _description_
        """
        
        # Compute E_1, v_{12}, G_{12} in new_base (x:1, y:2, z:3)
        lmn_const1, lmn_const2 = euler_angles_utils(new_base, angle)

        c= 2*((self.c11-self.c12)-self.c44/2)
        print(f'{c=}')
        print(f'{10**(-9)/(self.c11-c*lmn_const1)=}')
        Emodul= 10**(-9)/(self.c11-c*lmn_const1) # in GPa
        print(f'{-(2*self.c12+c*lmn_const2)=}')
        print(f'{(2*self.c11-2*c*lmn_const1)=}')
        v_ratio= -(2*self.c12+c*lmn_const2)/(2*self.c11-2*c*lmn_const1)
        Gmodul= 10**(-9)/(self.c44+2*c*lmn_const2) # in GPa   

        return Emodul, v_ratio, Gmodul

@dataclass
class AnisotropicPiezoresistivity(AnisotropicProperty):

    
    def compute_Pi(self, new_base:CoordinateSystem, angle:np.ndarray):
        # Compute pi_L = pi_{11}, pi_T = pi_{12} in new_base (x:1, y:2, z:3)
        lmn_const1, lmn_const2 = euler_angles_utils(new_base, angle)

        s= self.c11-self.c12-self.c44
        piL= (self.c11-2*s*lmn_const1) # in Pa^-1
        piT= (self.c12+s)*lmn_const2 # in Pa^-1 
        return piL, piT

def build_anisotropy_tensor_4_cubic_crystal(c11:float, c12:float, c44:float)->np.ndarray:
    """Build the tensor describing an anisotropic property from a cubic crystal materials
    
    build following tensor from the passed coefficients
    [c11, c12, c12,   0,   0,   0;
     c11, c11, c12,   0,   0,   0;
     c11, c12, c11,   0,   0,   0;
       0,   0,   0, c44,   0,   0;
       0,   0,   0,   0, c44,   0;
       0,   0,   0,   0,   0, c44;]

    Args:
        coeffs (np.ndarray): coefficients [c11, c12, c44] defined for a cubic material

    Returns:
        np.ndarray: tensor build from the passed coeffs
    """
    tensor=np.zeros((6,6))
    c11_diag= np.diag(np.ones(3)*c11)
    c44_diag= np.diag(np.ones(3)*c44)
    c12_mat= np.ones((3,3))*c12
    c11c12_mat=c12_mat - np.diag(np.diag(c12_mat))+c11_diag
    tensor[0:3,0:3]= c11c12_mat
    tensor[3:,3:]= c44_diag
    return tensor


if __name__ == "__main__":
    tensorA=np.array([[1, 0, 0],[0, 1, 0],[0, 0, 1]])
    propA= AnisotropicProperty('test',tensorA)
    print(f"{propA.tensor=}")
    print(f"{build_anisotropy_tensor_4_cubic_crystal([11,12,44])}")