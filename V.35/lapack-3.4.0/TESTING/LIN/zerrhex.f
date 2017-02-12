*> \brief \b ZERRHEX
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at 
*            http://www.netlib.org/lapack/explore-html/ 
*
*  Definition:
*  ===========
*
*       SUBROUTINE ZERRHE( PATH, NUNIT )
* 
*       .. Scalar Arguments ..
*       CHARACTER*3        PATH
*       INTEGER            NUNIT
*       ..
*  
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> ZERRHE tests the error exits for the COMPLEX*16 routines
*> for Hermitian indefinite matrices.
*>
*> Note that this file is used only when the XBLAS are available,
*> otherwise zerrhe.f defines this subroutine.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] PATH
*> \verbatim
*>          PATH is CHARACTER*3
*>          The LAPACK path name for the routines to be tested.
*> \endverbatim
*>
*> \param[in] NUNIT
*> \verbatim
*>          NUNIT is INTEGER
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
*> \ingroup complex16_lin
*
*  =====================================================================
      SUBROUTINE ZERRHE( PATH, NUNIT )
*
*  -- LAPACK test routine (version 3.4.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     November 2011
*
*     .. Scalar Arguments ..
      CHARACTER*3        PATH
      INTEGER            NUNIT
*     ..
*
*  =====================================================================
*
*
*     .. Parameters ..
      INTEGER            NMAX
      PARAMETER          ( NMAX = 4 )
*     ..
*     .. Local Scalars ..
      CHARACTER          EQ
      CHARACTER*2        C2
      INTEGER            I, INFO, J, N_ERR_BNDS, NPARAMS
      DOUBLE PRECISION   ANRM, RCOND, BERR
*     ..
*     .. Local Arrays ..
      INTEGER            IP( NMAX )
      DOUBLE PRECISION   R( NMAX ), R1( NMAX ), R2( NMAX ),
     $                   S( NMAX ), ERR_BNDS_N( NMAX, 3 ),
     $                   ERR_BNDS_C( NMAX, 3 ), PARAMS( 1 )
      COMPLEX*16         A( NMAX, NMAX ), AF( NMAX, NMAX ), B( NMAX ),
     $                   W( 2*NMAX ), X( NMAX )
*     ..
*     .. External Functions ..
      LOGICAL            LSAMEN
      EXTERNAL           LSAMEN
*     ..
*     .. External Subroutines ..
      EXTERNAL           ALAESM, CHKXER, ZHECON, ZHERFS, ZHETF2, ZHETRF,
     $                   ZHETRI, ZHETRI2, ZHETRS, ZHPCON, ZHPRFS,
     $                   ZHPTRF, ZHPTRI, ZHPTRS, ZHERFSX
*     ..
*     .. Scalars in Common ..
      LOGICAL            LERR, OK
      CHARACTER*32       SRNAMT
      INTEGER            INFOT, NOUT
*     ..
*     .. Common blocks ..
      COMMON             / INFOC / INFOT, NOUT, OK, LERR
      COMMON             / SRNAMC / SRNAMT
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          DBLE, DCMPLX
*     ..
*     .. Executable Statements ..
*
      NOUT = NUNIT
      WRITE( NOUT, FMT = * )
      C2 = PATH( 2: 3 )
*
*     Set the variables to innocuous values.
*
      DO 20 J = 1, NMAX
         DO 10 I = 1, NMAX
            A( I, J ) = DCMPLX( 1.D0 / DBLE( I+J ),
     $                  -1.D0 / DBLE( I+J ) )
            AF( I, J ) = DCMPLX( 1.D0 / DBLE( I+J ),
     $                   -1.D0 / DBLE( I+J ) )
   10    CONTINUE
         B( J ) = 0.D0
         R1( J ) = 0.D0
         R2( J ) = 0.D0
         W( J ) = 0.D0
         X( J ) = 0.D0
         S( J ) = 0.D0
         IP( J ) = J
   20 CONTINUE
      ANRM = 1.0D0
      OK = .TRUE.
*
*     Test error exits of the routines that use the diagonal pivoting
*     factorization of a Hermitian indefinite matrix.
*
      IF( LSAMEN( 2, C2, 'HE' ) ) THEN
*
*        ZHETRF
*
         SRNAMT = 'ZHETRF'
         INFOT = 1
         CALL ZHETRF( '/', 0, A, 1, IP, W, 1, INFO )
         CALL CHKXER( 'ZHETRF', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL ZHETRF( 'U', -1, A, 1, IP, W, 1, INFO )
         CALL CHKXER( 'ZHETRF', INFOT, NOUT, LERR, OK )
         INFOT = 4
         CALL ZHETRF( 'U', 2, A, 1, IP, W, 4, INFO )
         CALL CHKXER( 'ZHETRF', INFOT, NOUT, LERR, OK )
*
*        ZHETF2
*
         SRNAMT = 'ZHETF2'
         INFOT = 1
         CALL ZHETF2( '/', 0, A, 1, IP, INFO )
         CALL CHKXER( 'ZHETF2', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL ZHETF2( 'U', -1, A, 1, IP, INFO )
         CALL CHKXER( 'ZHETF2', INFOT, NOUT, LERR, OK )
         INFOT = 4
         CALL ZHETF2( 'U', 2, A, 1, IP, INFO )
         CALL CHKXER( 'ZHETF2', INFOT, NOUT, LERR, OK )
*
*        ZHETRI
*
         SRNAMT = 'ZHETRI'
         INFOT = 1
         CALL ZHETRI( '/', 0, A, 1, IP, W, INFO )
         CALL CHKXER( 'ZHETRI', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL ZHETRI( 'U', -1, A, 1, IP, W, INFO )
         CALL CHKXER( 'ZHETRI', INFOT, NOUT, LERR, OK )
         INFOT = 4
         CALL ZHETRI( 'U', 2, A, 1, IP, W, INFO )
         CALL CHKXER( 'ZHETRI', INFOT, NOUT, LERR, OK )
*
*        ZHETRI2
*
         SRNAMT = 'ZHETRI2'
         INFOT = 1
         CALL ZHETRI2( '/', 0, A, 1, IP, W, 1, INFO )
         CALL CHKXER( 'ZHETRI2', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL ZHETRI2( 'U', -1, A, 1, IP, W, 1, INFO )
         CALL CHKXER( 'ZHETRI2', INFOT, NOUT, LERR, OK )
         INFOT = 4
         CALL ZHETRI2( 'U', 2, A, 1, IP, W, 1, INFO )
         CALL CHKXER( 'ZHETRI2', INFOT, NOUT, LERR, OK )
*
*        ZHETRS
*
         SRNAMT = 'ZHETRS'
         INFOT = 1
         CALL ZHETRS( '/', 0, 0, A, 1, IP, B, 1, INFO )
         CALL CHKXER( 'ZHETRS', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL ZHETRS( 'U', -1, 0, A, 1, IP, B, 1, INFO )
         CALL CHKXER( 'ZHETRS', INFOT, NOUT, LERR, OK )
         INFOT = 3
         CALL ZHETRS( 'U', 0, -1, A, 1, IP, B, 1, INFO )
         CALL CHKXER( 'ZHETRS', INFOT, NOUT, LERR, OK )
         INFOT = 5
         CALL ZHETRS( 'U', 2, 1, A, 1, IP, B, 2, INFO )
         CALL CHKXER( 'ZHETRS', INFOT, NOUT, LERR, OK )
         INFOT = 8
         CALL ZHETRS( 'U', 2, 1, A, 2, IP, B, 1, INFO )
         CALL CHKXER( 'ZHETRS', INFOT, NOUT, LERR, OK )
*
*        ZHERFS
*
         SRNAMT = 'ZHERFS'
         INFOT = 1
         CALL ZHERFS( '/', 0, 0, A, 1, AF, 1, IP, B, 1, X, 1, R1, R2, W,
     $                R, INFO )
         CALL CHKXER( 'ZHERFS', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL ZHERFS( 'U', -1, 0, A, 1, AF, 1, IP, B, 1, X, 1, R1, R2,
     $                W, R, INFO )
         CALL CHKXER( 'ZHERFS', INFOT, NOUT, LERR, OK )
         INFOT = 3
         CALL ZHERFS( 'U', 0, -1, A, 1, AF, 1, IP, B, 1, X, 1, R1, R2,
     $                W, R, INFO )
         CALL CHKXER( 'ZHERFS', INFOT, NOUT, LERR, OK )
         INFOT = 5
         CALL ZHERFS( 'U', 2, 1, A, 1, AF, 2, IP, B, 2, X, 2, R1, R2, W,
     $                R, INFO )
         CALL CHKXER( 'ZHERFS', INFOT, NOUT, LERR, OK )
         INFOT = 7
         CALL ZHERFS( 'U', 2, 1, A, 2, AF, 1, IP, B, 2, X, 2, R1, R2, W,
     $                R, INFO )
         CALL CHKXER( 'ZHERFS', INFOT, NOUT, LERR, OK )
         INFOT = 10
         CALL ZHERFS( 'U', 2, 1, A, 2, AF, 2, IP, B, 1, X, 2, R1, R2, W,
     $                R, INFO )
         CALL CHKXER( 'ZHERFS', INFOT, NOUT, LERR, OK )
         INFOT = 12
         CALL ZHERFS( 'U', 2, 1, A, 2, AF, 2, IP, B, 2, X, 1, R1, R2, W,
     $                R, INFO )
         CALL CHKXER( 'ZHERFS', INFOT, NOUT, LERR, OK )
*
*        ZHERFSX
*
         N_ERR_BNDS = 3
         NPARAMS = 0
         SRNAMT = 'ZHERFSX'
         INFOT = 1
         CALL ZHERFSX( '/', EQ, 0, 0, A, 1, AF, 1, IP, S, B, 1, X, 1,
     $        RCOND, BERR, N_ERR_BNDS, ERR_BNDS_N, ERR_BNDS_C, NPARAMS,
     $        PARAMS, W, R, INFO )
         CALL CHKXER( 'ZHERFSX', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL ZHERFSX( 'U', EQ, -1, 0, A, 1, AF, 1, IP, S, B, 1, X, 1,
     $        RCOND, BERR, N_ERR_BNDS, ERR_BNDS_N, ERR_BNDS_C, NPARAMS,
     $        PARAMS, W, R, INFO )
         CALL CHKXER( 'ZHERFSX', INFOT, NOUT, LERR, OK )
         EQ = 'N'
         INFOT = 3
         CALL ZHERFSX( 'U', EQ, -1, 0, A, 1, AF, 1, IP, S, B, 1, X, 1,
     $        RCOND, BERR, N_ERR_BNDS, ERR_BNDS_N, ERR_BNDS_C, NPARAMS,
     $        PARAMS, W, R, INFO )
         CALL CHKXER( 'ZHERFSX', INFOT, NOUT, LERR, OK )
         INFOT = 4
         CALL ZHERFSX( 'U', EQ, 0, -1, A, 1, AF, 1, IP, S, B, 1, X, 1,
     $        RCOND, BERR, N_ERR_BNDS, ERR_BNDS_N, ERR_BNDS_C, NPARAMS,
     $        PARAMS, W, R, INFO )
         CALL CHKXER( 'ZHERFSX', INFOT, NOUT, LERR, OK )
         INFOT = 6
         CALL ZHERFSX( 'U', EQ, 2, 1, A, 1, AF, 2, IP, S, B, 2, X, 2,
     $        RCOND, BERR, N_ERR_BNDS, ERR_BNDS_N, ERR_BNDS_C, NPARAMS,
     $        PARAMS, W, R, INFO )
         CALL CHKXER( 'ZHERFSX', INFOT, NOUT, LERR, OK )
         INFOT = 8
         CALL ZHERFSX( 'U', EQ, 2, 1, A, 2, AF, 1, IP, S, B, 2, X, 2,
     $        RCOND, BERR, N_ERR_BNDS, ERR_BNDS_N, ERR_BNDS_C, NPARAMS,
     $        PARAMS, W, R, INFO )
         CALL CHKXER( 'ZHERFSX', INFOT, NOUT, LERR, OK )
         INFOT = 11
         CALL ZHERFSX( 'U', EQ, 2, 1, A, 2, AF, 2, IP, S, B, 1, X, 2,
     $        RCOND, BERR, N_ERR_BNDS, ERR_BNDS_N, ERR_BNDS_C, NPARAMS,
     $        PARAMS, W, R, INFO )
         CALL CHKXER( 'ZHERFSX', INFOT, NOUT, LERR, OK )
         INFOT = 13
         CALL ZHERFSX( 'U', EQ, 2, 1, A, 2, AF, 2, IP, S, B, 2, X, 1,
     $        RCOND, BERR, N_ERR_BNDS, ERR_BNDS_N, ERR_BNDS_C, NPARAMS,
     $        PARAMS, W, R, INFO )
         CALL CHKXER( 'ZHERFSX', INFOT, NOUT, LERR, OK )
*
*        ZHECON
*
         SRNAMT = 'ZHECON'
         INFOT = 1
         CALL ZHECON( '/', 0, A, 1, IP, ANRM, RCOND, W, INFO )
         CALL CHKXER( 'ZHECON', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL ZHECON( 'U', -1, A, 1, IP, ANRM, RCOND, W, INFO )
         CALL CHKXER( 'ZHECON', INFOT, NOUT, LERR, OK )
         INFOT = 4
         CALL ZHECON( 'U', 2, A, 1, IP, ANRM, RCOND, W, INFO )
         CALL CHKXER( 'ZHECON', INFOT, NOUT, LERR, OK )
         INFOT = 6
         CALL ZHECON( 'U', 1, A, 1, IP, -ANRM, RCOND, W, INFO )
         CALL CHKXER( 'ZHECON', INFOT, NOUT, LERR, OK )
*
*     Test error exits of the routines that use the diagonal pivoting
*     factorization of a Hermitian indefinite packed matrix.
*
      ELSE IF( LSAMEN( 2, C2, 'HP' ) ) THEN
*
*        ZHPTRF
*
         SRNAMT = 'ZHPTRF'
         INFOT = 1
         CALL ZHPTRF( '/', 0, A, IP, INFO )
         CALL CHKXER( 'ZHPTRF', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL ZHPTRF( 'U', -1, A, IP, INFO )
         CALL CHKXER( 'ZHPTRF', INFOT, NOUT, LERR, OK )
*
*        ZHPTRI
*
         SRNAMT = 'ZHPTRI'
         INFOT = 1
         CALL ZHPTRI( '/', 0, A, IP, W, INFO )
         CALL CHKXER( 'ZHPTRI', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL ZHPTRI( 'U', -1, A, IP, W, INFO )
         CALL CHKXER( 'ZHPTRI', INFOT, NOUT, LERR, OK )
*
*        ZHPTRS
*
         SRNAMT = 'ZHPTRS'
         INFOT = 1
         CALL ZHPTRS( '/', 0, 0, A, IP, B, 1, INFO )
         CALL CHKXER( 'ZHPTRS', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL ZHPTRS( 'U', -1, 0, A, IP, B, 1, INFO )
         CALL CHKXER( 'ZHPTRS', INFOT, NOUT, LERR, OK )
         INFOT = 3
         CALL ZHPTRS( 'U', 0, -1, A, IP, B, 1, INFO )
         CALL CHKXER( 'ZHPTRS', INFOT, NOUT, LERR, OK )
         INFOT = 7
         CALL ZHPTRS( 'U', 2, 1, A, IP, B, 1, INFO )
         CALL CHKXER( 'ZHPTRS', INFOT, NOUT, LERR, OK )
*
*        ZHPRFS
*
         SRNAMT = 'ZHPRFS'
         INFOT = 1
         CALL ZHPRFS( '/', 0, 0, A, AF, IP, B, 1, X, 1, R1, R2, W, R,
     $                INFO )
         CALL CHKXER( 'ZHPRFS', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL ZHPRFS( 'U', -1, 0, A, AF, IP, B, 1, X, 1, R1, R2, W, R,
     $                INFO )
         CALL CHKXER( 'ZHPRFS', INFOT, NOUT, LERR, OK )
         INFOT = 3
         CALL ZHPRFS( 'U', 0, -1, A, AF, IP, B, 1, X, 1, R1, R2, W, R,
     $                INFO )
         CALL CHKXER( 'ZHPRFS', INFOT, NOUT, LERR, OK )
         INFOT = 8
         CALL ZHPRFS( 'U', 2, 1, A, AF, IP, B, 1, X, 2, R1, R2, W, R,
     $                INFO )
         CALL CHKXER( 'ZHPRFS', INFOT, NOUT, LERR, OK )
         INFOT = 10
         CALL ZHPRFS( 'U', 2, 1, A, AF, IP, B, 2, X, 1, R1, R2, W, R,
     $                INFO )
         CALL CHKXER( 'ZHPRFS', INFOT, NOUT, LERR, OK )
*
*        ZHPCON
*
         SRNAMT = 'ZHPCON'
         INFOT = 1
         CALL ZHPCON( '/', 0, A, IP, ANRM, RCOND, W, INFO )
         CALL CHKXER( 'ZHPCON', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL ZHPCON( 'U', -1, A, IP, ANRM, RCOND, W, INFO )
         CALL CHKXER( 'ZHPCON', INFOT, NOUT, LERR, OK )
         INFOT = 5
         CALL ZHPCON( 'U', 1, A, IP, -ANRM, RCOND, W, INFO )
         CALL CHKXER( 'ZHPCON', INFOT, NOUT, LERR, OK )
      END IF
*
*     Print a summary line.
*
      CALL ALAESM( PATH, OK, NOUT )
*
      RETURN
*
*     End of ZERRHE
*
      END