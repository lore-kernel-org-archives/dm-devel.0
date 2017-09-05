From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH/rfc] dm: revise 'rescue' strategy for md->bs
	allocations
Date: Wed, 06 Sep 2017 09:43:28 +1000
Message-ID: <874lsgd84f.fsf@notabene.neil.brown.name>
References: <878ti0fefq.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1708312233010.32309@file01.intranet.prod.int.rdu2.redhat.com>
	<87inh3dqp3.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1709011947200.22293@file01.intranet.prod.int.rdu2.redhat.com>
	<87a82be2zf.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1709041249100.9535@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4511004098443703240=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1709041249100.9535@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

--===============4511004098443703240==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 04 2017, Mikulas Patocka wrote:

> On Mon, 4 Sep 2017, NeilBrown wrote:
>
>> On Fri, Sep 01 2017, Mikulas Patocka wrote:
>>=20
>> > On Fri, 1 Sep 2017, NeilBrown wrote:
>> >
>> >> On Thu, Aug 31 2017, Mikulas Patocka wrote:
>> >>=20
>> >> >>=20
>> >> >> Note that only current->bio_list[0] is offloaded.  current->bio_li=
st[1]
>> >> >> contains bios that were scheduled *before* the current one started=
, so
>> >> >
>> >> > These bios need to be offloaded too, otherwise you re-introduce thi=
s=20
>> >> > deadlock: https://www.redhat.com/archives/dm-devel/2014-May/msg0008=
9.html
>> >>=20
>> >> Thanks for the link.
>> >> In the example the bio that is stuck was created in step 4.  The call
>> >> to generic_make_request() will have placed it on current->bio_list[0].
>> >> The top-level generic_make_request call by Process A is still running,
>> >> so nothing will have moved the bio to ->bio_list[1].  That only happe=
ns
>> >> after the ->make_request_fn completes, which must be after step 7.
>> >> So the problem bio is on ->bio_list[0] and the code in my patch will
>> >> pass it to a workqueue for handling.
>> >>=20
>> >> So I don't think the deadlock would be reintroduced.  Can you see
>> >> something that I am missing?
>> >>=20
>> >> Thanks,
>> >> NeilBrown
>> >
>> > Offloading only current->bio_list[0] will work in a simple case descri=
bed=20
>> > above, but not in the general case.
>> >
>> > For example, suppose that we have a dm device where the first part is=
=20
>> > linear and the second part is snapshot.
>> >
>> > * We receive bio A that crosses the linear/snapshot boundary
>> > * DM core creates bio B, submits it to the linear target and adds it t=
o=20
>> > current->bio_list[0]
>> > * DM core creates bio C, submits it to the snapshot target, the snapsh=
ot=20
>> > target calls track_chunk for this bio and appends the bio to=20
>> > current->bio_list[0]
>> > * Now, we return back to generic_make_request
>> > * We pop bio B from current->bio_list[0]
>> > * We execute bio_list_on_stack[1] =3D bio_list_on_stack[0], that moves=
 bio C=20
>> > to bio_list_on_stack[1] - and now we lose any possibility to offload b=
io C=20
>> > to the rescue thread
>> > * The kcopyd thread for the snapshot takes the snapshot lock and waits=
 for=20
>> > bio C to finish
>>=20
>> Thanks for the explanation.
>> I cannot find this last step in the code.  "waits for BIO C to finish"
>> is presumably the called to __check_for_conflicting_io().  This is
>> called from kcopyd in merge_callback() -> snapshot_merge_next_chunks().
>> What lock is held at that time?
>
> The function pending_complete is called from the kcopyd callback. It take=
s=20
> "down_write(&s->lock)" and calls __check_for_conflicting_io which waits=20
> for I/Os to finish.
>
>> > * We process bio B - and if processing bio B reaches something that ta=
kes=20
>> > the snapshot lock (for example an origin target for the snapshot), a=20
>> > deadlock will happen. The deadlock could be avoided by offloading bio =
C to=20
>> > the rescue thread, but bio C is already on bio_list_on_stack[1] and so=
 it=20
>> > won't be offloaded
>>=20
>> I think the core issue behind this deadlock is that the same volume
>> can appear twice in the top-level device, in different regions.  An
>> outstanding request to one region can then interfere with a new request
>> to a different region.  That seems like a reasonable thing to do.
>> I cannot immediately see a generic way to handle this case that I am
>> happy with.  I'll keep hunting.
>
> You can have a snapshot and an origin for the same device in the same=20
> tree - it is not common, but it is possible.
>
> Offloafing bios queued on current->bio_list avoids the deadlock, but your=
=20
> patch breaks it by offloading only the first list and not the second.
>

Thanks for the extra explanation.  I've thought some more about this I can
see a way forward that I am comfortable with.  Please let me know what
you think.
I haven't tested this patch yet, but I believe that applying it first will
clear the way for my other patch to work without reintroducing
deadlocks.

Thanks,
NeilBrown


From: NeilBrown <neilb@suse.com>
Date: Wed, 6 Sep 2017 09:14:52 +1000
Subject: [PATCH] dm: ensure bio submission follows a depth-first tree walk.

A dm device can, in general, represent a tree of targets,
each of which handles a sub-range of the range of blocks handled
by the parent.

The bio sequencing managed by generic_make_request() requires that bios
are generated and handled in a depth-first manner.  Each call to a
make_request_fn() may submit bios to a single member device, and may
submit bios for a reduced region of the same device as the
make_request_fn.

In particular, any bios submitted to member devices must be expected to
be processed in order, so a later one must never wait for an earlier
one.

This ordering is usually achieved by using bio_split() to reduce a bio
to a size that can be completely handled by one target, and resubmitting
the remainder to the originating device. bio_queue_split() shows the canoni=
cal
approach.

