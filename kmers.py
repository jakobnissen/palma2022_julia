import random

data = [
    bytearray(random.choices([ord(i) for i in "ACGT"],
    k=10000)) for i in range(1000)
]
matrix = [[0 for i in range(256)] for j in range(len(data))]

LUT = [255 for i in range(256)]
LUT[ord('A')] = 0
LUT[ord('C')] = 1
LUT[ord('G')] = 2
LUT[ord('T')] = 3

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
    for i in matrix:
        for j in range(len(i)):
            i[j] = 0
    for (i, j) in zip(matrix, data):
        count_kmers(i, j)

    return matrix

x = count_matrix(data, matrix)
