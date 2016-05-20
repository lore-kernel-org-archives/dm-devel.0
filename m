From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?=
	<marmarek@invisiblethingslab.com>
Subject: discard on snapshot-origin target
Date: Fri, 20 May 2016 17:08:26 +0200
Message-ID: <20160520150826.GG1171@mail-itl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8072187969298816350=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============8072187969298816350==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nF5CeAc4QNWHTmva"
Content-Disposition: inline


--nF5CeAc4QNWHTmva
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Is it possible to enable DISCARD support for snapshot-origin target?
Currently it returns EOPNOTSUPP even if underlying device does support
it. I know there are some cases when it isn't desirable (for example
mkfs.ext4 discards the entire device, which would trigger copyout to the
snapshot), but I can live with that.=20

Or, if possible, better to prevent that copyout if discarded block(s)
were zeroed already. Which would handle the case of mkfs.ext4 on empty,
zeroed device.

I see that it may undesired in some cases, so maybe some configurable
option? Like module parameter or so?

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?

--nF5CeAc4QNWHTmva
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXPyhsAAoJENuP0xzK19csCv0IAIpcOvFcHybzLXoDzJGXY2E+
1yVsmF7vVl7BNcBomiL7HRtDjdJiKhDV2o887vZhFt+jOkuYW+//Z05jo+leZ+qC
1kGy6dB5Lp7Ev6VyMOXJ9/2KUYUeMFXdZlY5nMIPkftECVh1XmLesuTTRvyWM2+M
GmrfEYBHKh5EQgSYx9Lbxwk5UonmQ0X4eEbGvJoRR4BxEE/g/fQVVnA78oZc4jR7
VSO+OUc5NJN8ikW/AymY+H40sgT+eQyU+j8t1aA2B5URStpFXV/M8es8szTFTlTW
g/YVmcJKC6/Tv4w0ykRABQNaP+ui55o7YcDgHAD7/pOoUuD70ieJBGn3VPsXihA=
=nf7y
-----END PGP SIGNATURE-----

--nF5CeAc4QNWHTmva--


--===============8072187969298816350==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8072187969298816350==--
