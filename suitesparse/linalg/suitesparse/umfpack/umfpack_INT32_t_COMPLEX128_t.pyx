from cysparse.types.cysparse_types cimport *

from cysparse.sparse.ll_mat_matrices.ll_mat_INT32_t_COMPLEX128_t cimport LLSparseMatrix_INT32_t_COMPLEX128_t
from cysparse.sparse.csr_mat_matrices.csr_mat_INT32_t_COMPLEX128_t cimport CSRSparseMatrix_INT32_t_COMPLEX128_t, MakeCSRSparseMatrix_INT32_t_COMPLEX128_t
from cysparse.sparse.csc_mat_matrices.csc_mat_INT32_t_COMPLEX128_t cimport CSCSparseMatrix_INT32_t_COMPLEX128_t, MakeCSCSparseMatrix_INT32_t_COMPLEX128_t


from cysparse.types.cysparse_generic_types cimport split_array_complex_values_kernel_INT32_t_COMPLEX128_t, join_array_complex_values_kernel_INT32_t_COMPLEX128_t


from cpython.mem cimport PyMem_Malloc, PyMem_Realloc, PyMem_Free
from cpython cimport Py_INCREF, Py_DECREF

import numpy as np
cimport numpy as cnp


cnp.import_array()

cdef extern from "umfpack.h":

    char * UMFPACK_DATE
    ctypedef long SuiteSparse_long  # This is exactly CySparse's INT64_t

    cdef enum:
        UMFPACK_CONTROL, UMFPACK_INFO

        UMFPACK_VERSION, UMFPACK_MAIN_VERSION, UMFPACK_SUB_VERSION, UMFPACK_SUBSUB_VERSION

        # Return codes:
        UMFPACK_OK

        UMFPACK_WARNING_singular_matrix, UMFPACK_WARNING_determinant_underflow
        UMFPACK_WARNING_determinant_overflow

        UMFPACK_ERROR_out_of_memory
        UMFPACK_ERROR_invalid_Numeric_object
        UMFPACK_ERROR_invalid_Symbolic_object
        UMFPACK_ERROR_argument_missing
        UMFPACK_ERROR_n_nonpositive
        UMFPACK_ERROR_invalid_matrix
        UMFPACK_ERROR_different_pattern
        UMFPACK_ERROR_invalid_system
        UMFPACK_ERROR_invalid_permutation
        UMFPACK_ERROR_internal_error
        UMFPACK_ERROR_file_IO

        # Control:
        # Printing routines:
        UMFPACK_PRL
        # umfpack_*_symbolic:
        UMFPACK_DENSE_ROW
        UMFPACK_DENSE_COL
        UMFPACK_BLOCK_SIZE
        UMFPACK_STRATEGY
        UMFPACK_2BY2_TOLERANCE
        UMFPACK_FIXQ
        UMFPACK_AMD_DENSE
        UMFPACK_AGGRESSIVE
        # umfpack_*_numeric:
        UMFPACK_PIVOT_TOLERANCE
        UMFPACK_ALLOC_INIT
        UMFPACK_SYM_PIVOT_TOLERANCE
        UMFPACK_SCALE
        UMFPACK_FRONT_ALLOC_INIT
        UMFPACK_DROPTOL
        # umfpack_*_solve:
        UMFPACK_IRSTEP

        # For UMFPACK_STRATEGY:
        UMFPACK_STRATEGY_AUTO
        UMFPACK_STRATEGY_UNSYMMETRIC
        UMFPACK_STRATEGY_2BY2
        UMFPACK_STRATEGY_SYMMETRIC

        # For UMFPACK_SCALE:
        UMFPACK_SCALE_NONE
        UMFPACK_SCALE_SUM
        UMFPACK_SCALE_MAX

        # for SOLVE ACTIONS
        UMFPACK_A
        UMFPACK_At
        UMFPACK_Aat
        UMFPACK_Pt_L
        UMFPACK_L
        UMFPACK_Lt_P
        UMFPACK_Lat_P
        UMFPACK_Lt
        UMFPACK_U_Qt
        UMFPACK_U
        UMFPACK_Q_Ut
        UMFPACK_Q_Uat
        UMFPACK_Ut
        UMFPACK_Uat

    # TODO: Change types for CySparse types? int -> INT32_t, double -> FLOAT64_t etc?
    #       and keep only **one** declaration?







    ####################################################################################################################
    # ZI VERSION:   complex double precision, int integers
    ####################################################################################################################
    int umfpack_zi_symbolic(int n_row, int n_col,
                            int * Ap, int * Ai, double * Ax, double * Az,
                            void ** symbolic,
                            double * control, double * info)

    int umfpack_zi_numeric(int * Ap, int * Ai, double * Ax, double * Az,
                           void * symbolic,
                           void ** numeric,
                           double * control, double * info)

    void umfpack_zi_free_symbolic(void ** symbolic)
    void umfpack_zi_free_numeric(void ** numeric)
    void umfpack_zi_defaults(double * control)

    int umfpack_zi_solve(int umfpack_sys, int * Ap, int * Ai, double * Ax,  double * Az,
                         double * Xx, double * Xz, double * bx, double * bz, void * numeric, double * control, double * info)

    int umfpack_zi_get_lunz(int * lnz, int * unz, int * n_row, int * n_col,
                            int * nz_udiag, void * numeric)

    int umfpack_zi_get_numeric(int * Lp, int * Lj,
                               double * Lx, double * Lz,
                               int * Up, int * Ui,
                               double * Ux, double * Uz,
                               int * P, int * Q,
                               double * Dx, double * Dz,
                               int * do_recip, double * Rs,
                               void * numeric)

    void umfpack_zi_report_control(double *)
    void umfpack_zi_report_info(double *, double *)
    void umfpack_zi_report_symbolic(void *, double *)
    void umfpack_zi_report_numeric(void *, double *)







