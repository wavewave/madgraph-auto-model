{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving, RecordWildCards #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.ADMXUDD112degen
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

module HEP.Automation.MadGraph.Model.ADMXUDD112degen where

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
data ADMXUDD112degen = ADMXUDD112degen
             deriving (Show, Typeable, Data)

instance Model ADMXUDD112degen where 
  data ModelParam ADMXUDD112degen = ADMXUDD112degenParam { mgluino :: Double
                                               , msquark :: Double 
                                               , mslepton :: Double 
                                               , mneut :: Double }
                          deriving Show 
  briefShow ADMXUDD112degen = "ADMXUDD112degen"
  madgraphVersion _ = MadGraph5
  modelName _ = "ADMXUDD112degen"
  modelFromString str = case str of 
                          "ADMXUDD112degen" -> Just ADMXUDD112degen 
                          _ -> Nothing 
  paramCard4Model ADMXUDD112degen = "param_card_ADMXUDD112degen.dat"
  paramCardSetup tpath ADMXUDD112degen ADMXUDD112degenParam {..} = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("mgluino", printf "%.4e" mgluino :: String)
                 , ("msquark", printf "%.4e" msquark :: String)
                 , ("msquarkheavy" , (printf "%.4e" (msquark + 5.0) :: String)) 
                 , ("mslepton", printf "%.4e" mslepton :: String)
                 , ("mneut", printf "%.4e" mneut :: String)
                 ] 
                 (paramCard4Model ADMXUDD112degen) ) ++ "\n\n\n"
  briefParamShow ADMXUDD112degenParam {..} = "MG"++show mgluino
                                        ++ "MQ"++show msquark 
                                        ++ "ML"++show mslepton
                                        ++ "MN"++show mneut 
  interpreteParam str = let r = parse xudd112degenparse "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
xudd112degenparse :: ParsecT String () Identity (ModelParam ADMXUDD112degen)
xudd112degenparse = do 
  string "MG"
  mgstr <- many1 (oneOf "+-0123456789.")
  string "MQ"
  mqstr <- many1 (oneOf "+-0123456789.")
  string "ML"
  mlstr <- many1 (oneOf "+-0123456789.")
  string "MN"
  mnstr <- many1 (oneOf "+-0123456789.") 
  return (ADMXUDD112degenParam (read mgstr) (read mqstr) (read mlstr) (read mnstr))

-----------------------------
-- for type representation 
-----------------------------

-- | 
admxudd112degenTr :: TypeRep 
admxudd112degenTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.ADMXUDD112degen.ADMXUDD112degen") []

-- | 
instance Typeable (ModelParam ADMXUDD112degen) where
  typeOf _ = mkTyConApp modelParamTc [admxudd112degenTr]

-- | 
deriving instance Data (ModelParam ADMXUDD112degen)
