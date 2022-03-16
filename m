Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 156E1C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Mar 2022 20:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647461652;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RL6V71+ac3Wx+VkfDHjZ4X4eOyQJzSzQbANfmQRGWJE=;
	b=RDonF4XDfbrQYMjkDj0ILDUq4cr9IR1FLfaPgx+a5zrl4WkSP1HZ/+D1E9FQ1rkYNZAJ30
	4hezjprpsSPfmj9hQFPoXYUKq1LniH3XWAfYyWR+nGLC1iYWUoib+71LomWQYoA05C+uy1
	cu7GwxIZTLJkcL9f3WtVDYsYK8LHkig=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-0ZfAyiU-MueABGEmoBgjGA-1; Wed, 16 Mar 2022 16:14:08 -0400
X-MC-Unique: 0ZfAyiU-MueABGEmoBgjGA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 959668002BF;
	Wed, 16 Mar 2022 20:14:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1FE19464B4B;
	Wed, 16 Mar 2022 20:14:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DE0DC1949763;
	Wed, 16 Mar 2022 20:13:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9C51F1949761
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Mar 2022 20:13:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 81A001400E73; Wed, 16 Mar 2022 20:13:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 674E11427AFB;
 Wed, 16 Mar 2022 20:13:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22GKDu0A018991;
 Wed, 16 Mar 2022 15:13:57 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22GKDua5018990;
 Wed, 16 Mar 2022 15:13:56 -0500
Date: Wed, 16 Mar 2022 15:13:55 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220316201355.GG24684@octiron.msp.redhat.com>
References: <20220314213036.12074-1-mwilck@suse.com>
 <20220314213036.12074-5-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220314213036.12074-5-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 4/5] multipathd: reset __delayed_reconfig
 from ev_add_map()
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
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 14, 2022 at 10:30:35PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> With the previous patch, one race condition between child() and
> the uevent handler (ev_add_map()) remains: 1. child() sets
> __delayed_reconfig, 2. ev_add_map() calls schedule_reconfigure() and
> thus DAEMON_CONFIGURE, 3. child() sets DAEMON_IDLE. This would cause
> the pending reconfigure request to be missed.
> 
> To fix this, reset __delayed_reconfig immediately from ev_add_map()
> (and likewise, missing_uev_wait_tick()). This way the wait loop in
> child() terminates on the reconfigure_pending condition.
> 
> Also, these schedule_reconfigure() callers don't really request a
> reconfigure() call; they just unblock processing previously requested
> reconfigure() calls. Add a new helper, unblock_reconfigure(), that
> does just that.
>

Doesn't unblock_reconfigure() allow us to set the state to
DAEMON_CONFIGURE, right after the checkerloop() has set it to
DAEMON_RUNNING. schedule_reconfigure() didn't update the state if it was
DAEMON_RUNNING. Instead, it would wait till checkerloop() set the state
back to DAEMON_IDLE for the reconfigure to start.

I have also come up with a different bug that effects these fixes,
including mine. But it will effect this fix worse. This fix assumes that
when a reconfigure is delayed, it should remain delayed until either a
change event happens on the multipath device (ev_add_map) or multipathd
times out waiting for one (missing_uev_wait_tick). However the map could
be removed before either of those things happen.  It's possible that
multipathd could get a remove uevent after the add event but before the
change event. Either that or a multipathd client command could remove
it, or a dm event could happen either removing the device, or updating
it, but with __setup_multipath() removing it. Those are just the
examples I came up with off the top of my head.

So there's a specific problem where we don't handle clearing
__delayed_reconfig if a map was removed. That can be handled in a
different patch.  But this, or any other oversight we might have here
can be mitigated by being more proactive in removing __delayed_reconfig.
For instance, when then main thread tries to reconfigure, it checks
need_to_delay_reconfig(), and only does the reconfigure if this returns
that it's ok.  __delayed_reconfig mostly exists so that the main thread
doesn't need to grab the vecs lock and loop through the the multipath
devices to know if it need to delay, but need_to_delay_reconfig() is
the definitive answer. When the main thread checks this, we should be
updating __delayed_reconfig to match the result. This patch removes the
"__delayed_reconfig = false;" line, which I think is a mistake.

Imagine if, because a map got removed before ev_add_map() was called,
__delayed_reconfig was true, even though there were no maps with
mpp->wait_for_udev set. Any existing config request would still be
delayed, but if another reconfigure was requested not only would it
happen, but if the "__delayed_reconfig = false;" line was back,
__delayed_reconfig would go back to the correct value.

-Ben
 
> Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 41 ++++++++++++++++++++---------------------
>  1 file changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d033a9a..2424db7 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -155,16 +155,6 @@ int should_exit(void)
>  	return get_running_state() == DAEMON_SHUTDOWN;
>  }
>  
> -static bool get_delayed_reconfig(void)
> -{
> -	bool val;
> -
> -	pthread_mutex_lock(&config_lock);
> -	val = __delayed_reconfig;
> -	pthread_mutex_unlock(&config_lock);
> -	return val;
> -}
> -
>  /*
>   * global copy of vecs for use in sig handlers
>   */
> @@ -308,6 +298,22 @@ void post_config_state(enum daemon_status state)
>  	pthread_cleanup_pop(1);
>  }
>  
> +static bool unblock_reconfigure(void)
> +{
> +	bool was_delayed;
> +
> +	pthread_mutex_lock(&config_lock);
> +	was_delayed = __delayed_reconfig;
> +	if (was_delayed) {
> +		__delayed_reconfig = false;
> +		__post_config_state(DAEMON_CONFIGURE);
> +	}
> +	pthread_mutex_unlock(&config_lock);
> +	if (was_delayed)
> +		condlog(2, "reconfigure (delayed)");
> +	return was_delayed;
> +}
> +
>  void schedule_reconfigure(enum force_reload_types requested_type)
>  {
>  	pthread_mutex_lock(&config_lock);
> @@ -790,12 +796,9 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
>  		dm_get_info(mpp->alias, &mpp->dmi);
>  		if (mpp->wait_for_udev) {
>  			mpp->wait_for_udev = 0;
> -			if (get_delayed_reconfig() &&
> -			    !need_to_delay_reconfig(vecs)) {
> -				condlog(2, "reconfigure (delayed)");
> -				schedule_reconfigure(FORCE_RELOAD_WEAK);
> +			if (!need_to_delay_reconfig(vecs) &&
> +			    unblock_reconfigure())
>  				return 0;
> -			}
>  		}
>  		/*
>  		 * Not really an error -- we generate our own uevent
> @@ -1899,11 +1902,8 @@ missing_uev_wait_tick(struct vectors *vecs)
>  		}
>  	}
>  
> -	if (timed_out && get_delayed_reconfig() &&
> -	    !need_to_delay_reconfig(vecs)) {
> -		condlog(2, "reconfigure (delayed)");
> -		schedule_reconfigure(FORCE_RELOAD_WEAK);
> -	}
> +	if (timed_out && !need_to_delay_reconfig(vecs))
> +		unblock_reconfigure();
>  }
>  
>  static void
> @@ -3395,7 +3395,6 @@ child (__attribute__((unused)) void *param)
>  			reload_type = reconfigure_pending == FORCE_RELOAD_YES ?
>  				FORCE_RELOAD_YES : FORCE_RELOAD_WEAK;
>  			reconfigure_pending = FORCE_RELOAD_NONE;
> -			__delayed_reconfig = false;
>  			pthread_mutex_unlock(&config_lock);
>  
>  			rc = reconfigure(vecs, reload_type);
> -- 
> 2.35.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

