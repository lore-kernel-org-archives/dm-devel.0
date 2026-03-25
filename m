Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F6034C815
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 14:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774448969; cv=none; b=XGWRb8Kl6aZP+RwXw9baruQ2szIlfm7n8tnBTeoNvcg4oybbtiu1dCyXKUW7fx+m7hMivPQ/tbiyySkQ1OvDZZKdtJwEXQlqwwu47J2YkpOzWifUgd43IvAfXde7uJyNh30LDITwfCWotDrN5ZeewRpWBCbw7mRuOQ0lO05qzes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774448969; c=relaxed/simple;
	bh=qPhcUpqv/A+9csdJ2+QSsGJOFfwqcEPSzKAT2qb51L8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cYNtPsB+Ga91PbIJu7zm+YiWXlYta58T8ncDQrInhtJi1/gU+pDTfzeiwMPAoXzoFLLsMKG/5Ox12urmp409RFloR9aabK85WYEke+nZDMh1MdxpIToHWwrdMjwsCt4gq0wh1OBfbuD5tr02WwqIWQamqBZFLGN3TwttWjOFtTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O023iqfB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O023iqfB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774448967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IYshiDxwseoDjY1GHG4LiIuZ2ZMhUx87+XKwGrKPB40=;
	b=O023iqfBqFWvFBhY4xeeEaBBOko1EgkVz2GBp+d+hfpfl1UKDwkopiP/Zy5/UEZFT16LTO
	bzbJ8vveJl4P8K12oYYHYh7lfZK7UpFkz8DfzfPNkWgH1Lo4doZ6/p18LeMbw5HZ0KQ3Ld
	cRzpf30hsBZUCxfE/wmNqM1paFdbqos=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-196-cANDC1OmO3-BaMZUb7pKcA-1; Wed,
 25 Mar 2026 10:29:22 -0400
X-MC-Unique: cANDC1OmO3-BaMZUb7pKcA-1
X-Mimecast-MFC-AGG-ID: cANDC1OmO3-BaMZUb7pKcA_1774448961
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F5A01954AD0;
	Wed, 25 Mar 2026 14:29:14 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 782F61800576;
	Wed, 25 Mar 2026 14:29:00 +0000 (UTC)
Date: Wed, 25 Mar 2026 15:28:53 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Libo Chen <libchen@purestorage.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Yuanyuan Zhong <yzhong@purestorage.com>, 
    libochen@chenlibo.work
Subject: Re: [PATCH] dm: fix race between dm_mq_queue_rq and __dm_destroy
In-Reply-To: <20260325102741.293982-1-libchen@purestorage.com>
Message-ID: <410671df-5a9e-ee5b-42f4-4dcc75f63abe@redhat.com>
References: <20260325102741.293982-1-libchen@purestorage.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Jzbu0EYRGIOQkWW5wiVs9pqo3VjZ5Ia_y_jsFsvBTUw_1774448961
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

Please explain why are there in-progress requests when the device is being 
destroyed. What kind of workload does trigger this crash?

The device can only be destroyed if it's open count is zero. And if no one 
has the device open, there should be no requests in flight.

If some kernel code is sending requests to a closed block device, it 
should be fixed to not do that.

Mikulas



On Wed, 25 Mar 2026, Libo Chen wrote:

