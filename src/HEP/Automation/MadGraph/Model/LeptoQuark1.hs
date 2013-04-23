{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving, RecordWildCards #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.LeptoQuark1
-- Copyright   : (c) 2013 Ian-Woo Kim
--
-- License     : BSD3
-- Maintainer  : Ian-Woo Kim <ianwookim@gmail.com>
-- Stability   : experimental
-- Portability : GHC
--
-- 1st generation leptoquark model 
-- 
-----------------------------------------------------------------------------

module HEP.Automation.MadGraph.Model.LeptoQuark1 where

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
data LeptoQuark1 = LeptoQuark1
             deriving (Show, Typeable, Data)

instance Model LeptoQuark1 where 
  data ModelParam LeptoQuark1 = 
         LeptoQuark1Param { mLQ  :: Double, thLQ :: Double }
                          deriving Show 
  briefShow LeptoQuark1 = "LeptoQuark1"
  madgraphVersion _ = MadGraph5
  modelName _ = "leptoquark1"
  modelFromString str = case str of 
                          "LeptoQuark1" -> Just LeptoQuark1
                          _ -> Nothing 
  paramCard4Model LeptoQuark1 = "param_card_LeptoQuark1.dat"
  paramCardSetup tpath LeptoQuark1 LeptoQuark1Param {..} = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("mLQ"  , printf "%.4e" mLQ   :: String)
                 , ("thLQ", printf "%.4e" thLQ :: String) 
                 ] 
                 (paramCard4Model LeptoQuark1) ) ++ "\n\n\n"
  briefParamShow LeptoQuark1Param {..} = "MLQ"++show mLQ++"THLQ"++show thLQ
  interpreteParam str = let r = parse leptoQuark1parse "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
leptoQuark1parse :: ParsecT String () Identity (ModelParam LeptoQuark1)
leptoQuark1parse = do 
  string "MLQ"
  mlqstr <- many1 (oneOf "+-0123456789.")
  string "THLQ"
  thlqstr <- many1 (oneOf "+-0123456789.")
  return (LeptoQuark1Param (read mlqstr) (read thlqstr))

-----------------------------
-- for type representation 
-----------------------------

-- | 
leptoQuark1Tr :: TypeRep 
leptoQuark1Tr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.LeptoQuark1.LeptoQuark1") []

-- | 
instance Typeable (ModelParam LeptoQuark1) where
  typeOf _ = mkTyConApp modelParamTc [leptoQuark1Tr]

-- | 
deriving instance Data (ModelParam LeptoQuark1)

