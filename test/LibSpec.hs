{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}

module LibSpec where

import Lib

import Control.Monad.Writer
import Test.Hspec

type MockAction = Writer [String]

instance HasLogFunc MockAction where
  logInfo msg = tell [msg]

spec =
  describe "retry" $ do
    it "passes through the successful value" $
      runWriter (retry 3 justSucceeds) `shouldBe` (Just "OK", [])
    it "gives up after the specified time" $
      runWriter (retry 3 alwaysFails) `shouldBe`
      (Nothing, ["Retrying 1/3", "Retrying 2/3", "Retrying 3/3"])

alwaysFails :: MockAction (Maybe String)
alwaysFails = return Nothing

justSucceeds :: MockAction (Maybe String)
justSucceeds = return (Just "OK")
