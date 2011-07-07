{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.Wp where

import Control.Monad.Identity

import Text.Parsec 
import Text.Printf

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

data Wp = Wp
        deriving Show
           
instance Model Wp where
  data ModelParam Wp = WpParam { massWp :: Double, gRWp :: Double } 
    deriving Show
  briefShow Wp = "Wp"
  modelName Wp = "fvwp200_MG"
  modelFromString str = case str of 
                          "fvwp200_MG" -> Just Wp
                          _ -> Nothing
  paramCard4Model Wp   = "param_card_wP.dat"
  paramCardSetup tpath Wp (WpParam m g) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("massWp"       , (printf "%.4e" m :: String))
                 , ("gRWpoverSqrtTwo", (printf "%.4e" (g / (sqrt 2.0)) :: String))  
                 , ("widthWp"      , (printf "%.4e" (gammaWpZp m g) :: String)) ]  
                 (paramCard4Model Wp)  ) ++ "\n\n\n"
  briefParamShow (WpParam  m g) = "M"++show m++"G"++show g
  interpreteParam str = let r = parse wpparse "" str 
                        in case r of 
                          Right param -> param 
                          Left err -> error (show err)

wpparse :: ParsecT String () Identity (ModelParam Wp) 
wpparse = do 
  char 'M' 
  massstr <- many1 (oneOf "+-0123456789.")
  char 'G'
  gstr <- many1 (oneOf "+-0123456789.")
  return (WpParam (read massstr) (read gstr))

gammaWpZp :: Double -> Double -> Double            
gammaWpZp mass coup = 
  let r = mtop^(2 :: Int)/ mass^(2 :: Int)  
  in  coup^(2 :: Int) / (16.0 * pi) *mass*( 1.0 - 1.5 * r + 0.5 * r^(3 :: Int))
