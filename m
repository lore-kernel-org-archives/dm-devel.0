From: Neil Brown <neilb@suse.com>
Subject: Re: [PATCH] crash in md-raid1 and md-raid10 due to incorrect list manipulation
Date: Fri, 09 Oct 2015 08:35:20 +1100
Message-ID: <87lhbd59if.fsf@notabene.neil.brown.name>
References: <alpine.LRH.2.02.1510011442260.16076@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1510011442260.16076@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Mikulas Patocka <mpatocka@redhat.com> writes:

> The commit 55ce74d4bfe1b9444436264c637f39a152d1e5ac (md/raid1: ensure=20
> device failure recorded before write request returns) is causing crash in=
=20
> the LVM2 testsuite test shell/lvchange-raid.sh. For me the crash is 100%=
=20
> reproducible.
>
> The reason for the crash is that the newly added code in raid1d moves the=
=20
> list from conf->bio_end_io_list to tmp, then tests if tmp is non-empty an=
d=20
> then incorrectly pops the bio from conf->bio_end_io_list (which is empty=
=20
> because the list was alrady moved).
>
> Raid-10 has a similar bug.

Ouch.  I can't have been thinking when I wrote that code!

Thanks for finding and fixing this.  Patch will be sent to Linus in time
for next -rc.

Thanks,
NeilBrown

>
> Kernel Fault: Code=3D15 regs=3D000000006ccb8640 (Addr=3D0000000100000000)
> CPU: 3 PID: 1930 Comm: mdX_raid1 Not tainted 4.2.0-rc5-bisect+ #35
> task: 000000006cc1f258 ti: 000000006ccb8000 task.ti: 000000006ccb8000
>
>      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
> PSW: 00001000000001001111111000001111 Not tainted
> r00-03  000000ff0804fe0f 000000001059d000 000000001059f818 000000007f16be=
38
> r04-07  000000001059d000 000000007f16be08 0000000000200200 00000000000000=
01
> r08-11  000000006ccb8260 000000007b7934d0 0000000000000001 00000000000000=
00
> r12-15  000000004056f320 0000000000000000 0000000000013dd0 00000000000000=
00
> r16-19  00000000f0d00ae0 0000000000000000 0000000000000000 00000000000000=
01
> r20-23  000000000800000f 0000000042200390 0000000000000000 00000000000000=
00
> r24-27  0000000000000001 000000000800000f 000000007f16be08 000000001059d0=
00
> r28-31  0000000100000000 000000006ccb8560 000000006ccb8640 00000000000000=
00
> sr00-03  0000000000249800 0000000000000000 0000000000000000 0000000000249=
800
> sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000=
000
>
> IASQ: 0000000000000000 0000000000000000 IAOQ: 000000001059f61c 0000000010=
59f620
>  IIR: 0f8010c6    ISR: 0000000000000000  IOR: 0000000100000000
>  CPU:        3   CR30: 000000006ccb8000 CR31: 0000000000000000
>  ORIG_R28: 000000001059d000
>  IAOQ[0]: call_bio_endio+0x34/0x1a8 [raid1]
>  IAOQ[1]: call_bio_endio+0x38/0x1a8 [raid1]
>  RP(r2): raid_end_bio_io+0x88/0x168 [raid1]
> Backtrace:
>  [<000000001059f818>] raid_end_bio_io+0x88/0x168 [raid1]
>  [<00000000105a4f64>] raid1d+0x144/0x1640 [raid1]
>  [<000000004017fd5c>] kthread+0x144/0x160
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: 55ce74d4bfe1 ("md/raid1: ensure device failure recorded before wri=
te request returns.")
> Fixes: 95af587e95aa ("md/raid10: ensure device failure recorded before wr=
ite request returns.")
>
> ---
>  drivers/md/raid1.c  |    4 ++--
>  drivers/md/raid10.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> Index: linux-2.6/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/raid1.c	2015-10-01 21:10:05.000000000 +0200
> +++ linux-2.6/drivers/md/raid1.c	2015-10-01 21:10:58.000000000 +0200
> @@ -2437,8 +2437,8 @@ static void raid1d(struct md_thread *thr
>  		}
>  		spin_unlock_irqrestore(&conf->device_lock, flags);
>  		while (!list_empty(&tmp)) {
> -			r1_bio =3D list_first_entry(&conf->bio_end_io_list,
> -						  struct r1bio, retry_list);
> +			r1_bio =3D list_first_entry(&tmp, struct r1bio,
> +						  retry_list);
>  			list_del(&r1_bio->retry_list);
>  			raid_end_bio_io(r1_bio);
>  		}
> Index: linux-2.6/drivers/md/raid10.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/raid10.c	2015-10-01 21:11:02.000000000 +0200
> +++ linux-2.6/drivers/md/raid10.c	2015-10-01 21:11:19.000000000 +0200
> @@ -2804,8 +2804,8 @@ static void raid10d(struct md_thread *th
>  		}
>  		spin_unlock_irqrestore(&conf->device_lock, flags);
>  		while (!list_empty(&tmp)) {
> -			r10_bio =3D list_first_entry(&conf->bio_end_io_list,
> -						  struct r10bio, retry_list);
> +			r10_bio =3D list_first_entry(&tmp, struct r10bio,
> +						   retry_list);
>  			list_del(&r10_bio->retry_list);
>  			raid_end_bio_io(r10_bio);
>  		}

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWFuGZAAoJEDnsnt1WYoG5ducQAKPuZ3DMLGd9IX8njkuu6n2g
qryfZe2THrJGjAJ+SB7nlPHdvDZ1BozmKF66EtYAj7wy4gwSoNeKcVtOCVJxTlwK
qxUOiJfYAGs6cA762UBUWo28PyshYwBgEyOlBIiViMUTvpbLskMTKGjy0ctJ4UGY
yygHiE1nSpmkoUbEEz1pnSm2Tf++6nMZ+Y/cBFoItLVw3tZivpQdDmsiF96h6zqN
X3lAdU1nzpYPNqFFFqIM9ZyRfLszbWRiTfPmOQ0i2Znf0QzAm/+N7HWCBPsP5P/1
z4S+Qsry3OqnwDigR54MjTqF0/RGUishM9IvgtSy6+BWSGrmZ9T0yW+3QD/eOq8/
4JK+x3rE3IX0tkbxGlqhtgZGLm3eSjUclTVZDi+f2n+cPgiSZZ0gAInR39PDYHD2
n43XezGwslwaureUuLDcV/fMnqWsPdM0bJ/RfzELdNRT+tdkiJluqxl5rhDqkkl2
6R35ACwmorHU1Y0YVPSsFvsYeZDbgABCEXpfulrW22PWUSKn3HN4xs3QC4n166+7
L9kQTLJ/MFKuLTMTasEu/mt7VH0CO1nTgE6mhLPkJwc545kboGhYDZKH0Kn2q706
t3Ya13ACT161rVVgq90gHfY84Z8TlHKfZvQ2LjMRSEmqQ7gz+jTJ8uZd7z15rA7j
ASd8WfPHqtK5QSIXKFmJ
=CEM5
-----END PGP SIGNATURE-----
--=-=-=--
