{-# LANGUAGE OverloadedStrings #-}

module EightTracks.Types
       ( Player(..)
       , Status(..)
       , Mix(..)
       ) where

import Control.Applicative ((<$>), (<*>))
import Control.Monad       (liftM)

import           Data.Aeson (FromJSON (..), Value (..), (.:))
import qualified Data.Text  as T

data Player = LoggedOut { login    :: T.Text
                        , password :: T.Text
                        }
            | LoggedIn  { userToken :: T.Text
                        , status    :: Status
                        }
            deriving (Show)

data Status = Playing
            | Paused
            | Stopped
            deriving (Eq, Show)

type HTTPMethod = String
type HTTPUrl = String
type HTTPBody = T.Text

data Mix = Mix { getId          :: String
               , getDuration    :: Int
               , getName        :: T.Text
               , getDescription :: T.Text
               , getTrackCount  :: Int
               , getTagList     :: [T.Text]
               }
         deriving (Show)

instance FromJSON Mix where
  parseJSON (Object v) = Mix
                         <$> (v .: "id")
                         <*> (v .: "duration")
                         <*> (v .: "name")
                         <*> (v .: "description")
                         <*> (v .: "tracks_count")
                         <*> liftM tagListParser (v .: "tag_list_cache")

tagListParser :: T.Text -> [T.Text]
tagListParser t = map rmComma $ T.words t
  where rmComma :: T.Text -> T.Text
        rmComma t = case T.last t of
          ',' -> T.init t
          _ -> t
