{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

module HEP.Automation.MadGraph.Model.C8V where

import Data.Typeable
import Data.Data

import Text.Printf

import Text.Parsec
import Control.Monad.Identity

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

data C8V = C8V
         deriving (Show, Typeable, Data)

instance Model C8V where
  data ModelParam C8V = C8VParam { mnp :: Double, gnpR :: Double, gnpL :: Double } 
                      deriving Show
  briefShow _ = "C8V"
  madgraphVersion _ = MadGraph5
  modelName _ = "C8V_UFO"
  modelFromString str = case str of 
                          "C8V_UFO" -> Just C8V
                          _ -> Nothing
  paramCard4Model C8V  = "param_card_C8V.dat" 
  paramCardSetup tpath C8V (C8VParam m gR gL) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("mnp"  , (printf "%.4e" m :: String))
                 , ("gnpR" , (printf "%.4e" gR :: String))
                 , ("gnpL" , (printf "%.4e" gL :: String)) 
                 , ("wnp"  , (printf "%.4e" (gammanp m gR gL) :: String)) ]
                 (paramCard4Model C8V) ) ++ "\n\n\n"
  briefParamShow (C8VParam m gR gL) = "M"++show m++"GR"++show gR++"GL"++show gL
  interpreteParam str = let r = parse c8vparse "" str 
                        in case r of 
                          Right param -> param 
                          Left err -> error (show err)

c8vparse :: ParsecT String () Identity (ModelParam C8V) 
c8vparse = do 
  char 'M' 
  massstr <- many1 (oneOf "+-0123456789.")
  string "GR"
  grstr <- many1 (oneOf "+-0123456789.")
  string "GL"
  glstr <- many1 (oneOf "+-0123456789.")
  return (C8VParam (read massstr) (read grstr) (read glstr))

-- mtop :: Double 
-- mtop = 172.0

gammanp :: Double -> Double -> Double -> Double 
gammanp m gr gl = 
  1.0/6.0 * m/(4.0*pi) * (gr^(2::Int)+gl^(2::Int))/2.0 
                       * (1.0-(mtop^(2::Int))/(m^(2::Int)))^(2::Int)
                       * (1.0+0.5*(mtop^(2::Int))/(m^(2::Int)))

c8VTr :: TypeRep 
c8VTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.C8V.C8V") []

instance Typeable (ModelParam C8V) where
  typeOf _ = mkTyConApp modelParamTc [c8VTr]

deriving instance Data (ModelParam C8V)
                      







