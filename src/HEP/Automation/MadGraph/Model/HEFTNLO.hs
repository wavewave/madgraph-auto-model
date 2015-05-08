{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE RecordWildCards #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.HEFTNLO
-- Copyright   : (c) 2015 Ian-Woo Kim
--
-- License     : BSD3
-- Maintainer  : Ian-Woo Kim <ianwookim@gmail.com>
-- Stability   : experimental
-- Portability : GHC
--
-- Simplified SUSY
-- 
-----------------------------------------------------------------------------

module HEP.Automation.MadGraph.Model.HEFTNLO where

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
data HEFTNLO = HEFTNLO
             deriving (Show, Typeable, Data)

instance Model HEFTNLO where 
  data ModelParam HEFTNLO 
    = HEFTNLOParam { mhiggs :: Double, whiggs :: Double }
                          deriving Show 
  briefShow HEFTNLO = "HEFTNLO"
  madgraphVersion _ = MadGraph5
  modelName _ = "heftNLO"
  modelFromString str = case str of 
                          "HEFTNLO" -> Just HEFTNLO 
                          _ -> Nothing 
  paramCard4Model HEFTNLO = "param_card_heftNLO.dat"
  paramCardSetup tpath HEFTNLO HEFTNLOParam {..} = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("MHIGGS", printf "%.4e" mhiggs :: String)
                 , ("WHIGGS", printf "%.4e" whiggs :: String)
                 ] 
                 (paramCard4Model HEFTNLO) ) ++ "\n\n\n"
  briefParamShow HEFTNLOParam {..} = "MH"++show mhiggs ++ "WH"++show whiggs
  interpreteParam str = let r = parse heavyHiggsparse "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
heavyHiggsparse :: ParsecT String () Identity (ModelParam HEFTNLO)
heavyHiggsparse = do 
  string "MH"
  mhstr <- many1 (oneOf "+-0123456789.")
  string "WH"
  whstr <- many1 (oneOf "+-0123456789.")
  return (HEFTNLOParam (read mhstr) (read whstr))

-----------------------------
-- for type representation 
-----------------------------

-- | 
deriving instance Data (ModelParam HEFTNLO)
