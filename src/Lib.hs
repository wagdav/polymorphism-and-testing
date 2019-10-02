module Lib where

import Data.Maybe
import Text.Read

question :: IO (Maybe Int)
question = do
  putStr "Give me an integer: "
  readMaybe <$> getLine

-- Retry the provided action the given number of times
retry ::
     (Monad m, HasLogFunc m)
  => Int -- ^ number of times to retry
  -> m (Maybe a) -- ^ action to retry
  -> m (Maybe a)
retry n action = action >>= go 1
  where
    go i res =
      case res of
        Nothing ->
          if i > n
            then return res
            else do
              logInfo $ "Retrying " <> show i <> "/" <> show n
              res' <- action
              go (i + 1) res'
        _ -> return res

class HasLogFunc env where
  logInfo :: String -> env ()

instance HasLogFunc IO where
  logInfo = putStrLn
