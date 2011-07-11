{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.Six where

import Text.Printf

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Exotic
import HEP.Automation.MadGraph.Model.Common

data Six = Six
         deriving Show
           
instance Model Six where
  data ModelParam Six = SixParam { massSix :: Double, gRSix :: Double } 
                      deriving Show 
  briefShow Six = "Six"
  madgraphVersion _ = MadGraph5
  modelName Six = "sextets_fv"
  paramCard4Model Six  = "param_card_six.dat"  
  paramCardSetup tpath Six (SixParam m g) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("massSix" , (printf "%.4e" m :: String))
                 , ("gRSix"   , (printf "%.4e" g :: String))
                 , ("widthSix", (printf "%.4e" (decayWidthExotic g m mtop) :: String)) ]
                 (paramCard4Model Six) ) ++ "\n\n\n"
  briefParamShow (SixParam m g) = "M"++show m++"G"++show g
