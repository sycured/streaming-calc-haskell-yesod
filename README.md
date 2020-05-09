# streaming-calc-haskell-yesod

[![Build Status](https://travis-ci.com/sycured/streaming-calc-haskell-yesod.svg?branch=master)](https://travis-ci.com/sycured/streaming-calc-haskell-yesod)

Bandwidth calculation for streaming server - webservice | Rewrite from my original in Python

## Compilation

    stack build

## Usage

### Run the server

	./streaming-calc-haskell-yesod

By defaut, it's listening on 127.0.0.1:3000 but it can be tuned via env var:

- YESOD_HOST: define ip address
- YESOD_PORT: define port

Arguments available: nothing


### Information about endpoints

	curl http://localhost:3000
	curl http://localhost:3000/bwserver
	curl http://localhost:3000/serverusagebw

### Determine necessary server bandwidth

    curl -XPOST -H "Content-Type: application/json" --data '{"nblisteners":250,"bitrate":64}' http://localhost:3000/bwserver

**Output**

    {"result":15625}

### Determine the amount of data used for the streaming

    curl -XPOST -H "Content-Type: application/json" --data '{"nblisteners":250,"bitrate":64,"nbdays":1,"nbhours":24}' http://localhost:3000/serverusagebw

**Output**

    {"result":164794.92}
