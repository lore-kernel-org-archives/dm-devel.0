From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: [linux-pm] dm-crypt low performance
Date: Mon, 19 Jan 2009 16:04:20 +0530
Message-ID: <200901191604.21584.rrs@researchut.com>
References: <Pine.LNX.4.44L0.0901131456570.27985-100000@iolanthe.rowland.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1315498971=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.44L0.0901131456570.27985-100000@iolanthe.rowland.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alan Stern <stern@rowland.harvard.edu>
Cc: device-mapper development <dm-devel@redhat.com>, linux-pm@lists.linux-foundation.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

--===============1315498971==
Content-Type: multipart/signed; boundary="nextPart26799725.yS5aa6UCHA";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart26799725.yS5aa6UCHA
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Alan,


On Wednesday 14 Jan 2009 01:30:59 Alan Stern wrote:
> >
> > rrs@learner:~$ cat /tmp/lsusb.suspend
> > Bus 005 Device 005: ID 046d:08c6 Logitech, Inc. QuickCam for DELL
> > Notebooks Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> > Bus 004 Device 007: ID 05e3:0702 Genesys Logic, Inc. USB 2.0 IDE Adapter
> > Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 001 Device 005: ID 046d:c00c Logitech, Inc. Optical Wheel Mouse
> > Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>
> Notice that the IDE Adapter is now attached to a 1.1 bus rather than a
> 2.0 bus.  That's why it's running so much slower.
>
> > And here's the usb device listing after a fresh boot.
> >
> > rrs@learner:~$ lsusb
> > Bus 005 Device 004: ID 05e3:0702 Genesys Logic, Inc. USB 2.0 IDE Adapter
> > Bus 005 Device 003: ID 046d:08c6 Logitech, Inc. QuickCam for DELL
> > Notebooks Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> > Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 001 Device 004: ID 046d:c00c Logitech, Inc. Optical Wheel Mouse
> > Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>
> Try building a kernel with CONFIG_USB_DEBUG enabled, and post the dmesg
> log showing what happens during the disconnect, hibernate, resume, and
> reconnect.
>
> You could also try the same thing with no disconnect/reconnect.  Just
> leave the IDE adapter plugged in the whole time.
>

I've been testing the same hardware but unfortunately wasn't able to see th=
e=20
issue back again. One thing to notice is that the laptop has 4 USB ports ou=
t=20
of which 3 are 1.1 and only 1 is 2.0.
The suspected faulty USB HDD Enclosure has 2 cables that I was connecting t=
o,=20
thus ending up connecting them to a 2.0 and 1.1 USB port.

I tried with just 1 port connected to USB 2.0 port and haven't been able to=
=20
reproduce the issue back again yet. :-(
I also wasn't able to reproduce back the old issue with the pattern I=20
mentioned in the previous post (1 cable connected to 1.1 and the other=20
connected to 2.0 port)

I'll keep testing and post to this thread if I find something useful.

Thanks,
Ritesh
=2D-=20
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."


--nextPart26799725.yS5aa6UCHA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl0Vy0ACgkQ4Rhi6gTxMLxqVACfezT3dy0r9BKfkFZSX1RvUOdQ
hrYAmwWNHr3h/gRSr8fu/hiUSjUj0MoM
=LBEW
-----END PGP SIGNATURE-----

--nextPart26799725.yS5aa6UCHA--


--===============1315498971==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1315498971==--
