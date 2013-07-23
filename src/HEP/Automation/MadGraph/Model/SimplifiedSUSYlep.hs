{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving, RecordWildCards #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.SimplifiedSUSYlep
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

module HEP.Automation.MadGraph.Model.SimplifiedSUSYlep where

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
data SimplifiedSUSYlep = SimplifiedSUSYlep
             deriving (Show, Typeable, Data)

instance Model SimplifiedSUSYlep where 
  data ModelParam SimplifiedSUSYlep = 
         SimplifiedSUSYlepParam { mneut   :: Double
                                , mgluino :: Double
                                , msquarkL :: Double 
                                , mchargino :: Double 
                                , mslepton :: Double
                                , mneut2 :: Double 
                                }
                          deriving Show 
  briefShow SimplifiedSUSYlep = "SimplifiedSUSYlep"
  madgraphVersion _ = MadGraph5
  modelName _ = "SimplifiedSUSYlep"
  modelFromString str = case str of 
                          "SimplifiedSUSYlep" -> Just SimplifiedSUSYlep 
                          _ -> Nothing 
  paramCard4Model SimplifiedSUSYlep = "param_card_SimplifiedSUSYlep.dat"
  paramCardSetup tpath SimplifiedSUSYlep SimplifiedSUSYlepParam {..} = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("mneut"     , printf "%.4e" mneut   :: String)
                 , ("mgluino"   , printf "%.4e" mgluino :: String)
                 , ("msquarkL"   , printf "%.4e" msquarkL :: String)
                 , ("mchargino" , printf "%.4e" mchargino :: String)
                 , ("mslepton"  , printf "%.4e" mslepton :: String)
                 , ("mneuttwo"  , printf "%.4e" mneut2 :: String) 
                 ] 
                 (paramCard4Model SimplifiedSUSYlep) ) ++ "\n\n\n"
  briefParamShow SimplifiedSUSYlepParam {..} =  "N" ++ show mneut 
                                             ++ "G" ++ show mgluino
                                             ++ "QL" ++ show msquarkL
                                             ++ "C" ++ show mchargino
                                             ++ "L" ++ show mslepton
                                             ++ "NN" ++ show mneut2
  interpreteParam str = let r = parse parseSimplifiedSUSYlep "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
parseSimplifiedSUSYlep :: ParsecT String () Identity (ModelParam SimplifiedSUSYlep)
parseSimplifiedSUSYlep = do 
  char 'N' 
  mnstr <- many1 (oneOf "+-0123456789.")
  char 'G'
  mgstr <- many1 (oneOf "+-0123456789.")
  string "QL"
  mqlstr <- many1 (oneOf "+-0123456789.")
  char 'C'
  mcstr <- many1 (oneOf "+-0123456789.")
  char 'L' 
  mlstr <- many1 (oneOf "+-0123456789.")
  string "NN"
  mnnstr <- many1 (oneOf "+-0123456789.")
  return (SimplifiedSUSYlepParam (read mnstr) (read mgstr) (read mqlstr) (read mcstr) (read mlstr) (read mnnstr))

-----------------------------
-- for type representation 
-----------------------------

-- | 
simplifiedSUSYlepTr :: TypeRep 
simplifiedSUSYlepTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.SimplifiedSUSYlep.SimplifiedSUSYlep") []

-- | 
instance Typeable (ModelParam SimplifiedSUSYlep) where
  typeOf _ = mkTyConApp modelParamTc [simplifiedSUSYlepTr]

-- | 
deriving instance Data (ModelParam SimplifiedSUSYlep)
