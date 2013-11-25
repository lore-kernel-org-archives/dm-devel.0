From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] MD/DM RAID: Fix hang due to recent RAID5 locking
 changes
Date: Mon, 25 Nov 2013 11:03:15 +1100
Message-ID: <20131125110315.262223cf@notabene.brown>
References: <1385335843-14021-1-git-send-email-jbrassow@redhat.com>
	<1385335843-14021-2-git-send-email-jbrassow@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m=WJU4fceQuEFIacxjzYCwf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1385335843-14021-2-git-send-email-jbrassow@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--Sig_/m=WJU4fceQuEFIacxjzYCwf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 24 Nov 2013 17:30:43 -0600 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> When commit 773ca82 was made in v3.12-rc1, it caused RAID4/5/6 devices
> that were created via device-mapper (dm-raid.c) to hang on creation.
> This is not necessarily the fault of that commit, but perhaps the way
> dm-raid.c was setting-up and activating devices.
>=20
> Device-mapper allows I/O and memory allocations in the constructor
> (i.e. raid_ctr()), but nominal and recovery I/O should not be allowed
> until a 'resume' is issued (i.e. raid_resume()).  It has been problematic
> (at least in the past) to call mddev_resume before mddev_suspend was
> called, but this is how DM behaves - CTR then resume.  To solve the
> problem, raid_ctr() was setting up the structures, calling md_run(), and
> then also calling mddev_suspend().  The stage was then set for raid_resum=
e()
> to call mddev_resume().
>=20
> Commit 773ca82 caused a change in behavior during raid5.c:run().
> 'setup_conf->grow_stripes->grow_one_stripe' is called which creates the
> stripe cache and increments 'active_stripes'.
> 'grow_one_stripe->release_stripe' doesn't actually decrement 'active_stri=
pes'
> anymore.  The side effect of this is that when raid_ctr calls mddev_suspe=
nd,
> it waits for 'active_stripes' to reduce to 0 - which never happens.

Hi Jon,
 this sounds like the same bug that is fixed by=20

commit ad4068de49862b083ac2a15bc50689bb30ce3e44
Author: majianpeng <majianpeng@gmail.com>
Date:   Thu Nov 14 15:16:15 2013 +1100

    raid5: Use slow_path to release stripe when mddev->thread is null

which is already en-route to 3.12.x.  Could you check if it fixes the bug f=
or
you?

Thanks,
NeilBrown

>=20
> You could argue that the MD personalities should be able to handle either
> a suspend or a resume after 'md_run' is called, but it can't really handle
> either.  To fix this, I've removed the call to mddev_suspend in raid_ctr =
and
> I've made the call to the personality's 'quiesce' function within
> mddev_resume dependent on whether the device is currently suspended.
>=20
> This patch is suitable and recommended for 3.12.
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> ---
>  drivers/md/dm-raid.c |    1 -
>  drivers/md/md.c      |    5 ++++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 4880b69..cdad87c 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -1249,7 +1249,6 @@ static int raid_ctr(struct dm_target *ti, unsigned =
argc, char **argv)
>  	rs->callbacks.congested_fn =3D raid_is_congested;
>  	dm_table_add_target_callbacks(ti->table, &rs->callbacks);
> =20
> -	mddev_suspend(&rs->md);
>  	return 0;
> =20
>  size_mismatch:
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 561a65f..383980d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -359,9 +359,12 @@ EXPORT_SYMBOL_GPL(mddev_suspend);
> =20
>  void mddev_resume(struct mddev *mddev)
>  {
> +	int should_quiesce =3D mddev->suspended;
> +
>  	mddev->suspended =3D 0;
>  	wake_up(&mddev->sb_wait);
> -	mddev->pers->quiesce(mddev, 0);
> +	if (should_quiesce)
> +		mddev->pers->quiesce(mddev, 0);
> =20
>  	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>  	md_wakeup_thread(mddev->thread);


--Sig_/m=WJU4fceQuEFIacxjzYCwf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpKTxDnsnt1WYoG5AQJW5hAAs/YAVsS/GIEg/bkbm6GstosCBTZyHLyF
BtYkzvJQ6WCRWgTGWGPhpoajkbV8hp7iiUrItaL1hN90byHssyosnEyKQo0DSUfc
Qm5YP6e70tKTfZOwKRXVlXO7Dm95/QPWcPjtMq4EUHxSTM2h6iEVaTDWrtOUorCY
SkmSVVL3DD2yLRBeki9oXRplNbqo98dX0hdeNtGQNEIjlv115RKNmuHWTtmiuJlt
CFsfgiML+Mfs4ZoOsfyjzzw8+VecCa4isAE6bTMebnBETnFZNdxICwDlj4aSt8qP
wgjvkgOVv43YSIw5FyLgUZYMUmdydL+OtBrsVsdOiacX7rw6pIuwwRf+oznRulmr
ngYWaqinT45EYdl85On4Wll+eE5SyyVQVEAgBBYjAPFw3g9PBnVor8eBNsmI9gfs
NdeHIEL4zSX97boAH5qNCNo7DICnbNR+XNdWoqvCjwOUXTM850kpwUoq1lttlVEB
nELO1oM/e0s+PmAhmKlKT67WV0NGRRiSwLseVtulwRXtNQY0WLSql2tH/EykIG8N
YnrMcbNor6SDQBBxmrmx++tNy41ysmFwEPx3kvNy4wqcK0wEfEyWfzRoNlTj8BTd
TD5n+wj1L5wEiCtz8TXvHydCVQV9f4CCKOOBHpqUhglg/GgUgsoACnUXRIvDGk6i
gFTd3Uirb24=
=Ae5g
-----END PGP SIGNATURE-----

--Sig_/m=WJU4fceQuEFIacxjzYCwf--
