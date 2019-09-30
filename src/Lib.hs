module Lib where

import Data.Maybe
import Text.Read

someFunc :: IO ()
someFunc = putStrLn "someFunc"

question :: IO (Maybe Int)
question = do
  putStr "Give me an integer: "
  readMaybe <$> getLine

retry :: (Monad m, HasLogFunc m) => Int -> m (Maybe a) -> m (Maybe a)
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
