From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: make sure all the hwe attributes
	get merged
Date: Wed, 05 Oct 2011 22:48:33 +0200
Message-ID: <1317847713.32002.5.camel@lapoo.opensvc.com>
References: <20111005041349.GP24133@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111005041349.GP24133@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On mar., 2011-10-04 at 23:13 -0500, Benjamin Marzinski wrote:
> Not all of the hwe attributes were getting merged.  Also,
> multipathd show config was putting an extra set of quotes around the entries
> in the devices section.
> 
Merged.

I haven't checked recently with arrays with whitespaces in their
vendor/product/rev strings. I remember resorting to the value quoting
because of those. Might be worth checking if the parser behaves now
without the quotes.

Regards,
cvaroqui

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c |    4 ++++
>  libmultipath/print.c  |    2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> Index: multipath-tools-110916/libmultipath/config.c
> ===================================================================
> --- multipath-tools-110916.orig/libmultipath/config.c
> +++ multipath-tools-110916/libmultipath/config.c
> @@ -320,6 +320,10 @@ merge_hwe (struct hwentry * dst, struct
>  	merge_num(no_path_retry);
>  	merge_num(minio);
>  	merge_num(minio_rq);
> +	merge_num(pg_timeout);
> +	merge_num(flush_on_last_del);
> +	merge_num(fast_io_fail);
> +	merge_num(dev_loss);
>  
>  	return 0;
>  }
> Index: multipath-tools-110916/libmultipath/print.c
> ===================================================================
> --- multipath-tools-110916.orig/libmultipath/print.c
> +++ multipath-tools-110916/libmultipath/print.c
> @@ -860,7 +860,7 @@ snprint_hwentry (char * buff, int len, s
>  	if (fwd > len)
>  		return len;
>  	iterate_sub_keywords(rootkw, kw, i) {
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k \"%v\"\n",
> +		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
>  				kw, hwe);
>  		if (fwd > len)
>  			return len;
