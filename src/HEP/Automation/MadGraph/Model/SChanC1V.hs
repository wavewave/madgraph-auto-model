{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

module HEP.Automation.MadGraph.Model.SChanC1V where

import Data.Typeable
import Data.Data

import Text.Printf

import Text.Parsec
import Control.Monad.Identity

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

data SChanC1V = SChanC1V
         deriving (Show, Typeable, Data)

instance Model SChanC1V where
  data ModelParam SChanC1V = SChanC1VParam { mnp   :: Double
                                           , gnpqR :: Double 
                                           , gnpqL :: Double
                                           , gnptR :: Double
                                           , gnptL :: Double } 
                      deriving Show
  briefShow SChanC1V = "SChC1V"
  madgraphVersion _ = MadGraph5
  modelName SChanC1V = "schanC1V_UFO"
  modelFromString str = case str of 
                          "schanC1V_UFO" -> Just SChanC1V
                          _ -> Nothing
  paramCard4Model SChanC1V  = "param_card_schanC1V.dat" 
  paramCardSetup tpath SChanC1V (SChanC1VParam m gqR gqL gtR gtL) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("mnp"  , (printf "%.4e" m :: String))
                 , ("gnpqR", (printf "%.4e" gqR :: String))
                 , ("gnpqL", (printf "%.4e" gqL :: String))
                 , ("gnptR", (printf "%.4e" gtR :: String))
                 , ("gnptL", (printf "%.4e" gtL :: String)) 
                 , ("wnp",   (printf "%.4e" (gammanp m gqR gqL gtR gtL) :: String)) ]
                 (paramCard4Model SChanC1V) ) ++ "\n\n\n"
  briefParamShow (SChanC1VParam m gqR gqL gtR gtL) 
    ="M"++show m++"QR"++show gqR++"QL"++show gqL++"TR"++show gtR++"TL"++show gtL 
  interpreteParam str = let r = parse schanc1vparse "" str 
                        in case r of 
                          Right param -> param 
                          Left err -> error (show err)

schanc1vparse :: ParsecT String () Identity (ModelParam SChanC1V) 
schanc1vparse = do 
  char 'M' 
  massstr <- many1 (oneOf "+-0123456789.")
  string "QR"
  gqrstr <- many1 (oneOf "+-0123456789.")
  string "QL"
  gqlstr <- many1 (oneOf "+-0123456789.")
  string "TR"
  gtrstr <- many1 (oneOf "+-0123456789.")
  string "TL"
  gtlstr <- many1 (oneOf "+-0123456789.")
  return (SChanC1VParam (read massstr) 
                        (read gqrstr) (read gqlstr)
                        (read gtrstr) (read gtlstr))

gammanp :: Double -> Double -> Double -> Double -> Double -> Double   
gammanp m gqR gqL gtR gtL = 
  let r = mtop^(2 :: Int)/ m^(2 :: Int)  
  in  1.0/(4.0*pi)*m*(  
                        ( 
                          (gtR^(2::Int)+gtL^(2::Int))/2.0*(1.0-r)
                          +3.0*gtL*gtR*r
                        )*sqrt (1.0-4.0*r)
                        + (gtR^(2::Int)+gtL^(2::Int))/2.0
                        + 4.0*(gqR^(2::Int)+gqL^(2::Int))/2.0 
                     )

sChanC1VTr :: TypeRep 
sChanC1VTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.SChanC1V.SChanC1V") []

instance Typeable (ModelParam SChanC1V) where
  typeOf _ = mkTyConApp modelParamTc [sChanC1VTr]

deriving instance Data (ModelParam SChanC1V)








