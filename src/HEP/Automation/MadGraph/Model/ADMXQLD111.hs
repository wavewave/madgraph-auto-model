{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.ADMXQLD
-- Copyright   : (c) 2012,2013 Ian-Woo Kim
--
-- License     : BSD3
-- Maintainer  : Ian-Woo Kim <ianwookim@gmail.com>
-- Stability   : experimental
-- Portability : GHC
--
-- ADM (asymmetric dark matter) XQLD model, 111 generation
-- 
-----------------------------------------------------------------------------

module HEP.Automation.MadGraph.Model.ADMXQLD111 where

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
data ADMXQLD111 = ADMXQLD111 
             deriving (Show, Typeable, Data)

instance Model ADMXQLD111 where 
  data ModelParam ADMXQLD111 = ADMXQLD111Param { mgluino :: Double 
                                         , msquark :: Double
                                         , mslepton :: Double
                                         , mneut :: Double } 
                          deriving Show 
  briefShow ADMXQLD111 = "ADMXQLD111"
  madgraphVersion _ = MadGraph5
  modelName _ = "ADMXQLD111"
  modelFromString str = case str of 
                          "ADMXQLD111" -> Just ADMXQLD111 
                          _ -> Nothing 
  paramCard4Model ADMXQLD111 = "param_card_ADMXQLD111.dat"
  paramCardSetup tpath ADMXQLD111 (ADMXQLD111Param mg msq msl mn) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("mgluino", (printf "%.4e" mg :: String))
                 , ("msquark", (printf "%.4e" msq :: String))
                 , ("mslepton", (printf "%.4e" msl :: String))
                 , ("mneut",   (printf "%.4e" mn :: String)) ]
                 (paramCard4Model ADMXQLD111) ) ++ "\n\n\n"
  briefParamShow (ADMXQLD111Param mg msq msl mn) = "MG"++show mg++"MQ"++show msq ++ "ML" ++ show msl ++ "MN"++show mn
  interpreteParam str = let r = parse xqldparse "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
xqldparse :: ParsecT String () Identity (ModelParam ADMXQLD111)
xqldparse = do 
  string "MG"
  mgstr <- many1 (oneOf "+-0123456789.")
  string "MQ"
  mqstr <- many1 (oneOf "+-0123456789.")
  string "ML"
  mlstr <- many1 (oneOf "+-0123456789.")
  string "MN"
  mnstr <- many1 (oneOf "+-0123456789.") 
  return (ADMXQLD111Param (read mgstr) (read mqstr) (read mlstr) (read mnstr))

-----------------------------
-- for type representation 
-----------------------------

{-
-- | 
admxqldTr :: TypeRep 
admxqldTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.ADMXQLD111.ADMXQLD111") []

-- | 
instance Typeable (ModelParam ADMXQLD111) where
  typeOf _ = mkTyConApp modelParamTc [admxqldTr]

-}


deriving instance Data (ModelParam ADMXQLD111)
