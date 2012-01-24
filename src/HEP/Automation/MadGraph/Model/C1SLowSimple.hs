{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

module HEP.Automation.MadGraph.Model.C1SLowSimple where

import Data.Typeable
import Data.Data

import Text.Printf

import Text.Parsec
import Control.Monad.Identity

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

data C1SLowSimple = C1SLowSimple
         deriving (Show, Typeable, Data)

instance Model C1SLowSimple where
  data ModelParam C1SLowSimple 
         = C1SLowSimpleParam { mnp :: Double
                             , gnpR :: Double
                             , gnpL :: Double 
                             , gnpcuR :: Double 
                             , gnpcuL :: Double } 
                      deriving Show
  briefShow _ = "C1SLowSmp"
  madgraphVersion _ = MadGraph5
  modelName _ = "C1SLowSimple_UFO"
  modelFromString str = case str of 
                          "C1SLowSimple_UFO" -> Just C1SLowSimple
                          _ -> Nothing
  paramCard4Model C1SLowSimple  = "param_card_C1SLowSimple.dat" 
  paramCardSetup tpath C1SLowSimple (C1SLowSimpleParam m gR gL gcR gcL) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("mnp"  , (printf "%.4e" m :: String))
                 , ("gnpR" , (printf "%.4e" gR :: String))
                 , ("gnpL" , (printf "%.4e" gL :: String))
                 , ("gnpcuR" , (printf "%.4e" gcR :: String)) 
                 , ("gnpcuL" , (printf "%.4e" gcL :: String))
                 , ("wnp"  , (printf "%.4e" (gammanp m gR gL gcR gcL) :: String)) ]
                 (paramCard4Model C1SLowSimple) ) ++ "\n\n\n"
  briefParamShow (C1SLowSimpleParam m gR gL gcR gcL) = "M"++show m++"GR"++show gR++"GL"++show gL ++ "GCR" ++ show gcR ++ "GCL" ++ show gcL
  interpreteParam str = let r = parse c1slowsmpparse "" str 
                        in case r of 
                          Right param -> param 
                          Left err -> error (show err)

c1slowsmpparse :: ParsecT String () Identity (ModelParam C1SLowSimple) 
c1slowsmpparse = do 
  char 'M' 
  massstr <- many1 (oneOf "+-0123456789.")
  string "GR"
  grstr <- many1 (oneOf "+-0123456789.")
  string "GL"
  glstr <- many1 (oneOf "+-0123456789.")
  string "GCR"
  gcrstr <- many1 (oneOf "+-0123456789.")
  string "GCL"
  gclstr <- many1 (oneOf "+-0123456789.")
  return (C1SLowSimpleParam (read massstr) (read grstr) (read glstr)
                            (read gcrstr) (read gclstr))

-- mtop :: Double 
-- mtop = 172.0

gammanp :: Double -> Double -> Double -> Double -> Double -> Double 
gammanp m gR gL gcR gcL = 
  let gammacu = 3.0 * m/(8.0*pi) * (gcR^(2::Int)+gcL^(2::Int))/2.0
      gammatu = if m > mtop
                 then 3.0 * m/(8.0*pi) * (gR^(2::Int)+gL^(2::Int))/2.0 
                          * (1.0 - (mtop^(2::Int))/(m^(2::Int))) 
                 else 0
  in  gammacu + gammatu 

c1SLowSmpTr :: TypeRep 
c1SLowSmpTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.C1SLowSimple.C1SLowSimple") []

instance Typeable (ModelParam C1SLowSimple) where
  typeOf _ = mkTyConApp modelParamTc [c1SLowSmpTr]

deriving instance Data (ModelParam C1SLowSimple)





