From: Horia Geanta <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam - update xts sector size for large input
 length
Date: Mon, 2 Mar 2020 09:36:32 +0000
Message-ID: <VI1PR0402MB34851CC70E092F598E9BF32298E70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200228104648.18898-1-andrei.botila@oss.nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>, Aymen Sghaier <aymen.sghaier@nxp.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrei Botila <andrei.botila@nxp.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

+ dm-devel=0A=
=0A=
On 2/28/2020 12:47 PM, Andrei Botila (OSS) wrote:=0A=
> From: Andrei Botila <andrei.botila@nxp.com>=0A=
> =0A=
> Since in the software implementation of XTS-AES there is=0A=
> no notion of sector every input length is processed the same way.=0A=
> CAAM implementation has the notion of sector which causes different=0A=
> results between the software implementation and the one in CAAM=0A=
> for input lengths bigger than 512 bytes.=0A=
> Increase sector size to maximum value on 16 bits.=0A=
> =0A=
> Fixes: c6415a6016bf ("crypto: caam - add support for acipher xts(aes)")=
=0A=
> Cc: <stable@vger.kernel.org> # v4.12+=0A=
> Signed-off-by: Andrei Botila <andrei.botila@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
> ---=0A=
> This patch needs to be applied from v4.12+ because dm-crypt has added sup=
port=0A=
> for 4K sector size at that version. The commit was=0A=
> 8f0009a225171 ("dm-crypt: optionally support larger encryption sector siz=
e").=0A=
> =0A=
>  drivers/crypto/caam/caamalg_desc.c | 16 ++++++++++++++--=0A=
>  1 file changed, 14 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caa=
malg_desc.c=0A=
> index aa9ccca67045..8ebbbd28b1f7 100644=0A=
> --- a/drivers/crypto/caam/caamalg_desc.c=0A=
> +++ b/drivers/crypto/caam/caamalg_desc.c=0A=
> @@ -1518,7 +1518,13 @@ EXPORT_SYMBOL(cnstr_shdsc_skcipher_decap);=0A=
>   */=0A=
>  void cnstr_shdsc_xts_skcipher_encap(u32 * const desc, struct alginfo *cd=
ata)=0A=
>  {=0A=
> -	__be64 sector_size =3D cpu_to_be64(512);=0A=
> +	/*=0A=
> +	 * Set sector size to a big value, practically disabling=0A=
> +	 * sector size segmentation in xts implementation. We cannot=0A=
> +	 * take full advantage of this HW feature with existing=0A=
> +	 * crypto API / dm-crypt SW architecture.=0A=
> +	 */=0A=
> +	__be64 sector_size =3D cpu_to_be64(BIT(15));=0A=
>  	u32 *key_jump_cmd;=0A=
>  =0A=
>  	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);=0A=
> @@ -1571,7 +1577,13 @@ EXPORT_SYMBOL(cnstr_shdsc_xts_skcipher_encap);=0A=
>   */=0A=
>  void cnstr_shdsc_xts_skcipher_decap(u32 * const desc, struct alginfo *cd=
ata)=0A=
>  {=0A=
> -	__be64 sector_size =3D cpu_to_be64(512);=0A=
> +	/*=0A=
> +	 * Set sector size to a big value, practically disabling=0A=
> +	 * sector size segmentation in xts implementation. We cannot=0A=
> +	 * take full advantage of this HW feature with existing=0A=
> +	 * crypto API / dm-crypt SW architecture.=0A=
> +	 */=0A=
> +	__be64 sector_size =3D cpu_to_be64(BIT(15));=0A=
>  	u32 *key_jump_cmd;=0A=
>  =0A=
>  	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);=0A=
> =0A=
=0A=