dm doesn't follow this approach, largely because it has needed to split
bios since long before bio_split() was available.  It currently can
submit bios to separate targets within the one dm_make_request() call.
Dependencies between these targets, as can happen with dm-snap, can
cause deadlocks if either bios gets stuck behind the other in the queues
managed by generic_make_request().  This requires the 'rescue'
functionality provided by dm_offload*.

Some of this requirement can be removed by changing the order of bio
submission to follow the canonical approach.  That is, if dm finds that
it needs to split a bio, the remainder should be sent to
generic_make_request() rather than being handled immediately.  This delays
the handling until the first part is completely processed, so the
deadlock problems do not occur.

__split_and_process_bio() can be called both from dm_make_request() and
from dm_wq_work().  When called from dm_wq_work() the current approach
is perfectly satisfactory as each bio will be processed immediately.
When called from dm_make_request, current->bio_list will be non-NULL,
and in this case it is best to create a separate "clone" bio for the
remainder.

To provide the clone bio when splitting, we use q->bio_split().  This
was previously being freed to avoid having excess rescuer threads.  As
bio_split bio sets no longer create rescuer threads, there is little
cost and much gain from leaving the ->bio_split bio set in place.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/dm.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d669fddd9290..81395f7550c0 100644
=2D-- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1007,7 +1007,7 @@ static void dm_dax_flush(struct dax_device *dax_dev, =
pgoff_t pgoff, void *addr,
=20
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It =
is
=2D * allowed for all bio types except REQ_PREFLUSH.
+ * allowed for all bio types except REQ_PREFLUSH and REQ_OP_ZONE_RESET.
  *
  * dm_accept_partial_bio informs the dm that the target only wants to proc=
ess
  * additional n_sectors sectors of the bio and the rest of the data should=
 be
@@ -1508,8 +1508,21 @@ static void __split_and_process_bio(struct mapped_de=
vice *md,
 	} else {
 		ci.bio =3D bio;
 		ci.sector_count =3D bio_sectors(bio);
=2D		while (ci.sector_count && !error)
+		while (ci.sector_count && !error) {
 			error =3D __split_and_process_non_flush(&ci);
+			if (current->bio_list && ci.sector_count && !error) {
+				/* Remainder must be passed to generic_make_request()
+				 * so that it gets handled *after* bios already submitted
+				 * have been completely processed.
+				 */
+				struct bio *b =3D bio_clone_bioset(bio, GFP_NOIO,
+								 md->queue->bio_split);
+				bio_advance(b, (bio_sectors(b) - ci.sector_count) << 9);
+				bio_chain(b, bio);
+				generic_make_request(b);
+				break;
+			}
+		}
 	}
=20
 	/* drop the extra reference count */
@@ -1520,8 +1533,8 @@ static void __split_and_process_bio(struct mapped_dev=
ice *md,
  *---------------------------------------------------------------*/
=20
 /*
=2D * The request function that just remaps the bio built up by
=2D * dm_merge_bvec.
+ * The request function that remaps the bio to one target and
+ * splits off any remainder.
  */
 static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
 {
@@ -2056,12 +2069,6 @@ int dm_setup_md_queue(struct mapped_device *md, stru=
ct dm_table *t)
 	case DM_TYPE_DAX_BIO_BASED:
 		dm_init_normal_md_queue(md);
 		blk_queue_make_request(md->queue, dm_make_request);
=2D		/*
=2D		 * DM handles splitting bios as needed.  Free the bio_split bioset
=2D		 * since it won't be used (saves 1 process per bio-based DM device).
=2D		 */
=2D		bioset_free(md->queue->bio_split);
=2D		md->queue->bio_split =3D NULL;
=20
 		if (type =3D=3D DM_TYPE_DAX_BIO_BASED)
 			queue_flag_set_unlocked(QUEUE_FLAG_DAX, md->queue);
=2D-=20
2.14.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmvNqMACgkQOeye3VZi
gbnEjw/+OwTWFCqLU6fnUeFRtAQKXugzHTh4SbtVqKUsP8nzb2KVlAzsHv5FLSYM
MrXCplnauRKjs81jVYdsk6/w61JgexPFS3O55wu9MdIWloFnorOqsfMIUzk6gYqJ
tt+ud5i97VXj3ENtb/V6kn0b4OstpGF4rYmrIveXop4q8DKqyKFyn93HqKSebiJ/
rWlQhSf3aJ82rC/eSo5k6lNJyMvGB6Gms62hNYK4STMInR8V7+ygIvskuhTYDAoO
lHYNBwPTS328pEs/EjIBknaWUvH511Wx5BwGZrL1KV+ccWNoi0XHpmIUR0WEvsG4
rpDxOLo1xAYt9e7BYu1abixADEmpWOuAnjOJCfOmGumjnAW7zrgM6n37ZLmm55LS
VxumFkU/V5yyvCp1rIjyF6+DWsMhmo6DQ7FahK1hfUYi9Zhj6kyku0GVe0LgxPOy
2WYz5Io5W4h+uSFCeTo9VIk5HNNXjRqfL1+hfqgDF8J3ZXsfRWaU6Al5v2WidAxZ
jz5aptz4y0Ff21vIimvFzzD7IiLBWnn+Q5A5tjj5MgGgtDCyDuNHvQtKC5dsaDqR
PAjAtDaMOhUTF1Xo1AJcEyeuC3WDU5Hq2JRbpzaCp4nY782WSXKxRu2HJ2Y1YRyp
tLAi+gE7dgfcm1PU05ioNMXV1TQTgM7O8jXwuorJd1KCHs+MN/Q=
=APQU
-----END PGP SIGNATURE-----
--=-=-=--


--===============4511004098443703240==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4511004098443703240==--
