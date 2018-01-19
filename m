From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Fri, 19 Jan 2018 13:33:33 -0500
Message-ID: <20180119183333.GA29937@redhat.com>
References: <20180119072623.GB25369@ming.t460p>
 <047f68ec-f51b-190f-2f89-f413325c2540@kernel.dk>
 <20180119154047.GB14827@ming.t460p>
 <540e1239-c415-766b-d4ff-bb0b7f3517a7@kernel.dk>
 <20180119160518.GC14827@ming.t460p>
 <4a5c049f-0fab-bbaf-bfe2-eb5bca73f2c8@kernel.dk>
 <20180119162618.GD14827@ming.t460p>
 <1f072086-533e-4b75-d0e3-9e621b2120d8@kernel.dk>
 <20180119163736.GE14827@ming.t460p>
 <e17362b4-dfee-be8d-ea8d-b07f6d9768e8@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e17362b4-dfee-be8d-ea8d-b07f6d9768e8@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>
List-Id: dm-devel.ids

On Fri, Jan 19 2018 at 12:38pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 1/19/18 9:37 AM, Ming Lei wrote:
> > On Fri, Jan 19, 2018 at 09:27:46AM -0700, Jens Axboe wrote:
> >>
> >> There are no pending requests for this case, nothing to restart the
> >> queue. When you fail that blk_get_request(), you are idle, nothing
> >> is pending.
> > 
> > I think we needn't worry about that, once a device is attached to
> > dm-rq, it can't be mounted any more, and usually user don't use the device
> > directly and by dm-mpath at the same time.
> 
> Here's an example of that, using my current block tree (merged into
> master).  The setup is dm-mpath on top of null_blk, the latter having
> just a single request. Both are mq devices.
> 
> Fio direct 4k random reads on dm_mq: ~250K iops
> 
> Start dd on underlying device (or partition on same device), just doing
> sequential reads.
> 
> Fio direct 4k random reads on dm_mq with dd running: 9 iops
> 
> No schedulers involved.
> 
> https://i.imgur.com/WTDnnwE.gif

FYI, your tree doesn't have these dm-4.16 changes (which are needed to
make Ming's blk-mq chnages that are in your tree, commit 396eaf21e et
al, have Ming's desired effect on DM):

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=050af08ffb1b62af69196d61c22a0755f9a3cdbd
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=459b54019cfeb7330ed4863ad40f78489e0ff23d
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=ec3eaf9a673106f66606896aed6ddd20180b02ec

Fact that you're seeing such shit results without dm-4.16 commit
ec3eaf9a67 (that reverts older commit 6077c2d706) means: yeap, this
is really awful, let's fix it!  But it is a different flavor of awful
because the dm-rq.c:map_request() will handle the DM_MAPIO_DELAY_REQUEUE
result from the null_blk's blk_get_request() failure using
dm_mq_delay_requeue_request() against the dm-mq mpath device:

        blk_mq_requeue_request(rq, false);
        __dm_mq_kick_requeue_list(rq->q, msecs);

So begs the question: why are we stalling _exactly_?  (you may have it
all figured out, as your gif implies.. but I'm not there yet).

Might be interesting to see how your same test behaves without all of
the churn we've staged for 4.16, e.g. against v4.15-rc8

Mike
