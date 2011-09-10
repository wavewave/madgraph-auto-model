{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts, 
             DeriveDataTypeable, StandaloneDeriving #-}

module HEP.Automation.MadGraph.Model.MSSMSLHA where

import HEP.Automation.MadGraph.Model

import HEP.Physics.MSSM.SLHA

import Data.Typeable
import Data.Data


import qualified Data.ByteString.Char8 as C

data MSSMSLHA = MSSMSLHA deriving (Show, Typeable, Data)

instance Model MSSMSLHA where
  data ModelParam MSSMSLHA = MSSMSLHAParam { mssmSLHA :: SLHA } deriving (Show)
  briefShow MSSMSLHA = "MSSM"
  modelName MSSMSLHA = "mssm"
  paramCard4Model MSSMSLHA  = "" 
  paramCardSetup _ MSSMSLHA (MSSMSLHAParam slha) = return (C.unpack . slhaContent $ slha)
  briefParamShow (MSSMSLHAParam slha) = show . slhaMD5 $ slha 
  madgraphVersion = error "madgraphVersion undefined for MSSMSLHA"
  modelFromString = error "modelFromString undefined for MSSMSLHA"
  interpreteParam = error "interpreteParam undefined for MSSMSLHA"

  
mSSMSLHATr :: TypeRep 
mSSMSLHATr = mkTyConApp (mkTyCon "HEP.Automation.MadGraph.Model.MSSMSLHA.MSSMSLHA") []

instance Typeable (ModelParam MSSMSLHA) where
  typeOf _ = mkTyConApp modelParamTc [mSSMSLHATr]

deriving instance Data (ModelParam MSSMSLHA)
