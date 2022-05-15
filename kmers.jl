module Kmers

# Make 1000 sequences of length 25,000
data = [rand(UInt8.(collect("ACGT")), 25_000) for i in 1:1000]

# Make a Look Up Table to get the binary representation of each nucleotide
const LUT = let
    lut = fill(0xff, 256)
    for (i, char) in enumerate("ACGT")
        lut[UInt8(char) + 1] = i - 1
    end
    Tuple(lut)
end

# Fill i'th column of matrix with kmer counts from dna_bytes
encode(dna, i) = @inbounds LUT[dna[i] + 1]
function count_kmers!(matrix, index, dna_bytes) 
    kmer = (
        (encode(dna_bytes, 1) << 4) |
        (encode(dna_bytes, 2) << 2) |
        (encode(dna_bytes, 3) << 0)
    )
    for i in 4:lastindex(dna_bytes)
        kmer = (kmer << 2) | encode(dna_bytes, i)
        @inbounds matrix[kmer + 1, index] += 0x01
    end
end

function count_matrix(data, matrix)
    fill!(matrix, zero(eltype(matrix))) # Reset matrix
    for (i, dna_bytes) in enumerate(data)
        count_kmers!(matrix, i, dna_bytes)
    end
    matrix
end

matrix = zeros(Int32, 256, length(data))
x = count_matrix(data, matrix)

end # module
