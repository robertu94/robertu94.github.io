---
title: "Approachable Error Bounded Lossy Compression"
layout: presentation
location: Supercomputing 20 Doctoral Showcase
date: 2020-11-01
description: >
  Compression is commonly used in HPC applications to move and store data. Traditional losslesscompression, however, does not provide adequate compression of floating point data often found inscientific codes. Recently, researchers and scientists have turned to lossy compression techniquesthat approximate the original data rather than reproduce it in order to achieve desired levels ofcompression. Typical lossy compressors do not bound the errors introduced into the data, leading to the development of error bounded lossy compressors (EBLC). These tools provide the desired levelsof compression as mathematical guarantees on the errors introduced. The current state of EBLCleaves much to be desired. The existing EBLC all have different interfaces requiring codes to bechanged to adopt new techniques; EBLC have many more configuration options than theirpredecessors, making them more difficult to use; and EBLC typically bound quantities like pointwise errors rather than higher level metrics such as spectra, p-values, or test statistics thatscientists typically use. My dissertation aims to provide a uniform interface to compression and todevelop tools to allow application scientists to understand and apply EBLC. This canvas presentsthree groups of work: LibPressio, a standard interface for compression and analysis;FRaZ/LibPressio-Opt frameworks for the automated configuration of compressors using LibPressio;and work on tools for analyzing errors in particular domains
slides: sc20-doctoral.pdf
video: https://www.youtube.com/watch?v=6VSJpevcEhE
...

