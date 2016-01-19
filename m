From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath low performance with blk-mq
Date: Tue, 19 Jan 2016 17:45:12 -0500
Message-ID: <20160119224512.GA10515@redhat.com>
References: <569E11EA.8000305@dev.mellanox.co.il>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <569E11EA.8000305@dev.mellanox.co.il>
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
Cc: Christoph Hellwig <hch@infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, dm-devel@redhat.com, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Mon, Jan 18 2016 at  7:04am -0500,
Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:

> Hi All,
> 
> I've recently tried out dm-multipath over a "super-fast" nvme device
> and noticed a serious lock contention in dm-multipath that requires some
> extra attention. The nvme device is a simple loopback device emulation
> backed by null_blk device.
> 
> With this I've seen dm-multipath pushing around ~470K IOPs while
> the native (loopback) nvme performance can easily push up to 1500K+ IOPs.
> 
> perf output [1] reveals a huge lock contention on the multipath lock
> which is a per-dm_target contention point which seem to defeat the
> purpose of blk-mq i/O path.
> 
> The two current bottlenecks seem to come from multipath_busy and
> __multipath_map. Would it make better sense to move to a percpu_ref
> model with freeze/unfreeze logic for updates similar to what blk-mq
> is doing?
>
> Thoughts?

Your perf output clearly does identify the 'struct multipath' spinlock
as a bottleneck.

Is it fair to assume that implied in your test is that you increased
md->tag_set.nr_hw_queues to > 1 in dm_init_request_based_blk_mq_queue()?

I'd like to start by replicating your testbed.  So I'll see about
setting up the nvme loop driver you referenced in earlier mail.
Can you share your fio job file and fio commandline for your test?

Unrolling the dm-mpath.c implementation of .request_fn vs blk-mq and
identifiying a locking strategy for the 'struct multipath' member
accesses will take time to investigate.  If others can spare their
expertise to help speed up the discovery of the proper way forward I'd
very much appreciate it.

I'll consult with people like Mikulas (who did work to improve DM core's
scalability with changes like commit 83d5e5b0af9 "dm: optimize use SRCU
and RCU").

But I'll need to do further research on what fix is appropriate for
increasing the parallelism of the locking across blk-mq queues.  Part of
the challenge associated with that is that while blk-mq will know there
are multiple queues: the DM multipath target is currently oblivious.
Pushing that understanding down to the multipath target is likely needed
so that resources can be initialized and managed accordingly.  Certainly
made more complex when you consider we do still have support for the old
.request_fn code path (via dm-mpath.c:multipath_map).  But it could
easily be that this new locking strategy will work if number of queues
is 1 or >1.

This discovery will take time but I'll make it a priority and do my
best.

Mike
