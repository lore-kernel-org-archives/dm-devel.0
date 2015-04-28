From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH -stable] block: destroy bdi before blockdev is
 unregistered.
Date: Wed, 29 Apr 2015 07:25:30 +1000
Message-ID: <20150429072530.39d38b00@notabene.brown>
References: <20150414171537.GH25394@azat>
	<20150423160551.45345f96@notabene.brown>
	<20150427141222.5dac22f1@notabene.brown>
	<CAMM=eLf2aFFH29xeDVrS7beFj6T8kqUQRh=4KB1YO0kWGa7Rog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/a/y=o1PKzbldPLSytCnnabX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMM=eLf2aFFH29xeDVrS7beFj6T8kqUQRh=4KB1YO0kWGa7Rog@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, Azat Khuzhin <a3at.mail@gmail.com>, Christoph Hellwig <hch@lst.de>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--Sig_/a/y=o1PKzbldPLSytCnnabX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Apr 2015 12:41:18 -0400 Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Apr 27, 2015 at 12:12 AM, NeilBrown <neilb@suse.de> wrote:
> >
> > Because of the peculiar way that md devices are created (automatically
> > when the device node is opened), a new device can be created and
> > registered immediately after the
> >         blk_unregister_region(disk_devt(disk), disk->minors);
> > call in del_gendisk().
> >
> > Therefore it is important that all visible artifacts of the previous
> > device are removed before this call.  In particular, the 'bdi'.
> >
> > Since:
> > commit c4db59d31e39ea067c32163ac961e9c80198fd37
> > Author: Christoph Hellwig <hch@lst.de>
> >     fs: don't reassign dirty inodes to default_backing_dev_info
> >
> > moved the
> >    device_unregister(bdi->dev);
> > call from bdi_unregister() to bdi_destroy() it has been quite easy to
> > lose a race and have a new (e.g.) "md127" be created after the
> > blk_unregister_region() call and before bdi_destroy() is ultimately
> > called by the final 'put_disk', which must come after del_gendisk().
> >
> > The new device finds that the bdi name is already registered in sysfs
> > and complains
> >
> >> [ 9627.630029] WARNING: CPU: 18 PID: 3330 at fs/sysfs/dir.c:31 sysfs_w=
arn_dup+0x5a/0x70()
> >> [ 9627.630032] sysfs: cannot create duplicate filename '/devices/virtu=
al/bdi/9:127'
> >
> > We can fix this by moving the bdi_destroy() call out of
> > blk_release_queue() (which can happen very late when a refcount
> > reaches zero) and into blk_cleanup_queue() - which happens exactly when=
 the md
