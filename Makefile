build:
	coffee -j miskatonic.js -c src/*.coffee

min:
	coffee -pjc src/*.coffee | uglifyjs --unsafe -o miskatonic.min.js

clean:
	rm -f miskatonic.js miskatonic.min.js

test:
	python -m http.server
