From: Neil Brown <neilb@suse.de>
Subject: Re: Queuing of dm-raid1 resyncs to the same underlying
	block devices
Date: Fri, 09 Oct 2015 09:01:29 +1100
Message-ID: <87d1wp58au.fsf@notabene.neil.brown.name>
References: <20150926154902.GA2964@alpha.arachsys.com>
	<64020C6E-98B1-4139-A88C-0EC65493CCF9@redhat.com>
	<560BEB14.3060701@redhat.com>
	<87si5vk0rz.fsf@notabene.neil.brown.name>
	<560D0668.50300@redhat.com>
	<87fv1m8ied.fsf@notabene.neil.brown.name>
	<5616586A.4000200@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3132938735685814031=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5616586A.4000200@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3132938735685814031==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

Heinz Mauelshagen <heinzm@redhat.com> writes:
>
> E.g. keep track of the 'new' state of the array and initialize
> parity/syndrome on first access to any given stripe with
> the given performance optimization thereafter.
>
> Metadata kept to housekeep this  could be organized in a b-tree
> (e.g. via dm-persistent-data), thus storing just one node
> defining the whole array as 'new' and splitting the tree up
> as we go and have a size threshold to not allow to grow
> such metadata too big.
>

This idea has come up before.  A bitmap has been suggested.  Simpler
than a B-tree, though not as flexible.
It would allows us to do something more meaningful with Discard: record
that the whole region is invalid.

I don't object to the idea, but I find it hard to get excited about.  It
further blurs the line between the filesystem and the storage device,
and duplicates work between the two.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWFue5AAoJEDnsnt1WYoG5JUkP/iDZW3Ch9v3S0XSCm/a490ux
Zyey5xlTe/77zbreE3VBFruJEUF2TsIDBBEjGTuTuDFSeKPTOe3dgnOBmPeSRZbn
XG5rzDQR91WWFv21AGfthyHOAhm5DrThu70e6vqk1iJuRR32n777Qp9aJJaP80ib
gndpbv8lsuNQPr1c+4CGvq+j8ydgb85HpwMM60UGq+i6hAo6YNYndOsdU7stMr6r
pO3jHo1sTD+xi3oiK2vvhTXKsu72scnn9gj78x4NsJQDaO5exJNnfOPkiBmUHWAL
lVOhGr8XqVJ+l2PwGfUm1lgdmJMcINUOoieupbdWUq90/TEjzGjB8JufZmuiDz8l
YEN0IdEDgC+Fcd3u1aeDOwUURo76sEUocB482zKh7x9pJtDLNe8sx+gZoPUmlUB7
Qa5QXP9z2PLSCY28nwyIWlz0daxmSxvQFwcHcrdiYL8NY+T1Sn3GtlTPGTzwbpsR
NPPl2CX5+ptSacrUkFZMiYvU9ttdlFUXZgnF+iGfaM/lglFktp8qfJUaEQCpfhd+
2fh/JoIvnzml7p1KSEqweeSL4TJ5W2pPuRAsT9Iin1mzkGZ9LqOJHRVDNp7fPstA
d4N2lgGn1Q+gu0u2fHKPEryCsEOPexBzjSb7XettRvcVfNB/bqErOfCgod7wvdXq
spr8axofKs99uIXBVrx6
=ewng
-----END PGP SIGNATURE-----
--=-=-=--


--===============3132938735685814031==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3132938735685814031==--
