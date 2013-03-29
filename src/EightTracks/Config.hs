{-# LANGUAGE OverloadedStrings #-}

module EightTracks.Config
       ( Config(..)
       , withConfig
       , apiKey
       ) where

import Data.ByteString
import Data.Configurator
import Data.Text

data Config = Config { getLogin    :: Text
                     , getPassword :: Text
                     }

withConfig :: (Config -> IO ()) -> IO ()
withConfig f = do
  config <- load [ Required "$(HOME)/.8tracksrc" ]
  l <- require config "login" :: IO Text
  p <- require config "password" :: IO Text
  let c = Config l p
  f c

apiKey :: ByteString
apiKey = "6d61f31b0ff438fecf0cdd2bde3c9822eedeb4bb"
