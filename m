From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Re: [PATCH] User-configurable HDIO_GETGEO for dm
	volumes
Date: Wed, 22 Feb 2006 16:46:57 -0800
Message-ID: <1140655617.3300.14.camel@localhost.localdomain>
References: <43F38D83.3040702@us.ibm.com>
	<20060217151650.GC12173@agk.surrey.redhat.com>
	<43F6718E.2000908@us.ibm.com>
	<20060222223240.GI31641@agk.surrey.redhat.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2021390362=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060222223240.GI31641@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Chris McDermott <lcm@us.ibm.com>
List-Id: dm-devel.ids


--===============2021390362==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-GTv5dv728OERUgSpHGy5"


--=-GTv5dv728OERUgSpHGy5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Looks good and tests ok, with one issue: I still have a preference for
returning -ENOTTY over 0/0/0 when dm doesn't know the geometry.  That
said, most programs will see the zero cylinder count and make a guess,
so it probably doesn't matter.

If you're happy with it, I say put it in.  Thanks for the cleanup, by
the way!

--Darrick

On Wed, 2006-02-22 at 22:32 +0000, Alasdair G Kergon wrote:
> On Fri, Feb 17, 2006 at 04:59:58PM -0800, Darrick J. Wong wrote:
> > Here's the third revision, with the geometry pushed into mapped_device=20
> > as well as fixes for the problems that you pointed out wrt string=20
> > passing, lack of warning messages, etc.  Thanks for all the great feedb=
ack!
> =20
> Almost there now: how does the version below look?
> Corresponding userspace changes are in device-mapper CVS.
>=20
> Alasdair

--=-GTv5dv728OERUgSpHGy5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)

iD8DBQBD/QYBa6vRYYgWQuURAlf6AJwNhR0VXufdv6531tObm6ykrdCfEQCgnJGv
W3kVAjEUCAZ2SM1k/RTgDSM=
=mVId
-----END PGP SIGNATURE-----

--=-GTv5dv728OERUgSpHGy5--


--===============2021390362==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2021390362==--
