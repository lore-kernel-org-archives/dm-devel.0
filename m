From: Scott James Remnant <scott@ubuntu.com>
Subject: Re: [dm-devel] [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 17:18:46 +0000
Message-ID: <1197393526.25082.36.camel@quest>
References: <1197389316.25082.27.camel@quest>
	<20071211162538.GR22311@agk.fab.redhat.com>
	<1197391333.25082.31.camel@quest>
	<20071211170352.GS22311@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0217578513=="
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20071211170352.GS22311@agk.fab.redhat.com>
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


--===============0217578513==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-7C0CT7B14+IA/MOZEgu+"


--=-7C0CT7B14+IA/MOZEgu+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-12-11 at 17:03 +0000, Alasdair G Kergon wrote:

> On Tue, Dec 11, 2007 at 04:42:13PM +0000, Scott James Remnant wrote:
> > What is that agreed design?
> =20
> In simple terms:
>=20
> - udev takes over full responsibility for creating nodes
> [this will probably be a ./configure option]
>=20
Excellent, this is what we've wanted for a while.

> - udev provides interface we use to wait until it has finished
> processing all the outstanding requests we sent it.
>=20
What's this interface?

I had a proposed patch that made udev write its sequence number to the
kernel, and thus allowed any kobject add event to have a "bottom half"
that could happen when udev had finished.  The idea was that the
existing ioctls could then just block.

The other patch we tried a couple of releases ago was have devmapper
spin until udev had caught up.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-7C0CT7B14+IA/MOZEgu+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHXsZ2SnQiFMl4yK4RAkcRAKCn15opImCh7B646NzUxUTrfmNH8QCfaAn7
typHzygclsHGWQZ/ueNkv90=
=dAin
-----END PGP SIGNATURE-----

--=-7C0CT7B14+IA/MOZEgu+--



--===============0217578513==
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
--===============0217578513==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-hotplug-devel mailing list  http://linux-hotplug.sourceforge.net
Linux-hotplug-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel

--===============0217578513==--
