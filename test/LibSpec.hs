{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}

module LibSpec where

import Lib

import Control.Monad.Writer
import Test.Hspec

type MockAction = Writer [String]

instance HasLogFunc MockAction where
  logInfo msg = tell [msg]

instance HasDelay MockAction where
  delaySeconds s =
    tell
      [ "Wait " <> show s <> " second" <>
        (if s > 1
           then "s"
           else "")
      ]

spec =
  describe "retry" $ do
    it "passes through the successful value" $
      runWriter (retry 3 justSucceeds) `shouldBe` (Just "OK", [])
    it "gives up after the specified time" $
      runWriter (retry 3 alwaysFails) `shouldBe`
      ( Nothing
      , [ "Retrying in 1 seconds 1/3"
        , "Wait 1 second"
        , "Retrying in 4 seconds 2/3"
        , "Wait 4 seconds"
        , "Retrying in 9 seconds 3/3"
        , "Wait 9 seconds"
        ])

alwaysFails :: MockAction (Maybe String)
alwaysFails = return Nothing

justSucceeds :: MockAction (Maybe String)
justSucceeds = return (Just "OK")
