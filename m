Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693327;
	b=pK6qvrUA2RhojfC50ppKv0ODk9rvBtCpjx2kebGGoXcAV3KXdqHVuveJuF+1AfF5e/Qr
	 0AhTT/1rYUPBhQvyoA3famVZYkyzftoIcaR/9FvTwuGNFXNCyskfuPPldPjmiYiVm4abQ
	 hWQuTfu3KBEx983OIbzProGNFkI9m9gxTtbAQU9aDl+Asa1mZQ4Ci0vCYzO/e8Dx8/GLy
	 6PT71SFFyiM8ngovUcxFpDn5bgO4NUvfvBsFpQCV1M6b4rR29NcudMl5Uiw0+ZQlBq4xz
	 Azo+/qViS6HctnpbM6Yk8kG7tMdgVRe4LidKwZwYYlrajZZP70UNtwIzUeTyRaL9xLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693327;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Subject:To:Cc:In-Reply-To:References:Date:
	 Message-Id:X-Mailer;
	bh=XL3nMkkdw+gDxLxoVJw+xAao7MyGsp5RlD5LNf6Oork=;
	b=VyHxjG9StnECBwsGMtZ9R/LeJT/GHaR1yJxOdX3ppYYZNqLJ6yQQA0kD8HIrQUBwM0oK
	 EDwMqjolDmlbg4E+gusvxxPEsgoRFUn/xkRoMDqz4nqx2LNc0AWfUwB5PoLVao/OQW6vQ
	 1HEOZcNfF+Shjxe09UGsqi9B1UTE6spUPmkk/gQA0OfrEQeB2+gt16BsELHSeWMEbHBUP
	 GG4uk4P/OquMxDe6Ih5yILZ2L/YluWSiXIfMprDoSomq6bYxSQKAYE6RmTrPpgxAizhnT
	 uUN2+c6BXxQf3N5e/VQnj/KRjAGZejaRO9T3iZx73Djw9870UG5zfDdmNGzjaYj6chg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=TmDXCNBJ;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F417D606A330
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 11:42:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F417D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=TmDXCNBJ
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so57892165e9.2
        for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 03:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795693325; x=1796298125; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:subject
         :content-transfer-encoding:content-type:mime-version:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XL3nMkkdw+gDxLxoVJw+xAao7MyGsp5RlD5LNf6Oork=;
        b=TmDXCNBJnMFgp7CPaO7OCbkcAsMsFDQo4BlC18Eq/dYYrFbt+QQiSd/WAnTNk65o0m
         zMm0cOmIsEoO1sy1vx4771fT1MLsnb7cK4PPUg+LxyARKNP7EJpWuvxqaPEL4vKsy5ZB
         ULsJFcQ2wIxWmPcFYmd9BWdbZRwE2FxPhuOMUdAyrRFmtLQWIWxnucrR2EMlKOFXEUpE
         rRdV527Qe44iS/RCNy9nNOC0Gi6ScdvVquS0HuRsO48IrDcFxZicXngSpnuZUm/2A43c
         nWzogzHyPdZWpZBqWx5JSPgifpInUZwjTFwoZqTMhpjR3JDyeZzPDV+Aakt3TwcxKUzH
         WgWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795693325; x=1796298125;
        h=message-id:date:references:in-reply-to:cc:to:subject
         :content-transfer-encoding:content-type:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XL3nMkkdw+gDxLxoVJw+xAao7MyGsp5RlD5LNf6Oork=;
        b=yuNLjovbw5E21q7c5tZK9bZut+uwm8SrTIgow/CWDsQ1Jp2T0LVoxsky07C/ggqox/
         Y2+Weu6N4GgHg9oCN1/amK4JnfTKYrsQJwIiu8tdi+uS13wT1/eilteWBVa22b5ZaywF
         bKjq14JqGzVtlxbRT793IC9S1O0xct1ySxWc1/iqEgzpLErkjdSC0bno3Yx4lmpR+dRF
         aZrp3bdhDjDmpGt6TwxzqwOZObMUADsxB8tchAUUTcwHra64Pk9HWVqcMOuxkTgjmQTu
         Mb4EG8akzOQS7NUuh1rEmTNI1TY1wY/1Ze48SM4K6twTMNgukj6sVlMwq9OULr44BBmV
         a2bQ==
