{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.AxiGluon
-- Copyright   : (c) 2011, 2012 Ian-Woo Kim
--
-- License     : BSD3
-- Maintainer  : Ian-Woo Kim <ianwookim@gmail.com>
-- Stability   : experimental
-- Portability : GHC
--
-- Axigluon model 
-- 
-----------------------------------------------------------------------------

module HEP.Automation.MadGraph.Model.AxiGluon where

import Control.Monad.Identity
import Data.Typeable
import Data.Data
import Text.Parsec
import Text.Printf
import Text.StringTemplate
import Text.StringTemplate.Helpers
-- from hep-platform 
import HEP.Automation.MadGraph.Model

-- | 
data AxiGluon = AxiGluon
              deriving (Show, Typeable, Data)


instance Model AxiGluon where
  data ModelParam AxiGluon = AxiGluonParam { massAxiG :: Double, 
                                             gVq :: Double , 
                                             gVt :: Double , 
                                             gAq :: Double , 
                                             gAt :: Double }  
                           deriving Show 
  briefShow AxiGluon = "Axi"
  madgraphVersion _ = MadGraph4
  modelName AxiGluon = "Axigluon_AV_MG"
  modelFromString str = case str of 
                          "Axigluon_AV_MG" -> Just AxiGluon
                          _ -> Nothing
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
  interpreteParam str = let r = parse axigluonparse "" str
                        in case r of
                          Right param -> param
                          Left err -> error (show err)      

axigluonparse :: ParsecT String () Identity (ModelParam AxiGluon)
axigluonparse = do 
  char 'M'
  massstr <- many1 ( oneOf "+-0123456789." )
  string "Vq"
  gvqstr <- many1 ( oneOf "+-0123456789." ) 
  string "Vt"
  gvtstr <- many1 ( oneOf "+-0123456789." )   
  string "Aq" 
  gaqstr <- many1 ( oneOf "+-0123456789." ) 
  string "At" 
  gatstr <- many1 ( oneOf "+-0123456789." )
  return (AxiGluonParam (read massstr) (read gvqstr) (read gvtstr) 
                        (read gaqstr) (read gatstr))

gammaAxigluon :: Double -> Double -> Double -> Double -> Double -> Double -> Double
gammaAxigluon  alphas mass gvq gvt gaq gat = 
  alphas / 3.0 * mass * (gvt^(2 :: Int) + gat^(2 :: Int) 
                         + 2.0 * ( gvq^(2 :: Int) + gaq^(2 :: Int) ) )

axiGluonTr :: TypeRep 
axiGluonTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.AxiGluon.AxiGluon") []

instance Typeable (ModelParam AxiGluon) where
  typeOf _ = mkTyConApp modelParamTc [axiGluonTr]

deriving instance Data (ModelParam AxiGluon)





