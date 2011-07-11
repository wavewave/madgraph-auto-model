{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.C8V where

import Text.Printf

import Text.Parsec
import Control.Monad.Identity

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

import System.FilePath ((</>))

data C8V = C8V
         deriving Show

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
                 , ("gnpL" , (printf "%.4e" gL :: String)) ]
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








