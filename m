From: Stefan Bader <stefan.bader@canonical.com>
Subject: Re: bcache super block corruption with non 4k pages
Date: Tue, 26 Jul 2016 11:51:25 +0200
Message-ID: <fce2a0a9-47d1-a052-997c-b14cd62dcf46@canonical.com>
References: <1469091513-11233-1-git-send-email-stefan.bader@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="AxqHJcBG8M8CE5GlRMCKImXPqe5rVRO3l"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1469091513-11233-1-git-send-email-stefan.bader@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: liuzhengyuang521@gmail.com, kent.overstreet@gmail.com, bcache@linux.ewheeler.net, apw@canonical.com, Stefan Bader <stefan.bader@canonical.com>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AxqHJcBG8M8CE5GlRMCKImXPqe5rVRO3l
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 21.07.2016 10:58, Stefan Bader wrote:
> I was pointed at the thread which seems to address the same after
> I wrote most of below text. Did not want to re-write this so please
> bear with the odd layout.
>=20
> https://www.redhat.com/archives/dm-devel/2016-June/msg00015.html
>=20
> Zhengyuan tries to fix the problem by relocating the superblock on
> disk. But I am not sure whether there is really any guarantee about
> how __bread fills data into the buffer_head. What if there is the next
> odd arch with 128K pages?
>=20
> So below is an attempt to be more generic. Still I don't feel completel=
y
> happy with the way that a page moves (or is shared) between buffer_head=

> and biovec. What I tried to outline below is to let the register functi=
ons
> allocate bio+biovec memory and use the in-memory sb_cache data to initi=
alize
> the biovec buffer.

Any opinions here? Also adding LKML as I don't seem to get through modera=
tion on
dm-devel.


