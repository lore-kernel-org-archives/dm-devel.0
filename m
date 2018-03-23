From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 02/20] Revert "multipathd: imply -n if
 find_multipaths is set"
Date: Fri, 23 Mar 2018 12:51:28 -0500
Message-ID: <20180323175128.GG3103@octiron.msp.redhat.com>
References: <20180319150155.5363-1-mwilck@suse.com>
	<20180319150155.5363-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180319150155.5363-3-mwilck@suse.com>
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

On Mon, Mar 19, 2018 at 04:01:37PM +0100, Martin Wilck wrote:
> This reverts commit 64e27ec066a001012f44550f095c93443e91d845.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 3ae04422a123..0435133fadfb 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2389,10 +2389,6 @@ reconfigure (struct vectors * vecs)
>  		conf->verbosity = verbosity;
>  	if (bindings_read_only)
>  		conf->bindings_read_only = bindings_read_only;
> -	if (conf->find_multipaths) {
> -		condlog(2, "find_multipaths is set: -n is implied");
> -		ignore_new_devs = 1;
> -	}
>  	if (ignore_new_devs)
>  		conf->ignore_new_devs = ignore_new_devs;
>  	uxsock_timeout = conf->uxsock_timeout;
> -- 
> 2.16.1
