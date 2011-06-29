{-# LANGUAGE ExistentialQuantification, FlexibleContexts #-}

module HEP.Automation.MadGraph.ModelParser where

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.AxiGluon
import HEP.Automation.MadGraph.Model.ZpH


data ModelBox = forall a. (Model a) => ModelBox a


modelParse :: String -> Maybe ModelBox
modelParse "Axigluon_AV_MG" = Just (ModelBox AxiGluon)
modelParse "DummyModel"     = Just (ModelBox DummyModel)
modelParse "zHorizontal_MG" = Just (ModelBox ZpH)
modelParse _ = Nothing