> The existing dm_get() calls BUG_ON if DMF_FREEING is already set. This
> can be triggered when a request is dispatched via blk_mq_requeue_work()
> racing with __dm_destroy():
> 
>   CPU0                           CPU1
>   ----                           ----
>   __dm_destroy()
>     set_bit(DMF_FREEING)
>                                  blk_mq_requeue_work()
>                                    dm_mq_queue_rq()
>                                      dm_start_request()
>                                        dm_get(md)
>                                          BUG_ON(DMF_FREEING) <-- crash
> 
> Introduce dm_try_get() which increments holders first, then checks
> DMF_FREEING. If set, it decrements holders and returns false. The
> smp_mb__after_atomic() ensures the increment is visible before reading
> the flag, providing correct synchronization with __dm_destroy().
> 
> dm_hold() was not used because it acquires the global _minor_lock,
> which would cause contention in the hot I/O path.
> 
> Move dm_try_get() before blk_mq_start_request() in dm_start_request().
> This ensures we don't start the block layer timer or mark the request
> MQ_RQ_IN_FLIGHT for a request that will immediately fail due to device
> destruction. If dm_try_get() fails, we return early without calling
> blk_mq_start_request(), providing cleaner error semantics.
> 
> Signed-off-by: Libo Chen <libchen@purestorage.com>
> ---
>  drivers/md/dm-rq.c            | 26 ++++++++++++++++----------
>  drivers/md/dm.c               | 12 ++++++++++++
>  include/linux/device-mapper.h |  1 +
>  3 files changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index a6ca92049c10..dc6ba46cad92 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -430,8 +430,20 @@ ssize_t dm_attr_rq_based_seq_io_merge_deadline_store(struct mapped_device *md,
>  	return count;
>  }
>  
> -static void dm_start_request(struct mapped_device *md, struct request *orig)
> +static bool dm_start_request(struct mapped_device *md, struct request *orig)
>  {
> +	/*
> +	 * Hold the md reference here for the in-flight I/O.
> +	 * We can't rely on the reference count by device opener,
> +	 * because the device may be closed during the request completion
> +	 * when all bios are completed.
> +	 * See the comment in rq_completed() too.
> +	 *
> +	 * Fail if DMF_FREEING is set to avoid racing with __dm_destroy().
> +	 */
> +	if (!dm_try_get(md))
> +		return false;
> +
>  	blk_mq_start_request(orig);
>  
>  	if (unlikely(dm_stats_used(&md->stats))) {
> @@ -444,14 +456,7 @@ static void dm_start_request(struct mapped_device *md, struct request *orig)
>  				    &tio->stats_aux);
>  	}
>  
> -	/*
> -	 * Hold the md reference here for the in-flight I/O.
> -	 * We can't rely on the reference count by device opener,
> -	 * because the device may be closed during the request completion
> -	 * when all bios are completed.
> -	 * See the comment in rq_completed() too.
> -	 */
> -	dm_get(md);
> +	return true;
>  }
>  
>  static int dm_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
> @@ -508,7 +513,8 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	if (ti->type->busy && ti->type->busy(ti))
>  		return BLK_STS_RESOURCE;
>  
> -	dm_start_request(md, rq);
> +	if (!dm_start_request(md, rq))
> +		return BLK_STS_IOERR;
>  
>  	/* Init tio using md established in .init_request */
>  	init_tio(tio, rq, md);
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 6c83ab940af7..bd75b34de333 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2673,6 +2673,18 @@ void dm_get(struct mapped_device *md)
>  	BUG_ON(test_bit(DMF_FREEING, &md->flags));
>  }
>  
> +bool dm_try_get(struct mapped_device *md)
> +{
> +	atomic_inc(&md->holders);
> +	smp_mb__after_atomic();
> +
> +	if (unlikely(test_bit(DMF_FREEING, &md->flags))) {
> +		atomic_dec(&md->holders);
> +		return false;
> +	}
> +	return true;
> +}
> +
>  int dm_hold(struct mapped_device *md)
>  {
>  	spin_lock(&_minor_lock);
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 84fdc3a6a19a..8df81c180f2f 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -500,6 +500,7 @@ int dm_create(int minor, struct mapped_device **md);
>   */
>  struct mapped_device *dm_get_md(dev_t dev);
>  void dm_get(struct mapped_device *md);
> +bool dm_try_get(struct mapped_device *md);
>  int dm_hold(struct mapped_device *md);
>  void dm_put(struct mapped_device *md);
>  
> -- 
> 2.34.1
> 

