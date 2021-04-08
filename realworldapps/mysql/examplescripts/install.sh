
#Assue the first argument is the name of allocator

cd src/build
make install DESTDIR="../install/$1"
cd ../..