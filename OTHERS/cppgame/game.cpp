#include <iostream>

using namespace std;

bool turn(int segredo[4], bool vezf){
    int bullsf = 0, cowsf = 0;
    int tentativa[4];
    
    if(vezf) cout << "P2 G: ";
    else cout << "P1 G: ";

    for(int i = 0; i < 4; i++){
        cin >> tentativa[i]; // recebe tentativa
    }

    for(int i = 0; i < 4; i++){
        for(int j = 0; j < 4; j++){
            if(segredo[i] == tentativa[j]){
                if(i == j){
                    bullsf++;
                }
                else {
                    cowsf++;
                }
            }
        }
    }
    if(bullsf == 4) return true;
    cout << bullsf << " b " << cowsf << " c" << endl;
    return false;
}


int main(){

    int seg1[4], seg2[4];
    bool win = false, vez = false; // se vez false eh p1

    cout << "P1 SETUP" << endl;
    for(int i = 0; i < 4; i++){
        cin >> seg1[i];
    }

    cout << "P2 SETUP" << endl;
    for(int i = 0; i < 4; i++){
        cin >> seg2[i];
    }

    while(!win){
        if(!vez){
            win = turn(seg2, vez);
            if(win) break;
            vez = true;
        }
        else{
            win = turn(seg1, vez);
            if(win) break;
            vez = false;
        }
    }

    cout << endl << "Bullseye! ";
    if(vez) cout << "p2 wins" << endl;
    else cout << "p1 wins" << endl;
    return 0;
}