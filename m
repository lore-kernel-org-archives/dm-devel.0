Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40371C2D0A3
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:38:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E4833222EA
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:38:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4833222EA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-N4jcLJZUOE-FoTBF2Wgykw-1; Mon, 26 Oct 2020 03:38:53 -0400
X-MC-Unique: N4jcLJZUOE-FoTBF2Wgykw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D069B10866B0;
	Mon, 26 Oct 2020 07:38:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2686104326B;
	Mon, 26 Oct 2020 07:38:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 879BF1800BB2;
	Mon, 26 Oct 2020 07:38:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09NEnv0H011077 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Oct 2020 10:49:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5EFC085CDF; Fri, 23 Oct 2020 14:49:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 578FE85CCE
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 14:49:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDE83800962
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 14:49:54 +0000 (UTC)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
	[209.85.221.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-217-4EHMngkuO6GUm5o8YpNGtQ-1; Fri, 23 Oct 2020 10:49:52 -0400
X-MC-Unique: 4EHMngkuO6GUm5o8YpNGtQ-1
Received: by mail-wr1-f66.google.com with SMTP id n18so2188053wrs.5
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 07:49:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id
	:mail-followup-to:references:mime-version:content-disposition
	:in-reply-to;
	bh=xePUgVqudoa7FnGpfppkhLWoCoDAn7O+IxyLYMvs6Sc=;
	b=N5z7xRcEV8zzSj0/1sjQLOicoxylemhNgGjCX4zLD7veKhzlibhvsOsIpugi/cLr64
	8sbKifvXlVoRYFFDzbyeht/GDdAWVuig8L51OoGjfGbjiH7w9b5yDaldwkZTvdRJ/Maz
	IAAqyymEtCVjzvoI4VeaU3OToV3n6c3y+j77PKGKrrmuTwmf51XQuP06UZ8VfgN11//J
	hrMj2pPP3H08ciT3Fk1Rt0/O6dtRpqpcyACxrYV5MVFYuU3hHHJ3LnQ02gCBUrdlPe7t
	tl67xR0eOLr2chIBybhdC9UUB48VOPvGRpc1oiFl0TSrm0i8yO55g+GqvOLdt1klRy0J
	aAJg==
X-Gm-Message-State: AOAM530d14PNbKymVFGE9U73y3okbv5C2rKQ1O4RzcqeEvTDcr6TFKkX
	QXjE+/nZhjqT/MeuXtKZHxVCVnFt2pDeOKtJ
X-Google-Smtp-Source: ABdhPJyQZR2dXG0RjIsq+LQh8IIHllK8eRs8oeqmDRQIBDJg1umlU3uJqlUglPGV6YHm5CpOm9JoMg==
X-Received: by 2002:adf:ef06:: with SMTP id e6mr2966269wro.397.1603464591080; 
	Fri, 23 Oct 2020 07:49:51 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
	by smtp.gmail.com with ESMTPSA id
	e25sm4069542wra.71.2020.10.23.07.49.50
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 23 Oct 2020 07:49:50 -0700 (PDT)
Date: Fri, 23 Oct 2020 16:49:48 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-ID: <20201023144948.GE401619@phenom.ffwll.local>
Mail-Followup-To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	NeilBrown <neilb@suse.de>
References: <20200625113122.7540-1-willy@infradead.org>
	<20200625113122.7540-7-willy@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20200625113122.7540-7-willy@infradead.org>
X-Operating-System: Linux phenom 5.7.0-1-amd64
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 26 Oct 2020 03:19:19 -0400
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 6/6] mm: Add memalloc_nowait
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

