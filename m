Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03C7AC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 20:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637786502;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rV4jrJi7myNvCcRmjs53LcWSO2xShBQbV+39Xif6fNg=;
	b=dpFR+AZMn+sH+Ka2NuWBMbe3mjWKI2SUWTpcgXWZbDtQGf8oWiJtqhvxpTQxGjp2192RfA
	YE2zYuf99qrB14wLhcvafiG4a+DRpDOyYtUtKbUEbglcEUWsugs6iUPmfLrMQzJAu+3ICb
	nR7CxD17sSPTHEGpjDwCwJ11s2sMAkE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-utp6UtyxOtOLxdbEvckMtA-1; Wed, 24 Nov 2021 15:41:39 -0500
X-MC-Unique: utp6UtyxOtOLxdbEvckMtA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABB1B192FDA1;
	Wed, 24 Nov 2021 20:41:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AAC6794A1;
	Wed, 24 Nov 2021 20:41:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0EB434BB7C;
	Wed, 24 Nov 2021 20:41:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AOKfSbO020192 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 15:41:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CF07F418E; Wed, 24 Nov 2021 20:41:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82ECD67840;
	Wed, 24 Nov 2021 20:41:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AOKfJc8022387; 
	Wed, 24 Nov 2021 14:41:19 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AOKfI0v022386;
	Wed, 24 Nov 2021 14:41:18 -0600
Date: Wed, 24 Nov 2021 14:41:18 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211124204118.GP19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-4-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211118225840.19810-4-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 03/48] libmultipath: add optional wakeup
 functionality to lock.c
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

On Thu, Nov 18, 2021 at 11:57:55PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Have struct mutex_lock take an optional wakeup function.
> unlock() is renamed to __unlock() in order to prevent it from
> being called by mistake.
> 
> This changes offsets in "struct vectors", requiring a major
> libmultipath version bump. While the strucure is already changed,
> in order to avoid this in the future, move the lock to the end
> of "struct vectors".
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

In libmultipath.version, I would have said that set_wakeup_fn was added
in 10.0.0, instead of 9.2.0, which is a version that never actually
existed, but I don't think that's going to cause any problems so,

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/libmultipath.version | 13 +++++++------
>  libmultipath/lock.c               | 12 +++++++++++-
>  libmultipath/lock.h               |  6 +++++-
>  libmultipath/structs_vec.h        |  2 +-
>  4 files changed, 24 insertions(+), 9 deletions(-)
> 
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index c98cf7f..98ec502 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -31,7 +31,7 @@
>   *   The new version inherits the previous ones.
>   */
>  
> -LIBMULTIPATH_9.0.0 {
> +LIBMULTIPATH_10.0.0 {
>  global:
>  	/* symbols referenced by multipath and multipathd */
>  	add_foreign;
> @@ -284,11 +284,12 @@ global:
>  	/* added in 8.2.0 */
>  	check_daemon;
>  
> +	/* added in 9.1.0 */
> +	timespeccmp;
> +
> +	/* added in 9.2.0 */
> +	set_wakeup_fn;
> +
>  local:
>  	*;
>  };
> -
> -LIBMULTIPATH_9.1.0 {
> -global:
> -	timespeccmp;
> -} LIBMULTIPATH_9.0.0;
> diff --git a/libmultipath/lock.c b/libmultipath/lock.c
> index 72c70e3..93b48db 100644
> --- a/libmultipath/lock.c
> +++ b/libmultipath/lock.c
> @@ -3,6 +3,16 @@
>  void cleanup_lock (void * data)
>  {
>  	struct mutex_lock *lock = data;
> +	wakeup_fn *fn = lock->wakeup;
>  
> -	unlock(lock);
> +	__unlock(lock);
> +	if (fn)
> +		fn();
> +}
> +
> +void set_wakeup_fn(struct mutex_lock *lck, wakeup_fn *fn)
> +{
> +	lock(lck);
> +	lck->wakeup = fn;
> +	__unlock(lck);
>  }
> diff --git a/libmultipath/lock.h b/libmultipath/lock.h
> index d99eedb..d7b779e 100644
> --- a/libmultipath/lock.h
> +++ b/libmultipath/lock.h
> @@ -3,8 +3,11 @@
>  
>  #include <pthread.h>
>  
> +typedef void (wakeup_fn)(void);
> +
>  struct mutex_lock {
>  	pthread_mutex_t mutex;
> +	wakeup_fn *wakeup;
>  };
>  
>  static inline void lock(struct mutex_lock *a)
> @@ -22,7 +25,7 @@ static inline int timedlock(struct mutex_lock *a, struct timespec *tmo)
>  	return pthread_mutex_timedlock(&a->mutex, tmo);
>  }
>  
> -static inline void unlock(struct mutex_lock *a)
> +static inline void __unlock(struct mutex_lock *a)
>  {
>  	pthread_mutex_unlock(&a->mutex);
>  }
> @@ -30,5 +33,6 @@ static inline void unlock(struct mutex_lock *a)
>  #define lock_cleanup_pop(a) pthread_cleanup_pop(1)
>  
>  void cleanup_lock (void * data);
> +void set_wakeup_fn(struct mutex_lock *lock, wakeup_fn *fn);
>  
>  #endif /* _LOCK_H */
> diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
> index 29ede45..2a0cbd1 100644
> --- a/libmultipath/structs_vec.h
> +++ b/libmultipath/structs_vec.h
> @@ -6,9 +6,9 @@
>  #include "lock.h"
>  
>  struct vectors {
> -	struct mutex_lock lock; /* defined in lock.h */
>  	vector pathvec;
>  	vector mpvec;
> +	struct mutex_lock lock; /* defined in lock.h */
>  };
>  
>  void __set_no_path_retry(struct multipath *mpp, bool check_features);
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

