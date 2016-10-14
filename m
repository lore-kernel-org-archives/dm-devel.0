From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hwe_regmatch: match error
Date: Fri, 14 Oct 2016 08:00:56 +0200
Message-ID: <f26be52c-adc7-7aa2-eb17-d617bea8ff8c@suse.de>
References: <1476410631-7840-1-git-send-email-huang.wei56@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476410631-7840-1-git-send-email-huang.wei56@zte.com.cn>
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

On 10/14/2016 04:03 AM, huang.wei56@zte.com.cn wrote:
> From: "wei.huang" <huang.wei56@zte.com.cn>
> =

> Problem:
> when we configure a device like vendor, product, revision all null in mul=
tipath.conf, hwe_regmatch always return 0.
> =

> Reasons:
> \!hwe2->vendor, \!hwe2->product and \!hwe2->revision are all true.
> =

> Signed-off-by: wei.huang <huang.wei56@zte.com.cn>
> ---
>  libmultipath/config.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> =

> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index a48b8af..d99cd75 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -80,7 +80,8 @@ hwe_regmatch (struct hwentry *hwe1, struct hwentry *hwe=
2)
>  	    regcomp(&rre, hwe1->revision, REG_EXTENDED|REG_NOSUB))
>  		goto out_pre;
>  =

> -	if ((!hwe1->vendor || !hwe2->vendor ||
> +	if ((hwe2->vendor || hwe2->product || hwe2->revision) &&
> +	    (!hwe1->vendor || !hwe2->vendor ||
>  	     !regexec(&vre, hwe2->vendor, 0, NULL, 0)) &&
>  	    (!hwe1->product || !hwe2->product ||
>  	     !regexec(&pre, hwe2->product, 0, NULL, 0)) &&
> =

Good point.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
