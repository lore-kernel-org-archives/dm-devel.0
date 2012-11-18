From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/3] Add a new func to handle with clearing up for
 stoping dm-raid.
Date: Mon, 19 Nov 2012 10:49:53 +1100
Message-ID: <20121119104953.359f60ed@notabene.brown>
References: <201211151646510171304@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XTAnAm=iBJbP/TsKNbNmGtf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201211151646510171304@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: agk <agk@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

--Sig_/XTAnAm=iBJbP/TsKNbNmGtf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Nov 2012 16:46:54 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Because dm-raid call md_stop to clear up,but md_stop can't clear up compl=
etely.
> So add a new func to do.
>=20
> Jianpeng Ma (3):
>   md:Add a func 'dm_md_stop' for dm-raid to clear up md resource.
>   dm: When stoping dm-raid, it call dm_md_stop rather than md_stop to
>     do clear-up work.
>   md: Remove EXPORT_SYMBOL_GPL(md_stop).
>=20
>  drivers/md/dm-raid.c |    4 ++--
>  drivers/md/md.c      |   10 +++++++++-
>  drivers/md/md.h      |    1 +
>  3 files changed, 12 insertions(+), 3 deletions(-)
>=20

You don't really need 3 patches for this one little change.

I've applied the following.

Thanks for the report.

NeilBrown

=46rom 4ba69e1a88480249918ed2df8be0896be6ba7952 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 19 Nov 2012 10:47:48 +1100
Subject: [PATCH] md: make sure everything is freed when dm-raid stops an
 array.

md_stop() would stop an array, but not free various attached
data structures.
For internal arrays, these are freed later in do_md_stop() or
mddev_put(), but they don't apply for dm-raid arrays.
So get md_stop() to free them, and only all it from dm-raid.
For internal arrays we now call __md_stop.

Reported-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 98e1484..71df3c2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5294,7 +5294,7 @@ void md_stop_writes(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_stop_writes);
=20
-void md_stop(struct mddev *mddev)
+void __md_stop(struct mddev *mddev)
 {
 	mddev->ready =3D 0;
 	mddev->pers->stop(mddev);
@@ -5304,6 +5304,18 @@ void md_stop(struct mddev *mddev)
 	mddev->pers =3D NULL;
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 }
+
+void md_stop(struct mddev *mddev)
+{
+	/* stop the array and free an attached data structures.
+	 * This is called from dm-raid
+	 */
+	__md_stop(mddev);
+	bitmap_destroy(mddev);
+	if (mddev->bio_set)
+		bioset_free(mddev->bio_set);
+}
+
 EXPORT_SYMBOL_GPL(md_stop);
=20
 static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
@@ -5364,7 +5376,7 @@ static int do_md_stop(struct mddev * mddev, int mode,
 			set_disk_ro(disk, 0);
=20
 		__md_stop_writes(mddev);
-		md_stop(mddev);
+		__md_stop(mddev);
 		mddev->queue->merge_bvec_fn =3D NULL;
 		mddev->queue->backing_dev_info.congested_fn =3D NULL;
=20

--Sig_/XTAnAm=iBJbP/TsKNbNmGtf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKl0ITnsnt1WYoG5AQJtzBAAlUG4BnmHY7WB0BNUtM98+vflGNBkVQRj
7XIkO6oxCS6Ep1rnu+sAA6oDN71RIrd67dhgvP1+it6yNdTlMALUb1XHsvUuZOJq
9gbmTPTcj7kL8SqX57nH4MImmPlaXavR8WpIaEmPhIKMvvpMpaOz2iwwdM7tJASj
PMnqF1kI36ONVUH1/crGMGioCSo75PUI0mV8QrBpgUq28nawEoSd5vUXLFRxkGue
usu9hcarqQj8E3HCaJOug4xQeE3Il5XePuKBBz5b9D/cXAHB9LxneX+QbCjcCoUx
VR9DEpkWuscB012bNaviYllJpkx4edTjJuZXZcfQI+YlzAhuBslnlv63miJULxfl
fi+3Efu2hTdsylJHg6QEL/v+yAXO6AMh7hr2lyKGWZ5AjJ8aPLfyYpji5tJOPfBf
W6/QrqjsImaA+psDwScuqZhtEPZrgGGO4JgSZRNUM+mYCpSpxsS+qId01AdRhLDJ
Ba2ie/OFct5iC39lpiHnULt2Bu1Bfzev6H6ntABADMaCyyJgKiH7O4sqKkOaix8V
jWyB4aGw3PQvb3L3N+S2dDl8glPHoyzilyR1Q2PIwYuTC7Wad6xrKq/MZqhB75DE
UC43WRN9mTZmGMtC8v3/ZvvGR/BpWfpH6ARRJ/60TGDkyTzSRLobX/n66KrKw6pV
S4lPNMYHZqE=
=GZ3O
-----END PGP SIGNATURE-----

--Sig_/XTAnAm=iBJbP/TsKNbNmGtf--
