{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving, RecordWildCards #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.SimplifiedSUSY
-- Copyright   : (c) 2013 Ian-Woo Kim
--
-- License     : BSD3
-- Maintainer  : Ian-Woo Kim <ianwookim@gmail.com>
-- Stability   : experimental
-- Portability : GHC
--
-- Simplified SUSY
-- 
-----------------------------------------------------------------------------

module HEP.Automation.MadGraph.Model.SimplifiedSUSY where

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
data SimplifiedSUSY = SimplifiedSUSY
             deriving (Show, Typeable, Data)

instance Model SimplifiedSUSY where 
  data ModelParam SimplifiedSUSY = 
         SimplifiedSUSYParam { mneut   :: Double
                             , mgluino :: Double
                             , msquark :: Double }
                          deriving Show 
  briefShow SimplifiedSUSY = "SimplifiedSUSY"
  madgraphVersion _ = MadGraph5
  modelName _ = "SimplifiedSUSY"
  modelFromString str = case str of 
                          "SimplifiedSUSY" -> Just SimplifiedSUSY 
                          _ -> Nothing 
  paramCard4Model SimplifiedSUSY = "param_card_SimplifiedSUSY.dat"
  paramCardSetup tpath SimplifiedSUSY SimplifiedSUSYParam {..} = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("mneut"  , printf "%.4e" mneut   :: String)
                 , ("mgluino", printf "%.4e" mgluino :: String)
                 , ("msquark", printf "%.4e" msquark :: String)
                 ] 
                 (paramCard4Model SimplifiedSUSY) ) ++ "\n\n\n"
  briefParamShow SimplifiedSUSYParam {..} = "MN"++show mneut 
                                            ++"MG"++show mgluino
                                            ++"MSQ"++show msquark
  interpreteParam str = let r = parse simplifiedSUSYparse "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
simplifiedSUSYparse :: ParsecT String () Identity (ModelParam SimplifiedSUSY)
simplifiedSUSYparse = do 
  string "MN"
  mnstr <- many1 (oneOf "+-0123456789.")
  string "MG"
  mgstr <- many1 (oneOf "+-0123456789.")
  string "MSQ"
  msqstr <- many1 (oneOf "+-0123456789.")
  return (SimplifiedSUSYParam (read mnstr) (read mgstr) (read msqstr))

-----------------------------
-- for type representation 
-----------------------------

-- | 
simplifiedSUSYTr :: TypeRep 
simplifiedSUSYTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.SimplifiedSUSY.SimplifiedSUSY") []

-- | 
instance Typeable (ModelParam SimplifiedSUSY) where
  typeOf _ = mkTyConApp modelParamTc [simplifiedSUSYTr]

-- | 
deriving instance Data (ModelParam SimplifiedSUSY)