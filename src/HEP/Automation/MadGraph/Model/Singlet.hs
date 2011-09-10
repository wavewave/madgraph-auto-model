{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

module HEP.Automation.MadGraph.Model.Singlet where

import Data.Typeable
import Data.Data

import Text.Printf

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

data Singlet = Singlet
  deriving (Show, Typeable, Data)

instance Model Singlet where
  data ModelParam Singlet = SingletParam { mhh :: Double,  
                                           gtu :: Double, 
                                           gbd :: Double }
                          deriving Show
  briefShow Singlet = "Singlet"                             
  modelName Singlet = "scalarSinglet_MG" 
  paramCard4Model Singlet   = "param_card_Singlet.dat"
  paramCardSetup tpath Singlet p = do 
    templates <- directoryGroup tpath
    return $ ( renderTemplateGroup
                 templates
                 [ ("MHH" , (printf "%.4e" (mhh p)         :: String))
                 , ("gtu", (printf "%.4e" (gtu p) :: String))
                 , ("gbd", (printf "%.4e" (gbd p) :: String))
                 , ("wTop", (printf "%.4e" (gammaTop mtop (mhh p) (gtu p)) :: String))
                 , ("WHH" , (printf "%.4e" (gammaHH (mhh p) (gbd p)) :: String))
                 ]
                 (paramCard4Model Singlet  ) ) ++ "\n\n\n"
  briefParamShow p 
    = ("M" ++ show (mhh p)
       ++ "GT" ++ show (gtu p)  
       ++ "GB" ++ show (gbd p))
  madgraphVersion = error "madgraphVersion is not defined in Singlet"
  modelFromString = error "modelFromString is not defined in Singlet"
  interpreteParam = error "interpreteParam is not defined in Singlet"


-- | decay width of Zprime
gammaHH :: Double       -- ^ mhh
        -> Double       -- ^ gbd
        -> Double 
gammaHH mhh' gbd' = gbd'^(2::Int) / (16.0*pi) * mhh' -- 0.5*sqrt2 => 1.49027759

-- | additional decay width of top
gammaTop :: Double   -- ^ mtop 
            -> Double   -- ^ mhh  
            -> Double   -- ^ gtu
            -> Double
gammaTop mt' mhh' gtu' = gtu'^(2::Int) / (62.0*pi)* (mt'^(2::Int) - mhh'^(2::Int))^(2::Int) / (mt'^(3::Int))
                      + smgammatop 
    where smgammatop = 1.508336

singletTr :: TypeRep 
singletTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.Singlet.Singlet") []

instance Typeable (ModelParam Singlet) where
  typeOf _ = mkTyConApp modelParamTc [singletTr]

deriving instance Data (ModelParam Singlet)
