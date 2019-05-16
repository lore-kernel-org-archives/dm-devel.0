From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] libmultipath: get_prio(): really don't reset
 prio for inaccessible paths
Date: Thu, 16 May 2019 14:08:59 -0500
Message-ID: <20190516190859.GF3090@octiron.msp.redhat.com>
References: <20190516071024.7230-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190516071024.7230-1-mwilck@suse.com>
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

On Thu, May 16, 2019 at 09:10:24AM +0200, Martin Wilck wrote:
> As pointed out by Ben Marzinski, my previous patch ebbb56f2 doesn't do what
> it pretends to do.
> 
> Fixes: ebbb56f2 "libmultipath: get_prio(): don't reset prio for inaccessible
> paths"

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/discovery.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index b3dc60b1..856c52c6 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1648,10 +1648,11 @@ get_prio (struct path * pp)
>  		/* this changes pp->offline, but why not */
>  		int state = path_offline(pp);
>  
> -		if (state == PATH_DOWN || state == PATH_PENDING)
> +		if (state == PATH_DOWN || state == PATH_PENDING) {
> +			pp->priority = old_prio;
>  			condlog(3, "%s: %s prio error in state %d, keeping prio = %d",
>  				pp->dev, prio_name(p), state, pp->priority);
> -		else {
> +		} else {
>  			condlog(3, "%s: %s prio error in state %d",
>  				pp->dev, prio_name(p), state);
>  			pp->priority = PRIO_UNDEF;
> -- 
> 2.21.0
