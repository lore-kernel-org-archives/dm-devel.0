From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] libmultipath: Fix logic in should_multipath
Date: Fri, 13 Apr 2018 12:28:53 -0500
Message-ID: <20180413172853.GG3103@octiron.msp.redhat.com>
References: <20180413172042.11820-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180413172042.11820-1-mwilck@suse.com>
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

On Fri, Apr 13, 2018 at 07:20:42PM +0200, Martin Wilck wrote:
> Commit d3b71498 missed a negation.

Oops. Thanks for the catch.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Fixes: d3b71498 "multipath: fix rcu thread cancellation hang"
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/wwids.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
> index 0ec9f25b..8c21b33f 100644
> --- a/libmultipath/wwids.c
> +++ b/libmultipath/wwids.c
> @@ -284,7 +284,7 @@ should_multipath(struct path *pp1, vector pathvec)
>  	ignore_new_devs = conf->ignore_new_devs;
>  	find_multipaths = conf->find_multipaths;
>  	put_multipath_config(conf);
> -	if (find_multipaths && !ignore_new_devs)
> +	if (!find_multipaths && !ignore_new_devs)
>  		return 1;
>  
>  	condlog(4, "checking if %s should be multipathed", pp1->dev);
> -- 
> 2.16.1
