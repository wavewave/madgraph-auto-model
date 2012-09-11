{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.ADMXUDD
-- Copyright   : (c) 2011, 2012 Ian-Woo Kim
--
-- License     : BSD3
-- Maintainer  : Ian-Woo Kim <ianwookim@gmail.com>
-- Stability   : experimental
-- Portability : GHC
--
-- ADM (asymmetric dark matter) XUDD model
-- 
-----------------------------------------------------------------------------

module HEP.Automation.MadGraph.Model.ADMXUDD where

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
data ADMXUDD = ADMXUDD 
             deriving (Show, Typeable, Data)

instance Model ADMXUDD where 
  data ModelParam ADMXUDD = ADMXUDDParam { mgluino :: Double 
                                         , msquark :: Double
                                         , mneut :: Double } 
                          deriving Show 
  briefShow ADMXUDD = "ADMXUDD"
  madgraphVersion _ = MadGraph5
  modelName _ = "ADMXUDD"
  modelFromString str = case str of 
                          "ADMXUDD" -> Just ADMXUDD 
                          _ -> Nothing 
  paramCard4Model ADMXUDD = "param_card_ADMXUDD.dat"
  paramCardSetup tpath ADMXUDD (ADMXUDDParam mg msq mn) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("mgluino", (printf "%.4e" mg :: String))
                 , ("msquark", (printf "%.4e" msq :: String))
                 , ("mneut",   (printf "%.4e" mn :: String)) ]
                 (paramCard4Model ADMXUDD) ) ++ "\n\n\n"
  briefParamShow (ADMXUDDParam mg msq mn) = "MG"++show mg++"MQ"++show msq ++ "MN"++show mn
  interpreteParam str = let r = parse xuddparse "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
xuddparse :: ParsecT String () Identity (ModelParam ADMXUDD)
xuddparse = do 
  string "MG"
  mgstr <- many1 (oneOf "+-0123456789.")
  string "MQ"
  mqstr <- many1 (oneOf "+-0123456789.")
  string "MN"
  mnstr <- many1 (oneOf "+-0123456789.") 
  return (ADMXUDDParam (read mgstr) (read mqstr) (read mnstr))

-----------------------------
-- for type representation 
-----------------------------

-- | 
admxuddTr :: TypeRep 
admxuddTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.ADMXUDD.ADMXUDD") []

-- | 
instance Typeable (ModelParam ADMXUDD) where
  typeOf _ = mkTyConApp modelParamTc [admxuddTr]

-- | 
deriving instance Data (ModelParam ADMXUDD)