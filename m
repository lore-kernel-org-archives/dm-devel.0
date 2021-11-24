Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 033FFC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 21:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637788780;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Dp0BJiHw5R9HL33EaS05qd0medbtN4ibKvqmtvopkGw=;
	b=JgQyp4r4qlNqO6AhYR8am60xXejyPm12MpgFb3h4+6ZslxQROMMNb4VEgvUuyFL2p6LjSY
	n75L38tV9ydjHlPu2ATA2NIpTh5bcyiryvbt0Gk34IVqUqe6GfKNVAN3ICahuommBOdIsv
	71XlcgAcrvL+FBu6iLH23hGbBlvFGLQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-XYjyOTIxM1WIMcaTGtRICQ-1; Wed, 24 Nov 2021 16:19:02 -0500
X-MC-Unique: XYjyOTIxM1WIMcaTGtRICQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5184107B0F2;
	Wed, 24 Nov 2021 21:18:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A62FD10114AE;
	Wed, 24 Nov 2021 21:18:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D87C31809C89;
	Wed, 24 Nov 2021 21:18:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AOLIhZO021952 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 16:18:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5122B6F94F; Wed, 24 Nov 2021 21:18:43 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 205A86D03F;
	Wed, 24 Nov 2021 21:18:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AOLIJPT022616; 
	Wed, 24 Nov 2021 15:18:19 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AOLIImk022615;
	Wed, 24 Nov 2021 15:18:18 -0600
