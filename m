From: Neil Brown <neilb@suse.de>
Subject: Re: Queuing of dm-raid1 resyncs to the same underlying
	block devices
Date: Thu, 01 Oct 2015 08:20:00 +1000
Message-ID: <87si5vk0rz.fsf@notabene.neil.brown.name>
References: <20150926154902.GA2964@alpha.arachsys.com>
	<64020C6E-98B1-4139-A88C-0EC65493CCF9@redhat.com>
	<560BEB14.3060701@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6621171273027468280=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <560BEB14.3060701@redhat.com>
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

--===============6621171273027468280==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Heinz Mauelshagen <heinzm@redhat.com> writes:
>
> BTW:
> When you create a raid1/4/5/6/10 LVs _and_ never read what you have not=20
> written,
> "--nosync" can be used anyway in order to avoid the initial=20
> resynchronization load
> on the devices. Any data written in that case will update all=20
> mirrors/raid redundancy data.
>

While this is true for RAID1 and RAID10, and (I think) for the current
implementation of RAID6, it is definitely not true for RAID4/5.

For RAID4/5 a single-block write will be handled by reading
old-data/parity, subtracting the old data from the parity and adding the
new data, then writing out new data/parity.
So if the parity was wrong before, it will be wrong afterwards.

If the device that new data was written to then fails, the data on it is
lost.

So do this for RAID1/10 if you like, but not for other levels.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWDGAQAAoJEDnsnt1WYoG5CZkP/0km9fkMVSBMGyxvp28AFAIw
UWHd4/WiF6tkl2kyev2PMWv+XrfJXVhjBa9QZ1Xk6WxE6mcfKIP+g2SWzqbBTBNe
hUJRH8LDl1t5SGP4JOEg3jDFBlXruboXq6a9JgD/A9SXIAhUAM8c6ChDKyN9Ik/F
EI2rFLjoXrGGnqUYKjNBCfSjm9m9VDo6q/cjIuk9hEE+QSKF3z+JEuwtgrfARgmi
y50HMz7428UDwzd5jT2c+XrGfWcSulrj0Be7xtruGdoGUKVpnooZVfxuWH7NNoFg
JUCBWViy/B6SvYL6GPNbb8IpqU3x80xANnsg/zcwzUsR4z43TntvFhjGBuAlcLr3
jhsTe65oTOpxDEbLrPMjYl9lHqIiVzTOGklxWk/A83qzlHOOuXRFOPJ+NTwH23H8
6aUkfndR5Y4D2medHyRVbkQnALvorzHJ4By+QNTMfmsbhy/Mq2qI7ye+H8cBQm66
ANJb2nVvfqcD57TJMXU/MkymgLoYpZwpd7MScxviTCLEaoQr19cwBRvTtIe61K8W
J3WXkKo6cXMJ7QqDmQJemE37d6hIbQqFHCD1EMVV5gLOnsUFMT6lxI1sKxF5HyC8
1008UhmUUZQYp4/Fcc57kQETcCURszerh8DEGnENDmoSpqJRwUWdki2Wq2M5uZLc
FkinrW8qnW/CZg1EgxPi
=VKHj
-----END PGP SIGNATURE-----
--=-=-=--


--===============6621171273027468280==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6621171273027468280==--
