From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [BUG?] register_blkdev: failed to get major for device mapper
Date: Mon, 19 Feb 2007 15:39:38 +0100
Message-ID: <200702191539.38902.eike-kernel@sf-tec.de>
References: <200702161437.34063.eike-kernel@sf-tec.de> <20070219022955.f734006a.akpm@linux-foundation.org> <200702191340.56855.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2579341.ko4tmrKDGn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932296AbXBSOj3@vger.kernel.org>
In-Reply-To: <200702191340.56855.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--nextPart2579341.ko4tmrKDGn
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> Andrew Morton wrote:
> > On Mon, 19 Feb 2007 11:01:02 +0100 Rolf Eike Beer <eike-kernel@sf-tec.d=
e>
>
> wrote:
> > > Andrew Morton wrote:
> > > > On Fri, 16 Feb 2007 14:37:28 +0100
> > > >
> > > > Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
> > > > > I can't bring up my machine with root LVM anymore using x86_64. T=
he
> > > > > same machine from same kernel tree boots fine as x86. The error
> > > > > message is quoted in subject. The tree is at
> > > > > 86a71dbd3e81e8870d0f0e56b87875f57e58222b (for those not using git:
> > > > > somewhere after 2.6.20).
> > > >
> > > > Does this fix it?  I don't see why it would, but this was recently
> > > > added.
> > >
> > > Yes. But now usb complains "unable to get a dynamic major for usb
> > > endpoints". Nevertheless the USB mouse works.
> >
> > That's just nutty.
> >
> > Can you add this, see what it says just prior to that "unable to get a
> > dynamic major for usb endpoints"?
>
> It's totally weird. It prints the "skipped" message for every (!) number,
> not just for the blacklisted ones. And I've triple checked that I don't
> have missed the '{'.
>
> Compiler is SuSEs 4.1.0 from their 10.1. I remember some rumors that this
> thing is just broken?

Ok, I'm using the compiler from SuSE 10.2 now and it works. Time that we=20
refuse to build if it's a 4.1.0.

Sorry for the noise.

Eike

--nextPart2579341.ko4tmrKDGn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBF2baqXKSJPmm5/E4RAivYAJ46yLICxguBolPTvBCYzw0oe3MMbgCfVLVv
Gh0fimmsKAdiIK3aEPji4MQ=
=6ZtN
-----END PGP SIGNATURE-----

--nextPart2579341.ko4tmrKDGn--
