FUNCTION jastrowud(N,r,b,c)
        ! This function calculates the Jastrow factor contribution
        ! from the cross-terms between spin-up and spin-down electrons. 
        ! N = total number of electrons  r = coordinates of all electrons, r is a 3*N long-array
        ! b,c = jastrow parameters. See Eqn.(15), p.7 in my QDMC notes
        IMPLICIT NONE
        DOUBLE PRECISION :: jastrowud
        INTEGER :: N
        DOUBLE PRECISION :: r(3*N),b,c
        DOUBLE PRECISION :: rij,V(3),U(3)
        INTEGER :: I,J

        jastrowud = 0.0d0

        DO I=1,(N-MOD(N,2))/2
                DO J=(N-MOD(N,2))/2+1,N
                        V(1) = r(3*(I-1) + 1 )
                        V(2) = r(3*(I-1) + 2 )
                        V(3) = r(3*(I-1) + 3 )
                        U(1) = r(3*(J-1) + 1 )
                        U(2) = r(3*(J-1) + 2 )
                        U(3) = r(3*(J-1) + 3 )
                        rij = sqrt( DOT_PRODUCT(V-U,V-U) )
                        jastrowud = jastrowud + (1.0d0/2.0d0)*b*rij/(1+c*rij)
                ENDDO
       ENDDO
END FUNCTION jastrowud
