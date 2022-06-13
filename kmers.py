import random

# Make 1000 sequences of length 25,000
data = [
    bytearray(random.choices([ord(i) for i in "ACGT"],
    k=25_000)) for i in range(1000)
]

# Make a Look Up Table to get the binary representation of each nucleotide
LUT = [255 for i in range(256)]
for (i, char) in enumerate("ACGT"):
    LUT[ord(char)] = i

# Fill counts with kmer counts from dna_bytes
def count_kmers(counts, dna_bytes):
    kmer = (
        (LUT[dna_bytes[0]] << 4) |
        (LUT[dna_bytes[1]] << 2) |
        (LUT[dna_bytes[2]] << 0)
    )
    for i in range(3, len(dna_bytes)):
        kmer = ((kmer << 2) | LUT[dna_bytes[i]]) & 255
        counts[kmer] += 1

def count_matrix(data, matrix):
    # Reset matrix
    for i in matrix:
        for j in range(len(i)):
            i[j] = 0
    for (i, j) in zip(matrix, data):
        count_kmers(i, j)

    return matrix

matrix = [[0 for i in range(256)] for j in range(len(data))]
x = count_matrix(data, matrix)
