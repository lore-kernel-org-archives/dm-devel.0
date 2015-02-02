From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Remove might_sleep from wait_event_cmd
Date: Tue, 3 Feb 2015 09:12:53 +1100
Message-ID: <20150203091253.60ded1d7@notabene.brown>
References: <alpine.LRH.2.02.1502020935580.13510@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/n2X9A2gMiOCJVWT8jnAtHak"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1502020935580.13510@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Zdenek Kabelac <zkabelac@redhat.com>, tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--Sig_/n2X9A2gMiOCJVWT8jnAtHak
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Feb 2015 09:39:02 -0500 (EST) Mikulas Patocka <mpatocka@redhat.co=
m>
wrote:

> Hi
>=20
> Please apply this before 3.19 is released.
>=20
> Mikulas
>=20
>=20
> The patch e22b886a8a43b147e1994a9f970f678fc0df2033 introduced a bug in the
> raid5 subsystem.
>=20
> The function raid5_quiesce (and resize_stripes) calls=20
> lock_all_device_hash_locks_irq that disables interrupts and takes a few=20
> spinlocks, then it calls wait_event_cmd with cmd1=20
> unlock_all_device_hash_locks_irq(conf) and cmd2=20
> lock_all_device_hash_locks_irq(conf). cmd1 unlocks the spinlocks and=20
> enables interrupts, cmd2 disables interrupts and locks the spinlock.
>=20
> The patch e22b886a8a43b147e1994a9f970f678fc0df2033 adds might_sleep() to a
> position where spinlocks are taken, thus it introduces a bug.
>=20
> This patch removes might_sleep() from wait_event_cmd.
>=20
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>=20
> ---
>  include/linux/wait.h |    1 -
>  1 file changed, 1 deletion(-)
>=20
> Index: linux-2.6/include/linux/wait.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/include/linux/wait.h	2014-12-30 01:19:25.564231262 +01=
00
> +++ linux-2.6/include/linux/wait.h	2015-02-02 15:30:16.766354658 +0100
> @@ -363,7 +363,6 @@ do {									\
>   */
>  #define wait_event_cmd(wq, condition, cmd1, cmd2)			\
>  do {									\
> -	might_sleep();							\
>  	if (condition)							\
>  		break;							\
>  	__wait_event_cmd(wq, condition, cmd1, cmd2);			\
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


I support this patch.
However in case it doesn't get in, I've queued up a patch to change raid5.c
to use __wait_event_cmd instead...

NeilBrown

--Sig_/n2X9A2gMiOCJVWT8jnAtHak
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVM/2ZTnsnt1WYoG5AQK71A//QsHAwG/ETSnl6h76pA6SFvGHUpskpI9l
T1+3Q7PdlOhnsdQJoU06dUecUS7vYdcEbeOaFzwxwODfh+yrbIhZruOTrQ0t02qP
BGM6JfBeQy+eJYfnml8t9hBRLtCQ+7vY9QS/35CgR85263O/8w3Hcsbm4W5GKp80
V46+wMZ91W7e1SeGPW0zRyOSamkUue06x8JOB0hca+hLsEMqXlm1Rig4hRhpNwGd
/8eKt2ZWk/kgj2+ktWfx8MvzAfPgVR9pNaPVcDwVkC6stKuXqehBz+Bg/99YJJua
bbMg3WcVOjnv3keSFtcalhnoTaZ4Y6YWxVO+GGO2ewWX/36Nq5bPfcwN2iJZAIc6
FFbx0aNj9ReRVZ5PBIrcpXr7VGvjHNE62BqQNh+b1/c4bqKjYQj7TO04t1mFu+/D
ekfESlVW/kIKyQWNmTOwg3B90b5634tURw1/vavXSUnFGsz8DlANG5iqN2aVKfp9
QJqS9twGiV5GqsAb/2q3talMK20Dezs1WFu0ZELA0cwTLSVV4K9yZqdPM5H7l05Q
xAejU94uP4CsMJBM87gf87/+4RStHKYU2Fe8ayVSiChEkFMFEzgOhI4pyis++kAE
2cWMW6aW5m5uMvv75H628eSSjUm64FCsRquGeR/mN4XHjSxBo7UPfvUNs77f/yLJ
MJZgcyJSslc=
=Q0eh
-----END PGP SIGNATURE-----

--Sig_/n2X9A2gMiOCJVWT8jnAtHak--
