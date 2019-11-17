{-# LANGUAGE NoImplicitPrelude #-}

module Poly (benchmarks) where

import Protolude

import Criterion.Main
import Data.Curve.Weierstrass.BN254 (Fr)
import Data.Pairing.BN254           (getRootOfUnity)

import FFT

k :: Int
k = 5

polySize :: Int
polySize = 2^k

leftCoeffs, rightCoeffs :: [Fr]
leftCoeffs = map fromIntegral [1..polySize]
rightCoeffs = map fromIntegral (reverse [1..polySize])

points :: [(Fr,Fr)]
points
  = map (\i -> (getRootOfUnity k ^ i, fromIntegral i))
        [1..polySize]

fftPoints :: [Fr]
fftPoints = map snd points

benchmarks :: [Benchmark]
benchmarks
  = [ bench "FFT-based multiplication"
            $ nf (uncurry $ fftMult getRootOfUnity)
                 (leftCoeffs, rightCoeffs)
    , bench "FFT-based interpolation"
            $ nf (interpolate getRootOfUnity) fftPoints
    ]
