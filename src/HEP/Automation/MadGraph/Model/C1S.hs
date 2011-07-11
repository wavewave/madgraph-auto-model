{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.C1S where

import Text.Printf

import Text.Parsec
import Control.Monad.Identity

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

import System.FilePath ((</>))

data C1S = C1S
         deriving Show

instance Model C1S where
  data ModelParam C1S = C1SParam { mnp :: Double, gnpR :: Double, gnpL :: Double } 
                      deriving Show
  briefShow _ = "C1S"
  madgraphVersion _ = MadGraph5
  modelName _ = "C1S_UFO"
  modelFromString str = case str of 
                          "C1S_UFO" -> Just C1S
                          _ -> Nothing
  paramCard4Model C1S  = "param_card_C1S.dat" 
  paramCardSetup tpath C1S (C1SParam m gR gL) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("mnp"  , (printf "%.4e" m :: String))
                 , ("gnpR" , (printf "%.4e" gR :: String))
                 , ("gnpL" , (printf "%.4e" gL :: String)) ]
                 (paramCard4Model C1S) ) ++ "\n\n\n"
  briefParamShow (C1SParam m gR gL) = "M"++show m++"GR"++show gR++"GL"++show gL
  interpreteParam str = let r = parse c1sparse "" str 
                        in case r of 
                          Right param -> param 
                          Left err -> error (show err)

c1sparse :: ParsecT String () Identity (ModelParam C1S) 
c1sparse = do 
  char 'M' 
  massstr <- many1 (oneOf "+-0123456789.")
  string "GR"
  grstr <- many1 (oneOf "+-0123456789.")
  string "GL"
  glstr <- many1 (oneOf "+-0123456789.")
  return (C1SParam (read massstr) (read grstr) (read glstr))








