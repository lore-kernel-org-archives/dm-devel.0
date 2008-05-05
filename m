From: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Subject: Re: PROBLEM: powertop reports 8000 spurious interrupts/s from USB disk
Date: Sun, 4 May 2008 17:13:53 -0700
Message-ID: <20080505001353.GF22961@one-eyed-alien.net>
References: <54b33ccd0805040924x55ad1fcesb3c9f50870043312@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7cm2iqirTL37Ot+N"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54b33ccd0805040924x55ad1fcesb3c9f50870043312-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marti Raudsepp <marti-HlJQ7cSfIDjYtjvyW6yDsg@public.gmane.org>
Cc: Linux USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux USB storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, device-mapper list <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids


--7cm2iqirTL37Ot+N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 04, 2008 at 07:24:19PM +0300, Marti Raudsepp wrote:
> Hello,
>=20
> [1.] One line summary of the problem:
> PROBLEM: powertop reports 8000 spurious interrupts/s from USB disk
>=20
> [2.] Full description of the problem/report:
> I am frequently seeing bursts of (exactly) 8000 interrupts per second
> from my USB controller; it seems to be closely related to activity on
> my USB hard disk, although the relation is somewhat vague.
> [...]
> What is obviously visible from the dstat output is that the ~8000
> interrupts keep arriving even when there is no actual activity on the
> disk, and it also causes no noticeable CPU load.

If there is no actual activity, then this is likely not a usb-storage
problem.  It may very well be an HCD problem, however.

You may want to turn on CONFIG_USB_STORAGE_DEBUG and verify that there is,
in fact, no activity to the drive during these events.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I'm a pink gumdrop! How can anything be worse?!!
					-- Erwin
User Friendly, 10/4/1998

--7cm2iqirTL37Ot+N
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIHlFBHL9iwnUZqnkRAjOlAJ9DVzjiYeupgelzUkWRskzCZzyqYQCgrpIz
mR8fPXTyUN/g5jF8yV+rVoc=
=ypAN
-----END PGP SIGNATURE-----

--7cm2iqirTL37Ot+N--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
