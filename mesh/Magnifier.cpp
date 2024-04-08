#include <sstream>
#include <string>
#include <fstream>
#include <iostream>
#include <iomanip>
using namespace std;

int main(){
    setprecision(17);
    string line;
    ifstream infile("./pancreas.msh");
    ofstream myfile("./pancreas.msh-mag");
    for (int i=1; i<15; i++){ 
        std::getline(infile, line);
        istringstream iss(line);
        myfile<<line<<endl;}
   
    std::getline(infile, line);
    istringstream iss(line);
    myfile<<line<<endl;
    
    int Nodes, index;
    float x, y, z;
    iss>>Nodes; cout<<Nodes<<endl;
    
    for (int i=1; i<=Nodes; i++){
    getline(infile, line);
    
    istringstream iss(line);
    iss>>index >> x>> y>> z;
    x=x/47.0; y=y/47.0; z=z/47.0;
    myfile<<setprecision(15)<<index<<" "<<x<<" "<<y<<" "<<z<<endl;
    }

    while (getline(infile, line)){  
          myfile<<line<<endl;
    }
    
    return 0;
}
