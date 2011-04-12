{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.Octet where

import Text.Printf

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

data Octet = Octet
  deriving Show

instance Model Octet where
  data ModelParam Octet = OctetParam { mhh :: Double,  
                                       gtu :: Double, 
                                       gbd :: Double }
                          deriving Show
  briefShow Octet = "Octet"                             
  modelName Octet = "scalarOctet_MG" 
  paramCard4Model Octet   = "param_card_Octet.dat"
  paramCardSetup tpath Octet p = do 
    templates <- directoryGroup tpath
    return $ ( renderTemplateGroup
                 templates
                 [ ("MHH" , (printf "%.4e" (mhh p)         :: String))
                 , ("gtu", (printf "%.4e" (gtu p) :: String))
                 , ("gbd", (printf "%.4e" (gbd p) :: String))
                 , ("wTop", (printf "%.4e" (gammaTop mtop (mhh p) (gtu p)) :: String))
                 , ("WHH" , (printf "%.4e" (gammaHH (mhh p) (gbd p)) :: String))
                 ]
                 (paramCard4Model Octet  ) ) ++ "\n\n\n"
  briefParamShow p 
    = ("M" ++ show (mhh p)
       ++ "GT" ++ show (gtu p)  
       ++ "GB" ++ show (gbd p))

-- | decay width of Zprime
gammaHH :: Double       -- ^ mhh
        -> Double       -- ^ gbd
        -> Double 
gammaHH mhh gbd = gbd^(2::Int) / (16.0*pi) * mhh -- 0.5*sqrt2 => 1.49027759

-- | additional decay width of top
gammaTop :: Double   -- ^ mtop 
            -> Double   -- ^ mhh  
            -> Double   -- ^ gtu
            -> Double
gammaTop mt mhh gtu = 4.0 / 3.0 * gtu^(2::Int) / (62.0*pi)* (mt^(2::Int) - mhh^(2::Int))^(2::Int) / (mt^(3::Int))
                      + smgammatop 
    where smgammatop = 1.508336