>=20
> -Stefan
>=20
>=20
> ---
>=20
> This was seen on ppc64le with 64k page size. The problem is that
> in that case __bread returns a page where b_data is not at the
> start of the page. And I am not really sure that the way bcache
> re-purposes the page returned by __bread to be used as biovec=20
> element is really a good idea.
>=20
> The way it is now, I saw __bread return a 64k page where b_data
> was starting at 4k offset. Then __write_super was modifying some
> data at offset 0 but for example not writing the magic number again.
>=20
> Not sure why (maybe this messes up flushes, too) but the bad data was n=
ot
> immediately written back when the devices were registered. So at that t=
ime
> bcache-super-show would report data as it was written by user-space (li=
ke
> the cache type still 0 and not 3, and claiming the cache to still bei
> detached).
>=20
> But when stopping the cache and unregistering the cache set this change=
d
> and bcache-super-show was reporting a bad magic number (as expected).
>=20
> The patch below works around this (tested with 64k and 4k pages) but I
> am not really sure this is a clean approach. My gut feeling would be th=
at
> the bio structures should be allocated speperately (I think there is a =
way
> of allocating a bioset without using a pool). Then that separate page c=
ould
> be pre-initialized from the super block structure without passing aroun=
d
> a page the feels more private to __bread usage...
>=20
> -Stefan
>=20
>=20
>=20
> From 3652e98359b876f3c1e6d7b9b7305e3411178296 Mon Sep 17 00:00:00 2001
> From: Stefan Bader <stefan.bader@canonical.com>
> Date: Wed, 20 Jul 2016 12:06:27 +0200
> Subject: [PATCH] bcache: handle non 4k pages returned by __bread
>=20
> On non-x86 arches pages can be bigger than 4k. Currently read_super
> returns a reference to the page used as buffer in the buffer_head
> that is returned by __bread().
> With 4k page size and a requested read this normally ends up with=20
> the super block data starting at offset 0. But as seen on ppc64le
> with 64k page size, the data can start at an offset (from what I
> saw the offset was 4k).
> This causes harm later on when __write_super() maps the super
> block data at the start of the page acquired before and also
> not writes back all fields (particularly the super block magic).
>=20
> Try to avoid this by also returning the potential offset within the
> sb_page from read_super() and fully initiallize the single bvec of
> the bio used for __write_super() calls. Doing that is the same as
> would have been done in bch_bio_map() which now must not be used in
> __write_super().
>=20
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
>=20
> removedebug
>=20
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> ---
>  drivers/md/bcache/super.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e169739..3e0d2de 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -62,7 +62,7 @@ struct workqueue_struct *bcache_wq;
>  /* Superblock */
> =20
>  static const char *read_super(struct cache_sb *sb, struct block_device=
 *bdev,
> -			      struct page **res)
> +			      struct page **res, unsigned int *off)
>  {
>  	const char *err;
>  	struct cache_sb *s;
> @@ -192,6 +192,7 @@ static const char *read_super(struct cache_sb *sb, =
struct block_device *bdev,
>  	err =3D NULL;
> =20
>  	get_page(bh->b_page);
> +	*off =3D (unsigned int) (bh->b_data - ((char *) page_address(bh->b_pa=
ge)));
>  	*res =3D bh->b_page;
>  err:
>  	put_bh(bh);
> @@ -202,19 +203,19 @@ static void write_bdev_super_endio(struct bio *bi=
o)
>  {
>  	struct cached_dev *dc =3D bio->bi_private;
>  	/* XXX: error checking */
> -
>  	closure_put(&dc->sb_write);
>  }
> =20
>  static void __write_super(struct cache_sb *sb, struct bio *bio)
>  {
> -	struct cache_sb *out =3D page_address(bio->bi_io_vec[0].bv_page);
> +	struct cache_sb *out =3D page_address(bio->bi_io_vec[0].bv_page) +
> +			       bio->bi_io_vec[0].bv_offset;
>  	unsigned i;
> =20
>  	bio->bi_iter.bi_sector	=3D SB_SECTOR;
>  	bio->bi_rw		=3D REQ_SYNC|REQ_META;
>  	bio->bi_iter.bi_size	=3D SB_SIZE;
> -	bch_bio_map(bio, NULL);
> +	// bch_bio_map(bio, NULL);
> =20
>  	out->offset		=3D cpu_to_le64(sb->offset);
>  	out->version		=3D cpu_to_le64(sb->version);
> @@ -1139,6 +1140,7 @@ static int cached_dev_init(struct cached_dev *dc,=
 unsigned block_size)
>  /* Cached device - bcache superblock */
> =20
>  static void register_bdev(struct cache_sb *sb, struct page *sb_page,
> +				 unsigned int sb_off,
>  				 struct block_device *bdev,
>  				 struct cached_dev *dc)
>  {
> @@ -1154,6 +1156,8 @@ static void register_bdev(struct cache_sb *sb, st=
ruct page *sb_page,
>  	dc->sb_bio.bi_max_vecs	=3D 1;
>  	dc->sb_bio.bi_io_vec	=3D dc->sb_bio.bi_inline_vecs;
>  	dc->sb_bio.bi_io_vec[0].bv_page =3D sb_page;
> +	dc->sb_bio.bi_io_vec[0].bv_len =3D SB_SIZE;
> +	dc->sb_bio.bi_io_vec[0].bv_offset =3D sb_off;
>  	get_page(sb_page);
> =20
>  	if (cached_dev_init(dc, sb->block_size << 9))
> @@ -1839,6 +1843,7 @@ static int cache_alloc(struct cache_sb *sb, struc=
t cache *ca)
>  }
> =20
>  static int register_cache(struct cache_sb *sb, struct page *sb_page,
> +				unsigned int sb_off,
>  				struct block_device *bdev, struct cache *ca)
>  {
>  	char name[BDEVNAME_SIZE];
> @@ -1853,6 +1858,8 @@ static int register_cache(struct cache_sb *sb, st=
ruct page *sb_page,
>  	ca->sb_bio.bi_max_vecs	=3D 1;
>  	ca->sb_bio.bi_io_vec	=3D ca->sb_bio.bi_inline_vecs;
>  	ca->sb_bio.bi_io_vec[0].bv_page =3D sb_page;
> +	ca->sb_bio.bi_io_vec[0].bv_len  =3D SB_SIZE;
> +	ca->sb_bio.bi_io_vec[0].bv_offset =3D sb_off;
>  	get_page(sb_page);
> =20
>  	if (blk_queue_discard(bdev_get_queue(ca->bdev)))
> @@ -1936,6 +1943,7 @@ static ssize_t register_bcache(struct kobject *k,=
 struct kobj_attribute *attr,
>  	struct cache_sb *sb =3D NULL;
>  	struct block_device *bdev =3D NULL;
>  	struct page *sb_page =3D NULL;
> +	unsigned int sb_off;
> =20
>  	if (!try_module_get(THIS_MODULE))
>  		return -EBUSY;
> @@ -1967,7 +1975,7 @@ static ssize_t register_bcache(struct kobject *k,=
 struct kobj_attribute *attr,
>  	if (set_blocksize(bdev, 4096))
>  		goto err_close;
> =20
> -	err =3D read_super(sb, bdev, &sb_page);
> +	err =3D read_super(sb, bdev, &sb_page, &sb_off);
>  	if (err)
>  		goto err_close;
> =20
> @@ -1977,14 +1985,14 @@ static ssize_t register_bcache(struct kobject *=
k, struct kobj_attribute *attr,
>  			goto err_close;
> =20
>  		mutex_lock(&bch_register_lock);
> -		register_bdev(sb, sb_page, bdev, dc);
> +		register_bdev(sb, sb_page, sb_off, bdev, dc);
>  		mutex_unlock(&bch_register_lock);
>  	} else {
>  		struct cache *ca =3D kzalloc(sizeof(*ca), GFP_KERNEL);
>  		if (!ca)
>  			goto err_close;
> =20
> -		if (register_cache(sb, sb_page, bdev, ca) !=3D 0)
> +		if (register_cache(sb, sb_page, sb_off, bdev, ca) !=3D 0)
>  			goto err_close;
>  	}
>  out:
>=20



--AxqHJcBG8M8CE5GlRMCKImXPqe5rVRO3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJXlzKtAAoJEOhnXe7L7s6juv8QAJTv330oYKhoKUjn87+YKKNI
MNdPhkUDGsDZQVUz6R6vhkyEfIVCiPJF0uD1s/vEVVc3glYXXxlEoK/LkHulq2HN
wDFOWRl7KhCbZTagSGD4SasbYIvPWwIVpM3MNIiUe2h9jilFPxVQzEMLNUGIjp62
JkJJ6Inrmw8RTBGnl94coQB/RuKB7NcxVhWhqQ6HzEAXaR41XMyeullQ8X/at2cJ
YrDLVR320ZWRXSl3JCZQSO8qFGdoSRfgb/sAT2GSXYzpM+DCqws4jEauBUZvr8+5
MneNV4DBSdr4Ds2K12wxkduScBhyNGTC8hTIA0dywFreV2/xB5e18aMnfcy6YWcl
lYJhjdl1dzqrDvfG3uNwZ9C2YIdO6UC3PU1rKsDEc+dSSrVppcIKkj1sEMOq6KtH
wwm58+v7UocAgkUcYCq30GH0EYbfFYuYntm/2k/VCVImbMdLwl93u2YbR7ET3SS/
q1lg9bXMjVD4Dov5drA28WswlibvRgKYMmELmHoA71yGw/DJkJM+THwR6fog6UrU
NHzHREJVxF0S3xC/45kqZN+YAPQ+7I1fpbtS1J/8XnLOykLxP/+zGM5am6z/w6MU
D/fQh8YOb3h263nsqHp6snTH4+bB4pwTytR080WGpWB+UXM7A1BhSFRw5YZ044tK
1+fb6q344EiVnYglpQf2
=VI0c
-----END PGP SIGNATURE-----

--AxqHJcBG8M8CE5GlRMCKImXPqe5rVRO3l--
