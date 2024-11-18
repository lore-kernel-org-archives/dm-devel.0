Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190FB197531
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 20:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731963384; cv=none; b=ac9vl/2xXueOYr0+616ZPv9s7TcF+Km+D7haQ4S/9sIDmZIQJLO8fi4iAuXEgPxbRc3/gpgJ5BKGkP3N6wdNsEAfaxken0RiMK+yZO+AwTzCVHxiGxBjRy5sdBSog/V20FTvqIpl5Af0wsSF/ZXaqVmpy8iNDt1lAxK7rcVlNI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731963384; c=relaxed/simple;
	bh=9ze9iqGmzVjVOnIKUb1LAEBobeP3Dft5NhuA0174WIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=bMyMNu4hBft1+5dbuYPV8/wBtvWFLow8X/pxUKy+ZMlLinzhb7GCFym4qcJD299Z7IWq7HNjlGO0eUHlOrqBh8PAEamZRI0ndpHiZVbinNlTzeSGbkDL0jEZvVXhHIIfIQXIHKHcVJALewXgftYvpqoGzv9ad8sJAdn83BpKETg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JaXsWx0r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JaXsWx0r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731963381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZXjG0Xb+SSFVZGaQjWitUsvTm2ixUeQK4MKJwTZyaI4=;
	b=JaXsWx0rFq8n6G6gJ1MNc/aaeKjhz0VldReyqtz7W/VxIDsbxnH3YJng3Qk/V8dN93oiFP
	8k2npBmNVplzFZ+mEI1xbnOeImL/CdLZhbwA5CU4q41x+eqscm0DbIiA52eC8PfW5RMQfY
	Y5gPR5rCgyAiHb7ABn7bMYk7uwg1s7U=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-384-6CFytj7pPQubrbUdBWvV7g-1; Mon,
 18 Nov 2024 15:56:19 -0500
X-MC-Unique: 6CFytj7pPQubrbUdBWvV7g-1
X-Mimecast-MFC-AGG-ID: 6CFytj7pPQubrbUdBWvV7g
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65DF019541A0;
	Mon, 18 Nov 2024 20:56:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 017001956054;
	Mon, 18 Nov 2024 20:56:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AIKuG5i667708
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 18 Nov 2024 15:56:16 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AIKuGMS667707;
	Mon, 18 Nov 2024 15:56:16 -0500
Date: Mon, 18 Nov 2024 15:56:16 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 1/1] multipathd: move systemd watchdog handling into
 daemon
