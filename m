From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch] block: fix flush machinery for stacking drivers with
 differring flush flags
Date: Thu, 11 Aug 2011 08:56:37 +0800
Message-ID: <CANejiEVwvO5csrNCHEjcTzUj6ZeuVjHB6Bdavhn-axAyTj144Q@mail.gmail.com>
References: <x49ty9pqood.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x49ty9pqood.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, msnitzer@redhat.com, vgoyal@redhat.com
List-Id: dm-devel.ids

2011/8/10 Jeff Moyer <jmoyer@redhat.com>:
> Hi,
>
> Commit ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae, block: reimplement
> FLUSH/FUA to support merge, introduced a performance regression when
> running any sort of fsyncing workload using dm-multipath and certain
> storage (in our case, an HP EVA). =A0The test I ran was fs_mark, and =
it
> dropped from ~800 files/sec on ext4 to ~100 files/sec. =A0It turns ou=
t
> that dm-multipath always advertised flush+fua support, and passed
> commands on down the stack, where those flags used to get stripped of=
f.
> The above commit changed that behavior:
>
> static inline struct request *__elv_next_request(struct request_queue=
 *q)
> {
> =A0 =A0 =A0 =A0struct request *rq;
>
> =A0 =A0 =A0 =A0while (1) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (!list_empty(&q->queue_head)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!list_empty(&q->queue_head)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rq =3D list_entry_rq(q=
->queue_head.next);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(rq->cmd_flags & (=
REQ_FLUSH | REQ_FUA)) ||
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (rq->cmd_flags =
& REQ_FLUSH_SEQ))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
rq;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rq =3D blk_do_flush(q, =
rq);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rq)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
rq;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rq;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> Note that previously, a command would come in here, have
> REQ_FLUSH|REQ_FUA set, and then get handed off to blk_do_flush:
>
> struct request *blk_do_flush(struct request_queue *q, struct request =
*rq)
> {
> =A0 =A0 =A0 =A0unsigned int fflags =3D q->flush_flags; /* may change,=
 cache it */
> =A0 =A0 =A0 =A0bool has_flush =3D fflags & REQ_FLUSH, has_fua =3D ffl=
ags & REQ_FUA;
> =A0 =A0 =A0 =A0bool do_preflush =3D has_flush && (rq->cmd_flags & REQ=
_FLUSH);
> =A0 =A0 =A0 =A0bool do_postflush =3D has_flush && !has_fua && (rq->cm=
d_flags &
> =A0 =A0 =A0 =A0REQ_FUA);
> =A0 =A0 =A0 =A0unsigned skip =3D 0;
> ...
> =A0 =A0 =A0 =A0if (blk_rq_sectors(rq) && !do_preflush && !do_postflus=
h) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rq->cmd_flags &=3D ~REQ_FLUSH;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!has_fua)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rq->cmd_flags &=3D ~RE=
Q_FUA;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rq;
> =A0 =A0 =A0 =A0}
>
> So, the flush machinery was bypassed in such cases (q->flush_flags =3D=
=3D 0
> && rq->cmd_flags & (REQ_FLUSH|REQ_FUA)).
>
> Now, however, we don't get into the flush machinery at all. =A0Instea=
d,
> __elv_next_request just hands a request with flush and fua bits set t=
o
> the scsi_request_fn, even if the underlying request_queue does not
> support flush or fua.
>
> The agreed upon approach is to fix the flush machinery to allow
> stacking. =A0While this isn't used in practice (since there is only o=
ne
> request-based dm target, and that target will now reflect the flush
> flags of the underlying device), it does future-proof the solution, a=
nd
> make it function as designed.
>
> In order to make this work, I had to add a field to the struct reques=
t,
> inside the flush structure (to store the original req->end_io). =A0Sh=
aohua
> had suggested overloading the union with rb_node and completion_data,
> but the completion data is used by device mapper and can also be used=
 by
