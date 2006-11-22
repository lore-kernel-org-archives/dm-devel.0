From: AJ Lewis <alewis@rackable.com>
Subject: Re: Breaking of large IO requests into small bios by
	device-mapper
Date: Wed, 22 Nov 2006 08:46:54 -0600
Message-ID: <17E0A8E8-E705-459D-B49D-80CDCDDC007B@rackable.com>
References: <1164108010.2925.15.camel@garfield>
	<1164132122.4874.14.camel@linux-cxyg.rtp.netapp.com>
	<1164176719.2956.13.camel@garfield>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: multipart/mixed; boundary="===============1949936417=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1164176719.2956.13.camel@garfield>
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
--===============1949936417==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg=pgp-sha1; boundary="Apple-Mail-15--931462946"
Content-Transfer-Encoding: 7bit

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-15--931462946
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed


On Nov 22, 2006, at 12:25 AM, Kalpak Shah wrote:
> I tried to give a chunksize of 1024 but the lvcreate command  
> segfaults.
> I googled and found that it works only uptil 512K(1024 sectors).

Hrm...lvm2 has supported stripesizes of up to 1TB or so since this  
spring (I think the patch was committed sometime in May).  Make sure  
you have current code.

Regards,
AJ

--Apple-Mail-15--931462946
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (Darwin)

iD8DBQFFZGLen95okVnkz6cRAsluAJ9LR5lt2Ur6hkKQNn4IyaZDkXIljwCdG90G
ToW/bWe1EiOdBM+LizYCbM4=
=2Ji4
-----END PGP SIGNATURE-----

--Apple-Mail-15--931462946--


--===============1949936417==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1949936417==--
