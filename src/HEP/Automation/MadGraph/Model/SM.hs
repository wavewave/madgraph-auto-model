{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

module HEP.Automation.MadGraph.Model.SM where

import HEP.Automation.MadGraph.Model
import Text.Printf
import Text.StringTemplate
import Text.StringTemplate.Helpers
import System.FilePath ((</>))

import Data.Typeable
import Data.Data

data SM = SM 
        deriving (Show, Typeable, Data)

instance Model SM where
  data ModelParam SM = SMParam 
                     deriving Show 
  briefShow SM = "SM"
  madgraphVersion _ = MadGraph5
  modelName SM = "sm"
  modelFromString str = case str of 
                          "sm" -> Just SM 
                          _ -> Nothing
  paramCard4Model SM   = "param_card_sm.dat"
  paramCardSetup tpath SM SMParam = do  
    str <- readFile (tpath </> paramCard4Model SM ++ ".st" )  
    return str
  briefParamShow  SMParam = "" 
  interpreteParam _ = SMParam


sMTr :: TypeRep 
sMTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.SM.SM") []

instance Typeable (ModelParam SM) where
  typeOf _ = mkTyConApp modelParamTc [sMTr]

deriving instance Data (ModelParam SM)

-----------------------------------------------------
-----------------------------------------------------

data SMHiggs = SMHiggs 
        deriving (Show, Typeable, Data)

instance Model SMHiggs where
  data ModelParam SMHiggs = SMHiggsParam { mhiggs :: Double, whiggs :: Double } 
                     deriving Show 
  briefShow SMHiggs = "SMHiggs"
  modelName SMHiggs = "sm"
  paramCard4Model SMHiggs   = "param_card_smhiggs.dat"
  paramCardSetup tpath SMHiggs p = do  
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("mhiggs", (printf "%.4e" (mhiggs p) :: String) )
                 , ("whiggs", (printf "%.4e" (whiggs p) :: String) ) ] 
                 (paramCard4Model SMHiggs) ) ++ "\n\n\n"
  briefParamShow  (SMHiggsParam m w)  = "MH" ++ show m ++ "WH" ++ show w 
  madgraphVersion = error "madgraphVersion undefined in SMHiggs"
  modelFromString = error "modelFromString undefined in SMHiggs"
  interpreteParam = error "interpreteParam undefined in SMHiggs"


sMHiggsTr :: TypeRep 
sMHiggsTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.SM.SMHiggs") []

instance Typeable (ModelParam SMHiggs) where
  typeOf _ = mkTyConApp modelParamTc [sMHiggsTr]

deriving instance Data (ModelParam SMHiggs)
