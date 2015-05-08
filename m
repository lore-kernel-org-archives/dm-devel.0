From: NeilBrown <neilb@suse.de>
Subject: [PATCH v2] block: discard bdi_unregister() in favour of
 bdi_destroy()
Date: Fri, 8 May 2015 15:09:24 +1000
Message-ID: <20150508150924.33c3bca8@notabene.brown>
References: <20150414171537.GH25394@azat>
	<20150423160551.45345f96@notabene.brown>
	<20150427141222.5dac22f1@notabene.brown>
	<CAMM=eLf2aFFH29xeDVrS7beFj6T8kqUQRh=4KB1YO0kWGa7Rog@mail.gmail.com>
	<20150429072530.39d38b00@notabene.brown>
	<20150429133512.GA4436@lst.de>
	<20150429160258.GK17717@twins.programming.kicks-ass.net>
	<20150430103233.75227693@notabene.brown>
	<CAA9_cmcNfpNAuJbVVbNN-cacVg4Dn-=VroUQ0T-PZz-j69S+iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/DYSlBWqL6QlZFRGZsNqcQpo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcNfpNAuJbVVbNN-cacVg4Dn-=VroUQ0T-PZz-j69S+iQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Dan Williams <dan.j.williams@intel.com>, device-mapper development <dm-devel@redhat.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Azat Khuzhin <a3at.mail@gmail.com>, Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, nicholas.w.moulin@linux.intel.com
List-Id: dm-devel.ids

--Sig_/DYSlBWqL6QlZFRGZsNqcQpo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



bdi_unregister() now contains very little functionality.

It contains a "WARN_ON" if bdi->dev is NULL.  This warning is of no
real consequence as bdi->dev isn't needed by anything else in the function,
and it triggers if
   blk_cleanup_queue() -> bdi_destroy()
is called before bdi_unregister, which happens since
  Commit: 6cd18e711dd8 ("block: destroy bdi before blockdev is unregistered=
.")

So this isn't wanted.

It also calls bdi_set_min_ratio().  This needs to be called after
writes through the bdi have all been flushed, and before the bdi is destroy=
ed.
Calling it early is better than calling it late as it frees up a global
resource.

Calling it immediately after bdi_wb_shutdown() in bdi_destroy()
perfectly fits these requirements.

So bdi_unregister() can be discarded with the important content moved to
bdi_destroy(), as can the
  writeback_bdi_unregister
event which is already not used.

Reported-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org (v4.0)
Fixes: c4db59d31e39 ("fs: don't reassign dirty inodes to default_backing_de=
v_info")
Fixes: 6cd18e711dd8 ("block: destroy bdi before blockdev is unregistered.")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Nicholas Moulin <nicholas.w.moulin@linux.intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>

---

hi Jens,
 this is a revised version of the comment - no code change - make it suitab=
le to add
to your linux-block tree.

Thanks,
NeilBrown


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

--Sig_/DYSlBWqL6QlZFRGZsNqcQpo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUxFBDnsnt1WYoG5AQJAvhAAmM61o0LVwV0XxcwWl6SRC5BJ1cY+7p0o
Clg3P9WDnuSldP/h8Yrr2/6IlFwNvvOc8YKyJvx6QSE3BQ50C4WKcMROomK4uJkB
+yN0sVrO1ZJYq5RmLFW/ukdvSM32pVA3PEqFu3tI34tQcDGeXchL0sN/f2Zu09Sc
u1P4iLNYXHUM+wcGXyP2a6m2lFSRWK8StSXORs3GVLv7EYHEbWSjnzAa+c5zWgJE
OLfvTEfMb0TPupoQMaconf5lvv86A6Yf+w5cUFwHBKw60rcWCT93RuHaA7vffD9w
XsyAPpsfvHHOw0ntspKqBYZMsPue6EfaX/vo4znW6Agck7HBtv9dCedtV35y3aag
4lhlqaYyOF3yEMQB+3xwr/kXhT0E97VUk3yoABVH8ZRAIviEccg/D0BeReqWicTM
eUkWBoR8OWqswxFtYGmPVMKxAVSRdP2ixkYYj1V09ORkQ8//iBsmJt0OE4iZVVFj
yOFIx4Lnv+sSHpJspEM6MjqpMJuPsivnqlln01vN6DeM5tsCsADntycdDU+ytFgj
k+7o91RNZvWlJJwlJpKLAor2IVmCcVCGmfVsPPtTQcSjSZybwB4HI4Y9tq7fyfy6
GHmqccVhnJExhCyu++Zpf/hnH1Q2V+JQv25E6lcCZcH7VHVWQ94dWSCJnQ7EJI9c
4McCAPOiUSo=
=uTUf
-----END PGP SIGNATURE-----

--Sig_/DYSlBWqL6QlZFRGZsNqcQpo--
