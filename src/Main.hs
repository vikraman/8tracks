{-# LANGUAGE OverloadedStrings #-}

import EightTracks.Config
import EightTracks.Player
import EightTracks.Types

main :: IO ()
main = withConfig $ \config ->
  playerLogin (LoggedOut
               (getLogin config)
               (getPassword config)
              ) >>= print
