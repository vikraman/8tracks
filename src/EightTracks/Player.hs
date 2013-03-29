{-# LANGUAGE OverloadedStrings #-}

module EightTracks.Player
       ( playerLogin
       ) where

import Control.Monad.IO.Class (liftIO)

import Data.Conduit            (($$+-))
import Data.Conduit.Attoparsec (sinkParser)
import Network.HTTP.Conduit

import           Data.Aeson              (Value (..), decode)
import           Data.Aeson.Parser       (json)
import qualified Data.HashMap.Strict     as HM
import           Data.Text.Format        hiding (print)
import qualified Data.Text.Lazy.Encoding as TLE

import EightTracks.Config
import EightTracks.Types

-- request :: HTTPMethod -> HTTPUrl -> Maybe HTTPBody -> m Value
request m u b = withManager $ \manager ->
  do initReq <- parseUrl u
     let req = initReq { method = m
                       , requestHeaders =
                         [ ("X-Api-Version", "2")
                         , ("X-Api-Key", apiKey)
                         ]
                       , requestBody =
                           RequestBodyLBS $ TLE.encodeUtf8 b
                       }
     res <- http req manager
     responseBody res $$+- sinkParser json

playerLogin :: Player -> IO Player
playerLogin (LoggedOut l p) = do
  let body = format "login={}&password={}" (l, p)
  (Object hm) <- request "POST" "http://8tracks.com/sessions.jsonp" body
  case HM.lookup "user_token" hm of
    Nothing -> error "Couldn't login"
    Just (String ut) -> return $ LoggedIn ut Stopped
