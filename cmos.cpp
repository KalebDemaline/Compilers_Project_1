// A C++ program that can read in one file containing all tokenized submissions
// (tokens.txt) and performs the fingerprint analysis as described in the Winnowing Algorithm
// paper.

// 2. Create digital “fingerprints” for each program based on the tokenized code.
// 3. Compare pairs of programs for number of matching fingerprints. A higher number of matching
// fingerprints indicates potential plagiarism.

#include <iostream>
#include <deque>
#include <functional>

using namespace std;

vector<string> tokens;
vector<size_t> hashes;
vector<pair<int,size_t>> record;

void winnow (int w){
    deque<size_t> buffer(w, INT_MAX);
    int min_hash_index = w;

    for (int k_idx = 0; k_idx < hashes.size(); k_idx++){
        buffer.push_back(hashes[k_idx]);
        buffer.pop_front();
        min_hash_index--;
        
        if (min_hash_index == -1){
            for(int i = w-1; i >= 0; i--)
                if (buffer[i] < buffer[min_hash_index]) min_hash_index = i;
            record.push_back({k_idx, buffer[min_hash_index]});
        } else {
            if (buffer.back() <= buffer[min_hash_index]){
                min_hash_index = w-1;
                record.push_back({k_idx, buffer[min_hash_index]});
            }
        }
    }
}

int main(){
    string token, tmp;
    int k = 10,w = 8;
    hash<string> magic_hash_machine;
    while(cin >> token) tokens.push_back(token);

    hashes.resize(tokens.size()-k);

    for (int i = 0; i < tokens.size()-k; i++){
        for (int j = i; j < i + k; j++)
            tmp += tokens[j];
        hashes[i] = magic_hash_machine(tmp);
    }

    winnow(w);

    for(auto h: record)
        cout << h.first << '\t' << h.second << '\n';
    
    cout << "\n\n" << record.size() << '\n';
}
