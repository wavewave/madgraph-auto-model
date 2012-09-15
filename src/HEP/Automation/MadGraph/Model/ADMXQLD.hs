{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.ADMXQLD
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

module HEP.Automation.MadGraph.Model.ADMXQLD where

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
data ADMXQLD = ADMXQLD 
             deriving (Show, Typeable, Data)

instance Model ADMXQLD where 
  data ModelParam ADMXQLD = ADMXQLDParam { mgluino :: Double 
                                         , msquark :: Double
                                         , mslepton :: Double
                                         , mneut :: Double } 
                          deriving Show 
  briefShow ADMXQLD = "ADMXQLD"
  madgraphVersion _ = MadGraph5
  modelName _ = "ADMXQLD"
  modelFromString str = case str of 
                          "ADMXQLD" -> Just ADMXQLD 
                          _ -> Nothing 
  paramCard4Model ADMXQLD = "param_card_ADMXQLD.dat"
  paramCardSetup tpath ADMXQLD (ADMXQLDParam mg msq msl mn) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("mgluino", (printf "%.4e" mg :: String))
                 , ("msquark", (printf "%.4e" msq :: String))
                 , ("mslepton", (printf "%.4e" msl :: String))
                 , ("mneut",   (printf "%.4e" mn :: String)) ]
                 (paramCard4Model ADMXQLD) ) ++ "\n\n\n"
  briefParamShow (ADMXQLDParam mg msq msl mn) = "MG"++show mg++"MQ"++show msq ++ "ML" ++ show msl ++ "MN"++show mn
  interpreteParam str = let r = parse xqldparse "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
xqldparse :: ParsecT String () Identity (ModelParam ADMXQLD)
xqldparse = do 
  string "MG"
  mgstr <- many1 (oneOf "+-0123456789.")
  string "MQ"
  mqstr <- many1 (oneOf "+-0123456789.")
  string "ML"
  mlstr <- many1 (oneOf "+-0123456789.")
  string "MN"
  mnstr <- many1 (oneOf "+-0123456789.") 
  return (ADMXQLDParam (read mgstr) (read mqstr) (read mlstr) (read mnstr))

-----------------------------
-- for type representation 
-----------------------------

-- | 
admxqldTr :: TypeRep 
admxqldTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.ADMXQLD.ADMXQLD") []

-- | 
instance Typeable (ModelParam ADMXQLD) where
  typeOf _ = mkTyConApp modelParamTc [admxqldTr]

-- | 
deriving instance Data (ModelParam ADMXQLD)