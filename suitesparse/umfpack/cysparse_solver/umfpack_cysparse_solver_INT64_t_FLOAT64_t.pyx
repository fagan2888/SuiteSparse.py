from suitesparse.umfpack.umfpack_solver_base_INT64_t_FLOAT64_t cimport UmfpackSolverBase_INT64_t_FLOAT64_t

cdef class UmfpackCysparseSolver_INT64_t_FLOAT64_t(UmfpackSolverBase_INT64_t_FLOAT64_t):
    def __cinit__(self, A, **kwargs):
        pass