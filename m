From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] add_feature: coredump
Date: Fri, 28 Oct 2016 08:14:22 -0700
Message-ID: <eadb5017-c276-b304-f95d-793b41d32a1f@sandisk.com>
References: <1476410880-7156-1-git-send-email-huang.wei56@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
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

On 10/13/2016 07:08 PM, huang.wei56@zte.com.cn wrote:
> From: "wei.huang" <huang.wei56@zte.com.cn>
>
> Problem:
> when we configure device like vendor is COMPELNT in multipath.conf, multipathd will be coredump.
>
> Reasons:
> some vonders are not configured features in default_hw. In add_feature, strstr's first parameter *f maybe null.
>
> Signed-off-by: wei.huang <huang.wei56@zte.com.cn>
> ---
>  libmultipath/structs.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index fee58e5..41e142f 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -520,6 +520,20 @@ add_feature (char **f, char *n)
>  	if (!n || *n == '0')
>  		return 0;
>
> +	/* default feature is null */
> +	if(!*f)
> +	{
> +		l = strlen("1 ") + strlen(n) + 1;
> +		t = MALLOC(l);
> +		if (!t)
> +			return 1;
> +
> +		snprintf(t, l, "1 %s", n);
> +		*f = t;
> +	
> +		return 0;
> +	}
> +
>  	/* Check if feature is already present */
>  	if (strstr(*f, n))
>  		return 0;
>

Hello Wei Huang,

Please use asprintf() instead of open coding it and please also make the 
title of your patch comprehensible. Your patch avoids that multipathd 
triggers a core dump for a certain vendor name but that's not clear from 
the "add_feature: coredump".

Thanks,

Bart.
