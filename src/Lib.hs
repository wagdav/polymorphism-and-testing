module Lib
  ( someFunc
  ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"

question :: IO (Maybe Int)
question = do
  putStr "Give me a positive integer: "
  input <- getLine
  let val = read input
  if val > 0
    then do
      putStrLn "Good choice!"
      return $ Just val
    else do
      putStrLn "Wrong!"
      return Nothing

retry :: Int -> IO (Maybe a) -> IO (Maybe a)
retry n action = action >>= go 1
  where
    go i res =
      case res of
        Nothing ->
          if i > n
            then return res
            else do
              putStrLn $ "Retrying " <> show i <> "/" <> show n
              res' <- action
              go (i + 1) res'
        _ -> return res
