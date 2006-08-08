From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: geometry of dm devices......
Date: Tue, 08 Aug 2006 15:08:40 -0700
Message-ID: <44D90B68.3010401@us.ibm.com>
References: <1121230D3E3B6B4E9162069832D90A641BC0D2@XYUS-EX22.xyus.xyratex.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0995285102=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1121230D3E3B6B4E9162069832D90A641BC0D2@XYUS-EX22.xyus.xyratex.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============0995285102==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig86204B1D9ACBF0609650DAC0"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig86204B1D9ACBF0609650DAC0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Peter Koutoupis wrote:

>> I understand the HDIO_GETGEO is an unsupported feature to dm=20
>> devices....but under normal practices how would a normal end-user be=20
>> able to obtain such geometry from a raw dm device?  I have read of=20

Wow, I'm late to the game.  If your kernel/software are new enough, you
can set a dm device's geometry via the DM_DEV_SET_GEOMETRY_CMD ioctl.
iirc, the userland equivalent is:

# dmsetup setgeometry /dev/foo cyl head spt start

=2E..after which HDIO_GETGEO should return nonzero values.

You'll need kernel 2.6.16+ and I think the requisite version of dmsetup
is 1.02.  And to my (very limited) knowledge of multipath, geometry is
not set up automatically.

--D


--------------enig86204B1D9ACBF0609650DAC0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFE2Qtta6vRYYgWQuURAi//AJ0VA8rNEMAczSKTXOGfFVWcq9wTswCdG9I/
WH9epT74B82SgF2dfl8dpIk=
=5cMq
-----END PGP SIGNATURE-----

--------------enig86204B1D9ACBF0609650DAC0--


--===============0995285102==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0995285102==--
