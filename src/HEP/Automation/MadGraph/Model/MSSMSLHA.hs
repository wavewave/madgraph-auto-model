{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.MSSMSLHA where

import HEP.Automation.MadGraph.Model

import HEP.Physics.MSSM.SLHA

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as C

data MSSMSLHA = MSSMSLHA deriving Show

instance Model MSSMSLHA where
  data ModelParam MSSMSLHA = MSSMSLHAParam { mssmSLHA :: SLHA } deriving Show
  briefShow MSSMSLHA = "MSSM"
  modelName MSSMSLHA = "mssm"
  paramCard4Model MSSMSLHA  = "" 
  paramCardSetup _ MSSMSLHA (MSSMSLHAParam slha) = return (C.unpack . slhaContent $ slha)
  briefParamShow (MSSMSLHAParam slha) = show . slhaMD5 $ slha 
  