Date: Wed, 24 Nov 2021 15:18:18 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211124211818.GQ19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-8-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211118225840.19810-8-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 07/48] multipathd: improve delayed
	reconfigure
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 18, 2021 at 11:57:59PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> When a reconfigure operation is requested, either by the admin
> or by some condition multipathd encounters, the current code
> attempts to set DAEMON_CONFIGURE state and gives up after a second
> if it doesn't succeed. Apart from shutdown, this happens only
> if multipathd is either already reconfiguring, or busy in the
> path checker loop.
> 
> This patch modifies the logic as follows: rather than waiting,
> we set a flag that requests a reconfigure operation asap, i.e.
> when the current operation is finished and the status switched
> to DAEMON_IDLE. In this case, multipathd will not switch to IDLE
> but start another reconfigure cycle.
> 
> This assumes that if a reconfigure is requested while one is already
> running, the admin has made some (additional) changes and wants
> multipathd to pull them in. As we can't be sure that the currently
> running reconfigure has seen the configuration changes, we need
> to start over again.
> 
> A positive side effect is less waiting in clients and multipathd.
> 
> After this change, the only caller of set_config_state() is
> checkerloop(). Waking up every second just to see that DAEMON_RUNNING
> couldn't be set makes no sense. Therefore set_config_state() is
> changed to wait "forever", or until shutdown is requested. Unless
> multipathd completely hangs, the wait will terminate sooner or
> later.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/cli_handlers.c | 10 +----
>  multipathd/main.c         | 92 +++++++++++++++++++++++++++++----------
>  multipathd/main.h         |  2 +-
>  3 files changed, 70 insertions(+), 34 deletions(-)
> 
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 6d3a0ae..44f76ee 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1076,17 +1076,9 @@ cli_switch_group(void * v, char ** reply, int * len, void * data)
>  int
>  cli_reconfigure(void * v, char ** reply, int * len, void * data)
>  {
> -	int rc;
> -
>  	condlog(2, "reconfigure (operator)");
>  
> -	rc = set_config_state(DAEMON_CONFIGURE);
> -	if (rc == ETIMEDOUT) {
> -		condlog(2, "timeout starting reconfiguration");
> -		return 1;
> -	} else if (rc == EINVAL)
> -		/* daemon shutting down */
> -		return 1;
> +	schedule_reconfigure();
>  	return 0;
>  }
>  
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 1a1812e..7dc5f49 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -221,6 +221,10 @@ static void do_sd_notify(enum daemon_status old_state,
>  	} else if (new_state == DAEMON_CONFIGURE && startup_done)
>  		sd_notify(0, "RELOADING=1");
>  }
> +#else
> +static void do_sd_notify(__attribute__((unused)) enum daemon_status old_state,
> +			 __attribute__((unused)) enum daemon_status new_state)
> +{}
>  #endif
>  
>  static void config_cleanup(__attribute__((unused)) void *arg)
> @@ -266,19 +270,38 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
>  	return st;
>  }
>  
> +/* Don't access this variable without holding config_lock */
> +static bool reconfigure_pending;
> +
>  /* must be called with config_lock held */
>  static void __post_config_state(enum daemon_status state)
>  {
>  	if (state != running_state && running_state != DAEMON_SHUTDOWN) {
> -#ifdef USE_SYSTEMD
>  		enum daemon_status old_state = running_state;
> -#endif
>  
> +		/*
> +		 * Handle a pending reconfigure request.
> +		 * DAEMON_IDLE is set from child() after reconfigure(),
> +		 * or from checkerloop() after completing checkers.
> +		 * In either case, child() will see DAEMON_CONFIGURE
> +		 * again and start another reconfigure cycle.
> +		 */
> +		if (reconfigure_pending && state == DAEMON_IDLE &&
> +		    (old_state == DAEMON_CONFIGURE ||
> +		     old_state == DAEMON_RUNNING)) {
> +			/*
> +			 * notify systemd of transient idle state, lest systemd
> +			 * thinks the reload lasts forever.
> +			 */
> +			do_sd_notify(old_state, DAEMON_IDLE);
> +			old_state = DAEMON_IDLE;
> +			state = DAEMON_CONFIGURE;
> +		}
> +		if (reconfigure_pending && state == DAEMON_CONFIGURE)
> +			reconfigure_pending = false;
>  		running_state = state;
>  		pthread_cond_broadcast(&config_cond);
> -#ifdef USE_SYSTEMD
>  		do_sd_notify(old_state, state);
> -#endif
>  	}
>  }
>  
> @@ -290,24 +313,48 @@ void post_config_state(enum daemon_status state)
>  	pthread_cleanup_pop(1);
>  }
>  
> -int set_config_state(enum daemon_status state)
> +void schedule_reconfigure(void)
> +{
> +	pthread_mutex_lock(&config_lock);
> +	pthread_cleanup_push(config_cleanup, NULL);
> +	switch (running_state)
> +	{
> +	case DAEMON_SHUTDOWN:
> +		break;
> +	case DAEMON_IDLE:
> +		__post_config_state(DAEMON_CONFIGURE);
> +		break;
> +	case DAEMON_CONFIGURE:
> +	case DAEMON_RUNNING:
> +		reconfigure_pending = true;
> +		break;
> +	default:
> +		break;
> +	}
> +	pthread_cleanup_pop(1);
> +}
> +
> +static enum daemon_status set_config_state(enum daemon_status state)
>  {
>  	int rc = 0;
> +	enum daemon_status st;
>  
>  	pthread_cleanup_push(config_cleanup, NULL);
>  	pthread_mutex_lock(&config_lock);
> -	if (running_state != state) {
>  
> -		if (running_state == DAEMON_SHUTDOWN)
> -			rc = EINVAL;
> -		else
> -			rc = __wait_for_state_change(
> -				running_state != DAEMON_IDLE, 1000);
> -		if (!rc)
> -			__post_config_state(state);
> +	while (rc == 0 &&
> +	       running_state != state &&
> +	       running_state != DAEMON_SHUTDOWN &&
> +	       running_state != DAEMON_IDLE) {
> +		rc = pthread_cond_wait(&config_cond, &config_lock);
>  	}
> +
> +	if (rc == 0 && running_state == DAEMON_IDLE && state != DAEMON_IDLE)
> +		__post_config_state(state);
> +	st = running_state;
> +
>  	pthread_cleanup_pop(1);
> -	return rc;
> +	return st;
>  }
>  
>  struct config *get_multipath_config(void)
> @@ -745,7 +792,7 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
>  			if (delayed_reconfig &&
>  			    !need_to_delay_reconfig(vecs)) {
>  				condlog(2, "reconfigure (delayed)");
> -				set_config_state(DAEMON_CONFIGURE);
> +				schedule_reconfigure();
>  				return 0;
>  			}
>  		}
> @@ -1856,7 +1903,7 @@ missing_uev_wait_tick(struct vectors *vecs)
>  	if (timed_out && delayed_reconfig &&
>  	    !need_to_delay_reconfig(vecs)) {
>  		condlog(2, "reconfigure (delayed)");
> -		set_config_state(DAEMON_CONFIGURE);
> +		schedule_reconfigure();
>  	}
>  }
>  
> @@ -2495,6 +2542,10 @@ checkerloop (void *ap)
>  		int num_paths = 0, strict_timing, rc = 0;
>  		unsigned int ticks = 0;
>  
> +		if (set_config_state(DAEMON_RUNNING) != DAEMON_RUNNING)
> +			/* daemon shutdown */
> +			break;
> +
>  		get_monotonic_time(&start_time);
>  		if (start_time.tv_sec && last_time.tv_sec) {
>  			timespecsub(&start_time, &last_time, &diff_time);
> @@ -2510,13 +2561,6 @@ checkerloop (void *ap)
>  		if (use_watchdog)
>  			sd_notify(0, "WATCHDOG=1");
>  #endif
> -		rc = set_config_state(DAEMON_RUNNING);
> -		if (rc == ETIMEDOUT) {
> -			condlog(4, "timeout waiting for DAEMON_IDLE");
> -			continue;
> -		} else if (rc == EINVAL)
> -			/* daemon shutdown */
> -			break;
>  
>  		pthread_cleanup_push(cleanup_lock, &vecs->lock);
>  		lock(&vecs->lock);
> @@ -2844,7 +2888,7 @@ handle_signals(bool nonfatal)
>  		return;
>  	if (reconfig_sig) {
>  		condlog(2, "reconfigure (signal)");
> -		set_config_state(DAEMON_CONFIGURE);
> +		schedule_reconfigure();
>  	}
>  	if (log_reset_sig) {
>  		condlog(2, "reset log (signal)");
> diff --git a/multipathd/main.h b/multipathd/main.h
> index bc1f938..2960a4d 100644
> --- a/multipathd/main.h
> +++ b/multipathd/main.h
> @@ -37,6 +37,7 @@ void exit_daemon(void);
>  const char * daemon_status(void);
>  enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
>  					    unsigned long ms);
> +void schedule_reconfigure(void);
>  int need_to_delay_reconfig (struct vectors *);
>  int reconfigure (struct vectors *);
>  int ev_add_path (struct path *, struct vectors *, int);
> @@ -44,7 +45,6 @@ int ev_remove_path (struct path *, struct vectors *, int);
>  int ev_add_map (char *, const char *, struct vectors *);
>  int ev_remove_map (char *, char *, int, struct vectors *);
>  int flush_map(struct multipath *, struct vectors *, int);
> -int set_config_state(enum daemon_status);
>  void * mpath_alloc_prin_response(int prin_sa);
>  int prin_do_scsi_ioctl(char *, int rq_servact, struct prin_resp * resp,
>  		       int noisy);
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

