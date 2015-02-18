From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/3] md raid: enhancements to support the device mapper
 dm-raid target
Date: Wed, 18 Feb 2015 13:03:28 +1100
Message-ID: <20150218130328.3ce5ab53@notabene.brown>
References: <1423853282-6218-1-git-send-email-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/VV1Zo=yI_+zDXHJ4UvFgOMV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1423853282-6218-1-git-send-email-heinzm@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: heinzm@redhat.com
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--Sig_/VV1Zo=yI_+zDXHJ4UvFgOMV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Feb 2015 19:47:59 +0100 heinzm@redhat.com wrote:

> From: Heinz Mauelshagen <heinzm@redhat.com>
>=20
> I'm enhancing the device mapper raid target (dm-raid) to take
> advantage of so far unused md raid kernel funtionality:
> takeover, reshape, resize, addition and removal of devices to/from raid s=
ets.
>=20
> This series of patches remove constraints doing so.
>=20
>=20
> Patch #1:
> add 2 API functions to allow dm-raid to access the raid takeover
> and resize functionality (namely md_takeover() and md_resize());
> reshape APIs are not needed in lieu of the existing personalilty ones
>=20
> Patch #2:
> because device mapper core manages a request queue per mapped device
> utilizing the md make_request API to pass on bios via the dm-raid target,
> no md instance underneath it needs to manage a request queue of its own.
> Thus dm-raid can't use the md raid0 personality as is, because the latter
> accesses the request queue unconditionally in 3 places via mddev->queue
> which this patch addresses.
>=20
> Patch #3:
> when dm-raid processes a down takeover to raid0, it needs to destroy
> any existing bitmap, because raid0 does not require one. The patch
> exports the bitmap_destroy() API to allow dm-raid to remove bitmaps.
>=20
>=20
> Heinz Mauelshagen (3):
>   md core:   add 2 API functions for takeover and resize to support dm-ra=
id
>   md raid0:  access mddev->queue (request queue member) conditionally
>              because it is not set when accessed from dm-raid
>   md bitmap: export bitmap_destroy() to support dm-raid down takover to r=
aid0
>=20
>  drivers/md/bitmap.c |  1 +
>  drivers/md/md.c     | 39 ++++++++++++++++++++++++++++++---------
>  drivers/md/md.h     |  3 +++
>  drivers/md/raid0.c  | 48 +++++++++++++++++++++++++++---------------------
>  4 files changed, 61 insertions(+), 30 deletions(-)
>=20

Hi Heinz,
 I don't object to these patches if you will find the exported functionality
 useful, but I am a little surprised by them.

 I would expect that dm-raid wouldn't ask md to 'takeover' from one level to
 another, but instead would
   - suspend the dm device
   - dismantle the array using the old level
   - assemble the array using the new level
   - resume the dm device

 The reason md needs 'takeover' is because it doesn't have the same
 device/target separation that dm does.

 I was particularly surprised that you wanted to use md/raid0.c  It is no
 better than dm/dm-stripe.c and managing two different stripe engines under
 LVM doesn't see like a good idea.

 Is there some reason that I have missed which makes it easier to use
 'takeover' rather than suspend/resume?

Thanks,
NeilBrown

--Sig_/VV1Zo=yI_+zDXHJ4UvFgOMV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOPy8Dnsnt1WYoG5AQLAxhAAsoCmfndC1Sa4s+OAG2fP6XgNTfdfXZ5V
ftH4zN18uBERDF47wCwCl+cm3ZQ2dGIn9aCW6glOHzDjIhqTknQrkegt+F6JvS/a
VeWKuipn8/4t3EQWxsCW99BZK5P/SvUv5b/Ql1T6Ltj/kfZWufLRG0/zU/bbZeqn
4KP50GjGM1Ub72Cy8EF/ywA5IcCT/ZGt2fGGKs/zuIe3K10608NNnofW3UUW676s
w1J5BPsEzF1TkWdxBCFydxq13/5NE+sWv8tn3rJz9ZY+uIMYrn/Z/KjJiGrR1NNB
heNuaRWx+f1SJYl52Vh6i5pHOE35L0KUkPTp5WPLAtBtHp/ICYpT8vXj+RjD30cn
4DEPbwwFO58lDyorFv8BIYNTW1fTBkcjI8+nIGlMS/YbptUz0pnaEwukhG9Dfuat
KYWmHq1b+YP1CWKTCsnMXP23fzdGN2TkbCuKouhL7BQexypRtXM7CZcwpJ9Rf5rX
y4IhQsfk+UqaSjiW8X+BCoF553FSEMcPreXgh1NRqFwkwyXyiYaj81j96AVNOxVy
gvi5Gxie+tvc+Z30S9snEIdODRmG1Uj1AnYQ0b2Wlrywg/XNiAibcsvFA0/Wem79
rNI5kDJqdagAXQ43YPZeTNv3f93QlvRWD+zIFFFf35HVHFY9lvtzfm/IO5HYvfL/
a3FSxVGhoxo=
=q+AK
-----END PGP SIGNATURE-----

--Sig_/VV1Zo=yI_+zDXHJ4UvFgOMV--
