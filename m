From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [RFC PATCH] dm: fix excessive dm-mq context switching
Date: Sun, 7 Feb 2016 17:41:16 +0200
Message-ID: <56B7659C.8040601@dev.mellanox.co.il>
References: <20160129233504.GA13661@redhat.com> <56AC79D0.5060104@suse.de>
	<20160130191238.GA18686@redhat.com> <56AEFF63.7050606@suse.de>
	<20160203180406.GA11591@redhat.com> <20160203182423.GA12913@redhat.com>
	<56B2F5BC.1010700@suse.de> <20160204135420.GA18227@redhat.com>
	<20160205151334.GA82754@redhat.com> <20160205180515.GA25808@redhat.com>
	<20160205191909.GA25982@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160205191909.GA25982@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: "keith.busch@intel.com" <keith.busch@intel.com>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids


> FYI, here is the latest revised patch:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.6&id=a5b835282422ec41991c1dbdb88daa4af7d166d2
>
> (revised patch header and fixed a thinko in the dm.c:rq_completed()
> change from the RFC patch I posted earlier)

Hi Mike,

So I gave your patches a go (dm-4.6) but I still don't see the
improvement you reported (while I do see a minor improvement).

null_blk queue_mode=2 submit_queues=24
dm_mod blk_mq_nr_hw_queues=24 blk_mq_queue_depth=4096 use_blk_mq=Y

I see 620K IOPs on dm_mq vs. 1750K IOPs on raw nullb0.

Is there something I'm missing?
