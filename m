From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3 01/11] block: make generic_make_request handle arbitrarily sized bios
Date: Wed, 20 May 2015 14:58:41 -0400
Message-ID: <x49k2w3oz32.fsf@segfault.boston.devel.redhat.com>
References: <1430980461-5235-1-git-send-email-mlin@kernel.org>
	<1430980461-5235-2-git-send-email-mlin@kernel.org>
	<x49twv9kevg.fsf@segfault.boston.devel.redhat.com>
	<CAF1ivSbdbvnCi04oR9h4sqnMcLFNXfOo-8=_2qFVkzNYmnmELQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSbdbvnCi04oR9h4sqnMcLFNXfOo-8=_2qFVkzNYmnmELQ@mail.gmail.com>
	(Ming Lin's message of "Wed, 20 May 2015 11:30:10 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: dm-devel.ids

Ming Lin <mlin@kernel.org> writes:

> On Mon, May 18, 2015 at 9:52 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Ming Lin <mlin@kernel.org> writes:
>>
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index fd154b9..909f317 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -617,6 +617,10 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
>>>       if (q->id < 0)
>>>               goto fail_q;
>>>
>>> +     q->bio_split = bioset_create(4, 0);
>>> +     if (!q->bio_split)
>>> +             goto fail_id;
>>> +
>>
>> Arbitrary numbers should be documented.
>
> Kent,
>
> Is there specific reason to choose number 4?
> If no, I may change it to BIO_POOL_SIZE which is 2.

Here's what he had to say last time around:

  On Mon, Nov 25, 2013 at 10:09:21PM -0800, Christoph Hellwig wrote:
  > > +   q->bio_split = bioset_create(4, 0);
  > > +   if (!q->bio_split)
  > > +      goto fail_id;
  > 
  > How did we arrive at a mempool size of 4 to make sure we can always make
  > progress with arbitrarily sized bios?  Shouldn't we document the design
  > decision somewhere?

  It just has to be nonzero to guarantee forward progress - the
  bio_alloc_bioset() rescuer thing I did awhile back guarantees that.

link:  https://lkml.org/lkml/2013/11/26/47

Cheers,
Jeff
