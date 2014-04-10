{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.Axino
-- Copyright   : (c) 2012-2014 Ian-Woo Kim, 2014 Christopher Redino
--
-- License     : BSD3
-- Maintainer  : Ian-Woo Kim <ianwookim@gmail.com>
-- Stability   : experimental
-- Portability : GHC
--
-- Axino Model
-- 
-----------------------------------------------------------------------------

module HEP.Automation.MadGraph.Model.Axino where

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
data Axino = Axino 
             deriving (Show, Typeable, Data)

instance Model Axino where 
  data ModelParam Axino = AxinoParam { mgluino :: Double 
                                     , msquark :: Double
                                     , maxino :: Double
			             , fpqscale :: Double
                                     , mneut :: Double } 
                          deriving Show 
  briefShow Axino = "Axino"
  madgraphVersion _ = MadGraph5
  modelName _ = "Axino"
  modelFromString str = case str of 
                          "Axino" -> Just Axino 
                          _ -> Nothing 
  paramCard4Model Axino = "param_card_Axino.dat"
  paramCardSetup tpath Axino (AxinoParam mg msq mxa fpq mn) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("mgluino", (printf "%.4e" mg :: String))
                 , ("msquark", (printf "%.4e" msq :: String))
                 , ("maxino", (printf "%.4e" mxa :: String))
                 , ("fpqscale", (printf "%.4e" fpq :: String))
                 , ("mneut",   (printf "%.4e" mn :: String)) ]
                 (paramCard4Model Axino) ) ++ "\n\n\n"
  briefParamShow (AxinoParam mg msq fpq mxa mn) = "MG"++show mg++"MQ"++show msq ++ "MXA" ++ show mxa ++ "FPQ"++show fpq++ "MN"++show mn
  interpreteParam str = let r = parse axinoParse "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
axinoParse :: ParsecT String () Identity (ModelParam Axino)
axinoParse = do 
  string "MG"
  mgstr <- many1 (oneOf "+-0123456789.")
  string "MQ"
  mqstr <- many1 (oneOf "+-0123456789.")
  string "MXA"
  mxastr <- many1 (oneOf "+-0123456789.")
  string "FPQ"
  fpqstr <- many1 (oneOf "+-0123456789.")
  string "MN"
  mnstr <- many1 (oneOf "+-0123456789.") 
  return (AxinoParam (read mgstr) (read mqstr) (read mxastr) (read mnstr) (read fpqstr))

