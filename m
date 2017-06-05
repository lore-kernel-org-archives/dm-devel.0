From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md: initialise ->writes_pending in personality modules.
Date: Mon, 05 Jun 2017 16:05:13 +1000
Message-ID: <87zidnc6li.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


The new per-cpu counter for writes_pending is initialised in
md_alloc(), which is not called by dm-raid.
So dm-raid fails when md_write_start() is called.

Move the initialization to the personality modules
that need it.  This way it is always initialised when needed,
but isn't unnecessarily initialized (requiring memory allocation)
when the personality doesn't use writes_pending.

Reported-by: Heinz Mauelshagen <heinzm@redhat.com>
Fixes: 4ad23a976413 ("MD: use per-cpu counter for writes_pending")
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/md.c     | 16 ++++++++++++----
 drivers/md/md.h     |  1 +
 drivers/md/raid1.c  |  2 ++
 drivers/md/raid10.c |  3 +++
 drivers/md/raid5.c  |  3 +++
 5 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 10367ffe92e3..23f4adf3a8cc 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5174,6 +5174,18 @@ static void mddev_delayed_delete(struct work_struct =
*ws)
=20
 static void no_op(struct percpu_ref *r) {}
=20
+int mddev_init_writes_pending(struct mddev *mddev)
+{
+	if (mddev->writes_pending.percpu_count_ptr)
+		return 0;
+	if (percpu_ref_init(&mddev->writes_pending, no_op, 0, GFP_KERNEL) < 0)
+		return -ENOMEM;
+	/* We want to start with the refcount at zero */
+	percpu_ref_put(&mddev->writes_pending);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mddev_init_writes_pending);
+
 static int md_alloc(dev_t dev, char *name)
 {
 	/*
@@ -5239,10 +5251,6 @@ static int md_alloc(dev_t dev, char *name)
 	blk_queue_make_request(mddev->queue, md_make_request);
 	blk_set_stacking_limits(&mddev->queue->limits);
=20
=2D	if (percpu_ref_init(&mddev->writes_pending, no_op, 0, GFP_KERNEL) < 0)
=2D		goto abort;
=2D	/* We want to start with the refcount at zero */
=2D	percpu_ref_put(&mddev->writes_pending);
 	disk =3D alloc_disk(1 << shift);
 	if (!disk) {
 		blk_cleanup_queue(mddev->queue);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 11f15146ce51..0fa1de42c42b 100644
=2D-- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -648,6 +648,7 @@ extern void md_unregister_thread(struct md_thread **thr=
eadp);
 extern void md_wakeup_thread(struct md_thread *thread);
 extern void md_check_recovery(struct mddev *mddev);
 extern void md_reap_sync_thread(struct mddev *mddev);
+extern int mddev_init_writes_pending(struct mddev *mddev);
 extern void md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index af5056d56878..e1a7e3d4c5e4 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3063,6 +3063,8 @@ static int raid1_run(struct mddev *mddev)
 			mdname(mddev));
 		return -EIO;
 	}
+	if (mddev_init_writes_pending(mddev) < 0)
+		return -ENOMEM;
 	/*
 	 * copy the already verified devices into our private RAID1
 	 * bookkeeping area. [whatever we allocate in run(),
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4343d7ff9916..797ed60abd5e 100644
=2D-- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3611,6 +3611,9 @@ static int raid10_run(struct mddev *mddev)
 	int first =3D 1;
 	bool discard_supported =3D false;
=20
+	if (mddev_init_writes_pending(mddev) < 0)
+		return -ENOMEM;
+
 	if (mddev->private =3D=3D NULL) {
 		conf =3D setup_conf(mddev);
 		if (IS_ERR(conf))
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9c4f7659f8b1..861fc9a8d1be 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7108,6 +7108,9 @@ static int raid5_run(struct mddev *mddev)
 	long long min_offset_diff =3D 0;
 	int first =3D 1;
=20
+	if (mddev_init_writes_pending(mddev) < 0)
+		return -ENOMEM;
+
 	if (mddev->recovery_cp !=3D MaxSector)
 		pr_notice("md/raid:%s: not clean -- starting background reconstruction\n=
",
 			  mdname(mddev));
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlk09JwACgkQOeye3VZi
gbnFsw//f6t2MJX71u3T9gt0cD3wWOtgngvFrHLBNOUI1DyVRj9Fxi+JRJxN93Fz
ES6R8V+tOMtjsad5n4oPk61cVfh3qWxBTTRBmnMDgCpNrJu8VSDddvrYYVz1RTCm
6HOr0Rc0t80sY50UFKVgHKO3JZfl4iGL5Qy/5RBkf8R3EYjWfQsGFKFX+Bxwrjwx
Hfsqkw47qt3g8NgKrxZWAk/nKGJF9uSrAGVuc0eDTV+V8DfTuZbUxT9i2kJi0joe
RrqZAoKOgIG8gEj3gkuzJOxIsAVKAk5R67n3ks57dDbQR6DAhUucGC3y0q5H2OKP
W7pxZQx0iD2cGufPkIG/rs+VA4zYSvWZoCoXFjUI3M8DsNjollhohuhx956to6sE
Oo9fbigletWGaQiQ2SnxRRlGVxC9997Gk73wJauHI7jflX2D8+O8P7Cs7QZsxIJD
yoUdJU1fMuT13CtasFnDzbphKtotdluWW81uX24vspg0l+OaU10nrDjXMXRrY1BY
SDbYidJYa9SZIxkq3r/tVBkaJ5RwO+edYMhhZbi94mITZItSQc4b/CGhe12w0xaH
Pmt9Dt9RRzPiW7FHOCJFTMdmAaUFKcVhJWPhueBwXuB1/VYb3F5tYYs19d0sFUxa
ANhV0UfKSSGpYPfjd1StuFWLY1lo8Pxs5xC4cZbDW4j8Tj5VM5s=
=KbXf
-----END PGP SIGNATURE-----
--=-=-=--
