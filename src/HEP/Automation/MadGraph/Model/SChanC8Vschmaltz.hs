{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE DeriveDataTypeable, StandaloneDeriving #-}


module HEP.Automation.MadGraph.Model.SChanC8Vschmaltz where

import Data.Typeable
import Data.Data

import Text.Printf

import Text.Parsec
import Control.Monad.Identity

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Common

data SChanC8Vschmaltz = SChanC8Vschmaltz
         deriving (Show, Typeable, Data)

instance Model SChanC8Vschmaltz where
  data ModelParam SChanC8Vschmaltz = 
         SChanC8VschmaltzParam { mnp   :: Double
                               , mphi  :: Double
                               , ga    :: Double
                               , nphi  :: Double }
                      deriving Show
  briefShow SChanC8Vschmaltz = "SChC8VSchm"
  madgraphVersion _ = MadGraph5
  modelName SChanC8Vschmaltz = "schanC8Vschmaltz_UFO"
  modelFromString str = case str of 
                          "schanC8Vschmaltz_UFO" -> Just SChanC8Vschmaltz
                          _ -> Nothing
  paramCard4Model SChanC8Vschmaltz  = "param_card_schmaltz.dat" 
  paramCardSetup tpath SChanC8Vschmaltz 
                 sp@SChanC8VschmaltzParam{..} = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("mnp"  , (printf "%.4e" mnp :: String))
                 , ("mphi" , (printf "%.4e" mphi :: String))
                 , ("ga"   , (printf "%.4e" ga :: String))
                 , ("nphi" , (printf "%.4e" nphi :: String)) 
                 , ("wnp",   (printf "%.4e" (gammanp sp) :: String)) ]
                 (paramCard4Model SChanC8Vschmaltz) ) ++ "\n\n\n"
  briefParamShow SChanC8VschmaltzParam{..}
    ="M"++show mnp++"MP"++show mphi++"G"++show ga++"NP"++show nphi 
  interpreteParam str = let r = parse schmaltzparse "" str 
                        in case r of 
                          Right param -> param 
                          Left err -> error (show err)

schmaltzparse :: ParsecT String () Identity (ModelParam SChanC8Vschmaltz) 
schmaltzparse = do 
  char 'M' 
  mstr <- many1 (oneOf "+-0123456789.")
  string "MP"
  mpstr <- many1 (oneOf "+-0123456789.")
  char 'G'
  gstr <- many1 (oneOf "+-0123456789.")
  string "NP"
  npstr <- many1 (oneOf "+-0123456789.")
  return (SChanC8VschmaltzParam (read mstr) 
                                (read mpstr) 
                                (read gstr)
                                (read npstr) )

gammanp :: (ModelParam SChanC8Vschmaltz) -> Double    
gammanp SChanC8VschmaltzParam{..} = 
  1.0/(24.0*pi)*mnp*(ga^(2::Int)*(1.0-4.0*mtop^(2::Int)/(mnp^(2::Int)))**1.5 
                     +5.0*ga^(2::Int)
                    ) 
  + (gstrong*nphi)^(2::Int)/(16.0*pi)*mphi*(1.0-4.0*mphi^(2::Int)/
                                                         mnp^(2::Int))**1.5


sChanC8VschmaltzTr :: TypeRep 
sChanC8VschmaltzTr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.SChanC8Vschmaltz.SChanC8Vschmaltz") []

instance Typeable (ModelParam SChanC8Vschmaltz) where
  typeOf _ = mkTyConApp modelParamTc [sChanC8VschmaltzTr]

deriving instance Data (ModelParam SChanC8Vschmaltz)