def umfpack_version():
    version_string = "UMFPACK version %s" % UMFPACK_VERSION

    return version_string

def umfpack_detailed_version():
    version_string = "%s.%s.%s (%s)" % (UMFPACK_MAIN_VERSION,
                                         UMFPACK_SUB_VERSION,
                                         UMFPACK_SUBSUB_VERSION,
                                         UMFPACK_DATE)
    return version_string

UMFPACK_SYS_DICT = {
        'UMFPACK_A'     : UMFPACK_A,
        'UMFPACK_At'    : UMFPACK_At,
        'UMFPACK_Aat'   : UMFPACK_Aat,
        'UMFPACK_Pt_L'  : UMFPACK_Pt_L,
        'UMFPACK_L'     : UMFPACK_L,
        'UMFPACK_Lt_P'  : UMFPACK_Lt_P,
        'UMFPACK_Lat_P' : UMFPACK_Lat_P,
        'UMFPACK_Lt'    : UMFPACK_Lt,
        'UMFPACK_U_Qt'  : UMFPACK_U_Qt,
        'UMFPACK_U'     : UMFPACK_U,
        'UMFPACK_Q_Ut'  : UMFPACK_Q_Ut,
        'UMFPACK_Q_Uat' : UMFPACK_Q_Uat,
        'UMFPACK_Ut'    : UMFPACK_Ut,
        'UMFPACK_Uat'   : UMFPACK_Uat
    }

UMFPACK_ERROR_CODE_DICT = {
        UMFPACK_OK: 'UMFPACK_OK',
        UMFPACK_WARNING_singular_matrix: 'UMFPACK_WARNING_singular_matrix',
        UMFPACK_WARNING_determinant_underflow: 'UMFPACK_WARNING_determinant_underflow',
        UMFPACK_WARNING_determinant_overflow: 'UMFPACK_WARNING_determinant_overflow',
        UMFPACK_ERROR_out_of_memory: 'UMFPACK_ERROR_out_of_memory',
        UMFPACK_ERROR_invalid_Numeric_object: 'UMFPACK_ERROR_invalid_Numeric_object',
        UMFPACK_ERROR_invalid_Symbolic_object: 'UMFPACK_ERROR_invalid_Symbolic_object',
        UMFPACK_ERROR_argument_missing: 'UMFPACK_ERROR_argument_missing',
        UMFPACK_ERROR_n_nonpositive: 'UMFPACK_ERROR_n_nonpositive',
        UMFPACK_ERROR_invalid_matrix: 'UMFPACK_ERROR_invalid_matrix',
        UMFPACK_ERROR_different_pattern: 'UMFPACK_ERROR_different_pattern',
        UMFPACK_ERROR_invalid_system: 'UMFPACK_ERROR_invalid_system',
        UMFPACK_ERROR_invalid_permutation: 'UMFPACK_ERROR_invalid_permutation',
        UMFPACK_ERROR_internal_error: 'UMFPACK_ERROR_internal_error',
        UMFPACK_ERROR_file_IO: 'UMFPACK_ERROR_file_IO'
}

