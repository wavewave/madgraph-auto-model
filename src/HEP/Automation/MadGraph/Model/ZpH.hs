{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.ZpH where

import Text.Printf

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

import System.FilePath ((</>))

data ZpH = ZpH
         deriving Show

instance Model ZpH where
  data ModelParam ZpH = ZpHParam { massZp :: Double, gRZp :: Double } 
                      deriving Show
  briefShow ZpH = "Zp"
  modelName ZpH = "zHorizontal_MG"
  paramCard4Model ZpH  = "param_card_zHorizontal.dat" 
  paramCardSetup tpath ZpH (ZpHParam m g) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("masszp"       , (printf "%.4e" m :: String))
                 , ("gRoverSqrtTwo"  , (printf "%.4e" (g / (sqrt 2.0)) :: String))
                 , ("widthzp"      , (printf "%.4e" (gammaWpZp m g) :: String)) ]
                 (paramCard4Model ZpH) ) ++ "\n\n\n"
  briefParamShow (ZpHParam m g) = "M"++show m++"G"++show g 
  
  
gammaWpZp :: Double -> Double -> Double            
gammaWpZp mass coup = 
  let r = mtop^(2 :: Int)/ mass^(2 :: Int)  
  in  coup^(2 :: Int) / (16.0 * pi) *mass*( 1.0 - 1.5 * r + 0.5 * r^(3 :: Int))
