module HEP.Automation.MadGraph.Model.Exotic where

decayWidthExotic :: Double -> Double -> Double -> Double
decayWidthExotic  y mphi mt = y^(2 :: Int) / (16.0 * pi )
                              * (mphi^(2 :: Int) - mt^(2 :: Int))^(2 :: Int) 
                              / (mphi^(3 :: Int))

