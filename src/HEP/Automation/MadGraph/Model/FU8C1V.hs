{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             RecordWildCards, StandaloneDeriving, DeriveDataTypeable #-}


module HEP.Automation.MadGraph.Model.FU8C1V where

import Data.Typeable
import Data.Data

import Text.Printf

import Text.Parsec
import Control.Monad.Identity

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

data FU8C1V = FU8C1V
         deriving (Show, Typeable, Data)

instance Model FU8C1V where
  data ModelParam FU8C1V = FU8C1VParam { mMFV  :: Double
                                       , dmMFV :: Double 
                                       , gMFV  :: Double
                                       , eta   :: Double } 
                      deriving Show
  briefShow FU8C1V = "FU8C1V"
  madgraphVersion _ = MadGraph5
  modelName FU8C1V = "FU8C1V_UFO"
  modelFromString str = case str of 
                          "FU8C1V_UFO" -> Just FU8C1V
                          _ -> Nothing
  paramCard4Model FU8C1V  = "param_card_FU8C1V.dat" 
  paramCardSetup tpath FU8C1V s@FU8C1VParam{..} = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("Mmfv"       , (printf "%.4e" mMFV  :: String))
                 , ("dMmfv"      , (printf "%.4e" dmMFV :: String))
                 , ("gmfv"       , (printf "%.4e" gMFV  :: String)) 
                 , ("eta"        , (printf "%.4e" eta   :: String)) 
                 , ("Monetwo"    , (printf "%.4e" mMFV  :: String)) 
                 , ("Mthree"     , (printf "%.4e" mMFV  :: String))
                 , ("Mfourfive"  , (printf "%.4e" (mMFV + dmMFV) :: String)) 
                 , ("Msixseven"  , (printf "%.4e" (mMFV + dmMFV) :: String )) 
                 , ("Meight"     , (printf "%.4e" (m8mass mMFV dmMFV) :: String))
                 , ("Wonetwo"    , (printf "%.4e" (wv12 mMFV gMFV) :: String))
                 , ("Wthree"     , (printf "%.4e" (wv3 mMFV gMFV) :: String))
                 , ("Wfourfive"  , (printf "%.4e" (wv45 s) :: String))
                 , ("Wsixseven"  , (printf "%.4e" (wv67 s) :: String))
                 , ("Weight"     , (printf "%.4e" (wv8 s) :: String)) ]
                 (paramCard4Model FU8C1V) ) ++ "\n\n\n"
  briefParamShow FU8C1VParam{..} = "M"++show mMFV++"DM"++show dmMFV++"G"++show gMFV++"ETA"++show eta 
  interpreteParam str = let r = parse fu8c1vparse "" str 
                        in case r of 
                          Right param -> param 
                          Left err -> error (show err)

fu8c1vparse :: ParsecT String () Identity (ModelParam FU8C1V) 
fu8c1vparse = do 
  char 'M' 
  mstr <- many1 (oneOf "+-0123456789.")
  string "DM"
  dmstr <- many1 (oneOf "+-0123456789.")
  char 'G'
  gstr <- many1 (oneOf "+-0123456789.")
  string "ETA"
  etastr <- many1 (oneOf "+-0123456789.")
  return $ FU8C1VParam (read mstr) (read dmstr) (read gstr) (read etastr)


m8mass :: Double -> Double -> Double 
m8mass mmfv dmmfv = sqrt (mmfv^(2::Int)+(4.0/3.0)*(dmmfv^(2::Int)+2.0*dmmfv*mmfv))

wv12 :: Double -> Double -> Double 
wv12 mmfv gmfv = mmfv * gmfv^(2::Int) / (16.0*pi)

wv3 :: Double -> Double -> Double 
wv3 mmfv gmfv = mmfv * gmfv^(2::Int) / (16.0*pi)

wv45 :: ModelParam FU8C1V-> Double
wv45 FU8C1VParam{..} = m45 / (16.0*pi)*gMFV^(2::Int)*(1.0+2.0*eta*(mtop/higgsv)^(2::Int))^(2::Int)*(1.0-r)^(2::Int)*(1+0.5*r)
  where m45 = mMFV + dmMFV
        higgsv = 246.0
        r = mtop^(2::Int) / m45^(2::Int)

wv67 :: ModelParam FU8C1V -> Double
wv67 = wv45 

wv8 :: ModelParam FU8C1V -> Double 
wv8 FU8C1VParam{..} =  if m8 > 2.0*mtop 
                          then gMFV^(2::Int) / (48.0*pi)*m8* ( 2.0*(1.0+4.0*eta*(mtop/higgv)^(2::Int))^(2::Int)
                               *(1.0-r)*sqrt (1.0-4.0*r) + 1.0)
                          else gMFV^(2::Int) / (48.0*pi)*m8 

  where m8 = m8mass mMFV dmMFV
        r = mtop^(2::Int) / m8^(2::Int)
        higgv = 246.0

fU8C1VTr :: TypeRep 
fU8C1VTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.FU8C1V.FU8C1V") []

instance Typeable (ModelParam FU8C1V) where
  typeOf _ = mkTyConApp modelParamTc [fU8C1VTr]

deriving instance Data (ModelParam FU8C1V)






