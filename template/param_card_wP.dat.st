#This file has been generated automatically by FeynRules
# Version: 1.4.10   Date: 24. 11. 2010,    13:43
Block CKMBLOCK
  1  2.2773600000000E-01  # cabi
Block SMINPUTS
  1  1.2790000000000E+02  # aEWM1
  2  1.1663900000000E-05  # Gf
  3  1.1800000000000E-01  # aS
Block WPRIME
  1  $gRWpoverSqrtTwo$  # gWpdt
  2  1.0000000000000E+00  # gwp
Block YUKAWA
  4  1.4200000000000E+00  # ymc
  5  4.7000000000000E+00  # ymb
  6  1.7430000000000E+02  # ymt
  15  1.7770000000000E+00  # ymtau
Block MASS
  4  1.4200000000000E+00  # MC
  5  4.7000000000000E+00  # MB
  6  1.7430000000000E+02  # MT
  15  1.7770000000000E+00  # MTA
  23  9.1188000000000E+01  # MZ
  24  7.9825163827443E+01  # MW
  25  1.2000000000000E+02  # MH
  9000006  $massWp$          # mWp
  9000007  9.0000000000000E+02  # mZp
DECAY  6  1.5083364900000E+00  # WT
DECAY  23  2.4414035100000E+00  # WZ
DECAY  24  2.0475995100000E+00  # WW
DECAY  25  5.7530884800000E-03  # WH
DECAY  9000006  $widthWp$     # wWp
DECAY  9000007  1.0500000000000E+01  # wZp

#===========================================================
# QUANTUM NUMBERS OF NEW STATE(S) (NON SM PDG CODE) IF ANY
#===========================================================

Block QNUMBERS 9000006  # Wp+
        1 3  # 3 times electric charge
        2 3  # number of spin states (2S+1)
        3 1  # colour rep (1: singlet, 3: triplet, 8: octet)
        4 1  # Particle/Antiparticle distinction (0=own anti)
Block QNUMBERS 9000007  # Zp
        1 0  # 3 times electric charge
        2 3  # number of spin states (2S+1)
        3 1  # colour rep (1: singlet, 3: triplet, 8: octet)
        4 0  # Particle/Antiparticle distinction (0=own anti)
