From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Optane nvdimm performance
Date: Sun, 29 Mar 2020 16:25:30 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2003291116490.9236@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-nvdimm@lists.01.org
List-Id: dm-devel.ids

Hi

I performed some microbenchmarks on a system with real Optane-based nvdimm 
and I found out that the fastest method how to write to persistent memory 
is to fill a cacheline with 8 8-byte writes and then issue clwb or 
clflushopt on the cacheline. With this method, we can achieve 1.6 GB/s 
throughput for linear writes. On the other hand, non-temporal writes 
achieve only 1.3 GB/s.

The results are here:
http://people.redhat.com/~mpatocka/testcases/pmem/microbenchmarks/pmem.txt

The benchmarks here:
http://people.redhat.com/~mpatocka/testcases/pmem/microbenchmarks/

The winning benchmark is this:
http://people.redhat.com/~mpatocka/testcases/pmem/microbenchmarks/thrp-write-8-clwb.c


However, the kernel is not using this fastest method, it is using 
non-temporal stores instead.


I took the novafs filesystem (see git clone 
https://github.com/NVSL/linux-nova), it uses 
__copy_from_user_inatomic_nocache, which calls __copy_user_nocache which 
performs non-temporal stores. I hacked __copy_user_nocache to use clwb 
instead of non-temporal stores and it improved filesystem performance 
significantly.

This is the patch
http://people.redhat.com/~mpatocka/testcases/pmem/benchmarks/copy-nocache.patch 
(for the kernel 5.1 because novafs needs this version) and these are 
benchmark results:
http://people.redhat.com/~mpatocka/testcases/pmem/benchmarks/fs-bench.txt

- you can see that "test2" has twice the write throughput of "test1"


I took the dm-writecache driver, it uses memcpy_flushcache to write data 
to persistent memory. I hacked memcpy_flushcache to use clwb instead of 
non-temporal stores.

The result is - for 512-byte writes, non-temporal stores perform better 
than cache flushing. For 1024-byte and larger writes, cache flushing 
performs better than non-temporal stores. (I also tried to use cached 
writes + clwb for dm-writecache metadata updates, but it had bad 
performance)


Do you have some explanation why nontemporal stores are better for 
512-byte copies and worse for 1024-byte copies? (like filling up some 
buffers inside the CPU)?

In the next email, I'm sending a patch that makes memcpy_flushcache use 
clflushopt for transfers larger than 768 bytes.


Mikulas
