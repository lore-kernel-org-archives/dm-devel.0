From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 2/6] kpartx: fix -Wsign-compare error
Date: Thu, 6 Aug 2020 10:30:30 +0000
Message-ID: <6a8a2544bf10ae6e4d61bf93f8026216c3e90782.camel@suse.com>
References: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
	<1595877868-5595-3-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1595877868-5595-3-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <32A8E024AC962A4FB5709ADBF018860D@eurprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2020-07-27 at 14:24 -0500, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  kpartx/kpartx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index c24ad6d9..653ce0c8 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -738,7 +738,7 @@ struct block {
>  /* blknr is always in 512 byte blocks */
>  char *
>  getblock (int fd, unsigned int blknr) {
> -=09unsigned int secsz =3D get_sector_size(fd);
> +=09int secsz =3D get_sector_size(fd);
>  =09unsigned int blks_per_sec =3D secsz / 512;
>  =09unsigned int secnr =3D blknr / blks_per_sec;
>  =09unsigned int blk_off =3D (blknr % blks_per_sec) * 512;

I was wondering why I didn't see this one. Turns out that it occurs
only for 32bit compilations. It looks like sort of an overzealous
compiler warning to me, as it's only about a "!=3D" comparison that can
hardly produce a wrong or unexpected result.

Btw, not that it would matter much, but the value of he BLKSSZGET ioctl
is actually unsigned.

Anyway, ack.

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
