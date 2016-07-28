From: Stefan Bader <stefan.bader@canonical.com>
Subject: Re: bcache super block corruption with non 4k pages
Date: Thu, 28 Jul 2016 18:27:29 +0200
Message-ID: <cf5a7226-60fc-c712-2d0d-940f67b71cdf@canonical.com>
References: <1469091513-11233-1-git-send-email-stefan.bader@canonical.com>
 <fce2a0a9-47d1-a052-997c-b14cd62dcf46@canonical.com>
 <20160726102148.GA20130@kmo-pixel>
 <e09788a2-71f4-96ff-cca4-943c1bc1d9bb@canonical.com>
 <20160726124918.GA15102@kmo-pixel>
 <6a0f7c6d-ac26-22cb-9cc7-aeceb34ac2ba@canonical.com>
 <20160728055503.GA3009@kmo-pixel>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="9Fc7hc8wc23H63eJacxljoODBJqvqGX2h"
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20160728055503.GA3009@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, liuzhengyuang521@gmail.com, bcache@linux.ewheeler.net, apw@canonical.com, Stefan Bader <stefan.bader@canonical.com>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9Fc7hc8wc23H63eJacxljoODBJqvqGX2h
Content-Type: multipart/mixed;
 boundary="------------8CECECA717979EA72CFA12F1"

This is a multi-part message in MIME format.
--------------8CECECA717979EA72CFA12F1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 28.07.2016 07:55, Kent Overstreet wrote:
> On Wed, Jul 27, 2016 at 05:16:36PM +0200, Stefan Bader wrote:
>> So here is another attempt which does half the proposed changes. And b=
efore you
>> point out that it looks still ugly, let me explain some reasons. The g=
oal for me
>> would be to have something as small as possible to be acceptable as st=
able change.
>> And the part about putting a bio on the stack and using submit_bio_wai=
t: I
>> believe you meant in read_super to replace the __bread. I was thinking=
 about
>> that but in the end it seemed to make the change unnecessary big. Whet=
her using
>> __bread or submit_bio_wait, in both cases and without needing to make =
more
>> changes on the write side, read_super has to return the in-memory and =
on-disk
>> variant of the superblock. So as long as nothing that is related to __=
bread is
>> leaked out of read_super, it is much better than what is there now. An=
d I remain
>> as small as possible for the delta.
>=20
> I like that approach much better. I suppose it's not _strictly_ necessa=
ry to rip
> out the __bread()...
>=20
> Only other comment is that you shouldn't have to pass the buffer to
> __write_super() - I'd just move the bch_bio_map() call to when the stru=
ct
> cache/cached_dev is being initialized (or rip it out and initialize the=
 bvec by
> hand) and never touch it after that.

Hm, doing that would save three simple changes to add a new argument to t=
hat
private functions at the cost of haven the map call twice and a (more)
complicated calculation of the
>=20
>> So there is one part of the patch which I find hard to do in a better =
manner but
>> is a bit ugly: and that is to sanely free the sb_disk_data blob on all=
 error
>> paths but not on success when it is assigned to either cache or cached=
_dev.
>> Could possibly pass the address of the pointer and then clear it insid=
e the
>> called functions. Not sure that would be much less strange...
>=20
> Yeah that is a hassle - that's why in the 4k superblocks patch in bcach=
e-dev I
> added that "disk_sb" struct - it owns the buffer and random other crap.=
 You
> could read that patch for ideas if you want, look at how it transfers o=
wnership
> of the disk_sb.=20
>=20

I had a look but it felt like I could get into too much follow-up changes=
 going
that path. But I think I got it simpler now. One note about that area: bo=
th
register calls can run into problems but only one actually returns that s=
tatus.
And both do not seem to free the allocated structures (cache or cache_dev=
). It
is at least not obvious whether this is ever done.
I working around this by moving the assignment of the buffer page and the=

mapping to a place where an error exit no longer is possible. So the rele=
ase
functions will only see a non NULL pointer if things went well (reality r=
equired
to revise that a little bit as one of the register calls that can fail is=

actually doing the write).

So now there is just one oddness: when I am testing this (unfortunately r=
ight
now I only have a normal 4k case), after calling make-bache with cache an=
d
backing device, this all looks great and debugging shows the __write_supe=
r being
called. But reading the from userspace will return the old data until I s=
top the
bcache device and unregister the cache (which does not show any further w=
rites).
I cannot decide what I should think here...

