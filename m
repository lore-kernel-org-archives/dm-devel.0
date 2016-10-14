From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] add_feature: coredump
Date: Fri, 14 Oct 2016 08:02:25 +0200
Message-ID: <d7d282d7-691b-dbc1-1f44-c4933f9ecb8b@suse.de>
References: <1476410880-7156-1-git-send-email-huang.wei56@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476410880-7156-1-git-send-email-huang.wei56@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: huang.wei56@zte.com.cn, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

On 10/14/2016 04:08 AM, huang.wei56@zte.com.cn wrote:
> From: "wei.huang" <huang.wei56@zte.com.cn>
> =

> Problem:
> when we configure device like vendor is COMPELNT in multipath.conf, multi=
pathd will be coredump.
> =

> Reasons:
> some vonders are not configured features in default_hw. In add_feature, s=
trstr's first parameter *f maybe null.
> =

> Signed-off-by: wei.huang <huang.wei56@zte.com.cn>
> ---
>  libmultipath/structs.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> =

> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index fee58e5..41e142f 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -520,6 +520,20 @@ add_feature (char **f, char *n)
>  	if (!n || *n =3D=3D '0')
>  		return 0;
>  =

> +	/* default feature is null */
> +	if(!*f)
> +	{
> +		l =3D strlen("1 ") + strlen(n) + 1;
> +		t =3D MALLOC(l);
> +		if (!t)
> +			return 1;
> +
> +		snprintf(t, l, "1 %s", n);
> +		*f =3D t;
> +	=

> +		return 0;
> +	}
> +
>  	/* Check if feature is already present */
>  	if (strstr(*f, n))
>  		return 0;
> =

No, that is wrong.
It'll insert a '1' into the string if no features are present.

I have a patch queued for fixing this one up.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
