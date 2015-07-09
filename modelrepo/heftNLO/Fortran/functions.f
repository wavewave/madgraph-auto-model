
      DOUBLE COMPLEX FUNCTION FormFactor( HALFS )

      DOUBLE COMPLEX HALFS
      DOUBLE COMPLEX S
      DOUBLE COMPLEX mt
      DOUBLE COMPLEX tau
      DOUBLE COMPLEX beta
      DOUBLE COMPLEX BRA
      REAL PIE

      INCLUDE 'coupl.inc'
      INCLUDE 'input.inc'
    
      PIE=3.14159265358979323846264
      S = 2.0*HALFS
      mt = MDL_MT
      tau = 4*mt**2 / S
    
      IF (REAL(tau) .LT. 1.0) THEN  
        beta = SQRT(1-tau)
        BRA = 0.5*(LOG((1+beta)/(1-beta)) - (0D0,1D0)*PIE)**2
      ELSE 
        BRA = -2.0*(ASIN(1/SQRT(tau)))**2
      END IF
         
      FormFactor = - mt / (PIE**2 * S)*(1-0.5 * (1 - tau) * BRA ) 
      !WRITE(0,*) S,BRA,FormFactor

      return 
      end

      DOUBLE COMPLEX FUNCTION FormFactor2( HALFS )

      DOUBLE COMPLEX HALFS
      DOUBLE COMPLEX S
      DOUBLE COMPLEX mt
      DOUBLE COMPLEX wh1
      DOUBLE COMPLEX tau
      DOUBLE COMPLEX beta
      DOUBLE COMPLEX BRA1
      DOUBLE COMPLEX BRA
      DOUBLE COMPLEX CORRF
      REAL PIE

      INCLUDE 'coupl.inc'
      INCLUDE 'input.inc'
    
      PIE=3.14159265358979323846264
      S = 2.0*HALFS
      mt = MDL_MT
      !wh1 = MDL_WH1
      wh1 = 11.82
      mh1 = MDL_MP
      tau = 4*mt**2 / S

      CORRF = (S - mh1**2) / ((S-mh1**2)+(0D0,1D0)*mh1*wh1)
 
      IF (REAL(tau) .LT. 1.0) THEN  
        beta = SQRT(1-tau)
        BRA1 = LOG((1+beta)/(1-beta)) - (0D0,1D0)*PIE
        BRA = 0.5*BRA1*BRA1
      ELSE 
        BRA = -2.0*(ASIN(1/SQRT(tau)))**2
      END IF
         
      FormFactor2 = 4.0*mt / (16.0 * PIE**2 * S)* BRA * CORRF
      !IF (REAL(tau) .LT. 1.0) THEN  
      !  WRITE(0,*) SQRT(S),CORRF !,FormFactor2
      !ENDIF
      return 
      end


