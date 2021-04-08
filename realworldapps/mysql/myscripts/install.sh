
#Assue the first argument is the name of allocator

mkdir -p "./src/install/$1"
make install DESTDIR="./src/install/$1"