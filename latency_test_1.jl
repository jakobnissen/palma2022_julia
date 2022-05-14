module LatencyTest1

using BioSequences
using FASTX: FASTA, FASTA.sequence

data = ">test record
TAGATAA
TAGCC
"

# Try uncommenting some of the lines below!
record = first(FASTA.Reader(IOBuffer(data)))
# println(typeof(record))
seq = LongRNA{2}(sequence(LongDNA{2}, record))
# println(typeof(seq))
println(reverse_complement(seq))
println(last(seq))
# println(typeof(last(seq)))

end # module
