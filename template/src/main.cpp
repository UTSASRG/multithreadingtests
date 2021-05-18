#include <iostream>
#include <thread>
#include <chrono>
#include <fstream>

using namespace std;

#ifdef USE_TESTLIB
#include "main.h"
#endif

int main(){
    cout<<"Benchmark running, I'll sleep for 1sec to simulate actual computation."<<endl;
    std::this_thread::sleep_for (std::chrono::seconds(1));
    cout<<"I'll then allocate 1MB memory to simulate actual memory usage."<<endl;
    void* memPtr=malloc(10240);
    free(memPtr);

    cout<<"I'll then read and print input."<<endl;
	// Read and print input.in
    string myText;
    ifstream MyReadFile("input.in");
    while (getline (MyReadFile, myText)) {
        cout << myText;
    }
    MyReadFile.close(); 


#ifdef USE_TESTLIB
    cout<<"Test library was linked. 1+2="<<add(1,2)<<endl;
#endif

    return 0;
}
