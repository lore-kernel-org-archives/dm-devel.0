From: Gris Ge <fge@redhat.com>
Subject: [PATCH V5] multipath-tools: Introducing multipath C API
Date: Fri, 24 Feb 2017 21:07:46 +0800
Message-ID: <20170224130428.GA6272@redhat.com>
References: <1453953120-7023-1-git-send-email-fge@redhat.com>
	<20160812121240.47796-1-fge@redhat.com>
	<20160812121240.47796-5-fge@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8637345956706721528=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160812121240.47796-5-fge@redhat.com>
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


--===============8637345956706721528==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NKoe5XOeduwbEQHU"
Content-Disposition: inline


--NKoe5XOeduwbEQHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guys,

Just sent V5 patches for C API, it got eaten again by SPAM filter[1].

Please check the patch via:
    https://github.com/cathay4t/multipath-tools/commit/c3b39f35bb2ce17ba962=
364e33f93f7c7900823b

Changes since V4:

 * Only a simple patch file now, as other prerequisite patches got merged in
   other thread[2].
 * Add new function dmmp_mpath_kdev_name_get() to query the '/dev/dm-01' for
   mpath.
 * Updated manpages.
 * Rebased to current master ea4367159d32444e48a409a4f1c4f18324b737a9.


This API does not include all information exposed by JSON API yet, but just
include basic informations for an initial review. I will send more patches =
to
expose the rest informations afterwords.

Thank you.

Best regards.

[1]: https://www.redhat.com/archives/dm-devel/2016-July/msg00060.html
[2]: https://www.redhat.com/archives/dm-devel/2017-January/msg00205.html
--=20
Gris Ge

--NKoe5XOeduwbEQHU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJYsDAiAAoJEGzN5Y/kHij/FIoQAIgBC5lrxi2Lik7c+TUbq8y7
2YM7Uc6YAfFUSsafxLPfgbRWvoElLwGR1/nLnQCjdgMU2tCrlCnoQmDhWCadRGIR
lI/SNGDTloisHmGzQJ6SfY1uWizuNTVwnCLCIWZhLrrkPx3x324FZRrxmuxq/blX
109egpRtb2+s2YBZ/dwQFy7QCeC4qXesPbf0G3TtspAE8/RLhFky631fr2GhFc23
/PRnKaxnzn/u5MoZwpAnKc50svZHpCj5Oq9dfN/JQrXurLXivutp/YNFMcZPwQKP
3pV716imzCNutGBcgYcjW+hO8DZ1E/urROCvSHrmk1/ZOw6mHB6LufSD1/Wm0AQS
LakNgTlI1DVyvIGHMD1YrjVg38bVw4lzNVoReivqd7ZYwvzwt+jxVqJYjT/aR/Ci
SynPYTD2C5W5+9+2XVjAp6gIJ7yV+HyOauDULKxEln2Ja5F5TiSWjD3Fyw/Clqnx
53RYAlmBSP7CzcqeyyglenXbUZ9jOzDwc/UPVrYtovg+cu53A/Rolwk5XaARsjOY
HMft4v5gF675h5pd4vSezUmzeeFpS2JElIoGM5eDYZD7+VQ1DGSDPwd/4ysq7+lG
yyr4MjoFK4amV107eetikwnW1n4hCHSev+v2dElfr8jtGwuiqw+f3nT60tYpURxa
xV6s+dWC1u2NO3dIwQ5Y
=B8LP
-----END PGP SIGNATURE-----

--NKoe5XOeduwbEQHU--


--===============8637345956706721528==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8637345956706721528==--
