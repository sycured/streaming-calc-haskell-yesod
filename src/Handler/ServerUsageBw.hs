{-# LANGUAGE OverloadedStrings     #-}

module Handler.ServerUsageBw
  ( getServerUsageBwR
  , postServerUsageBwR
  )
where

import           Import
import           Data.Aeson


data ServerUsageBwGetJson = ServerUsageBwGetJson {description :: Text, method :: String, variables :: [String], result :: String}

instance ToJSON ServerUsageBwGetJson where
  toJSON (ServerUsageBwGetJson d m v r) =
    object ["description" .= d, "method" .= m, "variables" .= v, "result" .= r]

getServerUsageBwR :: Handler Value
getServerUsageBwR = do
  let response = ServerUsageBwGetJson
        "Determine the amount of data used for the streaming"
        "POST a json to this endpoint"
        ["nblisteners", "bitrate (kb/s)", "nbdays", "nbhours"]
        "Bandwidth used (GiB)"
  returnJson response


data ServerUsageBwJson = ServerUsageBwJson
    { nblisteners :: Float
    , bitrate :: Float
    , nbdays :: Float
    , nbhours :: Float
    } deriving (Eq, Show)

instance ToJSON ServerUsageBwJson where
  toJSON (ServerUsageBwJson n b h d) =
    object ["nblisteners" .= n, "bitrate" .= b, "nbdays" .= d, "nbhours" .= h]

instance FromJSON ServerUsageBwJson where
  parseJSON = withObject "ServerUsageBwJson" $ \v ->
    ServerUsageBwJson
      <$> v
      .:  "nblisteners"
      <*> v
      .:  "bitrate"
      <*> v
      .:  "nbdays"
      <*> v
      .:  "nbhours"

postServerUsageBwR :: Handler Value
postServerUsageBwR = do
  json_payload <- requireCheckJsonBody :: Handler ServerUsageBwJson
  let response = object ["result" .= result]       where
        result =
          nbdays json_payload
            * nbhours json_payload
            * 3600
            * bitrate json_payload
            * 1000
            / 8
            * nblisteners json_payload
            / 1024
            / 1024
  returnJson response
