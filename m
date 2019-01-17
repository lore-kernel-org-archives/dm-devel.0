From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] multipathd: avoid crash in cli_list_path
Date: Thu, 17 Jan 2019 14:59:51 -0600
Message-ID: <20190117205950.GB11315@octiron.msp.redhat.com>
References: <20190108232543.18134-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190108232543.18134-1-mwilck@suse.com>
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

On Wed, Jan 09, 2019 at 12:25:43AM +0100, Martin Wilck wrote:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> multipathd can be crashed by passing an invalid path name
> to the "show path" command. Fix it.
> ---
>  multipathd/cli_handlers.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 6304ed3a..fabf4440 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -346,6 +346,8 @@ cli_list_path (void * v, char ** reply, int * len, void * data)
>  	condlog(3, "%s: list path (operator)", param);
>  
>  	pp = find_path_by_dev(vecs->pathvec, param);
> +	if (!pp)
> +		return 1;
>  
>  	return show_path(reply, len, vecs, pp, "%o");
>  }
> -- 
> 2.19.2
