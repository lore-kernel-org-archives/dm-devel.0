From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] libmultipath: fix compilation with
	-fno-common
Date: Tue, 21 Jan 2020 09:58:26 -0600
Message-ID: <20200121155826.GV30153@octiron.msp.redhat.com>
References: <20200116215514.20718-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200116215514.20718-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jan 16, 2020 at 10:55:14PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>


Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> This never-used variable must be declared extern in order to avoid
> a link stage error with -fno-common.
> ---
>  libmultipath/structs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index a3adf906..4bb567d3 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -106,7 +106,7 @@ enum yes_no_undef_states {
>   * _FIND_MULTIPATHS_F must have the same value as YNU_YES.
>   * Generate a compile time error if that isn't the case.
>   */
> -char ___error1___[-(_FIND_MULTIPATHS_F != YNU_YES)];
> +extern char ___error1___[-(_FIND_MULTIPATHS_F != YNU_YES)];
>  
>  #define find_multipaths_on(conf) \
>  	(!!((conf)->find_multipaths & _FIND_MULTIPATHS_F))
> -- 
> 2.24.1
