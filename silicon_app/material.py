from dataclasses import dataclass, field
from matplotlib.animation import Animation
import numpy as np

@dataclass
class AnisotropicProperty:
    """
    Contains the tensor describing an anisotropic property from a specific material
    """
    name:str
    tensor:np.ndarray
    main_axes:np.ndarray=field(default=np.array([[1, 0, 0],[0, 1, 0],[0, 0, 1]]), init=False)

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