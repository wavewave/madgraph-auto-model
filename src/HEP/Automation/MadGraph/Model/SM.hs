{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.SM where

import HEP.Automation.MadGraph.Model

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