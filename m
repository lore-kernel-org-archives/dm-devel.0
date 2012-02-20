From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Benchmarking dm-crypt with different block size,
 request number and scheduler
Date: Mon, 20 Feb 2012 15:47:18 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1202201201330.10690@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi

As you asked to run benchmarks with more requests and bigger block size to 
test if sorting inside dm-crypt is needed. Here are the results.

Conclusion: if I increase the number of requests to 1000000, the cfq 
scheduler behaves nondeterministically, the same workload on the raw 
device (without crypt) takes sometimes 15 seconds and sometimes 34 
seconds. Cfq scheduler was likely not designed to run with such high 
request count.

Even with the number of requests increased to 1000000 and block size 
increased to 4096, dm-crypt still benefits from sorting writes 
(performance is 3 times better when sorting requests in dm-crypt).

The deadline scheduler behaves much more deterministically than cfq, 
increasing the number of requests to 1000000 generally fixes the problems 
and makes sorting in dm-crypt not needed. With 100000 requests and 4096 
block size, sorting in dm-crypt still improves performance, but only a 
little (17 seconds without sorting, 14 with sorting).

Mikulas



Data:

raw device: benchmark on raw device without crypt
dm-crypt-without-sorting: dm crypt without request sorting.
dm-crypt-offload-writes-to-thread: dm crypt with all write requests 
	submitted to a thread. No sorting of requests is done.
dm-crypt-retain-write-ordering: dm crypt with write requests being 
	submitted in the same order they were received in.
dm-crypt-sort-writes: dm crypt with write requests being sorted using 
	red-black tree.

cfq scheduler, blocksize 512, 128 requests:
raw device: 0m15.934s
dm-crypt-without-sorting: 3m57.734s
dm-crypt-offload-writes-to-thread: 0m25.923s
dm-crypt-retain-write-ordering: 0m21.940s
dm-crypt-sort-writes: 0m20.812s

cfq scheduler, blocksize 512, 1000000 requests:
raw device: 0m15.087s-0m34.446s (the result varies and seems to depend on 
previous workload)
dm-crypt-without-sorting: 0m49.316s
dm-crypt-offload-writes-to-thread: 0m22.118s
dm-crypt-retain-write-ordering: 0m21.939s
dm-crypt-sort-writes: 0m21.451s

cfq scheduler, blocksize 4096, 128 requests:
raw device: 0m14.558s
dm-crypt-without-sorting: 0m40.323s
dm-crypt-offload-writes-to-thread: 0m15.267s
dm-crypt-retain-write-ordering: 0m13.953s
dm-crypt-sort-writes: 0m13.902s

cfq scheduler, blocksize 4096, 1000000 requests:
raw device: 0m15.236s-0m23.367s (the result varies)
dm-crypt-without-sorting: 0m45.478s
dm-crypt-offload-writes-to-thread: 0m14.187s
dm-crypt-retain-write-ordering: 0m14.013s
dm-crypt-sort-writes: 0m13.954s


deadline scheduler, blocksize 512, 128 requests:
raw device: 0m15.211s
dm-crypt-without-sorting: 3m59.977s
dm-crypt-offload-writes-to-thread: 0m14.819s
dm-crypt-retain-write-ordering: 0m15.027s
dm-crypt-sort-writes: 0m14.598s

deadline scheduler, blocksize 512, 1000000 requests:
raw device: 0m15.412s
dm-crypt-without-sorting: 0m15.125s
dm-crypt-offload-writes-to-thread: 0m14.877s
dm-crypt-retain-write-ordering: 0m14.893s
dm-crypt-sort-writes: 0m14.741s

deadline scheduler, blocksize 4096, 128 requests:
raw device: 0m14.143s
dm-crypt-without-sorting: 0m22.124s
dm-crypt-offload-writes-to-thread: 0m14.793s
dm-crypt-retain-write-ordering: 0m13.917s
dm-crypt-sort-writes: 0m13.943s

deadline scheduler, blocksize 4096, 1000000 requests:
raw device: 0m15.208s
dm-crypt-without-sorting: 0m17.642s
dm-crypt-offload-writes-to-thread: 0m14.308s
dm-crypt-retain-write-ordering: 0m13.973s
dm-crypt-sort-writes: 0m14.025s
