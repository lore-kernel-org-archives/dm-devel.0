From: Stefan Bader <stefan.bader@canonical.com>
Subject: Re: bcache super block corruption with non 4k pages
Date: Thu, 4 Aug 2016 12:03:41 +0200
Message-ID: <87bb3444-23b6-837e-afe5-c670c1a2f572@canonical.com>
References: <1469091513-11233-1-git-send-email-stefan.bader@canonical.com>
 <fce2a0a9-47d1-a052-997c-b14cd62dcf46@canonical.com>
 <20160726102148.GA20130@kmo-pixel>
 <e09788a2-71f4-96ff-cca4-943c1bc1d9bb@canonical.com>
 <20160726124918.GA15102@kmo-pixel>
 <6a0f7c6d-ac26-22cb-9cc7-aeceb34ac2ba@canonical.com>
 <20160728055503.GA3009@kmo-pixel>
 <cf5a7226-60fc-c712-2d0d-940f67b71cdf@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="csx9T4qJhwCNUTmvF2pL5CT7W1g7flfxJ"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cf5a7226-60fc-c712-2d0d-940f67b71cdf@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, liuzhengyuang521@gmail.com, bcache@linux.ewheeler.net, apw@canonical.com, Stefan Bader <stefan.bader@canonical.com>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--csx9T4qJhwCNUTmvF2pL5CT7W1g7flfxJ
Content-Type: multipart/mixed;
 boundary="------------21325C6DF48B034B205C0C13"

This is a multi-part message in MIME format.
--------------21325C6DF48B034B205C0C13
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 28.07.2016 18:27, Stefan Bader wrote:
> On 28.07.2016 07:55, Kent Overstreet wrote:
>> On Wed, Jul 27, 2016 at 05:16:36PM +0200, Stefan Bader wrote:
>>> So here is another attempt which does half the proposed changes. And =
before you
>>> point out that it looks still ugly, let me explain some reasons. The =
goal for me
>>> would be to have something as small as possible to be acceptable as s=
table change.
>>> And the part about putting a bio on the stack and using submit_bio_wa=
it: I
>>> believe you meant in read_super to replace the __bread. I was thinkin=
g about
>>> that but in the end it seemed to make the change unnecessary big. Whe=
ther using
>>> __bread or submit_bio_wait, in both cases and without needing to make=
 more
>>> changes on the write side, read_super has to return the in-memory and=
 on-disk
>>> variant of the superblock. So as long as nothing that is related to _=
_bread is
>>> leaked out of read_super, it is much better than what is there now. A=
nd I remain
>>> as small as possible for the delta.
>>
>> I like that approach much better. I suppose it's not _strictly_ necess=
ary to rip
>> out the __bread()...
>>
>> Only other comment is that you shouldn't have to pass the buffer to
>> __write_super() - I'd just move the bch_bio_map() call to when the str=
uct
>> cache/cached_dev is being initialized (or rip it out and initialize th=
e bvec by
>> hand) and never touch it after that.
>=20
> Hm, doing that would save three simple changes to add a new argument to=
 that
> private functions at the cost of haven the map call twice and a (more)
> complicated calculation of the
>>
>>> So there is one part of the patch which I find hard to do in a better=
 manner but
>>> is a bit ugly: and that is to sanely free the sb_disk_data blob on al=
l error
>>> paths but not on success when it is assigned to either cache or cache=
d_dev.
>>> Could possibly pass the address of the pointer and then clear it insi=
de the
>>> called functions. Not sure that would be much less strange...
>>
>> Yeah that is a hassle - that's why in the 4k superblocks patch in bcac=
he-dev I
>> added that "disk_sb" struct - it owns the buffer and random other crap=
=2E You
>> could read that patch for ideas if you want, look at how it transfers =
ownership
>> of the disk_sb.=20
>>
>=20
> I had a look but it felt like I could get into too much follow-up chang=
es going
> that path. But I think I got it simpler now. One note about that area: =
both
> register calls can run into problems but only one actually returns that=
 status.
> And both do not seem to free the allocated structures (cache or cache_d=
ev). It
> is at least not obvious whether this is ever done.
> I working around this by moving the assignment of the buffer page and t=
he
> mapping to a place where an error exit no longer is possible. So the re=
lease
> functions will only see a non NULL pointer if things went well (reality=
 required
> to revise that a little bit as one of the register calls that can fail =
is
> actually doing the write).
>=20
> So now there is just one oddness: when I am testing this (unfortunately=
 right
> now I only have a normal 4k case), after calling make-bache with cache =
and
> backing device, this all looks great and debugging shows the __write_su=
per being
> called. But reading the from userspace will return the old data until I=
 stop the
