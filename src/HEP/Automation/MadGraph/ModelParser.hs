{-# LANGUAGE ExistentialQuantification, FlexibleContexts #-}

module HEP.Automation.MadGraph.ModelParser where

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.SM
import HEP.Automation.MadGraph.Model.ADMXQLD111
import HEP.Automation.MadGraph.Model.ADMXQLD111degen
import HEP.Automation.MadGraph.Model.ADMXQLD211
import HEP.Automation.MadGraph.Model.ADMXQLD311
import HEP.Automation.MadGraph.Model.ADMXQLDlight
import HEP.Automation.MadGraph.Model.ADMXUDD112
import HEP.Automation.MadGraph.Model.ADMXUDD112degen
import HEP.Automation.MadGraph.Model.SimplifiedSUSY
import HEP.Automation.MadGraph.Model.LeptoQuark1

data ModelBox = forall a. (Model a) => ModelBox a


modelParse :: String -> Maybe ModelBox
modelParse "sm"                = Just (ModelBox SM) 
modelParse "ADMXQLD111"        = Just (ModelBox ADMXQLD111)
modelParse "ADMXQLD111degen"   = Just (ModelBox ADMXQLD111degen)
modelParse "ADMXQLD211"        = Just (ModelBox ADMXQLD211)
modelParse "ADMXQLD311"        = Just (ModelBox ADMXQLD311)
modelParse "ADMXQLDlight"      = Just (ModelBox ADMXQLDlight)
modelParse "ADMXUDD112"        = Just (ModelBox ADMXUDD112)
modelParse "ADMXUDD112degen"   = Just (ModelBox ADMXUDD112degen)
modelParse "SimplifiedSUSY"    = Just (ModelBox SimplifiedSUSY)
modelParse "LeptoQuark1"       = Just (ModelBox LeptoQuark1)
modelParse _ = Nothing

