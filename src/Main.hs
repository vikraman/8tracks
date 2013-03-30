{-# LANGUAGE OverloadedStrings #-}

import System.Console.CmdArgs

import EightTracks.Config
import EightTracks.Modes
import EightTracks.Player
import EightTracks.Types

main :: IO ()
main = runMode =<< cmdArgsRun mode
