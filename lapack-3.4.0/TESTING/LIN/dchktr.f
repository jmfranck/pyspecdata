*> \brief \b DCHKTR
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at 
*            http://www.netlib.org/lapack/explore-html/ 
*
*  Definition:
*  ===========
*
*       SUBROUTINE DCHKTR( DOTYPE, NN, NVAL, NNB, NBVAL, NNS, NSVAL,
*                          THRESH, TSTERR, NMAX, A, AINV, B, X, XACT,
*                          WORK, RWORK, IWORK, NOUT )
* 
*       .. Scalar Arguments ..
*       LOGICAL            TSTERR
*       INTEGER            NMAX, NN, NNB, NNS, NOUT
*       DOUBLE PRECISION   THRESH
*       ..
*       .. Array Arguments ..
*       LOGICAL            DOTYPE( * )
*       INTEGER            IWORK( * ), NBVAL( * ), NSVAL( * ), NVAL( * )
*       DOUBLE PRECISION   A( * ), AINV( * ), B( * ), RWORK( * ),
*      $                   WORK( * ), X( * ), XACT( * )
*       ..
*  
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> DCHKTR tests DTRTRI, -TRS, -RFS, and -CON, and DLATRS
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] DOTYPE
*> \verbatim
*>          DOTYPE is LOGICAL array, dimension (NTYPES)
*>          The matrix types to be used for testing.  Matrices of type j
*>          (for 1 <= j <= NTYPES) are used for testing if DOTYPE(j) =
*>          .TRUE.; if DOTYPE(j) = .FALSE., then type j is not used.
*> \endverbatim
*>
*> \param[in] NN
*> \verbatim
*>          NN is INTEGER
*>          The number of values of N contained in the vector NVAL.
*> \endverbatim
*>
*> \param[in] NVAL
*> \verbatim
*>          NVAL is INTEGER array, dimension (NN)
*>          The values of the matrix column dimension N.
*> \endverbatim
*>
*> \param[in] NNB
*> \verbatim
*>          NNB is INTEGER
*>          The number of values of NB contained in the vector NBVAL.
*> \endverbatim
*>
*> \param[in] NBVAL
*> \verbatim
*>          NBVAL is INTEGER array, dimension (NNB)
*>          The values of the blocksize NB.
*> \endverbatim
*>
*> \param[in] NNS
*> \verbatim
*>          NNS is INTEGER
*>          The number of values of NRHS contained in the vector NSVAL.
*> \endverbatim
*>
*> \param[in] NSVAL
*> \verbatim
*>          NSVAL is INTEGER array, dimension (NNS)
*>          The values of the number of right hand sides NRHS.
*> \endverbatim
*>
*> \param[in] THRESH
*> \verbatim
*>          THRESH is DOUBLE PRECISION
*>          The threshold value for the test ratios.  A result is
*>          included in the output file if RESULT >= THRESH.  To have
*>          every test ratio printed, use THRESH = 0.
*> \endverbatim
*>
*> \param[in] TSTERR
*> \verbatim
*>          TSTERR is LOGICAL
*>          Flag that indicates whether error exits are to be tested.
*> \endverbatim
*>
*> \param[in] NMAX
*> \verbatim
*>          NMAX is INTEGER
*>          The leading dimension of the work arrays.
*>          NMAX >= the maximum value of N in NVAL.
*> \endverbatim
*>
*> \param[out] A
*> \verbatim
*>          A is DOUBLE PRECISION array, dimension (NMAX*NMAX)
*> \endverbatim
*>
*> \param[out] AINV
*> \verbatim
*>          AINV is DOUBLE PRECISION array, dimension (NMAX*NMAX)
*> \endverbatim
*>
*> \param[out] B
*> \verbatim
*>          B is DOUBLE PRECISION array, dimension (NMAX*NSMAX)
*>          where NSMAX is the largest entry in NSVAL.
*> \endverbatim
*>
*> \param[out] X
*> \verbatim
*>          X is DOUBLE PRECISION array, dimension (NMAX*NSMAX)
*> \endverbatim
*>
*> \param[out] XACT
*> \verbatim
*>          XACT is DOUBLE PRECISION array, dimension (NMAX*NSMAX)
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is DOUBLE PRECISION array, dimension
*>                      (NMAX*max(3,NSMAX))
*> \endverbatim
*>
*> \param[out] RWORK
*> \verbatim
*>          RWORK is DOUBLE PRECISION array, dimension
*>                      (max(NMAX,2*NSMAX))
*> \endverbatim
*>
*> \param[out] IWORK
*> \verbatim
*>          IWORK is INTEGER array, dimension (NMAX)
*> \endverbatim
*>
*> \param[in] NOUT
*> \verbatim
*>          NOUT is INTEGER
*>          The unit number for output.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee 
*> \author Univ. of California Berkeley 
*> \author Univ. of Colorado Denver 
*> \author NAG Ltd. 
*
*> \date November 2011
*
*> \ingroup double_lin
*
*  =====================================================================
      SUBROUTINE DCHKTR( DOTYPE, NN, NVAL, NNB, NBVAL, NNS, NSVAL,
     $                   THRESH, TSTERR, NMAX, A, AINV, B, X, XACT,
     $                   WORK, RWORK, IWORK, NOUT )
