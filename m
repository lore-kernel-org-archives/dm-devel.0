From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipathd/main.c: delete redundant judgment
 before LOG_MSG()
Date: Tue, 18 Oct 2016 12:02:38 -0500
Message-ID: <20161018170238.GN1972@octiron.msp.redhat.com>
References: <1476781905-8584-1-git-send-email-li.minghui7@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1476781905-8584-1-git-send-email-li.minghui7@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: li.minghui7@zte.com.cn
Cc: dm-devel@redhat.com, zhang.kai16@zte.com.cn
List-Id: dm-devel.ids

On Tue, Oct 18, 2016 at 05:11:45PM +0800, li.minghui7@zte.com.cn wrote:
> From: "li.minghui" <li.minghui7@zte.com.cn>
> 
> Problem:the LOG_MSG() doesn't note the path info "path offline" when the
> path is in offline with the pp->offline = 1.
> 
> Reasons:There is no need to judge the strlen(b) again before calling
> LOG_MSG(a, b) because there exists the judgmnet of strlen(b) in
> defination of LOG_MSG(a,b).

ACK

-Ben

> ---
>  multipathd/main.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index b6eb696..b147ca5 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1454,8 +1454,7 @@ void repair_path(struct path * pp)
>  		return;
>  
>  	checker_repair(&pp->checker);
> -	if (strlen(checker_message(&pp->checker)))
> -		LOG_MSG(1, checker_message(&pp->checker));
> +	LOG_MSG(1, checker_message(&pp->checker));
>  }
>  
>  /*
> @@ -1590,8 +1589,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
>  		int oldstate = pp->state;
>  		pp->state = newstate;
>  
> -		if (strlen(checker_message(&pp->checker)))
> -			LOG_MSG(1, checker_message(&pp->checker));
> +		LOG_MSG(1, checker_message(&pp->checker));
>  
>  		/*
>  		 * upon state change, reset the checkint
> @@ -1703,8 +1701,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
>  			pp->tick = pp->checkint;
>  		}
>  	}
> -	else if (newstate == PATH_DOWN &&
> -		 strlen(checker_message(&pp->checker))) {
> +	else if (newstate == PATH_DOWN) {
>  		int log_checker_err;
>  
>  		conf = get_multipath_config();
> -- 
> 2.8.1.windows.1
