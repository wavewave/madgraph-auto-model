{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.Wp where

import Text.Printf

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

data Wp = Wp
        deriving Show
           
instance Model Wp where
  data ModelParam Wp = WpParam { massWp :: Double, gRWp :: Double } 
    deriving Show
  briefShow Wp = "Wp"
  modelName Wp = "fvwp200_MG"
  paramCard4Model Wp   = "param_card_wP.dat"
  paramCardSetup tpath Wp (WpParam m g) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("massWp"       , (printf "%.4e" m :: String))
                 , ("gRWpoverSqrtTwo", (printf "%.4e" (g / (sqrt 2.0)) :: String))  
                 , ("widthWp"      , (printf "%.4e" (gammaWpZp m g) :: String)) ]  
                 (paramCard4Model Wp)  ) ++ "\n\n\n"
  briefParamShow (WpParam  m g) = "M"++show m++"G"++show g

gammaWpZp :: Double -> Double -> Double            
gammaWpZp mass coup = 
  let r = mtop^(2 :: Int)/ mass^(2 :: Int)  
  in  coup^(2 :: Int) / (16.0 * pi) *mass*( 1.0 - 1.5 * r + 0.5 * r^(3 :: Int))
