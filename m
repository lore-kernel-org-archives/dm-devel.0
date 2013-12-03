From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: Re: [dm-devel] [PATCH] md: fix compiler warning: large integer
 implicitly truncated to unsigned type
Date: Tue, 3 Dec 2013 11:47:19 -0200
Message-ID: <20131203134719.GG24646@oc0268524204.ibm.com>
References: <20131202191220.GA2314@ls3530.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-parisc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131202191220.GA2314@ls3530.box>
Sender: linux-parisc-owner@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Cc: dm-devel@redhat.com, linux-parisc@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Dec 02, 2013 at 08:12:20PM +0100, Helge Deller wrote:
> Compiling a 32bit kernel with CONFIG_LBDAF=3Dn gives this compiler wa=
rning:
> /drivers/md/md.c: In function =E2=80=98super_90_load=E2=80=99:
> /drivers/md/md.c:1068:3: warning: large integer implicitly truncated =
to unsigned type [-Woverflow]
>=20
> Fix it by casting the calculated value to a sector_t type.
>=20
> Signed-off-by: Helge Deller <deller@gmx.de>
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e60cebf..b56f1c7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1065,7 +1065,7 @@ static int super_90_load(struct md_rdev *rdev, =
struct md_rdev *refdev, int minor
>  	 * record this size)
>  	 */
>  	if (rdev->sectors >=3D (2ULL << 32) && sb->level >=3D 1)
> -		rdev->sectors =3D (2ULL << 32) - 2;
> +		rdev->sectors =3D (sector_t) ((2ULL << 32) - 2);
> =20
>  	if (rdev->sectors < ((sector_t)sb->size) * 2 && sb->level >=3D 1)
>  		/* "this cannot possibly happen" ... */
> @@ -1356,7 +1356,7 @@ super_90_rdev_size_change(struct md_rdev *rdev,=
 sector_t num_sectors)
>  	 * 4TB =3D=3D 2^32 KB, or 2*2^32 sectors.
>  	 */
>  	if (num_sectors >=3D (2ULL << 32) && rdev->mddev->level >=3D 1)
> -		num_sectors =3D (2ULL << 32) - 2;
> +		num_sectors =3D (sector_t) ((2ULL << 32) - 2);
>  	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
>  		       rdev->sb_page);
>  	md_super_wait(rdev->mddev);
>=20

It does overflow and get truncated on 32-bit systems without LABDF.
Casting is just hiding the problem! 32-bit systems without LABDF do not
support block devices larger than 2TB, and thus, should not worry about
larger than 4TB devices.

This code should either be ifdef'd to 64-bit or LABDF, or should test
for the size of sector_t. The second option would still need some chang=
e
in the code in order to avoid the warning, or we should don't care abou=
t
them, since testing for num_sectors >=3D (2ULL << 32) should always be
false.

Regards.
Cascardo.

--
To unsubscribe from this list: send the line "unsubscribe linux-parisc"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
