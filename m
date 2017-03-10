From: NeilBrown <neilb@suse.com>
Subject: [PATCH 5/5] block_dev: make blkdev_dio_pool a non-rescuing bioset
Date: Fri, 10 Mar 2017 15:37:41 +1100
Message-ID: <87y3wdg31m.fsf@notabene.neil.brown.name>
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


Allocations from blkdev_dio_pool are never made under
generic_make_request, so this bioset does not need a rescuer thread.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 fs/block_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c0ca5f0d0369..2eca00ec4370 100644
=2D-- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -436,7 +436,7 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *i=
ter)
=20
 static __init int blkdev_init(void)
 {
=2D	blkdev_dio_pool =3D bioset_create_rescued(4, offsetof(struct blkdev_dio=
, bio));
+	blkdev_dio_pool =3D bioset_create(4, offsetof(struct blkdev_dio, bio));
 	if (!blkdev_dio_pool)
 		return -ENOMEM;
 	return 0;



--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljCLZUACgkQOeye3VZi
gbkLmA/8CmeNbNFTvSRO6k8E9hrVRTMjSBnLDc+fqP1lIwzkjb1S6+h5iKUcTxzo
y/OiP2NSpCf3c6BH66CRT1wgGpSCtk1gUOZwE0dX5KmjOJ09qTXZeuap+G5e78BC
DUaBiFvSoTq68nGeZUxQ36osOBSCXZ+l0yZO3kAGZP8qOdPMyTj4qUJKvL2fIYwD
lbrVZ1Tbm390F5lI3B6bXSmGKTIQQmf5Yvj7NoezW0iPFqq7idCXExb/eKhXpsPU
dRc8jRP+Q9zeg7efEk9VT4MqrIbguEay8j5RmPuOhF54YT/Mle0SMXbwxszGs79Y
418959/C+k/fs96NQ9Um5F+MzQ+TqpXX/YgieLm+gLHxINDDP/R6EOpL331cm5SL
eakadQjHlKlyjpI1HlwUxWSc3+Cw0v8cqt3I6hI/YF0XJBCk/oWgQJTrilB3ug4I
UKjtQkHo/NvRHXlYGDMudfaaDZFzKby+f1qkj+PiKCu5Lv4I6Cazm2htT6nvEhvi
gz9pycu+L+pp5DRBE50SNTFwOYyZmDa8+CNajVdHx01PC+zFZPCB/xalZReZSyCF
pOyFX48x7WeDOezpQHFd5aTMUSGWjudKGswLpk8ibBHTgc65Fe8+dyeHlwQuNuX8
1QARp9q5fKEUt0eqN2NcT2m9Zz08HGJKr5sFXLNOoW7xH8NI7Mw=
=7NCx
-----END PGP SIGNATURE-----
--=-=-=--
