From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH v4 08/11] block: kill merge_bvec_fn() completely
Date: Mon, 25 May 2015 18:02:30 +0300
Message-ID: <CAOi1vP8vNEXw2e1eWa4LqKD14SA7XtSQ_C8+4d_sz20t4nfEng@mail.gmail.com>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-9-git-send-email-mlin@kernel.org>
	<20150525140413.GA26065@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150525140413.GA26065@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ming Lin <mlin@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>, Alex Elder <elder@kernel.org>, Ceph Development <ceph-devel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Alex Elder <elder@linaro.org>
List-Id: dm-devel.ids

On Mon, May 25, 2015 at 5:04 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, May 22, 2015 at 11:18:40AM -0700, Ming Lin wrote:
>> From: Kent Overstreet <kent.overstreet@gmail.com>
>>
>> As generic_make_request() is now able to handle arbitrarily sized bios,
>> it's no longer necessary for each individual block driver to define its
>> own ->merge_bvec_fn() callback. Remove every invocation completely.
>
> It might be good to replace patch 1 and this one by a patch per driver
> to remove the merge_bvec_fn instance and add the blk_queue_split call
> for all those drivers that actually had a ->merge_bvec_fn.  As some
> of them were non-trivial attention from the maintainers would be helpful,
> and a patch per driver might help with that.
>
>> -/* This is called by bio_add_page().
>> - *
>> - * q->max_hw_sectors and other global limits are already enforced there.
>> - *
>> - * We need to call down to our lower level device,
>> - * in case it has special restrictions.
>> - *
>> - * We also may need to enforce configured max-bio-bvecs limits.
>> - *
>> - * As long as the BIO is empty we have to allow at least one bvec,
>> - * regardless of size and offset, so no need to ask lower levels.
>> - */
>> -int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct bio_vec *bvec)
>
>
> This just checks the lower device, so it looks obviously fine.
>
>> -static int pkt_merge_bvec(struct request_queue *q, struct bvec_merge_data *bmd,
>> -                       struct bio_vec *bvec)
>> -{
>> -     struct pktcdvd_device *pd = q->queuedata;
>> -     sector_t zone = get_zone(bmd->bi_sector, pd);
>> -     int used = ((bmd->bi_sector - zone) << 9) + bmd->bi_size;
>> -     int remaining = (pd->settings.size << 9) - used;
>> -     int remaining2;
>> -
>> -     /*
>> -      * A bio <= PAGE_SIZE must be allowed. If it crosses a packet
>> -      * boundary, pkt_make_request() will split the bio.
>> -      */
>> -     remaining2 = PAGE_SIZE - bmd->bi_size;
>> -     remaining = max(remaining, remaining2);
>> -
>> -     BUG_ON(remaining < 0);
>> -     return remaining;
>> -}
>
> As mentioned in the comment pkt_make_request will split the bio so pkt
> looks fine.
>
>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>> index ec6c5c6..f50edb3 100644
>> --- a/drivers/block/rbd.c
>> +++ b/drivers/block/rbd.c
>> @@ -3440,52 +3440,6 @@ static int rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
>>       return BLK_MQ_RQ_QUEUE_OK;
>>  }
>>
>> -/*
>> - * a queue callback. Makes sure that we don't create a bio that spans across
>> - * multiple osd objects. One exception would be with a single page bios,
>> - * which we handle later at bio_chain_clone_range()
>> - */
>> -static int rbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bmd,
>> -                       struct bio_vec *bvec)
>
> It seems rbd handles requests spanning objects just fine, so I don't
> really understand why rbd_merge_bvec even exists.  Getting some form
> of ACK from the ceph folks would be useful.

I'm not Alex, but yeah, we have all the clone/split machinery and so we
can handle a spanning case just fine.  I think rbd_merge_bvec() exists
to make sure we don't have to do that unless it's really necessary -
like when a single page gets submitted at an inconvenient offset.

I have a patch that adds a blk_queue_chunk_sectors(object_size) call to
rbd_init_disk() but I haven't had a chance to play with it yet.  In any
case, we should be fine with getting rid of rbd_merge_bvec().  If this
ends up a per-driver patchset, I can make rbd_merge_bvec() ->
blk_queue_chunk_sectors() a single patch and push it through
ceph-client.git.

Thanks,

                Ilya