> bcache device and unregister the cache (which does not show any further=
 writes).
> I cannot decide what I should think here...

So its __bread doing cached operations and after not (ab)using the page f=
rom
there, the writes will never cause the cached old result to go away until=
 the
device gets closed. So (hopefully) last apptempt. Also drop __bread and u=
se
submit_bio_wait. This seems to work. On x64 and ppc64le with 64k pages.

So the only pain with this is that upstream seems to have re-organized th=
e
submit_bio functions in the upcoming v4.7-rc2 kernel. So it is without re=
work
only applicable to older kernels. I was using a 4.4 one, 4.6 in theory sh=
ould be
ok...

-Stefan


--------------21325C6DF48B034B205C0C13
Content-Type: text/x-diff;
 name="0001-bcache-read_super-handle-architectures-with-more-tha.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-bcache-read_super-handle-architectures-with-more-tha.pa";
 filename*1="tch"

=46rom 91bbee69d19b59ec3a08a2c4e7c92747a23b3956 Mon Sep 17 00:00:00 2001
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
Also get rid of __bread as this is doing cached IO and the only
reason this did not cause weird effects was the direct use of the
page cache page that was returned by __bread.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/md/bcache/bcache.h |  2 ++
 drivers/md/bcache/super.c  | 76 +++++++++++++++++++++++++++++-----------=
------
 2 files changed, 50 insertions(+), 28 deletions(-)

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
index e169739..5a2c848 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -62,17 +62,27 @@ struct workqueue_struct *bcache_wq;
 /* Superblock */
=20
 static const char *read_super(struct cache_sb *sb, struct block_device *=
bdev,
-			      struct page **res)
+			      void *sb_data)
 {
 	const char *err;
 	struct cache_sb *s;
-	struct buffer_head *bh =3D __bread(bdev, 1, SB_SIZE);
+	struct bio rs_bio;
+	struct bio_vec rs_bv[1];
 	unsigned i;
=20
-	if (!bh)
+	bio_init(&rs_bio);
+	rs_bio.bi_bdev			=3D bdev;
+	rs_bio.bi_rw			=3D READ;
+	rs_bio.bi_max_vecs		=3D 1;
+	rs_bio.bi_io_vec		=3D &rs_bv[0];
+	rs_bio.bi_iter.bi_sector	=3D SB_SECTOR;
+	rs_bio.bi_iter.bi_size		=3D SB_SIZE;
+	bch_bio_map(&rs_bio, sb_data);
+
+	if (submit_bio_wait(READ, &rs_bio))
 		return "IO error";
=20
-	s =3D (struct cache_sb *) bh->b_data;
+	s =3D (struct cache_sb *) sb_data;
=20
 	sb->offset		=3D le64_to_cpu(s->offset);
 	sb->version		=3D le64_to_cpu(s->version);
@@ -191,10 +201,7 @@ static const char *read_super(struct cache_sb *sb, s=
truct block_device *bdev,
 	sb->last_mount =3D get_seconds();
 	err =3D NULL;
=20
-	get_page(bh->b_page);
-	*res =3D bh->b_page;
 err:
-	put_bh(bh);
 	return err;
 }
=20
@@ -208,13 +215,13 @@ static void write_bdev_super_endio(struct bio *bio)=

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
@@ -238,7 +245,7 @@ static void __write_super(struct cache_sb *sb, struct=
 bio *bio)
 	pr_debug("ver %llu, flags %llu, seq %llu",
 		 sb->version, sb->flags, sb->seq);
=20
-	submit_bio(REQ_WRITE, bio);
+	submit_bio(WRITE_FLUSH_FUA, bio);
 }
=20
 static void bch_write_bdev_super_unlock(struct closure *cl)
@@ -1045,6 +1052,8 @@ void bch_cached_dev_release(struct kobject *kobj)
 {
 	struct cached_dev *dc =3D container_of(kobj, struct cached_dev,
 					     disk.kobj);
+
+	kfree(dc->sb_disk_data);
 	kfree(dc);
 	module_put(THIS_MODULE);
 }
@@ -1138,7 +1147,7 @@ static int cached_dev_init(struct cached_dev *dc, u=
nsigned block_size)
=20
 /* Cached device - bcache superblock */