def test_umfpack_result(status, msg, raise_error=True, print_on_screen=True):
    """
    Test returned status from UMFPACK routines.

    Args:
        status (int): Returned status from UMFPACK routines.
        msg: Message to display in error or on screen.
        raise_error: Raises an error if ``status`` is an error if ``True``..
        print_on_screen: Prints warnings on screen if ``True``.

    Raises:
        RuntimeError: If ``raise_error`` is ``True`` and ``status < 0``.

    """

    if status != UMFPACK_OK:

        if status < 0 and raise_error:
            raise RuntimeError("%s %s: %s" % (msg, "aborted", UMFPACK_ERROR_CODE_DICT[status]))
        elif status > 0 and print_on_screen:
            print "%s %s: %s" % (msg, "warning", UMFPACK_ERROR_CODE_DICT[status])


cdef class UmfpackContext_INT32_t_COMPLEX128_t:
    """
    Umfpack Context from SuiteSparse.

    This version **only** deals with ``LLSparseMatrix_INT32_t_COMPLEX128_t`` objects.

    We follow the common use of Umfpack. In particular, we use the same names for the methods of this
    class as their corresponding counter-parts in Umfpack.
    """
    UMFPACK_VERSION = "%s.%s.%s (%s)" % (UMFPACK_MAIN_VERSION,
                                     UMFPACK_SUB_VERSION,
                                     UMFPACK_SUBSUB_VERSION,
                                     UMFPACK_DATE)

    ####################################################################################################################
    # INIT
    ####################################################################################################################
    def __cinit__(self, LLSparseMatrix_INT32_t_COMPLEX128_t A):
        """
        Args:
            A: A :class:`LLSparseMatrix_INT32_t_COMPLEX128_t` object.

        Warning:
            The solver takes a "snapshot" of the matrix ``A``, i.e. the results given by the solver are only
            valid for the matrix given. If the matrix ``A`` changes aferwards, the results given by the solver won't
            reflect this change.

        """
        self.A = A
        Py_INCREF(self.A)  # increase ref to object to avoid the user deleting it explicitly or implicitly

        self.nrow = A.nrow
        self.ncol = A.ncol

        self.nnz = self.A.nnz

        # test if we can use UMFPACK
        assert self.nrow == self.ncol, "Only square matrices are handled in UMFPACK"



        # we keep internally two arrays for the complex numbers: this is required by UMFPACK...
        self.internal_real_arrays_computed = False

        cdef:
            FLOAT64_t * rval
            FLOAT64_t * ival

        rval = <FLOAT64_t *> PyMem_Malloc(self.nnz * sizeof(FLOAT64_t))
        if not rval:
            raise MemoryError()
        self.csc_rval = rval

        ival = <FLOAT64_t *> PyMem_Malloc(self.nnz * sizeof(FLOAT64_t))
        if not ival:
            PyMem_Free(rval)
            raise MemoryError()
        self.csc_ival = ival


        self.csc_mat  = self.A.to_csc()

        self.symbolic_computed = False
        self.numeric_computed = False

        # set default parameters for control
        umfpack_zi_defaults(<double *>&self.control)
        self.set_verbosity(3)


    cdef create_real_arrays_if_needed(self):
        """
        Duplicate the complex ``val`` array of the CSC representation into two real arrays: ``csc_rval`` and ``csc_ival``.

        Note:
            Results are cached.

        """
        if not self.internal_real_arrays_computed:

            if self.nnz != self.A.nnz:
                raise RuntimeError('Initial matrix has changed!')

            split_array_complex_values_kernel_INT32_t_COMPLEX128_t(self.csc_mat.val, self.nnz,
                                                                       self.csc_rval, self.nnz,
                                                                       self.csc_ival, self.nnz)

            self.internal_real_arrays_computed = True


    ####################################################################################################################
    # FREE MEMORY
    ####################################################################################################################
    def __dealloc__(self):
        """
        
        """
        self.free()

        Py_DECREF(self.A) # release ref


        PyMem_Free(self.csc_rval)
        PyMem_Free(self.csc_ival)


    def free_symbolic(self):
        """
        Free symbolic object if needed.
        
        """
        if self.symbolic_computed:
            umfpack_zi_free_symbolic(&self.symbolic)

    def free_numeric(self):
        """
        Free numeric object if needed.
        
        """
        if self.numeric_computed:
            umfpack_zi_free_numeric(&self.numeric)

    def free(self):
        """
        Free symbolic and/or numeric objects if needed.
        
        """
        self.free_numeric()
        self.free_symbolic()

    ####################################################################################################################
    # PRIMARY ROUTINES
    ####################################################################################################################
    cdef int _create_symbolic(self):
        """
        Create the symbolic object.

        Note:
            Create the object no matter what. See :meth:`create_symbolic` for a conditional creation.
        
        """

        if self.symbolic_computed:
            self.free_symbolic()

        cdef INT32_t * ind = <INT32_t *> self.csc_mat.ind
        cdef INT32_t * row = <INT32_t *> self.csc_mat.row


        # create self.csc_rval and self.csc_ival **if** needed
        self.create_real_arrays_if_needed()

        cdef int status


        status= umfpack_zi_symbolic(self.nrow, self.ncol, ind, row, self.csc_rval, self.csc_ival, &self.symbolic, self.control, self.info)

        self.symbolic_computed = True

        return status


    def create_symbolic(self, recompute=False):
        """
        Create the symbolic object if it is not already in cache (or if ``recompute`` is set to ``True``).

        Args:
            recompute: If ``True`` forces the (re)computation of the object.
        
        """
        if not recompute and self.symbolic_computed:
            return

        cdef int status = self._create_symbolic()

        if status != UMFPACK_OK:
            self.free_symbolic()
            test_umfpack_result(status, "create_symbolic()")

    cdef int _create_numeric(self):
        """
        Create the numeric object.

        Note:
            Create the object no matter what. See :meth:`create_numeric` for a conditional creation.
        
        """

        if self.numeric_computed:
            self.free_numeric()

        cdef INT32_t * ind = <INT32_t *> self.csc_mat.ind
        cdef INT32_t * row = <INT32_t *> self.csc_mat.row


        # create self.csc_rval and self.csc_ival **if** needed
        self.create_real_arrays_if_needed()



        cdef INT32_t status =  umfpack_zi_numeric(ind, row,
                           self.csc_rval, self.csc_ival,
                           self.symbolic,
                           &self.numeric,
                           self.control, self.info)


        self.numeric_computed = True

        return status

    def create_numeric(self, recompute=False):
        """
        Create the numeric object if it is not already in cache (or if ``recompute`` is set to ``True``).

        Args:
            recompute: If ``True`` forces the (re)computation of the object.
        
        """

        if not recompute and self.numeric_computed:
            return

        self.create_symbolic(recompute=recompute)

        cdef int status = self._create_numeric()

        if status != UMFPACK_OK:
            self.free_numeric()
            test_umfpack_result(status, "create_numeric()")


    def solve(self, cnp.ndarray[cnp.npy_complex128, ndim=1, mode="c"] b, umfpack_sys='UMFPACK_A', irsteps=2):
        """
        Solve the linear system  ``A x = b``.

        Args:
           b: a Numpy vector of appropriate dimension.
           umfpack_sys: specifies the type of system being solved:

                    +-------------------+--------------------------------------+
                    |``"UMFPACK_A"``    | :math:`\mathbf{A} x = b` (default)   |
                    +-------------------+--------------------------------------+
                    |``"UMFPACK_At"``   | :math:`\mathbf{A}^T x = b`           |
                    +-------------------+--------------------------------------+
                    |``"UMFPACK_Pt_L"`` | :math:`\mathbf{P}^T \mathbf{L} x = b`|
                    +-------------------+--------------------------------------+
                    |``"UMFPACK_L"``    | :math:`\mathbf{L} x = b`             |
                    +-------------------+--------------------------------------+
                    |``"UMFPACK_Lt_P"`` | :math:`\mathbf{L}^T \mathbf{P} x = b`|
                    +-------------------+--------------------------------------+
                    |``"UMFPACK_Lt"``   | :math:`\mathbf{L}^T x = b`           |
                    +-------------------+--------------------------------------+
                    |``"UMFPACK_U_Qt"`` | :math:`\mathbf{U} \mathbf{Q}^T x = b`|
                    +-------------------+--------------------------------------+
                    |``"UMFPACK_U"``    | :math:`\mathbf{U} x = b`             |
                    +-------------------+--------------------------------------+
                    |``"UMFPACK_Q_Ut"`` | :math:`\mathbf{Q} \mathbf{U}^T x = b`|
                    +-------------------+--------------------------------------+
                    |``"UMFPACK_Ut"``   | :math:`\mathbf{U}^T x = b`           |
                    +-------------------+--------------------------------------+

           irsteps: number of iterative refinement steps to attempt. Default: 2

        Returns:
            ``sol``: The solution of ``A*x=b`` if everything went well.

        Raises:
            AttributeError: When vector ``b`` doesn't have a ``shape`` attribute.
            AssertionError: When vector ``b`` doesn't have the right first dimension.
            RuntimeError: Whenever ``UMFPACK`` returned status is not ``UMFPACK_OK`` and is an error.

        Notes:
            The opaque objects ``symbolic`` and ``numeric`` are automatically created if necessary.

            You can ask for a report of what happened by calling :meth:`report_info()`.

        
        
        """
        #TODO: add other umfpack_sys arguments to the docstring.
        # test argument b
        cdef cnp.npy_intp * shape_b
        try:
            shape_b = b.shape
        except:
            raise AttributeError("argument b must implement attribute 'shape'")
        dim_b = shape_b[0]
        assert dim_b == self.nrow, "array dimensions must agree"

        if umfpack_sys not in UMFPACK_SYS_DICT.keys():
            raise ValueError('umfpack_sys must be in' % UMFPACK_SYS_DICT.keys())

        self.control[UMFPACK_IRSTEP] = irsteps

        self.create_symbolic()
        self.create_numeric()

        cdef cnp.ndarray[cnp.npy_complex128, ndim=1, mode='c'] sol = np.empty(self.ncol, dtype=np.complex128)

        cdef INT32_t * ind = <INT32_t *> self.csc_mat.ind
        cdef INT32_t * row = <INT32_t *> self.csc_mat.row


        # create self.csc_rval and self.csc_ival **if** needed
        self.create_real_arrays_if_needed()

        # access b
        cdef COMPLEX128_t * b_data = <COMPLEX128_t *> cnp.PyArray_DATA(b)

        # create bx and bz
        cdef:
            FLOAT64_t * bx
            FLOAT64_t * bz

        bx = <FLOAT64_t *> PyMem_Malloc(dim_b * sizeof(FLOAT64_t))
        if not bx:
            raise MemoryError()

        bz = <FLOAT64_t *> PyMem_Malloc(dim_b * sizeof(FLOAT64_t))

        if not bz:
            PyMem_Free(bx)
            raise MemoryError()

        split_array_complex_values_kernel_INT32_t_COMPLEX128_t(b_data, dim_b,
                                                         bx, dim_b,
                                                         bz, dim_b)

        # create solx and solz
        cdef:
            FLOAT64_t * solx
            FLOAT64_t * solz

        solx = <FLOAT64_t *> PyMem_Malloc(self.ncol * sizeof(FLOAT64_t))
        if not solx:
            PyMem_Free(bx)
            PyMem_Free(bz)

            raise MemoryError()

        solz = <FLOAT64_t *> PyMem_Malloc(self.ncol * sizeof(FLOAT64_t))

        if not solz:
            PyMem_Free(bx)
            PyMem_Free(bz)

            PyMem_Free(solx)
            raise MemoryError()



        cdef int status =  umfpack_zi_solve(UMFPACK_SYS_DICT[umfpack_sys], ind, row, self.csc_rval, self.csc_ival, solx, solz, bx, bz, self.numeric, self.control, self.info)

        if status != UMFPACK_OK:
            test_umfpack_result(status, "solve()")


        # join solx and solz
        cdef COMPLEX128_t * sol_data = <COMPLEX128_t *> cnp.PyArray_DATA(sol)

        join_array_complex_values_kernel_INT32_t_COMPLEX128_t(solx, self.ncol,
                                                        solz, self.ncol,
                                                        sol_data, self.ncol)

        # Free temp arrays
        PyMem_Free(bx)
        PyMem_Free(bz)
        PyMem_Free(solx)
        PyMem_Free(solz)


        return sol

    ####################################################################################################################
    # LU ROUTINES
    ####################################################################################################################
    def get_lunz(self):
        """
        Determine the size and number of non zeros in the LU factors held by the opaque ``Numeric`` object.

        Returns:
            (lnz, unz, n_row, n_col, nz_udiag):

            lnz: The number of nonzeros in ``L``, including the diagonal (which is all one's)
            unz: The number of nonzeros in ``U``, including the diagonal.
            n_row, n_col: The order of the ``L`` and ``U`` matrices. ``L`` is ``n_row`` -by- ``min(n_row,n_col)``
                and ``U`` is ``min(n_row,n_col)`` -by- ``n_col``.
            nz_udiag: The number of numerically nonzero values on the diagonal of ``U``. The
                matrix is singular if ``nz_diag < min(n_row,n_col)``. A ``divide-by-zero``
                will occur if ``nz_diag < n_row == n_col`` when solving a sparse system
                involving the matrix ``U`` in ``solve()``.

        Raises:
            RuntimeError: When ``UMFPACK`` return status is not ``UMFPACK_OK`` and is an error.

        
        
        """
        self.create_numeric()

        cdef:
            INT32_t lnz
            INT32_t unz
            INT32_t n_row
            INT32_t n_col
            INT32_t nz_udiag

        cdef status = umfpack_zi_get_lunz(&lnz, &unz, &n_row, &n_col, &nz_udiag, self.numeric)

        if status != UMFPACK_OK:
            test_umfpack_result(status, "get_lunz()")

        return (lnz, unz, n_row, n_col, nz_udiag)

    def get_LU(self, get_L=True, get_U=True, get_P=True, get_Q=True, get_D=True, get_R=True):
        """
        Return LU factorisation objects. If needed, the LU factorisation is triggered.

        Returns:
            (L, U, P, Q, D, do_recip, R)

            The original matrix A is factorized into

                L U = P R A Q

            where:
             - L is unit lower triangular,
             - U is upper triangular,
             - P and Q are permutation matrices,
             - R is a row-scaling diagonal matrix such that

                  * the i-th row of A has been multiplied by R[i] if do_recip = True,
                  * the i-th row of A has been divided by R[i] if do_recip = False.

            L and U are returned as CSRSparseMatrix and CSCSparseMatrix sparse matrices respectively.
            P, Q and R are returned as NumPy arrays.


        
        
        """
        # TODO: use properties?? we can only get matrices, not set them...
        # TODO: implement the use of L=True, U=True, P=True, Q=True, D=True, R=True
        # i.e. allow to return only parts of the arguments and not necessarily all of them...
        self.create_numeric()

        cdef:
            INT32_t lnz
            INT32_t unz
            INT32_t n_row
            INT32_t n_col
            INT32_t nz_udiag

            INT32_t _do_recip

        (lnz, unz, n_row, n_col, nz_udiag) = self.get_lunz()

        # L CSR matrix
        cdef INT32_t * Lp = <INT32_t *> PyMem_Malloc((n_row + 1) * sizeof(INT32_t))
        if not Lp:
            raise MemoryError()

        cdef INT32_t * Lj = <INT32_t *> PyMem_Malloc(lnz * sizeof(INT32_t))
        if not Lj:
            PyMem_Free(Lp)
            raise MemoryError()


        cdef FLOAT64_t * Lx = <FLOAT64_t *> PyMem_Malloc(lnz * sizeof(FLOAT64_t))
        if not Lx:
            PyMem_Free(Lp)
            PyMem_Free(Lj)

            raise MemoryError()

        cdef FLOAT64_t * Lz = <FLOAT64_t *> PyMem_Malloc(lnz * sizeof(FLOAT64_t))
        if not Lz:
            PyMem_Free(Lp)
            PyMem_Free(Lj)

            PyMem_Free(Lx)

            raise MemoryError()


        # U CSC matrix
        cdef INT32_t * Up = <INT32_t *> PyMem_Malloc((n_col + 1) * sizeof(INT32_t))
        if not Up:
            PyMem_Free(Lp)
            PyMem_Free(Lj)

            PyMem_Free(Lx)

            PyMem_Free(Lz)

            raise MemoryError()

        cdef INT32_t * Ui = <INT32_t *> PyMem_Malloc(unz * sizeof(INT32_t))
        if not Ui:
            PyMem_Free(Lp)
            PyMem_Free(Lj)

            PyMem_Free(Lx)

            PyMem_Free(Lz)

            PyMem_Free(Up)

            raise MemoryError()


        cdef FLOAT64_t * Ux = <FLOAT64_t *> PyMem_Malloc(unz * sizeof(FLOAT64_t))
        if not Ux:
            PyMem_Free(Lp)
            PyMem_Free(Lj)

            PyMem_Free(Lx)
            PyMem_Free(Lz)

            PyMem_Free(Ui)

            raise MemoryError()

        cdef FLOAT64_t * Uz = <FLOAT64_t *> PyMem_Malloc(unz * sizeof(FLOAT64_t))
        if not Uz:
            PyMem_Free(Lp)
            PyMem_Free(Lj)

            PyMem_Free(Lx)
            PyMem_Free(Lz)

            PyMem_Free(Ui)
            PyMem_Free(Ux)

            raise MemoryError()


        # TODO: see what type of int exactly to pass
        cdef cnp.npy_intp *dims_n_row = [n_row]
        cdef cnp.npy_intp *dims_n_col = [n_col]

        cdef cnp.npy_intp *dims_min = [min(n_row, n_col)]

        cdef INT32_t dim_D = min(n_row, n_col)

        #cdef cnp.ndarray[cnp.int_t, ndim=1, mode='c'] P
        #cdef cnp.ndarray[int, ndim=1, mode='c'] P
        cdef cnp.ndarray[cnp.npy_int32, ndim=1, mode='c'] P


        #P = cnp.PyArray_EMPTY(1, dims_n_row, cnp.NPY_INT32, 0)
        P = cnp.PyArray_EMPTY(1, dims_n_row, cnp.NPY_INT32, 0)


        #cdef cnp.ndarray[cnp.int_t, ndim=1, mode='c'] Q
        #cdef cnp.ndarray[int, ndim=1, mode='c'] Q
        cdef cnp.ndarray[cnp.npy_int32, ndim=1, mode='c'] Q

        #Q = cnp.PyArray_EMPTY(1, dims_n_col, cnp.NPY_INT32, 0)
        Q = cnp.PyArray_EMPTY(1, dims_n_col, cnp.NPY_INT32, 0)


        cdef cnp.ndarray[cnp.double_t, ndim=1, mode='c'] D
        D = cnp.PyArray_EMPTY(1, dims_min, cnp.NPY_DOUBLE, 0)


        # create Dx and Dz
        cdef:
            FLOAT64_t * Dx
            FLOAT64_t * Dz

        Dx = <FLOAT64_t *> PyMem_Malloc(dim_D * sizeof(FLOAT64_t))
        if not Dx:
            PyMem_Free(Lp)
            PyMem_Free(Lj)

            PyMem_Free(Lx)
            PyMem_Free(Lz)

            PyMem_Free(Ui)
            PyMem_Free(Ux)

            raise MemoryError()

        Dz = <FLOAT64_t *> PyMem_Malloc(dim_D * sizeof(FLOAT64_t))

        if not Dz:
            PyMem_Free(Lp)
            PyMem_Free(Lj)

            PyMem_Free(Lx)
            PyMem_Free(Lz)

            PyMem_Free(Ui)
            PyMem_Free(Ux)

            PyMem_Free(Dx)
            raise MemoryError()


        cdef cnp.ndarray[cnp.double_t, ndim=1, mode='c'] R
        R = cnp.PyArray_EMPTY(1, dims_n_row, cnp.NPY_DOUBLE, 0)


        cdef int status =umfpack_zi_get_numeric(Lp, Lj, Lx, Lz,
                               Up, Ui, Ux,Uz,
                               <INT32_t *> cnp.PyArray_DATA(P), <INT32_t *> cnp.PyArray_DATA(Q), Dx, Dz,
                               &_do_recip, <double *> cnp.PyArray_DATA(R),
                               self.numeric)



        if status != UMFPACK_OK:
            test_umfpack_result(status, "get_LU()")

        cdef bint do_recip = _do_recip

        cdef CSRSparseMatrix_INT32_t_COMPLEX128_t L
        cdef CSCSparseMatrix_INT32_t_COMPLEX128_t U

        cdef INT32_t size = min(n_row,n_col)


        cdef COMPLEX128_t * Lx_complex = <COMPLEX128_t *> PyMem_Malloc(lnz * sizeof(COMPLEX128_t))
        if not Lx_complex:
            PyMem_Free(Lp)
            PyMem_Free(Lj)

            PyMem_Free(Lx)
            PyMem_Free(Lz)

            PyMem_Free(Ui)
            PyMem_Free(Ux)

            PyMem_Free(Dx)
            PyMem_Free(Dz)

            raise MemoryError()

        join_array_complex_values_kernel_INT32_t_COMPLEX128_t(Lx, lnz,
                                                        Lz, lnz,
                                                        Lx_complex, lnz)

        cdef COMPLEX128_t * Ux_complex = <COMPLEX128_t *> PyMem_Malloc(unz * sizeof(COMPLEX128_t))
        if not Ux_complex:
            PyMem_Free(Lp)
            PyMem_Free(Lj)

            PyMem_Free(Lx)
            PyMem_Free(Lz)

            PyMem_Free(Ui)
            PyMem_Free(Ux)

            PyMem_Free(Dx)
            PyMem_Free(Dz)

            PyMem_Free(Lx_complex)
            
            raise MemoryError()

        join_array_complex_values_kernel_INT32_t_COMPLEX128_t(Ux, unz,
                                                        Uz, unz,
                                                        Ux_complex, unz)

        L = MakeCSRSparseMatrix_INT32_t_COMPLEX128_t(nrow=size, ncol=size, nnz=lnz, ind=Lp, col=Lj, val=Lx_complex, is_symmetric=False, store_zeros=False)
        U = MakeCSCSparseMatrix_INT32_t_COMPLEX128_t(nrow=size, ncol=size, nnz=unz, ind=Up, row=Ui, val=Ux_complex, is_symmetric=False, store_zeros=False)

        return (L, U, P, Q, D, do_recip, R)

    ####################################################################################################################
    # REPORTING ROUTINES
    ####################################################################################################################
    def set_verbosity(self, level):
        """
        Set UMFPACK verbosity level.

        Args:
            level (int): Verbosity level (default: 1).


        
        
        """
        self.control[UMFPACK_PRL] = level

    def get_verbosity(self):
        """
        Return UMFPACK verbosity level.

        Returns:
            verbosity_level (int): The verbosity level set.

        
        
        """
        return self.control[UMFPACK_PRL]

    def report_control(self):
        """
        Print control values.

        
        
        """
        umfpack_zi_report_control(self.control)


    def report_info(self):
        """
        Print all status information.

        Use **after** calling :meth:`create_symbolic()`, :meth:`create_numeric()`, :meth:`factorize()` or :meth:`solve()`.

        
        
        """
        umfpack_zi_report_info(self.control, self.info)


    def report_symbolic(self):
        """
        Print information about the opaque ``symbolic`` object.

        
        
        """
        if not self.symbolic_computed:
            print "No opaque symbolic object has been computed"
            return

        umfpack_zi_report_symbolic(self.symbolic, self.control)


    def report_numeric(self):
        """
        Print information about the opaque ``numeric`` object.

        
        
        """
        umfpack_zi_report_numeric(self.numeric, self.control)
