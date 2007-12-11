From: Scott James Remnant <scott@ubuntu.com>
Subject: Re: [dm-devel] [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 19:09:03 +0000
Message-ID: <1197400143.25082.41.camel@quest>
References: <1197389316.25082.27.camel@quest>
	<3ae72650712110935n20398423t1da02c585a72aead@mail.gmail.com>
	<1197394828.25082.39.camel@quest>
	<20071211175359.GV22311@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1441742927=="
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20071211175359.GV22311@agk.fab.redhat.com>
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


--===============1441742927==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-G+5HLHlybAhkuN7gE2qg"


--=-G+5HLHlybAhkuN7gE2qg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-12-11 at 17:53 +0000, Alasdair G Kergon wrote:

> On Tue, Dec 11, 2007 at 05:40:28PM +0000, Scott James Remnant wrote:
> >  1) udev creates device node and sets permissions
> >  2) devmapper no-ops since it already exists
> =20
> ...because libdevmapper has no notion that something other than itself
> could have created it.  That's a bug, but provided the proper udev
> integration isn't much longer in coming, I shan't bother to fix it.
>=20
That's ok ;)  no pressure on the patch, I just wanted to make sure that
we weren't carrying anything that hadn't at least been shown upstream to
see whether you wanted it or not.

Obviously we'd prefer the long-term solution, our patch is just a short
term one since we're already relying on udev for devmapper work today.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-G+5HLHlybAhkuN7gE2qg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHXuBPSnQiFMl4yK4RAtDzAJ9Vui72N0rV3xguwJW/3jSEoGJ9nQCgi1X0
jQfVVVHD7dCo0ySbTI5rHJE=
=muVQ
-----END PGP SIGNATURE-----

--=-G+5HLHlybAhkuN7gE2qg--



--===============1441742927==
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
--===============1441742927==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-hotplug-devel mailing list  http://linux-hotplug.sourceforge.net
Linux-hotplug-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel

--===============1441742927==--
