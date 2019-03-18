From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH v3 1/6] list: Don't use WRITE_ONCE() in hlist_add_behind()
Date: Mon, 18 Mar 2019 08:39:25 -0700
Message-ID: <20190318153925.GH4102@linux.ibm.com>
References: <20190317122258.21760-1-ntsironis@arrikto.com>
 <20190317122258.21760-2-ntsironis@arrikto.com>
Reply-To: paulmck@linux.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190317122258.21760-2-ntsironis@arrikto.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, mpatocka@redhat.com, hch@infradead.org, iliastsi@arrikto.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Mar 17, 2019 at 02:22:53PM +0200, Nikos Tsironis wrote:
> Commit 1c97be677f72b3 ("list: Use WRITE_ONCE() when adding to lists and
> hlists") introduced the use of WRITE_ONCE() to atomically write the list
> head's ->next pointer.
> 
> hlist_add_behind() doesn't touch the hlist head's ->first pointer so
> there is no reason to use WRITE_ONCE() in this case.
> 
> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
> Signed-off-by: Ilias Tsitsimpis <iliastsi@arrikto.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.ibm.com>

> ---
>  include/linux/list.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index edb7628e46ed..b68d2a85859b 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -743,7 +743,7 @@ static inline void hlist_add_behind(struct hlist_node *n,
>  				    struct hlist_node *prev)
>  {
>  	n->next = prev->next;
> -	WRITE_ONCE(prev->next, n);
> +	prev->next = n;
>  	n->pprev = &prev->next;
>  
>  	if (n->next)
> -- 
> 2.11.0
> 
