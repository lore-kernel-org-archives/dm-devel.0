From: OS Engineering <osengineering-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Subject: Performance Comparison among EnhanceIO, bcache and dm-cache.
Date: Tue, 11 Jun 2013 15:05:07 +0000
Message-ID: <D399C715A2AD7F4F891A75871FC3117507866B@MYMBX3.stec-inc.ad>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Padmini Balasubramaniyan <padminib-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>, Amit Phansalkar <aphansalkar-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
List-Id: dm-devel.ids

Hi Jens,

In continuation with our previous communication, we have carried out performance comparison among EnhanceIO, bcache and dm-cache.

We found that EnhanceIO provides better throughput on zipf workload (with theta=1.2) in comparison to bcache and dm-cache for write through caches.
However, for write back caches, we found that dm-cache had best throughput followed by EnhanceIO and then bcache. Dm-cache commits on-disk metadata every time a REQ_SYNC or REQ_FUA bio is written. If no such requests are made then it commits metadata once every second. If power is lost, it may lose some recent writes. However, EnhanceIO and bcache do not acknowledge IO completion until both IO and metadata hits the SSD. Hence, EnhanceIO and bcache provide higher data integrity at a cost of performance.

The fio config and setup information follows:
HDD              : 100GB
SSD              :  20GB
Mode             : write through / write back
Cache block_size : 4KB for bcache, EnhanceIO and 256KB for dm-cache

The other options have been left to their default values.

Note:
1) In case of dm-cache, we used 2 partitions of same SSD with 1GB partition as metadata and 20GB partition as caching device. This has been done so as to ensure a fair comparison as EnhanceIO and bcache do not have a separate metadata device.

2) In order to ensure proper cache warm up, We have turned off sequential bypass in bcache. This does not impact our performance results as they are taken for random workload.

For each test, we first performed a warm up run using the following fio options:
fio --direct=1 --size=90% --filesize=20G --blocksize=4k --ioengine=libaio --rw=rw --rwmixread=100 --rwmixwrite=0 --iodepth=8 ...

Then, we performed our actual run with the following fio options:
fio --direct=1 --size=100% --filesize=20G --blocksize=4k --ioengine=libaio --rw=randrw --rwmixread=90 --rwmixwrite=10 --iodepth=8 --numjobs=4 --random_distribution=zipf:1.2 ...

============================= Write Through ===============================
Type      Read Latency(ms)   Write Latency(ms)    Read(MB/s)    Write(MB/s)
===========================================================================
EnhanceIO      1.58              16.53               32.91       3.65
bcache         0.58              31.05               27.17       3.02
dm-cache       0.24              27.45               31.05       3.44

============================= Write Back ==================================
Type      Read Latency(ms)    Write Latency(ms)    Read(MB/s)   Write(MB/s)
===========================================================================
EnhanceIO      0.34               4.98               138.72      15.40
bcache         0.95               1.76               106.82      11.85
dm-cache       0.58               0.55               193.76      21.52

============================ Base Line ====================================
Type      Read Latency(ms)    Write Latency(ms)    Read(MB/s)   Write(MB/s)
===========================================================================
HDD            6.22              27.23                13.51       1.49
SSD            0.47               0.42               235.87      26.21

We have written scripts that aid in cache creation, deletion and performance run for all these caching solutions. These scripts can be found at:
https://github.com/stec-inc/EnhanceIO/tree/master/performance_test

Thanks and Regards,
sTec Team

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
