Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EADC4361B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 05:59:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6FB623715
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 05:59:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6FB623715
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608184772;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OoXhAEyYK44OEHRyoiHt3S7RV5LCK+kcHNbED0UAUU4=;
	b=V0Z7nzKC8a4G6enpG9XDdeJtCaWtul0BqSIwEfXbnolQ4QF0zuj0oPxhXS1w3zO2WrQ6Ao
	3BzSvegEjltyHxrFmsd+BKJDuEBiMJ6zRhxzekE620DBKyLE0k2txL/k4mMMZE1pD8AxFE
	WBvcS+LprXyMPf9KPOhq72ggnjhBsns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-FS5KpsdgODCWcBtnDaPHjg-1; Thu, 17 Dec 2020 00:59:30 -0500
X-MC-Unique: FS5KpsdgODCWcBtnDaPHjg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15B09800D53;
	Thu, 17 Dec 2020 05:59:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A19F60CE9;
	Thu, 17 Dec 2020 05:59:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6D89A180954D;
	Thu, 17 Dec 2020 05:59:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BH5uPFB026635 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Dec 2020 00:56:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 76BD460C47; Thu, 17 Dec 2020 05:56:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 614B360C15;
	Thu, 17 Dec 2020 05:56:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BH5uKMb028692; 
	Wed, 16 Dec 2020 23:56:20 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BH5uJoS028691;
	Wed, 16 Dec 2020 23:56:19 -0600
Date: Wed, 16 Dec 2020 23:56:19 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201217055619.GY3103@octiron.msp.redhat.com>
References: <20201216181708.22224-1-mwilck@suse.com>
	<20201216181708.22224-30-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201216181708.22224-30-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 29/29] libmultipath: fix race between
 log_safe and log_thread_stop()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 16, 2020 at 07:17:08PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> log_safe() could race with log_thread_stop(); simply
> checking the value of log_thr has never been safe. By converting the
> mutexes to static initializers, we avoid having to destroy them, and thus
> possibly accessing a destroyed mutex in log_safe(). Furthermore, taking
> both the logev_lock and the logq_lock makes sure the logarea isn't freed
> while we are writing to it.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/log_pthread.c | 48 +++++++++++++++++++++-----------------
>  1 file changed, 26 insertions(+), 22 deletions(-)
> 
> diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
> index 3a2566a..0d48c52 100644
> --- a/libmultipath/log_pthread.c
> +++ b/libmultipath/log_pthread.c
> @@ -17,31 +17,42 @@
>  
>  static pthread_t log_thr;
>  
> -static pthread_mutex_t logq_lock;
> -static pthread_mutex_t logev_lock;
> -static pthread_cond_t logev_cond;
> +/* logev_lock must not be taken with logq_lock held */
> +static pthread_mutex_t logq_lock = PTHREAD_MUTEX_INITIALIZER;
> +static pthread_mutex_t logev_lock = PTHREAD_MUTEX_INITIALIZER;
> +static pthread_cond_t logev_cond = PTHREAD_COND_INITIALIZER;
>  
>  static int logq_running;
>  static int log_messages_pending;
>  
>  void log_safe (int prio, const char * fmt, va_list ap)
>  {
> +	bool running;
> +
>  	if (prio > LOG_DEBUG)
>  		prio = LOG_DEBUG;
>  
> -	if (log_thr == (pthread_t)0) {
> -		vsyslog(prio, fmt, ap);
> -		return;
> -	}
> +	/*
> +	 * logev_lock protects logq_running. By holding it, we avoid a race
> +	 * with log_thread_stop() -> log_close(), which would free the logarea.
> +	 */
> +	pthread_mutex_lock(&logev_lock);
> +	pthread_cleanup_push(cleanup_mutex, &logev_lock);
> +	running = logq_running;
>  
> -	pthread_mutex_lock(&logq_lock);
> -	log_enqueue(prio, fmt, ap);
> -	pthread_mutex_unlock(&logq_lock);
> +	if (running) {
> +		pthread_mutex_lock(&logq_lock);
> +		pthread_cleanup_push(cleanup_mutex, &logq_lock);
> +		log_enqueue(prio, fmt, ap);
> +		pthread_cleanup_pop(1);
>  
> -	pthread_mutex_lock(&logev_lock);
> -	log_messages_pending = 1;
> -	pthread_cond_signal(&logev_cond);
> -	pthread_mutex_unlock(&logev_lock);
> +		log_messages_pending = 1;
> +		pthread_cond_signal(&logev_cond);
> +	}
> +	pthread_cleanup_pop(1);
> +
> +	if (!running)
> +		vsyslog(prio, fmt, ap);
>  }
>  
>  static void flush_logqueue (void)
> @@ -103,9 +114,6 @@ void log_thread_start (pthread_attr_t *attr)
>  	int running = 0;
>  
>  	logdbg(stderr,"enter log_thread_start\n");
> -	pthread_mutex_init(&logq_lock, NULL);
> -	pthread_mutex_init(&logev_lock, NULL);
> -	pthread_cond_init(&logev_cond, NULL);
>  
>  	if (log_init("multipathd", 0)) {
>  		fprintf(stderr,"can't initialize log buffer\n");
> @@ -154,13 +162,9 @@ void log_thread_stop (void)
>  	}
>  	pthread_cleanup_pop(1);
>  
> -	flush_logqueue();
>  	if (running)
>  		pthread_join(log_thr, NULL);
>  
> -	pthread_mutex_destroy(&logq_lock);
> -	pthread_mutex_destroy(&logev_lock);
> -	pthread_cond_destroy(&logev_cond);
> -
> +	flush_logqueue();
>  	log_close();
>  }
> -- 
> 2.29.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

