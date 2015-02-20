From: Ondrej Kozina <okozina@redhat.com>
Subject: Performance testing of related dm-crypt patches
Date: Fri, 20 Feb 2015 10:38:06 +0100
Message-ID: <54E7007E.5000702@redhat.com>
References: <alpine.LRH.2.02.1502130827100.6449@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1502130827100.6449@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi,

the mail will be quite a big one so for better navigation I'm adding 
contents:

[1] Short resume of performance results
[2] Descriptions of test systems
[3] Detailed tests description
[4] Description of dm-crypt modules involved in testing
[5] dm-zero based test results
[6] spin drive based results
[7] spin drive based results (heavy load)
--------------------------------------------------------------------

[1] Short resume of performance results
---------------------------------------

Results for dm-crypt target mapped over dm-zero one (testing pure 
performance of dm-crypt only) show that unbounding the workqueue
is vastly beneficial for very fast devices. Offloading the requests to 
separate thread (before sorting the requests) has some cost (~10% 
compared to after the unbound workqueue patch applied) but it's not 
anything that would kill the performance seriously. Also results show 
that (CPU) price for sorting the requests before submitting to lower 
layer is negligible. Note that with dm-zero backend no I/O scheduler 
steps in.

With spin drives it's not so straightforward, but in summary there're 
still nice performance gains visible. Especially with larger block sizes 
(and deeper queues) the sorting patch improves the performance 
significantly and sometimes matches the performance of raw block device!

Unfortunately there are examples of workloads where even unbounding the 
queue or subsequent offloading of requests to separate thread can hurt 
performance so this is why we decided to introduce 2 switches in 
dm-crypt target constructor. More detailed explanation in [6] and [7].

[2] Descriptions of test systems
--------------------------------

numa_1 : single socket Intel system with 6 cores CPU and hyper-threading 
enabled (12 logical cores), 12GiB ram

numa_2 : two socket Intel system with 2x8 cores with HT enabled (32 
logical cores), 128 GiB ram

numa_4 : 4 socket AMD system with 4x4 cores no HT (16 logical cores), 
8GiB ram

numa_8 : 8 socket Intel system with 8x10 cores and HT eanabled (160 
logical cores), 1 TiB ram

- All systems had additional storage attached so that spin drives were 
not shared with the system (with rootfs, swap, whatever)

- CPU throttling was disabled: especially all sleep states (except 
c-state 0) and turbo modes (if available)

- read/write caching disabled on spin drives

- test OS was RHEL7 with upstream kernel and custom dm-crypt patches 
(more on that in section [4])

[3] Detailed tests description
------------------------------

tested cipher passed to dm-crypt target: aes-xts-plain64

Tests were performing async sequental writes using fio and libaio 
library. Each test scenario ran repeatedly (5 to 10 iterations per each 
scenario) to rule out measurements error as much as possible or to 
detect some results for particular job were highly volatile (there were 
some)

Tests were based on two backends for dm-crypt mapping: spin drive or 
dm-zero target for measuring pure dm-crypt performance.