X-Forwarded-Encrypted: i=1; AL+hErEZyQRqxnfYOdQ/sy8msX8JZKlFH0/qIqWNTe2ZWjhMDyBbVSP6PgUIHF6jFtJcBZwUkNM65PpAEQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z8VQvIOjCnRTOu5XeL+CPpZHXMpdjHjI84ozB3Ie8HGDC2fFcUI
	a8dK/g+7fvFM3YDY+C4p1+SF83NFjSRE2S5jYpNzLNCZTp+j9ZEcUz6OVyy5q/pQukY=
X-Gm-Gg: AZFdTZcZPFwrfHn6OuNcKMwwsLhgnj9hECNKaMHnT+2GSLxJANo4WVsZVmDOchW8aqY
	m527U+lKzL07SpkxGgo2n/489m7ka9s7cfe3IsOXVvJi7Ab14wRA6uG7RmkZ/Ag953Tsa+iYcAt
	19q42dwjk2OxeqkobJ4c7Q/A8jF9IRd0ZEuuv+Jla7v8CRu11SuRLKVsjADzBJ1OC8ZXXa6MWtl
	hVJdO6FWuunmz2h8nkNYxmoqOUZ7muBHWQesHrLgXzTFaOqIke34F5aa6Qq2EWsHUW+Ls+Xn8Li
	66WiCE8qBmHfWU124fwK2qaieLwibRKK3cgn8OFDGjIrT/Jpp1l4/ipAzhLiM5lARYENWxQO7IE
	haB93Ys6iI+ZEcr/8toJ5q23VV+F4hvXr8OhK1n1sF0DxPq2yWp2345WaVSitdsewr5CF0msLQW
	mLZVByrHqj8YwoTpqotOvnl9VP/6/X94lgMxZW4TxQrKugwfe/4DoaEmAQfk9waEM6AoB+hzmWd
	DCpKZP/Q55FKB2hKCv3JYkXYjBcuilatto1ihzIwYHPmCTCKH1vDwHM16Ao7Gnc+Hd9+DqElSnm
	X9BhQ//8370JHpkp6gzebPUi6VTYW8M0/NZz98F2OdYhm6W6q9LPPYMXH8IAPFkE6PojyvHAmfl
	hQSK+WRq/JO6KaHkZ
X-Received: by 2002:a05:600c:840d:b0:4bb:6814:738c with SMTP id 5b1f17b1804b1-4bb88820cedmr433446645e9.22.1795693325056;
        Thu, 26 Nov 2026 03:42:05 -0800 (PST)
Received: from localhost (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4ab6a68048esm42153589f8f.29.2026.11.26.03.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 03:42:04 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 4/4] multipathd: add commands to wait for reconfigures
 to complete
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
 device-mapper development <dm-devel@lists.linux.dev>, 
 Martin Wilck <Martin.Wilck@suse.com>
In-Reply-To: <20261126052434.725762-5-bmarzins@redhat.com>
References: <20261126052434.725762-1-bmarzins@redhat.com>
 <20261126052434.725762-5-bmarzins@redhat.com>
Date: Thu, 26 Nov 2026 12:42:00 +0100
Message-Id: <179569332053.310906.14178249137263551915.b4-review@b4>
X-Mailer: b4 0.16.0

