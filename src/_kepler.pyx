# cython: profile=True

# cimport the Cython declarations for numpy
cimport numpy as np
import numpy as np
import cython

# if you want to use the Numpy-C-API from Cython
# (not strictly necessary for this example, but good practice)
np.import_array()

# Wrapping kepler(M,e) a simple function that takes two doubles as
# arguments and returns a double
cdef extern from "kepler.c":
    double kepler(double M, double e)

def kepler_cext(M, e):
    return kepler(M, e)

# cdefine the signature of our c function
cdef extern from "kepler.c":
    void kepler_array(double * M_array, double e, double * E_array, int size)


# create the wrapper code, with numpy type annotations
def kepler_array_cext(np.ndarray[np.float64_t, ndim=1, mode="c"] M_array, double e):
    cdef int size = M_array.shape[0]
    cdef np.ndarray[np.float64_t, ndim=1] E_array = \
        np.empty(size, dtype=np.float64)

    kepler_array(<double*> np.PyArray_DATA(M_array), e,
                 <double*> np.PyArray_DATA(E_array), size)
    return E_array 

#def kepler_array_cext2(np.ndarray[np.float64_t, ndim=1, mode="c"] M_array, double e):
#
#    cdef int size = M_array.shape[0]
#    
#    cdef np.ndarray[np.float64_t, ndim=1] E_array = \
#        np.empty(size, dtype=np.float64)
#
#    kepler_array(<double*> np.PyArray_DATA(M_array), e,
#                 <double*> np.PyArray_DATA(E_array), size)
#    return E_array 
