{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.ZpHFull where

import Text.Printf

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model

data ZpHFull = ZpHFull
  deriving Show

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
                 , ("wZp" , (printf "%.4e" gammaZp :: String))
                 ]
                 (paramCard4Model ZpHFull)  ) ++ "\n\n\n"
 -- Decay width is not right. 
  briefParamShow p 
    = ("M" ++ show (mZp p)
       ++ "GT" ++ show (gHtu p)  
       ++ "GB" ++ show (gHbd p))

-- | this is not good at all.
gammaZp :: Double 
gammaZp = 1.49027759
