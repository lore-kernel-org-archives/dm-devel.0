From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: Multipath on STK OPENStorage D240
Date: Thu, 4 May 2006 15:37:53 +0200
Message-ID: <20060504133753.GA22657@bogon.ms20.nix>
References: <20060504074119.GB17730@bogon.ms20.nix>
	<20060504123523.GA9269@vienna.egenera.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0150372824=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060504123523.GA9269@vienna.egenera.com>
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


--===============0150372824==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 04, 2006 at 08:35:23AM -0400, Philip R. Auld wrote:
> Hi,
>=20
> Rumor has it that on Thu, May 04, 2006 at 09:41:20AM +0200 Guido Guenther=
 said:
> > Hi,
> > when using path_checker readsector0 on the above machine the box stalls
> > every 5 seconds when checking the currently nonactive path. Same for
> > path_checker tur. Is there a way to avoid this? I'd consider writing a
> > specific checker but am lacking any documentation.
>=20
> This thing is a preferred path array. I can see how readsector0
> is probably the wrong choice of checker. I imagine it causes=20
> a cache flush from the preferred controller. Odd that the tur
> checker has the same behavior. If you want to code something=20
Well, can I check which check is really being used, if not I'll hack
that into the daemon next week? I noticed that typos in multipath.conf
are being silently ignored.=20
Cheers,
 -- Guido

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEWgOwn88szT8+ZCYRAmmIAJ9R1gXtzF/1ykBD3VKZGf9MpMlMBACfSnOm
8baWGCM6loUfYG3bm9LAnx4=
=KNaj
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--


--===============0150372824==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0150372824==--
