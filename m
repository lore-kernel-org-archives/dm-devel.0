From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 1/3] PM suspend/hibernate: Call notifier after freezing processes
Date: Thu, 9 Apr 2015 18:55:01 +0200
Message-ID: <201504091855.01927@pali>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com> <201504090836.57365@pali> <1856560.gNHsvxOS0D@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1969028.4ke9EkrGWW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1856560.gNHsvxOS0D@vostro.rjw.lan>
Sender: linux-pm-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

--nextPart1969028.4ke9EkrGWW
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 09 April 2015 19:13:55 Rafael J. Wysocki wrote:
> On Thursday, April 09, 2015 08:36:57 AM Pali Roh=C3=A1r wrote:
> > --nextPart2566388.gOmNIJrIqI
> > Content-Type: Text/Plain;
> >=20
> >   charset=3D"utf-8"
> >=20
> > Content-Transfer-Encoding: quoted-printable
> >=20
> > On Thursday 09 April 2015 02:28:41 Rafael J. Wysocki wrote:
> > > On Sunday, April 05, 2015 07:20:17 PM Pali Roh=3DC3=3DA1r
> > > wrote:
> > > > To prevent race conditions on userspace processes with
> > > > I/O some taks must be called after processes are
> > > > freezed. This patch adds new events which are delivered
> > > > by
> > > > pm_notifier_call_chain() after freezing processes when
> > > > doing suspend or hibernate action.
> > > >
> > > >=3D20
> > > >
> > > > Signed-off-by: Pali Roh=3DC3=3DA1r <pali.rohar@gmail.com>
> > >
> > >=3D20
> > >
> > > Please don't add more notifiers.  Just call whatever you
> > > need directly from where you need to call that.
> > >
> > >=3D20
> > >
> > > If that is device-related, try to use device PM
> > > suspend/hibernate callbacks instead.
> > >
> > >=3D20
> >=20
> > Hi! It is not possible to use any exiting pm notifiers! This
> > is=3D20 reason why I added new ones. As I wrote wiping dm
> > crypt keys must=3D20 be done *after* userspace processes are
> > freezed to prevent race=3D20 conditions...
>=20
> I'm not talking about using the existing notifiers.  I'm
> talking about calling the function you need to call directly
> from a suitable place in the system suspend code.

I need to wipe crypto keys from dm-crypt module. That module can=20
be compiled as external .ko file and so kernel cannot call=20
directly needed function. This is reason why I'm adding new=20
notifier event.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1969028.4ke9EkrGWW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlUmruUACgkQi/DJPQPkQ1IhZgCgvM2Jf7nmY89Mr0DEAObogRFI
b3AAnjvhsMuF1Momnm4dmBQwyuq0+Yvr
=1tgs
-----END PGP SIGNATURE-----

--nextPart1969028.4ke9EkrGWW--
