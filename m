From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0 of 5] MD:  prepare RAID10 for inclusion in dm-raid.c
Date: Wed, 4 Jul 2012 11:13:20 +1000
Message-ID: <20120704111320.792a56aa@notabene.brown>
References: <1340700259.19015.10.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gqh__22O0FEUZ_TNGV5cy7n"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1340700259.19015.10.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/gqh__22O0FEUZ_TNGV5cy7n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Jun 2012 03:44:19 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
> Here's a couple patches that are necessary for MD before I can add
> RAID10 to the list of supported personalities through dm-raid.c:
> 	1) md-raid10-rename-mirror_info.patch
> 	2) md-raid1-rename-mirror_info.patch
> 	3) md-move-IO_BLOCKED-to-md_h.patch
> 	4) md-export-md_raid10_congested.patch
>=20
> I'll send the patch that enables raid10 as a separate patch that depends
> on this patch set and a couple of DM patches.
>=20
>  brassow
>=20

All 4 applied, thanks.

NeilBrown

--Sig_/gqh__22O0FEUZ_TNGV5cy7n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/OYsDnsnt1WYoG5AQKPAg/8DqKQWJQdN4OR+KqtUdju4bvCjppNttep
cIbHLbQX7/1sVByRTWc2+rt+RhUHy5tWZVP5NBg4eEg8tiZv+KbvcGSYBMrHhr1i
YH8bPDe/3Bgd1mwAJxdqhjJpCGxjZeVzWqk6iTWhEfvmhmMxu66kRnIVlul1ZYRD
lmVw5rwKgYtfCnhatx2gEkm+KoI0p9/cklD405YxC44tDldjd7WkMep1hIC7eOlM
AgIngBgi3ZpXl4oJjplicG7EiyUwhVXVUKRNfD9EKLhNorDjA3gK5n6jPFBaYz8B
xMQ3EEO6WOrEilJUQr4oj5XPNrZnoTVXTrB2E4ThjEyTsgLQ7TgOw+Z6L+bZeavR
JtcjC5MuLXOvP0aVSxfZiGX0oY5X23yqc2QsXrWYQUCOcwgAvbeaoZb76q3FoBc4
DMVYHFyaRaZOaw/NOEaNg/gUTutY9DxaKQLuwxZ6Sj3kJuvLkZBvaVJclahEQCRq
R8leod42yp8FsBBxi/+jzukKvGbpO42aY1gAG/LqUmkkxN3OcLG3MEnNIOc9pr23
fyHPnxQvglqkdJlGRB4RQ96cajYu0kwOtmOkeRl/Wgks+DgvNsKLl3UvijTdZBgy
Hv+GAmlo/OUWpJyGXU/2c8FQ4x3Rewq+ygPiy3Pf2fouqxMiG3lYSvIndxaQbmNO
fWOU8ZkAjZM=
=rwFy
-----END PGP SIGNATURE-----

--Sig_/gqh__22O0FEUZ_TNGV5cy7n--
