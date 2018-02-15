From: NeilBrown <neilb@suse.com>
Subject: [PATCH] block: be more careful about status in __bio_chain_endio
Date: Thu, 15 Feb 2018 20:09:24 +1100
Message-ID: <87eflmpqkb.fsf@notabene.neil.brown.name>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Milan Broz <gmazyland@gmail.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


If two bios are chained under the one parent (with bio_chain())
it is possible that one will succeed and the other will fail.
__bio_chain_endio must ensure that the failure error status
is reported for the whole, rather than the success.

It currently tries to be careful, but this test is racy.
If both children finish at the same time, they might both see that
parent->bi_status as zero, and so will assign their own status.
If the assignment to parent->bi_status by the successful bio happens
last, the error status will be lost which can lead to silent data
corruption.

Instead, __bio_chain_endio should only assign a non-zero status
to parent->bi_status.  There is then no need to test the current
value of parent->bi_status - a test that would be racy anyway.

Note that this bug hasn't been seen in practice.  It was only discovered
by examination after a similar bug was found in dm.c

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index e1708db48258..ad77140edc6f 100644
=2D-- a/block/bio.c
+++ b/block/bio.c
@@ -312,7 +312,7 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 {
 	struct bio *parent =3D bio->bi_private;
=20
=2D	if (!parent->bi_status)
+	if (bio->bi_status)
 		parent->bi_status =3D bio->bi_status;
 	bio_put(bio);
 	return parent;
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlqFTkQACgkQOeye3VZi
gbl38hAAuH2ehzZRqSUECPVbVybMgFyXH9hu3wZUFXmHTAgE0+qtBFdNzQezHDc5
QcjGXptF707jUFETG6v4mtGLRlRGTl6zZ++PSb8otV1ZNqAsLtO2XPpdezk7cwuz
4NpRrHSgUX2oxbsgmEWenx09SlDl2HrD7KFl9eXBY1zDNGvol8c9jV07FAeqr2dG
u6FaYoquornB9NS2nC1GXOvOpbs2NWkvj04H3NWvh0rvk4vxTzcb2avB9Jw60MQ/
F2Y1V65ZrrnrGlqrfqxGWWJVu94N+mw9MPlGl+B+/6ObkPsFxKhTAUyoNQ+3yWnC
fV3jDeVf2f4ZLKGbGb82NA1ZF7hJVqyf4ZRJNCf8A0Wlf3Lx0izpQE97wn2Qr4y8
b/Ha3ZPcb7k7aMW2xlU+966j4duczGSGncszRCUodhdOETHsK24GTRJHb8rEBDKp
9r4DSoEt/zj8wkWNluXAwow8OnIBI5WOkH5FoiZgdmGcTbaOl9dd5ZwVoEv425po
vzqCqDJYAwIZ7PaLfgpfvrIhPXA/Hl6FwJv2PhJpilOViqhmaWxxXjl8BFL+Q5QL
ISqW/3fmAi06YcKK82QQwBtlAGjvpbierPHAahu5s5Tor75LYRm36hmZ2DnQE61L
/CgV5f0B1wB9TbOoJortlx7dKXol3zublH8p84+WlLZ15gBtnnw=
=k8H1
-----END PGP SIGNATURE-----
--=-=-=--
