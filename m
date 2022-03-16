Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED533C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Mar 2022 20:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647461759;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2CvSXH2i2mDRYLHSh3xMUKonwF7SDJkMOBDg97E8tRA=;
	b=GvAi1CBF+Ugs113MRCZ7V5ihPyI+b6Is2+1P0xGDqKQXn7oq7v3ATekLFjF3Hm9jiwenu2
	ZTNx05W4LVDCMdk4aX9o/eeq9Vj86Ei6Mb6cwY57OjwE+RgFGFRtsG4PWqSVW2SYbvHjWG
	m4v+4cADN6co0sRKW+Le2jgEeJQ/GRs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-RGIPUD56Pf-OcdAf5_uWiA-1; Wed, 16 Mar 2022 16:15:58 -0400
X-MC-Unique: RGIPUD56Pf-OcdAf5_uWiA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9589280B71C;
	Wed, 16 Mar 2022 20:15:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 834F8111CD4E;
	Wed, 16 Mar 2022 20:15:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 18AA91949763;
	Wed, 16 Mar 2022 20:15:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E9291949761
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Mar 2022 20:15:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5CC2F401E7A; Wed, 16 Mar 2022 20:15:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 40A23401476;
 Wed, 16 Mar 2022 20:15:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22GKFpnD019051;
 Wed, 16 Mar 2022 15:15:51 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22GKFpcd019050;
 Wed, 16 Mar 2022 15:15:51 -0500
Date: Wed, 16 Mar 2022 15:15:50 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220316201550.GI24684@octiron.msp.redhat.com>
References: <20220314213036.12074-1-mwilck@suse.com>
 <20220314213036.12074-4-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220314213036.12074-4-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 3/5] multipathd: avoid busy loop in child()
 for delayed reconfigure
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 14, 2022 at 10:30:34PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If need_to_delay_reconfig() returned true, the logic introduced
> by 250708c ("multipathd: improve delayed reconfigure") and
> 4b104e6 ("multipathd: pass in the type of reconfigure") could cause
> child() to run in a tight loop, switching back and forth between
> DAEMON_CONFIGURE and DAEMON_IDLE states without actually calling
> reconfigure().
> 
> Move the logic to postpone reconfigure() calls from __post_config_state()
> into child(), entirely, to avoid this situation. This means that child()
> needs to poll for reconfigure_pending besides running_state changes.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

With the understanding that this fix still leaves a bug that needs to be
resolved.

> Fixes: 250708c ("multipathd: improve delayed reconfigure")
> Fixes: 4b104e6 ("multipathd: pass in the type of reconfigure")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 48 +++++++++++++++++++----------------------------
>  1 file changed, 19 insertions(+), 29 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 7ecf3bd..d033a9a 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -288,38 +288,12 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
>  /* Don't access this variable without holding config_lock */
>  static enum force_reload_types reconfigure_pending = FORCE_RELOAD_NONE;
>  
> -static void enable_delayed_reconfig(void)
> -{
> -	pthread_mutex_lock(&config_lock);
> -	__delayed_reconfig = true;
> -	pthread_mutex_unlock(&config_lock);
> -}
> -
>  /* must be called with config_lock held */
>  static void __post_config_state(enum daemon_status state)
>  {
>  	if (state != running_state && running_state != DAEMON_SHUTDOWN) {
>  		enum daemon_status old_state = running_state;
>  
> -		/*
> -		 * Handle a pending reconfigure request.
> -		 * DAEMON_IDLE is set from child() after reconfigure(),
> -		 * or from checkerloop() after completing checkers.
> -		 * In either case, child() will see DAEMON_CONFIGURE
> -		 * again and start another reconfigure cycle.
> -		 */
> -		if (reconfigure_pending != FORCE_RELOAD_NONE &&
> -		    state == DAEMON_IDLE &&
> -		    (old_state == DAEMON_CONFIGURE ||
> -		     old_state == DAEMON_RUNNING)) {
> -			/*
> -			 * notify systemd of transient idle state, lest systemd
> -			 * thinks the reload lasts forever.
> -			 */
> -			do_sd_notify(old_state, DAEMON_IDLE);
> -			old_state = DAEMON_IDLE;
> -			state = DAEMON_CONFIGURE;
> -		}
>  		running_state = state;
>  		pthread_cond_broadcast(&config_cond);
>  		do_sd_notify(old_state, state);
> @@ -3390,8 +3364,21 @@ child (__attribute__((unused)) void *param)
>  		pthread_cleanup_push(config_cleanup, NULL);
>  		pthread_mutex_lock(&config_lock);
>  		while (running_state != DAEMON_CONFIGURE &&
> -		       running_state != DAEMON_SHUTDOWN)
> +		       running_state != DAEMON_SHUTDOWN &&
> +		       /*
> +			* Check if another reconfigure request was scheduled
> +			* while we last ran reconfigure().
> +			* We have to test __delayed_reconfig here
> +			* to avoid a busy loop
> +			*/
> +		       (reconfigure_pending == FORCE_RELOAD_NONE
> +			 || __delayed_reconfig))
>  			pthread_cond_wait(&config_cond, &config_lock);
> +
> +		if (running_state != DAEMON_CONFIGURE &&
> +		    running_state != DAEMON_SHUTDOWN)
> +			/* This sets running_state to DAEMON_CONFIGURE */
> +			__post_config_state(DAEMON_CONFIGURE);
>  		state = running_state;
>  		pthread_cleanup_pop(1);
>  		if (state == DAEMON_SHUTDOWN)
> @@ -3412,8 +3399,11 @@ child (__attribute__((unused)) void *param)
>  			pthread_mutex_unlock(&config_lock);
>  
>  			rc = reconfigure(vecs, reload_type);
> -		} else
> -			enable_delayed_reconfig();
> +		} else {
> +			pthread_mutex_lock(&config_lock);
> +			__delayed_reconfig = true;
> +			pthread_mutex_unlock(&config_lock);
> +		}
>  		lock_cleanup_pop(vecs->lock);
>  		if (!rc)
>  			post_config_state(DAEMON_IDLE);
> -- 
> 2.35.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

