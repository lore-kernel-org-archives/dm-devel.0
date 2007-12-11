From: Scott James Remnant <scott@ubuntu.com>
Subject: Re: [dm-devel] [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 16:42:13 +0000
Message-ID: <1197391333.25082.31.camel@quest>
References: <1197389316.25082.27.camel@quest>
	<20071211162538.GR22311@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0294927021=="
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20071211162538.GR22311@agk.fab.redhat.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-hotplug-devel@lists.sourceforge.net
List-Id: dm-devel.ids


--===============0294927021==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-mKO8F/ZsplRPR4FoW1dN"


--=-mKO8F/ZsplRPR4FoW1dN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-12-11 at 16:25 +0000, Alasdair G Kergon wrote:

> On Tue, Dec 11, 2007 at 04:08:36PM +0000, Scott James Remnant wrote:
> > This is a patch we've written and applied in Ubuntu to improve the
> > atomicity of devmapper device creation somewhat, and avoid races with
> > udev.
> =20
> BTW I won't be applying this upstream - these nodes are designed to be
> managed by libdevmapper not udev so it's not relevant.  I'm awaiting
> patches that have been promised to an agreed design that will provide
> for correct libdevmapper/udev integration without races/deadlocks etc.
>=20
What is that agreed design?

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-mKO8F/ZsplRPR4FoW1dN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHXr3lSnQiFMl4yK4RAtsBAJ48p0RIaeCLL95LzHgxzkcBFMwhLwCgktYR
db+yDC6kstxAlizv/9pxM0A=
=i7Uv
-----END PGP SIGNATURE-----

--=-mKO8F/ZsplRPR4FoW1dN--



--===============0294927021==
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
--===============0294927021==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-hotplug-devel mailing list  http://linux-hotplug.sourceforge.net
Linux-hotplug-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel

--===============0294927021==--
