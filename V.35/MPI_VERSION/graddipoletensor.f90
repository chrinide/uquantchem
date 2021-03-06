SUBROUTINE graddipoletensor(NATOMS,BAS,POLDIR,gDPTENSOR)
      ! This subroutine calculates the nuclear gradients of the 
      ! dipole-tensoris d_mn(x) = <m|x|n>
      ! d_mn(y) = <m|y|n>, d_mn(z) = <m|z|n>
      ! The result is stored in the array: DPTENSOR
      USE datatypemodule
      IMPLICIT NONE
      DOUBLE PRECISION, EXTERNAL :: primoverlap
      EXTERNAL :: gradprimoverlap
      TYPE(BASIS), INTENT(IN) :: BAS
      INTEGER, INTENT(IN) :: NATOMS,POLDIR
      DOUBLE PRECISION, INTENT(OUT) :: gDPTENSOR(NATOMS,3,BAS%NBAS,BAS%NBAS)
      INTEGER :: I,J,N,K,L1,M1,N1,L2,M2,N2,M,AA,BA
      DOUBLE PRECISION :: NO1,NO2,NP1,NP2,gradient(2,3)
      DOUBLE PRECISION :: A(3),B(3),alpha1,alpha2,coeff1,coeff2
      

      gDPTENSOR(:,:,:,:) = 0.0d0
      
      DO I=1,BAS%NBAS
                
                L1= BAS%PSI(I)%L(1)
                M1= BAS%PSI(I)%L(2)
                N1= BAS%PSI(I)%L(3)
                A = BAS%PSI(I)%R
                NO1 = BAS%PSI(I)%NORM 
                AA = BAS%PSI(I)%ATYPE
                
                DO J=1,BAS%NBAS
                        
                        L2= BAS%PSI(J)%L(1)
                        M2= BAS%PSI(J)%L(2)
                        N2= BAS%PSI(J)%L(3)
                        B = BAS%PSI(J)%R
                        NO2 = BAS%PSI(J)%NORM
                        BA = BAS%PSI(J)%ATYPE

                        DO N=1,BAS%PSI(I)%NPRIM
                                alpha1 = BAS%PSI(I)%EXPON(N)
                                coeff1 = BAS%PSI(I)%CONTRCOEFF(N)
                                NP1 = BAS%PSI(I)%PRIMNORM(N)
                                DO K=1,BAS%PSI(J)%NPRIM
                                        alpha2 = BAS%PSI(J)%EXPON(K)
                                        coeff2 = BAS%PSI(J)%CONTRCOEFF(K)
                                        NP2 = BAS%PSI(J)%PRIMNORM(K)
                                        !------------------------------------------------------
                                        ! Here calculate the grad<psi(N)|x|psi(K)> -tensor elements
                                        !-------------------------------------------------------
                                        IF ( POLDIR .EQ. 1 ) THEN
                                                CALL gradprimoverlap(L1,M1,N1,A,alpha1,L2+1,M2,N2,B,alpha2,gradient)
                                                gDPTENSOR(AA,:,I,J) = gDPTENSOR(AA,:,I,J) + NO1*NO2*coeff1*coeff2*NP1*NP2*gradient(1,:)
                                                gDPTENSOR(BA,:,I,J) = gDPTENSOR(BA,:,I,J) + NO1*NO2*coeff1*coeff2*NP1*NP2*gradient(2,:)
                                                
                                                CALL gradprimoverlap(L1,M1,N1,A,alpha1,L2,M2,N2,B,alpha2,gradient)
                                                gDPTENSOR(AA,:,I,J) = gDPTENSOR(AA,:,I,J) + B(1)*NO1*NO2*coeff1*coeff2*NP1*NP2*gradient(1,:)
                                                gDPTENSOR(BA,:,I,J) = gDPTENSOR(BA,:,I,J) + B(1)*NO1*NO2*coeff1*coeff2*NP1*NP2*gradient(2,:)
                                                
                                                gDPTENSOR(BA,1,I,J) = gDPTENSOR(BA,1,I,J) + NO1*NO2*coeff1*coeff2*NP1*NP2*primoverlap(L1,M1,N1,A,alpha1,L2,M2,N2,B,alpha2)
                                        ENDIF
                                        !------------------------------------------------------
                                        ! Here calculate the grad<psi(N)|y|psi(K)> -tensor elements
                                        !-------------------------------------------------------
                                        IF ( POLDIR .EQ. 2 ) THEN
                                                CALL gradprimoverlap(L1,M1,N1,A,alpha1,L2,M2+1,N2,B,alpha2,gradient)
                                                gDPTENSOR(AA,:,I,J) = gDPTENSOR(AA,:,I,J) + NO1*NO2*coeff1*coeff2*NP1*NP2*gradient(1,:)
                                                gDPTENSOR(BA,:,I,J) = gDPTENSOR(BA,:,I,J) + NO1*NO2*coeff1*coeff2*NP1*NP2*gradient(2,:)
                                                
                                                CALL gradprimoverlap(L1,M1,N1,A,alpha1,L2,M2,N2,B,alpha2,gradient)
                                                gDPTENSOR(AA,:,I,J) = gDPTENSOR(AA,:,I,J) + B(2)*NO1*NO2*coeff1*coeff2*NP1*NP2*gradient(1,:)
                                                gDPTENSOR(BA,:,I,J) = gDPTENSOR(BA,:,I,J) + B(2)*NO1*NO2*coeff1*coeff2*NP1*NP2*gradient(2,:)
                                                
                                                gDPTENSOR(BA,2,I,J) = gDPTENSOR(BA,2,I,J) + NO1*NO2*coeff1*coeff2*NP1*NP2*primoverlap(L1,M1,N1,A,alpha1,L2,M2,N2,B,alpha2)
                                        ENDIF
                                        !------------------------------------------------------
                                        ! Here calculate the grad<psi(N)|z|psi(K)> -tensor elements
                                        !-------------------------------------------------------
                                        IF ( POLDIR .EQ. 3 ) THEN
                                                CALL gradprimoverlap(L1,M1,N1,A,alpha1,L2,M2,N2+1,B,alpha2,gradient)
                                                gDPTENSOR(AA,:,I,J) = gDPTENSOR(AA,:,I,J) + NO1*NO2*coeff1*coeff2*NP1*NP2*gradient(1,:)
                                                gDPTENSOR(BA,:,I,J) = gDPTENSOR(BA,:,I,J) + NO1*NO2*coeff1*coeff2*NP1*NP2*gradient(2,:)
                                                
                                                CALL gradprimoverlap(L1,M1,N1,A,alpha1,L2,M2,N2,B,alpha2,gradient)
                                                gDPTENSOR(AA,:,I,J) = gDPTENSOR(AA,:,I,J) + B(3)*NO1*NO2*coeff1*coeff2*NP1*NP2*gradient(1,:)
                                                gDPTENSOR(BA,:,I,J) = gDPTENSOR(BA,:,I,J) + B(3)*NO1*NO2*coeff1*coeff2*NP1*NP2*gradient(2,:)
                                                
                                                gDPTENSOR(BA,3,I,J) = gDPTENSOR(BA,3,I,J) + NO1*NO2*coeff1*coeff2*NP1*NP2*primoverlap(L1,M1,N1,A,alpha1,L2,M2,N2,B,alpha2)
                                        ENDIF
                                ENDDO
                        ENDDO
                ENDDO

      ENDDO
END SUBROUTINE graddipoletensor
