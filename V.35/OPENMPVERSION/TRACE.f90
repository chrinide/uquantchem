FUNCTION TRACE(MAT,N)
      IMPLICIT NONE
      DOUBLE PRECISION :: TRACE
      INTEGER :: N
      DOUBLE PRECISION :: MAT(N,N)
      INTEGER :: I

      TRACE = 0.0d0 
      DO I=1,N
                TRACE = TRACE + MAT(I,I)
      ENDDO

END FUNCTION TRACE
