{-# LANGUAGE OverloadedStrings #-}

module Handler.ServerUsageBwSpec
  ( spec
  )
where

import           TestImport
import           Data.Aeson

spec :: Spec
spec = withApp $ do

  describe "ServerUsageBw" $ do
    it "loads and checks it looks right" $ do
      get ServerUsageBwR
      statusIs 200
      bodyContains "Determine the amount of data used for the streaming"
  it "do a computation" $ do
    request $ do
      addRequestHeader ("Content-Type", "application/json")
      setMethod "POST"
      setUrl ServerUsageBwR
      setRequestBody $ encode $ object
        [ "nblisteners" .= (250 :: Float)
        , "bitrate" .= (64 :: Float)
        , "nbdays" .= (1 :: Float)
        , "nbhours" .= (24 :: Float)
        ]
    statusIs 200
    bodyContains "164794.92"
