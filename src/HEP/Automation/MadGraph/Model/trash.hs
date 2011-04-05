module HEP.Automation.MadGraph.Model.Wprime where

import Text.Printf

import Text.StringTemplate
import Text.StringTemplate.Helpers

import HEP.Automation.MadGraph.Model


data ZpH = ZpH 
data Six = Six 
data Trip = Trip 
data AxiGluon = AxiGluon 
data SixFull = SixFull 
data TripFull = TripFull 
data WpZpFull = WpZpFull



paramCard4Model :: Model -> String



paramCard4Model SixFull = "param_card_sixfull.dat"
paramCard4Model TripFull = "param_card_tripfull.dat"



data Model = SM | Wp | ZpH | Six | Trip | AxiGluon 
           | SixFull | TripFull | WpZpFull
           deriving Show




data Param = SMParam 
           | WpParam { massWp :: Double, gRWp :: Double } 
           |          
             

           | 
           | SixFullParam { massSix :: Double, gRSix :: Double, gRSixD :: Double } 
           | TripFullParam { massTrip :: Double, gRTrip :: Double, gRTripD :: Double } 
           | 
           deriving Show

modelName :: Model -> String


modelName SixFull = "sextetsfull3"
modelName TripFull = "tripletsfull3"



gammaWpZp :: Double -> Double -> Double            
gammaWpZp mass coup = 
  let r = mtop^(2 :: Int)/ mass^(2 :: Int)  
  in  coup^(2 :: Int) / (16.0 * pi) *mass*( 1.0 - 1.5 * r + 0.5 * r^(3 :: Int))





