From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/3] list_bl: Add hlist_bl_add_before/behind helpers
Date: Thu, 28 Feb 2019 16:32:02 -0500
Message-ID: <20190228213201.GB23527@redhat.com>
References: <20181220180651.4879-1-ntsironis@arrikto.com>
 <20181220180651.4879-2-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181220180651.4879-2-ntsironis@arrikto.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, hch@infradead.org, Nikos Tsironis <ntsironis@arrikto.com>
Cc: agk@redhat.com, dm-devel@redhat.com, mpatocka@redhat.com, iliastsi@arrikto.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Dec 20 2018 at  1:06pm -0500,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> Add hlist_bl_add_before/behind helpers to add an element before/after an
> existing element in a bl_list.
> 
> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
> Signed-off-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
> ---
>  include/linux/list_bl.h | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
> index 3fc2cc57ba1b..2fd918e5fd48 100644
> --- a/include/linux/list_bl.h
> +++ b/include/linux/list_bl.h
> @@ -86,6 +86,33 @@ static inline void hlist_bl_add_head(struct hlist_bl_node *n,
>  	hlist_bl_set_first(h, n);
>  }
>  
> +static inline void hlist_bl_add_before(struct hlist_bl_node *n,
> +				       struct hlist_bl_node *next)
> +{
> +	struct hlist_bl_node **pprev = next->pprev;
> +
> +	n->pprev = pprev;
> +	n->next = next;
> +	next->pprev = &n->next;
> +
> +	/* pprev may be `first`, so be careful not to lose the lock bit */
> +	WRITE_ONCE(*pprev,
> +		   (struct hlist_bl_node *)
> +			((unsigned long)n |
> +			 ((unsigned long)*pprev & LIST_BL_LOCKMASK)));
> +}
> +
> +static inline void hlist_bl_add_behind(struct hlist_bl_node *n,
> +				       struct hlist_bl_node *prev)
> +{
> +	n->next = prev->next;
> +	n->pprev = &prev->next;
> +	WRITE_ONCE(prev->next, n);
> +
> +	if (n->next)
> +		n->next->pprev = &n->next;
> +}
> +
>  static inline void __hlist_bl_del(struct hlist_bl_node *n)
>  {
>  	struct hlist_bl_node *next = n->next;
> -- 
> 2.11.0

Hi Paul and Christoph,

You've added your Signed-off-by to include/linux/list_bl.h commits in
the past.  I'm not sure how this proposed patch should be handled.

These new hlist_bl_add_{before,behind} changes are a prereq for
dm-snapshot changes that Nikos has proposed, please see:
https://patchwork.kernel.org/patch/10739265/

Any assistance/review you, or others on LKML, might be able to provide
would be appreciated.

Thanks,
Mike
