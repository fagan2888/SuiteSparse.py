from suitesparse.umfpack.umfpack_solver_base_INT32_t_COMPLEX128_t cimport UmfpackSolverBase_INT32_t_COMPLEX128_t

cdef class UmfpackCysparseSolver_INT32_t_COMPLEX128_t(UmfpackSolverBase_INT32_t_COMPLEX128_t):
    def __cinit__(self, A, **kwargs):
        pass