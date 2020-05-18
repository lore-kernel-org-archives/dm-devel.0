From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <valdis.kletnieks@vt.edu>
Subject: Re: next-20200514 - build issue in drivers/md/dm-zoned-target.c
Date: Mon, 18 May 2020 16:22:42 -0400
Message-ID: <74618.1589833362@turing-police>
References: <367320.1589627953@turing-police> <7bb0d1c8-b164-d5f3-0218-5c71047c3a8c@suse.de>
 <20200518164449.GA24518@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1589833361_31675P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200518164449.GA24518@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--==_Exmh_1589833361_31675P
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 18 May 2020 12:44:49 -0400, Mike Snitzer said:

> Unless I'm missing something it was fixed up with this commit last
> wednesday (13th):
>
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.=
git/commit/?h=3Ddm-5.8&id=3D81a3a1453ec4e5da081e1395732801a600feb352

That says:

author	Nathan Chancellor <natechancellor=40gmail.com>	2020-05-13 01:45:22=
 -0700
committer	Mike Snitzer <snitzer=40redhat.com>	2020-05-15 10:29:39 -0400

So it didn't make it into next-0514, which is why I got bit by it.  It's =
in today's linux-next
and life is good. :)

--==_Exmh_1589833361_31675P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.9.0 11/07/2018

iQIVAwUBXsLukQdmEQWDXROgAQJj2w//XgM9u5d10BsMq/vpw2IiM1yGckHbK/ar
oGAc7biiwgohYKxuoVDjWaqvxLyWjRKKY51HLw1hW0iW+s6GRkXmJMOiCUIYRUgl
cBJmUKzAUnHuWN2aXTRMk2iMR2cT76ymT/JCgdhl/ohiBIgHg3nhF9+eNLgxme+C
PT9jC+TzcaMMpxwkAgpEVVpYsx+4S+4Y0iIKH/tsTbfMlGaUtBRKx/uiEcnugIP8
VpOGjU6aUwpWNQpztpya2Be8E63mTkHv+QkjIMzt+B8Oo3NzqT4hFkr6X8bQ2Xsb
b7Pd7f5ca2r6g2Y7JOvK2yawZTVoKt57Y3ri/fvaHLL1gk3Nj66D/XLEWtioiEq4
hw4hmCIinwKg1EmWomkgHzaGEylZZIMWRuKcX00JhVqqtM6BEG5rSFC5b67LxARr
BEkrlRCYM4PIaNYGnh7lbwdiwAORk/60JXmlzVq8DyRJXjmNjAGUL5aAIVRsACzN
VY8FWX/KGblmvyp6mkq2CUEa3HAIh2BlUccA+wWJtwQbCtsB87obhcyd60iHso55
apXGB/y3HCKAmyuET/GPGfRPb84RwZR98ylJbhvkU9KHNImaNpQcIJe/kGZUqqWd
5tvPtuWstOixl3czNpAym0S1QGvgqebzKZQAeJPdRNmg8/WSt/LdOXt7Snt8AOss
gikLBdM2Rzs=
=24y2
-----END PGP SIGNATURE-----

--==_Exmh_1589833361_31675P--
