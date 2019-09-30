module Main where

import System.Environment
import System.IO

import Lib

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  result <- retry 3 question
  print result
