{-# LANGUAGE ExistentialQuantification, FlexibleContexts #-}

module HEP.Automation.MadGraph.ModelParser where

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.SM
import HEP.Automation.MadGraph.Model.AxiGluon
import HEP.Automation.MadGraph.Model.ZpH
import HEP.Automation.MadGraph.Model.Wp
import HEP.Automation.MadGraph.Model.C1V

data ModelBox = forall a. (Model a) => ModelBox a


modelParse :: String -> Maybe ModelBox
modelParse "Axigluon_AV_MG" = Just (ModelBox AxiGluon)
modelParse "DummyModel"     = Just (ModelBox DummyModel)
modelParse "zHorizontal_MG" = Just (ModelBox ZpH)
modelParse "fvwp200_MG"     = Just (ModelBox Wp) 
modelParse "C1V_UFO"        = Just (ModelBox C1V)
modelParse "sm"             = Just (ModelBox SM)
modelParse _ = Nothing

