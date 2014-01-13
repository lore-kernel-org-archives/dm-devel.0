From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: dm-writeboost: Progress Report
Date: Mon, 13 Jan 2014 20:46:35 +0900
Message-ID: <52D3D21B.8030408@gmail.com>
References: <52D0F25D.6030904@gmail.com> <20140113100903.GA4984@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140113100903.GA4984@debian>
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
List-Id: dm-devel.ids

Hi, Joe,

> Do you have any benchmarks yet?  Which situations does it out perform
> bcache and dm-cache?
Yes, I do.
Writeboost outperforms other cache softwares in case of bursty random writes.
With the fio script below, dm-writeboost recorded a throughput as high as the
sequential write throughput of the cache device (259MB/266MB. only 3% loss).
This is because Writeboost makes a log on the RAM and writes it out to the
cache device in sequential manner. I don't think other cache softwares can achieve
this high level of throughput.

[global]
filename=/dev/mapper/perflv
randrepeat=1
ioengine=libaio
bs=4k
ba=4k
size=16GB
direct=1
gtod_reduce=1
norandommap
iodepth=64
stonewall

[perf]
rw=randwrite


Unfortunately, I don't have any results with synthetic workload emulates databases
or file servers. But, it is easy to imagine Writeboost can improve them if they are
backed by RAID-ed storage whose writes are really slow compared to read with
typical RAID mode like RAID-5.
Since our softwares are just providing "caching" choosing one as the silver bullet
is just a fantasy. Since Writeboost provides really a peculiar caching there must be
some situations that Writeboost is the best.

To tell the truth, I don't have any more equipments to have benchmark more. Why I
need my software in the tree is not only to have the "many eyes" on my code to improve
the quality but also to have Writeboost participate in public benchmark
(like this http://www.accelcloud.com/2012/04/18/linux-flashcache-and-bcache-performance-testing/).

Beside the performance, please consider the compact codebase of Writeboost. As a writeback
caching it should be as simple as possible to reduce potential bugs.

By the way, Writeboost improves only writes so if you need more improvement on reads
you can stack dm-cache (write-through) under dm-writeboost. They are orthogonal.
dm-cache seems to be good for read caching.

For read caching, I have an another plan to develop separate cache module that, on the other hand,
purely focuses on improving reads. I have a name "dm-readboost" in my mind.
Since write cache and read cache require different data structures and controls they should be separated.
So, if dm-cache can be simpler and optimized by deleting the support for writeback mode I really prefer it.

>> 5. Add regression tests under testing/ of my Github tree
>> --------------------------------------------------------
>> Joe's test-suite is really well-designed but it has too many things before stand-by.
> 
> I'm not sure what you mean here?
device-mapper-test-suite is a flexible framework but it has too many dependencies outside Ruby.

Akira
