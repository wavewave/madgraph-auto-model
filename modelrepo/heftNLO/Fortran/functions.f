
      DOUBLE COMPLEX FUNCTION FormFactor( HALFS )

      DOUBLE COMPLEX HALFS
      DOUBLE COMPLEX S
      DOUBLE COMPLEX mt
      DOUBLE COMPLEX tau
      DOUBLE COMPLEX beta
      REAL PIE

      INCLUDE 'coupl.inc'
      INCLUDE 'input.inc'
    
      PIE=3.14159265358979323846264
      S = 2.0*HALFS
      mt = MDL_MT
      tau = 4*mt**2 / S
    
      IF (REAL(tau) .LT. 1.0) THEN  
        beta = SQRT(1-tau)
        BRA = 0.5*(LOG((1+beta)/(1-beta)) - (0D0,1D0)*PI)**2
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
      DOUBLE COMPLEX tau
      DOUBLE COMPLEX beta
      REAL PIE

      INCLUDE 'coupl.inc'
      INCLUDE 'input.inc'
    
      PIE=3.14159265358979323846264

      S = 2.0*HALFS
   
      mt = MDL_MT

      tau = 4*mt**2 / S
    
      IF (REAL(tau) .LT. 1.0) THEN  
        beta = SQRT(1-tau)
        BRA = 0.5*(LOG((1+beta)/(1-beta)) - (0D0,1D0)*PI)**2
      ELSE 
        BRA = -2.0*(ASIN(1/SQRT(tau)))**2
      END IF
         
      FormFactor2 = 4.0*mt / (16.0 * PIE**2 * S)* BRA 

      !WRITE(0,*) S,BRA,FormFactor2

      return 
      end


