from suitesparse.solver_INT64_t_COMPLEX128_t cimport Solver_INT64_t_COMPLEX128_t

from suitesparse.common_types.suitesparse_types cimport *

cdef extern from "umfpack.h":

    cdef enum:
        UMFPACK_CONTROL, UMFPACK_INFO


cdef class UmfpackSolverBase_INT64_t_COMPLEX128_t(Solver_INT64_t_COMPLEX128_t):
    cdef:

        # UMFPACK takes a C CSC matrix object
        INT64_t * ind
        INT64_t * row


        FLOAT64_t * rval
        FLOAT64_t * ival



        # UMFPACK opaque objects
        void * symbolic

        void * numeric

        # Control and Info arrays
        public double info[UMFPACK_INFO]
        public double control[UMFPACK_CONTROL]


    cdef check_matrix(self)