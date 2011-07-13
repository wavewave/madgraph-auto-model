{-# LANGUAGE ExistentialQuantification, FlexibleContexts #-}

module HEP.Automation.MadGraph.ModelParser where

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.SM
import HEP.Automation.MadGraph.Model.AxiGluon
import HEP.Automation.MadGraph.Model.ZpH
import HEP.Automation.MadGraph.Model.Wp
import HEP.Automation.MadGraph.Model.C1V
import HEP.Automation.MadGraph.Model.C1S 
import HEP.Automation.MadGraph.Model.C8V
import HEP.Automation.MadGraph.Model.C8S 
import HEP.Automation.MadGraph.Model.SChanC1V
import HEP.Automation.MadGraph.Model.SChanC8V

data ModelBox = forall a. (Model a) => ModelBox a


modelParse :: String -> Maybe ModelBox
modelParse "Axigluon_AV_MG" = Just (ModelBox AxiGluon)
modelParse "DummyModel"     = Just (ModelBox DummyModel)
modelParse "zHorizontal_MG" = Just (ModelBox ZpH)
modelParse "fvwp200_MG"     = Just (ModelBox Wp) 
modelParse "C1V_UFO"        = Just (ModelBox C1V)
modelParse "C1S_UFO"        = Just (ModelBox C1S)
modelParse "C8V_UFO"        = Just (ModelBox C8V)
modelParse "C8S_UFO"        = Just (ModelBox C8S)
modelParse "schanC1V_UFO"   = Just (ModelBox SChanC1V)
modelParse "schanC8V_UFO"   = Just (ModelBox SChanC8V)
modelParse "sm"             = Just (ModelBox SM)
modelParse _ = Nothing

