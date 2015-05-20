From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v3 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Wed, 20 May 2015 11:16:20 -0700
Message-ID: <CAF1ivSbu4e2MzUB2CPJi92PpkOvLrLA=TO55-=7m07GpYz98Xw@mail.gmail.com>
References: <1430980461-5235-1-git-send-email-mlin@kernel.org>
	<1430980461-5235-2-git-send-email-mlin@kernel.org>
	<20150520124418.GA15594@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150520124418.GA15594@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ming Lin <mlin@kernel.org>, lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: dm-devel.ids

On Wed, May 20, 2015 at 5:44 AM, Christoph Hellwig <hch@lst.de> wrote:
> This needs the patch below for the blk-mq case with multiple queues.

Will add it.

>
> Also I wonder why we really want to push this below ->make_request.
> Moving it just outside ->make_request would make the callchain more
> obvious and avoid the recursion into the driver.

Are you saying move the split to generic_make_request()?
Below is an off-list discussion.

Ming Lei asked:
> > I am wondering why the bio isn't splitted just before q->make_request_fn
> > is called in generic_make_request()?  By this way, drivers won't need
> > to call blk_queue_split() at all.  Is it because performance reason? or
> > others?

Kent replied:
> > The reasoning was because blk_queue_split() was only an interim solution -
> > there's actually no inherent need to split the bios at all, but not splitting
> > them takes (a small amount of) driver modification. You just have the driver
> > consume the bios incrementally, advancing the iterator and using bi_remaining
> > when they have multiple tags pointing to the same bio.

>
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index e9bbc04..e7fae76 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1256,6 +1256,8 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
>                 return;
>         }
>
> +       blk_queue_split(q, &bio, q->bio_split);
> +
>         rq = blk_mq_map_request(q, bio, &data);
>         if (unlikely(!rq))
>                 return;
