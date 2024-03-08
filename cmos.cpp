// Jansen Craft & Kaleb Demaline

#include <iostream>
#include <deque>
#include <vector>
#include <algorithm>
#include <climits>
#include <iterator>
#include <iomanip>

using namespace std;

vector<size_t> winnow (int w, const vector<string>& k_grams, hash<string>& hasher){
    deque<size_t> buffer(w, SIZE_T_MAX);
    vector<size_t> fingerprints;
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
            fingerprints.push_back(buffer[min_hash_index]);
        } else {
            if (buffer.back() <= buffer[min_hash_index]){
                min_hash_index = w-1;
                fingerprints.push_back(buffer[min_hash_index]);
            }
        }
    }
    return fingerprints;
}

int main(){
    int k = 20, w = 20;
    hash<string> hasher;
    vector<string> filenames;
    vector<vector<size_t>> fingerprints;

    string filename, tokens;

    while(cin >> filename && getline(cin, tokens)){
        filenames.push_back(filename);
        auto end = remove_if(tokens.begin(),tokens.end(),[](char c){return c == ' ';});
        tokens.erase(end,tokens.end());

        vector<string> k_grams;
        for (int i = 0; i <= tokens.size()-k; i++)
            k_grams.push_back(tokens.substr(i, k));
        
        auto fp = winnow(w,k_grams,hasher);
        fingerprints.push_back(fp);
    }

    // Compare Fingerprints
    for (int i = 0; i < fingerprints.size(); i++)
        sort(fingerprints[i].begin(), fingerprints[i].end());

    vector<pair<float, string>> similarity_scores;
    
    for (int i = 0; i < fingerprints.size(); i++){
        for (int j = i+1; j < fingerprints.size(); j++){
            vector<size_t> intersection;
            set_intersection(
                fingerprints[i].begin(), fingerprints[i].end(),
                fingerprints[j].begin(), fingerprints[j].end(),
                back_inserter(intersection)
            );
            similarity_scores.push_back({(float)intersection.size() / (float)fingerprints[i].size(), filenames[i] + ' ' + filenames[j]});
            intersection.clear();
        }
    }

    sort(similarity_scores.rbegin(), similarity_scores.rend());

    for (auto score: similarity_scores){
        cout << setprecision(3) << setfill('0') << fixed << score.first << "\t" << score.second << '\n';
    }
}
