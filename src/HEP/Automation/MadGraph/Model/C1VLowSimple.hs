{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

module HEP.Automation.MadGraph.Model.C1VLowSimple where

import Data.Typeable
import Data.Data

import Text.Printf

import Text.Parsec
import Control.Monad.Identity

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

data C1VLowSimple = C1VLowSimple
         deriving (Show, Typeable, Data)

instance Model C1VLowSimple where
  data ModelParam C1VLowSimple 
         = C1VLowSimpleParam { mphi :: Double
                             , gtuR :: Double
                             , gtuL :: Double 
                             , guuR :: Double 
                             , guuL :: Double 
                             , gttR :: Double
                             , gttL :: Double 
                             } 
                      deriving Show
  briefShow _ = "C1VLowSmp"
  madgraphVersion _ = MadGraph5
  modelName _ = "C1VLowSimple_UFO"
  modelFromString str = case str of 
                          "C1VLowSimple_UFO" -> Just C1VLowSimple
                          _ -> Nothing
  paramCard4Model C1VLowSimple  = "param_card_C1VLowSimple.dat" 
  paramCardSetup tpath C1VLowSimple (C1VLowSimpleParam m gtuR' gtuL' guuR' guuL' gttR' gttL') = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("mphi"  , (printf "%.4e" m :: String))
                 , ("gtuR" , (printf "%.4e" gtuR' :: String))
                 , ("gtuL" , (printf "%.4e" gtuL' :: String))
                 , ("guuR" , (printf "%.4e" guuR' :: String)) 
                 , ("guuL" , (printf "%.4e" guuL' :: String))
                 , ("gttR" , (printf "%.4e" gttR' :: String)) 
                 , ("gttL" , (printf "%.4e" gttL' :: String))
                 , ("wphi"  , (printf "%.4e" (gammanp m gtuR' gtuL' guuR' guuL') :: String)) ]
                 (paramCard4Model C1VLowSimple) ) ++ "\n\n\n"
  briefParamShow (C1VLowSimpleParam m gtuR' gtuL' guuR' guuL' gttR' gttL') = 
    "M"++show m++"GTUR"++show gtuR'++"GTUL"++show gtuL'++"GUUR"++show guuR'++"GUUL"++show guuL'++"GTTR"++show gttR'++"GTTL"++show gttL' 
  interpreteParam str = let r = parse c1vlowsmpparse "" str 
                        in case r of 
                          Right param -> param 
                          Left err -> error (show err)

c1vlowsmpparse :: ParsecT String () Identity (ModelParam C1VLowSimple) 
c1vlowsmpparse = do 
  char 'M' 
  massstr <- many1 (oneOf "+-0123456789.")
  string "GTUR"
  gtuRstr <- many1 (oneOf "+-0123456789.")
  string "GTUL"
  gtuLstr <- many1 (oneOf "+-0123456789.")
  string "GUUR"
  guuRstr <- many1 (oneOf "+-0123456789.")
  string "GUUL"
  guuLstr <- many1 (oneOf "+-0123456789.")
  string "GTTR"
  gttRstr <- many1 (oneOf "+-0123456789.")
  string "GTTL"
  gttLstr <- many1 (oneOf "+-0123456789.")
  return (C1VLowSimpleParam (read massstr) (read gtuRstr) (read gtuLstr)
                            (read guuRstr) (read guuLstr) (read gttRstr) (read gttLstr))

-- mtop :: Double 
-- mtop = 172.0

gammanp :: Double -> Double -> Double -> Double -> Double -> Double 
gammanp m gtuR gtuL guuR guuL = 
  let gammauu = 3.0 * m/(8.0*pi) * (guuR^(2::Int)+guuL^(2::Int))/2.0
      gammatu = if m > mtop
                 then 3.0 * m/(8.0*pi) * (gtuR^(2::Int)+gtuL^(2::Int))/2.0 
                          * (1.0 - (mtop^(2::Int))/(m^(2::Int))) 
                 else 0
  in  gammauu + gammatu 

c1VLowSmpTr :: TypeRep 
c1VLowSmpTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.C1VLowSimple.C1VLowSimple") []

instance Typeable (ModelParam C1VLowSimple) where
  typeOf _ = mkTyConApp modelParamTc [c1VLowSmpTr]

deriving instance Data (ModelParam C1VLowSimple)