*
*  -- LAPACK test routine (version 3.4.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     November 2011
*
*     .. Scalar Arguments ..
      LOGICAL            TSTERR
      INTEGER            NMAX, NN, NNB, NNS, NOUT
      DOUBLE PRECISION   THRESH
*     ..
*     .. Array Arguments ..
      LOGICAL            DOTYPE( * )
      INTEGER            IWORK( * ), NBVAL( * ), NSVAL( * ), NVAL( * )
      DOUBLE PRECISION   A( * ), AINV( * ), B( * ), RWORK( * ),
     $                   WORK( * ), X( * ), XACT( * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      INTEGER            NTYPE1, NTYPES
      PARAMETER          ( NTYPE1 = 10, NTYPES = 18 )
      INTEGER            NTESTS
      PARAMETER          ( NTESTS = 9 )
      INTEGER            NTRAN
      PARAMETER          ( NTRAN = 3 )
      DOUBLE PRECISION   ONE, ZERO
      PARAMETER          ( ONE = 1.0D0, ZERO = 0.0D0 )
*     ..
*     .. Local Scalars ..
      CHARACTER          DIAG, NORM, TRANS, UPLO, XTYPE
      CHARACTER*3        PATH
      INTEGER            I, IDIAG, IMAT, IN, INB, INFO, IRHS, ITRAN,
     $                   IUPLO, K, LDA, N, NB, NERRS, NFAIL, NRHS, NRUN
      DOUBLE PRECISION   AINVNM, ANORM, DUMMY, RCOND, RCONDC, RCONDI,
     $                   RCONDO, SCALE
*     ..
*     .. Local Arrays ..
      CHARACTER          TRANSS( NTRAN ), UPLOS( 2 )
      INTEGER            ISEED( 4 ), ISEEDY( 4 )
      DOUBLE PRECISION   RESULT( NTESTS )
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      DOUBLE PRECISION   DLANTR
      EXTERNAL           LSAME, DLANTR
*     ..
*     .. External Subroutines ..
      EXTERNAL           ALAERH, ALAHD, ALASUM, DCOPY, DERRTR, DGET04,
     $                   DLACPY, DLARHS, DLATRS, DLATTR, DTRCON, DTRRFS,
     $                   DTRT01, DTRT02, DTRT03, DTRT05, DTRT06, DTRTRI,
     $                   DTRTRS, XLAENV
*     ..
*     .. Scalars in Common ..
      LOGICAL            LERR, OK
      CHARACTER*32       SRNAMT
      INTEGER            INFOT, IOUNIT
*     ..
*     .. Common blocks ..
      COMMON             / INFOC / INFOT, IOUNIT, OK, LERR
      COMMON             / SRNAMC / SRNAMT
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MAX
*     ..
*     .. Data statements ..
      DATA               ISEEDY / 1988, 1989, 1990, 1991 /
      DATA               UPLOS / 'U', 'L' / , TRANSS / 'N', 'T', 'C' /
*     ..
*     .. Executable Statements ..
*
*     Initialize constants and the random number seed.
*
      PATH( 1: 1 ) = 'Double precision'
      PATH( 2: 3 ) = 'TR'
      NRUN = 0
      NFAIL = 0
      NERRS = 0
      DO 10 I = 1, 4
         ISEED( I ) = ISEEDY( I )
   10 CONTINUE
*
*     Test the error exits
*
      IF( TSTERR )
     $   CALL DERRTR( PATH, NOUT )
      INFOT = 0
      CALL XLAENV( 2, 2 )
*
      DO 120 IN = 1, NN
*
*        Do for each value of N in NVAL
*
         N = NVAL( IN )
         LDA = MAX( 1, N )
         XTYPE = 'N'
*
         DO 80 IMAT = 1, NTYPE1
*
*           Do the tests only if DOTYPE( IMAT ) is true.
*
            IF( .NOT.DOTYPE( IMAT ) )
     $         GO TO 80
*
            DO 70 IUPLO = 1, 2
*
*              Do first for UPLO = 'U', then for UPLO = 'L'
*
               UPLO = UPLOS( IUPLO )
*
*              Call DLATTR to generate a triangular test matrix.
*
               SRNAMT = 'DLATTR'
               CALL DLATTR( IMAT, UPLO, 'No transpose', DIAG, ISEED, N,
     $                      A, LDA, X, WORK, INFO )
*
*              Set IDIAG = 1 for non-unit matrices, 2 for unit.
*
               IF( LSAME( DIAG, 'N' ) ) THEN
                  IDIAG = 1
               ELSE
                  IDIAG = 2
               END IF
*
               DO 60 INB = 1, NNB
*
*                 Do for each blocksize in NBVAL
*
                  NB = NBVAL( INB )
                  CALL XLAENV( 1, NB )
*
*+    TEST 1
*                 Form the inverse of A.
*
                  CALL DLACPY( UPLO, N, N, A, LDA, AINV, LDA )
                  SRNAMT = 'DTRTRI'
                  CALL DTRTRI( UPLO, DIAG, N, AINV, LDA, INFO )
*
*                 Check error code from DTRTRI.
*
                  IF( INFO.NE.0 )
     $               CALL ALAERH( PATH, 'DTRTRI', INFO, 0, UPLO // DIAG,
     $                            N, N, -1, -1, NB, IMAT, NFAIL, NERRS,
     $                            NOUT )
*
*                 Compute the infinity-norm condition number of A.
*
                  ANORM = DLANTR( 'I', UPLO, DIAG, N, N, A, LDA, RWORK )
                  AINVNM = DLANTR( 'I', UPLO, DIAG, N, N, AINV, LDA,
     $                     RWORK )
                  IF( ANORM.LE.ZERO .OR. AINVNM.LE.ZERO ) THEN
                     RCONDI = ONE
                  ELSE
                     RCONDI = ( ONE / ANORM ) / AINVNM
                  END IF
*
*                 Compute the residual for the triangular matrix times
*                 its inverse.  Also compute the 1-norm condition number
*                 of A.
*
                  CALL DTRT01( UPLO, DIAG, N, A, LDA, AINV, LDA, RCONDO,
     $                         RWORK, RESULT( 1 ) )
*
*                 Print the test ratio if it is .GE. THRESH.
*
                  IF( RESULT( 1 ).GE.THRESH ) THEN
                     IF( NFAIL.EQ.0 .AND. NERRS.EQ.0 )
     $                  CALL ALAHD( NOUT, PATH )
                     WRITE( NOUT, FMT = 9999 )UPLO, DIAG, N, NB, IMAT,
     $                  1, RESULT( 1 )
                     NFAIL = NFAIL + 1
                  END IF
                  NRUN = NRUN + 1
*
*                 Skip remaining tests if not the first block size.
*
                  IF( INB.NE.1 )
     $               GO TO 60
*
                  DO 40 IRHS = 1, NNS
                     NRHS = NSVAL( IRHS )
                     XTYPE = 'N'
*
                     DO 30 ITRAN = 1, NTRAN
*
*                    Do for op(A) = A, A**T, or A**H.
*
                        TRANS = TRANSS( ITRAN )
                        IF( ITRAN.EQ.1 ) THEN
                           NORM = 'O'
                           RCONDC = RCONDO
                        ELSE
                           NORM = 'I'
                           RCONDC = RCONDI
                        END IF
*
*+    TEST 2
*                       Solve and compute residual for op(A)*x = b.
*
                        SRNAMT = 'DLARHS'
                        CALL DLARHS( PATH, XTYPE, UPLO, TRANS, N, N, 0,
     $                               IDIAG, NRHS, A, LDA, XACT, LDA, B,
     $                               LDA, ISEED, INFO )
                        XTYPE = 'C'
                        CALL DLACPY( 'Full', N, NRHS, B, LDA, X, LDA )
*
                        SRNAMT = 'DTRTRS'
                        CALL DTRTRS( UPLO, TRANS, DIAG, N, NRHS, A, LDA,
     $                               X, LDA, INFO )
*
*                       Check error code from DTRTRS.
*
                        IF( INFO.NE.0 )
     $                     CALL ALAERH( PATH, 'DTRTRS', INFO, 0,
     $                                  UPLO // TRANS // DIAG, N, N, -1,
     $                                  -1, NRHS, IMAT, NFAIL, NERRS,
     $                                  NOUT )
*
*                       This line is needed on a Sun SPARCstation.
*
                        IF( N.GT.0 )
     $                     DUMMY = A( 1 )
*
                        CALL DTRT02( UPLO, TRANS, DIAG, N, NRHS, A, LDA,
     $                               X, LDA, B, LDA, WORK, RESULT( 2 ) )
*
*+    TEST 3
*                       Check solution from generated exact solution.
*
                        CALL DGET04( N, NRHS, X, LDA, XACT, LDA, RCONDC,
     $                               RESULT( 3 ) )
*
*+    TESTS 4, 5, and 6
*                       Use iterative refinement to improve the solution
*                       and compute error bounds.
*
                        SRNAMT = 'DTRRFS'
                        CALL DTRRFS( UPLO, TRANS, DIAG, N, NRHS, A, LDA,
     $                               B, LDA, X, LDA, RWORK,
     $                               RWORK( NRHS+1 ), WORK, IWORK,
     $                               INFO )
*
*                       Check error code from DTRRFS.
*
                        IF( INFO.NE.0 )
     $                     CALL ALAERH( PATH, 'DTRRFS', INFO, 0,
     $                                  UPLO // TRANS // DIAG, N, N, -1,
     $                                  -1, NRHS, IMAT, NFAIL, NERRS,
     $                                  NOUT )
*
                        CALL DGET04( N, NRHS, X, LDA, XACT, LDA, RCONDC,
     $                               RESULT( 4 ) )
                        CALL DTRT05( UPLO, TRANS, DIAG, N, NRHS, A, LDA,
     $                               B, LDA, X, LDA, XACT, LDA, RWORK,
     $                               RWORK( NRHS+1 ), RESULT( 5 ) )
*
*                       Print information about the tests that did not
*                       pass the threshold.
*
                        DO 20 K = 2, 6
                           IF( RESULT( K ).GE.THRESH ) THEN
                              IF( NFAIL.EQ.0 .AND. NERRS.EQ.0 )
     $                           CALL ALAHD( NOUT, PATH )
                              WRITE( NOUT, FMT = 9998 )UPLO, TRANS,
     $                           DIAG, N, NRHS, IMAT, K, RESULT( K )
                              NFAIL = NFAIL + 1
                           END IF
   20                   CONTINUE
                        NRUN = NRUN + 5
   30                CONTINUE
   40             CONTINUE
*
*+    TEST 7
*                       Get an estimate of RCOND = 1/CNDNUM.
*
                  DO 50 ITRAN = 1, 2
                     IF( ITRAN.EQ.1 ) THEN
                        NORM = 'O'
                        RCONDC = RCONDO
                     ELSE
                        NORM = 'I'
                        RCONDC = RCONDI
                     END IF
                     SRNAMT = 'DTRCON'
                     CALL DTRCON( NORM, UPLO, DIAG, N, A, LDA, RCOND,
     $                            WORK, IWORK, INFO )
*
*                       Check error code from DTRCON.
*
                     IF( INFO.NE.0 )
     $                  CALL ALAERH( PATH, 'DTRCON', INFO, 0,
     $                               NORM // UPLO // DIAG, N, N, -1, -1,
     $                               -1, IMAT, NFAIL, NERRS, NOUT )
*
                     CALL DTRT06( RCOND, RCONDC, UPLO, DIAG, N, A, LDA,
     $                            RWORK, RESULT( 7 ) )
*
*                    Print the test ratio if it is .GE. THRESH.
*
                     IF( RESULT( 7 ).GE.THRESH ) THEN
                        IF( NFAIL.EQ.0 .AND. NERRS.EQ.0 )
     $                     CALL ALAHD( NOUT, PATH )
                        WRITE( NOUT, FMT = 9997 )NORM, UPLO, N, IMAT,
     $                     7, RESULT( 7 )
                        NFAIL = NFAIL + 1
                     END IF
                     NRUN = NRUN + 1
   50             CONTINUE
   60          CONTINUE
   70       CONTINUE
   80    CONTINUE
*
*        Use pathological test matrices to test DLATRS.
*
         DO 110 IMAT = NTYPE1 + 1, NTYPES
*
*           Do the tests only if DOTYPE( IMAT ) is true.
*
            IF( .NOT.DOTYPE( IMAT ) )
     $         GO TO 110
*
            DO 100 IUPLO = 1, 2
*
*              Do first for UPLO = 'U', then for UPLO = 'L'
*
               UPLO = UPLOS( IUPLO )
               DO 90 ITRAN = 1, NTRAN
*
*                 Do for op(A) = A, A**T, and A**H.
*
                  TRANS = TRANSS( ITRAN )
*
*                 Call DLATTR to generate a triangular test matrix.
*
                  SRNAMT = 'DLATTR'
                  CALL DLATTR( IMAT, UPLO, TRANS, DIAG, ISEED, N, A,
     $                         LDA, X, WORK, INFO )
*
*+    TEST 8
*                 Solve the system op(A)*x = b.
*
                  SRNAMT = 'DLATRS'
                  CALL DCOPY( N, X, 1, B, 1 )
                  CALL DLATRS( UPLO, TRANS, DIAG, 'N', N, A, LDA, B,
     $                         SCALE, RWORK, INFO )
*
*                 Check error code from DLATRS.
*
                  IF( INFO.NE.0 )
     $               CALL ALAERH( PATH, 'DLATRS', INFO, 0,
     $                            UPLO // TRANS // DIAG // 'N', N, N,
     $                            -1, -1, -1, IMAT, NFAIL, NERRS, NOUT )
*
                  CALL DTRT03( UPLO, TRANS, DIAG, N, 1, A, LDA, SCALE,
     $                         RWORK, ONE, B, LDA, X, LDA, WORK,
     $                         RESULT( 8 ) )
*
*+    TEST 9
*                 Solve op(A)*X = b again with NORMIN = 'Y'.
*
                  CALL DCOPY( N, X, 1, B( N+1 ), 1 )
                  CALL DLATRS( UPLO, TRANS, DIAG, 'Y', N, A, LDA,
     $                         B( N+1 ), SCALE, RWORK, INFO )
*
*                 Check error code from DLATRS.
*
                  IF( INFO.NE.0 )
     $               CALL ALAERH( PATH, 'DLATRS', INFO, 0,
     $                            UPLO // TRANS // DIAG // 'Y', N, N,
     $                            -1, -1, -1, IMAT, NFAIL, NERRS, NOUT )
*
                  CALL DTRT03( UPLO, TRANS, DIAG, N, 1, A, LDA, SCALE,
     $                         RWORK, ONE, B( N+1 ), LDA, X, LDA, WORK,
     $                         RESULT( 9 ) )
*
*                 Print information about the tests that did not pass
*                 the threshold.
*
                  IF( RESULT( 8 ).GE.THRESH ) THEN
                     IF( NFAIL.EQ.0 .AND. NERRS.EQ.0 )
     $                  CALL ALAHD( NOUT, PATH )
                     WRITE( NOUT, FMT = 9996 )'DLATRS', UPLO, TRANS,
     $                  DIAG, 'N', N, IMAT, 8, RESULT( 8 )
                     NFAIL = NFAIL + 1
                  END IF
                  IF( RESULT( 9 ).GE.THRESH ) THEN
                     IF( NFAIL.EQ.0 .AND. NERRS.EQ.0 )
     $                  CALL ALAHD( NOUT, PATH )
                     WRITE( NOUT, FMT = 9996 )'DLATRS', UPLO, TRANS,
     $                  DIAG, 'Y', N, IMAT, 9, RESULT( 9 )
                     NFAIL = NFAIL + 1
                  END IF
                  NRUN = NRUN + 2
   90          CONTINUE
  100       CONTINUE
  110    CONTINUE
  120 CONTINUE
*
*     Print a summary of the results.
*
      CALL ALASUM( PATH, NOUT, NFAIL, NRUN, NERRS )
*
 9999 FORMAT( ' UPLO=''', A1, ''', DIAG=''', A1, ''', N=', I5, ', NB=',
     $      I4, ', type ', I2, ', test(', I2, ')= ', G12.5 )
 9998 FORMAT( ' UPLO=''', A1, ''', TRANS=''', A1, ''', DIAG=''', A1,
     $      ''', N=', I5, ', NB=', I4, ', type ', I2, ',
     $      test(', I2, ')= ', G12.5 )
 9997 FORMAT( ' NORM=''', A1, ''', UPLO =''', A1, ''', N=', I5, ',',
     $      11X, ' type ', I2, ', test(', I2, ')=', G12.5 )
 9996 FORMAT( 1X, A, '( ''', A1, ''', ''', A1, ''', ''', A1, ''', ''',
     $      A1, ''',', I5, ', ... ), type ', I2, ', test(', I2, ')=',
     $      G12.5 )
      RETURN
*
*     End of DCHKTR
*
      END
