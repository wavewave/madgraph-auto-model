{-# LANGUAGE ExistentialQuantification, FlexibleContexts #-}

module HEP.Automation.MadGraph.ModelParser where

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.SM
-- import HEP.Automation.MadGraph.Model.AxiGluon
-- import HEP.Automation.MadGraph.Model.ZpH
-- import HEP.Automation.MadGraph.Model.Wp
-- import HEP.Automation.MadGraph.Model.Trip
-- import HEP.Automation.MadGraph.Model.C1V
-- import HEP.Automation.MadGraph.Model.C1VLowSimple
-- import HEP.Automation.MadGraph.Model.C1S 
-- import HEP.Automation.MadGraph.Model.C1SLowSimple
-- import HEP.Automation.MadGraph.Model.C8V
-- import HEP.Automation.MadGraph.Model.C8S 
-- import HEP.Automation.MadGraph.Model.SChanC1V
-- import HEP.Automation.MadGraph.Model.SChanC8V
-- import HEP.Automation.MadGraph.Model.SChanC8Vschmaltz
-- import HEP.Automation.MadGraph.Model.FU8C1V 
-- import HEP.Automation.MadGraph.Model.ADMXUDD
import HEP.Automation.MadGraph.Model.ADMXQLD111
import HEP.Automation.MadGraph.Model.ADMXQLD211
import HEP.Automation.MadGraph.Model.ADMXQLD311
import HEP.Automation.MadGraph.Model.SimplifiedSUSY

data ModelBox = forall a. (Model a) => ModelBox a


modelParse :: String -> Maybe ModelBox
-- modelParse "Axigluon_AV_MG" = Just (ModelBox AxiGluon)
-- modelParse "DummyModel"     = Just (ModelBox DummyModel)
-- modelParse "zHorizontal_MG" = Just (ModelBox ZpH)
-- modelParse "fvwp200_MG"     = Just (ModelBox Wp) 
-- modelParse "triplets_fv"    = Just (ModelBox Trip)
-- modelParse "C1V_UFO"        = Just (ModelBox C1V)
-- modelParse "C1VLowSimple_UFO" = Just (ModelBox C1VLowSimple)
-- modelParse "C1S_UFO"        = Just (ModelBox C1S)
-- modelParse "C1SLowSimple_UFO"  = Just (ModelBox C1SLowSimple)
-- modelParse "C8V_UFO"        = Just (ModelBox C8V)
-- modelParse "C8S_UFO"        = Just (ModelBox C8S)
-- modelParse "schanC1V_UFO"   = Just (ModelBox SChanC1V)
-- modelParse "schanC8V_UFO"   = Just (ModelBox SChanC8V)
-- modelParse "schanC8Vschmaltz_UFO" = Just (ModelBox SChanC8Vschmaltz)
-- modelParse "FU8C1V_UFO"     = Just (ModelBox FU8C1V)
-- modelParse "ADMXUDD"        = Just (ModelBox ADMXUDD)
modelParse "sm"                = Just (ModelBox SM) 
modelParse "ADMXQLD111"        = Just (ModelBox ADMXQLD111)
modelParse "ADMXQLD211"        = Just (ModelBox ADMXQLD211)
modelParse "ADMXQLD311"        = Just (ModelBox ADMXQLD311)
modelParse "SimplifiedSUSY"    = Just (ModelBox SimplifiedSUSY)
modelParse _ = Nothing

