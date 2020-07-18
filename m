From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 61/74] libmultipath: adopt_paths(): skip
	removed paths
Date: Fri, 17 Jul 2020 23:28:36 -0500
Message-ID: <20200718042836.GT11089@octiron.msp.redhat.com>
References: <20200709105145.9211-1-mwilck@suse.com>
	<20200709105145.9211-9-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-9-mwilck@suse.com>
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

On Thu, Jul 09, 2020 at 12:51:32PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If we don't do this, pathinfo() will fail on these paths, causing
> adopt_paths() to fail.
> 

This is probably unnecessary, but it seems safer to make sure that
pp->mpp is set to mpp, before bailing out on removed paths.

-Ben

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/structs_vec.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 7c68592..1e0f109 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -79,6 +79,8 @@ int adopt_paths(vector pathvec, struct multipath *mpp)
>  					pp->dev, mpp->alias);
>  				continue;
>  			}
> +			if (pp->initialized == INIT_REMOVED)
> +				continue;
>  			condlog(3, "%s: ownership set to %s",
>  				pp->dev, mpp->alias);
>  			pp->mpp = mpp;
> -- 
> 2.26.2
