{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.C8S where

import Text.Printf

import Text.Parsec
import Control.Monad.Identity

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

import System.FilePath ((</>))

data C8S = C8S
         deriving Show

instance Model C8S where
  data ModelParam C8S = C8SParam { mnp :: Double, gnpR :: Double, gnpL :: Double } 
                      deriving Show
  briefShow _ = "C8S"
  madgraphVersion _ = MadGraph5
  modelName _ = "C8S_UFO"
  modelFromString str = case str of 
                          "C8S_UFO" -> Just C8S
                          _ -> Nothing
  paramCard4Model C8S  = "param_card_C8S.dat" 
  paramCardSetup tpath C8S (C8SParam m gR gL) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("mnp"  , (printf "%.4e" m :: String))
                 , ("gnpR" , (printf "%.4e" gR :: String))
                 , ("gnpL" , (printf "%.4e" gL :: String)) 
                 , ("wnp"  , (printf "%.4e" (gammanp m gR gL) :: String)) ]
                 (paramCard4Model C8S) ) ++ "\n\n\n"
  briefParamShow (C8SParam m gR gL) = "M"++show m++"GR"++show gR++"GL"++show gL
  interpreteParam str = let r = parse c8sparse "" str 
                        in case r of 
                          Right param -> param 
                          Left err -> error (show err)

c8sparse :: ParsecT String () Identity (ModelParam C8S) 
c8sparse = do 
  char 'M' 
  massstr <- many1 (oneOf "+-0123456789.")
  string "GR"
  grstr <- many1 (oneOf "+-0123456789.")
  string "GL"
  glstr <- many1 (oneOf "+-0123456789.")
  return (C8SParam (read massstr) (read grstr) (read glstr))

-- mtop :: Double 
-- mtop = 172.0

gammanp :: Double -> Double -> Double -> Double 
gammanp m gr gl = 
  1.0/2.0 * m/(8.0*pi) * (gr^(2::Int)+gl^(2::Int))/2.0
                       * (1.0-(mtop^(2::Int))/(m^(2::Int)))





