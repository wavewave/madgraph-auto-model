{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE RecordWildCards #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.HeavyHiggs
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

module HEP.Automation.MadGraph.Model.HeavyHiggs where

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
data HeavyHiggs = HeavyHiggs
             deriving (Show, Typeable, Data)

instance Model HeavyHiggs where 
  data ModelParam HeavyHiggs 
    = HeavyHiggsParam { mhhiggs :: Double }
                          deriving Show 
  briefShow HeavyHiggs = "HeavyHiggs"
  madgraphVersion _ = MadGraph5
  modelName _ = "mssm"
  modelFromString str = case str of 
                          "HeavyHiggs" -> Just HeavyHiggs 
                          _ -> Nothing 
  paramCard4Model HeavyHiggs = "param_card_HeavyHiggs.dat"
  paramCardSetup tpath HeavyHiggs HeavyHiggsParam {..} = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("mhhiggs"  , printf "%.4e" mhhiggs :: String)
                 ] 
                 (paramCard4Model HeavyHiggs) ) ++ "\n\n\n"
  briefParamShow HeavyHiggsParam {..} = "MHH"++show mhhiggs 
  interpreteParam str = let r = parse heavyHiggsparse "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
heavyHiggsparse :: ParsecT String () Identity (ModelParam HeavyHiggs)
heavyHiggsparse = do 
  string "MHH"
  mhhstr <- many1 (oneOf "+-0123456789.")
  return (HeavyHiggsParam (read mhhstr))

-----------------------------
-- for type representation 
-----------------------------

-- | 
deriving instance Data (ModelParam HeavyHiggs)
