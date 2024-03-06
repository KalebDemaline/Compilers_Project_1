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

vector<pair<size_t,int>> winnow (int w, const vector<string>& k_grams, hash<string>& hasher){
    deque<size_t> buffer(w, SIZE_T_MAX);
    vector<pair<size_t,int>> fingerprints;
    int min_hash_index = 0;

    // Load initial w k grams
    for (int k_idx = 0; k_idx < w; k_idx++){
        buffer.push_back(hasher(k_grams[k_idx]));
        buffer.pop_front();
    }

    for (int k_idx = w; k_idx < k_grams.size(); k_idx++){
        buffer.push_back(hasher(k_grams[k_idx]));
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
    int k = 5, w = 4;
    hash<string> hasher;
    vector<string> filenames;
    vector<vector<pair<size_t,int>>> fingerprints;

    string filename, tokens;

    while(cin >> filename && getline(cin, tokens)){
        auto end = remove_if(tokens.begin(),tokens.end(),[](char c){return c == ' ';});
        tokens.erase(end,tokens.end());
        filenames.push_back(filename);

        vector<string> k_grams;
        for (int i = 0; i <= tokens.size()-k; i++)
            k_grams.push_back(tokens.substr(i, k));
        
        auto fp = winnow(w,k_grams,hasher);
        fingerprints.push_back(fp);
    }

    // TODO Compare fingerprints
}