Message-ID: <Zzup8FZf4XYuTeyH@redhat.com>
References: <20241118130447.554773-1-mwilck@suse.com>
 <20241118130447.554773-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241118130447.554773-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PrSVjHNHfzTu1xQcG_ghppK07TJYKDByeUTeL5MBXtI_1731963378
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 18, 2024 at 02:04:47PM +0100, Martin Wilck wrote:
> Only multipathd needs to take care of notifying systemd. There's
> no need to track this information in struct config, or to limit our
> checker interval to it, as checkerloop() wakes up every second anyway.
> 
> While at it, fix the watchdog enablement logic:
> 
> - the watchdog should only be active if WATCHDOG_PID is either unset,
>   or matches the daemon's PID, and if WATCHDOG_USEC is not 0.
> - the watchdog should trigger twice per systemd-set interval.
> - if WatchdogSec= is set to an unreasonable value, make a smarter
>   choice than just disabling the watchdog, and print a more meaningful
>   error message.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/config.c | 25 ----------------
>  libmultipath/config.h |  1 -
>  multipathd/main.c     | 67 ++++++++++++++++++++++++++++++++++---------
>  3 files changed, 53 insertions(+), 40 deletions(-)
> 
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 0e3a5cc..8b424d1 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -858,27 +858,6 @@ process_config_dir(struct config *conf, char *dir)
>  	pthread_cleanup_pop(1);
>  }
>  
> -#ifdef USE_SYSTEMD
> -static void set_max_checkint_from_watchdog(struct config *conf)
> -{
> -	char *envp = getenv("WATCHDOG_USEC");
> -	unsigned long checkint;
> -
> -	if (envp && sscanf(envp, "%lu", &checkint) == 1) {
> -		/* Value is in microseconds */
> -		checkint /= 1000000;
> -		if (checkint < 1 || checkint > UINT_MAX) {
> -			condlog(1, "invalid value for WatchdogSec: \"%s\"", envp);
> -			return;
> -		}
> -		if (conf->max_checkint == 0 || conf->max_checkint > checkint)
> -			conf->max_checkint = checkint;
> -		condlog(3, "enabling watchdog, interval %ld", checkint);
> -		conf->use_watchdog = true;
> -	}
> -}
> -#endif
> -
>  static int init_config__ (const char *file, struct config *conf);
>  
>  int init_config(const char *file)
> @@ -916,7 +895,6 @@ int init_config__ (const char *file, struct config *conf)
>  	conf->attribute_flags = 0;
>  	conf->reassign_maps = DEFAULT_REASSIGN_MAPS;
>  	conf->checkint = CHECKINT_UNDEF;
> -	conf->use_watchdog = false;
>  	conf->max_checkint = 0;
>  	conf->force_sync = DEFAULT_FORCE_SYNC;
>  	conf->partition_delim = (default_partition_delim != NULL ?
> @@ -967,9 +945,6 @@ int init_config__ (const char *file, struct config *conf)
>  	/*
>  	 * fill the voids left in the config file
>  	 */
> -#ifdef USE_SYSTEMD
> -	set_max_checkint_from_watchdog(conf);
> -#endif
>  	if (conf->max_checkint == 0) {
>  		if (conf->checkint == CHECKINT_UNDEF)
>  			conf->checkint = DEFAULT_CHECKINT;
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 94cdf25..5b4ebf8 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -148,7 +148,6 @@ struct config {
>  	unsigned int checkint;
>  	unsigned int max_checkint;
>  	unsigned int adjust_int;
> -	bool use_watchdog;
>  	int pgfailback;
>  	int rr_weight;
>  	int no_path_retry;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index a99da81..1f0d02c 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2153,6 +2153,58 @@ partial_retrigger_tick(vector pathvec)
>  	}
>  }
>  
> +#ifdef USE_SYSTEMD
> +static int get_watchdog_interval(void)
> +{
> +	char *envp;
> +	long checkint;
> +	long pid;
> +
> +	envp = getenv("WATCHDOG_PID");
> +	/* See sd_watchdog_enabled(3) */
> +	if (envp && sscanf(envp, "%lu", &pid) == 1 && pid != daemon_pid)
> +		return -1;
> +
> +	envp = getenv("WATCHDOG_USEC");
> +	if (!envp || sscanf(envp, "%lu", &checkint) != 1 || checkint == 0)
> +		return -1;
> +
> +	/*
> +	 * Value is in microseconds, and the watchdog should be triggered
> +	 * twice per interval.
> +	 */
> +	checkint /= 2000000;
> +	if (checkint > INT_MAX / 2) {

If we're worried that WATCHDOG_USEC might be larger than INT_MAX, we
should probably make checkint a "unsigned long long", because I believe
it's possible to run multipath on a 32-bit system. We can still return
an int, of course.

> +		condlog(1, "WatchdogSec=%ld is too high, assuming %d",
> +			checkint * 2, INT_MAX);
> +			checkint = INT_MAX / 2;
> +	} else if (checkint < 1) {
> +		condlog(1, "WatchdogSec=1 is too low, daemon will be killed by systemd!");
> +		checkint = 1;
> +	}
> +
> +	condlog(3, "enabling watchdog, interval %lds", checkint);
> +	return checkint;
> +}
> +
> +static void watchdog_tick(void) {

Instead of assuming one tick here, we should either pass in ticks or
pass in the current time (start_tile) from checkerloop(). Otherwise, if
the checkers take too long and more than two seconds elapse on average
between loops, we might not send our notification soon enough for the
watchdog timer.

-Ben

> +	static int watchdog_interval, watchdog_tick;
> +
> +	if (watchdog_interval == 0)
> +		watchdog_interval = get_watchdog_interval();
> +	if (watchdog_interval < 0)
> +		return;
> +
> +	if (--watchdog_tick < 0) {
> +		condlog(4, "%s: sending watchdog message", __func__);
> +		sd_notify(0, "WATCHDOG=1");
> +		watchdog_tick = watchdog_interval;
> +	}
> +}
> +#else
> +static void watchdog_tick(void) {}
> +#endif
> +
>  static bool update_prio(struct multipath *mpp, bool refresh_all)
>  {
>  	int oldpriority;
> @@ -2931,9 +2983,6 @@ checkerloop (void *ap)
>  	struct timespec last_time;
>  	struct config *conf;
>  	int foreign_tick = 0;
> -#ifdef USE_SYSTEMD
> -	bool use_watchdog;
> -#endif
>  
>  	pthread_cleanup_push(rcu_unregister, NULL);
>  	rcu_register_thread();
> @@ -2944,13 +2993,6 @@ checkerloop (void *ap)
>  	get_monotonic_time(&last_time);
>  	last_time.tv_sec -= 1;
>  
> -	/* use_watchdog is set from process environment and never changes */
> -	conf = get_multipath_config();
> -#ifdef USE_SYSTEMD
> -	use_watchdog = conf->use_watchdog;
> -#endif
> -	put_multipath_config(conf);
> -
>  	while (1) {
>  		struct timespec diff_time, start_time, end_time;
>  		int num_paths = 0, strict_timing;
> @@ -2967,10 +3009,7 @@ checkerloop (void *ap)
>  			(long)diff_time.tv_sec, diff_time.tv_nsec / 1000);
>  		last_time = start_time;
>  		ticks = diff_time.tv_sec;
> -#ifdef USE_SYSTEMD
> -		if (use_watchdog)
> -			sd_notify(0, "WATCHDOG=1");
> -#endif
> +		watchdog_tick();
>  		while (checker_state != CHECKER_FINISHED) {
>  			struct multipath *mpp;
>  			int i;
> -- 
> 2.47.0

