From: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: next-20200514 - build issue in
 drivers/md/dm-zoned-target.c
Date: Sat, 16 May 2020 12:07:03 -0700
Message-ID: <1589656023.8524.1.camel@HansenPartnership.com>
References: <367320.1589627953@turing-police>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0314160435874863611=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <367320.1589627953@turing-police>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Valdis =?UTF-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>, Hannes Reinecke <hare@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--===============0314160435874863611==
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Mp2dUCEd7FWpRS+D3bdZ"

--=-Mp2dUCEd7FWpRS+D3bdZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2020-05-16 at 07:19 -0400, Valdis Kl=C4=93tnieks wrote:
> Am seeing a build error in next-0514.  -0420 built OK.
> building a 'make allmodconfig' on a RPi4 in 32-bit mode.
>=20
>   MODPOST 7575 modules
> ERROR: modpost: "__aeabi_uldivmod" [drivers/md/dm-zoned.ko]
> undefined!
>=20
> objdump and 'make drivers/md/dm-zoned-target.s' tells
> me that the problem is in function dmz_fixup_devices(), near here:
>=20
> @ drivers/md/dm-zoned-target.c:806:             reg_dev->nr_zones =3D
> DIV_ROUND_UP(reg_dev->capacity,
>         ldr     r0, [r6, #56]   @ reg_dev_166->capacity, reg_dev_166-
> >capacity
>         adds    r1, r3, r1      @ tmp316, _227, reg_dev_166->capacity
>         adc     r0, r2, r0      @ tmp315, _227, reg_dev_166->capacity
>         subs    r1, r1, #1      @, tmp316,
> @ drivers/md/dm-zoned-target.c:805:             reg_dev-
> >zone_nr_sectors =3D zoned_dev->zone_nr_sectors;
>         strd    r2, [r6, #80]   @, reg_dev,
> @ drivers/md/dm-zoned-target.c:806:             reg_dev->nr_zones =3D
> DIV_ROUND_UP(reg_dev->capacity,
>         sbc     r0, r0, #0      @, tmp315,
>         bl      __aeabi_uldivmod                @
> @ drivers/md/dm-zoned-target.c:806:             reg_dev->nr_zones =3D
> DIV_ROUND_UP(reg_dev->capacity,
>         str     r1, [r6, #64]   @ tmp306, reg_dev_166->nr_zones
>=20
> git blame points at this commit:
>=20
> commit 70978208ec91d798066f4c291bc98ff914bea222
> Author: Hannes Reinecke <hare@suse.de>
> Date:   Mon May 11 10:24:30 2020 +0200
>=20
>     dm zoned: metadata version 2
>=20
> Reverting that commit lets the build complete.

That's because the DIV_ROUND_UP in the patch should actually be
DIV_ROUND_UP_SECTOR_T I think.

James

--=-Mp2dUCEd7FWpRS+D3bdZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iHUEABMIAB0WIQTnYEDbdso9F2cI+arnQslM7pishQUCXsA51wAKCRDnQslM7pis
hZePAP9k+4pgr+O3cOw3dKCULg5dyXP0H/ovz0PjY3NwyCgqYAEA1ghh0wkxUfz4
GB4Svstsox0oy29X7rGUd/p1slLLNZM=
=2NcN
-----END PGP SIGNATURE-----

--=-Mp2dUCEd7FWpRS+D3bdZ--


--===============0314160435874863611==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0314160435874863611==--
