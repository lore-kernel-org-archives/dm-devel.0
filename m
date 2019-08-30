From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v3 1/2] md raid0/linear: Mark array as
	'broken' and fail BIOs if a member is gone
Date: Fri, 30 Aug 2019 18:08:10 +1000
Message-ID: <87d0gnf53p.fsf@notabene.neil.brown.name>
References: <20190822161318.26236-1-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4103811891291545270=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190822161318.26236-1-gpiccoli@canonical.com>
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
Cc: Neil F Brown <nfbrown@suse.com>, Song Liu <songliubraving@fb.com>, liu.song.a23@gmail.com, linux-block@vger.kernel.org, dm-devel@redhat.com, jay.vosburgh@canonical.com
List-Id: dm-devel.ids

--===============4103811891291545270==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22 2019,  Guilherme G. Piccoli  wrote:

> Currently md raid0/linear are not provided with any mechanism to validate
> if an array member got removed or failed. The driver keeps sending BIOs
> regardless of the state of array members, and kernel shows state 'clean'
> in the 'array_state' sysfs attribute. This leads to the following
> situation: if a raid0/linear array member is removed and the array is
> mounted, some user writing to this array won't realize that errors are
> happening unless they check dmesg or perform one fsync per written file.
> Despite udev signaling the member device is gone, 'mdadm' cannot issue the
> STOP_ARRAY ioctl successfully, given the array is mounted.
>
> In other words, no -EIO is returned and writes (except direct ones) appear
> normal. Meaning the user might think the wrote data is correctly stored in
> the array, but instead garbage was written given that raid0 does stripping
> (and so, it requires all its members to be working in order to not corrupt
> data). For md/linear, writes to the available members will work fine, but
> if the writes go to the missing member(s), it'll cause a file corruption
> situation, whereas the portion of the writes to the missing devices aren't
> written effectively.
>
> This patch changes this behavior: we check if the block device's gendisk
> is UP when submitting the BIO to the array member, and if it isn't, we fl=
ag
> the md device as MD_BROKEN and fail subsequent I/Os to that device; a read
> request to the array requiring data from a valid member is still complete=
d.
> While flagging the device as MD_BROKEN, we also show a rate-limited warni=
ng
> in the kernel log.
>
> A new array state 'broken' was added too: it mimics the state 'clean' in
> every aspect, being useful only to distinguish if the array has some memb=
er
> missing. We rely on the MD_BROKEN flag to put the array in the 'broken'
> state. This state cannot be written in 'array_state' as it just shows
> one or more members of the array are missing but acts like 'clean', it
> wouldn't make sense to write it.
>
> With this patch, the filesystem reacts much faster to the event of missing
> array member: after some I/O errors, ext4 for instance aborts the journal
> and prevents corruption. Without this change, we're able to keep writing
> in the disk and after a machine reboot, e2fsck shows some severe fs errors
> that demand fixing. This patch was tested in ext4 and xfs filesystems, and
> requires a 'mdadm' counterpart to handle the 'broken' state.
>
> Cc: NeilBrown <neilb@suse.com>
> Cc: Song Liu <songliubraving@fb.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> ---
>
> v2 -> v3:
> * Rebased against md-next.
>
> * Merged both patches in a single one (thanks Song for the
> suggestion); now we fail BIOs and mark array as MD_BROKEN
> when a member is missing. We rely in the MD_BROKEN flag
> to set array to 'broken' state.
>
> * Function is_missing_dev() was removed due to the above.
>
> v1 -> v2:
> * Added handling for md/linear 'broken' state;
> * Check for is_missing_dev() instead of personality (thanks Neil for
> the suggestion);
> * Changed is_missing_dev() handlers to static;
> * Print rate-limited warning in case of more members go away, not only
> the first.
>
> Cover-letter from v1:
> lore.kernel.org/linux-block/20190729203135.12934-1-gpiccoli@canonical.com
>
>
>  drivers/md/md-linear.c |  9 +++++++++
>  drivers/md/md.c        | 22 ++++++++++++++++++----
>  drivers/md/md.h        |  3 +++
>  drivers/md/raid0.c     | 10 ++++++++++
>  4 files changed, 40 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 7354466ddc90..0479ccdbdeeb 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -258,6 +258,15 @@ static bool linear_make_request(struct mddev *mddev,=
 struct bio *bio)
