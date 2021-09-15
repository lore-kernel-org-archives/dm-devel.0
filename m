Return-Path: <SRS0=IV6L=OF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB77C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 22:20:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C722A60F13
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 22:20:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C722A60F13
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631744442;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rS9XQWaN3mDCV2sJmSla0qEUrdHCpdBX6yjryFx8qNs=;
	b=HLmmEy5k0VHNH9aFZuetdPeseRJMQ5K4zxAaUsaC1PU2d0AyIgzLoxkBP6uppWO400a15A
	VrO7ybiMTHRPlRm86DhvKQlQamK+eLz/ppxVmGYMmq+gJsze0sr4cyZpuruOwVAkTiE/ni
	1oXpl8n9LFseJlUq64ujQNcFIl5fO+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-vr5QiaQHOim-ypzG9SuqMQ-1; Wed, 15 Sep 2021 18:20:38 -0400
X-MC-Unique: vr5QiaQHOim-ypzG9SuqMQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2332C1808305;
	Wed, 15 Sep 2021 22:20:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B50605C1A1;
	Wed, 15 Sep 2021 22:20:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F39764EA2A;
	Wed, 15 Sep 2021 22:20:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18FMKVpf009081 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 18:20:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1A078604CC; Wed, 15 Sep 2021 22:20:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B4F8760583;
	Wed, 15 Sep 2021 22:20:26 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18FMKOl3006372; 
	Wed, 15 Sep 2021 17:20:25 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18FMKOog006371;
	Wed, 15 Sep 2021 17:20:24 -0500
Date: Wed, 15 Sep 2021 17:20:23 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210915222023.GQ3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-6-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-6-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 05/35] libmultipath: improve cleanup of
 uevent queues on exit
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 10, 2021 at 01:40:50PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> uevents listed on merge_node must be cleaned up, too. uevents
> cancelled while being serviced and temporary queues, likewise.
> The global uevq must be cleaned out in the uevent listener thread,
> because it might have added events after the dispatcher thread
> had already finished.
> 

There's nothing wrong with this, but for the global list, wouldn't it be
easier to just wait till after cleanup_child() calls cleanup_threads(),
and then call cleanup_global_uevq(). That way you know nothing else is
running.

-Ben

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/uevent.c | 49 ++++++++++++++++++++++++++++++++-----------
>  1 file changed, 37 insertions(+), 12 deletions(-)
> 
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index 4265904..082e891 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -91,16 +91,25 @@ struct uevent * alloc_uevent (void)
>  	return uev;
>  }
>  
> +static void uevq_cleanup(struct list_head *tmpq);
> +
> +static void cleanup_uev(void *arg)
> +{
> +	struct uevent *uev = arg;
> +
> +	uevq_cleanup(&uev->merge_node);
> +	if (uev->udev)
> +		udev_device_unref(uev->udev);
> +	FREE(uev);
> +}
> +
>  static void uevq_cleanup(struct list_head *tmpq)
>  {
>  	struct uevent *uev, *tmp;
>  
>  	list_for_each_entry_safe(uev, tmp, tmpq, node) {
>  		list_del_init(&uev->node);
> -
> -		if (uev->udev)
> -			udev_device_unref(uev->udev);
> -		FREE(uev);
> +		cleanup_uev(uev);
>  	}
>  }
>  
> @@ -384,14 +393,10 @@ service_uevq(struct list_head *tmpq)
>  	list_for_each_entry_safe(uev, tmp, tmpq, node) {
>  		list_del_init(&uev->node);
>  
> +		pthread_cleanup_push(cleanup_uev, uev);
>  		if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
>  			condlog(0, "uevent trigger error");
> -
> -		uevq_cleanup(&uev->merge_node);
> -
> -		if (uev->udev)
> -			udev_device_unref(uev->udev);
> -		FREE(uev);
> +		pthread_cleanup_pop(1);
>  	}
>  }
>  
> @@ -411,6 +416,18 @@ static void monitor_cleanup(void *arg)
>  	udev_monitor_unref(monitor);
>  }
>  
> +static void cleanup_uevq(void *arg)
> +{
> +	uevq_cleanup(arg);
> +}
> +
> +static void cleanup_global_uevq(void *arg __attribute__((unused)))
> +{
> +	pthread_mutex_lock(uevq_lockp);
> +	uevq_cleanup(&uevq);
> +	pthread_mutex_unlock(uevq_lockp);
> +}
> +
>  /*
>   * Service the uevent queue.
>   */
> @@ -425,6 +442,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
>  	while (1) {
>  		LIST_HEAD(uevq_tmp);
>  
> +		pthread_cleanup_push(cleanup_mutex, uevq_lockp);
>  		pthread_mutex_lock(uevq_lockp);
>  		servicing_uev = 0;
>  		/*
> @@ -436,14 +454,17 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
>  		}
>  		servicing_uev = 1;
>  		list_splice_init(&uevq, &uevq_tmp);
> -		pthread_mutex_unlock(uevq_lockp);
> +		pthread_cleanup_pop(1);
> +
>  		if (!my_uev_trigger)
>  			break;
> +
> +		pthread_cleanup_push(cleanup_uevq, &uevq_tmp);
>  		merge_uevq(&uevq_tmp);
>  		service_uevq(&uevq_tmp);
> +		pthread_cleanup_pop(1);
>  	}
>  	condlog(3, "Terminating uev service queue");
> -	uevq_cleanup(&uevq);
>  	return 0;
>  }
>  
> @@ -600,6 +621,8 @@ int uevent_listen(struct udev *udev)
>  
>  	events = 0;
>  	gettimeofday(&start_time, NULL);
> +	pthread_cleanup_push(cleanup_global_uevq, NULL);
> +	pthread_cleanup_push(cleanup_uevq, &uevlisten_tmp);
>  	while (1) {
>  		struct uevent *uev;
>  		struct udev_device *dev;
> @@ -650,6 +673,8 @@ int uevent_listen(struct udev *udev)
>  		gettimeofday(&start_time, NULL);
>  		timeout = 30;
>  	}
> +	pthread_cleanup_pop(1);
> +	pthread_cleanup_pop(1);
>  out:
>  	pthread_cleanup_pop(1);
>  out_udev:
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

