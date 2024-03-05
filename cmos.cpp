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

vector<pair<size_t,int>> winnow (int w, const vector<size_t>& get_hash){
    deque<size_t> buffer(w, SIZE_T_MAX);
    vector<pair<size_t,int>> fingerprints;
    int min_hash_index = 0;

    // Load initial k grams
    for (int k_idx = 0; k_idx < w-1; k_idx++){
        buffer.push_back(get_hash[k_idx]);
        buffer.pop_front();
        min_hash_index--;
    }

    for (int k_idx = w-1; k_idx < get_hash.size(); k_idx++){
        buffer.push_back(get_hash[k_idx]);
        buffer.pop_front();
        min_hash_index--;
        
        if (min_hash_index == -1){
            min_hash_index = w-1;
            for(int i = w-1; i >= 0; i--)
                if (buffer[i] < buffer[min_hash_index]) min_hash_index = i;
            fingerprints.push_back({buffer[min_hash_index],k_idx - (w-1-min_hash_index)});
        } else {
            if (buffer.back() <= buffer[min_hash_index]){
                min_hash_index = w-1;
                fingerprints.push_back({buffer[min_hash_index],k_idx});
            }
        }
    }
    return fingerprints;
}

int main(){
    string token, tmp;
    int k = 5, w = 4;
    hash<string> magic_hash_machine;
    vector<string> tokens;

    while(cin >> token) tokens.push_back(token);
    vector<size_t> kgram_hash(tokens.size()-k);

    for (int i = 0; i < tokens.size()-k; i++){
        for (int j = i; j < i + k; j++)
            tmp += tokens[j];
        kgram_hash[i] = magic_hash_machine(tmp);
    }

    cout << "\n\n" << kgram_hash.size() << '\n';

    // vector<size_t> kgram_hash2 = {77,74,42,17,98,50,17,98,8,88,67,39,77,74,42,17,98};
    // auto fingerprints = winnow(w,kgram_hash2);
    
    auto fingerprints = winnow(w,kgram_hash);

    for(auto fp: fingerprints)
        cout << fp.first << '\t' << fp.second << '\n';
    
    cout << "\n\n" << fingerprints.size() << '\n';
}
