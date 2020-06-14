(CXXFLAGS)=-Wall -Werror
(CXX)=g++

all: changeOfBase newAlphabet scientificFloating triMatMult

changeOfBase: changeOfBase.o
	$(CXX) $(CXXFLAGS) -o $@ $^
newAlphabet: newAlphabet.o
	$(CXX) $(CXXFLAGS) -o $@ $^
scientificFloating: scientificFloating.cpp
	$(CXX) $(CXXFLAGS) -o $@ $^
triMatMult: triMatMult.o
	$(CXX) $(CXXFLAGS) -o $@ $^
clean:
	rm -f changeOfBase newAlphabet scientifcFloating triMatMult *.o
