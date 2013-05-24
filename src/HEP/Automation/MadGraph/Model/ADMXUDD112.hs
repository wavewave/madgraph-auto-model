{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving, RecordWildCards #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.ADMXUDD112
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

module HEP.Automation.MadGraph.Model.ADMXUDD112 where

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
data ADMXUDD112 = ADMXUDD112
             deriving (Show, Typeable, Data)

instance Model ADMXUDD112 where 
  data ModelParam ADMXUDD112 = ADMXUDD112Param { mgluino :: Double
                                               , msquark :: Double 
                                               , mslepton :: Double 
                                               , mneut :: Double }
                          deriving Show 
  briefShow ADMXUDD112 = "ADMXUDD112"
  madgraphVersion _ = MadGraph5
  modelName _ = "ADMXUDD112"
  modelFromString str = case str of 
                          "ADMXUDD112" -> Just ADMXUDD112 
                          _ -> Nothing 
  paramCard4Model ADMXUDD112 = "param_card_ADMXUDD112.dat"
  paramCardSetup tpath ADMXUDD112 ADMXUDD112Param {..} = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("mgluino", printf "%.4e" mgluino :: String)
                 , ("msquark", printf "%.4e" msquark :: String)
                 , ("mslepton", printf "%.4e" mslepton :: String)
                 , ("mneut", printf "%.4e" mneut :: String)
                 ] 
                 (paramCard4Model ADMXUDD112) ) ++ "\n\n\n"
  briefParamShow ADMXUDD112Param {..} = "MG"++show mgluino
                                        ++ "MQ"++show msquark 
                                        ++ "ML"++show mslepton
                                        ++ "MN"++show mneut 
  interpreteParam str = let r = parse xudd112parse "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
xudd112parse :: ParsecT String () Identity (ModelParam ADMXUDD112)
xudd112parse = do 
  string "MG"
  mgstr <- many1 (oneOf "+-0123456789.")
  string "MQ"
  mqstr <- many1 (oneOf "+-0123456789.")
  string "ML"
  mlstr <- many1 (oneOf "+-0123456789.")
  string "MN"
  mnstr <- many1 (oneOf "+-0123456789.") 
  return (ADMXUDD112Param (read mgstr) (read mqstr) (read mlstr) (read mnstr))

-----------------------------
-- for type representation 
-----------------------------

-- | 
admxudd112Tr :: TypeRep 
admxudd112Tr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.ADMXUDD112.ADMXUDD112") []

-- | 
instance Typeable (ModelParam ADMXUDD112) where
  typeOf _ = mkTyConApp modelParamTc [admxudd112Tr]

-- | 
deriving instance Data (ModelParam ADMXUDD112)
