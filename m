From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: dm-writeboost: benchmark (comparing with bcache)
Date: Sat, 01 Feb 2014 17:23:54 +0900
Message-ID: <52ECAF1A.7030303@gmail.com>
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
To: dm-devel@redhat.com
Cc: kmo@daterainc.com, ruby.wktk@gmail.com
List-Id: dm-devel.ids

Hi, DM Guys

My experiments and results.


Purpose
-------
The purpose of these experiments is to
- compare dm-writeboost and bcache in terms of random write throughput.
- see the potential maximum throughput of dm-writeboost.


Summary
-------
- dm-writeboost outperforms bcache (3 times in performance, 5 times more efficient in CPU comsumption per iops).
- dm-writeboost's maximum throughput is 1.5GB/sec (4KB randwrite) experimented with
  a RAM-backed block device (4GB/sec 512KB randwrite potential).
  To achieve higher, locking should be improved and execution path should be shortened.
- We see no explicit improvement by parallel flush I recently implemented.


Hardwares
---------
- CPU: Intel core i7-3770 (4cores/8threads)
- HDD (backing store): Seagate HDD
- SSD (cache device): Samsung 840 Pro 256GB
- RAM disk (cache device): A loopback device backed by a file on tmpfs (16GB size)


Script
------
Experiments are all conducted using FIO (v2.0.8).
The script is shown below. numjobs, iodepth, bs and ba (aligned address)
are typically tuned for each experiment.

------------------- FROM -------------------------
[global]
filename=/dev/mapper/writeboost-vol
# filename=/dev/bcache0
# filename=/dev/sdd2
# filename=/dev/loop0
numjobs=1 # a (see below)
iodepth=32 # b
bs=4k # c
ba=4k # always equals to bs
randrepeat=1
ioengine=libaio
runtime=15
direct=1
gtod_reduce=1
norandommap
stonewall

[perf]
rw=randwrite
-------------------- TO --------------------------


Notations
---------
- A triple (a, b, c) means
  the number of jobs (indicated by numjobs) is a, the iodepth is b and the iosize is c.
  This triple shows the characteristics of the benchmark.
- x(y) means
  the throughput is x MB/sec and the CPU usage (seen in sysstat) is y %


Baseline
--------
To measure the maximum throughput, more threads and higher iodepth is thought to be better.
I set 4 and 32 respectively through baseline benchmark.

1. SSD
(4, 32, 4): 201.1(4.45)
(4, 32, 512): 268.3(0.35)

- The maximum write throughput of this SSD is considered to be around 268MB/sec.

2. RAM-backed device
(1, 1, 4): 413.8(9.7)
(1, 1, 512): 4709.5(8.7)
(4, 32, 4): 3187.7(24.5) 
(4, 32, 512): 4827.5(12.6)

- the segment size now is 512KB and the RAM-backed cache device can yield
  more than 4.5GB/sec.


Setting
-------
- For dm-writeboost, segment size is 512KB. That means write to the cache device is
  always 512KB in size.
- For bcache, cache_mode is set to writeback.


Experiments
-----------
In the benchmark, sysstat is also recorded.

(i) Comparing dm-writeboost / bcache (cache: SSD) with 4KB randwrite
(1, 4, 4): 253.4(3.9) / 71.8(4.6)
(1, 32, 4): 253.1(3.6) / 77.9(4.9)
(4, 4, 4): 260.1(1.6) / 76.8(7.6)
(4. 32, 4): 260.2(1.5) / 101.7(5.3)

- In ALL cases, dm-writeboost outperforms bcache.
- (1, 32, 4) case shows 3.24 times throughput boost and 1.7 times efficient CPU consumption
-- it means about 5 times efficient in CPU consumption per iops
-- CPU consumption is better because dm-writeboost focuses on random write.
- dm-writeboost's 4KB randwrite (260MB/sec) is close to the maximum throughput of the SSD device (268)
  and its better than the 4KB randwrite of the SSD device (201).

In storage system, not only our cache modules are running but other processes (nfsd, xfs, ...)
are running too. Thus, a new feature to introduce newly should be lighter in CPU consumption
otherwise the users don't like to introduce it into the system. dm-writeboost is quite lightweight.

Furthermore, I saw the blktrace of the bcache and it doesn't submit big write to the
cache device but submits 4KB writes in sequential manner in address and its metadata afterward.
dm-writeboost on the other hand first writes to the RAM buffer and submits one big write to the
cache device afterward.
How they handle I/O is completely different.

(ii) What if we add more flushers in dm-writeboost (cache: SSD)
wbflusher in dm-writeboost is a worker thread that submit the filled RAM buffer.
Thus, The more the wbflushers are the higher the throughtput is.
I set the maximum number of wbflushers to 4 by
echo 4 > /sys/bus/workqueue/devices/wbflusher/max_active

(4, 32, 4): 263.4(1.0) 

- Doesn't change so far (only 3MB/sec gain. seems to be a measurement error).

(iii) What if we use RAM-backed block device as the cache device? (cache: RAM)
I used commodity SSD in above experiments but knowing how dm-writeboost scale
with better SSD is important, too. 

(1, 32, 4): 1458.7(12.5)
(4, 32, 4): 370.7(0.74)
(4, 32, 4): 434.2(1.85) (4 wbflushers)

- If the SSD is super fast dm-writeboost can yield 1.5GB/sec randwrite.
-- Unfortunately, far less than 4.7GB/sec. Running through the path of cache lookup and so on are
   now dominant with fast SSD to this degree.
- It somehow performs badly if the # threads is 4.
-- it seems to be collision occurs too frequently and rescheculing overhead drops the throughput.
-- I don't understand why adding more wbflushers increases the throughtput.
   It seems to be just a measurement error. Adding workers changes the timing.
- For bcache, I couldn't initialize with RAM-backed block device. I don't know why.



Thanks for reading,
Akira
