C----------------------------------------------------------------------
C----------------------------------------------------------------------
C   som :            The shimmy equations from somieski et.al
C----------------------------------------------------------------------
C----------------------------------------------------------------------
C
      SUBROUTINE FUNC(NDIM,U,ICP,PAR,IJAC,F,DFDU,DFDP)
C     ---------- ----
C
C Evaluates the algebraic equations or ODE right hand side
C
C Input arguments :
C      NDIM   :   Dimension of the ODE system 
C      U      :   State variables
C      ICP    :   Array indicating the free parameter(s)
C      PAR    :   Equation parameters
C
C Values to be returned :
C      F      :   ODE right hand side values
C
C Normally unused Jacobian arguments : IJAC, DFDU, DFDP (see manual)
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DOUBLE PRECISION IZ
      DOUBLE PRECISION IX
      DOUBLE PRECISION IY
      DOUBLE PRECISION MZ
      DOUBLE PRECISION M4
      DOUBLE PRECISION MKPSI
      DOUBLE PRECISION MDPSI
      DOUBLE PRECISION MKLAMPSI
      DOUBLE PRECISION MKDELTA
      DOUBLE PRECISION MDDELTA
      DOUBLE PRECISION MKLAMDELTA
      DOUBLE PRECISION MKBETA
      DOUBLE PRECISION MDBETA
      DOUBLE PRECISION MKLAMBETA
      DOUBLE PRECISION KSBETA
      DOUBLE PRECISION CSBETA

	
      DIMENSION U(NDIM), PAR(*), F(NDIM), ICP(*)
C
	IZ=100.0D0
	IX=600.0D0
	IY=300.0D0
	KSBETA=3E+7
	CSBETA=1E+2
	CMA=1.0D0
	SIGMA=0.3D0
	ALPHAG=10.0D0*3.1415926/180.0D0
        EEFF=PAR(1)*COS(PAR(8)+U(5))+(0.362D0+PAR(1)
     +      *SIN(PAR(8)+U(5)))*TAN(PAR(8)+U(5))
	HLG=2.50D0
C
	ALPHA=ATAN(U(7)/SIGMA)
C
	FY=0.01*ATAN(7.0D0*TAN(ALPHA))
     +      *COS(0.95D0*ATAN(7.0D0*TAN(ALPHA)))*PAR(4)
C
	IF (DABS(ALPHA).LE.ALPHAG) THEN 
	   MZ=-PAR(4)*CMA*(ALPHAG/3.1415926)*SIN(ALPHA*3.1415926/ALPHAG)
	ELSE
	   MZ=0.0D0
	END IF
C
	MKPSI=-PAR(6)*U(1)
C
	MDPSI=-PAR(3)*U(2)
C
	MKLAMPSI=-EEFF*FY
C
	M4=-U(2)*PAR(7)*COS(PAR(8)+U(5))/PAR(2)
C
	MKDELTA=-PAR(9)*U(3)
C
	MDDELTA=-PAR(10)*U(4)
C
        MKLAMDELTA=-FY*COS(U(1)*COS(PAR(8)+U(5)))
     +      *HLG*COS(PAR(8)+U(5))*COS(U(3))
C
	MKBETA=-KSBETA*U(5)
C
	MDBETA=-CSBETA*U(6)
C
	MKLAMBETA=-FY*SIN(U(1)*COS(PAR(8)+U(5)))*HLG*COS(PAR(8)+U(5))
C
       F(1)=U(2)
       F(2)=(1.0D0/IZ)*(MKPSI+MDPSI+MKLAMPSI+MZ+M4
     +      +PAR(4)*SIN(PAR(8)+U(5))*EEFF*SIN(U(1)*COS(PAR(8)+U(5))))
       F(3)=U(4)
       F(4)=(1.0D0/IX)*(MKDELTA+MDDELTA+MKLAMDELTA
     +      +PAR(4)*EEFF*SIN(U(1)*COS(PAR(8)+U(5)))) 	
       F(5)=U(6)
       F(6)=(1.0D0/IY)*(MKBETA+MDBETA+MKLAMBETA
     +      +PAR(4)*HLG*SIN(PAR(8)+U(5)))
       F(7)=PAR(2)*SIN(U(1)*COS(PAR(8)+U(5)))+(EEFF-PAR(5))
     +      *U(2)*COS(U(1)*COS(PAR(8)+U(5)))*COS(PAR(8)+U(5))
     +      -(PAR(2)/SIGMA)*U(7)*COS(U(1)*COS(PAR(8)+U(5)))
     +      +HLG*COS(U(3))*U(4)
C
      RETURN
      END
C----------------------------------------------------------------------
C----------------------------------------------------------------------
C
      SUBROUTINE STPNT(NDIM,U,PAR)
C     ---------- -----
C
C Input arguments :
C      NDIM   :   Dimension of the ODE system 
C
C Values to be returned :
C      U      :   A starting solution vector
C      PAR    :   The corresponding equation-parameter values
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION U(NDIM), PAR(*)
C
C Initialize the equation parameters
C
	PAR(1)=0.16
	PAR(2)=0.001D0
	PAR(3)=1.10E+2
	PAR(4)=180000.0D0
	PAR(5)=0.10D0
	PAR(6)=3.0E+5
	PAR(7)=570.0D0
	PAR(8)=0.2571D0
	PAR(9)=3.24E+6
	PAR(10)=0.01E+2
C
C Initialize the solution
C
       U(1)=0.0D0
       U(2)=0.0D0
       U(3)=0.0D0
       U(4)=0.0D0
C	60k
c       U(5)=0.00127
C	150k
c       U(5)=0.0361
C	170k
c       U(5)=0.0417
C	180k
       U(5)=0.00386
C	180k
c       U(5)=0.0389
       U(6)=0.0D0
       U(7)=0.0D0
C
      RETURN
      END
C----------------------------------------------------------------------
C----------------------------------------------------------------------
C The following subroutines are not used here,
C but they must be supplied as dummy routines
C
      SUBROUTINE BCND 
      RETURN 
      END 
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
C----------------------------------------------------------------------
