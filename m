From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [BUG?] register_blkdev: failed to get major for device mapper
Date: Mon, 19 Feb 2007 11:01:02 +0100
Message-ID: <200702191101.09192.eike-kernel@sf-tec.de>
References: <200702161437.34063.eike-kernel@sf-tec.de> <20070216160920.27c1167a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1194680.IX0xHVM6LP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750819AbXBSKA5@vger.kernel.org>
In-Reply-To: <20070216160920.27c1167a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--nextPart1194680.IX0xHVM6LP
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Andrew Morton wrote:
> On Fri, 16 Feb 2007 14:37:28 +0100
> Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:

> > I can't bring up my machine with root LVM anymore using x86_64. The same
> > machine from same kernel tree boots fine as x86. The error message is
> > quoted in subject. The tree is at
> > 86a71dbd3e81e8870d0f0e56b87875f57e58222b (for those not using git:
> > somewhere after 2.6.20).
>
> Does this fix it?  I don't see why it would, but this was recently added.

Yes. But now usb complains "unable to get a dynamic major for usb endpoints=
".=20
Nevertheless the USB mouse works.

Eike

--nextPart1194680.IX0xHVM6LP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBF2XVlXKSJPmm5/E4RAgu0AKCnKK3iFYAx5HKDklGw/YYZPzETWACfeZmo
8CJxnNBg3ocSVIJfHOLa2c4=
=FxQF
-----END PGP SIGNATURE-----

--nextPart1194680.IX0xHVM6LP--
