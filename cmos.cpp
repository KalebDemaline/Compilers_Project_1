// A C++ program that can read in one file containing all tokenized submissions
// (tokens.txt) and performs the fingerprint analysis as described in the Winnowing Algorithm
// paper.

// 2. Create digital “fingerprints” for each program based on the tokenized code.
// 3. Compare pairs of programs for number of matching fingerprints. A higher number of matching
// fingerprints indicates potential plagiarism.

#include <iostream>

using namespace std;

// void winnow(int window_size /*window size*/) {
//     // circular buffer implementing window of size w
//     hash_t h[window_size];
//     for (int i = 0; i < window_size; ++i) h[i] = INT_MAX;
//     int right = 0; // window right end
//     int min_hash_index = 0;
//     while (true) {
//         right = (right + 1) % window_size;
//         h[right] = next_hash();
//         if (min_hash_index == right) {
//             for(int i = (right-1) % window_size; i != right; i = (i-1+window_size) % window_size)
//             if (h[i] < h[min_hash_index]) min_hash_index = i;
//             record(h[min_hash_index], global_pos(min_hash_index, right, window_size));
//         } else {
//             if (h[right] <= h[min_hash_index]) {
//                 min_hash_index = right;
//                 record(h[min_hash_index], global_pos(min_hash_index, right, window_size));
//             }
//         }
//     }
// }

int main(){

}