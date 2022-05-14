module Kmers

data = [rand(UInt8.(collect("ACGT")), 10000) for i in 1:1000]
matrix = zeros(UInt32, 256, length(data))

const LUT = fill(0xff, 256)
LUT[UInt8('A') + 1] = 0
LUT[UInt8('C') + 1] = 1
LUT[UInt8('G') + 1] = 2
LUT[UInt8('T') + 1] = 3

encode(dna, i) = @inbounds LUT[dna[i] + 0x01]
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
    matrix
end

function count_matrix(data, matrix)
    fill!(matrix, zero(eltype(matrix)))
    for (i, dna_bytes) in enumerate(data)
        count_kmers!(matrix, i, dna_bytes)
    end
    matrix
end

x = count_matrix(data, matrix)

end # module