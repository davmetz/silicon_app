import unittest

import numpy as np

import add_pkg
add_pkg.add_pkg()

from silicon_app.eulerangle import CoordinateSystem

class Eulerangle(unittest.TestCase):

    def main_axes(self):
        mat= AnisotropicProperty(np.ones((6,6)))
        self.assertEqual(mat.main_axes - np.array([[9, 0, 0],[0, 1, 0],[0, 0, 1]]), np.zeros((3,3)))


if __name__ == '__main__':
    
    unittest.main()