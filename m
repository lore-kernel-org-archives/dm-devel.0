From: Teng-Feng Yang <shinrairis@gmail.com>
Subject: Unable to receive overwrite BIO in dm-thin
Date: Mon, 23 Sep 2013 19:06:04 +0800
Message-ID: <CAKTMprP29Xjho0xir2xpWS3=izMTqbHLYL12FHza_9J=96mNQA@mail.gmail.com>
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
List-Id: dm-devel.ids

Hi folks,

I have recently performed some experiments to get the IO performance
of thin devices created by dm-thin under different circumstances.
Therefore, I create a 100GB thin device from a thin pool (block size =
1MB) created by a 3TB HD as the data device and a 128GB SSD as the
metadata device.

First, I want to know the IO performance of the raw HD

> dd if=/dev/zero of=/dev/sdg bs=1M count=10K
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 79.3541 s, 135 MB/s

Then, I create a thin device and do the same IO.

> dd if=/dev/zero of=/dev/mapper/thin bs=1M count=10K
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 22.4915 s, 47.7 MB/s

The write throughput is much more lower than the raw device, so I dig
a little deeper into the source code and turn the block_dump flag to
true.
It turns out that the "max_sectors_kb" of the thin device has been set
to 1024 sectors ( 512KB ). so the thin device can never receive 1MB
block size IO and try to zero block before every write.
So, I remove the whole pool and recreate the whole testing environment
and then set the max_sectors_kb to 2048.

> echo 2048 > /sys/block/dm-1/queue/max_sectors_kb
> dd if=/dev/zero of=/dev/mapper/thin bs=1M count=10K
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 223.517 s, 48.0 MB/s

The performance is nearly the same, and the block_dump message shows
that the IO block_size is still 8 sectors per bio.
To test if the direct IO does the trick, I try:

> dd if=/dev/zero of=/dev/mapper/thin oflag=direct bs=1M count=10K
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 192.099 s, 55.9 MB/s

However, the block_dump message shows the following line repeatedly:
[614644.643377] dd(20404): WRITE block 942080 on dm-1 (1344 sectors)
[614644.643398] dd(20404): WRITE block 943424 on dm-1 (704 sectors)

It looks like each IO request of dd has been split into 2 bios with
1344 and 704 sectors.
In this circumstances, we can never follow the shorter path in dm-thin
since a single BIO seldom overwrites the whole 1MB block.
I also perform the same experiment with pool size equals to 512KB, and
everything works as expected.

So here are my questions:
1. Is there anything else I can do to force or hint the kernel to
submit 1MB size bio when it is possible? Or the only thing I can do is
to stick with the block size lower or equal to 512KB instead?
2. Should the max_sectors_kb's attribute of the thin device be
automatically set to block size?

Any help would be greatly appreciated.
Thanks for your patience

Best Regards,
Dennis
