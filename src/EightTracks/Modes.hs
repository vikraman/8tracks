{-# LANGUAGE DeriveDataTypeable #-}

module EightTracks.Modes
       ( mode
       , runMode
       ) where

import System.Console.CmdArgs

data Player = Find { tags :: Maybe [String]
                   , sort :: Maybe SortMode
                   }
            | Info { mix :: Int
                   }
            | Play { mix :: Int
                   }
            deriving (Data, Typeable, Show, Eq)

data SortMode = Recent | Popular | Hot
              deriving (Data, Typeable, Show, Eq)

find :: Player
find = Find { tags = def
            , sort = def
            }

info :: Player
info = Info { mix = def }

play :: Player
play = Play { mix = def }

mode :: Mode (CmdArgs Player)
mode = cmdArgsMode $ modes [find, info, play &= auto]

runMode :: Player -> IO ()
runMode = print
