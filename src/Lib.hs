module Lib where

import Control.Concurrent
import Data.Maybe
import Text.Read

question :: IO (Maybe Int)
question = do
  putStr "Give me an integer: "
  readMaybe <$> getLine

-- Retry the provided action the given number of times
retry ::
     (Monad m, HasLogFunc m, HasDelay m)
  => Int -- ^ number of times to retry
  -> m (Maybe a) -- ^ action to retry
  -> m (Maybe a)
retry n action = action >>= go 1
  where
    go i (Just r) = return (Just r)
    go i Nothing =
      if i > n
        then return Nothing
        else do
          let dt = min 9 (i * i)
          logInfo $
            "Retrying in " <> show dt <> " seconds " <> show i <> "/" <> show n
          delaySeconds dt
          res' <- action
          go (i + 1) res'

class HasLogFunc env where
  logInfo :: String -> env ()

class HasDelay env where
  delaySeconds :: Int -> env ()

instance HasLogFunc IO where
  logInfo = putStrLn

instance HasDelay IO where
  delaySeconds n = threadDelay (n * 1000000)
