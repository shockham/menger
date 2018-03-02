
all: build

build:
	elm-make src/*.elm --warn --output=build/js/main.js

live:
	elm-live src/*.elm --warn --output=build/js/main.js
