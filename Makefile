
.PHONY: all

all:
	elm-make src/*.elm --warn --output=build/js/main.js

live:
	elm-live src/*.elm --warn --output=build/js/main.js

clean:
	rm build/js/main.js

electron: all
	yarn start
