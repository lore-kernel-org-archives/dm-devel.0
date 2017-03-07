From: NeilBrown <neilb@suse.com>
Subject: [PATCH v2] blk: improve order of bio handling in
	generic_make_request()
Date: Wed, 08 Mar 2017 07:38:05 +1100
Message-ID: <87r328j00i.fsf@notabene.neil.brown.name>
References: <87h93blz6g.fsf@notabene.neil.brown.name>
	<71562c2c-97f4-9a0a-32ec-30e0702ca575@profitbricks.com>
	<87lgsjj9w8.fsf@notabene.neil.brown.name>
	<a674456d-fb93-437e-c50e-195e7a035ba4@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8054014909071316192=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a674456d-fb93-437e-c50e-195e7a035ba4@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>, Jack Wang <jinpu.wang@profitbricks.com>
Cc: linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Pavel Machek <pavel@ucw.cz>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

--===============8054014909071316192==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


To avoid recursion on the kernel stack when stacked block devices
are in use, generic_make_request() will, when called recursively,
queue new requests for later handling.  They will be handled when the
make_request_fn for the current bio completes.

If any bios are submitted by a make_request_fn, these will ultimately
be handled seqeuntially.  If the handling of one of those generates
further requests, they will be added to the end of the queue.

This strict first-in-first-out behaviour can lead to deadlocks in
various ways, normally because a request might need to wait for a
previous request to the same device to complete.  This can happen when
they share a mempool, and can happen due to interdependencies
particular to the device.  Both md and dm have examples where this happens.

These deadlocks can be erradicated by more selective ordering of bios.
Specifically by handling them in depth-first order.  That is: when the
handling of one bio generates one or more further bios, they are
handled immediately after the parent, before any siblings of the
parent.  That way, when generic_make_request() calls make_request_fn
for some particular device, we can be certain that all previously
submited requests for that device have been completely handled and are
not waiting for anything in the queue of requests maintained in
generic_make_request().

An easy way to achieve this would be to use a last-in-first-out stack
instead of a queue.  However this will change the order of consecutive
bios submitted by a make_request_fn, which could have unexpected consequenc=
es.
Instead we take a slightly more complex approach.
A fresh queue is created for each call to a make_request_fn.  After it comp=
letes,
any bios for a different device are placed on the front of the main queue, =
followed
by any bios for the same device, followed by all bios that were already on
the queue before the make_request_fn was called.
This provides the depth-first approach without reordering bios on the same =
level.

This, by itself, it not enough to remove all deadlocks.  It just makes
it possible for drivers to take the extra step required themselves.

To avoid deadlocks, drivers must never risk waiting for a request
after submitting one to generic_make_request.  This includes never
allocing from a mempool twice in the one call to a make_request_fn.

A common pattern in drivers is to call bio_split() in a loop, handling
the first part and then looping around to possibly split the next part.
Instead, a driver that finds it needs to split a bio should queue
(with generic_make_request) the second part, handle the first part,
and then return.  The new code in generic_make_request will ensure the
requests to underlying bios are processed first, then the second bio
that was split off.  If it splits again, the same process happens.  In
each case one bio will be completely handled before the next one is attempt=
ed.

With this is place, it should be possible to disable the
punt_bios_to_recover() recovery thread for many block devices, and
eventually it may be possible to remove it completely.

Ref: http://www.spinics.net/lists/raid/msg54680.html
Tested-by: Jinpu Wang <jinpu.wang@profitbricks.com>
Inspired-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 block/blk-core.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

Changes since v1:
 - merge code improvements from Jack Wang
 - more edits to changelog comment
 - add Ref: link.
 - Add some lists to Cc, that should have been there the first time.
=20


diff --git a/block/blk-core.c b/block/blk-core.c
index b9e857f4afe8..9520e82aa78c 100644
=2D-- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2018,17 +2018,34 @@ blk_qc_t generic_make_request(struct bio *bio)
 		struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);
=20
 		if (likely(blk_queue_enter(q, false) =3D=3D 0)) {
+			struct bio_list hold;
+			struct bio_list lower, same;
+
+			/* Create a fresh bio_list for all subordinate requests */
+			hold =3D bio_list_on_stack;
+			bio_list_init(&bio_list_on_stack);
 			ret =3D q->make_request_fn(q, bio);
=20
 			blk_queue_exit(q);
=20
=2D			bio =3D bio_list_pop(current->bio_list);
+			/* sort new bios into those for a lower level
+			 * and those for the same level
+			 */
+			bio_list_init(&lower);
+			bio_list_init(&same);
+			while ((bio =3D bio_list_pop(&bio_list_on_stack)) !=3D NULL)
+				if (q =3D=3D bdev_get_queue(bio->bi_bdev))
+					bio_list_add(&same, bio);
+				else
+					bio_list_add(&lower, bio);
+			/* now assemble so we handle the lowest level first */
+			bio_list_merge(&bio_list_on_stack, &lower);
+			bio_list_merge(&bio_list_on_stack, &same);
+			bio_list_merge(&bio_list_on_stack, &hold);
 		} else {
=2D			struct bio *bio_next =3D bio_list_pop(current->bio_list);
=2D
 			bio_io_error(bio);
=2D			bio =3D bio_next;
 		}
+		bio =3D bio_list_pop(current->bio_list);
 	} while (bio);
 	current->bio_list =3D NULL; /* deactivate */
=20
=2D-=20
2.12.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli/Gi0ACgkQOeye3VZi
gbnm7w//cNixQfS7igcyLC4/P28sJ6GeYESGga5mtZwIlz5sHfpqvDyOCqKA5vBB
BnczNn3wMhDIMpIbzMyiaX3Nhp+442+1up0xCU6Srp1amkIXTrFQ84qv/BWvQhVu
mfVOVyR9c9xcX0ihd1Ol8zAzdnfmeOV0S2K9gwM+/wDgBGTPw0BnAKsG54MS/NXt
onq8nl9nJwc4D4yuF+nF7pkEOX7A0V2afe/WLDYbRtPv6PSJ+8oeyEw4yunfUq0r
uu6cGbr6/Yt59LWEVA0l83it1ZSP/So5zyeedM0CMO2745Ymar4L+XUgmUQdV4Rr
g5Tqu11KRq6ABBqtsb41yj4g5XGDi225+M6gzSHRXdZtiuiGlCAx71K0XwYqgPQj
xoCy55Ou7QFXwIwfqlnTHdpkdcSOnHVhxCWsT9xbWdSZqxsm08Z4V8QHz261/PFc
70T63iwhIzV6mYFA/g993urcrPZe/sAK+K+f/nonq2MMuKhlFhKDrUpDeWSZd6gI
S1v2yHtZvO3aQAJLzVJ0Ms1B9i+P4ouuRtGYq7Ox1+GQOjhUZ3reDlICOm2pSY4y
GP8mRacjH7x9b0zT1gOsh6tko+xigoHUY7ZkKRXp4V4g0CAES5hX/DwHYVNlVwdV
/yYiiNsxyiQiKzL6aKnndTD3Jk0wTLmvjkSOqVi5dHLyEvm6STM=
=Szsy
-----END PGP SIGNATURE-----
--=-=-=--


--===============8054014909071316192==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8054014909071316192==--
