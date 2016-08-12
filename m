From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH V7 0/4] multipath: Introducing multipath C API
Date: Fri, 12 Aug 2016 21:26:06 +0800
Message-ID: <20160812132606.GA67525@redhat.com>
References: <1453953120-7023-1-git-send-email-fge@redhat.com>
	<20160812121240.47796-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3127223664680801409=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160812121240.47796-1-fge@redhat.com>
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


--===============3127223664680801409==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 12, 2016 at 08:12:36PM +0800, Gris Ge wrote:
> Changes since V6:
>  * Add new patch(1/4) to block SIGPIPE when write() in libmpathcmd.
>  * Patch 2/4 does not have 'send_packet_daemon_only()' as SIGPIPE already
>    handled by libmpathcmd.
The mail list system drop patch 4/4 again.
It could be found via
https://github.com/cathay4t/multipath-tools/commit/3175188cc0a92946a673dd63=
ec7482a8b36548d5.patch

--=20
Gris Ge

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXrc5tAAoJEGzN5Y/kHij/Q+QP/RY6dbM7iYVnbshudIfBJl80
0OJ3T8Sw7BaJwJlhMzgzwrs9aPGemhAwnefJGMnVf91LW/FObQW20ysfjg2ETGB8
xA5ERUp2+/g4RM4+71mqdoiSgO4LqrPMv5o6kcfiQbLlaxyXs+hNCfykbtuXQBKP
r2pBT+VTOqx15S0QAGxGWSquXVYzwsG5oGefRP42l7FSpWx/izA/OB7s/IezIt42
tBvtbZJZCusH18bMHe9zdjRlo+lmjksSy/fequJeEsR3DwcpOlFKKrYH3jXqKqah
hZWVgRx2Tih2JEJUGKR5GkG335BRO//oF7m3HVa8679kUkX+8C29PONXgBP06w/7
+LoYoigZYTPUvMmf3CxHTdi30AdZFkIfiQN2LasFuSQL1Az2ERh0RkCXYDBNb6JA
YQHT2PpAoR6Mi0pBZa0JtYw6EYbK+XxAeixCDI524kNwgAfZlsoFkKzdwAa1dNOd
fXHeC9Wl3NqB5an1Zkmsae9xNK0bXwNINYG8aEcfsFoayLjClTEZVQi7rs4Iq87e
KTDcYvWq84FIyF2NCZD6HglvllCAwqJ4w0rlw6LKckYoM5j9GtXd+tvO+xH0gW+B
+Bo2tsRVh0mg/Ts936ekHfzM8ZuD6ZlhOcjstw40ns9nRsQjaMUbeF/5gmXG3kF7
7ow7QKdLsruvS2z+0B5P
=MXrs
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--


--===============3127223664680801409==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3127223664680801409==--
