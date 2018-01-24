From: Martin Wilck <mwilck@suse.com>
Subject: Re: [dm-devel] [PATCH] dm mpath selector: more evenly distribute
 ties
Date: Wed, 24 Jan 2018 11:57:17 +0100
Message-ID: <1516791437.6678.6.camel@suse.com>
References: <20180119230737.133596-1-khazhy@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180119230737.133596-1-khazhy@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khazhismel Kumykov <khazhy@google.com>, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, 2018-01-19 at 15:07 -0800, Khazhismel Kumykov wrote:
> Move the last used path to the end of the list (least preferred) so
> that
> ties are more evenly distributed.
> 
> For example, in case with three paths with one that is slower than
> others, the remaining two would be unevenly used if they tie. This is
> due to the rotation not being a truely fair distribution.
> 
> Illustrated: paths a, b, c, 'c' has 1 outstanding IO, a and b are
> 'tied'
> Three possible rotations:
> (a, b, c) -> best path 'a'
> (b, c, a) -> best path 'b'
> (c, a, b) -> best path 'a'
> (a, b, c) -> best path 'a'
> (b, c, a) -> best path 'b'
> (c, a, b) -> best path 'a'
> ...


This happens only if a and b actually have the same weight (e.g. queue
length for the queue-length selector). If 'a' really receives more IO,
its queue grows, and the selector will start preferring 'b', so the
effect should level out automatically with the current code as soon as
you have real IO going on. But maybe I haven't grasped what you're
referring to as "tied".

OTOH, if the "best" path has much lower queue length than the other
paths for whatever reason, your pushing it to the tail will require a
full list walk with every new call of the selector. I see tjat as a
small disadvantage of your approach.

Regards
Martin

> 
> So 'a' is used 2x more than 'b', although they should be used evenly.
> 
> With this change, the most recently used path is always the least
> preferred, removing this bias resulting in even distribution.
> (a, b, c) -> best path 'a'
> (b, c, a) -> best path 'b'
> (c, a, b) -> best path 'a'
> (c, b, a) -> best path 'b'
> ...
> 
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> ---
>  drivers/md/dm-queue-length.c | 6 +++---
>  drivers/md/dm-service-time.c | 6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm-queue-length.c b/drivers/md/dm-queue-
> length.c
> index 23f178641794..969c4f1a3633 100644
> --- a/drivers/md/dm-queue-length.c
> +++ b/drivers/md/dm-queue-length.c
> @@ -195,9 +195,6 @@ static struct dm_path *ql_select_path(struct
> path_selector *ps, size_t nr_bytes)
>  	if (list_empty(&s->valid_paths))
>  		goto out;
>  
> -	/* Change preferred (first in list) path to evenly balance.
> */
> -	list_move_tail(s->valid_paths.next, &s->valid_paths);
> -
>  	list_for_each_entry(pi, &s->valid_paths, list) {
>  		if (!best ||
>  		    (atomic_read(&pi->qlen) < atomic_read(&best-
> >qlen)))
> @@ -210,6 +207,9 @@ static struct dm_path *ql_select_path(struct
> path_selector *ps, size_t nr_bytes)
>  	if (!best)
>  		goto out;
>  
> +	/* Move most recently used to least preferred to evenly
> balance. */
> +	list_move_tail(&best->list, &s->valid_paths);
> +
>  	ret = best->path;
>  out:
>  	spin_unlock_irqrestore(&s->lock, flags);
> diff --git a/drivers/md/dm-service-time.c b/drivers/md/dm-service-
> time.c
> index 7b8642045c55..f006a9005593 100644
> --- a/drivers/md/dm-service-time.c
> +++ b/drivers/md/dm-service-time.c
> @@ -282,9 +282,6 @@ static struct dm_path *st_select_path(struct
> path_selector *ps, size_t nr_bytes)
>  	if (list_empty(&s->valid_paths))
>  		goto out;
>  
> -	/* Change preferred (first in list) path to evenly balance.
> */
> -	list_move_tail(s->valid_paths.next, &s->valid_paths);
> -
>  	list_for_each_entry(pi, &s->valid_paths, list)
>  		if (!best || (st_compare_load(pi, best, nr_bytes) <
> 0))
>  			best = pi;
> @@ -292,6 +289,9 @@ static struct dm_path *st_select_path(struct
> path_selector *ps, size_t nr_bytes)
>  	if (!best)
>  		goto out;
>  
> +	/* Move most recently used to least preferred to evenly
> balance. */
> +	list_move_tail(&best->list, &s->valid_paths);
> +
>  	ret = best->path;
>  out:
>  	spin_unlock_irqrestore(&s->lock, flags);
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
