"""
Common solver interface in Cython.
"""

cdef class Solver_INT64_t_FLOAT64_t:
    cdef:
        str __solver_name
        object __A