From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch] block: fix flush machinery for stacking drivers with differring flush flags
Date: Fri, 12 Aug 2011 13:01:18 -0400
Message-ID: <x49bovupns1.fsf@segfault.boston.devel.redhat.com>
References: <x49ty9pqood.fsf@segfault.boston.devel.redhat.com>
	<CANejiEVwvO5csrNCHEjcTzUj6ZeuVjHB6Bdavhn-axAyTj144Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANejiEVwvO5csrNCHEjcTzUj6ZeuVjHB6Bdavhn-axAyTj144Q@mail.gmail.com>
	(Shaohua Li's message of "Thu, 11 Aug 2011 08:56:37 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, msnitzer@redhat.com, vgoyal@redhat.com
List-Id: dm-devel.ids

Shaohua Li <shli@kernel.org> writes:

> 2011/8/10 Jeff Moyer <jmoyer@redhat.com>:
>> @@ -320,6 +319,7 @@ void blk_insert_flush(struct request *rq)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((policy & REQ_FSEQ_DATA) &&
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!(policy & (REQ_FSEQ_PREFLU=
SH | REQ_FSEQ_POSTFLUSH))) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_add_tail=
(&rq->queuelist, &q->queue_head);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 blk_run_queue_asy=
nc(q);
> A minor issue. I can understand this is required for
> blk_insert_cloned_request() because INSERT_BACK will run
> queue but INSERT_FLUSH doesn't. But sounds we don't need
> run queue for normal requests. Either __make_request will run
> queue (task has plug list) or flush_plug will run queue. delaying
> run queue has its benefit. can we do the runqueue in
> blk_insert_cloned_request() if this is a INSERT_FLUSH.

Well, the only time we need to run the queue is when the request has
data, has REQ_FUA set, and the underlying queue's flush flags contain
only REQ_FUA.  In code:

if (rq->cmd_flags & REQ_FUA && q->flush_flags =3D=3D REQ_FUA)
	blk_run_queue_async(q);

If that was added to blk_insert_cloned_request, we could get rid of the
blk_run_queue_async in blk_insert_flush.  However, I think Tejun will
object due to the layering violation for the same reason he doesn't lik=
e
my handling of empty flushes in blk_insert_cloned_request.

Tejun?

Cheers,
Jeff