I used three basic scenarios:
"disk" single fio process writing sequentially dm-crypt mapped over 
spind drive (starting with device's origin)

"zero": single fio process writing sequentially dm-crypt mapped over dm-zero

"disk_heavy_load": sequential writes issued from multiple fio processes 
each process set bound to different CPU sockets writing to spin drive 
(under dm-crypt mapping). The device is divided uniformly between all 
sockets (and thus also all fio processes).

example of disk_heavy_load test with 3 fio processes per socket:
CPU0 (meant whole socket, not single core)
f0 f1 f2 (set of three individual fio processes bound to CPU0)
r0 (device region (linear segment) written by f0)

     CPU0--------CPU1-------CPU2
            |          |          |
  f0 f1 f2  | f3 f4 f5 | f6 f7 f8 |
   |  |  |  |  |  |  | |  |  |  | |
  r0 r1 r2  | r3 r4 r5 | r6 r7 r9 |

Result tables are composed from multiple lines that looks like following:

D iodepth=256, 32k, mode: write: 698461.10 14795.64 2.12 %
-    -----     ---                -----      -----   ----
|      |        |                   |          |      |
|      |        |                   |          |      v
|      |        |                   |          |  standard deviation
|      |        |                   |          v
|      |        |                   |     average deviation (KiB/s)
|      |        |                   v
|      |        |       sum of bandwidth all fio's (KiB/s)
|      |        v
|      v     block size
| max I/O queue depth
|
v
dm-crypt module name (see following section)

[4] Description of dm-crypt modules involved in testing
-------------------------------------------------------

Each line in results tables is prefixed with single letter meaning 
different dm-crypt module was involved in testing.

'_' stands for raw block device (used only within one "disk" test)

'A' stands for upstream kernel

'D' stands for following patches:
- dm crypt: remove unused io_pool and _crypt_io_pool
- dm crypt: avoid deadlock in mempools
- dm crypt: don't allocate pages for a partial request

'E' stands for following patch:
    dm crypt: use unbound workqueue for request processing (the option 
'same_cpu_crypt' turned off)

'F' stands for following patches:
- dm crypt: offload writes to thread
- dm crypt: add 'submit_from_crypt_cpus' option (but turned off)

'G' stands for following patch:
- dm crypt: sort writes ('submit_from_crypt_cpus' turned off)

[5] dm-zero based test results
------------------------------

"zero" test on single socket system: 
http://okozina.fedorapeople.org/dm-crypt-for-3.20/zero/numa_1/stats

"zero" test on 8 socket system: 
http://okozina.fedorapeople.org/dm-crypt-for-3.20/zero/numa_8/stats

full test results including fio job files and logs:
http://okozina.fedorapeople.org/dm-crypt-for-3.20/zero/numa_1/test_zero_aio.tar.xz
http://okozina.fedorapeople.org/dm-crypt-for-3.20/zero/numa_8/test_zero_aio.tar.xz

[6] spin drive based results
----------------------------

"disk" test single socket system with cfq scheduler: 
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk/numa_1/stats
full test results including fio job files and logs:
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk/numa_1/test_disk_aio.tar.xz

Usually, there's noticeable performance improvement starting with patch 
E in iodepth=8 and reasonably set bsize (4KiB and larger), but as you 
can seen there're few examples where offloading (and sorting) hurts the 
performance (iodepth=32, various block sizes).

With iodepth=256 there're some examples where unbounding the workqueue 
without offloading to single thread can hurt the performance 
(bsize=16KiB and 32KiB)

But in most cases we can say dm-crypt performance is pretty close to raw 
block device now.

[7] spin drive based results (heavy load)
-----------------------------------------

These tests were most complex. Tested both cfq and deadline schedulers, 
setting different nr_request parameter for device's scheduler queue.

Tests were spawning 1, 5 or 8 fio processes per CPU socket (8, 40 or 64 
processes in case of numa_8) in a system and performed i/o on same count 
of non-overlapping disk regions.

subdir /numj_1/ means: single process per cpu socket, /numj_5/: 5 
processes...

Unfortunately, there're workloads where unbounding the workqueue shows 
performance drop and subsequent offloading to single thread makes it 
even worse. (see 8 socket system, cfq, numj_1: 
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_8/cfq/nr_req_128/numj_1/stats).

Similar observations in 2 socket system, cfq, numj_1 
:http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_2/cfq/nr_req_128/numj_1/stats.

On both 2 socket and 8 socket system this observation fades away with 
adding more fio processes per socket.

Only 4 socket system (not so up to date AMD CPUs w/o HT) didn't show 
such pattern.

Generally with higher load, deeper ioqueues and larger block sizes, the 
sorting which takes place in offload thread proves to do it's job good.

*cfq* scheduler, nr_request=128:

2 sockets system:
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_2/cfq/nr_req_128/numj_1/stats
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_2/cfq/nr_req_128/numj_5/stats
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_2/cfq/nr_req_128/numj_8/stats

4 sockets system:
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_4/cfq/nr_req_128/numj_1/stats
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_4/cfq/nr_req_128/numj_5/stats
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_4/cfq/nr_req_128/numj_8/stats

8 sockets system:
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_8/cfq/nr_req_128/numj_1/stats
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_8/cfq/nr_req_128/numj_5/stats
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_8/cfq/nr_req_128/numj_8/stats

*deadline* scheduler, nr_request=128:

2 sockets system:
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_2/deadline/nr_req_128/numj_1/stats
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_2/deadline/nr_req_128/numj_5/stats
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_2/deadline/nr_req_128/numj_8/stats

4 sockets system:
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_4/deadline/nr_req_128/numj_1/stats
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_4/deadline/nr_req_128/numj_5/stats
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_4/deadline/nr_req_128/numj_8/stats

8 sockets system:
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_8/deadline/nr_req_128/numj_1/stats
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_8/deadline/nr_req_128/numj_5/stats
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_8/deadline/nr_req_128/numj_8/stats

full test results including fio job files and logs (beware of archive 
unpacked has about 500MiBs):
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_2/test_disk_heavy_load.tar.xz
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_4/test_disk_heavy_load.tar.xz
http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_8/test_disk_heavy_load.tar.xz

Ondrej
