From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] dm: verity target
Date: Fri, 16 Sep 2011 13:54:07 -0400
Message-ID: <59032.1316195647@turing-police.cc.vt.edu>
References: <1316112359-6085-1-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316195647_55056P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: Your message of "Thu, 15 Sep 2011 11:45:59 PDT."
             <1316112359-6085-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mandeep Singh Baines <msb@chromium.org>
Cc: dm-devel@redhat.com, Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--==_Exmh_1316195647_55056P
Content-Type: text/plain; charset=us-ascii

On Thu, 15 Sep 2011 11:45:59 PDT, Mandeep Singh Baines said:
> The verity target provides transparent integrity checking of block devices
> using a cryptographic digest.

I just had this mental image of Dr Henry Jones saying: "But in Latin, verify is
spelled with an f..." ;)

Might want to add something to device-mapper/dm-verity.txt explaining
where the name came from and that it's *not* a typo?

--==_Exmh_1316195647_55056P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOc40/cC3lWbTT17ARAlK+AJ96GzzZqE0XRLQrD5o7WPkv2HFZiQCeK8PD
2R1jQZha0QSRetnPI+wPOzM=
=SWTW
-----END PGP SIGNATURE-----

--==_Exmh_1316195647_55056P--
