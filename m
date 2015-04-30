From: NeilBrown <neilb@suse.de>
Subject: [PATCH stable] block: discard bdi_unregister() in favour of
 bdi_destroy()
Date: Thu, 30 Apr 2015 10:32:33 +1000
Message-ID: <20150430103233.75227693@notabene.brown>
References: <20150414171537.GH25394@azat>
	<20150423160551.45345f96@notabene.brown>
	<20150427141222.5dac22f1@notabene.brown>
	<CAMM=eLf2aFFH29xeDVrS7beFj6T8kqUQRh=4KB1YO0kWGa7Rog@mail.gmail.com>
	<20150429072530.39d38b00@notabene.brown>
	<20150429133512.GA4436@lst.de>
	<20150429160258.GK17717@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/OfqQ86f0HuessydaDU67vwj"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150429160258.GK17717@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Azat Khuzhin <a3at.mail@gmail.com>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--Sig_/OfqQ86f0HuessydaDU67vwj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


bdi_unregister() now contains very little functionality.

It contains a "WARN_ON" if bdi->dev is NULL.  This warning is of no
real consequence as bdi->dev isn't needed by anything else in the function,
and it triggers if
   blk_cleanup_queue() -> bdi_destroy()
is called before bdi_unregister, which a subsequent patch will make happen.
So this isn't wanted.

It also calls bdi_set_min_ratio().  This needs to be called after
writes through the bdi have all been flushed, and before the bdi is destroy=
ed.
Calling it early is better than calling it late as it frees up a global
resource.

Calling it immediately after bdi_wb_shutdown() in bdi_destroy()
perfectly fits these requirements.

So bdi_unregister can be discarded with the important content moved to
bdi_destroy, as can the
  writeback_bdi_unregister
event which is already not used.

This is tagged for 'stable' as it is a pre-requisite for a subsequent
patch which moves calls to blk_cleanup_queue() before calls to
del_gendisk().  The commit identified as 'Fixes' removed a lot of
other functionality from bdi_unregister(), and made a change which
necessitated moving the blk_cleanup_queue() calls.

Reported-by: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org (v4.0)
Fixes: c4db59d31e39ea067c32163ac961e9c80198fd37
Signed-off-by: NeilBrown <neilb@suse.de>

---

Hi again Jens,
 would you be able to queue this patch *before* the other one:
   block: destroy bdi before blockdev is unregistered.

 If it has to come after I'll need to re-write the text a bit.
 If you could give me the commit hash to reference I'll do that.

diff --git a/block/genhd.c b/block/genhd.c
index e351fc521053..1d4435478e8a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -657,7 +657,6 @@ void del_gendisk(struct gendisk *disk)
 	disk->flags &=3D ~GENHD_FL_UP;
=20
 	sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
-	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_queue(disk);
 	blk_unregister_region(disk_devt(disk), disk->minors);
=20
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index aff923ae8c4b..d87d8eced064 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -116,7 +116,6 @@ __printf(3, 4)
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...);
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
-void bdi_unregister(struct backing_dev_info *bdi);
 int __must_check bdi_setup_and_register(struct backing_dev_info *, char *);
 void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
 			enum wb_reason reason);
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeb=
ack.h
index 880dd7437172..c178d13d6f4c 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -250,7 +250,6 @@ DEFINE_EVENT(writeback_class, name, \
 DEFINE_WRITEBACK_EVENT(writeback_nowork);
 DEFINE_WRITEBACK_EVENT(writeback_wake_background);
 DEFINE_WRITEBACK_EVENT(writeback_bdi_register);
-DEFINE_WRITEBACK_EVENT(writeback_bdi_unregister);
=20
 DECLARE_EVENT_CLASS(wbc_class,
 	TP_PROTO(struct writeback_control *wbc, struct backing_dev_info *bdi),
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 6dc4580df2af..000e7b3b9896 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -359,23 +359,6 @@ static void bdi_wb_shutdown(struct backing_dev_info *b=
di)
 	flush_delayed_work(&bdi->wb.dwork);
 }
=20
-/*
- * Called when the device behind @bdi has been removed or ejected.
- *
- * We can't really do much here except for reducing the dirty ratio at
- * the moment.  In the future we should be able to set a flag so that
- * the filesystem can handle errors at mark_inode_dirty time instead
- * of only at writeback time.
- */
-void bdi_unregister(struct backing_dev_info *bdi)
-{
-	if (WARN_ON_ONCE(!bdi->dev))
-		return;
-
-	bdi_set_min_ratio(bdi, 0);
-}
-EXPORT_SYMBOL(bdi_unregister);
-
 static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info =
*bdi)
 {
 	memset(wb, 0, sizeof(*wb));
@@ -443,6 +426,7 @@ void bdi_destroy(struct backing_dev_info *bdi)
 	int i;
=20
 	bdi_wb_shutdown(bdi);
+	bdi_set_min_ratio(bdi, 0);
=20
 	WARN_ON(!list_empty(&bdi->work_list));
 	WARN_ON(delayed_work_pending(&bdi->wb.dwork));

--Sig_/OfqQ86f0HuessydaDU67vwj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUF4ITnsnt1WYoG5AQLIFw//S0U655G4km69kS3nJHdDHuX5k9fzkeSH
U9jQxbqLClZeyADmKsCe4tHQEovSTYRk+CnZO6LexNaEygcRoC9pFeF+W0gzPIuF
XmjVeoDbjDydRQU1yFW4Qh6JCO5wxHX6iNH1X2pEd7QAgHSg/HWHT8NwbwneKIxK
69hw0RYtqwtwTaCERM3c3zD0zhxl2fJc4A7Sw9b1xEAWJe4ZJlSwDztKV/PbN2Lu
VGDmfL8+SHl+U61fF6EK4h/aNUbPBnK2lJp6c8Gua9BGtvAcWf+sPy8TA9HtkcxX
UTWI1S6z50B7ivalzoYEXERFffFTxaiBQ/mJB8qA7gOlMKLyDniLHYxLeu0QVmxp
yl9twFq/5Sm7zR+7+C8dDaF0XaDT5CPDwPjsHDf/h8BCFgivHW40G78+hu7wCjor
Zmoikb0kgIiDO13KDPSwGv+d01H6xJW3k2OQOiHMuCV/zAzLU+q47LfGOmJATnDu
1d4YPuGoQEfWokErhdBdX8rXD9vu7d0ssnret3zPOS1uDDnVoEVdTfgjO9SDueOA
bYqui/WsP8qfljxVdBkxJmR8PYE0VEpqeYYaeUNdSKJsOAamWC3ymceDLClVrfgx
lp1PyK5EB07GD62Fqhwy20bjInyKk1eeMRui0zit4tsgfE8LXtVAUezeexXjSntA
pk6ssak6WVc=
=zGK1
-----END PGP SIGNATURE-----

--Sig_/OfqQ86f0HuessydaDU67vwj--
