From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [BUG?] register_blkdev: failed to get major for device mapper
Date: Mon, 19 Feb 2007 13:40:56 +0100
Message-ID: <200702191340.56855.eike-kernel@sf-tec.de>
References: <200702161437.34063.eike-kernel@sf-tec.de> <200702191101.09192.eike-kernel@sf-tec.de> <20070219022955.f734006a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1609073.x1QvuiNTH3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932196AbXBSMkm@vger.kernel.org>
In-Reply-To: <20070219022955.f734006a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--nextPart1609073.x1QvuiNTH3
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Andrew Morton wrote:
> On Mon, 19 Feb 2007 11:01:02 +0100 Rolf Eike Beer <eike-kernel@sf-tec.de>=
=20
wrote:
> > Andrew Morton wrote:
> > > On Fri, 16 Feb 2007 14:37:28 +0100
> > >
> > > Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
> > > > I can't bring up my machine with root LVM anymore using x86_64. The
> > > > same machine from same kernel tree boots fine as x86. The error
> > > > message is quoted in subject. The tree is at
> > > > 86a71dbd3e81e8870d0f0e56b87875f57e58222b (for those not using git:
> > > > somewhere after 2.6.20).
> > >
> > > Does this fix it?  I don't see why it would, but this was recently
> > > added.
> >
> > Yes. But now usb complains "unable to get a dynamic major for usb
> > endpoints". Nevertheless the USB mouse works.
>
> That's just nutty.
>
> Can you add this, see what it says just prior to that "unable to get a
> dynamic major for usb endpoints"?

It's totally weird. It prints the "skipped" message for every (!) number, n=
ot=20
just for the blacklisted ones. And I've triple checked that I don't have=20
missed the '{'.

Compiler is SuSEs 4.1.0 from their 10.1. I remember some rumors that this=20
thing is just broken?

Eike

--nextPart1609073.x1QvuiNTH3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBF2ZrYXKSJPmm5/E4RAoMGAJ94m5Ka7/TsNTeQRK7EFgQcRQsXsgCgkMxE
UgZvTojaplFpDnbJIAqHj5o=
=iMBq
-----END PGP SIGNATURE-----

--nextPart1609073.x1QvuiNTH3--
