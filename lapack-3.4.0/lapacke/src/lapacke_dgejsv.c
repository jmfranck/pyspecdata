/*****************************************************************************
  Copyright (c) 2011, Intel Corp.
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Intel Corporation nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
  THE POSSIBILITY OF SUCH DAMAGE.
*****************************************************************************
* Contents: Native high-level C interface to LAPACK function dgejsv
* Author: Intel Corporation
* Generated November, 2011
*****************************************************************************/

#include "lapacke.h"
#include "lapacke_utils.h"

lapack_int LAPACKE_dgejsv( int matrix_order, char joba, char jobu, char jobv,
                           char jobr, char jobt, char jobp, lapack_int m,
                           lapack_int n, double* a, lapack_int lda, double* sva,
                           double* u, lapack_int ldu, double* v, lapack_int ldv,
                           double* stat, lapack_int* istat )
{
    lapack_int info = 0;
    lapack_int lwork = (!( LAPACKE_lsame( jobu, 'u' ) ||
                       LAPACKE_lsame( jobu, 'f' ) ||
                       LAPACKE_lsame( jobv, 'v' ) ||
                       LAPACKE_lsame( jobv, 'j' ) ||
                       LAPACKE_lsame( joba, 'e' ) ||
                       LAPACKE_lsame( joba, 'g' ) ) ? MAX3(7,4*n+1,2*m+n) :
                       ( (!( LAPACKE_lsame( jobu, 'u' ) ||
                       LAPACKE_lsame( jobu, 'f' ) ||
                       LAPACKE_lsame( jobv, 'v' ) ||
                       LAPACKE_lsame( jobv, 'j' ) ) &&
                       ( LAPACKE_lsame( joba, 'e' ) ||
                       LAPACKE_lsame( joba, 'g' ) ) ) ? MAX3(7,4*n+n*n,2*m+n) :
                       ( ( LAPACKE_lsame( jobu, 'u' ) ||
                       LAPACKE_lsame( jobu, 'f' ) ) &&
                       (!( LAPACKE_lsame( jobv, 'v' ) ||
                       LAPACKE_lsame( jobv, 'j' ) ) ) ? MAX(7,2*n+m) :
                       ( ( LAPACKE_lsame( jobv, 'v' ) ||
                       LAPACKE_lsame( jobv, 'j' ) ) &&
                       (!( LAPACKE_lsame( jobu, 'u' ) ||
                       LAPACKE_lsame( jobu, 'f' ) ) ) ? MAX(7,2*n+m) :
                       ( ( LAPACKE_lsame( jobu, 'u' ) ||
                       LAPACKE_lsame( jobu, 'f' ) ) &&
                       ( LAPACKE_lsame( jobv, 'v' ) ||
                       LAPACKE_lsame( jobv, 'j' ) ) &&
                       !LAPACKE_lsame( jobv, 'j' ) ? MAX(1,6*n+2*n*n) :
                       ( ( LAPACKE_lsame( jobu, 'u' ) ||
                       LAPACKE_lsame( jobu, 'f' ) ) &&
                       ( LAPACKE_lsame( jobv, 'v' ) ||
                       LAPACKE_lsame( jobv, 'j' ) ) &&
                       LAPACKE_lsame( jobv, 'j' ) ? MAX(7,m+3*n+n*n) :
                       1) ) ) ) ) );
    lapack_int* iwork = NULL;
    double* work = NULL;
    lapack_int i;
    if( matrix_order != LAPACK_COL_MAJOR && matrix_order != LAPACK_ROW_MAJOR ) {
        LAPACKE_xerbla( "LAPACKE_dgejsv", -1 );
        return -1;
    }
#ifndef LAPACK_DISABLE_NAN_CHECK
    /* Optionally check input matrices for NaNs */
    lapack_int nu = LAPACKE_lsame( jobu, 'n' ) ? 1 : m;
    lapack_int nv = LAPACKE_lsame( jobv, 'n' ) ? 1 : n;
    if( LAPACKE_dge_nancheck( matrix_order, m, n, a, lda ) ) {
        return -10;
    }
    if( LAPACKE_lsame( jobu, 'f' ) || LAPACKE_lsame( jobu, 'u' ) ||
        LAPACKE_lsame( jobu, 'w' ) ) {
        if( LAPACKE_dge_nancheck( matrix_order, nu, n, u, ldu ) ) {
            return -13;
        }
    }
    if( LAPACKE_lsame( jobv, 'j' ) || LAPACKE_lsame( jobv, 'v' ) ||
        LAPACKE_lsame( jobv, 'w' ) ) {
        if( LAPACKE_dge_nancheck( matrix_order, nv, n, v, ldv ) ) {
            return -15;
        }
    }
#endif
    /* Allocate memory for working array(s) */
    iwork = (lapack_int*)LAPACKE_malloc( sizeof(lapack_int) * MAX(1,m+3*n) );
    if( iwork == NULL ) {
        info = LAPACK_WORK_MEMORY_ERROR;
        goto exit_level_0;
    }
    work = (double*)LAPACKE_malloc( sizeof(double) * lwork );
    if( work == NULL ) {
        info = LAPACK_WORK_MEMORY_ERROR;
        goto exit_level_1;
    }
    /* Call middle-level interface */
    info = LAPACKE_dgejsv_work( matrix_order, joba, jobu, jobv, jobr, jobt,
                                jobp, m, n, a, lda, sva, u, ldu, v, ldv, work,
                                lwork, iwork );
    /* Backup significant data from working array(s) */
    for( i=0; i<7; i++ ) {
        stat[i] = work[i];
    }
    for( i=0; i<3; i++ ) {
        istat[i] = iwork[i];
    }
    /* Release memory and exit */
    LAPACKE_free( work );
exit_level_1:
    LAPACKE_free( iwork );
exit_level_0:
    if( info == LAPACK_WORK_MEMORY_ERROR ) {
        LAPACKE_xerbla( "LAPACKE_dgejsv", info );
    }
    return info;
}
