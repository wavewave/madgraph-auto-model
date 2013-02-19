{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving, RecordWildCards #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.ADMXQLD311
-- Copyright   : (c) 2013 Ian-Woo Kim
--
-- License     : BSD3
-- Maintainer  : Ian-Woo Kim <ianwookim@gmail.com>
-- Stability   : experimental
-- Portability : GHC
--
-- ADM (asymmetric dark matter) XUDD model
-- 
-----------------------------------------------------------------------------

module HEP.Automation.MadGraph.Model.ADMXQLD311 where

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
data ADMXQLD311 = ADMXQLD311
             deriving (Show, Typeable, Data)

instance Model ADMXQLD311 where 
  data ModelParam ADMXQLD311 = ADMXQLD311Param { mstop  :: Double
                                               , mgluino :: Double
                                               , msquark :: Double }
                          deriving Show 
  briefShow ADMXQLD311 = "ADMXQLD311"
  madgraphVersion _ = MadGraph5
  modelName _ = "ADMXQLD311"
  modelFromString str = case str of 
                          "ADMXQLD311" -> Just ADMXQLD311 
                          _ -> Nothing 
  paramCard4Model ADMXQLD311 = "param_card_ADMXQLD311.dat"
  paramCardSetup tpath ADMXQLD311 ADMXQLD311Param {..} = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("mstop"  , printf "%.4e" mstop   :: String)
                 , ("mgluino", printf "%.4e" mgluino :: String)
                 , ("msquark", printf "%.4e" msquark :: String)
                 ] 
                 (paramCard4Model ADMXQLD311) ) ++ "\n\n\n"
  briefParamShow ADMXQLD311Param {..} = "MST"++show mstop++"MG"++show mgluino++"MSQ"++show msquark
  interpreteParam str = let r = parse xqld311parse "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
xqld311parse :: ParsecT String () Identity (ModelParam ADMXQLD311)
xqld311parse = do 
  string "MST"
  mststr <- many1 (oneOf "+-0123456789.")
  string "MG"
  mgstr <- many1 (oneOf "+-0123456789.")
  string "MSQ"
  msqstr <- many1 (oneOf "+-0123456789.")
  return (ADMXQLD311Param (read mststr) (read mgstr) (read msqstr))

-----------------------------
-- for type representation 
-----------------------------

-- | 
admxqld311Tr :: TypeRep 
admxqld311Tr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.ADMXQLD311.ADMXQLD311") []

-- | 
instance Typeable (ModelParam ADMXQLD311) where
  typeOf _ = mkTyConApp modelParamTc [admxqld311Tr]

-- | 
deriving instance Data (ModelParam ADMXQLD311)