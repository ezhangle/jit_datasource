CXX = clang++

CXXFLAGS = -DMAPNIK_DEBUG -fPIC -O0 -g $(shell mapnik-config --cflags) -DURDL_DISABLE_SSL=1 -Iurdl/include

LIBS = -lfreetype -lyajl $(shell mapnik-config --libs --ldflags) -licuuc -lboost_thread-mt -lboost_system-mt

SRC = $(wildcard *.cpp) urdl/src/urdl.cpp

OBJ = $(SRC:.cpp=.o)

BIN = jit.input

all : $(SRC) $(BIN)

$(BIN) : $(OBJ)
	$(CXX) -shared $(OBJ) $(LIBS) -o $@

.cpp.o :
	$(CXX) -c $(CXXFLAGS) $< -o $@

.PHONY : clean

clean:
	rm -f $(OBJ)
	rm -f $(BIN)

deploy:
	cp jit.input $(shell mapnik-config --input-plugins)

install: clean all deploy
