From: NeilBrown <neilb@suse.com>
Subject: [PATCH] dm: correctly handle chained bios in dec_pending()
Date: Thu, 15 Feb 2018 20:00:15 +1100
Message-ID: <87k1vepqzk.fsf@notabene.neil.brown.name>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


dec_pending() is given an error status (possibly 0)
to be recorded against a bio.
It can be called several times on the one 'struct dm_io',
and it is careful to only assign a non-zero error to
io->status.
However when it then assigned io->status to bio->bi_status,
it is not careful and could overwrite a genuine error status with
zero.

This can happen when chained bios are in use.  If a bio is chained
beneath the bio that this dm_io is handling, the child bio might
complete and set bio->bi_status before the dm_io completes.

This has been possible since chained bios were introduced in 3.14, and
become a lot easier to trigger with commit 18a25da84354 ("dm: ensure bio
submission follows a depth-first tree walk") as that commit caused dm to
start using chained bios itself.

A particular failure mode is that if a bio spans an 'error' target and
a working target, the 'error' fragment will complete instantly and set
the ->bi_status, and the other fragment will normally complete a
little later, and will clear ->bi_status.

The fix is simply to only assign io_error to bio->bi_status when
io_error is not zero.

Reported-and-tested-by: Milan Broz <gmazyland@gmail.com>
Cc: stable@vger.kernel.org (v3.14+)
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d6de00f367ef..68136806d365 100644
=2D-- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -903,7 +903,8 @@ static void dec_pending(struct dm_io *io, blk_status_t =
error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
=2D			bio->bi_status =3D io_error;
+			if (io_error)
+				bio->bi_status =3D io_error;
 			bio_endio(bio);
 		}
 	}
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlqFTB8ACgkQOeye3VZi
gbnIWQ//boIh7VP4NRCJxy1CgFlcx8UHEALUBBvPBKUJ5GZdSy/SM2OiYHvnSUNI
GZZx7P9Dp2F4KElFI4sIeXpfPketwHsX2DT/1kGH2H9lMV+v/8qqO2CcxSPTxshq
91W56zgEdbjcZX+Tcj2ZH4xeNtqkRHB/9RpZdF/TqYbU72Vog3o/UzXX8EIEFZ0s
SWUVA9AI7mCQm4uYbzieY/uMaugZKxDQxgDosy9QNFhgMS6gVUB0L71naY4vANlR
loc8J6ORoQPJ5sM7kYBX1Tyxgao1RYDFvF0SASlveamhb0ktxELC4O0alLLDgfv4
HXM6tuZLva0FmAhCDs+nWzp9KAB/dMgIUigvf9oXxfTl5cve/V8sLMMPmTq7vH5w
b28H4cM/YYfTC4RRZagiVqn2EScoWqxKBBh8KXsjvE3nARLer0HPWGm5DMecTh3D
E4/2GNjlp5zkFjPPaTbO8WU+yC/wABOaBrHid5piyQhaPpt9AL7xDtIW16LhfJaB
snJcn4oRjcRROPk2Qb1FpiPkWrq0BYzBo5tOLgGbbQy6mnEDFtw1LB0+ZeS9T1hZ
AX8bW2TW3ZL3m74yJRwlvisLTAvBTWmZTGwlzpkUw78dzoWOE/A3MkRjptByrToR
ZFAfHXvAq4XWAvqmHEkBCFCx8gqhWm7s2KHpDx7+dzpN6vrK934=
=WsZm
-----END PGP SIGNATURE-----
--=-=-=--
