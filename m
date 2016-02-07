From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] dm: fix excessive dm-mq context switching
Date: Sun, 7 Feb 2016 11:07:12 -0500
Message-ID: <20160207160712.GA6017@redhat.com>
References: <20160130191238.GA18686@redhat.com> <56AEFF63.7050606@suse.de>
	<20160203180406.GA11591@redhat.com>
	<20160203182423.GA12913@redhat.com> <56B2F5BC.1010700@suse.de>
	<20160204135420.GA18227@redhat.com>
	<20160205151334.GA82754@redhat.com>
	<20160205180515.GA25808@redhat.com>
	<20160205191909.GA25982@redhat.com>
	<56B7659C.8040601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56B7659C.8040601@dev.mellanox.co.il>
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

On Sun, Feb 07 2016 at 10:41am -0500,
Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:

> 
> >FYI, here is the latest revised patch:
> >https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.6&id=a5b835282422ec41991c1dbdb88daa4af7d166d2
> >
> >(revised patch header and fixed a thinko in the dm.c:rq_completed()
> >change from the RFC patch I posted earlier)
> 
> Hi Mike,
> 
> So I gave your patches a go (dm-4.6) but I still don't see the
> improvement you reported (while I do see a minor improvement).
> 
> null_blk queue_mode=2 submit_queues=24
> dm_mod blk_mq_nr_hw_queues=24 blk_mq_queue_depth=4096 use_blk_mq=Y
> 
> I see 620K IOPs on dm_mq vs. 1750K IOPs on raw nullb0.

blk_mq_nr_hw_queues=24 isn't likely to help you (but with these patches,
the first being the most important, it shouldn't hurt either provided
you have 24 cpus).

Could be you have multiple NUMA nodes and are seeing problems from that?

I have 12 cpus (in the same physical cpu) and only a single NUMA node.
I get the same results as blk_mq_nr_hw_queues=12 with
blk_mq_nr_hw_queues=4 (same goes for null_blk submit_queues).
I've seen my IOPs go from ~950K to ~1400K.  The peak null_blk can get on
my setup is ~1950K.  So I'm still seeing a ~25% drop with dm-mq (but
that is much better than the over 50% drop I saw seeing).

> Is there something I'm missing?

Not sure, I just emailed out all my patches (and cc'd you).  Please
verify you're using the latest here (same as 'dm-4.6' branch):
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next

I rebased a couple times... so please diff what you have tested against
this latest 'dm-4.6' branch.
