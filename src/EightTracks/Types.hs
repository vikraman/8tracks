{-# LANGUAGE OverloadedStrings #-}

module EightTracks.Types
       ( Player(..)
       , Status(..)
       ) where

import Data.Text

data Player = LoggedOut { login    :: Text
                        , password :: Text
                        }
            | LoggedIn  { userToken :: Text
                        , status    :: Status
                        }
            deriving (Show)

data Status = Playing
            | Paused
            | Stopped
            deriving (Eq, Show)

type HTTPMethod = String
type HTTPUrl = String
type HTTPBody = Text
