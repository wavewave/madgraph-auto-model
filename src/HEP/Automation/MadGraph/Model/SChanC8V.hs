{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.SChanC8V where

import Text.Printf

import Text.Parsec
import Control.Monad.Identity

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

import System.FilePath ((</>))

data SChanC8V = SChanC8V
         deriving Show

instance Model SChanC8V where
  data ModelParam SChanC8V = SChanC8VParam { mnp   :: Double
                                           , gnpqR :: Double 
                                           , gnpqL :: Double
                                           , gnpbR :: Double
                                           , gnpbL :: Double
                                           , gnptR :: Double
                                           , gnptL :: Double } 
                      deriving Show
  briefShow SChanC8V = "SChC8V"
  madgraphVersion _ = MadGraph5
  modelName SChanC8V = "schanC8V_UFO"
  modelFromString str = case str of 
                          "schanC8V_UFO" -> Just SChanC8V
                          _ -> Nothing
  paramCard4Model SChanC8V  = "param_card_schanC8V.dat" 
  paramCardSetup tpath SChanC8V (SChanC8VParam m gqR gqL gbR gbL gtR gtL) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("mnp"  , (printf "%.4e" m :: String))
                 , ("gnpqR", (printf "%.4e" gqR :: String))
                 , ("gnpqL", (printf "%.4e" gqL :: String))
                 , ("gnpbR", (printf "%.4e" gbR :: String))
                 , ("gnpbL", (printf "%.4e" gbL :: String)) 
                 , ("gnptR", (printf "%.4e" gtR :: String))
                 , ("gnptL", (printf "%.4e" gtL :: String)) 
                 , ("wnp",   (printf "%.4e" (gammanp m gqR gqL gbR gbL gtR gtL) :: String)) ]
                 (paramCard4Model SChanC8V) ) ++ "\n\n\n"
  briefParamShow (SChanC8VParam m gqR gqL gbR gbL gtR gtL) 
    = "M"++show m++"QR"++show gqR++"QL"++show gqL
      ++"BR"++show gbR++"BL"++show gbL
      ++"TR"++show gtR++"TL"++show gtL 
  interpreteParam str = let r = parse schanc8vparse "" str 
                        in case r of 
                          Right param -> param 
                          Left err -> error (show err)

schanc8vparse :: ParsecT String () Identity (ModelParam SChanC8V) 
schanc8vparse = do 
  char 'M' 
  massstr <- many1 (oneOf "+-0123456789.")
  string "QR"
  gqrstr <- many1 (oneOf "+-0123456789.")
  string "QL"
  gqlstr <- many1 (oneOf "+-0123456789.")
  string "BR"
  gbrstr <- many1 (oneOf "+-0123456789.")
  string "BL"
  gblstr <- many1 (oneOf "+-0123456789.")
  string "TR"
  gtrstr <- many1 (oneOf "+-0123456789.")
  string "TL"
  gtlstr <- many1 (oneOf "+-0123456789.")
  return (SChanC8VParam (read massstr) 
                        (read gqrstr) (read gqlstr)
                        (read gbrstr) (read gblstr)
                        (read gtrstr) (read gtlstr))

gammanp :: Double -> Double -> Double -> Double -> Double -> Double -> Double 
        -> Double   
gammanp m gqR gqL gbR gbL gtR gtL = 
  let r = mtop^(2 :: Int)/ m^(2 :: Int)  
  in  1.0/(24.0*pi)*m*(  
                         ( 
                           (gtR^(2::Int)+gtL^(2::Int))/2.0*(1.0-r)
                           +3.0*gtL*gtR*r
                         )*sqrt (1.0-4.0*r)
                         + (gbR^(2::Int)+gbL^(2::Int))/2.0
                         + 4.0*(gqR^(2::Int)+gqL^(2::Int))/2.0 
                      )







