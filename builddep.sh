#!/bin/bash 

sudo apt-get install libblas-dev liblapack-dev libgsl0-dev gfortran
cabal install transformers 
cabal install hscolour
cabal install hmatrix 

mkdir deps
git clone https://github.com/wavewave/devadmin.git deps/devadmin
cd deps/devadmin ; cabal install --force-reinstalls ; cd ../../
$HOME/.cabal/bin/build cloneall --config=build.conf

# for dep installation
$HOME/.cabal/bin/build bootstrap --config=build.conf

# for documentation of dep packages
$HOME/.cabal/bin/build haddockboot --config=build.conf 

# for documentation of this package
cabal install  --enable-documentation
cabal haddock --hyperlink-source
cabal copy 


# upload documentation
tar cvzf madgraph-auto-model.tar.gz $HOME/.cabal/share/doc/madgraph-auto* $HOME/.cabal/share/doc/LHE* $HOME/.cabal/share/doc/HEPUtil*  $HOME/.cabal/share/doc/LHCOAnalysis*
echo $CR | curl --digest -T madgraph-auto-model.tar.gz -K - $SRVRURL 

# this is needed for checking
cabal install --enable-tests


