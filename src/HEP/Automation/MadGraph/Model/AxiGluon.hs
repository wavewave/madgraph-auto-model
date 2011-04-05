{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.AxiGluon where

import Text.Printf

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model

data AxiGluon = AxiGluon
              deriving Show


instance Model AxiGluon where
  data ModelParam AxiGluon = AxiGluonParam { massAxiG :: Double, 
                                             gVq :: Double , 
                                             gVt :: Double , 
                                             gAq :: Double , 
                                             gAt :: Double }  
                           deriving Show 
  briefShow AxiGluon = "Axi"
  modelName AxiGluon = "Axigluon_AV_MG"
  paramCard4Model AxiGluon = "param_card_axigluon.dat"
  paramCardSetup tpath AxiGluon (AxiGluonParam m gvq gvt gaq gat) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("maxi" , (printf "%.4e" m :: String))
                 , ("gvq"  , (printf "%.4e" gvq :: String))
                 , ("gvt"  , (printf "%.4e" gvt :: String))
                 , ("gaq"  , (printf "%.4e" gaq :: String))
                 , ("gat"  , (printf "%.4e" gat :: String))
                 , ("waxi", (printf "%.4e" (gammaAxigluon 0.118 m gvq gvt gaq gat) :: String)) ]
                 (paramCard4Model AxiGluon) ) ++ "\n\n\n"
  briefParamShow (AxiGluonParam m gvq gvt gaq gat)  
    = "M"++show m++"Vq"++show gvq ++ "Vt"++show gvt 
      ++ "Aq" ++ show gaq ++ "At" ++ show gat 
      
gammaAxigluon :: Double -> Double -> Double -> Double -> Double -> Double -> Double
gammaAxigluon  alphas mass gvq gvt gaq gat = 
  alphas / 3.0 * mass * (gvt^(2 :: Int) + gat^(2 :: Int) 
                         + 2.0 * ( gvq^(2 :: Int) + gaq^(2 :: Int) ) )

