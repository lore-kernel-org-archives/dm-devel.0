From: Stefan Bader <stefan.bader@canonical.com>
Subject: Re: bcache super block corruption with non 4k pages
Date: Wed, 27 Jul 2016 17:16:36 +0200
Message-ID: <6a0f7c6d-ac26-22cb-9cc7-aeceb34ac2ba@canonical.com>
References: <1469091513-11233-1-git-send-email-stefan.bader@canonical.com>
 <fce2a0a9-47d1-a052-997c-b14cd62dcf46@canonical.com>
 <20160726102148.GA20130@kmo-pixel>
 <e09788a2-71f4-96ff-cca4-943c1bc1d9bb@canonical.com>
 <20160726124918.GA15102@kmo-pixel>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="tU3lrUJ1ev9bEWpAct5tx1AhTH2fRdqqS"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160726124918.GA15102@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, liuzhengyuang521@gmail.com, bcache@linux.ewheeler.net, apw@canonical.com, Stefan Bader <stefan.bader@canonical.com>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tU3lrUJ1ev9bEWpAct5tx1AhTH2fRdqqS
Content-Type: multipart/mixed;
 boundary="------------5B8528B42B133023112A1CEC"

This is a multi-part message in MIME format.
--------------5B8528B42B133023112A1CEC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 26.07.2016 14:49, Kent Overstreet wrote:
> On Tue, Jul 26, 2016 at 02:32:31PM +0200, Stefan Bader wrote:
>> On 26.07.2016 12:21, Kent Overstreet wrote:
>>> On Tue, Jul 26, 2016 at 11:51:25AM +0200, Stefan Bader wrote:
>>>> On 21.07.2016 10:58, Stefan Bader wrote:
>>>>> I was pointed at the thread which seems to address the same after
>>>>> I wrote most of below text. Did not want to re-write this so please=

>>>>> bear with the odd layout.
>>>>>
>>>>> https://www.redhat.com/archives/dm-devel/2016-June/msg00015.html
>>>>>
>>>>> Zhengyuan tries to fix the problem by relocating the superblock on
>>>>> disk. But I am not sure whether there is really any guarantee about=

>>>>> how __bread fills data into the buffer_head. What if there is the n=
ext
>>>>> odd arch with 128K pages?
>>>>>
>>>>> So below is an attempt to be more generic. Still I don't feel compl=
etely
>>>>> happy with the way that a page moves (or is shared) between buffer_=
head
>>>>> and biovec. What I tried to outline below is to let the register fu=
nctions
>>>>> allocate bio+biovec memory and use the in-memory sb_cache data to i=
nitialize
>>>>> the biovec buffer.
>>>>
>>>> Any opinions here? Also adding LKML as I don't seem to get through m=
oderation on
>>>> dm-devel.
>>>
>>> The correct solution is to rip out the __bread() and just read the su=
perblock by
>>> issuing a bio, the same way all the other IO in bcache is done.
>>>
>>> This is the way it's done in the bcache-dev branch - unfortunately, t=
he patch
>>> that does that in bcache-dev is big and invasive and probably not wor=
th the
>>> hassle to backport:
>>>
>>> https://evilpiepirate.org/git/linux-bcache.git/commit/?h=3Dbcache-dev=
&id=3D303eb67bffad57b4d9e71523e7df04bf258e66d1
>>
>> I agree that this looks better and also rather large.
>>>
>>> Probably best to just do something small and localized.
>>>
>> So what did you think about the change I did? It seemed to be ok for 4=
K and 64K
>> at least and is rather small. And I believe that, compared to Zhengyua=
n's
>> approach this would have the benefit of not changing the superblock se=
ctor. So
>> it would be compatible with previously created superblocks.
>=20
> Too ugly to live. Just kmalloc() 4k, allocate a bio on the stack, set i=
t up, and
> submit it with submit_bio_wait(). Use virt_to_page(), don't bother with=
 raw
> pages - you want 4k, not whatever the page size is.
>=20

So here is another attempt which does half the proposed changes. And befo=
re you
point out that it looks still ugly, let me explain some reasons. The goal=
 for me
would be to have something as small as possible to be acceptable as stabl=
e change.
And the part about putting a bio on the stack and using submit_bio_wait: =
I
believe you meant in read_super to replace the __bread. I was thinking ab=
out
that but in the end it seemed to make the change unnecessary big. Whether=
 using
