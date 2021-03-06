#!/usr/bin/env python

"""
This file tests UMFPACK ``get_LU`` for all :program:`CySparse` matrices objects.

We verify the equality ``L * U = P * R * A * Q``.

"""

import unittest
from cysparse.sparse.ll_mat import *

from suitesparse.umfpack.umfpack_solver import UmfpackSolver


########################################################################################################################
# Tests
########################################################################################################################


SIZE = 10
EPS = 1e-12

#######################################################################
# Case: store_symmetry == False, Store_zero==False
#######################################################################
class CySparseUmfpackget_LUNoSymmetryNoZero_CSRSparseMatrix_INT64_t_COMPLEX128_t_TestCase(unittest.TestCase):
    def setUp(self):
       

        self.A = LinearFillLLSparseMatrix(size=SIZE, dtype=COMPLEX128_T, itype=INT64_T)


        self.C = self.A.to_csr()



        self.solver = UmfpackSolver(self.C)

    def test_factorization_element_by_element(self):
        """
        Verify the equality ``L * U = P * R * A * Q``
        """
        (L, U, P, Q, D, do_recip, R) = self.solver.get_LU()

        lhs = L * U

        P_mat = PermutationLLSparseMatrix(P=P, size=SIZE, dtype=COMPLEX128_T, itype=INT64_T)
        Q_mat = PermutationLLSparseMatrix(P=Q, size=SIZE, dtype=COMPLEX128_T, itype=INT64_T)

        R_mat = None
        if do_recip:
            R_mat = LLSparseMatrix(size=SIZE, dtype=COMPLEX128_T, itype=INT64_T)
            for i in xrange(SIZE):
                R_mat[i, i] = R[i]
        else:
            R_mat = LLSparseMatrix(size=size, dtype=COMPLEX128_T, itype=INT64_T)
            for i in xrange(SIZE):
                R_mat[i, i] = 1/R[i]

        rhs = P_mat * R_mat * self.C * Q_mat

        for i in xrange(SIZE):
            for j in xrange(SIZE):

                self.assertTrue(abs(lhs[i, j] - rhs[i, j]) < EPS, "lhs[%d, %d] =? %f + %f j , rhs[%d, %d] = %f + %f j" % (i,j, lhs[i, j].real, lhs[i, j].imag, i, j, rhs[i, j].real, rhs[i, j].imag))


#######################################################################
# Case: store_symmetry == True, Store_zero==False
#######################################################################
class CySparseUmfpackget_LUWithSymmetryNoZero_CSRSparseMatrix_INT64_t_COMPLEX128_t_TestCase(unittest.TestCase):
    def setUp(self):

        self.size = SIZE

        self.A = LinearFillLLSparseMatrix(size=self.size, dtype=COMPLEX128_T, itype=INT64_T, store_symmetry=True)


        self.C = self.A.to_csr()



        self.solver = UmfpackSolver(self.C)

    def test_factorization_element_by_element(self):
        """
        Verify the equality ``L * U = P * R * A * Q``
        """
        (L, U, P, Q, D, do_recip, R) = self.solver.get_LU()

        lhs = L * U

        P_mat = PermutationLLSparseMatrix(P=P, size=SIZE, dtype=COMPLEX128_T, itype=INT64_T)
        Q_mat = PermutationLLSparseMatrix(P=Q, size=SIZE, dtype=COMPLEX128_T, itype=INT64_T)

        R_mat = None
        if do_recip:
            R_mat = LLSparseMatrix(size=SIZE, dtype=COMPLEX128_T, itype=INT64_T)
            for i in xrange(SIZE):
                R_mat[i, i] = R[i]
        else:
            R_mat = LLSparseMatrix(size=size, dtype=COMPLEX128_T, itype=INT64_T)
            for i in xrange(SIZE):
                R_mat[i, i] = 1/R[i]

        rhs = P_mat * R_mat * self.C * Q_mat

        for i in xrange(SIZE):
            for j in xrange(SIZE):

                self.assertTrue(abs(lhs[i, j] - rhs[i, j]) < EPS, "lhs[%d, %d] =? %f + %f j , rhs[%d, %d] = %f + %f j" % (i,j, lhs[i, j].real, lhs[i, j].imag, i, j, rhs[i, j].real, rhs[i, j].imag))


