SUBROUTINE invert(A,AINV,N)
      IMPLICIT NONE
      DOUBLE PRECISION, INTENT(IN) :: A(N,N)
      DOUBLE PRECISION, INTENT(OUT) :: AINV(N,N)
      INTEGER, INTENT(IN) :: N
      INTEGER :: I,INFO
      DOUBLE PRECISION :: C(N,N),CT(N,N),DIAG(N,N),EIGENVAL(N),EIGENVECT(N,N)
      EXTERNAL :: diagh

      CALL diagh( A,N,EIGENVAL,EIGENVECT,INFO)

      C = EIGENVECT
      CT = TRANSPOSE(EIGENVECT)

      DIAG(:,:) = 0.0d0
      DO I=1,N
                DIAG(I,I) = 1.0d0/EIGENVAL(I)
      ENDDO

      AINV = MATMUL(C,MATMUL(DIAG,CT))

      END SUBROUTINE invert


