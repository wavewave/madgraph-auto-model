{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.Singlet where

import Text.Printf

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

data Singlet = Singlet
  deriving Show

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
gammaTop mt mhh gtu = (gtu^(2::Int) / (64.0*pi)* mt^(3::Int) / (mhh*mhh) 
                          * ( 1- mhh*mhh/ (mt*mt))^(2::Int)
                          * ( 1+ 2.0 * mhh*mhh / (mt*mt) ))
                       + smgammatop 
    where smgammatop = 1.508336