From: Stefan Bader <stefan.bader@canonical.com>
Subject: Re: bcache super block corruption with non 4k pages
Date: Tue, 26 Jul 2016 14:32:31 +0200
Message-ID: <e09788a2-71f4-96ff-cca4-943c1bc1d9bb@canonical.com>
References: <1469091513-11233-1-git-send-email-stefan.bader@canonical.com>
 <fce2a0a9-47d1-a052-997c-b14cd62dcf46@canonical.com>
 <20160726102148.GA20130@kmo-pixel>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="tNjwAvm361t9QxSLMm08kQIfsK93U305S"
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20160726102148.GA20130@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, liuzhengyuang521@gmail.com, bcache@linux.ewheeler.net, apw@canonical.com, Stefan Bader <stefan.bader@canonical.com>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tNjwAvm361t9QxSLMm08kQIfsK93U305S
Content-Type: multipart/mixed;
 boundary="------------1153330A84D7B8540A392CD8"

This is a multi-part message in MIME format.
--------------1153330A84D7B8540A392CD8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 26.07.2016 12:21, Kent Overstreet wrote:
> On Tue, Jul 26, 2016 at 11:51:25AM +0200, Stefan Bader wrote:
>> On 21.07.2016 10:58, Stefan Bader wrote:
>>> I was pointed at the thread which seems to address the same after
>>> I wrote most of below text. Did not want to re-write this so please
>>> bear with the odd layout.
>>>
>>> https://www.redhat.com/archives/dm-devel/2016-June/msg00015.html
>>>
>>> Zhengyuan tries to fix the problem by relocating the superblock on
>>> disk. But I am not sure whether there is really any guarantee about
>>> how __bread fills data into the buffer_head. What if there is the nex=
t
>>> odd arch with 128K pages?
>>>
>>> So below is an attempt to be more generic. Still I don't feel complet=
ely
>>> happy with the way that a page moves (or is shared) between buffer_he=
ad
>>> and biovec. What I tried to outline below is to let the register func=
tions
>>> allocate bio+biovec memory and use the in-memory sb_cache data to ini=
tialize
>>> the biovec buffer.
>>
>> Any opinions here? Also adding LKML as I don't seem to get through mod=
eration on
>> dm-devel.
>=20
> The correct solution is to rip out the __bread() and just read the supe=
rblock by
> issuing a bio, the same way all the other IO in bcache is done.
>=20
> This is the way it's done in the bcache-dev branch - unfortunately, the=
 patch
> that does that in bcache-dev is big and invasive and probably not worth=
 the
> hassle to backport:
>=20
> https://evilpiepirate.org/git/linux-bcache.git/commit/?h=3Dbcache-dev&i=
d=3D303eb67bffad57b4d9e71523e7df04bf258e66d1

I agree that this looks better and also rather large.
>=20
> Probably best to just do something small and localized.
>=20
So what did you think about the change I did? It seemed to be ok for 4K a=
nd 64K
at least and is rather small. And I believe that, compared to Zhengyuan's=

approach this would have the benefit of not changing the superblock secto=
r. So
it would be compatible with previously created superblocks.

-Stefan



--------------1153330A84D7B8540A392CD8
Content-Type: text/x-diff;
 name="0001-bcache-stable-fix-sb.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-bcache-stable-fix-sb.patch"

=46rom 3652e98359b876f3c1e6d7b9b7305e3411178296 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Wed, 20 Jul 2016 12:06:27 +0200
Subject: [PATCH] bcache: handle non 4k pages returned by __bread

On non-x86 arches pages can be bigger than 4k. Currently read_super
returns a reference to the page used as buffer in the buffer_head
that is returned by __bread().
With 4k page size and a requested read this normally ends up with=20
the super block data starting at offset 0. But as seen on ppc64le
with 64k page size, the data can start at an offset (from what I
saw the offset was 4k).
This causes harm later on when __write_super() maps the super
block data at the start of the page acquired before and also
not writes back all fields (particularly the super block magic).

Try to avoid this by also returning the potential offset within the
sb_page from read_super() and fully initiallize the single bvec of
the bio used for __write_super() calls. Doing that is the same as
would have been done in bch_bio_map() which now must not be used in
__write_super().

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>

---
 drivers/md/bcache/super.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e169739..3e0d2de 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -62,7 +62,7 @@ struct workqueue_struct *bcache_wq;
 /* Superblock */