> other drivers. =A0So, I didn't see a way around the additional field.
>
> I chose to short-circuit empty flush requests (when the flush flags
> don't advertise flush) in blk_insert_cloned_request. =A0I don't see a=
 huge
> advantage to doing this inside blk_insert_flush, though it could be d=
one
> there as well.
>
> I tested this patch on an HP EVA with both ext4 and xfs, and it recov=
ers
> the lost performance. =A0Comments and other testers, as always, are
> appreciated.
>
> Cheers,
> Jeff
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index b850bed..7ee03c6 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -39,6 +39,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
> =A0EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
>
> =A0static int __make_request(struct request_queue *q, struct bio *bio=
);
> +static bool blk_end_bidi_request(struct request *rq, int error,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsi=
gned int nr_bytes, unsigned int bidi_bytes);
>
> =A0/*
> =A0* For the allocated request tables
> @@ -1700,6 +1702,7 @@ EXPORT_SYMBOL_GPL(blk_rq_check_limits);
> =A0int blk_insert_cloned_request(struct request_queue *q, struct requ=
est *rq)
> =A0{
> =A0 =A0 =A0 =A0unsigned long flags;
> + =A0 =A0 =A0 int where =3D ELEVATOR_INSERT_BACK;
>
> =A0 =A0 =A0 =A0if (blk_rq_check_limits(q, rq))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> @@ -1708,6 +1711,20 @@ int blk_insert_cloned_request(struct request_q=
ueue *q, struct request *rq)
> =A0 =A0 =A0 =A0 =A0 =A0should_fail_request(&rq->rq_disk->part0, blk_r=
q_bytes(rq)))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
>
> + =A0 =A0 =A0 if (rq->cmd_flags & (REQ_FLUSH|REQ_FUA)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Filter empty flush requests here. =
=A0REQ_FLUSH_SEQ will
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ensure that no I/O accounting is d=
one for this request.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!q->flush_flags && !blk_rq_sectors(=
rq)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_end_bidi_request(rq=
, 0, 0, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 where =3D ELEVATOR_INSERT_FLUSH;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* REQ_FLUSH_SEQ will be set again by t=
he flush machinery */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rq->cmd_flags &=3D ~REQ_FLUSH_SEQ;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0spin_lock_irqsave(q->queue_lock, flags);
>
> =A0 =A0 =A0 =A0/*
> @@ -1716,7 +1733,7 @@ int blk_insert_cloned_request(struct request_qu=
eue *q, struct request *rq)
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0BUG_ON(blk_queued_rq(rq));
>
> - =A0 =A0 =A0 add_acct_request(q, rq, ELEVATOR_INSERT_BACK);
> + =A0 =A0 =A0 add_acct_request(q, rq, where);
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(q->queue_lock, flags);
>
> =A0 =A0 =A0 =A0return 0;
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 2d162bd..2633a08 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -123,7 +123,7 @@ static void blk_flush_restore_request(struct requ=
est *rq)
>
> =A0 =A0 =A0 =A0/* make @rq a normal request */
> =A0 =A0 =A0 =A0rq->cmd_flags &=3D ~REQ_FLUSH_SEQ;
> - =A0 =A0 =A0 rq->end_io =3D NULL;
> + =A0 =A0 =A0 rq->end_io =3D rq->flush.saved_end_io;
> =A0}
>
> =A0/**
> @@ -301,7 +301,6 @@ void blk_insert_flush(struct request *rq)
> =A0 =A0 =A0 =A0unsigned int fflags =3D q->flush_flags; =A0 /* may cha=
nge, cache */
> =A0 =A0 =A0 =A0unsigned int policy =3D blk_flush_policy(fflags, rq);
>
> - =A0 =A0 =A0 BUG_ON(rq->end_io);
> =A0 =A0 =A0 =A0BUG_ON(!rq->bio || rq->bio !=3D rq->biotail);
>
> =A0 =A0 =A0 =A0/*
> @@ -320,6 +319,7 @@ void blk_insert_flush(struct request *rq)
> =A0 =A0 =A0 =A0if ((policy & REQ_FSEQ_DATA) &&
> =A0 =A0 =A0 =A0 =A0 =A0!(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTF=
LUSH))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_add_tail(&rq->queuelist, &q->queu=
e_head);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_run_queue_async(q);
A minor issue. I can understand this is required for
blk_insert_cloned_request() because INSERT_BACK will run
queue but INSERT_FLUSH doesn't. But sounds we don't need
run queue for normal requests. Either __make_request will run
queue (task has plug list) or flush_plug will run queue. delaying
run queue has its benefit. can we do the runqueue in
blk_insert_cloned_request() if this is a INSERT_FLUSH.

Thanks,
Shaohua