> > device driver calls it.
> >
> > Then it is only necessary for md to call blk_cleanup_queue() before
> > del_gendisk().  As loop.c devices are also created on demand by
> > opening the device node, we make the same change there.
> >
> > Fixes: c4db59d31e39ea067c32163ac961e9c80198fd37
> > Reported-by: Azat Khuzhin <a3at.mail@gmail.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: stable@vger.kernel.org (v4.0)
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >
> > --
> > Hi Jens,
> >  if you could check this and forward on to Linus I'd really appreciate =
it.
> >
> > Thanks,
> > NeilBrown
> >
> >
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index fd154b94447a..7871603f0a29 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -552,6 +552,8 @@ void blk_cleanup_queue(struct request_queue *q)
> >                 q->queue_lock =3D &q->__queue_lock;
> >         spin_unlock_irq(lock);
> >
> > +       bdi_destroy(&q->backing_dev_info);
> > +
> >         /* @q is and will stay empty, shutdown and put */
> >         blk_put_queue(q);
> >  }
> > diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> > index faaf36ade7eb..2b8fd302f677 100644
> > --- a/block/blk-sysfs.c
> > +++ b/block/blk-sysfs.c
> > @@ -522,8 +522,6 @@ static void blk_release_queue(struct kobject *kobj)
> >
> >         blk_trace_shutdown(q);
> >
> > -       bdi_destroy(&q->backing_dev_info);
> > -
> >         ida_simple_remove(&blk_queue_ida, q->id);
> >         call_rcu(&q->rcu_head, blk_free_queue_rcu);
> >  }
> > diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> > index ae3fcb4199e9..d7173cb1ea76 100644
> > --- a/drivers/block/loop.c
> > +++ b/drivers/block/loop.c
> > @@ -1620,8 +1620,8 @@ out:
> >
> >  static void loop_remove(struct loop_device *lo)
> >  {
> > -       del_gendisk(lo->lo_disk);
> >         blk_cleanup_queue(lo->lo_queue);
> > +       del_gendisk(lo->lo_disk);
> >         blk_mq_free_tag_set(&lo->tag_set);
> >         put_disk(lo->lo_disk);
> >         kfree(lo);
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index d4f31e195e26..593a02476c78 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -4818,12 +4818,12 @@ static void md_free(struct kobject *ko)
> >         if (mddev->sysfs_state)
> >                 sysfs_put(mddev->sysfs_state);
> >
> > +       if (mddev->queue)
> > +               blk_cleanup_queue(mddev->queue);
> >         if (mddev->gendisk) {
> >                 del_gendisk(mddev->gendisk);
> >                 put_disk(mddev->gendisk);
> >         }
> > -       if (mddev->queue)
> > -               blk_cleanup_queue(mddev->queue);
> >
> >         kfree(mddev);
> >  }
>=20
> I've taken this patch into consideration relative to DM, please see:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=
=3Dwip&id=3D5dac86fb79697e93297edb6a316b429236d00137
>=20
> Point is in my private snitzer/wip branch DM now calls
> blk_cleanup_queue() before del_gendisk().
>=20
> With your patch:
> 1) blk_cleanup_queue -> bdi_destroy -> bdi->dev =3D NULL;
> 2) del_gendisk -> bdi_unregister -> WARN_ON_ONCE(!bdi->dev)
>=20
> So, in testing with DM I'm hitting bdi_unregister's WARN_ON(), are you
> seeing this WARN_ON?

Hmmm.  Yes I am.  I wonder how I missed that.  Thanks!

As bdi_set_min_ratio doesn't touch bdi->dev, there seems to be no need for
the test, or the warning.

I wonder if it would make sense to move the bdi_set_min_ratio() call to
bdi_destroy, and discard bdi_unregister??
There is a comment which suggests bdi_unregister might be of use later, but
it might be best to have a clean slate in which to add whatever might be
needed??

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

--Sig_/a/y=o1PKzbldPLSytCnnabX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVT/6yznsnt1WYoG5AQJz9Q/9GlKTZ1e3UXcDuQ8Sh2wC9nYbDSvE4pKP
0UEMZs8A/Vs9SGPsztRwBlc3voXEZZPxul4Tkp4NVAz0saHER6PVw+Lit+i3am2x
jEgQDh/NX2agzxxAps9lihsGpIM3ueO3C1updmR4VR9eAVZ6eVgXXa26M6HL6zoG
nXmOasCw6hN4pWZZYZduw9gRXNXwgI6+JKZAo7mJbv3sxooMrAS+JlCDYOoP36GW
NYy61w4dCmPPVXMQW4IbUgCVwfL/30mUJiBHlx5iRIfG8gn2v/kqLUZsBTIw/t7w
H569vT5Tl5Z3Z03nsxbJo+cMSBJV42Zc9j2yB5WTir6OPRTW3gz2B1yBaUUPWWb2
oLfrxlf2Ci2JBkL0MJVgQK/WCTBY2MB2OSy78oPy/3fBgQIDODw/n/AryFgGpuOc
uFNY6/3jcMSD8Zx/0pwSuCveSkzHBZuuy9qD8R7L0xa1yQwwsreZZfzonWtjHCo0
017a41a+CX3KNhccx3IaezS5wOHF4b7Deqtg/Dt7CUSkPchuH4K144t+V3Dzg2Ny
dT+nGYmtTYnnZt90IezEuhxyHSf1Vz6ArBiLrCnzAa8wVevLUPyaTkaaFwBbr8y2
EECADzrqpK0PxgL2bz2/fcsrVFHcqsZH2TBEsFSscgNrQtI1/h1CbRM/pYdL/ZnY
YxDdQOdRrvs=
=6SHG
-----END PGP SIGNATURE-----

--Sig_/a/y=o1PKzbldPLSytCnnabX--
