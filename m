From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md/raid0: Fail BIOs if their underlying
	block device is gone
Date: Tue, 30 Jul 2019 10:08:45 +1000
Message-ID: <87zhkwl6ya.fsf@notabene.neil.brown.name>
References: <20190729193359.11040-1-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3965283299856440800=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190729193359.11040-1-gpiccoli@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, jay.vosburgh@canonical.com, Song Liu <songliubraving@fb.com>, dm-devel@redhat.com, Neil F Brown <nfbrown@suse.com>
List-Id: dm-devel.ids

--===============3965283299856440800==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29 2019,  Guilherme G. Piccoli  wrote:

> Currently md/raid0 is not provided with any mechanism to validate if
> an array member got removed or failed. The driver keeps sending BIOs
> regardless of the state of array members. This leads to the following
> situation: if a raid0 array member is removed and the array is mounted,
> some user writing to this array won't realize that errors are happening
> unless they check kernel log or perform one fsync per written file.
>
> In other words, no -EIO is returned and writes (except direct ones) appear
> normal. Meaning the user might think the wrote data is correctly stored in
> the array, but instead garbage was written given that raid0 does stripping
> (and so, it requires all its members to be working in order to not corrupt
> data).
>
> This patch proposes a small change in this behavior: we check if the block
> device's gendisk is UP when submitting the BIO to the array member, and if
> it isn't, we flag the md device as broken and fail subsequent I/Os. In ca=
se
> the array is restored (i.e., the missing array member is back), the flag =
is
> cleared and we can submit BIOs normally.
>
> With this patch, the filesystem reacts much faster to the event of missing
> array member: after some I/O errors, ext4 for instance aborts the journal
> and prevents corruption. Without this change, we're able to keep writing
> in the disk and after a machine reboot, e2fsck shows some severe fs errors
> that demand fixing. This patch was tested in both ext4 and xfs
> filesystems.
>
> Cc: NeilBrown <neilb@suse.com>
> Cc: Song Liu <songliubraving@fb.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> ---
>
> After an attempt to change the way md/raid0 fails in case one of its
> members gets removed (see [0]), we got not so great feedback from the
> community and also, the change was complex and had corner cases.
> One of the points which seemed to be a consensus in that attempt was
> that raid0 could benefit from a way of failing faster in case a member
> gets removed. This patch aims for that, in a simpler way than earlier
> proposed. Any feedbacks are welcome, thanks in advance!
>
>
> Guilherme
>
>
> [0] lore.kernel.org/linux-block/20190418220448.7219-1-gpiccoli@canonical.=
com
>
>
>  drivers/md/md.c    | 5 +++++
>  drivers/md/md.h    | 3 +++
>  drivers/md/raid0.c | 8 ++++++++
>  3 files changed, 16 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 24638ccedce4..fba49918d591 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -376,6 +376,11 @@ static blk_qc_t md_make_request(struct request_queue=
 *q, struct bio *bio)
>  	struct mddev *mddev =3D q->queuedata;
>  	unsigned int sectors;
>=20=20
> +	if (unlikely(test_bit(MD_BROKEN, &mddev->flags))) {
> +		bio_io_error(bio);
> +		return BLK_QC_T_NONE;
> +	}

I think this should only fail WRITE requests, not READ requests.

Otherwise the patch is probably reasonable.

NeilBrown


> +
>  	blk_queue_split(q, &bio);
>=20=20
>  	if (mddev =3D=3D NULL || mddev->pers =3D=3D NULL) {
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 10f98200e2f8..41552e615c4c 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -248,6 +248,9 @@ enum mddev_flags {
>  	MD_UPDATING_SB,		/* md_check_recovery is updating the metadata
>  				 * without explicitly holding reconfig_mutex.
>  				 */
> +	MD_BROKEN,              /* This is used in RAID-0 only, to stop I/O
> +				 * in case an array member is gone/failed.
> +				 */
>  };
>=20=20
>  enum mddev_sb_flags {
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index bf5cf184a260..58a9cc5193bf 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -586,6 +586,14 @@ static bool raid0_make_request(struct mddev *mddev, =
struct bio *bio)
>=20=20
>  	zone =3D find_zone(mddev->private, &sector);
>  	tmp_dev =3D map_sector(mddev, zone, sector, &sector);
> +
> +	if (unlikely(!(tmp_dev->bdev->bd_disk->flags & GENHD_FL_UP))) {
> +		set_bit(MD_BROKEN, &mddev->flags);
> +		bio_io_error(bio);
> +		return true;
> +	}
> +
> +	clear_bit(MD_BROKEN, &mddev->flags);
>  	bio_set_dev(bio, tmp_dev->bdev);
>  	bio->bi_iter.bi_sector =3D sector + zone->dev_start +
>  		tmp_dev->data_offset;
> --=20
> 2.22.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl0/io4ACgkQOeye3VZi
gbkPnw//ZDAHleCZDsGZjuID2XCXBfEvuRDbTSMrk2NaIj/z/DlsSQOkNDYYGP5m
H4g7AssCnA49f67+F8sfkH/Fy+crnjR9p0e22bzKdXSi3O0HOGvkHkqHLjtWt7Pu
+atITqeUB/riI/v0b9y9whdFO1P3itEuZ+Nv+3hf3AlQ7P01Pv3v9ntpFycztqgG
VN0EkaGudLA5lkCphHmajgUUfLWF4GmP0dLsCHvd9GYCqpKGChImrHLrqgVPXTKz
T5BLp5l+icj59dM7Gn1iF3Hmub46QkGlfF0Flfp0jduqADB/khx7+smapYcBPXBu
pVsCV/fZtnWE/82CjYQiGeU+z6YZ2mFQRnRmgUFGE/Da6Te51DdyipU1NwYRRHB4
EgBOO76o9EaKBfqPzWMmxAuBUbdvZI2Dk1ZvYhSL0tZ2kFHXmlQwlY98VOc+D8WK
0bEMNJYmiiNkQzIqS3W1BiNFfG+ZDAgw6gC2quVlTVXgMpW205QpN1CbyRpC4Ayi
MSEHFyMDUQMLeehZ5HWK/51PvyvXlrWTjGWvv13EdqhROjzQ0TykR4RbPcrVK/00
ZPxKUZWwk9lh/ko6vfh1ZzcmPEnZ6Ft1pnvbdrH0wd3WOM7cRgjOYMqo/O7nHOQX
PkZVA3CNUYC4Y6oZNTXX9Re8W87Ola4kh00+jT2qddVprwuiaOQ=
=0n/S
-----END PGP SIGNATURE-----
--=-=-=--


--===============3965283299856440800==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3965283299856440800==--
