From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 16/20] libmultipath/print: add "%G -
	foreign" wildcard
Date: Thu, 1 Mar 2018 00:04:09 -0600
Message-ID: <20180301060409.GC14513@octiron.msp.redhat.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-17-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180220132658.22295-17-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 20, 2018 at 02:26:54PM +0100, Martin Wilck wrote:
> This adds a format field to identify foreign maps as such, and
> uses it in default-formatted topology output (generic_style()).
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/generic.c |  4 +++-
>  libmultipath/print.c   | 14 ++++++++++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/generic.c b/libmultipath/generic.c
> index 61cbffb708b6..5f74427cb5b1 100644
> --- a/libmultipath/generic.c
> +++ b/libmultipath/generic.c
> @@ -33,7 +33,9 @@ int generic_style(const struct gen_multipath* gm,
>  	gm->ops->snprint(gm, wwid_buf, sizeof(wwid_buf), 'w');
>  
>  	if (strcmp(alias_buf, wwid_buf))
> -		n = snprintf(buf, len, " (%%w)");
> +		n += snprintf(buf, len, "%%n (%%w) [%%G]");
> +	else
> +		n += snprintf(buf, len, "%%n [%%G]");
>  
>  	return (n < len ? n : len - 1);
>  }
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 9a5a6a2f4ad6..a6ff6b297b3f 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -342,6 +342,12 @@ snprint_multipath_rev (char * buff, size_t len, const struct multipath * mpp)
>  	return snprintf(buff, len, "##");
>  }
>  
> +static int
> +snprint_multipath_foreign (char * buff, size_t len, const struct multipath * pp)
> +{
> +	return snprintf(buff, len, "%s", "--");
> +}
> +
>  static int
>  snprint_action (char * buff, size_t len, const struct multipath * mpp)
>  {
> @@ -621,6 +627,12 @@ snprint_path_checker (char * buff, size_t len, const struct path * pp)
>  	return snprint_str(buff, len, c->name);
>  }
>  
> +static int
> +snprint_path_foreign (char * buff, size_t len, const struct path * pp)
> +{
> +	return snprintf(buff, len, "%s", "--");
> +}
> +
>  struct multipath_data mpd[] = {
>  	{'n', "name",          0, snprint_name},
>  	{'w', "uuid",          0, snprint_multipath_uuid},
> @@ -644,6 +656,7 @@ struct multipath_data mpd[] = {
>  	{'v', "vend",          0, snprint_multipath_vend},
>  	{'p', "prod",          0, snprint_multipath_prod},
>  	{'e', "rev",           0, snprint_multipath_rev},
> +	{'G', "foreign",       0, snprint_multipath_foreign},
>  	{0, NULL, 0 , NULL}
>  };
>  
> @@ -667,6 +680,7 @@ struct path_data pd[] = {
>  	{'R', "host WWPN",     0, snprint_host_wwpn},
>  	{'r', "target WWPN",   0, snprint_tgt_wwpn},
>  	{'a', "host adapter",  0, snprint_host_adapter},
> +	{'G', "foreign",       0, snprint_path_foreign},
>  	{0, NULL, 0 , NULL}
>  };
>  
> -- 
> 2.16.1
