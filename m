Return-Path: <SRS0=29P4=D2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FE5C433E7
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 20:00:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 66415222B8
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 20:00:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Um57Vndk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66415222B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603137630;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RcFVJ6gymnWhNwStp/FXUQ6tBxtiLw6TBPWS9L56DCc=;
	b=Um57VndkYFNEqbrdj5HZyRyXEEhsYhxbl5VdBQN9HA8UzrajppaEXG7btUqbqxqOFP1PI2
	+GU4czW/Ph1m3sXYKVXhyeJjgHz3dVXuI6OmR7PWPKepntlrTNttKBwGNMRmoMLJGTPMw/
	Ta+5tJuxrGqDIgYIHaVW/G6rMGrakLs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-CUt5Q1BtP_qLH4stzxVAJg-1; Mon, 19 Oct 2020 16:00:27 -0400
X-MC-Unique: CUt5Q1BtP_qLH4stzxVAJg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD4848049C9;
	Mon, 19 Oct 2020 20:00:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4518010013D0;
	Mon, 19 Oct 2020 20:00:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6BCF6181A06B;
	Mon, 19 Oct 2020 20:00:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09JK0IOv028605 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Oct 2020 16:00:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CCBAD5D9EF; Mon, 19 Oct 2020 20:00:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22C865D9D2;
	Mon, 19 Oct 2020 20:00:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09JK0DTo013939; 
	Mon, 19 Oct 2020 15:00:13 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09JK0CTY013938;
	Mon, 19 Oct 2020 15:00:12 -0500
Date: Mon, 19 Oct 2020 15:00:12 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201019200012.GE3384@octiron.msp.redhat.com>
References: <20201016104501.8700-1-mwilck@suse.com>
	<20201016104501.8700-19-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201016104501.8700-19-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 18/29] libmultipath: fix log_thread
 startup and teardown
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 16, 2020 at 12:44:50PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> This fixes several issues with the log_thread. First, the running
> flag logq_running should be set by the thread itself, not by
> log_thread_start()/_stop(). Second, the thread was both cancelled and
> terminated via a flag (again, logq_running). It's sufficient,
> and better, to just cancel it and use logq_running as indication for
> successful termination. Third, the locking wasn't cancel-safe in some
> places. Forth, log_thread_start() and log_thread_stop() didn't wait for
> startup/teardown properly. Fifth, using (pthread_t)0 is wrong (pthread_t is
> opaque; there's no guarantee that 0 is not a valid pthread_t value). Sixth,
> pthread_cancel() was called under logq_lock, which doesn't make sense to
> me at all.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/log_pthread.c | 72 ++++++++++++++++++++++++++------------
>  1 file changed, 49 insertions(+), 23 deletions(-)
> 
> diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
> index 0c327ff..3c73941 100644
> --- a/libmultipath/log_pthread.c
> +++ b/libmultipath/log_pthread.c
> @@ -13,6 +13,7 @@
>  #include "log_pthread.h"
>  #include "log.h"
>  #include "lock.h"
> +#include "util.h"
>  
>  static pthread_t log_thr;
>  
> @@ -56,44 +57,70 @@ static void flush_logqueue (void)
>  	} while (empty == 0);
>  }
>  
> +static void cleanup_log_thread(__attribute((unused)) void *arg)
> +{
> +	logdbg(stderr, "log thread exiting");
> +	pthread_mutex_lock(&logev_lock);
> +	logq_running = 0;
> +	pthread_mutex_unlock(&logev_lock);
> +}
> +
>  static void * log_thread (__attribute__((unused)) void * et)
>  {
>  	int running;
>  
>  	pthread_mutex_lock(&logev_lock);
> -	logq_running = 1;
> +	running = logq_running;
> +	if (!running)
> +		logq_running = 1;
> +	pthread_cond_signal(&logev_cond);
>  	pthread_mutex_unlock(&logev_lock);
> +	if (running)
> +		/* already started */
> +		return NULL;
> +	pthread_cleanup_push(cleanup_log_thread, NULL);
>  
>  	mlockall(MCL_CURRENT | MCL_FUTURE);
>  	logdbg(stderr,"enter log_thread\n");
>  
>  	while (1) {
>  		pthread_mutex_lock(&logev_lock);
> -		if (logq_running && !log_messages_pending)
> +		pthread_cleanup_push(cleanup_mutex, &logev_lock);
> +		while (!log_messages_pending)
> +			/* this is a cancellation point */
>  			pthread_cond_wait(&logev_cond, &logev_lock);
>  		log_messages_pending = 0;
> -		running = logq_running;
> -		pthread_mutex_unlock(&logev_lock);
> -		if (!running)
> -			break;
> +		pthread_cleanup_pop(1);
> +
>  		flush_logqueue();
>  	}
> +	pthread_cleanup_pop(1);
>  	return NULL;
>  }
>  
>  void log_thread_start (pthread_attr_t *attr)
>  {
> -	logdbg(stderr,"enter log_thread_start\n");
> +	bool err = false;
>  
> -	pthread_mutex_init(&logq_lock, NULL);
> -	pthread_mutex_init(&logev_lock, NULL);
> -	pthread_cond_init(&logev_cond, NULL);

If you remove these initializers, then these variables are
uninitialized. I realize that patch 29 makes them statically
initialized, so I'm not sure how big of an issue it is.  I guess it
depends on how much we care about the possiblity of things not working
right when bisecting an issue.

-Ben

> +	logdbg(stderr,"enter log_thread_start\n");
>  
>  	if (log_init("multipathd", 0)) {
>  		fprintf(stderr,"can't initialize log buffer\n");
>  		exit(1);
>  	}
> +
> +	pthread_mutex_lock(&logev_lock);
> +	pthread_cleanup_push(cleanup_mutex, &logev_lock);
>  	if (pthread_create(&log_thr, attr, log_thread, NULL)) {
> +		err = true;
> +	}
> +
> +	/* wait for thread startup */
> +	while (!logq_running)
> +		pthread_cond_wait(&logev_cond, &logev_lock);
> +	pthread_cleanup_pop(1);
> +
> +	if (err) {
>  		fprintf(stderr,"can't start log thread\n");
>  		exit(1);
>  	}
> @@ -112,27 +139,26 @@ void log_thread_reset (void)
>  
>  void log_thread_stop (void)
>  {
> +	int running;
> +
>  	if (!la)
>  		return;
>  
>  	logdbg(stderr,"enter log_thread_stop\n");
>  
>  	pthread_mutex_lock(&logev_lock);
> -	logq_running = 0;
> -	pthread_cond_signal(&logev_cond);
> -	pthread_mutex_unlock(&logev_lock);
> -
> -	pthread_mutex_lock(&logq_lock);
> -	pthread_cancel(log_thr);
> -	pthread_mutex_unlock(&logq_lock);
> -	pthread_join(log_thr, NULL);
> -	log_thr = (pthread_t)0;
> +	pthread_cleanup_push(cleanup_mutex, &logev_lock);
> +	running = logq_running;
> +	if (running) {
> +		pthread_cancel(log_thr);
> +		pthread_cond_signal(&logev_cond);
> +	}
> +	pthread_cleanup_pop(1);
>  
> -	flush_logqueue();
> +	if (running)
> +		pthread_join(log_thr, NULL);
>  
> -	pthread_mutex_destroy(&logq_lock);
> -	pthread_mutex_destroy(&logev_lock);
> -	pthread_cond_destroy(&logev_cond);
>  
> +	flush_logqueue();
>  	log_close();
>  }
> -- 
> 2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

