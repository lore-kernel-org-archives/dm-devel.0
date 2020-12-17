Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBE8C4361B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 03:45:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C37B02371F
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 03:45:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C37B02371F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608176736;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yRvRznKAYFgW14xpGfWtNDpRlL43MJFgLxNjyaTd26c=;
	b=fH6ILOFcPbCjrG6yjm4+zFD0xyS32exlfHBcGDuqqfZEmMVALwqxuJr59dyVGGZLn7lEXT
	NeFLUcizQdiDt/hlnn/FfbfDu3dfTU1a3/9FaxwGfwn8Jb0A8HTXIMkGWy7qt0mxufmXmD
	xEBXGiH/LFFbyuLMl6G9SRb3vgWGR6k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-ri8fD55TNimLQefd73QZow-1; Wed, 16 Dec 2020 22:45:32 -0500
X-MC-Unique: ri8fD55TNimLQefd73QZow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BB3180EFAA;
	Thu, 17 Dec 2020 03:45:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 78C4118017;
	Thu, 17 Dec 2020 03:45:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3EA6E4A7C6;
	Thu, 17 Dec 2020 03:45:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BH3gXeR012909 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 22:42:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5F9C360C5F; Thu, 17 Dec 2020 03:42:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A747D60C43;
	Thu, 17 Dec 2020 03:42:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BH3gSu2028202; 
	Wed, 16 Dec 2020 21:42:28 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BH3gSEH028201;
	Wed, 16 Dec 2020 21:42:28 -0600
