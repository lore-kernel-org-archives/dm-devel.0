Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33679C433EF
	for <dm-devel@archiver.kernel.org>; Sat,  2 Apr 2022 03:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648870548;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wQPbOfMoSHl/HXeKi8RwU/IGFwUxIARdkKjpj6OZACk=;
	b=OUQcte9RRADSIvY+bOZ2QqQ+Pjp1eHo7Hdpkjr5PVc+4lROD4H23uqnaalOWYWv3YkIa5X
	+1H51bU7slyl+FEZMsbcmjqxDB7vFhpQ+Q81RRazL1geZf5kOqHWOr7qcQLDZuyjKRWbtw
	ybOf6h1+/U+3GA+/ACmasC5ozwNlzxM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-WSznzFhMPaiH1OhP_g_cnA-1; Fri, 01 Apr 2022 23:35:45 -0400
X-MC-Unique: WSznzFhMPaiH1OhP_g_cnA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E384A185A794;
	Sat,  2 Apr 2022 03:35:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1481C57960;
	Sat,  2 Apr 2022 03:35:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F8B21949761;
	Sat,  2 Apr 2022 03:35:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 921861947BBE
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Apr 2022 03:35:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 703E9C57962; Sat,  2 Apr 2022 03:35:41 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 56CF2C57960;
 Sat,  2 Apr 2022 03:35:41 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2323ZeF5015914;
 Fri, 1 Apr 2022 22:35:40 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2323ZdnT015913;
 Fri, 1 Apr 2022 22:35:39 -0500
