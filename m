From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH next] Btrfs: fix comparison in __btrfs_map_block()
Date: Sun, 17 Jul 2016 15:51:03 -0500
Message-ID: <578BEFB7.6060209@redhat.com>
References: <1465155145-10812-14-git-send-email-mchristi@redhat.com>
 <1468595001-4270-1-git-send-email-vincent.stehle@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1468595001-4270-1-git-send-email-vincent.stehle@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: =?UTF-8?Q?Vincent_Stehl=c3=a9?= <vincent.stehle@intel.com>, linux-btrfs@vger.kernel.org
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <axboe@fb.com>
List-Id: dm-devel.ids

On 07/15/2016 10:03 AM, Vincent Stehl=C3=A9 wrote:
> Add missing comparison to op in expression, which was forgotten when =
doing
> the REQ_OP transition.
>=20
> Fixes: b3d3fa519905 ("btrfs: update __btrfs_map_block for REQ_OP tran=
sition")
> Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@intel.com>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Jens Axboe <axboe@fb.com>
> ---
>=20
>=20
> Hi,
>=20
> I saw that issue in linux next.
>=20
> Not sure if it is too late to squash the fix with commit b3d3fa519905=
 or
> not...
>=20
> Best regards,
>=20
> Vincent.
>=20
>=20
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a69203a..6ee1e36 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5533,7 +5533,7 @@ static int __btrfs_map_block(struct btrfs_fs_in=
fo *fs_info, int op,
>  		}
> =20
>  	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
> -		if (op =3D=3D REQ_OP_WRITE || REQ_OP_DISCARD ||
> +		if (op =3D=3D REQ_OP_WRITE || op =3D=3D REQ_OP_DISCARD ||
>  		    op =3D=3D REQ_GET_READ_MIRRORS) {
>  			num_stripes =3D map->num_stripes;
>  		} else if (mirror_num) {
>=20


Shoot. Dumb mistake by me. It is of course correct.

Reviewed-by: Mike Christie <mchristi@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