__bread or submit_bio_wait, in both cases and without needing to make mor=
e
changes on the write side, read_super has to return the in-memory and on-=
disk
variant of the superblock. So as long as nothing that is related to __bre=
ad is
leaked out of read_super, it is much better than what is there now. And I=
 remain
as small as possible for the delta.

So there is one part of the patch which I find hard to do in a better man=
ner but
is a bit ugly: and that is to sanely free the sb_disk_data blob on all er=
ror
paths but not on success when it is assigned to either cache or cached_de=
v.
Could possibly pass the address of the pointer and then clear it inside t=
he
called functions. Not sure that would be much less strange...


-Stefan



--------------5B8528B42B133023112A1CEC
Content-Type: text/x-diff;
 name="0001-bcache-read_super-handle-architectures-with-more-tha.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-bcache-read_super-handle-architectures-with-more-tha.pa";
 filename*1="tch"

=46rom 391682e2329a6f8608bfc7628b6c8a0afa9a5d98 Mon Sep 17 00:00:00 2001
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
 drivers/md/bcache/super.c  | 61 ++++++++++++++++++++++++++--------------=
------
 2 files changed, 36 insertions(+), 27 deletions(-)

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
index e169739..f017f69 100644
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
@@ -206,15 +205,15 @@ static void write_bdev_super_endio(struct bio *bio)=

 	closure_put(&dc->sb_write);
 }
=20
-static void __write_super(struct cache_sb *sb, struct bio *bio)
+static void __write_super(struct cache_sb *sb, struct bio *bio, void *sb=
_data)
 {
-	struct cache_sb *out =3D page_address(bio->bi_io_vec[0].bv_page);
+	struct cache_sb *out =3D sb_data;
 	unsigned i;
=20
 	bio->bi_iter.bi_sector	=3D SB_SECTOR;
 	bio->bi_rw		=3D REQ_SYNC|REQ_META;
 	bio->bi_iter.bi_size	=3D SB_SIZE;
-	bch_bio_map(bio, NULL);
+	bch_bio_map(bio, sb_data);
=20
 	out->offset		=3D cpu_to_le64(sb->offset);
 	out->version		=3D cpu_to_le64(sb->version);
@@ -262,7 +261,7 @@ void bch_write_bdev_super(struct cached_dev *dc, stru=
ct closure *parent)
 	bio->bi_private =3D dc;
=20
 	closure_get(cl);
-	__write_super(&dc->sb, bio);
+	__write_super(&dc->sb, bio, dc->sb_disk_data);
=20
 	closure_return_with_destructor(cl, bch_write_bdev_super_unlock);
 }
@@ -308,7 +307,7 @@ void bcache_write_super(struct cache_set *c)
 		bio->bi_private =3D ca;
=20
 		closure_get(cl);
-		__write_super(&ca->sb, bio);
+		__write_super(&ca->sb, bio, ca->sb_disk_data);
 	}
