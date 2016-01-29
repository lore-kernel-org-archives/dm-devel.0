From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath low performance with blk-mq
Date: Fri, 29 Jan 2016 18:35:05 -0500
Message-ID: <20160129233504.GA13661@redhat.com>
References: <569E11EA.8000305@dev.mellanox.co.il>
	<20160119224512.GA10515@redhat.com>
	<20160125214016.GA10060@redhat.com>
	<20160125233717.GQ24960@octiron.msp.redhat.com>
	<20160126132939.GA23967@redhat.com>
	<56A8A6A8.9090003@dev.mellanox.co.il>
	<20160127174828.GA31802@redhat.com>
	<56A904B6.50407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56A904B6.50407@dev.mellanox.co.il>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: axboe@kernel.dk, "keith.busch@intel.com" <keith.busch@intel.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Wed, Jan 27 2016 at 12:56pm -0500,
Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:

> 
> 
> On 27/01/2016 19:48, Mike Snitzer wrote:
> >On Wed, Jan 27 2016 at  6:14am -0500,
> >Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
> >
> >>
> >>>>I don't think this is going to help __multipath_map() without some
> >>>>configuration changes.  Now that we're running on already merged
> >>>>requests instead of bios, the m->repeat_count is almost always set to 1,
> >>>>so we call the path_selector every time, which means that we'll always
> >>>>need the write lock. Bumping up the number of IOs we send before calling
> >>>>the path selector again will give this patch a change to do some good
> >>>>here.
> >>>>
> >>>>To do that you need to set:
> >>>>
> >>>>	rr_min_io_rq <something_bigger_than_one>
> >>>>
> >>>>in the defaults section of /etc/multipath.conf and then reload the
> >>>>multipathd service.
> >>>>
> >>>>The patch should hopefully help in multipath_busy() regardless of the
> >>>>the rr_min_io_rq setting.
> >>>
> >>>This patch, while generic, is meant to help the blk-mq case.  A blk-mq
> >>>request_queue doesn't have an elevator so the requests will not have
> >>>seen merging.
> >>>
> >>>But yes, implied in the patch is the requirement to increase
> >>>m->repeat_count via multipathd's rr_min_io_rq (I'll backfill a proper
> >>>header once it is tested).
> >>
> >>I'll test it once I get some spare time (hopefully soon...)
> >
> >OK thanks.
> >
> >BTW, I _cannot_ get null_blk to come even close to your reported 1500K+
> >IOPs on 2 "fast" systems I have access to.  Which arguments are you
> >loading the null_blk module with?
> >
> >I've been using:
> >modprobe null_blk gb=4 bs=4096 nr_devices=1 queue_mode=2 submit_queues=12
> 
> $ for f in /sys/module/null_blk/parameters/*; do echo $f; cat $f; done
> /sys/module/null_blk/parameters/bs
> 512
> /sys/module/null_blk/parameters/completion_nsec
> 10000
> /sys/module/null_blk/parameters/gb
> 250
> /sys/module/null_blk/parameters/home_node
> -1
> /sys/module/null_blk/parameters/hw_queue_depth
> 64
> /sys/module/null_blk/parameters/irqmode
> 1
> /sys/module/null_blk/parameters/nr_devices
> 2
> /sys/module/null_blk/parameters/queue_mode
> 2
> /sys/module/null_blk/parameters/submit_queues
> 24
> /sys/module/null_blk/parameters/use_lightnvm
> N
> /sys/module/null_blk/parameters/use_per_node_hctx
> N
> 
> $ fio --group_reporting --rw=randread --bs=4k --numjobs=24
> --iodepth=32 --runtime=99999999 --time_based --loops=1
> --ioengine=libaio --direct=1 --invalidate=1 --randrepeat=1
> --norandommap --exitall --name task_nullb0 --filename=/dev/nullb0
> task_nullb0: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K,
> ioengine=libaio, iodepth=32
> ...
> fio-2.1.10
> Starting 24 processes
> Jobs: 24 (f=24): [rrrrrrrrrrrrrrrrrrrrrrrr] [0.0% done]
> [7234MB/0KB/0KB /s] [1852K/0/0 iops] [eta 1157d:09h:46m:22s]

Your test above is prone to exhaust the dm-mpath blk-mq tags (128)
because 24 threads * 32 easily exceeds 128 (by a factor of 6).

I found that we were context switching (via bt_get's io_schedule)
waiting for tags to become available.

This is embarassing but, until Jens told me today, I was oblivious to
the fact that the number of blk-mq's tags per hw_queue was defined by
tag_set.queue_depth.

Previously request-based DM's blk-mq support had:
md->tag_set.queue_depth = BLKDEV_MAX_RQ; (again: 128)

Now I have a patch that allows tuning queue_depth via dm_mod module
parameter.  And I'll likely bump the default to 4096 or something (doing
so eliminated blocking in bt_get).

But eliminating the tags bottleneck only raised my read IOPs from ~600K
to ~800K (using 1 hw_queue for both null_blk and dm-mpath).

When I raise nr_hw_queues to 4 for null_blk (keeping dm-mq at 1) I see a
whole lot more context switching due to request-based DM's use of
ksoftirqd (and kworkers) for request completion.

So I'm moving on to optimizing the completion path.  But at least some
progress was made, more to come...

Mike