>  		     bio_sector < start_sector))
>  		goto out_of_bounds;
>=20=20
> +	if (unlikely(!(tmp_dev->rdev->bdev->bd_disk->flags & GENHD_FL_UP))) {
> +		if (!test_bit(MD_BROKEN, &mddev->flags))
> +			pr_warn("md: %s: linear array has a missing/failed member\n",
> +				mdname(mddev));
> +		set_bit(MD_BROKEN, &mddev->flags);

It is a minor point, but I think this would look nicer as
   if (!test_and_set_bit(MD_BROKEN, ....) { .. . }


> +		bio_io_error(bio);
> +		return true;
> +	}
> +
>  	if (unlikely(bio_end_sector(bio) > end_sector)) {
>  		/* This bio crosses a device boundary, so we have to split it */
>  		struct bio *split =3D bio_split(bio, end_sector - bio_sector,
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b46bb143e3c5..e7612033005f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -376,6 +376,11 @@ static blk_qc_t md_make_request(struct request_queue=
 *q, struct bio *bio)
>  	struct mddev *mddev =3D q->queuedata;
>  	unsigned int sectors;
>=20=20
> +	if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw =3D=3D WRITE)) {
> +		bio_io_error(bio);
> +		return BLK_QC_T_NONE;
> +	}
> +
>  	blk_queue_split(q, &bio);
>=20=20
>  	if (mddev =3D=3D NULL || mddev->pers =3D=3D NULL) {
> @@ -4158,12 +4163,17 @@ __ATTR_PREALLOC(resync_start, S_IRUGO|S_IWUSR,
>   * active-idle
>   *     like active, but no writes have been seen for a while (100msec).
>   *
> + * broken
> + *     RAID0/LINEAR-only: same as clean, but array is missing a member.
> + *     It's useful because RAID0/LINEAR mounted-arrays aren't stopped
> + *     when a member is gone, so this state will at least alert the
> + *     user that something is wrong.
>   */
>  enum array_state { clear, inactive, suspended, readonly, read_auto, clea=
n, active,
> -		   write_pending, active_idle, bad_word};
> +		   write_pending, active_idle, broken, bad_word};
>  static char *array_states[] =3D {
>  	"clear", "inactive", "suspended", "readonly", "read-auto", "clean", "ac=
tive",
> -	"write-pending", "active-idle", NULL };
> +	"write-pending", "active-idle", "broken", NULL };
>=20=20
>  static int match_word(const char *word, char **list)
>  {
> @@ -4179,7 +4189,7 @@ array_state_show(struct mddev *mddev, char *page)
>  {
>  	enum array_state st =3D inactive;
>=20=20
> -	if (mddev->pers && !test_bit(MD_NOT_READY, &mddev->flags))
> +	if (mddev->pers && !test_bit(MD_NOT_READY, &mddev->flags)) {
>  		switch(mddev->ro) {
>  		case 1:
>  			st =3D readonly;
> @@ -4199,7 +4209,10 @@ array_state_show(struct mddev *mddev, char *page)
>  				st =3D active;
>  			spin_unlock(&mddev->lock);
>  		}
> -	else {
> +
> +		if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && st =3D=3D clean)

I prefer to keep "unlikely" for performance-sensitive code.  This is not
performance sensitive.

Even without those changes:
  Reviewed-by: NeilBrown <neilb@suse.de>


Thanks,
NeilBrown

> +			st =3D broken;
> +	} else {
>  		if (list_empty(&mddev->disks) &&
>  		    mddev->raid_disks =3D=3D 0 &&
>  		    mddev->dev_sectors =3D=3D 0)
> @@ -4313,6 +4326,7 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>  		break;
>  	case write_pending:
>  	case active_idle:
> +	case broken:
>  		/* these cannot be set */
>  		break;
>  	}
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1edcd967eb8e..240de65e15e8 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -251,6 +251,9 @@ enum mddev_flags {
>  	MD_NOT_READY,		/* do_md_run() is active, so 'array_state'
>  				 * must not report that array is ready yet
>  				 */
> +	MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
> +				 * I/O in case an array member is gone/failed.
> +				 */
>  };
>=20=20
>  enum mddev_sb_flags {
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index bf5cf184a260..7772f5350bf2 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -586,6 +586,16 @@ static bool raid0_make_request(struct mddev *mddev, =
struct bio *bio)
>=20=20
>  	zone =3D find_zone(mddev->private, &sector);
>  	tmp_dev =3D map_sector(mddev, zone, sector, &sector);
> +
> +	if (unlikely(!(tmp_dev->bdev->bd_disk->flags & GENHD_FL_UP))) {
> +		if (!test_bit(MD_BROKEN, &mddev->flags))
> +			pr_warn("md: %s: raid0 array has a missing/failed member\n",
> +				mdname(mddev));
> +		set_bit(MD_BROKEN, &mddev->flags);
> +		bio_io_error(bio);
> +		return true;
> +	}
> +
>  	bio_set_dev(bio, tmp_dev->bdev);
>  	bio->bi_iter.bi_sector =3D sector + zone->dev_start +
>  		tmp_dev->data_offset;
> --=20
> 2.22.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl1o2WsACgkQOeye3VZi
gbnEahAAh7csw4AcVbuP23lk6OnyJaDC57BKbTiWM9IhMjR+hLfTwWeXo6QNnwvq
1/geFX/p8iGZT5hUM1lCYe6FEpw8vYtOnciXldaaJrdcB/QNc68oJ8P0DMIkJGxT
dEQS6mrX5e1dWPaWWA3ZP8woXgHr+RuQMBpuukn65obsvwfv3IOsuCCUMorO2H9v
JnpPd8Y3RnZIdAdg/HW2CN+rIEptU4DYK3ZwBCDglH+DDoWXmBGJQZENw9KykZ3k
p23Kw+WwNi9PoeqyHwxqlne6Xt5Q7GHXVqFp8OQM71TtGOQCXUN6LA5hgKLzl73E
6Aus59MW4zNlPxgZPu2gdh5vt1G54H1kXO+7Cvdy353wRXa6DpG+3ppHrOYG63z8
cMT7FcTlGK76qzbpNQ9AijCuH4fUT+HJEQrQSQdEGsyuqjUx9hnGLCRcpFPUbyqa
w4foUg/2LR00k8RGWhgOx6tznxjPMRhYlCSJgfAqV9EqxRG71fgAfho3yjGn2ltW
/uvwYv+TbRTw2w9oK0WmhPvstxl3Jg1iqr7NABIKVz4j1BQLBGI8LKLtNjpwImbL
V16RdU1MqHQwuLqPNQjGvhJhC9UQaRD30lEeFRK2beSzdPcevHBYCeLknaTja/pE
jnNZhYdjtnVfytrhFVWg3mPchbr4w4O3HQfQovpHWfWilUDOb/A=
=pmHU
-----END PGP SIGNATURE-----
--=-=-=--


--===============4103811891291545270==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4103811891291545270==--
