C----------------------------------------------------------------------
C----------------------------------------------------------------------
C   tim :    A test problem for timing AUTO
C----------------------------------------------------------------------
C----------------------------------------------------------------------
C
      SUBROUTINE FUNC(NDIM,U,ICP,PAR,IJAC,F,DFDU,DFDP)
C     ---------- ----
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION U(NDIM),PAR(*),F(NDIM)
C
       NDIM2=NDIM/2
       DO I=1,NDIM2
         I1=2*(I-1)+1
         I2=I1+1
         E=FEXP(U(I1))
         F(I1)=U(I2)
         F(I2)=-PAR(1)*E
       ENDDO
C
      RETURN
      END
C----------------------------------------------------------------------
C
C put a cheat in here for conversion. replace function statement with 
C sub-routine statement
C      DOUBLE PRECISION FUNCTION FEXP(U)
      SUBROUTINE FEXP(U)
C     ------ --------- -------- ----
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C
       NTERMS=25
       FEXP=1.d0
       TRM=FEXP
       DO K=1,NTERMS
        TRM=TRM*U/K
        FEXP=FEXP + TRM
       ENDDO
C
      RETURN
      END
C----------------------------------------------------------------------
C
      SUBROUTINE STPNT(NDIM,U,PAR,T)
C     ---------- -----
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION U(NDIM),PAR(*)
C
      DO I=1,NDIM
        U(I)=0.0
      ENDDO
C
      RETURN
      END
C----------------------------------------------------------------------
C
      SUBROUTINE BCND(NDIM,PAR,ICP,NBC,U0,U1,FB,IJAC,DBC)
C     ---------- ----
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION PAR(*),ICP(*),U0(NDIM),U1(NDIM),FB(NBC)
C
       NDIM2=NDIM/2
       DO I=1,NDIM2
         I1=2*(I-1)+1
         I2=I1+1
         FB(I1)=U0(I1)
         FB(I2)=U1(I1)
       ENDDO
C
      RETURN
      END
C----------------------------------------------------------------------
C
      SUBROUTINE ICND
      RETURN
      END
C
      SUBROUTINE FOPT
      RETURN
      END
C 
      SUBROUTINE PVLS
      RETURN 
      END 
C----------------------------------------------------------------------
