{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

-----------------------------------------------------------------------------
-- |
-- Module      : HEP.Automation.MadGraph.Model.ADMXQLDlight
-- Copyright   : (c) 2012,2013 Ian-Woo Kim
--
-- License     : BSD3
-- Maintainer  : Ian-Woo Kim <ianwookim@gmail.com>
-- Stability   : experimental
-- Portability : GHC
--
-- ADM (asymmetric dark matter) XQLD model, same coupling and mass for 1st and 2nd generation
-- 
-----------------------------------------------------------------------------

module HEP.Automation.MadGraph.Model.ADMXQLDlight where

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
data ADMXQLDlight = ADMXQLDlight 
             deriving (Show, Typeable, Data)

instance Model ADMXQLDlight where 
  data ModelParam ADMXQLDlight = ADMXQLDlightParam { mgluino :: Double 
                                         , msquark :: Double
                                         , mslepton :: Double
                                         , mneut :: Double } 
                          deriving Show 
  briefShow ADMXQLDlight = "ADMXQLDlight"
  madgraphVersion _ = MadGraph5
  modelName _ = "ADMXQLDlight"
  modelFromString str = case str of 
                          "ADMXQLDlight" -> Just ADMXQLDlight 
                          _ -> Nothing 
  paramCard4Model ADMXQLDlight = "param_card_ADMXQLDlight.dat"
  paramCardSetup tpath ADMXQLDlight (ADMXQLDlightParam mg msq msl mn) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup 
                 templates 
                 [ ("mgluino", (printf "%.4e" mg :: String))
                 , ("msquark", (printf "%.4e" msq :: String))
                 , ("mslepton", (printf "%.4e" msl :: String))
                 , ("mneut",   (printf "%.4e" mn :: String)) ]
                 (paramCard4Model ADMXQLDlight) ) ++ "\n\n\n"
  briefParamShow (ADMXQLDlightParam mg msq msl mn) = "MG"++show mg++"MQ"++show msq ++ "ML" ++ show msl ++ "MN"++show mn
  interpreteParam str = let r = parse xqldparse "" str 
                        in case r of
                          Right param -> param 
                          Left err -> error (show err)

-- | 
xqldparse :: ParsecT String () Identity (ModelParam ADMXQLDlight)
xqldparse = do 
  string "MG"
  mgstr <- many1 (oneOf "+-0123456789.")
  string "MQ"
  mqstr <- many1 (oneOf "+-0123456789.")
  string "ML"
  mlstr <- many1 (oneOf "+-0123456789.")
  string "MN"
  mnstr <- many1 (oneOf "+-0123456789.") 
  return (ADMXQLDlightParam (read mgstr) (read mqstr) (read mlstr) (read mnstr))

-----------------------------
-- for type representation 
-----------------------------

-- | 
admxqldTr :: TypeRep 
admxqldTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.ADMXQLDlight.ADMXQLDlight") []

-- | 
instance Typeable (ModelParam ADMXQLDlight) where
  typeOf _ = mkTyConApp modelParamTc [admxqldTr]

-- | 
deriving instance Data (ModelParam ADMXQLDlight)