-Stefan


--------------8CECECA717979EA72CFA12F1
Content-Type: text/x-diff;
 name="0001-bcache-read_super-handle-architectures-with-more-tha.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-bcache-read_super-handle-architectures-with-more-tha.pa";
 filename*1="tch"

=46rom 982a4ff25d4dbd114432b4b2f908182995f402a0 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Tue, 26 Jul 2016 18:47:21 +0200
Subject: [PATCH] bcache: read_super: handle architectures with more than =
4k
 page size

There is no guarantee that the superblock which __bread returns in
a buffer_head starts at offset 0 when an architecture has bigger
pages than 4k (the used sector size).

This is the attempt to fix this with the minimum amount of change
by having a buffer allocated with kmalloc that holds the superblock
data as it is on disk.
This buffer can then be passed to bch_map_bio which will set up the
bio_vec correctly.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/md/bcache/bcache.h |  2 ++
 drivers/md/bcache/super.c  | 58 ++++++++++++++++++++++++++++------------=
------
 2 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 6b420a5..3c48927 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -295,6 +295,7 @@ struct cached_dev {
 	struct cache_sb		sb;
 	struct bio		sb_bio;
 	struct bio_vec		sb_bv[1];
+	void			*sb_disk_data;
 	struct closure		sb_write;
 	struct semaphore	sb_write_mutex;
=20
@@ -382,6 +383,7 @@ struct cache {
 	struct cache_sb		sb;
 	struct bio		sb_bio;
 	struct bio_vec		sb_bv[1];
+	void			*sb_disk_data;
=20
 	struct kobject		kobj;
 	struct block_device	*bdev;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e169739..14f3304 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -62,7 +62,7 @@ struct workqueue_struct *bcache_wq;
 /* Superblock */
=20
 static const char *read_super(struct cache_sb *sb, struct block_device *=
bdev,
-			      struct page **res)
+			      void *sb_data)
 {
 	const char *err;
 	struct cache_sb *s;
@@ -191,8 +191,7 @@ static const char *read_super(struct cache_sb *sb, st=
ruct block_device *bdev,
 	sb->last_mount =3D get_seconds();
 	err =3D NULL;
=20
-	get_page(bh->b_page);
-	*res =3D bh->b_page;
+	memcpy(sb_data, bh->b_data, SB_SIZE);
 err:
 	put_bh(bh);
 	return err;
@@ -208,13 +207,13 @@ static void write_bdev_super_endio(struct bio *bio)=

=20
 static void __write_super(struct cache_sb *sb, struct bio *bio)
 {
-	struct cache_sb *out =3D page_address(bio->bi_io_vec[0].bv_page);
+	struct cache_sb *out =3D page_address(bio->bi_io_vec[0].bv_page) +
+			       bio->bi_io_vec[0].bv_offset;
 	unsigned i;
=20
 	bio->bi_iter.bi_sector	=3D SB_SECTOR;
 	bio->bi_rw		=3D REQ_SYNC|REQ_META;
 	bio->bi_iter.bi_size	=3D SB_SIZE;
-	bch_bio_map(bio, NULL);
=20
 	out->offset		=3D cpu_to_le64(sb->offset);
 	out->version		=3D cpu_to_le64(sb->version);
@@ -1045,6 +1044,8 @@ void bch_cached_dev_release(struct kobject *kobj)
 {
 	struct cached_dev *dc =3D container_of(kobj, struct cached_dev,
 					     disk.kobj);
+
+	kfree(dc->sb_disk_data);
 	kfree(dc);
 	module_put(THIS_MODULE);
 }
@@ -1138,7 +1139,7 @@ static int cached_dev_init(struct cached_dev *dc, u=
nsigned block_size)
=20
 /* Cached device - bcache superblock */
=20
-static void register_bdev(struct cache_sb *sb, struct page *sb_page,
+static void register_bdev(struct cache_sb *sb, void *sb_disk_data,
 				 struct block_device *bdev,
 				 struct cached_dev *dc)
 {
@@ -1152,9 +1153,7 @@ static void register_bdev(struct cache_sb *sb, stru=
ct page *sb_page,
=20
 	bio_init(&dc->sb_bio);
 	dc->sb_bio.bi_max_vecs	=3D 1;
-	dc->sb_bio.bi_io_vec	=3D dc->sb_bio.bi_inline_vecs;
-	dc->sb_bio.bi_io_vec[0].bv_page =3D sb_page;
-	get_page(sb_page);
+	dc->sb_bio.bi_io_vec	=3D &dc->sb_bv[0];
=20
 	if (cached_dev_init(dc, sb->block_size << 9))
 		goto err;
@@ -1168,6 +1167,11 @@ static void register_bdev(struct cache_sb *sb, str=
uct page *sb_page,
=20
 	pr_info("registered backing device %s", bdevname(bdev, name));
=20
+	/* Do assignment and mapping late, cannot error after this */
+	dc->sb_disk_data =3D sb_disk_data;
+	dc->sb_bio.bi_iter.bi_size =3D SB_SIZE;
+	bch_bio_map(&dc->sb_bio, sb_disk_data);
+
 	list_add(&dc->list, &uncached_devices);
 	list_for_each_entry(c, &bch_cache_sets, list)
 		bch_cached_dev_attach(dc, c);
@@ -1179,6 +1183,7 @@ static void register_bdev(struct cache_sb *sb, stru=
ct page *sb_page,
 	return;
 err:
 	pr_notice("error opening %s: %s", bdevname(bdev, name), err);
+	kfree(sb_disk_data);
 	bcache_device_stop(&dc->disk);
 }
=20
@@ -1793,8 +1798,7 @@ void bch_cache_release(struct kobject *kobj)
 	for (i =3D 0; i < RESERVE_NR; i++)
 		free_fifo(&ca->free[i]);
=20
-	if (ca->sb_bio.bi_inline_vecs[0].bv_page)
-		put_page(ca->sb_bio.bi_io_vec[0].bv_page);
+	kfree(ca->sb_disk_data);
=20
 	if (!IS_ERR_OR_NULL(ca->bdev))
 		blkdev_put(ca->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
@@ -1838,7 +1842,7 @@ static int cache_alloc(struct cache_sb *sb, struct =
cache *ca)
 	return 0;
 }
=20
-static int register_cache(struct cache_sb *sb, struct page *sb_page,
+static int register_cache(struct cache_sb *sb, void *sb_disk_data,
 				struct block_device *bdev, struct cache *ca)
 {
 	char name[BDEVNAME_SIZE];
@@ -1851,16 +1855,16 @@ static int register_cache(struct cache_sb *sb, st=
ruct page *sb_page,
=20
 	bio_init(&ca->sb_bio);
 	ca->sb_bio.bi_max_vecs	=3D 1;
-	ca->sb_bio.bi_io_vec	=3D ca->sb_bio.bi_inline_vecs;
-	ca->sb_bio.bi_io_vec[0].bv_page =3D sb_page;
-	get_page(sb_page);
+	ca->sb_bio.bi_io_vec	=3D &ca->sb_bv[0];
=20
 	if (blk_queue_discard(bdev_get_queue(ca->bdev)))
 		ca->discard =3D CACHE_DISCARD(&ca->sb);
=20
 	ret =3D cache_alloc(sb, ca);
-	if (ret !=3D 0)
+	if (ret !=3D 0) {
+		err =3D "error calling cache_alloc";
 		goto err;
+	}
=20
 	if (kobject_add(&ca->kobj, &part_to_dev(bdev->bd_part)->kobj, "bcache")=
) {
 		err =3D "error calling kobject_add";
@@ -1868,11 +1872,17 @@ static int register_cache(struct cache_sb *sb, st=
ruct page *sb_page,
 		goto out;
 	}
=20
+	/* Do assignment and mapping late */
+	ca->sb_disk_data =3D sb_disk_data;
+	ca->sb_bio.bi_iter.bi_size =3D SB_SIZE;
+	bch_bio_map(&ca->sb_bio, sb_disk_data);
+
 	mutex_lock(&bch_register_lock);
 	err =3D register_cache_set(ca);
 	mutex_unlock(&bch_register_lock);
=20
 	if (err) {
+		ca->sb_disk_data =3D NULL;
 		ret =3D -ENODEV;
 		goto out;
 	}
@@ -1935,13 +1945,14 @@ static ssize_t register_bcache(struct kobject *k,=
 struct kobj_attribute *attr,
 	char *path =3D NULL;
 	struct cache_sb *sb =3D NULL;
 	struct block_device *bdev =3D NULL;
-	struct page *sb_page =3D NULL;
+	void *sb_disk_data =3D NULL;
=20
 	if (!try_module_get(THIS_MODULE))
 		return -EBUSY;
=20
 	if (!(path =3D kstrndup(buffer, size, GFP_KERNEL)) ||
-	    !(sb =3D kmalloc(sizeof(struct cache_sb), GFP_KERNEL)))
+	    !(sb =3D kmalloc(sizeof(struct cache_sb), GFP_KERNEL)) ||
+	    !(sb_disk_data =3D kmalloc(SB_SIZE, GFP_KERNEL)))
 		goto err;
=20
 	err =3D "failed to open device";
@@ -1967,7 +1978,7 @@ static ssize_t register_bcache(struct kobject *k, s=
truct kobj_attribute *attr,
 	if (set_blocksize(bdev, 4096))
 		goto err_close;
=20
-	err =3D read_super(sb, bdev, &sb_page);
+	err =3D read_super(sb, bdev, sb_disk_data);
 	if (err)
 		goto err_close;
=20
@@ -1977,19 +1988,20 @@ static ssize_t register_bcache(struct kobject *k,=
 struct kobj_attribute *attr,
 			goto err_close;
=20
 		mutex_lock(&bch_register_lock);
-		register_bdev(sb, sb_page, bdev, dc);
+		register_bdev(sb, sb_disk_data, bdev, dc);
+		sb_disk_data =3D NULL; /* Consumed or freed in register call */
 		mutex_unlock(&bch_register_lock);
 	} else {
 		struct cache *ca =3D kzalloc(sizeof(*ca), GFP_KERNEL);
 		if (!ca)
 			goto err_close;
=20
-		if (register_cache(sb, sb_page, bdev, ca) !=3D 0)
+		if (register_cache(sb, sb_disk_data, bdev, ca) !=3D 0)
 			goto err_close;
+		sb_disk_data =3D NULL;
 	}
 out:
-	if (sb_page)
-		put_page(sb_page);
+	kfree(sb_disk_data);
 	kfree(sb);
 	kfree(path);
 	module_put(THIS_MODULE);
--=20
1.9.1


--------------8CECECA717979EA72CFA12F1--

--9Fc7hc8wc23H63eJacxljoODBJqvqGX2h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJXmjJ5AAoJEOhnXe7L7s6jVq8P/0LDvtQCGtfLKR8W7yIZQ/iA
szJkz6Vtd8kxyaTb/mBdyqb2aHXVO8VeHwaIWv3K59P6r9MIkKLgAJAaPwhy33AM
LavSpsTkrK3XkVpSTZPvFCL4CBWPc+ip1EgwYgc5Ha4Kmmqm1UipTDUQA7YpPiRN
JjbqQahQJvrwkn59TgIBvCGNwu7GEFvdQAewj492ZO9iUPGeih/4Mi03kCR4xnqu
1Gh3E49TnlC6ii+EZYv0YDVorNqj6OKNYAeTs0KuvsK0DAGpnsrVDwIOjqD+lXLX
2q++fBNO8mq70xX4rzzPUNkfpvdXYeWps47TwjbC5Jd3XBF/Ly7u5DJlkgcOSP1/
7RNRKsY4+N2TuQcMfrPlgKU3JotlOZlgJmFV+EOK6VLL6YoBPvwDOyCggEAuRn5A
ss7+1QJ0P5J8qRpyk8OoxpQhdqVTp/kikLI0ZxRot25FNyBrJbZCSRjEB9KManS6
kmkCMfCVeBcURy/5MdArS3Br1+DJUKSKCiBWKnE/sfM/CPDW07bu99tMP96J3rlP
J+0bofepC+N3iLwtgjKgOpfYyyYqzCmd/X7pcOsV+RV3gk+Eb2s831umzzGsmiHm
wdR31qn1FjAmebgCXYcHM3coYDMIrHvJGcDDzXCK8PduR5JoE097VQ8amn5QrlVa
KfzFyo82WyXbgMmDvwE0
=dgCk
-----END PGP SIGNATURE-----

--9Fc7hc8wc23H63eJacxljoODBJqvqGX2h--
