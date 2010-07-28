From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: BIO_RW_SYNCIO
Date: Wed, 28 Jul 2010 08:42:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007271935180.4811@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904161948420.312@hs20-bc2-1.build.redhat.com>
	<20090417063615.GE4593@kernel.dk>
	<Pine.LNX.4.64.0904200220290.22707@hs20-bc2-1.build.redhat.com>
	<20090421072903.GY4593@kernel.dk>
	<Pine.LNX.4.64.1007261747560.12939@hs20-bc2-1.build.redhat.com>
	<20100727020919.GC18940@redhat.com>
	<Pine.LNX.4.64.1007271452180.1954@hs20-bc2-1.build.redhat.com>
	<20100727230950.GI7347@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100727230950.GI7347@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> > I took the traces and placed them at 
> > http://people.redhat.com/mpatocka/data/blktrace/
> > 
> > It shows that WRITE requests are merged without SYNCIO flags and are not 
> > merged if SYNCIO is used.
> 
> Yes you are right. So I think following is happening.
> 
> Key is that requests don't get merged once they are on dispatch list. They
> get merged only when they are still sitting in some cfq queue and are with
> elevator.
>
> In case of sync IO, both reads and writes are on single cfq queue. We are
> driving good dispatch list depth (drv=65). That means there are 65 reads
> and writes on dispatch list and none of the new requests can be merged with
> those.
> 
> In case of async IO, reads and writes are going on different cfq queues.
> While reads are being dispatched from one queue, writes are sitting in 
> CFQ and are open to merge. That's the reason we are seeing lot more WRITE
> merging with async case.
> 
> Not sure what we can do about it though. But had a couple of questions.
> 
> - You seem to be issuing lots of 4K size adjacent READS and WRITES. Is
>   there a way that you can club these together and issue a bigger request.

It is possible, but it would mean major code size increase (replicate the 
merge functionality in dm-kcopyd). We don't have problems with CPU time 
consumption, so we are not planning it now.

It just simpler to turn off BIO_RW_SYNCIO. I also turned off BIO_RW_UNPLUG 
and unplug the queue after more requests. It improves performance to 
22MB/s.

> - What kind of device this is where request queue depth is 65. Can you
>   try reducing request queue depth to say 16 and see if things improve
>   a bit. (/sys/block/<dev>/device/queue_depth).

Seagate U320 SCSI disk on MPT controller. It has 64 tags.

When I reduced the number of tags, it improved performance, 16 was good 
(19MB/s), reducing it to 4 or 1 improved it even more (22MB/s).

Mikulas
