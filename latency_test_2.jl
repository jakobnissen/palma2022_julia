module LatencyTest2

using Plots

function create_plots(ys)
	plt_scatter = scatter(
		eachindex(ys[1:10]), # the first 10 indices, i.e. 1:10
		ys[1:10],
		title="Some random points",
		legend=nothing,
		xlabel="X-label",
		ylabel="Y-label"
	)

	savefig(plt_scatter, "random.pdf")

	plt_hist = histogram(
		ys,
		title="Histogram of Gaussian data",
		legend=nothing
	)

	savefig(plt_hist, "hist.png")
end

create_plots(randn(1_000_000))

end # module 