=20
 static const char *read_super(struct cache_sb *sb, struct block_device *=
bdev,
-			      struct page **res)
+			      struct page **res, unsigned int *off)
 {
 	const char *err;
 	struct cache_sb *s;
@@ -192,6 +192,7 @@ static const char *read_super(struct cache_sb *sb, st=
ruct block_device *bdev,
 	err =3D NULL;
=20
 	get_page(bh->b_page);
+	*off =3D (unsigned int) (bh->b_data - ((char *) page_address(bh->b_page=
)));
 	*res =3D bh->b_page;
 err:
 	put_bh(bh);
@@ -202,19 +203,19 @@ static void write_bdev_super_endio(struct bio *bio)=

 {
 	struct cached_dev *dc =3D bio->bi_private;
 	/* XXX: error checking */
-
 	closure_put(&dc->sb_write);
 }
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
+	// bch_bio_map(bio, NULL);
=20
 	out->offset		=3D cpu_to_le64(sb->offset);
 	out->version		=3D cpu_to_le64(sb->version);
@@ -1139,6 +1140,7 @@ static int cached_dev_init(struct cached_dev *dc, u=
nsigned block_size)
 /* Cached device - bcache superblock */
=20
 static void register_bdev(struct cache_sb *sb, struct page *sb_page,
+				 unsigned int sb_off,
 				 struct block_device *bdev,
 				 struct cached_dev *dc)
 {
@@ -1154,6 +1156,8 @@ static void register_bdev(struct cache_sb *sb, stru=
ct page *sb_page,
 	dc->sb_bio.bi_max_vecs	=3D 1;
 	dc->sb_bio.bi_io_vec	=3D dc->sb_bio.bi_inline_vecs;
 	dc->sb_bio.bi_io_vec[0].bv_page =3D sb_page;
+	dc->sb_bio.bi_io_vec[0].bv_len =3D SB_SIZE;
+	dc->sb_bio.bi_io_vec[0].bv_offset =3D sb_off;
 	get_page(sb_page);
=20
 	if (cached_dev_init(dc, sb->block_size << 9))
@@ -1839,6 +1843,7 @@ static int cache_alloc(struct cache_sb *sb, struct =
cache *ca)
 }
=20
 static int register_cache(struct cache_sb *sb, struct page *sb_page,
+				unsigned int sb_off,
 				struct block_device *bdev, struct cache *ca)
 {
 	char name[BDEVNAME_SIZE];
@@ -1853,6 +1858,8 @@ static int register_cache(struct cache_sb *sb, stru=
ct page *sb_page,
 	ca->sb_bio.bi_max_vecs	=3D 1;
 	ca->sb_bio.bi_io_vec	=3D ca->sb_bio.bi_inline_vecs;
 	ca->sb_bio.bi_io_vec[0].bv_page =3D sb_page;
+	ca->sb_bio.bi_io_vec[0].bv_len  =3D SB_SIZE;
+	ca->sb_bio.bi_io_vec[0].bv_offset =3D sb_off;
 	get_page(sb_page);
=20
 	if (blk_queue_discard(bdev_get_queue(ca->bdev)))
@@ -1936,6 +1943,7 @@ static ssize_t register_bcache(struct kobject *k, s=
truct kobj_attribute *attr,
 	struct cache_sb *sb =3D NULL;
 	struct block_device *bdev =3D NULL;
 	struct page *sb_page =3D NULL;
+	unsigned int sb_off;
=20
 	if (!try_module_get(THIS_MODULE))
 		return -EBUSY;
@@ -1967,7 +1975,7 @@ static ssize_t register_bcache(struct kobject *k, s=
truct kobj_attribute *attr,
 	if (set_blocksize(bdev, 4096))
 		goto err_close;
=20
-	err =3D read_super(sb, bdev, &sb_page);
+	err =3D read_super(sb, bdev, &sb_page, &sb_off);
 	if (err)
 		goto err_close;
=20
@@ -1977,14 +1985,14 @@ static ssize_t register_bcache(struct kobject *k,=
 struct kobj_attribute *attr,
 			goto err_close;
=20
 		mutex_lock(&bch_register_lock);
-		register_bdev(sb, sb_page, bdev, dc);
+		register_bdev(sb, sb_page, sb_off, bdev, dc);
 		mutex_unlock(&bch_register_lock);
 	} else {
 		struct cache *ca =3D kzalloc(sizeof(*ca), GFP_KERNEL);
 		if (!ca)
 			goto err_close;
=20
-		if (register_cache(sb, sb_page, bdev, ca) !=3D 0)
+		if (register_cache(sb, sb_page, sb_off, bdev, ca) !=3D 0)
 			goto err_close;
 	}
 out:
--=20
1.9.1


--------------1153330A84D7B8540A392CD8--

--tNjwAvm361t9QxSLMm08kQIfsK93U305S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJXl1hnAAoJEOhnXe7L7s6jwHcP/ieNC6+NOGCJp+7C0jH6PqqQ
OfbwxeNoKj6oGjS6B8rmQJBf+LOCuBIJDcYpbWu7iJIWyVgvzfli+7MfKmGRiSSI
pS8SGwAEP0GFXEZy2tKDPUL7q9+frUf4KS2C2iAh1fd6TMTlxenIvQJ+e7fW1FjF
48OYDEXv0quU2H7ZfCVUIEBBgesB81PpzJpqBgwXACff45UK6iWzgXGRdUp+HA5t
lhRApU6hegsJ8swGDMSiOuYXFv1V7FAiJaw84ll9kfEEugcR+BrI42LL4XNlnLWp
jLU5U8YY1CUEmqukpbQpHrwep1OJXVLaIgOXTxLDXL5aZNDN9RP6Q61gXHzyem1l
HFUK761bFlYdQujPvFcmEUC4fT1NNL7sOKn9AtNARDZyOfy4unSQMzZvTpvulZdk
5fXlfqNyKcr2Xv4nyUAHQuIQ9SSO3mDg7Kz8EbFm9AOdraGY9uCP48gPCzIMiOWm
mF0ajh1F0yEEBjYmnSXTCLt0vRHaDTYS0yiI8KQYq7Ab7ej0/ruG5OFCL6xuSlAu
+QWRqZijXXh053OYgb1EAUeNt4KsCpXoWq2bp/jsmC+z+SKKpd9EIqLa3ieGi+1c
sSACicznKfPVe2jdO4Ec2OJGmhOT50VQ+1Ud5yaJp4R9YN8UFFZLLdMI1H8luytz
gDxga82kcBTcNGSalnN1
=HreP
-----END PGP SIGNATURE-----

--tNjwAvm361t9QxSLMm08kQIfsK93U305S--