=20
 	closure_return_with_destructor(cl, bcache_write_super_unlock);
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
@@ -1152,9 +1153,8 @@ static void register_bdev(struct cache_sb *sb, stru=
ct page *sb_page,
=20
 	bio_init(&dc->sb_bio);
 	dc->sb_bio.bi_max_vecs	=3D 1;
-	dc->sb_bio.bi_io_vec	=3D dc->sb_bio.bi_inline_vecs;
-	dc->sb_bio.bi_io_vec[0].bv_page =3D sb_page;
-	get_page(sb_page);
+	dc->sb_bio.bi_io_vec	=3D &dc->sb_bv[0];
+	dc->sb_disk_data	=3D sb_disk_data;
=20
 	if (cached_dev_init(dc, sb->block_size << 9))
 		goto err;
@@ -1179,6 +1179,7 @@ static void register_bdev(struct cache_sb *sb, stru=
ct page *sb_page,
 	return;
 err:
 	pr_notice("error opening %s: %s", bdevname(bdev, name), err);
+	kfree(sb_disk_data);
 	bcache_device_stop(&dc->disk);
 }
=20
@@ -1793,8 +1794,7 @@ void bch_cache_release(struct kobject *kobj)
 	for (i =3D 0; i < RESERVE_NR; i++)
 		free_fifo(&ca->free[i]);
=20
-	if (ca->sb_bio.bi_inline_vecs[0].bv_page)
-		put_page(ca->sb_bio.bi_io_vec[0].bv_page);
+	kfree(ca->sb_disk_data);
=20
 	if (!IS_ERR_OR_NULL(ca->bdev))
 		blkdev_put(ca->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
@@ -1838,7 +1838,7 @@ static int cache_alloc(struct cache_sb *sb, struct =
cache *ca)
 	return 0;
 }
=20
-static int register_cache(struct cache_sb *sb, struct page *sb_page,
+static int register_cache(struct cache_sb *sb, void *sb_disk_data,
 				struct block_device *bdev, struct cache *ca)
 {
 	char name[BDEVNAME_SIZE];
@@ -1851,16 +1851,17 @@ static int register_cache(struct cache_sb *sb, st=
ruct page *sb_page,
=20
 	bio_init(&ca->sb_bio);
 	ca->sb_bio.bi_max_vecs	=3D 1;
-	ca->sb_bio.bi_io_vec	=3D ca->sb_bio.bi_inline_vecs;
-	ca->sb_bio.bi_io_vec[0].bv_page =3D sb_page;
-	get_page(sb_page);
+	ca->sb_bio.bi_io_vec	=3D &ca->sb_bv[0];
+	ca->sb_disk_data	=3D sb_disk_data;
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
@@ -1883,8 +1884,10 @@ out:
 	kobject_put(&ca->kobj);
=20
 err:
-	if (err)
+	if (err) {
 		pr_notice("error opening %s: %s", bdevname(bdev, name), err);
+		kfree(sb_disk_data);
+	}
=20
 	return ret;
 }
@@ -1935,13 +1938,14 @@ static ssize_t register_bcache(struct kobject *k,=
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
@@ -1967,7 +1971,7 @@ static ssize_t register_bcache(struct kobject *k, s=
truct kobj_attribute *attr,
 	if (set_blocksize(bdev, 4096))
 		goto err_close;
=20
-	err =3D read_super(sb, bdev, &sb_page);
+	err =3D read_super(sb, bdev, sb_disk_data);
 	if (err)
 		goto err_close;
=20
@@ -1977,20 +1981,23 @@ static ssize_t register_bcache(struct kobject *k,=
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
+		if (register_cache(sb, sb_disk_data, bdev, ca) !=3D 0) {
+			sb_disk_data =3D NULL;
 			goto err_close;
+		}
+		sb_disk_data =3D NULL;
 	}
 out:
-	if (sb_page)
-		put_page(sb_page);
 	kfree(sb);
+	kfree(sb_disk_data);
 	kfree(path);
 	module_put(THIS_MODULE);
 	return ret;
--=20
1.9.1


--------------5B8528B42B133023112A1CEC--

--tU3lrUJ1ev9bEWpAct5tx1AhTH2fRdqqS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJXmNBbAAoJEOhnXe7L7s6jjnQP/0j91ILJFocrWoVdNW0JhWVU
vo1xs/0YFZOUTJrJ+zc5xZC8M3SwVxPWQrVPyBNxsnNE8PL7Ivz4b63R1hHJxOa0
ZXem1W2/0mDiseWgSRZi7svXiuVWK8J2DkR295dwdi0HqX0z9Sf8EkWrv742+rvs
DSZiVlj2kPedhjEwu/js1/1n7bxxUZJ4Du6qMLN9BZlEwKB3HgoTmLlEyPepPFFF
75RBofp9Hzl+wt2ayXX/MCAM0OX0HcWsnj26PLXytTwCzZu73ariw5n0FkGT4RYk
bSSjv+o2udsJJomfRUelHRpu7Q5WMIjOMEylGsNC5lDL+J+o0Gdi3Z69zKq99Z1m
6wMBs/nz/xvtCGGwWg4NII2dV/sOBAE1twwbmvCYNSHGFjkKVh2bvW9QLj0kNVig
LVpwyjoyU612jb9aupDGBx2DCBnN/eaYaVuhKBt16wHu91N3dL/a6G+qkJ3Ya7OM
ryRbaQC9kRFmTCjrDp88pV2F0T1giyGeRt8LcrbN6xqOe4WRXzsTuhAYCyKmkpF5
CbkjxqBk8u8DPn8G9WqI+N8JrMmlEeEE2m+mkXgZQHfHItgzgD6TI4bmp19FVqoH
hOdD1+F/eR95llQ0bWO56/LqC4mhXVUDqE86EfYRSCVqZIt9QFRKls+/XZfHK6Ii
B66ebE015j1NobL1zi1j
=jsGx
-----END PGP SIGNATURE-----

--tU3lrUJ1ev9bEWpAct5tx1AhTH2fRdqqS--
