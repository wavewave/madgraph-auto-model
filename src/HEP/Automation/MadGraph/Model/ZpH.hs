{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

module HEP.Automation.MadGraph.Model.ZpH where

import Data.Typeable
import Data.Data

import Text.Printf

import Text.Parsec
import Control.Monad.Identity

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

data ZpH = ZpH
         deriving (Show, Typeable, Data)

instance Model ZpH where
  data ModelParam ZpH = ZpHParam { massZp :: Double, gRZp :: Double } 
                      deriving Show
  briefShow ZpH = "Zp"
  madgraphVersion _ = MadGraph4
  modelName ZpH = "zHorizontal_MG"
  modelFromString str = case str of 
                          "zHorizontal_MG" -> Just ZpH
                          _ -> Nothing
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
  interpreteParam str = let r = parse zphparse "" str 
                        in case r of 
                          Right param -> param 
                          Left err -> error (show err)

zphparse :: ParsecT String () Identity (ModelParam ZpH) 
zphparse = do 
  char 'M' 
  massstr <- many1 (oneOf "+-0123456789.")
  char 'G'
  gstr <- many1 (oneOf "+-0123456789.")
  return (ZpHParam (read massstr) (read gstr))

gammaWpZp :: Double -> Double -> Double            
gammaWpZp mass coup = 
  let r = mtop^(2 :: Int)/ mass^(2 :: Int)  
  in  coup^(2 :: Int) / (16.0 * pi) *mass*( 1.0 - 1.5 * r + 0.5 * r^(3 :: Int))

zpHTr :: TypeRep 
zpHTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.ZpH.ZpH") []

instance Typeable (ModelParam ZpH) where
  typeOf _ = mkTyConApp modelParamTc [zpHTr]

deriving instance Data (ModelParam ZpH)