Date: Fri, 1 Apr 2022 22:35:39 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220402033539.GT24684@octiron.msp.redhat.com>
References: <20220330221510.22578-1-mwilck@suse.com>
 <20220330221510.22578-6-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220330221510.22578-6-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 05/14] libmultipath: uevent_dispatch(): only
 filter/merge new uevents
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> On Thu, Mar 31, 2022 at 12:15:01AM +0200, mwilck@suse.com wrote:
> When uevq_work is non-empty and we append a list of new events,
> we don't need to check the entire list for filterable and mergeable
> uevents. uevq_work had been filtered and merged already. So we just
> need to check the newly appended events. These must of course be
> checked for merges with earlier events, too.
> 
> We must deal with some special cases here, like previously merged
> uevents being filtered later.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/list.h   | 24 ++++++++++++++
>  libmultipath/uevent.c | 77 +++++++++++++++++++++++++++++++++----------
>  2 files changed, 83 insertions(+), 18 deletions(-)
> 
> diff --git a/libmultipath/list.h b/libmultipath/list.h
> index ddea99f..248f72b 100644
> --- a/libmultipath/list.h
> +++ b/libmultipath/list.h
> @@ -363,6 +363,30 @@ static inline struct list_head *list_pop(struct list_head *head)
>  	     &pos->member != (head);                                    \
>  	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
>  
> +/**
> + * list_for_some_entry - iterate list from the given begin node to the given end node
> + * @pos:	the type * to use as a loop counter.
> + * @from:	the begin node of the iteration.
> + * @to:		the end node of the iteration.
> + * @member:	the name of the list_struct within the struct.
> + */
> +#define list_for_some_entry(pos, from, to, member)                      \
> +	for (pos = list_entry((from)->next, typeof(*pos), member);      \
> +	     &pos->member != (to);                                      \
> +	     pos = list_entry(pos->member.next, typeof(*pos), member))
> +
> +/**
> + * list_for_some_entry_reverse - iterate backwards list from the given begin node to the given end node
> + * @pos:	the type * to use as a loop counter.
> + * @from:	the begin node of the iteration.
> + * @to:		the end node of the iteration.
> + * @member:	the name of the list_struct within the struct.
> + */
> +#define list_for_some_entry_reverse(pos, from, to, member)		\
> +	for (pos = list_entry((from)->prev, typeof(*pos), member);      \
> +	     &pos->member != (to);                                      \
> +	     pos = list_entry(pos->member.prev, typeof(*pos), member))
> +
>  /**
>   * list_for_some_entry_safe - iterate list from the given begin node to the given end node safe against removal of list entry
>   * @pos:	the type * to use as a loop counter.
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index 602eccb..2779703 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -306,17 +306,49 @@ uevent_can_merge(struct uevent *earlier, struct uevent *later)
>  	return false;
>  }
>  
> +static void uevent_delete_from_list(struct uevent *to_delete,
> +				    struct uevent **previous,
> +				    struct list_head **old_tail)
> +{
> +	/*
> +	 * "old_tail" is the list_head before the last list element to which
> +	 * the caller iterates (the list anchor if the caller iterates over
> +	 * the entire list). If this element is removed (which can't happen
> +	 * for the anchor), "old_tail" must be moved. It can happen that
> +	 * "old_tail" ends up pointing at the anchor.
> +	 */
> +	if (*old_tail == &to_delete->node)
> +		*old_tail = to_delete->node.prev;
> +
> +	list_del_init(&to_delete->node);
> +
> +	/*
> +	 * The "to_delete" uevent has been merged with other uevents
> +	 * previously. Re-insert them into the list, at the point we're
> +	 * currently at. This must be done after the list_del_init() above,
> +	 * otherwise previous->next would still point to to_delete.
> +	 */
> +	if (!list_empty(&to_delete->merge_node)) {
> +		struct uevent *last = list_entry(to_delete->merge_node.prev,
> +						 typeof(*last), node);
> +
> +		list_splice(&to_delete->merge_node, &(*previous)->node);
> +		*previous = last;
> +	}
> +	if (to_delete->udev)
> +		udev_device_unref(to_delete->udev);
> +
> +	free(to_delete);
> +}
> +
>  static void
> -uevent_prepare(struct list_head *tmpq)
> +uevent_prepare(struct list_head *tmpq, struct list_head **stop)
>  {
>  	struct uevent *uev, *tmp;
>  
> -	list_for_each_entry_reverse_safe(uev, tmp, tmpq, node) {
> +	list_for_some_entry_reverse_safe(uev, tmp, tmpq, *stop, node) {
>  		if (uevent_can_discard(uev)) {
> -			list_del_init(&uev->node);
> -			if (uev->udev)
> -				udev_device_unref(uev->udev);
> -			free(uev);
> +			uevent_delete_from_list(uev, &tmp, stop);

You are only running this on new events, so they can't possibly have any
merged uevents, and can't possibly be equal to stop, so the old, simple,
deleting code works fine here, and you can just pass stop as a regular
pointer, right? Or is this tricker than I understand?

-Ben

>  			continue;
>  		}
>  
> @@ -327,7 +359,7 @@ uevent_prepare(struct list_head *tmpq)
>  }
>  
>  static void
> -uevent_filter(struct uevent *later, struct list_head *tmpq)
> +uevent_filter(struct uevent *later, struct list_head *tmpq, struct list_head **stop)
>  {
>  	struct uevent *earlier, *tmp;
>  
> @@ -341,16 +373,13 @@ uevent_filter(struct uevent *later, struct list_head *tmpq)
>  				earlier->kernel, earlier->action,
>  				later->kernel, later->action);
>  
> -			list_del_init(&earlier->node);
> -			if (earlier->udev)
> -				udev_device_unref(earlier->udev);
> -			free(earlier);
> +			uevent_delete_from_list(earlier, &tmp, stop);
>  		}
>  	}
>  }
>  
>  static void
> -uevent_merge(struct uevent *later, struct list_head *tmpq)
> +uevent_merge(struct uevent *later, struct list_head *tmpq, struct list_head **stop)
>  {
>  	struct uevent *earlier, *tmp;
>  
> @@ -365,6 +394,10 @@ uevent_merge(struct uevent *later, struct list_head *tmpq)
>  				earlier->action, earlier->kernel, earlier->wwid,
>  				later->action, later->kernel, later->wwid);
>  
> +			/* See comment in uevent_delete_from_list() */
> +			if (&earlier->node == *stop)
> +				*stop = earlier->node.prev;
> +
>  			list_move(&earlier->node, &later->merge_node);
>  			list_splice_init(&earlier->merge_node,
>  					 &later->merge_node);
> @@ -373,15 +406,15 @@ uevent_merge(struct uevent *later, struct list_head *tmpq)
>  }
>  
>  static void
> -merge_uevq(struct list_head *tmpq)
> +merge_uevq(struct list_head *tmpq, struct list_head *stop)
>  {
>  	struct uevent *later;
>  
> -	uevent_prepare(tmpq);
> -	list_for_each_entry_reverse(later, tmpq, node) {
> -		uevent_filter(later, tmpq);
> +	uevent_prepare(tmpq, &stop);
> +	list_for_some_entry_reverse(later, tmpq, stop, node) {
> +		uevent_filter(later, tmpq, &stop);
>  		if(uevent_need_merge())
> -			uevent_merge(later, tmpq);
> +			uevent_merge(later, tmpq, &stop);
>  	}
>  }
>  
> @@ -442,6 +475,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
>  
>  	pthread_cleanup_push(cleanup_uevq, &uevq_work);
>  	while (1) {
> +		struct list_head *stop;
>  
>  		pthread_cleanup_push(cleanup_mutex, uevq_lockp);
>  		pthread_mutex_lock(uevq_lockp);
> @@ -452,13 +486,20 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
>  			pthread_cond_wait(uev_condp, uevq_lockp);
>  
>  		servicing_uev = 1;
> +		/*
> +		 * "stop" is the list element towards which merge_uevq()
> +		 * will iterate: the last element of uevq_work before
> +		 * appending new uevents. If uveq_is empty, uevq_work.prev
> +		 * equals &uevq_work, which is what we need.
> +		 */
> +		stop = uevq_work.prev;
>  		list_splice_tail_init(&uevq, &uevq_work);
>  		pthread_cleanup_pop(1);
>  
>  		if (!my_uev_trigger)
>  			break;
>  
> -		merge_uevq(&uevq_work);
> +		merge_uevq(&uevq_work, stop);
>  		service_uevq(&uevq_work);
>  	}
>  	pthread_cleanup_pop(1);
> -- 
> 2.35.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

