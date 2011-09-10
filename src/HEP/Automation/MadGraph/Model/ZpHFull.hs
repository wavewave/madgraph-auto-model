{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

module HEP.Automation.MadGraph.Model.ZpHFull where

import Data.Typeable
import Data.Data

import Text.Printf

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

data ZpHFull = ZpHFull
  deriving (Show, Typeable, Data)

instance Model ZpHFull where
  data ModelParam ZpHFull = ZpHFullParam { mZp :: Double,  
                                           gHtu :: Double, 
                                           gHbd :: Double }
                          deriving Show
  briefShow ZpHFull = "ZpHFull"                             
  modelName ZpHFull = "zHorizontalTUBDlight_MG" 
  paramCard4Model ZpHFull   = "param_card_ZpHFull.dat"
  paramCardSetup tpath ZpHFull p = do 
    templates <- directoryGroup tpath
    return $ ( renderTemplateGroup
                 templates
                 [ ("mZp" , (printf "%.4e" (mZp p)         :: String))
                 , ("gHtu", (printf "%.4e" (gHtu p/sqrt 2) :: String))
                 , ("gHbd", (printf "%.4e" (gHbd p/sqrt 2) :: String))
                 , ("wTop", (printf "%.4e" (gammaTop mtop (mZp p) (gHtu p)) :: String))
                 , ("wZp" , (printf "%.4e" (gammaZp (mZp p) (gHbd p)) :: String))
                 ]
                 (paramCard4Model ZpHFull)  ) ++ "\n\n\n"
  briefParamShow p 
    = ("M" ++ show (mZp p)
       ++ "GT" ++ show (gHtu p)  
       ++ "GB" ++ show (gHbd p))
  madgraphVersion = error "madgraphVersion is not defined in ZpHFull"
  modelFromString = error "modelFromString is not defined in ZpHFull"
  interpreteParam = error "interpreteParam is not defined in ZpHFull"


-- | decay width of Zprime
gammaZp :: Double       -- ^ mZp
        -> Double       -- ^ gHbd
        -> Double 
gammaZp mzp ghbd = ghbd^(2::Int) / (16.0*pi) * mzp -- 0.5*sqrt2 => 1.49027759

-- | additional decay width of top
gammaTop :: Double   -- ^ mtop 
            -> Double   -- ^ mZp  
            -> Double   -- ^ gHbd
            -> Double
gammaTop mt mzp ghtu = (ghtu^(2::Int) / (64.0*pi)* mt^(3::Int) / (mzp*mzp) 
                          * ( 1- mzp*mzp / (mt*mt))^(2::Int)
                          * ( 1+ 2.0 * mzp*mzp / (mt*mt) ))
                       + smgammatop 
    where smgammatop = 1.508336

zpHFullTr :: TypeRep 
zpHFullTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.ZpHFull.ZpHFull") []

instance Typeable (ModelParam ZpHFull) where
  typeOf _ = mkTyConApp modelParamTc [zpHFullTr]

deriving instance Data (ModelParam ZpHFull)