#######################################################################
# Case: store_symmetry == False, Store_zero==True
#######################################################################
class CySparseUmfpackget_LUNoSymmetrySWithZero_CSRSparseMatrix_INT64_t_COMPLEX128_t_TestCase(unittest.TestCase):
    def setUp(self):

        self.A = LinearFillLLSparseMatrix(size=SIZE, dtype=COMPLEX128_T, itype=INT64_T, store_zero=True)


        self.C = self.A.to_csr()



        self.solver = UmfpackSolver(self.C)

    def test_factorization_element_by_element(self):
        """
        Verify the equality ``L * U = P * R * A * Q``
        """
        (L, U, P, Q, D, do_recip, R) = self.solver.get_LU()

        lhs = L * U

        P_mat = PermutationLLSparseMatrix(P=P, size=SIZE, dtype=COMPLEX128_T, itype=INT64_T)
        Q_mat = PermutationLLSparseMatrix(P=Q, size=SIZE, dtype=COMPLEX128_T, itype=INT64_T)

        R_mat = None
        if do_recip:
            R_mat = LLSparseMatrix(size=SIZE, dtype=COMPLEX128_T, itype=INT64_T)
            for i in xrange(SIZE):
                R_mat[i, i] = R[i]
        else:
            R_mat = LLSparseMatrix(size=size, dtype=COMPLEX128_T, itype=INT64_T)
            for i in xrange(SIZE):
                R_mat[i, i] = 1/R[i]

        rhs = P_mat * R_mat * self.C * Q_mat

        for i in xrange(SIZE):
            for j in xrange(SIZE):

                self.assertTrue(abs(lhs[i, j] - rhs[i, j]) < EPS, "lhs[%d, %d] =? %f + %f j , rhs[%d, %d] = %f + %f j" % (i,j, lhs[i, j].real, lhs[i, j].imag, i, j, rhs[i, j].real, rhs[i, j].imag))


#######################################################################
# Case: store_symmetry == True, Store_zero==True
#######################################################################
class CySparseUmfpackget_LUWithSymmetrySWithZero_CSRSparseMatrix_INT64_t_COMPLEX128_t_TestCase(unittest.TestCase):
    def setUp(self):

        self.size = SIZE

        self.A = LinearFillLLSparseMatrix(size=self.size, dtype=COMPLEX128_T, itype=INT64_T, store_symmetry=True, store_zero=True)


        self.C = self.A.to_csr()



        self.solver = UmfpackSolver(self.C)

    def test_factorization_element_by_element(self):
        """
        Verify the equality ``L * U = P * R * A * Q``
        """
        (L, U, P, Q, D, do_recip, R) = self.solver.get_LU()

        lhs = L * U

        P_mat = PermutationLLSparseMatrix(P=P, size=SIZE, dtype=COMPLEX128_T, itype=INT64_T)
        Q_mat = PermutationLLSparseMatrix(P=Q, size=SIZE, dtype=COMPLEX128_T, itype=INT64_T)

        R_mat = None
        if do_recip:
            R_mat = LLSparseMatrix(size=SIZE, dtype=COMPLEX128_T, itype=INT64_T)
            for i in xrange(SIZE):
                R_mat[i, i] = R[i]
        else:
            R_mat = LLSparseMatrix(size=size, dtype=COMPLEX128_T, itype=INT64_T)
            for i in xrange(SIZE):
                R_mat[i, i] = 1/R[i]

        rhs = P_mat * R_mat * self.C * Q_mat

        for i in xrange(SIZE):
            for j in xrange(SIZE):

                self.assertTrue(abs(lhs[i, j] - rhs[i, j]) < EPS, "lhs[%d, %d] =? %f + %f j , rhs[%d, %d] = %f + %f j" % (i,j, lhs[i, j].real, lhs[i, j].imag, i, j, rhs[i, j].real, rhs[i, j].imag))


if __name__ == '__main__':
    unittest.main()
