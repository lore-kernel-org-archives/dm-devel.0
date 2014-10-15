From: NeilBrown <neilb@suse.de>
Subject: [PATCH] dm raid: ensure metadata IO matches device block
	size.
Date: Wed, 15 Oct 2014 12:19:07 +1100
Message-ID: <20141015121907.265b3aed@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7859176873646891474=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Liuhua Wang <lwang@suse.com>, Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--===============7859176873646891474==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/DC8PnpFH7mx+VOuA5jdP2hu";
	protocol="application/pgp-signature"

--Sig_/DC8PnpFH7mx+VOuA5jdP2hu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


dm_raid_superblock is 512.
Reading or writing this on a 512-byte sector works fine.
On a 4096-byte sector device, this fails.

If we round up rdev->sb_size to match the block size of
the device, all IO will work correctly.

Reported-by: "Liuhua Wang" <lwang@suse.com>
Signed-off-by: NeilBrown <neilb@suse.de>

---
this issue has been discussed already a bit. See email thread
 Subject: Re: [dm-devel] [PATCH] fix mirror device creation with lvcreate f=
ailed
I think this is the best fix.  It handles boths read and writes, and (I thi=
nk)
at the best level.

Thanks,
NeilBrown


diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4880b69e2e9e..31bdd73bc368 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -858,7 +858,8 @@ static int super_load(struct md_rdev *rdev, struct md_r=
dev *refdev)
 	uint64_t events_sb, events_refsb;
=20
 	rdev->sb_start =3D 0;
-	rdev->sb_size =3D sizeof(*sb);
+	rdev->sb_size =3D roundup(sizeof(*sb),
+				bdev_logical_block_size(rdev->meta_bdev));
=20
 	ret =3D read_disk_sb(rdev, rdev->sb_size);
 	if (ret)

--Sig_/DC8PnpFH7mx+VOuA5jdP2hu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVD3Liznsnt1WYoG5AQKBcA//VdPefOvhfRgiIoJXpbDyg842IbvopWNg
3VJ+LQ51BkIkbzZeZ2/fWyL2OgmkMt0ZonQja0ChlCjw8o98LXaV9ivniZ5XqaH7
Fea+WoEy4xecdjiLW4ruxzYPocGXxrj1nJBLiWQvvfRp1xu9ycH2OoZqRvTPKekd
QFs1399QZeCi2lZYnC0la/7PCbUQQwJWZkITWZ4IxWg2RPpv5kmwnEy9omo9ew/5
WUV/gl6QXqBkEy/Tx3jHiOl8hmDTksEq21qLcn/qpy6rlHElidBTa5DOVwts+eY9
FXf4oCLko/Z8t5r7uk2dmfguQju85frlZKJTBSBb1lD3azW52WHPCqe/1cfvU4nv
nZPiMdG1Fhj9CfJ6QQmLkpkH2utj0VTcFyAM5n/so0GLHXa3m49Hprmb+4yPeiak
jpcTNLAviZ4Dd7qISPyK6N/S1wgtc3qKCcuGHVe0eyJa0zfzevlGqhMnnEW16IJO
EBlZrtk2FTmbiaF1o86xP29JNbwHL+6ZIpMeh4yi1BAjdkQuwd0l3BI96rGIHF/7
lUrapnsnMTfMMoU2Kg+f0fDhM3qy9h/v1CVRZSi69x6XUuaD5BPSGvfiQomHxliR
h7xOrMr63TVEYqoJegks0emzVzqpv/Ekm6cJXWfLje1Q3AX+kyTwU1knWpp2PwGY
EgGpviY3Vgs=
=LJUO
-----END PGP SIGNATURE-----

--Sig_/DC8PnpFH7mx+VOuA5jdP2hu--


--===============7859176873646891474==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7859176873646891474==--
