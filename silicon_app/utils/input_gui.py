
import numpy as np



def convert2vector(text:str)->np.ndarray:
    """"""
    
    return np.array([float(t) for t in text.split(sep= ',')])


if __name__ == "__main__":
    print(convert2vector('2,2,2'))
    print(convert2vector('2  ,2, 2'))
    print(convert2vector('  2  ,  2  , 2  '))
