Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581C4C433DF
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 20:14:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 80E0F20878
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 20:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eXnyM5AR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80E0F20878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1602879238;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=l01BXR2pAdHrx0mnxMuC6Ozpgmd8kf9wmUt/rX+B9wo=;
	b=eXnyM5ARPvCYLx1v1xu/FkJjKaZCCk/o26DiGpbwDKaQsTHrI3L7ljqqVkr2tmsLhnoPUr
	Qj311/27FAOwGo/yHNL2/RVYr+oQtZJMk75n6UiulgNBJen2s5ufvme776gJBtzTOAlLWx
	cxtEtSUdBv2ia980iwBNbfSm/w9i1x0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-JP9N5_vPOLqO3VMGgJ02qQ-1; Fri, 16 Oct 2020 16:13:55 -0400
X-MC-Unique: JP9N5_vPOLqO3VMGgJ02qQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97F3F186DD2F;
	Fri, 16 Oct 2020 20:13:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2401D5D9CC;
	Fri, 16 Oct 2020 20:13:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 76951180B658;
	Fri, 16 Oct 2020 20:13:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GKDkxx029633 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 16:13:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BE7581000232; Fri, 16 Oct 2020 20:13:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 37AEE10013D7;
	Fri, 16 Oct 2020 20:13:43 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09GKDflq026931; 
	Fri, 16 Oct 2020 15:13:41 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09GKDeB0026930;
	Fri, 16 Oct 2020 15:13:40 -0500
Date: Fri, 16 Oct 2020 15:13:40 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201016201340.GV3384@octiron.msp.redhat.com>
References: <20201016104501.8700-1-mwilck@suse.com>
	<20201016104501.8700-26-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201016104501.8700-26-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 25/29] libmultipath: introduce symbolic
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 16, 2020 at 12:44:57PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>

Git complains about this patch adding new blank line at EOF
in libmultipath/debug.h

Otherwise, it looks good.
-Ben

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/debug.c     |  4 ++--
>  libmultipath/debug.h     |  7 +++++++
>  libmultipath/devmapper.c |  4 ++--
>  multipath/main.c         |  4 ++--
>  multipathd/main.c        | 17 ++++++++---------
>  tests/globals.c          |  3 ++-
>  tests/hwtable.c          |  2 +-
>  7 files changed, 24 insertions(+), 17 deletions(-)
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
> index 1f3bc8b..91ba02b 100644
> --- a/libmultipath/debug.h
> +++ b/libmultipath/debug.h
> @@ -12,3 +12,10 @@ extern int libmp_verbosity;
>  
>  #define condlog(prio, fmt, args...) \
>  	dlog(logsink, prio, fmt "\n", ##args)
> +
> +enum {
> +	LOGSINK_STDERR_WITH_TIME = 0,
> +	LOGSINK_STDERR_WITHOUT_TIME = -1,
> +	LOGSINK_SYSLOG = 1,
> +};
> +
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index a8e0611..78112a9 100644
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
> index 9bdc5d2..46cfa17 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -840,7 +840,7 @@ main (int argc, char *argv[])
>  	libmultipath_init();
>  	if (atexit(dm_lib_exit) || atexit(libmultipath_exit))
>  		condlog(1, "failed to register cleanup handler for libmultipath: %m");
> -	logsink = 0;
> +	logsink = LOGSINK_STDERR_WITH_TIME;
>  	if (init_config(DEFAULT_CONFIGFILE))
>  		exit(RTVL_FAIL);
>  	if (atexit(uninit_config))
> @@ -991,7 +991,7 @@ main (int argc, char *argv[])
>  	if (dev_type == DEV_UEVENT) {
>  		openlog("multipath", 0, LOG_DAEMON);
>  		setlogmask(LOG_UPTO(libmp_verbosity + 3));
> -		logsink = 1;
> +		logsink = LOGSINK_SYSLOG;
>  	}
>  
>  	set_max_fds(conf->max_fds);
> diff --git a/multipathd/main.c b/multipathd/main.c
> index fbd354c..725a10b 100644
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
> @@ -3032,7 +3032,7 @@ static void cleanup_child(void)
>  		cleanup_dmevent_waiter();
>  
>  	cleanup_pidfile();
> -	if (logsink == 1)
> +	if (logsink == LOGSINK_SYSLOG)
>  		log_thread_stop();
>  
>  	cleanup_conf();
> @@ -3078,7 +3078,7 @@ child (__attribute__((unused)) void *param)
>  	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
>  	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
>  
> -	if (logsink == 1) {
> +	if (logsink == LOGSINK_SYSLOG) {
>  		setup_thread_attr(&log_attr, 64 * 1024, 0);
>  		log_thread_start(&log_attr);
>  		pthread_attr_destroy(&log_attr);
> @@ -3309,7 +3309,7 @@ main (int argc, char *argv[])
>  	ANNOTATE_BENIGN_RACE_SIZED(&uxsock_timeout, sizeof(uxsock_timeout),
>  		"Suppress complaints about this scalar variable");
>  
> -	logsink = 1;
> +	logsink = LOGSINK_SYSLOG;
>  
>  	if (getuid() != 0) {
>  		fprintf(stderr, "need to be root\n");
> @@ -3336,9 +3336,8 @@ main (int argc, char *argv[])
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
> @@ -3348,7 +3347,7 @@ main (int argc, char *argv[])
>  			libmp_verbosity = verbosity = atoi(optarg);
>  			break;
>  		case 's':
> -			logsink = -1;
> +			logsink = LOGSINK_STDERR_WITHOUT_TIME;
>  			break;
>  		case 'k':
>  			logsink = 0;
> @@ -3381,7 +3380,7 @@ main (int argc, char *argv[])
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
> 2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

