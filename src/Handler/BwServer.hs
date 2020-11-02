{-# LANGUAGE OverloadedStrings     #-}

module Handler.BwServer
  ( getBwServerR
  , postBwServerR
  )
where

import           Import
import           Data.Aeson

data BwServerGetJson = BwServerGetJson {description :: String, method :: String, variables :: [String], result :: String}

instance ToJSON BwServerGetJson where
  toJSON (BwServerGetJson d m v r) = object ["description" .= d, "method" .= m, "variables" .= v, "result" .= r]

getBwServerR :: Handler Value
getBwServerR = do
  let response = BwServerGetJson "Determine necessary server bandwidth"
                                 "POST a json to this endpoint"
                                 ["nblisteners", "bitrate (kb/s)"]
                                 "Server bandwidth (Mib/s)"
  returnJson response

data BwServerJson = BwServerJson
    { nblisteners :: Float
    , bitrate :: Float
    } deriving (Eq, Show)

instance ToJSON BwServerJson where
  toJSON (BwServerJson n b) = object ["nblisteners" .= n, "bitrate" .= b]

instance FromJSON BwServerJson where
  parseJSON = withObject "BwServerJson"
    $ \v -> BwServerJson <$> v .: "nblisteners" <*> v .: "bitrate"

postBwServerR :: Handler Value
postBwServerR = do
  json_payload <- requireCheckJsonBody :: Handler BwServerJson
  let response = object ["result" .= result]       where
        result = 125 * nblisteners json_payload * bitrate json_payload / 128
  returnJson response
