{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Handler.HomeSpec
  ( spec
  )
where

import           TestImport

spec :: Spec
spec = withApp $ do

  describe "Homepage" $ do
    it "loads the index and checks it looks right" $ do
      get HomeR
      statusIs 200
      bodyContains "ready"
    it "POST not available" $ do
      post HomeR
      statusIs 405
