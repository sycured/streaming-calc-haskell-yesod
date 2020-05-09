{-# LANGUAGE OverloadedStrings     #-}

module Handler.Home
  ( getHomeR
  )
where

import           Data.Aeson
import           Import

data HomeGetJson = HomeGetJson { app :: String, developer :: String, method :: String, endpoints :: [String], status :: String}

instance ToJSON HomeGetJson where
  toJSON (HomeGetJson a d m e s) =
    object ["app" .= a, "developer" .= d, "method" .= m, "endpoints" .= e, "status" .= s]

getHomeR :: Handler Value
getHomeR = do
  let response = HomeGetJson "streaming-calc-haskell-yesod"
                             "sycured"
                             "POST a json to this endpoint"
                             ["/bwserver", "/serverusagebw"]
                             "ready"
  returnJson response
