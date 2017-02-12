SUBROUTINE diaghscalapack(HAMILTONIAN,LNROWSA,LNCOLSA,MYROW, MYCOL,NCI,NBB,CONTEXT,DESCA,EIGENVAL,WRITECICOEF)
     IMPLICIT NONE
     INTEGER, INTENT(IN) :: DESCA(9),MYCOL,MYROW,NCI,NBB,LNROWSA,LNCOLSA,CONTEXT
     DOUBLE PRECISION, INTENT(INOUT) ::  HAMILTONIAN(LNROWSA,LNCOLSA)
     DOUBLE PRECISION, INTENT(OUT) :: EIGENVAL(NCI)
     LOGICAL, INTENT(IN) :: WRITECICOEF     
     DOUBLE PRECISION :: Z(LNROWSA,LNCOLSA)
     INTEGER :: LWORK,LIWORK
     DOUBLE PRECISION :: rtmp(4)
     INTEGER  :: itmp( 4 )
     INTEGER  :: INFO
     DOUBLE PRECISION, ALLOCATABLE :: WORK(:)
     INTEGER, ALLOCATABLE :: IWORK(:)
     EXTERNAL :: PDLAPRNT,PDYSEVD

!     Ask PDSYEVD to compute the entire eigendecomposition
     
     LWORK = -1
     LIWORK = 1
     rtmp(:) = 0.0d0
     itmp(:) = 0
     
     CALL PDSYEVD( 'V', 'U', NCI, HAMILTONIAN, 1, 1, DESCA, EIGENVAL, Z, 1, 1, DESCA, rtmp, LWORK,itmp, LIWORK, INFO )
     
     LWORK  = MAX( 131072, 2*INT( rtmp(1) ) + 1 )
     LIWORK = MAX( 8*NCI , itmp(1) + 1 ) 
     ALLOCATE( IWORK(LIWORK),WORK(LWORK))

     CALL PDSYEVD( 'V', 'U', NCI, HAMILTONIAN, 1, 1, DESCA, EIGENVAL, Z, 1, 1, DESCA, WORK, LWORK,IWORK, LIWORK, INFO )
     
!     Print out the eigenvectors
      IF ( WRITECICOEF ) THEN
          IF ( MYCOL .EQ. 0 .AND.  MYROW .EQ. 0  ) OPEN(7,FILE='CIEXPANSIONCOEFF.dat',ACTION='WRITE')
          CALL PDLAPRNT( NCI, NCI, Z, 1, 1, DESCA, 0, 0, 'Z', 7, WORK )
          IF ( MYCOL .EQ. 0 .AND.  MYROW .EQ. 0  ) CLOSE(7)
      ENDIF
      
END SUBROUTINE diaghscalapack
