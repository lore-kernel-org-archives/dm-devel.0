From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/2] dm: add new loop and ram targets
Date: Wed, 24 Jan 2018 13:48:17 +0100
Message-ID: <bfb667c8-ea26-cd9b-6a18-9c88252f7b1b@redhat.com>
References: <cover.1516124587.git.heinzm@redhat.com>
 <20180122201944.GA7080@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180122201944.GA7080@infradead.org>
Content-Language: de-CH
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@redhat.com, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On 22/01/18 21:19, Christoph Hellwig wrote:

> On Wed, Jan 17, 2018 at 08:33:59PM +0100, Heinz Mauelshagen wrote:
>> Enhancing IO performance compared to the kernels existing
>> loop driver thus better suiting respective requirements in
>> test setups, this patch series adds new "loop" and "ram" targets.
> For a fair comparism vs loop you'll need to compare it to the
> direct I/O mode.

True, the tested use cases were based  on backing filesystems
w/o direct I/O support which is valuable to me.

>    If it is faster than that we have a very serious
> bug somewhere.

As a quick test I opened the backing file O_DIRECT in dm-loop on XFS 
backed by
NVMe and it's 10-20% slower than loop because it's bio based and thus 
lags mq.

So, no worries, loop looks ok in regards to direct I/O mode.
>> For measures see test results below.
>>
>>
>> The "loop" target maps segments to backing files.
>> Mapping table example:
>> 0 4192256 loop /tmp/mapper_loop1
>> 4192256 2097152 loop /dev/nvm/mapper_loop0
>>
>>
>> The "ram" target accesses RAM directly rather than through
>> tmpfs additionally enhancing performance compared to "loop"
>> thus avoding filesystem overhead.
>> Mapping table example:
>> 0 8388608 ram
>>
>> "ram" is a singleton target.
>>
>>
>> Performance test results for 4K and 32K IOPS comparing the loop driver
>> with dm-loop backed by tmpfs and dm-ram (all 2GiB backing size):
>>
>> <TESTSCRIPT>
>> #!/bin/sh
>> for f in /tmp/loop0 /tmp/mapper_loop0
>> do
>> 	dd if=/dev/zero of=$f bs=256M count=8 iflag=fullblock
>> done
>>
>> losetup /dev/loop0 /tmp/loop0
>> sectors=`du -s /tmp/mapper_loop0|cut -f1`
>> dmsetup create loop0 --table "0 $sectors loop /tmp/mapper_loop0"
>> dmsetup create ram --table "0 $sectors ram"
>>
>> for bs in 4K 32K
>> do
>> 	for d in /dev/loop0 /dev/mapper/loop0 /dev/mapper/ram
>> 	do
>> 		echo 3 > /proc/sys/vm/drop_caches
>> 		fio --bs=$bs --rw=randrw --numjobs=99 --group_reporting --iodepth=12 --runtime=3 --ioengine=libaio \
>> 		    --loops=1 --direct=1 --exitall --name dc --filename=$d | egrep "read|write"
>> 	done
>> done
>> </TESTSCRIPT>
>>
>> <4K_RESULTS>
>> loop driver:
>>     read: IOPS=226k, BW=881MiB/s (924MB/s)(2645MiB/3003msec)
>>    write: IOPS=225k, BW=880MiB/s (923MB/s)(2643MiB/3003msec)
>> dm-loop target:
>>     read: IOPS=425k, BW=1661MiB/s (1742MB/s)(4990MiB/3004msec)
>>    write: IOPS=425k, BW=1662MiB/s (1743MB/s)(4992MiB/3004msec)
>> dm-ram target:
>>     read: IOPS=636k, BW=2484MiB/s (2605MB/s)(7464MiB/3005msec)
>>    write: IOPS=636k, BW=2484MiB/s (2605MB/s)(7464MiB/3005msec)
>> </4K_RESULTS>
>>
>> <32K_RESULTS>
>> loop driver:
>>    read: IOPS=55.5k, BW=1733MiB/s (1817MB/s)(5215MiB/3009msec)
>>    write: IOPS=55.2k, BW=1726MiB/s (1810MB/s)(5195MiB/3009msec)
>> dm-loop target:
>>     read: IOPS=110k, BW=3452MiB/s (3620MB/s)(10.1GiB/3006msec)
>>    write: IOPS=110k, BW=3448MiB/s (3615MB/s)(10.1GiB/3006msec)
>> dm-ram target:
>>     read: IOPS=355k, BW=10.8GiB/s (11.6GB/s)(32.6GiB/3008msec)
>>    write: IOPS=355k, BW=10.8GiB/s (11.6GB/s)(32.6GiB/3008msec)
>> </32K_RESULTS>
>>
>>
>> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
>>
>> Heinz Mauelshagen (2):
>>    dm loop: new target redirecting io to backing file(s)
>>    dm ram: new target redirecting io to RAM
>>
>>   Documentation/device-mapper/loop.txt |  20 ++
>>   Documentation/device-mapper/ram.txt  |  15 ++
>>   drivers/md/Kconfig                   |  14 ++
>>   drivers/md/Makefile                  |   2 +
>>   drivers/md/dm-loop.c                 | 352 +++++++++++++++++++++++++++++++++++
>>   drivers/md/dm-ram.c                  | 101 ++++++++++
>>   6 files changed, 504 insertions(+)
>>   create mode 100644 Documentation/device-mapper/loop.txt
>>   create mode 100644 Documentation/device-mapper/ram.txt
>>   create mode 100644 drivers/md/dm-loop.c
>>   create mode 100644 drivers/md/dm-ram.c
>>
>> -- 
>> 2.14.3
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
> ---end quoted text---
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