=20
-static void register_bdev(struct cache_sb *sb, struct page *sb_page,
+static void register_bdev(struct cache_sb *sb, void *sb_disk_data,
 				 struct block_device *bdev,
 				 struct cached_dev *dc)
 {
@@ -1152,9 +1161,7 @@ static void register_bdev(struct cache_sb *sb, stru=
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
@@ -1168,6 +1175,11 @@ static void register_bdev(struct cache_sb *sb, str=
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
@@ -1179,6 +1191,7 @@ static void register_bdev(struct cache_sb *sb, stru=
ct page *sb_page,
 	return;
 err:
 	pr_notice("error opening %s: %s", bdevname(bdev, name), err);
+	kfree(sb_disk_data);
 	bcache_device_stop(&dc->disk);
 }
=20
@@ -1793,8 +1806,7 @@ void bch_cache_release(struct kobject *kobj)
 	for (i =3D 0; i < RESERVE_NR; i++)
 		free_fifo(&ca->free[i]);
=20
-	if (ca->sb_bio.bi_inline_vecs[0].bv_page)
-		put_page(ca->sb_bio.bi_io_vec[0].bv_page);
+	kfree(ca->sb_disk_data);
=20
 	if (!IS_ERR_OR_NULL(ca->bdev))
 		blkdev_put(ca->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
@@ -1838,7 +1850,7 @@ static int cache_alloc(struct cache_sb *sb, struct =
cache *ca)
 	return 0;
 }
=20
-static int register_cache(struct cache_sb *sb, struct page *sb_page,
+static int register_cache(struct cache_sb *sb, void *sb_disk_data,
 				struct block_device *bdev, struct cache *ca)
 {
 	char name[BDEVNAME_SIZE];
@@ -1851,16 +1863,16 @@ static int register_cache(struct cache_sb *sb, st=
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
@@ -1868,11 +1880,17 @@ static int register_cache(struct cache_sb *sb, st=
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
@@ -1935,13 +1953,14 @@ static ssize_t register_bcache(struct kobject *k,=
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
@@ -1967,7 +1986,7 @@ static ssize_t register_bcache(struct kobject *k, s=
truct kobj_attribute *attr,
 	if (set_blocksize(bdev, 4096))
 		goto err_close;
=20
-	err =3D read_super(sb, bdev, &sb_page);
+	err =3D read_super(sb, bdev, sb_disk_data);
 	if (err)
 		goto err_close;
=20
@@ -1977,19 +1996,20 @@ static ssize_t register_bcache(struct kobject *k,=
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


--------------21325C6DF48B034B205C0C13--

--csx9T4qJhwCNUTmvF2pL5CT7W1g7flfxJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJXoxMFAAoJEOhnXe7L7s6jAzQP/3FIwa4gjBUn8WQ9XRDTp+5n
evb6P9a0he7RFGyeEuJuK1w6uM90+JzkxRFc7ze9TAr5HPs1ySmKjCIuXBNLVNSu
b5lXXRKz/yuQUu6pvQd8tsS8LWIXT11fA92hn9vPx/N9tHAm8XVyllylXpnv7vM9
qdjUr31iP7D2FovWnakOAoXefHhxuNqwo+G5wfpXFsle7IHxiJSUWDaRgjVas0jF
FTwTUcXxqwrTqwttbDALsDPd4KsHc8HsoVKEDZgz4GOcqN0wPTGvxQ9cBQ1WuVuk
3T4v3ljkeQTEViUFLGEI5L9KOmslZPMShT3ry28oDKFACbp88qSGN/8fPyWwmHaO
I3ly5WbKuauvfZjukivLLQ86f8YpOJ2B0L5Eg55fc6rAnswOguQqUMNezUnny/pb
pouVC0epkF7Ck0RP+tQHolcIoCaAKlyiI/QDqRxBefD8FUFpqg1AXXXbHL1eYtMx
AyXU2NVc9pUrUnM6QbmpZH5pEyeKAG1p5MvhXqgHyG2vJ2DmTh+mQjW5ffyUebT5
eXPpbWju9vI2eH45vki/N1p7vhmq0BqlJlkeyyiR37UVvuK+NUZq4qJYPl8Zj7Ag
+Z2Qtp5o6+CLZy0R1p/i9JnFRKYKaFKHgXJKZYiEI4WnxpCMKO6yvpVBm09P16/S
5Ih6BUmdTfY5JRG5QyBf
=j9lz
-----END PGP SIGNATURE-----

--csx9T4qJhwCNUTmvF2pL5CT7W1g7flfxJ--
