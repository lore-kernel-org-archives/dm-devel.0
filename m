From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v4 13/20] multipath -u: treat failed wwids as
	invalid
Date: Thu, 12 Apr 2018 13:35:29 -0500
Message-ID: <20180412183529.GP3103@octiron.msp.redhat.com>
References: <20180404161627.6244-1-mwilck@suse.com>
	<20180404161627.6244-14-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180404161627.6244-14-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Julian Andres Klode <julian.klode@canonical.com>
List-Id: dm-devel.ids

On Wed, Apr 04, 2018 at 06:16:20PM +0200, Martin Wilck wrote:
> If a WWID has been marked as "failed", don't treat it as "valid multipath
> device path" in multipath -c/-u. This is key to achieve consistency between
> multipathd and udev rule processing.
> 

Like I said, this isn't a definitive check for multipathd failure, but
it will help, so

Reviewed-by: Benjamin Marzinski <benmarz@gmail.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index 59a72ed..942caf4 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -450,8 +450,12 @@ configure (struct config *conf, enum mpath_cmds cmd,
>  		 * Paths listed in the wwids file are always considered valid.
>  		 */
>  		if (cmd == CMD_VALID_PATH) {
> -			if ((!find_multipaths_on(conf) && ignore_wwids_on(conf))
> -			    || check_wwids_file(refwwid, 0) == 0)
> +			if (is_failed_wwid(refwwid) == WWID_IS_FAILED) {
> +				r = 1;
> +				goto print_valid;
> +			} else if ((!find_multipaths_on(conf) &&
> +				    ignore_wwids_on(conf)) ||
> +				   check_wwids_file(refwwid, 0) == 0)
>  				r = 0;
>  			if (r == 0 ||
>  			    !find_multipaths_on(conf) ||
> -- 
> 2.16.1
