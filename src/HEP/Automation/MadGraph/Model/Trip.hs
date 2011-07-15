{-# LANGUAGE TypeFamilies, FlexibleInstances, FlexibleContexts #-}

module HEP.Automation.MadGraph.Model.Trip where

import Control.Monad.Identity
import Text.Printf
import Text.StringTemplate
import Text.StringTemplate.Helpers
import Text.Parsec

import HEP.Automation.MadGraph.Model
import HEP.Automation.MadGraph.Model.Exotic
import HEP.Automation.MadGraph.Model.Common

data Trip = Trip
          deriving Show

instance Model Trip where
  data ModelParam Trip = TripParam { massTrip :: Double, gRTrip :: Double  } 
                       deriving Show 
  briefShow Trip = "Trip"
  madgraphVersion _ = MadGraph5
  modelName Trip = "triplets_fv"
  modelFromString str = case str of 
                          "triplets_fv" -> Just Trip
                          _ -> Nothing
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
  interpreteParam str = let r = parse tripparse "" str 
                        in case r of 
                          Right param -> param
                          Left err -> error (show err)

tripparse :: ParsecT String () Identity (ModelParam Trip) 
tripparse = do 
  char 'M' 
  massstr <- many1 (oneOf "+-0123456789.")
  char 'G'
  gstr <- many1 (oneOf "+-0123456789.")
  return (TripParam (read massstr) (read gstr))
