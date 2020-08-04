#cython: language_level=3
cimport cython


ctypedef fused numeric_t:
    float
    double
    long long


@cython.boundscheck(False)  # Decativate bounds checking
@cython.wraparound(False)   # Deactivate negative indexing
def get_nearest_grid_index(numeric_t[:] v, numeric_t[:, :] vs):
    cdef Py_ssize_t x_max = vs.shape[0]
    cdef Py_ssize_t y_max = vs.shape[1]

    assert v.shape[0] == vs.shape[1]

    cdef Py_ssize_t i, x, y
    cdef numeric_t tmp, err, err_min

    i = 0
    err_min = -1
    for x in range(x_max):
        err = 0
        for y in range(y_max):
            tmp = vs[x, y] - v[y]
            err += tmp * tmp

        if err_min == -1 or err < err_min:
            i = x
            err_min = err

            if err_min == 0.:
                break
    return i