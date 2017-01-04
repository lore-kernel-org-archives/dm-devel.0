From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 09/12] multipathd: merge uevents before
	proccessing
Date: Tue, 3 Jan 2017 18:30:49 -0600
Message-ID: <20170104003049.GF2732@octiron.msp.redhat.com>
References: <1482825809-9528-1-git-send-email-tang.junhui@zte.com.cn>
	<1482825809-9528-10-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1482825809-9528-10-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn
Cc: tang.wenjun3@zte.com.cn, zhang.kai16@zte.com.cn, dm-devel@redhat.com, bart.vanassche@sandisk.com, mwilck@suse.com
List-Id: dm-devel.ids

On Tue, Dec 27, 2016 at 04:03:26PM +0800, tang.junhui@zte.com.cn wrote:
> From: tang.junhui <tang.junhui@zte.com.cn>
> 
> These uevents are going to be merged:
> 1) uevents come from paths and
> 2) uevents type is same and
> 3) uevents type is addition or deletion and
> 4) uevents wwid is same.

This is just a nit, and I might be missing something subtle here, but it
seems like instead of adding list_for_some_entry_reverse, and then
breaking the abstraction to manually get previous entries, you could
have just added list_for_some_entry_reverse_safe in your earlier patch,
and hid the work of traversing a list while removing elements behind the
well understood abstraction of a *_safe list traversal method.

-Ben

> 
> Change-Id: I05ee057391c092aa0c5f989b7a4f9cb550bb4d98
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
>  libmultipath/uevent.c | 125 +++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 114 insertions(+), 11 deletions(-)
> 
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index b0b05e9..114068c 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -85,6 +85,20 @@ struct uevent * alloc_uevent (void)
>  	return uev;
>  }
>  
> +void
> +uevq_cleanup(struct list_head *tmpq)
> +{
> +	struct uevent *uev, *tmp;
> +
> +	list_for_each_entry_safe(uev, tmp, tmpq, node) {
> +		list_del_init(&uev->node);
> +
> +		if (uev->udev)
> +			udev_device_unref(uev->udev);
> +		FREE(uev);
> +	}
> +}
> +
>  bool
>  uevent_can_discard(char *devpath, char *kernel)
>  {
> @@ -125,6 +139,103 @@ uevent_can_discard(char *devpath, char *kernel)
>  	return false;
>  }
>  
> +bool
> +merge_need_stop(struct uevent *earlier, struct uevent *later)
> +{
> +	/*
> +	 * dm uevent do not try to merge with left uevents
> +	 */
> +	if (!strncmp(later->kernel, "dm-", 3))
> +		return true;
> +
> +	/*
> +	 * we can not make a jugement without wwid,
> +	 * so it is sensible to stop merging
> +	 */
> +	if (!earlier->wwid || !later->wwid)
> +		return true;
> +	/*
> +	 * uevents merging stoped
> +	 * when we meet an opposite action uevent from the same LUN to AVOID
> +	 * "add path1 |remove path1 |add path2 |remove path2 |add path3"
> +	 * to merge as "remove path1, path2" and "add path1, path2, path3"
> +	 * OR
> +	 * "remove path1 |add path1 |remove path2 |add path2 |remove path3"
> +	 * to merge as "add path1, path2" and "remove path1, path2, path3"
> +	 * SO
> +	 * when we meet a non-change uevent from the same LUN
> +	 * with the same wwid and different action
> +	 * it would be better to stop merging.
> +	 */
> +	if (!strcmp(earlier->wwid, later->wwid) &&
> +	    strcmp(earlier->action, later->action) &&
> +	    strcmp(earlier->action, "change") &&
> +	    strcmp(later->action, "change"))
> +		return true;
> +
> +	return false;
> +}
> +
> +bool
> +uevent_can_merge(struct uevent *earlier, struct uevent *later)
> +{
> +	/* merge paths uevents
> +	 * whose wwids exsit and are same
> +	 * and actions are same,
> +	 * and actions are addition or deletion
> +	 */
> +	if (earlier->wwid && later->wwid &&
> +	    !strcmp(earlier->wwid, later->wwid) &&
> +	    !strcmp(earlier->action, later->action) &&
> +	    strncmp(earlier->action, "change", 6) &&
> +	    strncmp(earlier->kernel, "dm-", 3)) {
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +void
> +uevent_merge(struct uevent *later, struct list_head *tmpq)
> +{
> +	struct uevent *earlier, *temp;
> +	/*
> +	 * compare the uevent with earlier uevents
> +	 */
> +	list_for_some_entry_reverse(earlier, &later->node, tmpq, node) {
> +next_earlier_node:
> +		if (merge_need_stop(earlier, later))
> +			break;
> +		/*
> +		 * try to merge earlier uevents to the later uevent
> +		 */
> +		if (uevent_can_merge(earlier, later)) {
> +			condlog(3, "merged uevent: %s-%s-%s with uevent: %s-%s-%s",
> +				earlier->action, earlier->kernel, earlier->wwid,
> +				later->action, later->kernel, later->wwid);
> +			temp = earlier;
> +
> +			earlier = list_entry(earlier->node.prev, typeof(struct uevent), node);
> +			list_move(&temp->node, &later->merge_node);
> +
> +			if (earlier ==  list_entry(tmpq, typeof(struct uevent), node))
> +				break;
> +			else
> +				goto next_earlier_node;
> +		}
> +	}
> +}
> +
> +void
> +merge_uevq(struct list_head *tmpq)
> +{
> +	struct uevent *later;
> +
> +	list_for_each_entry_reverse(later, tmpq, node) {
> +		uevent_merge(later, tmpq);
> +	}
> +}
> +
>  void
>  service_uevq(struct list_head *tmpq)
>  {
> @@ -136,6 +247,8 @@ service_uevq(struct list_head *tmpq)
>  		if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
>  			condlog(0, "uevent trigger error");
>  
> +		uevq_cleanup(&uev->merge_node);
> +
>  		if (uev->udev)
>  			udev_device_unref(uev->udev);
>  		FREE(uev);
> @@ -150,17 +263,6 @@ static void uevent_cleanup(void *arg)
>  	udev_unref(udev);
>  }
>  
> -void
> -uevq_cleanup(struct list_head *tmpq)
> -{
> -	struct uevent *uev, *tmp;
> -
> -	list_for_each_entry_safe(uev, tmp, tmpq, node) {
> -		list_del_init(&uev->node);
> -		FREE(uev);
> -	}
> -}
> -
>  /*
>   * Service the uevent queue.
>   */
> @@ -189,6 +291,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
>  		pthread_mutex_unlock(uevq_lockp);
>  		if (!my_uev_trigger)
>  			break;
> +		merge_uevq(&uevq_tmp);
>  		service_uevq(&uevq_tmp);
>  	}
>  	condlog(3, "Terminating uev service queue");
> -- 
> 2.8.1.windows.1
> 
