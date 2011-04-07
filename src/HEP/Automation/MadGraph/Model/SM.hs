{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.SM where

import HEP.Automation.MadGraph.Model
import Text.Printf
import Text.StringTemplate
import Text.StringTemplate.Helpers

data SM = SM 
        deriving Show

instance Model SM where
  data ModelParam SM = SMParam 
                     deriving Show 
  briefShow SM = "SM"
  modelName SM = "sm"
  paramCard4Model SM   = "param_card_sm.dat"
  paramCardSetup tpath SM SMParam = do  
    str <- readFile (tpath ++ "/" ++ paramCard4Model SM ++ ".st" )  
    return str
  briefParamShow  SMParam = "" 

data SMHiggs = SMHiggs 
        deriving Show

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
