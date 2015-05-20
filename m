From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v3 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Wed, 20 May 2015 11:30:10 -0700
Message-ID: <CAF1ivSbdbvnCi04oR9h4sqnMcLFNXfOo-8=_2qFVkzNYmnmELQ@mail.gmail.com>
References: <1430980461-5235-1-git-send-email-mlin@kernel.org>
	<1430980461-5235-2-git-send-email-mlin@kernel.org>
	<x49twv9kevg.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x49twv9kevg.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Ming Lin <mlin@kernel.org>, lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: dm-devel.ids

On Mon, May 18, 2015 at 9:52 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Ming Lin <mlin@kernel.org> writes:
>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index fd154b9..909f317 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -617,6 +617,10 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
>>       if (q->id < 0)
>>               goto fail_q;
>>
>> +     q->bio_split = bioset_create(4, 0);
>> +     if (!q->bio_split)
>> +             goto fail_id;
>> +
>
> Arbitrary numbers should be documented.

Kent,

Is there specific reason to choose number 4?
If no, I may change it to BIO_POOL_SIZE which is 2.

Thanks.
