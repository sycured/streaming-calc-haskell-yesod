{-# LANGUAGE OverloadedStrings #-}

module Handler.BwServerSpec
  ( spec
  )
where

import           TestImport
import           Data.Aeson

spec :: Spec
spec = withApp $ do

  describe "BwServer" $ do
    it "loads and checks it looks right" $ do
      get BwServerR
      statusIs 200
      bodyContains "Determine necessary server bandwidth"
    it "do a computation" $ do
      request $ do
        addRequestHeader ("Content-Type", "application/json")
        setMethod "POST"
        setUrl BwServerR
        setRequestBody $ encode $ object
          ["nblisteners" .= (250 :: Float), "bitrate" .= (64 :: Float)]
      statusIs 200
      bodyContains "15625"