On Thu, Jun 25, 2020 at 12:31:22PM +0100, Matthew Wilcox (Oracle) wrote:
> Similar to memalloc_noio() and memalloc_nofs(), memalloc_nowait()
> guarantees we will not sleep to reclaim memory.  Use it to simplify
> dm-bufio's allocations.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  drivers/md/dm-bufio.c    | 30 ++++++++----------------------
>  include/linux/sched.h    |  1 +
>  include/linux/sched/mm.h | 12 ++++++++----
>  3 files changed, 17 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 6d1565021d74..140ada9a2c8f 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -412,23 +412,6 @@ static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
>  
>  	*data_mode = DATA_MODE_VMALLOC;
>  
> -	/*
> -	 * __vmalloc allocates the data pages and auxiliary structures with
> -	 * gfp_flags that were specified, but pagetables are always allocated
> -	 * with GFP_KERNEL, no matter what was specified as gfp_mask.
> -	 *
> -	 * Consequently, we must set per-process flag PF_MEMALLOC_NOIO so that
> -	 * all allocations done by this process (including pagetables) are done
> -	 * as if GFP_NOIO was specified.
> -	 */
> -	if (gfp_mask & __GFP_NORETRY) {
> -		unsigned noio_flag = memalloc_noio_save();
> -		void *ptr = __vmalloc(c->block_size, gfp_mask);
> -
> -		memalloc_noio_restore(noio_flag);
> -		return ptr;
> -	}
> -
>  	return __vmalloc(c->block_size, gfp_mask);
>  }
>  
> @@ -866,9 +849,6 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>  	 * dm-bufio is resistant to allocation failures (it just keeps
>  	 * one buffer reserved in cases all the allocations fail).
>  	 * So set flags to not try too hard:
> -	 *	GFP_NOWAIT: don't wait; if we need to sleep we'll release our
> -	 *		    mutex and wait ourselves.
> -	 *	__GFP_NORETRY: don't retry and rather return failure
>  	 *	__GFP_NOMEMALLOC: don't use emergency reserves
>  	 *	__GFP_NOWARN: don't print a warning in case of failure
>  	 *
> @@ -877,7 +857,9 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>  	 */
>  	while (1) {
>  		if (dm_bufio_cache_size_latch != 1) {
> -			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			unsigned nowait_flag = memalloc_nowait_save();
> +			b = alloc_buffer(c, GFP_KERNEL | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			memalloc_nowait_restore(nowait_flag);
>  			if (b)
>  				return b;
>  		}
> @@ -886,8 +868,12 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>  			return NULL;
>  
>  		if (dm_bufio_cache_size_latch != 1 && !tried_noio_alloc) {
> +			unsigned noio_flag;
> +
>  			dm_bufio_unlock(c);
> -			b = alloc_buffer(c, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			noio_flag = memalloc_noio_save();
> +			b = alloc_buffer(c, GFP_KERNEL | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			memalloc_noio_restore(noio_flag);
>  			dm_bufio_lock(c);
>  			if (b)
>  				return b;
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 90336850e940..b1c2cddd366c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -803,6 +803,7 @@ struct task_struct {
>  #endif
>  	unsigned			memalloc_noio:1;
>  	unsigned			memalloc_nofs:1;
> +	unsigned			memalloc_nowait:1;

I think you also need to update gfpflags_allow_blocking() to take your new
flag into account, or some debug checks all over the place might misfire.

Plus I have a patch which rolls this out to a few more places in all the
allocators.
-Daniel

>  	unsigned			memalloc_nocma:1;
>  
>  	unsigned long			atomic_flags; /* Flags requiring atomic access. */
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 6f7b59a848a6..6484569f50df 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -179,12 +179,16 @@ static inline bool in_vfork(struct task_struct *tsk)
>  static inline gfp_t current_gfp_context(gfp_t flags)
>  {
>  	if (unlikely(current->memalloc_noio || current->memalloc_nofs ||
> -		     current->memalloc_nocma)) {
> +		     current->memalloc_nocma) || current->memalloc_nowait) {
>  		/*
> -		 * NOIO implies both NOIO and NOFS and it is a weaker context
> -		 * so always make sure it makes precedence
> +		 * Clearing DIRECT_RECLAIM means we won't get to the point
> +		 * of testing IO or FS, so we don't need to bother clearing
> +		 * them.  noio implies neither IO nor FS and it is a weaker
> +		 * context so always make sure it takes precedence.
>  		 */
> -		if (current->memalloc_noio)
> +		if (current->memalloc_nowait)
> +			flags &= ~__GFP_DIRECT_RECLAIM;
> +		else if (current->memalloc_noio)
>  			flags &= ~(__GFP_IO | __GFP_FS);
>  		else if (current->memalloc_nofs)
>  			flags &= ~__GFP_FS;
> -- 
> 2.27.0
> 
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

