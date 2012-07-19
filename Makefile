build:
	coffee -j miskatonic.js -c src/*.coffee src/*/*.coffee

min:
	coffee -pjc src/*.coffee src/*/*.coffee | uglifyjs --unsafe -o miskatonic.min.js

doc:
	docco src/*.coffee
