
from dataclasses import dataclass
from typing import Tuple
from matplotlib.axes import Axes

import numpy as np

@dataclass
class CoordinateSystem():
    x:np.ndarray
    y:np.ndarray
    z:np.ndarray

    def __post_init__(self):
        self.x = self._check_vector(self.x)
        self.y = self._check_vector(self.y)
        self.z = self._check_vector(self.z)
        self._check_is_base()

    def _check_vector(self, v:np.ndarray)->np.ndarray:
        if len(v) != 3:
            raise TypeError(f'Passed vector: {v}, is not a 3D vector')

        if not isinstance(v, np.ndarray):
            v= np.array(v)
        return v

    def _check_is_base(self):
        """"""
        matrix = self.matrix

        dot_prod= [
            np.dot(self.x, self.y),
            np.dot(self.x, self.z),
            np.dot(self.y, self.z)
        ]

        # The linearly dependent row vectors
        if any(d != 0 for d in dot_prod):
            raise ValueError(f'Passed vectors: {matrix}, are not forming an orthogonal base')
    
    @property
    def matrix(self)->np.ndarray:
        return np.vstack([self.x, self.y, self.z])

MAIN_COORDINATE_SYSTEM= CoordinateSystem([2,0,0],[0,2,0],[0,0,2])

def build_coordinate_system(x:np.ndarray, z:np.ndarray)->CoordinateSystem:
    return CoordinateSystem(x, np.cross(z, x), z)

def eulerianAngle(base_a:CoordinateSystem, base_b:CoordinateSystem)-> tuple[np.ndarray]:
    """
    Compute Eulerian angles $\alpha,\beta, \gamma$ noted a b c between the 
    bases $x_i$ noted x and $x_i'$  noted x_prime

    Args:
        base_a (np.ndarray): 3 vectors describing base_a; shape(3,3)
        base_b (np.ndarray): 3 vectors describing base_b; shape(3,3) 

    Returns:
        np.ndarray: three Eulerian angles abc = $[\alpha,\beta, \gamma]$
    """    
    # Compute Projection of b_z on the plane (a_x a_y) and vector N (line node direction)

    proj_bz_axy= [
        np.dot(base_b.z, base_a.x)/np.linalg.norm(base_a.x)**2,
        np.dot(base_b.z, base_a.y)/np.linalg.norm(base_a.y)**2,
        0
    ]
    rotZ_90deg = [
        [0, -1, 0],
        [1, 0, 0],
        [0, 0, 1]
    ]# pi/2 rotation of projection_b_z on a_z
    N = np.dot(proj_bz_axy,rotZ_90deg) if np.linalg.norm(proj_bz_axy)>0 else base_a.y
    # Assignment of the basis vectors $x_i'$
    abc = np.array([angle_btw_vectors(N, base_a.y),angle_btw_vectors(base_b.z, base_a.z),angle_btw_vectors(base_b.y, N)])
    return abc, N

def angle_btw_vectors(u:np.ndarray, v:np.ndarray)->float:
    # %ANGLEBTWVECTORS  Compute angles theta between both vectors u,v
    # %  Input:     two 1x3 vectors  u, v
    # %  Output:    angles theta between both vectors u,v
    # %  $\theta = acos (\frac{1}{abs(u)abs(v)})$
    #     theta = acos(dot(u, v)/(norm(u) * norm(v)));
    # end
    # u=np.reshape(u,(-1,))
    # v=np.reshape(v,(-1,))
    unit_u = u / np.linalg.norm(u)
    unit_v = v / np.linalg.norm(v)
    dot_product = np.dot(unit_u, unit_v)
    # return np.arccos(np.dot(u, v)/(np.linalg.norm(u) * np.linalg.norm(v)))  
    return np.arccos(dot_product)

def euler_angles_utils(new_base:CoordinateSystem, angle:np.ndarray)-> tuple[np.ndarray]:
    """
    _summary_

    Args:
        new_base (CoordinateSystem): _description_
        angle (np.ndarray): _description_

    Returns:
        tuple[np.ndarray]: _description_
    """
    euler_angles, _= eulerianAngle(MAIN_COORDINATE_SYSTEM, new_base)
    c = np.radians(angle) + euler_angles[2]
    # print(f'{euler_angles=}')
    #  cosines and sines from Eulerian angles
    ca =  np.cos(euler_angles[0])
    sa =  np.sin(euler_angles[0])
    cb =  np.cos(euler_angles[1])
    sb =  np.sin(euler_angles[1])
    cc =  np.cos(c)
    sc =  np.sin(c)
    # print(ca, sa, cb, sb, cc, sc)

    # compute l_i, m_i, n_i
    l=[ca*cb*cc-sa*sc, -ca*cb*sc-sa*cc, ca*sb]
    m=[sa*cb*cc+ca*sc, -sa*cb*sc+ca*cc, sa*sb]
    n=[-sb*cc, sb*sc, cb]
    # print(l[0].shape, m[0].shape, n[0].shape)
    # print(l[1].shape, m[1].shape, n[1].shape)

    lmn_const1= l[0]**2*m[0]**2+l[0]**2*n[0]**2+m[0]**2*n[1]**2
    lmn_const2=l[0]**2*l[1]**2+m[0]**2*m[1]**2+n[0]**2*n[1]**2
    return lmn_const1, lmn_const2

def plot_coordinatesystem(ax:Axes, cs:CoordinateSystem, label: str = None, color:str ='k'):
    if label is None:
        labels = ['X', 'Y', 'Z']
    else:
        labels = ['_'.join([axes, label])for axes in ['x', 'y', 'z']]
    origin = np.array([[0, 0, 0],[0, 0, 0],[0, 0, 0]]) # origin point
    V= cs.matrix
    ax.quiver(*origin, V[:,0], V[:,1],V[:,2],color=color)
    ax.text(*V[0,:], labels[0], color=color, fontsize=12)
    ax.text(*V[1,:], labels[1], color=color, fontsize=12)
    ax.text(*V[2,:], labels[2], color=color, fontsize=12)
    ax.set_xlim3d(-2,2)
    ax.set_ylim3d(-2,2)
    ax.set_zlim3d(-2,2)

if __name__ == "__main__":
    """"""
    print(f"{angle_btw_vectors([1,1,0], [0,0,1])}")
    base_a= CoordinateSystem([1,1,0],[-1,1,0],[0,0,1])
    base_b= CoordinateSystem([0,1,1],[0,1,-1],[1,0,0])
    print(eulerianAngle(base_a, base_b))

    import numpy as np
    import matplotlib.pyplot as plt
    ax = plt.figure().add_subplot(projection='3d')

    plot_coordinatesystem(ax, MAIN_COORDINATE_SYSTEM, label= None, color='k')
    plot_coordinatesystem(ax, base_b, label= 'b', color='r')
    plot_coordinatesystem(ax, base_a, label= 'a', color='b')
    plt.show()
    print(base_a.x.shape)
    print(base_a.y.shape)
    print(base_a.z.shape)
    a, b= euler_angles_utils(base_a, np.arange(90))
    print(a, a.shape)
    print(b, b.shape)



    
