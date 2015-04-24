From: NeilBrown <neilb@suse.de>
Subject: Re: Bisected, with rfc/patch - was Re: BUG: unable to handle kernel
 NULL pointer dereference at sysfs_do_create_link_sd (after mdadm)
Date: Fri, 24 Apr 2015 12:09:32 +1000
Message-ID: <20150424120932.3d554638@notabene.brown>
References: <20150414171537.GH25394@azat>
	<20150423160551.45345f96@notabene.brown>
	<20150423073724.GA8139@lst.de>
	<20150423180314.367c0876@notabene.brown>
	<20150423161051.GA18971@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/sLtWkV/_GAuEMuL5BLNo.xk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150423161051.GA18971@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Azat Khuzhin <a3at.mail@gmail.com>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--Sig_/sLtWkV/_GAuEMuL5BLNo.xk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Apr 2015 18:10:51 +0200 Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Apr 23, 2015 at 06:03:14PM +1000, NeilBrown wrote:
> > On Thu, 23 Apr 2015 09:37:24 +0200 Christoph Hellwig <hch@lst.de> wrote:
> >=20
> > > Plase fix your device name lifetimes.
> >=20
> > Any chance you could be more explicit?
> >
> > The commit you identified doesn't seem to help much - md and dm are qui=
te
> > different in this area.
> >=20
> > It seems that it is no longer safe to call 'add_disk' between calling
> > 'del_gendisk' and bdi_destroy being called.  How can I find out if I am=
 in
> > that window, or wait for bdi_destroy to be called?
>=20
> The bdi is only around if the device is open, either through a device
> node, or through a blkdev_get from a file system.  If you get duplicate
> names that means you're trying to allocate a new gendisk while the old
> one is still around.
>=20
> In theory you're fine once the device gets ->release called.

In practice .... the put_disk() shortly after the ->release call in
__blkdev_put() is what ultimately releases the name of the bdi - at least in
the cases where I get a crash.

>=20
> Except that we can hold sysfs reference to the qeue, eww.  So for now
> try to follow the dm model, but I'll need to add a callback to the
> queue called once the request_queue actually is released for this.

I'm pretty sure that the md code is already as close to the "dm model" as it
meaningfully can be.

If I move bdi_destroy out of blk_release_queue (which really think is too
later) and place it in blk_cleanup_queue (which seems a credible place for
it), and then move the blk_cleanup_queue call in md_free up before the
del_gendisk() call (which is probably the right thing to do anyway, though =
dm
has the same order that md currently has) then I don't get any crashes and
I'm almost convince it is correct...

Thoughts?

Thanks,
NeilBrown


diff --git a/block/blk-core.c b/block/blk-core.c
index 794c3e7f01cf..66406474f0c4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -552,6 +552,8 @@ void blk_cleanup_queue(struct request_queue *q)
 		q->queue_lock =3D &q->__queue_lock;
 	spin_unlock_irq(lock);
=20
+	bdi_destroy(&q->backing_dev_info);
+
 	/* @q is and will stay empty, shutdown and put */
 	blk_put_queue(q);
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index faaf36ade7eb..2b8fd302f677 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -522,8 +522,6 @@ static void blk_release_queue(struct kobject *kobj)
=20
 	blk_trace_shutdown(q);
=20
-	bdi_destroy(&q->backing_dev_info);
-
 	ida_simple_remove(&blk_queue_ida, q->id);
 	call_rcu(&q->rcu_head, blk_free_queue_rcu);
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d4f31e195e26..593a02476c78 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4818,12 +4818,12 @@ static void md_free(struct kobject *ko)
 	if (mddev->sysfs_state)
 		sysfs_put(mddev->sysfs_state);
=20
+	if (mddev->queue)
+		blk_cleanup_queue(mddev->queue);
 	if (mddev->gendisk) {
 		del_gendisk(mddev->gendisk);
 		put_disk(mddev->gendisk);
 	}
-	if (mddev->queue)
-		blk_cleanup_queue(mddev->queue);
=20
 	kfree(mddev);
 }

--Sig_/sLtWkV/_GAuEMuL5BLNo.xk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTml3Dnsnt1WYoG5AQKPShAAsMGGNf1xkm78Xxo8C7Ccmnl2BAwDzmLW
tDqnCV3p9Qp2wwN/yJ40NZcfJDNtxC9zv9br5Fsw8ms8vFEqizKse37NtK3HF6aA
9AHwKKEfBq0N37RCnWfGpjU7aiCjRRHatx8sDtTrUBmvKTCLf2Kp1FkIUulHYmx8
O9RbNwU7q8fZ1oKU4VzLrKuZtx+xB5h8SZVw0YjlFRFnicuqZgLk0xkQvt7i0Z/4
0DZO2C3jb6bUSOaset0RYccr/X53/PGQtEuWtpy1GrjcbA/rkffyNG2Y7nFEiHQV
vf8dPyVmmJZsFd9mxFOm5OFKe8xnn8ug7lcZS3eF03JwGgFXUJZxLUiXyYaMPk5j
7UVbAonfBtR1yi83f2QLrOrq7OJKHuaLe3PjVaqm3I5R+JixljtxqHo8ABqvkOU/
BgFlpLAwUFQooV9uUR4s6XhiiwNgdMp7VHmi2nBuqqpcZp3MOL0mJNDplYjFPEML
1lz8nT7RSyEgSCdxQqWl1zSdPBGEBQcb4FSUsJgxJo4oBfRoFt0nQoG6hyOfU4oi
Zj0th9rjb6MaF3QF1vfewA/mvD72CODJW4KtaCqvINQhbDcAVBqhv8SRzvLDf8Zm
QX4wEC4DrjXrLtcwVwBNbUBoea/Esibjh0ibEgVS6A7t5bfWWqQXZ8omLJX2mkf4
cV0hgqh+CYg=
=j4Zn
-----END PGP SIGNATURE-----

--Sig_/sLtWkV/_GAuEMuL5BLNo.xk--
