From: Scott James Remnant <scott@ubuntu.com>
Subject: Re: [dm-devel] [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 17:40:28 +0000
Message-ID: <1197394828.25082.39.camel@quest>
References: <1197389316.25082.27.camel@quest>
	<3ae72650712110935n20398423t1da02c585a72aead@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1997840292=="
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <3ae72650712110935n20398423t1da02c585a72aead@mail.gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: device-mapper development <dm-devel@redhat.com>, linux-hotplug-devel@lists.sourceforge.net
List-Id: dm-devel.ids


--===============1997840292==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-eBgFRngGENfbeBQWd4ZA"


--=-eBgFRngGENfbeBQWd4ZA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-12-11 at 18:35 +0100, Kay Sievers wrote:

> On Dec 11, 2007 5:08 PM, Scott James Remnant <scott@ubuntu.com> wrote:
> > This is a patch we've written and applied in Ubuntu to improve the
> > atomicity of devmapper device creation somewhat, and avoid races with
> > udev.
>=20
> Without synchronization between libdevmapper and udev, you can't
> predict which one will win in creating the node, right?
> So this patch makes is more likely to create a valid device node, but
> it can still happen, that libdevmapper replaces the udev nodes, which
> is not what we want, right?
>=20
No, the patch is slightly skewed so that udev always wins.  udev will
always adopt an existing device node, adjusting permissions as
necessary.  The patch makes devmapper "back off" if the device node
exists.

So you end up with either:

 1) devmapper creates device node
 2) udev adopts device node and sets permissions

or:

 1) udev creates device node and sets permissions
 2) devmapper no-ops since it already exists

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-eBgFRngGENfbeBQWd4ZA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHXsuMSnQiFMl4yK4RAm5wAJ9h/nRGVGinZ0AHU+6FDUPgmonSsQCeMk7n
T0q4Z7LhTkJaOr056WCOF1c=
=Da8Q
-----END PGP SIGNATURE-----

--=-eBgFRngGENfbeBQWd4ZA--



--===============1997840292==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
SF.Net email is sponsored by: 
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://sourceforge.net/services/buy/index.php
--===============1997840292==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-hotplug-devel mailing list  http://linux-hotplug.sourceforge.net
Linux-hotplug-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel

--===============1997840292==--
