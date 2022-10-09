import unittest

import numpy as np
from torch import compiled_with_cxx11_abi

import add_pkg
add_pkg.add_pkg()

from silicon_app.material import AnisotropicProperty, build_anisotropy_tensor_4_cubic_crystal

class Material(unittest.TestCase):

    def test_main_axes(self):
        mat= AnisotropicProperty(np.ones((6,6)))
        np.testing.assert_almost_equal(mat.main_axes, np.array([[1, 0, 0],[0, 1, 0],[0, 0, 1]]))
    def test_tensors(self):
        tensor=np.array(
            [
                [11, 12, 13, 14, 15, 16],
                [21, 22, 23, 24, 25, 26],
                [31, 32, 33, 34, 35, 36],
                [41, 42, 43, 44, 45, 46],
                [51, 52, 53, 54, 55, 56],
                [61, 62, 63, 64, 65, 66]
            ]
        )
        mat= AnisotropicProperty(tensor)
        np.testing.assert_almost_equal(tensor, mat.tensor)
        np.testing.assert_almost_equal(tensor[1,1], mat.c11)
        np.testing.assert_almost_equal(tensor[1,2], mat.c12)
        np.testing.assert_almost_equal(tensor[4,4], mat.c44)
        tensor=np.array(
            [
                [11, 12, 13, 0, 0, 0],
                [11, 12, 13, 0, 0, 0],
            ]
        )
        with self.assertRaises(TypeError):
            mat= AnisotropicProperty(tensor)
    def test_build_anisotropy_tensor_4_cubic_crystal(self):

        c11= 11
        c12= 12
        c44= 44

        testmat= [
            [c11, c12, c12,  0,  0,  0],
            [c12, c11, c12,  0,  0,  0],
            [c12, c12, c11,  0,  0,  0],
            [ 0,  0,  0, c44,  0,  0],
            [ 0,  0,  0,  0, c44,  0],
            [ 0,  0,  0,  0,  0, c44]
        ]
        testmat= np.array(testmat)

        mat= build_anisotropy_tensor_4_cubic_crystal(c11, c12, c44)
        self.assertTrue(isinstance(mat, np.ndarray))
        self.assertTrue(mat.shape ==(6,6))
        np.testing.assert_almost_equal(testmat, mat)

if __name__ == '__main__':
    
    unittest.main()