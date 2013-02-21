{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving, RecordWildCards #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.ADMXQLD211
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

module HEP.Automation.MadGraph.Model.ADMXQLD211 where

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
data ADMXQLD211 = ADMXQLD211
             deriving (Show, Typeable, Data)

instance Model ADMXQLD211 where 
  data ModelParam ADMXQLD211 = ADMXQLD211Param { mstop  :: Double
                                               , mgluino :: Double
                                               , msquark :: Double 
                                               }
                          deriving Show 
  briefShow ADMXQLD211 = "ADMXQLD211"
  madgraphVersion _ = MadGraph5
  modelName _ = "ADMXQLD211"
  modelFromString str = case str of 
                          "ADMXQLD211" -> Just ADMXQLD211 
                          _ -> Nothing 
  paramCard4Model ADMXQLD211 = "param_card_ADMXQLD211.dat"
  paramCardSetup tpath ADMXQLD211 ADMXQLD211Param {..} = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("mstop"  , printf "%.4e" mstop   :: String)
                 , ("mgluino", printf "%.4e" mgluino :: String)
                 , ("msquark", printf "%.4e" msquark :: String)
                 ] 
                 (paramCard4Model ADMXQLD211) ) ++ "\n\n\n"
  briefParamShow ADMXQLD211Param {..} = "MST"++show mstop++"MG"++show mgluino++"MSQ"++show msquark  
  interpreteParam str = let r = parse xqld211parse "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
xqld211parse :: ParsecT String () Identity (ModelParam ADMXQLD211)
xqld211parse = do 
  string "MST"
  mststr <- many1 (oneOf "+-0123456789.")
  string "MG"
  mgstr <- many1 (oneOf "+-0123456789.")
  string "MSQ"
  msqstr <- many1 (oneOf "+-0123456789.")
  return (ADMXQLD211Param (read mststr) (read mgstr) (read msqstr))

-----------------------------
-- for type representation 
-----------------------------

-- | 
admxqld211Tr :: TypeRep 
admxqld211Tr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.ADMXQLD211.ADMXQLD211") []

-- | 
instance Typeable (ModelParam ADMXQLD211) where
  typeOf _ = mkTyConApp modelParamTc [admxqld211Tr]

-- | 
deriving instance Data (ModelParam ADMXQLD211)
