Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66395C433EF
	for <dm-devel@archiver.kernel.org>; Sat,  2 Apr 2022 03:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648870309;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ndJiS3wkL0qOk+ltn5yXZKT7u4YcAd14aPGPE2EFBlU=;
	b=IWWcE5ayyt50l1G5PXwoDxu/WwJWXv03xb5+FCf1Xwspvpgqt7t6JOlNqOUjDpEdIgzn1t
	7z8/0XsOUMBtw/Z8QqB4kcjdF1cd4zz+VQKzrFO1zmHhHe+KnNShK2vGx0/50BOrNvU4k7
	BQSaqHdPa4yZPYFb7gx5eGn7Lcin9JY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-JxLcEZK5NSOBJURk4Dgs-w-1; Fri, 01 Apr 2022 23:31:46 -0400
X-MC-Unique: JxLcEZK5NSOBJURk4Dgs-w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F46D811E83;
	Sat,  2 Apr 2022 03:31:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6534520296C7;
	Sat,  2 Apr 2022 03:31:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 316491949761;
	Sat,  2 Apr 2022 03:31:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C57B11947BBE
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Apr 2022 03:31:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8F65D4010144; Sat,  2 Apr 2022 03:31:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B42640CF8F2;
 Sat,  2 Apr 2022 03:31:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2323VZ11015900;
 Fri, 1 Apr 2022 22:31:35 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2323VXpm015899;
 Fri, 1 Apr 2022 22:31:33 -0500
Date: Fri, 1 Apr 2022 22:31:33 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220402033133.GS24684@octiron.msp.redhat.com>
References: <20220330221510.22578-1-mwilck@suse.com>
 <20220330221510.22578-5-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220330221510.22578-5-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 04/14] libmultipath: uevent_dispatch():
 process uevents one by one
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
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> On Thu, Mar 31, 2022 at 12:15:00AM +0200, mwilck@suse.com wrote:
> The main rationale for delaying uevents is that the
> uevent dispatcher may have to wait for other threads to release the
> vecs lock, may the vecs lock for an extended amount of time, and
> even sleep occasionally. By delaying them, we have the chance
> to accumulate events for the same path device ("filtering") or
> WWID ("merging"), thus avoiding duplicate work if we merge these
> into one.
> 
> A similar effect can be obtained in the uevent dispatcher itself
> by looking for new uevents after each dispatched event, and trying
> to merge the newly arrived events with those that remained
> in the queue.

I'm not sure how I feel about this commit existing on its own.
uevent_filter() can leak memory if it deletes a uevent that already has
merged uevents.  I see that you fixed this in your next patch.  The
question is, does the reviewing simplification from splitting the
patches make up for adding an error in this one.  If you want to leave
it in as its own commit, you should probably flag that it creates a
memory leak that will be fixed in a future patch.

-Ben
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/list.h   | 29 +++++++++++++++++++++++++++++
>  libmultipath/uevent.c | 37 ++++++++++++++++++++-----------------
>  2 files changed, 49 insertions(+), 17 deletions(-)
> 
> diff --git a/libmultipath/list.h b/libmultipath/list.h
> index ced021f..ddea99f 100644
> --- a/libmultipath/list.h
> +++ b/libmultipath/list.h
> @@ -246,6 +246,35 @@ static inline void list_splice_tail_init(struct list_head *list,
>  #define list_entry(ptr, type, member) \
>  	container_of(ptr, type, member)
>  
> +
> +/**
> + * list_pop - unlink and return the first list element
> + * @head:	the &struct list_head pointer.
> + */
> +static inline struct list_head *list_pop(struct list_head *head)
> +{
> +	struct list_head *tmp;
> +
> +	if (list_empty(head))
> +		return NULL;
> +	tmp = head->next;
> +	list_del_init(tmp);
> +	return tmp;
> +}
> +
> +/**
> + * list_pop_entry - unlink and return the entry of the first list element
> + * @head:	the &struct list_head pointer.
> + * @type:	the type of the struct this is embedded in.
> + * @member:	the name of the list_struct within the struct.
> + */
> +#define list_pop_entry(head, type, member)		\
> +({							\
> +	struct list_head *__h = list_pop(head);		\
> +							\
> +	(__h ? container_of(__h, type, member) : NULL);	\
> +})
> +
>  /**
>   * list_for_each	-	iterate over a list
>   * @pos:	the &struct list_head to use as a loop counter.
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index fe60ae3..602eccb 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -366,6 +366,8 @@ uevent_merge(struct uevent *later, struct list_head *tmpq)
>  				later->action, later->kernel, later->wwid);
>  
>  			list_move(&earlier->node, &later->merge_node);
> +			list_splice_init(&earlier->merge_node,
> +					 &later->merge_node);
>  		}
>  	}
>  }
> @@ -386,16 +388,15 @@ merge_uevq(struct list_head *tmpq)
>  static void
>  service_uevq(struct list_head *tmpq)
>  {
> -	struct uevent *uev, *tmp;
> +	struct uevent *uev = list_pop_entry(tmpq, typeof(*uev), node);
>  
> -	list_for_each_entry_safe(uev, tmp, tmpq, node) {
> -		list_del_init(&uev->node);
> -
> -		pthread_cleanup_push(cleanup_uev, uev);
> -		if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
> -			condlog(0, "uevent trigger error");
> -		pthread_cleanup_pop(1);
> -	}
> +	if (uev == NULL)
> +		return;
> +	condlog(4, "servicing uevent '%s %s'", uev->action, uev->kernel);
> +	pthread_cleanup_push(cleanup_uev, uev);
> +	if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
> +		condlog(0, "uevent trigger error");
> +	pthread_cleanup_pop(1);
>  }
>  
>  static void uevent_cleanup(void *arg)
> @@ -432,33 +433,35 @@ static void cleanup_global_uevq(void *arg __attribute__((unused)))
>  int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
>  		    void * trigger_data)
>  {
> +	LIST_HEAD(uevq_work);
> +
>  	my_uev_trigger = uev_trigger;
>  	my_trigger_data = trigger_data;
>  
>  	mlockall(MCL_CURRENT | MCL_FUTURE);
>  
> +	pthread_cleanup_push(cleanup_uevq, &uevq_work);
>  	while (1) {
> -		LIST_HEAD(uevq_tmp);
>  
>  		pthread_cleanup_push(cleanup_mutex, uevq_lockp);
>  		pthread_mutex_lock(uevq_lockp);
> -		servicing_uev = 0;
>  
> -		while (list_empty(&uevq))
> +		servicing_uev = !list_empty(&uevq_work);
> +
> +		while (list_empty(&uevq_work) && list_empty(&uevq))
>  			pthread_cond_wait(uev_condp, uevq_lockp);
>  
>  		servicing_uev = 1;
> -		list_splice_init(&uevq, &uevq_tmp);
> +		list_splice_tail_init(&uevq, &uevq_work);
>  		pthread_cleanup_pop(1);
>  
>  		if (!my_uev_trigger)
>  			break;
>  
> -		pthread_cleanup_push(cleanup_uevq, &uevq_tmp);
> -		merge_uevq(&uevq_tmp);
> -		service_uevq(&uevq_tmp);
> -		pthread_cleanup_pop(1);
> +		merge_uevq(&uevq_work);
> +		service_uevq(&uevq_work);
>  	}
> +	pthread_cleanup_pop(1);
>  	condlog(3, "Terminating uev service queue");
>  	return 0;
>  }
> -- 
> 2.35.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

