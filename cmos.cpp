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
vector<pair<size_t,int>> record;

void winnow (int window_size){
    deque<int> buffer(window_size, INT_MAX);

    int r = 0;
    int min_hash_index = 0;

    for (int k_index = 0; k_index < hashes.size(); k_index++){    
        r = (r+1) % window_size;
        // buffer[r] = hashes[k_index];    // Add next hash
        buffer.push_back(hashes[k_index]);
        buffer.pop_front();

        if (min_hash_index == r){
            // find rightmost min
            for (int i = (r-1)%window_size; i != r; i = (i-1+window_size)%window_size)
                if (buffer[i] < buffer[min_hash_index]) min_hash_index = i;
            record.push_back({buffer[min_hash_index],k_index});
        } else {
            if (buffer[r] <= buffer[min_hash_index]){
                min_hash_index = r;
                record.push_back({buffer[min_hash_index],k_index});
            }
        }
    }
}

int main(){
    string token, tmp;
    int window_size = 8;
    hash<string> magic_hash_machine;
    while(cin >> token) tokens.push_back(token);

    hashes.resize(tokens.size()-window_size);

    for (int i = 0; i < tokens.size()-window_size; i++){
        for (int j = i; j < i + window_size; j++)
            tmp += tokens[j];
        hashes[i] = magic_hash_machine(tmp);
    }

    winnow(window_size);

    for(auto h: record){
        cout << h.second << '\t' << h.first << '\n';
    }
    
    cout << "\n\n" << record.size() << '\n';
}

// int winnow (int window_size){
//     deque<int> buffer(window_size, INT_MAX);
//     vector<pair<int,int>> record;

//     int r = 0;
//     int min_hash_index = 0;
    
//     while (true){
//         r = (r+1) % window_size;
//         buffer[r] = next_hash();    // Add next hash

//         if (min_hash_index == r){
//             // find rightmost min
//             for (int i = (r-1)%window_size; i != r; i = (i-1+window_size)%window_size)
//                 if (buffer[i] < buffer[min_hash_index]) min_hash_index = i;
//             record(buffer[min_hash_index], global_pos(min_hash_index, r, window_size))
//         } else {
//             if (buffer[r] <= buffer[min_hash_index]){
//                 min_hash_index = r;
//                 record(buffer[min_hash_index], global_pos(min_hash_index, r, window_size));
//             }
//         }
//     }
//     return 0;
// }