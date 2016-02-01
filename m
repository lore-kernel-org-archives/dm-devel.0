From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/3] add %g format specifier to 'multipathd
 show paths format' command
Date: Mon, 1 Feb 2016 11:36:11 -0600
Message-ID: <20160201173611.GG24960@octiron.msp.redhat.com>
References: <1454331207-380-1-git-send-email-tgill@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1454331207-380-1-git-send-email-tgill@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Todd Gill <tgill@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 01, 2016 at 07:53:25AM -0500, Todd Gill wrote:
> The %g specifier will print the group number of the path when used with
> multipathd show paths format.

The set looks good to me.

-Ben

> 
> Signed-off-by: Todd Gill <tgill@redhat.com>
> ---
>  libmultipath/print.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 6215d0b..332327a 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -293,6 +293,12 @@ snprint_path_uuid (char * buff, size_t len, struct path * pp)
>  	return snprint_str(buff, len, pp->wwid);
>  }
>  
> +static int snprint_path_groupnumber(char * buff, size_t len, struct path * pp)
> +{
> +	return snprint_int(buff, len, pp->pgindex);
> +}
> +
> +
>  static int
>  snprint_hcil (char * buff, size_t len, struct path * pp)
>  {
> @@ -576,6 +582,7 @@ struct path_data pd[] = {
>  	{'i', "hcil",          0, snprint_hcil},
>  	{'d', "dev",           0, snprint_dev},
>  	{'D', "dev_t",         0, snprint_dev_t},
> +	{'g', "group",         0, snprint_path_groupnumber},
>  	{'t', "dm_st",         0, snprint_dm_path_state},
>  	{'o', "dev_st",        0, snprint_offline},
>  	{'T', "chk_st",        0, snprint_chk_state},
> -- 
> 2.5.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
