build:
	coffee -j miskatonic.js -c src/*.coffee

min:
	coffee -pjc src/*.coffee | uglifyjs --unsafe -o miskatonic.min.js

doc:
	docco src/*.coffee

test:
	python -m http.server
