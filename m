From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] md/raid0: Introduce new array state
	'broken' for raid0
Date: Tue, 30 Jul 2019 10:11:17 +1000
Message-ID: <87wog0l6u2.fsf@notabene.neil.brown.name>
References: <20190729203135.12934-1-gpiccoli@canonical.com>
	<20190729203135.12934-2-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3643406624535424492=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190729203135.12934-2-gpiccoli@canonical.com>
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
Cc: linux-block@vger.kernel.org, jay.vosburgh@canonical.com, songliubraving@fb.com, dm-devel@redhat.com, Neil F Brown <nfbrown@suse.com>
List-Id: dm-devel.ids

--===============3643406624535424492==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29 2019,  Guilherme G. Piccoli  wrote:

> Currently if a md/raid0 array gets one or more members removed while
> being mounted, kernel keeps showing state 'clean' in the 'array_state'
> sysfs attribute. Despite udev signaling the member device is gone, 'mdadm'
> cannot issue the STOP_ARRAY ioctl successfully, given the array is mounte=
d.
>
> Nothing else hints that something is wrong (except that the removed devic=
es
> don't show properly in the output of 'mdadm detail' command). There is no
> other property to be checked, and if user is not performing reads/writes
> to the array, even kernel log is quiet and doesn't give a clue about the
> missing member.
>
> This patch changes this behavior; when 'array_state' is read we introduce
> a non-expensive check (only for raid0) that relies in the comparison of
> the total number of disks when array was assembled with gendisk flags of
> those devices to validate if all members are available and functional.
> A new array state 'broken' was added: it mimics the state 'clean' in every
> aspect, being useful only to distinguish if such array has some member
> missing. Also, we show a rate-limited warning in kernel log in such case.
>
> This patch has no proper functional change other than adding a 'clean'-li=
ke
> state; it was tested with ext4 and xfs filesystems. It requires a 'mdadm'
> counterpart to handle the 'broken' state.
>
> Cc: NeilBrown <neilb@suse.com>
> Cc: Song Liu <songliubraving@fb.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> ---
>  drivers/md/md.c    | 23 +++++++++++++++++++----
>  drivers/md/md.h    |  2 ++
>  drivers/md/raid0.c | 26 ++++++++++++++++++++++++++
>  3 files changed, 47 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index fba49918d591..b80f36084ec1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4160,12 +4160,18 @@ __ATTR_PREALLOC(resync_start, S_IRUGO|S_IWUSR,
>   * active-idle
>   *     like active, but no writes have been seen for a while (100msec).
>   *
> + * broken
> + *     RAID0-only: same as clean, but array is missing a member.
> + *     It's useful because RAID0 mounted-arrays aren't stopped
> + *     when a member is gone, so this state will at least alert
> + *     the user that something is wrong.
> + *
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
> @@ -4181,7 +4187,7 @@ array_state_show(struct mddev *mddev, char *page)
>  {
>  	enum array_state st =3D inactive;
>=20=20
> -	if (mddev->pers)
> +	if (mddev->pers) {
>  		switch(mddev->ro) {
>  		case 1:
>  			st =3D readonly;
> @@ -4201,7 +4207,15 @@ array_state_show(struct mddev *mddev, char *page)
>  				st =3D active;
>  			spin_unlock(&mddev->lock);
>  		}
> -	else {
> +
> +		if ((mddev->pers->level =3D=3D 0) &&

Don't test if ->level is 0.  Instead, test if ->is_missing_dev is not
NULL.

NeilBrown


> +		   ((st =3D=3D clean) || (st =3D=3D broken))) {
> +			if (mddev->pers->is_missing_dev(mddev))
> +				st =3D broken;
> +			else
> +				st =3D clean;
> +		}
> +	} else {
>  		if (list_empty(&mddev->disks) &&
>  		    mddev->raid_disks =3D=3D 0 &&
>  		    mddev->dev_sectors =3D=3D 0)
> @@ -4315,6 +4329,7 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>  		break;
>  	case write_pending:
>  	case active_idle:
> +	case broken:
>  		/* these cannot be set */
>  		break;
>  	}
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 41552e615c4c..e7b42b75701a 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -590,6 +590,8 @@ struct md_personality
>  	int (*congested)(struct mddev *mddev, int bits);
>  	/* Changes the consistency policy of an active array. */
>  	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
> +	/* Check if there is any missing/failed members - RAID0 only for now. */
> +	bool (*is_missing_dev)(struct mddev *mddev);
>  };
>=20=20
>  struct md_sysfs_entry {
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 58a9cc5193bf..79618a6ae31a 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -455,6 +455,31 @@ static inline int is_io_in_chunk_boundary(struct mdd=
ev *mddev,
>  	}
>  }
>=20=20
> +bool raid0_is_missing_dev(struct mddev *mddev)
> +{
> +	struct md_rdev *rdev;
> +	static int already_missing;
> +	int def_disks, work_disks =3D 0;
> +	struct r0conf *conf =3D mddev->private;
> +
> +	def_disks =3D conf->strip_zone[0].nb_dev;
> +	rdev_for_each(rdev, mddev)
> +		if (rdev->bdev->bd_disk->flags & GENHD_FL_UP)
> +			work_disks++;
> +
> +	if (unlikely(def_disks - work_disks)) {
> +		if (!already_missing) {
> +			already_missing =3D 1;
> +			pr_warn("md: %s: raid0 array has %d missing/failed members\n",
> +				mdname(mddev), (def_disks - work_disks));
> +		}
> +		return true;
> +	}
> +
> +	already_missing =3D 0;
> +	return false;
> +}
> +
>  static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
>  {
>  	struct r0conf *conf =3D mddev->private;
> @@ -789,6 +814,7 @@ static struct md_personality raid0_personality=3D
>  	.takeover	=3D raid0_takeover,
>  	.quiesce	=3D raid0_quiesce,
>  	.congested	=3D raid0_congested,
> +	.is_missing_dev	=3D raid0_is_missing_dev,
>  };
>=20=20
>  static int __init raid0_init (void)
> --=20
> 2.22.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl0/iyUACgkQOeye3VZi
gblnEQ/+NamZPUglUnNVstM5Jl6QtOiUnrvb2fgle89GT0fps4Ef3ZhRcXM8TQ4l
fr2ooqdO0tgdPXY7m/pJhvg7IQLKedll9KDsuOe4DzTjBxxSs8kOutkHlFwmK8iL
P+rFdOd59xg1EFuLEkPteiGI8JaZzfUd/cFhQukOy+yFVWk7Pvh4xLCIUCfG3sp/
jSwRrym+rHyEYlaPxOT0qn6rrONVDs/fayXvCqvjeLWwMRP9hFkYd8fZBfgXmB5j
3jzSBtAafp4WlK/+z5OT94QB+43rOK+WM2pLL25aEnamjZF/SmmjIy+6+VV1/bUf
WFduwc6Sc1ILNbiPF09bNV7ul1X7XW8kF7xt49Kkpaqf3Hr1vAajlNvFU1ye49co
DwpR0MGx0TGulB/S9Hg+oGryfGwQgLQn7+noKh3Fpjktjy5q1KOnB4KpsPypu1/1
nBXOXzO6f3KHLr2RiSdTqa/wl/3r1mUHCSWFMDe1wupuFVxltEVm/WtRzVpGDEAw
pM63fd5/IHnIqweTJN2YAThKc5Lyc4Ou7BN3lg/VQtnirWCuJPS7c4/JIiUpqluH
uhg9qzSiuKXtlhXEEo7E/OEhE2NH4Rg+/JrntygSNQJoQ8oQJrDx67bH0PoWjV1p
MjLl855yMwXwOaHOhEKSbE/erRLklajWJ9oeKaO4tOB6TXe3zPI=
=pDFz
-----END PGP SIGNATURE-----
--=-=-=--


--===============3643406624535424492==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3643406624535424492==--
