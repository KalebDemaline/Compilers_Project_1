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

void winnow (int w){
    deque<int> buffer(w, INT_MAX);

    int r = 0;
    int min_hash_index = 0;

    for (int k_index = 0; k_index < hashes.size(); k_index++){    
        r = (r+1) % w;
        // buffer[r] = hashes[k_index];    // Add next hash
        buffer.push_back(hashes[k_index]);
        buffer.pop_front();

        if (min_hash_index == r){
            // find rightmost min
            for (int i = (r-1)%w; i != r; i = (i-1+w)%w)
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

// void winnow(int w /*window size*/) {
//     // circular buffer implementing window of size w
//     hash_t h[w];
//     for (int i=0; i<w; ++i) h[i] = INT_MAX;
//     int r = 0; // window right end
//     int min = 0; // index of minimum hash
//     // At the end of each iteration, min holds the
//     // position of the rightmost minimal hash in the
//     // current window. record(x) is called only the
//     // first time an instance of x is selected as the
//     // rightmost minimal hash of a window.
//     while (true) {
//         r = (r + 1) % w; // shift the window by one
//         h[r] = next_hash(); // and add one new hash
//         if (min == r) {
//             // The previous minimum is no longer in this
//             // window. Scan h leftward starting from r
//             // for the rightmost minimal hash. Note min
//             // starts with the index of the rightmost
//             // hash.
//             for(int i=(r-1)%w; i!=r; i=(i-1+w)%w)
//                 if (h[i] < h[min]) min = i;
//             record(h[min], global_pos(min, r, w));
//         } else {
//             // Otherwise, the previous minimum is still in
//             // this window. Compare against the new value
//             // and update min if necessary.
//             if (h[r] <= h[min]) { // (*)
//                 min = r;
//                 record(h[min], global_pos(min, r, w));
//             }
//         }
//     }
// }