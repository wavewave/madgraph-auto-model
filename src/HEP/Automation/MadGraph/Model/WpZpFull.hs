{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.WpZpFull where

import Text.Printf

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model

data WpZpFull = WpZpFull
  deriving Show

instance Model WpZpFull where
  data ModelParam WpZpFull = WpZpFullParam { mWp :: Double,
                                             mZp :: Double,  
                                             gWpdt :: Double, 
                                             gWpub :: Double, 
                                             gZpbb :: Double, 
                                             gZptt :: Double, 
                                             gZpuu :: Double, 
                                             gZpdd :: Double }
                           deriving Show
  briefShow WpZpFull = "WpZpFull"                             
  modelName WpZpFull = "fvwpzpLight_MG" 
  paramCard4Model WpZpFull   = "param_card_wpzpfull.dat"
  paramCardSetup tpath WpZpFull (WpZpFullParam mWp' mZp' gWpdt' gWpub' gZpbb'
                                             gZptt' gZpuu' gZpdd' ) = do 
    templates <- directoryGroup tpath
    let (gammaWp,gammaZp) = gammaWpZpFullBelowTopMass mWp' mZp' gWpub' gZpuu' gZpdd' gZpbb'  
    return $ ( renderTemplateGroup
                 templates
                 [ ("mWp"         , (printf "%.4e" mWp'   :: String))
                 , ("mZp"         , (printf "%.4e" mZp'   :: String))
                 , ("gWpdtOverSqrtTwo", (printf "%.4e" (gWpdt' / sqrt 2) :: String))
                 , ("gWpubOverSqrtTwo", (printf "%.4e" (gWpub' / sqrt 2) :: String))
                 , ("gZpbb"       , (printf "%.4e" gZpbb' :: String))
                 , ("gZptt"       , (printf "%.4e" gZptt' :: String))
                 , ("gZpuu"       , (printf "%.4e" gZpuu' :: String))
                 , ("gZpdd"       , (printf "%.4e" gZpdd' :: String)) 
                 , ("wWp"         , (printf "%.4e" gammaWp :: String)) 
                 , ("wZp"         , (printf "%.4e" gammaZp :: String))
                 ]
                 (paramCard4Model WpZpFull)  ) ++ "\n\n\n"
 -- Decay width is not right. 
  briefParamShow (WpZpFullParam mWp mZp gWpdt gWpub gZpbb gZptt gZpuu gZpdd)
    = ("MWP"++show mWp 
       ++ "MZP" ++ show mZp 
       ++ "GWPDT" ++ show gWpdt 
       ++ "GWPUB" ++ show gWpub
       ++ "GZPBB" ++ show gZpbb
       ++ "GZPTT" ++ show gZptt
       ++ "GZPUU" ++ show gZpuu
       ++ "GZPDD" ++ show gZpdd)

gammaWpZpFullBelowTopMass :: Double -> Double -> Double -> Double -> Double -> Double-> (Double,Double)  
gammaWpZpFullBelowTopMass mWp mZp gWpub gZpuu gZpdd gZpbb = 
  let gammaWp = gWpub^(2::Int)*(1/(16.0*pi)) * mWp 
      gammaZp = (gZpuu^(2::Int)+gZpdd^(2::Int)+gZpbb^(2::Int))*(2.0/(16.0*pi))*mZp 
  in  (gammaWp,gammaZp)




