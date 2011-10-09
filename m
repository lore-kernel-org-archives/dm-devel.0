From: Shaohua Li <shli@kernel.org>
Subject: Re: [dm-devel] Block regression since 3.1-rc3
Date: Sun, 9 Oct 2011 16:08:13 +0800
Message-ID: <CANejiEVsqtrhA00j3MEOL8yARRq+GtHFOq-8cbncgU1SQkciuw@mail.gmail.com>
References: <1317397918.27140.15.camel@localhost>
	<x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	<1317729761.25998.4.camel@localhost>
	<x49bottoq57.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x49bottoq57.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christophe Saout <christophe@saout.de>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

2011/10/7 Jeff Moyer <jmoyer@redhat.com>:
> Christophe Saout <christophe@saout.de> writes:
>
>> Hi Jeff,
>>
>>> Anyway, it would help a great deal if you could retrigger the failu=
re
>>> and provide the full failure output. =A0You can get that by issuing=
 the
>>> 'dmesg' command and redirecting it to a file.
>>
>> Oh, sorry, yes, there's a line missing.
>>
>> Line 323 is this one: BUG_ON(!rq->bio || rq->bio !=3D rq->biotail);
>
> OK, it turns out my testing was incomplete. =A0I only tested targets =
that
> had a write-through cache, so I didn't hit this problem. =A0It reprod=
uces
> pretty easily with just multipath involved (no linear target on top) =
when
> running against the right storage.
>
> So, here's a patch, but I don't have a full explanation for it just y=
et.
> What I observed was that, on fsync, blkdev_issue_flush was called.
> Eventually, the flush request gets cloned, and blk_insert_cloned_requ=
est
> is called. =A0This cloned request never actually gets issued to the
> q->requst_fn (scsi_request_fn in my case). =A0So, it may be that ther=
e is
> no plug list for this, so the queue isn't goosed? =A0I'll try to come=
 up
> with a better explanation, or Tejun may just know off the top of his
> head what's going on.
blk_insert_flush() just insert request to list and doesn't actually
dispatch request
to drive, because normally there is other way to run queue later. But
blk_insert_cloned_request() actually means dispatch request to drive. I=
f we
don't flush queue, the queue will stall.

> So, the patch works for me, but is very much just an RFC.
>
> Cheers,
> Jeff
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 491eb30..7aa4736 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -320,7 +320,7 @@ void blk_insert_flush(struct request *rq)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 BUG_ON(!rq->bio || rq->bio !=3D rq->biotail);
> + =A0 =A0 =A0 BUG_ON(rq->bio && rq->bio !=3D rq->biotail);
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * If there's data but flush is not necessary, the req=
uest can be
> @@ -345,6 +345,12 @@ void blk_insert_flush(struct request *rq)
> =A0 =A0 =A0 =A0rq->end_io =3D flush_data_end_io;
>
> =A0 =A0 =A0 =A0blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy,=
 0);
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* A cloned empty flush needs a queue kick to make pr=
ogress.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (!rq->bio)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_run_queue_async(q);
> =A0}
the rq could be a cloned FUA request, so rq->bio could not be NULL.
Better move blk_run_queue_async() to blk_insert_cloned_request().
We need run the queue in flush case anyway.
