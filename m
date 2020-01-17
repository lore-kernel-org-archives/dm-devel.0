From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 06/15] libmultipath: add missing hwe mpe
	variable merges
Date: Fri, 17 Jan 2020 17:04:47 +0100
Message-ID: <ed37ab905f7790af8846a47052dfde6f2a70dd04.camel@suse.de>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-7-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-7-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> There were some variables in the hwe and mpe structs that weren't
> being
> merged by merge_hwe() and merge_mpe().
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 20e3b8bf..85626e96 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -372,6 +372,10 @@ merge_hwe (struct hwentry * dst, struct hwentry
> * src)
>  	merge_num(san_path_err_threshold);
>  	merge_num(san_path_err_forget_rate);
>  	merge_num(san_path_err_recovery_time);
> +	merge_num(marginal_path_err_sample_time);
> +	merge_num(marginal_path_err_rate_threshold);
> +	merge_num(marginal_path_err_recheck_gap_time);
> +	merge_num(marginal_path_double_failed_time);

Hm, looking at this, I think we should not attempt to merge sets of
parameters that belong together like this. The marginal_path params
should only be merged if they are *all* unset in the destination.
Otherwise we risk to end up with an inconsistent parameter set from two
different sources.

But that's not a failure of your patch, it should be done in a follow-
up fix. So:

Reviewed-by: Martin Wilck <mwilck@suse.com>
