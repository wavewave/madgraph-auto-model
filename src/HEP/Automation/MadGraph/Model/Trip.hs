{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.Trip where

import Text.Printf

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Exotic
import HEP.Automation.MadGraph.Model.Common

data Trip = Trip
          deriving Show

instance Model Trip where
  data ModelParam Trip = TripParam { massTrip :: Double, gRTrip :: Double  } 
                       deriving Show 
  briefShow Trip = "Trip"
  modelName Trip = "triplets_fv"
  paramCard4Model Trip = "param_card_trip.dat" 
  paramCardSetup tpath Trip (TripParam m g) = do 
    templates <- directoryGroup tpath 
    return $ ( renderTemplateGroup
                 templates
                 [ ("massTrip" , (printf "%.4e" m :: String))
                 , ("gRtrip"   , (printf "%.4e" g :: String))
                 , ("widthTrip", (printf "%.4e" (decayWidthExotic g m mtop) :: String)) ]
                 (paramCard4Model Trip) ) ++ "\n\n\n"
  briefParamShow (TripParam m g) = "M"++show m++"G"++show g 

