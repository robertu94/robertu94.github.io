---
title: "FRaZ: A Generic High-Fidelity Fixed-Ratio Lossy Compression Framework for Floating Point Scientific Data"
layout: presentation
location: International Parallel and Distributed Processing Symposium 2020 (Virutal)
date: 2020-05-01
description: >
  With ever-increasing volumes of scientific floating-point data being produced by high-performance computingapplications, significantly reducing scientific floating-point datasize is critical, and error-controlled lossy compressors have beendeveloped for years. None of the existing scientific floating-pointlossy data compressors, however, support effective fixed-ratiolossy compression. Yet fixed-ratio lossy compression for scientificfloating-point data not only compresses to the requested ratio butalso respects a user-specified error bound with higher fidelity. Inthis paper, we present FRaZ: a generic fixed-ratio lossy com-pression framework respecting user-specified error constraints.The contribution is twofold. (1) We develop an efficient iterativeapproach to accurately determine the appropriate error settingsfor different lossy compressors based on target compressionratios. (2) We perform a thorough performance and accuracyevaluation for our proposed fixed-ratio compression frameworkwith multiple state-of-the-art error-controlled lossy compressors,using several real-world scientific floating-point datasets fromdifferent domains. Experiments show that FRaZ effectively iden-tifies the optimum error setting in the entire error setting space ofany given lossy compressor. While fixed-ratio lossy compressionis slower than fixed-error compression, it provides an importantnew lossy compression technique for users of very large scientificfloating-point datasets.
video: https://youtu.be/oXpZAEEywHg
slides: ipdps2020-fraz.pdf
acknowledgments: The paper behind this presentation was written by Robert Underwood, Sheng Di, Jon C. Calhoun, and Franck Cappello.
...
<section class="slide level2">

</section>
