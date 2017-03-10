From: NeilBrown <neilb@suse.com>
Subject: [PATCH 4/5] blk: use non-rescuing bioset for q->bio_split.
Date: Fri, 10 Mar 2017 15:36:20 +1100
Message-ID: <871su5hhob.fsf@notabene.neil.brown.name>
References: <87h93blz6g.fsf@notabene.neil.brown.name> <71562c2c-97f4-9a0a-32ec-30e0702ca575@profitbricks.com> <87lgsjj9w8.fsf@notabene.neil.brown.name> <a674456d-fb93-437e-c50e-195e7a035ba4@kernel.dk> <87r328j00i.fsf@notabene.neil.brown.name> <87d1dphhuy.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87d1dphhuy.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jack Wang <jinpu.wang@profitbricks.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>, Pavel Machek <pavel@ucw.cz>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


A rescuing bioset is only useful if there might be bios from
that same bioset on the bio_list_on_stack queue at a time
when bio_alloc_bioset() is called.  This never applies to
q->bio_split.

Allocations from q->bio_split are only ever made from
blk_queue_split() which is only ever called early in each of
various make_request_fn()s.  The original bio (call this A)
is then passed to generic_make_request() and is placed on
the bio_list_on_stack queue, and the bio that was allocated
from q->bio_split (B) is processed.

The processing of this may cause other bios to be passed to
generic_make_request() or may even cause the bio B itself to
be passed, possible after some prefix has been split off
(using some other bioset).

generic_make_request() now guarantees that all of these bios
(B and dependants) will be fully processed before the tail
of the original bio A gets handled.  None of these early bios
can possible trigger an allocation from the original
q->bio_split as they are either too small to require
splitting or (more likely) are destined for a different queue.

The next time that the original q->bio_split might be used
by this thread is when A is processed again, as it might
still be too big to handle directly.  By this time there
cannot be and other bios allocated fro q->bio_split in the
generic_make_request() queue.  So no rescuing will ever be
needed.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c3992d17dc2c..375006c94c15 100644
=2D-- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -714,7 +714,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_ma=
sk, int node_id)
 	if (q->id < 0)
 		goto fail_q;
=20
=2D	q->bio_split =3D bioset_create_rescued(BIO_POOL_SIZE, 0);
+	q->bio_split =3D bioset_create(BIO_POOL_SIZE, 0);
 	if (!q->bio_split)
 		goto fail_id;
=20



--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljCLUQACgkQOeye3VZi
gbmtbw//Vqna/c1XoVNNyGIbpl7CVQfYE1gHgFUo/NG9BuGrZw7iF2NRUhTr3BzS
7vNIgMsj5feegCG6d4yKS6LGck6sYNWu62yWvjG+DuaK9PhGL7yt5xZyyxDe42y9
2HUkQVpg8XT2UgxhpTpEHYp2TQTkz6QebGchdeU6ExmUr1hLoPi/DXAiLr48H9NQ
bHii/ukL5BymRm9cydsEPOuHLAWndZgWNQwOq2k87AT7kXobWzEpLdoNtLZpMHc+
aPMpAyYg6+rZRxn4WOuCvkeYlwIB8WeWWOlqolsCzSriY+974lwGv2IOSN7MxEtV
v/Mlm/z1AHbbeNwfE6hHM5KoaemWV/gGx2zATGBiNUBV3jawkBdWhExcmvqkt+bt
A+Fac/jOKee0WuLiFwU24sB4v128KKrXUrlNvpDGZIjhbQ3uIGDBV3zeVwPrMZhh
8hHCfs8NiiSR2u19xbeiIwHtbrW2QtFvAPbv/RmvFZMgWammMUVUTByMHoPfjLcR
YhQwooNnTj7Q/qorLRtxLT2Ut0ZRXBhXJIt3Bcrvq1M3lN+UQLXVDQ7s4YsKzhZL
baATDHgykZ0jl+6dh62YSQJw8ij3O/tmme+z6bn/o3UBWujPGN8CRSkgeQogWcaX
MOre5eE4IFu0Vlk1vG0K/5wxQpmzMldpglKXOo+0z28BMsgTaXQ=
=taSq
-----END PGP SIGNATURE-----
--=-=-=--