Date: Wed, 16 Dec 2020 21:42:27 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201217034227.GX3103@octiron.msp.redhat.com>
References: <20201216181708.22224-1-mwilck@suse.com>
	<20201216181708.22224-26-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201216181708.22224-26-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 25/29] libmultipath: introduce symbolic
 values for logsink
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Wed, Dec 16, 2020 at 07:17:04PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/debug.c     |  4 ++--
>  libmultipath/debug.h     |  6 ++++++
>  libmultipath/devmapper.c |  4 ++--
>  multipath/main.c         |  4 ++--
>  multipathd/main.c        | 17 ++++++++---------
>  tests/globals.c          |  3 ++-
>  tests/hwtable.c          |  2 +-
>  7 files changed, 23 insertions(+), 17 deletions(-)
> 
> diff --git a/libmultipath/debug.c b/libmultipath/debug.c
> index a1713b9..f9b7755 100644
> --- a/libmultipath/debug.c
> +++ b/libmultipath/debug.c
> @@ -25,8 +25,8 @@ void dlog (int sink, int prio, const char * fmt, ...)
>  	va_start(ap, fmt);
>  
>  	if (prio <= libmp_verbosity) {
> -		if (sink < 1) {
> -			if (sink == 0) {
> +		if (sink != LOGSINK_SYSLOG) {
> +			if (sink == LOGSINK_STDERR_WITH_TIME) {
>  				time_t t = time(NULL);
>  				struct tm *tb = localtime(&t);
>  				char buff[16];
> diff --git a/libmultipath/debug.h b/libmultipath/debug.h
> index 1f3bc8b..b6ce70a 100644
> --- a/libmultipath/debug.h
> +++ b/libmultipath/debug.h
> @@ -12,3 +12,9 @@ extern int libmp_verbosity;
>  
>  #define condlog(prio, fmt, args...) \
>  	dlog(logsink, prio, fmt "\n", ##args)
> +
> +enum {
> +	LOGSINK_STDERR_WITH_TIME = 0,
> +	LOGSINK_STDERR_WITHOUT_TIME = -1,
> +	LOGSINK_SYSLOG = 1,
> +};
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index dfe95d2..f8b180e 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -104,8 +104,8 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
>  		return;
>  
>  	va_start(ap, f);
> -	if (logsink < 1) {
> -		if (logsink == 0) {
> +	if (logsink != LOGSINK_SYSLOG) {
> +		if (logsink == LOGSINK_STDERR_WITH_TIME) {
>  			time_t t = time(NULL);
>  			struct tm *tb = localtime(&t);
>  			char buff[16];
> diff --git a/multipath/main.c b/multipath/main.c
> index 371be2a..c94bb26 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -816,7 +816,7 @@ main (int argc, char *argv[])
>  	libmultipath_init();
>  	if (atexit(dm_lib_exit) || atexit(libmultipath_exit))
>  		condlog(1, "failed to register cleanup handler for libmultipath: %m");
> -	logsink = 0;
> +	logsink = LOGSINK_STDERR_WITH_TIME;
>  	if (init_config(DEFAULT_CONFIGFILE))
>  		exit(RTVL_FAIL);
>  	if (atexit(uninit_config))
> @@ -967,7 +967,7 @@ main (int argc, char *argv[])
>  	if (dev_type == DEV_UEVENT) {
>  		openlog("multipath", 0, LOG_DAEMON);
>  		setlogmask(LOG_UPTO(libmp_verbosity + 3));
> -		logsink = 1;
> +		logsink = LOGSINK_SYSLOG;
>  	}
>  
>  	set_max_fds(conf->max_fds);
> diff --git a/multipathd/main.c b/multipathd/main.c
> index ba25751..867f0f8 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2780,7 +2780,7 @@ handle_signals(bool nonfatal)
>  	}
>  	if (log_reset_sig) {
>  		condlog(2, "reset log (signal)");
> -		if (logsink == 1)
> +		if (logsink == LOGSINK_SYSLOG)
>  			log_thread_reset();
>  	}
>  	reconfig_sig = 0;
> @@ -3033,7 +3033,7 @@ static void cleanup_child(void)
>  		cleanup_dmevent_waiter();
>  
>  	cleanup_pidfile();
> -	if (logsink == 1)
> +	if (logsink == LOGSINK_SYSLOG)
>  		log_thread_stop();
>  
>  	cleanup_conf();
> @@ -3076,7 +3076,7 @@ child (__attribute__((unused)) void *param)
>  	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
>  	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
>  
> -	if (logsink == 1) {
> +	if (logsink == LOGSINK_SYSLOG) {
>  		setup_thread_attr(&log_attr, 64 * 1024, 0);
>  		log_thread_start(&log_attr);
>  		pthread_attr_destroy(&log_attr);
> @@ -3307,7 +3307,7 @@ main (int argc, char *argv[])
>  	ANNOTATE_BENIGN_RACE_SIZED(&uxsock_timeout, sizeof(uxsock_timeout),
>  		"Suppress complaints about this scalar variable");
>  
> -	logsink = 1;
> +	logsink = LOGSINK_SYSLOG;
>  
>  	if (getuid() != 0) {
>  		fprintf(stderr, "need to be root\n");
> @@ -3334,9 +3334,8 @@ main (int argc, char *argv[])
>  		switch(arg) {
>  		case 'd':
>  			foreground = 1;
> -			if (logsink > 0)
> -				logsink = 0;
> -			//debug=1; /* ### comment me out ### */
> +			if (logsink == LOGSINK_SYSLOG)
> +				logsink = LOGSINK_STDERR_WITH_TIME;
>  			break;
>  		case 'v':
>  			if (sizeof(optarg) > sizeof(char *) ||
> @@ -3346,7 +3345,7 @@ main (int argc, char *argv[])
>  			libmp_verbosity = verbosity = atoi(optarg);
>  			break;
>  		case 's':
> -			logsink = -1;
> +			logsink = LOGSINK_STDERR_WITHOUT_TIME;
>  			break;
>  		case 'k':
>  			logsink = 0;
> @@ -3379,7 +3378,7 @@ main (int argc, char *argv[])
>  		char * s = cmd;
>  		char * c = s;
>  
> -		logsink = 0;
> +		logsink = LOGSINK_STDERR_WITH_TIME;
>  		if (verbosity)
>  			libmp_verbosity = verbosity;
>  		conf = load_config(DEFAULT_CONFIGFILE);
> diff --git a/tests/globals.c b/tests/globals.c
> index 8add5eb..fc0c07a 100644
> --- a/tests/globals.c
> +++ b/tests/globals.c
> @@ -1,9 +1,10 @@
>  #include "structs.h"
>  #include "config.h"
> +#include "debug.h"
>  
>  /* Required globals */
>  struct udev *udev;
> -int logsink = -1;
> +int logsink = LOGSINK_STDERR_WITHOUT_TIME;
>  struct config conf = {
>  	.verbosity = 4,
>  };
> diff --git a/tests/hwtable.c b/tests/hwtable.c
> index 57f832b..4dd0873 100644
> --- a/tests/hwtable.c
> +++ b/tests/hwtable.c
> @@ -53,7 +53,7 @@ struct hwt_state {
>  
>  static struct config *_conf;
>  struct udev *udev;
> -int logsink = -1;
> +int logsink = LOGSINK_STDERR_WITHOUT_TIME;
>  
>  struct config *get_multipath_config(void)
>  {
> -- 
> 2.29.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