> Add the "reconfigure wait" and "reconfigure all wait" multipathd
> commands. These work just like the non-wait options, but they do not
> return until there are no more scheduled reconfigures.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>
> diff --git a/multipathd/callbacks.c b/multipathd/callbacks.c
> index 2027c3a..6064751 100644
> --- a/multipathd/callbacks.c
> +++ b/multipathd/callbacks.c
> @@ -44,6 +44,9 @@ void init_handler_callbacks(void)
>  	set_unlocked_handler_callback(VRB_RECONFIGURE, HANDLER(cli_reconfigure));
>  	set_unlocked_handler_callback(VRB_RECONFIGURE | Q1_ALL,
>  				      HANDLER(cli_reconfigure_all));
> +	set_unlocked_handler_callback(VRB_RECONFIGURE | Q1_WAIT, HANDLER(cli_reconfigure_wait));
> +	set_unlocked_handler_callback(VRB_RECONFIGURE | Q1_ALL | Q2_WAIT,
> +				      HANDLER(cli_reconfigure_all_wait));
>  	set_handler_callback(VRB_SUSPEND | Q1_MAP, HANDLER(cli_suspend));
>  	set_handler_callback(VRB_RESUME | Q1_MAP, HANDLER(cli_resume));
>  	set_handler_callback(VRB_RESIZE | Q1_MAP, HANDLER(cli_resize));
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index 0d679c8..25dce4e 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -228,6 +228,7 @@ load_keys (void)
>  	r += add_key(keys, "setprhold", VRB_SETPRHOLD, 0);
>  	r += add_key(keys, "unsetprhold", VRB_UNSETPRHOLD, 0);
>  	r += add_key(keys, "pathlist", KEY_PATHLIST, 1);
> +	r += add_key(keys, "wait", KEY_WAIT, 0);
>  
>  	if (r) {
>  		free_keys(keys);
> diff --git a/multipathd/cli.h b/multipathd/cli.h
> index 6d599ca..1c6c42e 100644
> --- a/multipathd/cli.h
> +++ b/multipathd/cli.h
> @@ -64,6 +64,7 @@ enum {
>  	KEY_GROUP		= 82,
>  	KEY_KEY			= 83,
>  	KEY_PATHLIST		= 84,
> +	KEY_WAIT		= 85,
>  };
>  
>  /*
> @@ -85,6 +86,7 @@ enum {
>  	Q1_ALL			= KEY_ALL << 8,
>  	Q1_DAEMON		= KEY_DAEMON << 8,
>  	Q1_STATUS		= KEY_STATUS << 8,
> +	Q1_WAIT			= KEY_WAIT << 8,
>  
>  	/* byte 2: qualifier 2 */
>  	Q2_FMT			= KEY_FMT << 16,
> @@ -97,6 +99,7 @@ enum {
>  	Q2_GROUP		= KEY_GROUP << 16,
>  	Q2_KEY			= KEY_KEY << 16,
>  	Q2_PATHLIST		= KEY_PATHLIST << 16,
> +	Q2_WAIT			= KEY_WAIT << 16,
>  
>  	/* byte 3: qualifier 3 */
>  	Q3_FMT			= KEY_FMT << 24,
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index e5c43bd..86f050a 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1021,7 +1021,7 @@ static int cli_reconfigure(void *v, struct strbuf *reply,
>  {
>  	condlog(2, "reconfigure (operator)");
>  
> -	schedule_reconfigure(FORCE_RELOAD_WEAK);
> +	schedule_reconfigure(FORCE_RELOAD_WEAK, NULL);
>  	return 0;
>  }
>  
> @@ -1030,7 +1030,25 @@ int cli_reconfigure_all(void *v, struct strbuf *reply,
>  {
>  	condlog(2, "reconfigure all (operator)");
>  
> -	schedule_reconfigure(FORCE_RELOAD_YES);
> +	schedule_reconfigure(FORCE_RELOAD_YES, NULL);
> +	return 0;
> +}
> +
> +static int cli_reconfigure_wait(void *v, struct strbuf *reply,
> +				struct list_head *wait_node, void *data)
> +{
> +	condlog(2, "reconfigure wait (operator)");
> +
> +	schedule_reconfigure(FORCE_RELOAD_WEAK, wait_node);
> +	return 0;
> +}
> +
> +static int cli_reconfigure_all_wait(void *v, struct strbuf *reply,
> +			            struct list_head *wait_node, void *data)
> +{
> +	condlog(2, "reconfigure all wait (operator)");
> +
> +	schedule_reconfigure(FORCE_RELOAD_YES, wait_node);
>  	return 0;
>  }
>  
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 1bb8eac..83773d9 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -135,6 +135,8 @@ static enum daemon_status running_state = DAEMON_INIT;
>  static bool delayed_reconfig;
>  /* Don't access this variable without holding config_lock */
>  static enum force_reload_types reconfigure_pending = FORCE_RELOAD_NONE;
> +/* Don't access this variable without holding config_lock */
> +LIST_HEAD(config_wait_list);

I am unsure about the purpose of using config_lock for this list.
The uxlsnr side uses client_wait_lock, and knows nothing about config_lock,
so it may manipulate elements of this list without taking config_lock.
The list should be protected by client_wait_lock.

>  pid_t daemon_pid;
>  static pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
>  static pthread_cond_t config_cond;
> @@ -336,7 +338,8 @@ void remove_map_callback(struct multipath *mpp)
>  		unblock_reconfigure();
>  }
>  
> -void schedule_reconfigure(enum force_reload_types requested_type)
> +void schedule_reconfigure(enum force_reload_types requested_type,
> +			  struct list_head *wait_node)
>  {
>  	pthread_mutex_lock(&config_lock);
>  	pthread_cleanup_push(config_cleanup, NULL);
> @@ -360,6 +363,8 @@ void schedule_reconfigure(enum force_reload_types requested_type)
>  	default:
>  		break;
>  	}
> +	if (wait_node)
> +		wait_for_event(wait_node, &config_wait_list);

We should only wait for this event if reconfigure_pending ws actually set.
Waiting in DAEMON_SHUTDOWN state seems definitely wrong.

>  	pthread_cleanup_pop(1);
>  }
>  
> @@ -3657,7 +3662,7 @@ handle_signals(bool nonfatal)
>  		return;
>  	if (reconfig_sig) {
>  		condlog(3, "reconfigure (signal)");
> -		schedule_reconfigure(FORCE_RELOAD_WEAK);
> +		schedule_reconfigure(FORCE_RELOAD_WEAK, NULL);
>  	}
>  	if (log_reset_sig) {
>  		condlog(3, "reset log (signal)");
> @@ -4169,6 +4174,12 @@ child (__attribute__((unused)) void *param)
>  			pthread_mutex_unlock(&config_lock);
>  
>  			rc = reconfigure(vecs, reload_type);
> +
> +			/* wake up waiters if there are no pending reconfigs */
> +			pthread_mutex_lock(&config_lock);
> +			if (reconfigure_pending == FORCE_RELOAD_NONE)
> +				wakeup_event_waiter(&config_wait_list);
> +			pthread_mutex_unlock(&config_lock);
>  		} else {
>  			pthread_mutex_lock(&config_lock);
>  			delayed_reconfig = true;
> diff --git a/multipathd/main.h b/multipathd/main.h
> index b66208e..76d0919 100644
> --- a/multipathd/main.h
> +++ b/multipathd/main.h
> @@ -34,7 +34,8 @@ void exit_daemon(void);
>  const char *daemon_status(bool *pending_reconfig);
>  enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
>  					    unsigned long ms);
> -void schedule_reconfigure(enum force_reload_types requested_type);
> +void schedule_reconfigure(enum force_reload_types requested_type,
> +			  struct list_head *wait_node);
>  int need_to_delay_reconfig (struct vectors *);
>  int ev_add_path (struct path *, struct vectors *, int);
>  int ev_remove_path (struct path *, struct vectors *, int);
> diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
> index 632cbe4..aee6700 100644
> --- a/multipathd/multipathd.8.in
> +++ b/multipathd/multipathd.8.in
> @@ -274,13 +274,28 @@ group index, starting with 1.
>  .B reconfigure
>  Rereads the configuration, and reloads all changed multipath devices. This
>  also happens at startup, when the service is reload, or when a SIGHUP is
> -received.
> +received. This command schedules the reconfiguration and returns immediately.
> +.
> +.TP
> +.B reconfigure wait
> +Rereads the configuration, and reloads all changed multipath devices. This
> +also happens at startup, when the service is reload, or when a SIGHUP is
> +received. This command waits for for the reconfiguration to complete before
> +returning

Nit: "for for", missing period at end.

The actual implementation waits for all scheduled reconfigure operations to end,
not just for "the" reconfiguration started by this command. Not sure if we need
to mention that, it may cause more confusion than insight, as overlapping
reconfigure requests are rare in practice.

>  .
>  .TP
>  .B reconfigure all
>  Rereads the configuration, and reloads all multipath devices regardless of
>  whether or not they have changed. This also happens when \fImultipath -r\fR is
> -run.
> +run. This command schedules the reconfiguration and returns immediately.
> +.
> +.TP
> +.B reconfigure all wait
> +Rereads the configuration, and reloads all multipath devices regardless of
> +whether or not they have changed. This also happens when \fImultipath -r\fR is
> +run. This command waits for for the reconfiguration to complete before
> +returning

Same comment as for "reconfigure wait".

-- 
Martin Wilck <mwilck@suse.com>
