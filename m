Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5A064D
	for <dm-devel@lists.linux.dev>; Thu, 27 Mar 2025 16:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743092225; cv=none; b=gRST5jI8ch1+CNk/rmCfUGDc0OU0MdRy7ohGkg2lcu+On/fUZsX7F4osgr/oZQqGroACrkmJi38gzHTSL3n2w+dkAV/M1QZqK7j3kyzb29gLUDrCUOd2gbinqRtAMca11s4E7sMwvT9sLt3O7K+J7GsTZ/yjjRoMxNNVGhfLquQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743092225; c=relaxed/simple;
	bh=xbE02ZfyuhcBZ08oapFTcigVEbW96Mvn+HHSyh7+Eko=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=LoMO/TssGkYNoNtqQ1VDQ4lSs8p3E6SQTheW8E7s/X9eogWpyqMSNL7x7eQe/92tUtwu3FA0fNxfigSM3+cCGS7ie24W44RI43yrE+sixYDg1MzM0C3Ok2/Ha2rplfcOe53Bq6l/0KfCSZCzGAigkJrwAW9i8h9eGfjLGXs86gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aPOrMiDH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aPOrMiDH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743092221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lqrDT8GrndqV9A6zDZ5tYGuLiDIlsMO4nl5jj2BeyTQ=;
	b=aPOrMiDHozW/mWmAlntJY2kd7ULTan24p202k3oVTlmgbdEZ/K5S5Vm5omCpshSwlV/F5D
	2fDhaFyaT0IEfLZk/YOyoRFneUGWnZhk1xz35rQZS0w8W81OARNaHoGxG4Yi1op+9Fqfia
	ET5UgPWc3jwZKq7elVyRv5iqgN5xQdw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-307-z9Qn4dvxN2yW9GcVR0GQHA-1; Thu,
 27 Mar 2025 12:16:58 -0400
X-MC-Unique: z9Qn4dvxN2yW9GcVR0GQHA-1
X-Mimecast-MFC-AGG-ID: z9Qn4dvxN2yW9GcVR0GQHA_1743092217
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20FFB180AF57;
	Thu, 27 Mar 2025 16:16:56 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15B28180A803;
	Thu, 27 Mar 2025 16:16:53 +0000 (UTC)
Date: Thu, 27 Mar 2025 17:16:47 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: LongPing Wei <weilongping@oppo.com>
cc: snitzer@kernel.org, dm-devel@lists.linux.dev, guoweichao@oppo.com, 
    ebiggers@kernel.org, bvanassche@acm.org
Subject: Re: [PATCH v3] dm-verity: support block number limits for different
 ioprio classes
In-Reply-To: <20250327021819.1623099-1-weilongping@oppo.com>
Message-ID: <6dddcbfb-e424-ef41-53bf-e376428a3d5e@redhat.com>
References: <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com> <20250327021819.1623099-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QXk7VuFTkorzc5_3vaDxDoq_6g0YxLlZERDzYXs0QAg_1743092217
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

I applied the patch, thanks.

Mikulas


On Thu, 27 Mar 2025, LongPing Wei wrote:

> Calling verity_verify_io in bh for IO of all sizes is not suitable for
> embedded devices. From our tests, it can improve the performance of 4K
> synchronise random reads.
> For example:
> ./fio --name=rand_read --ioengine=psync --rw=randread --bs=4K \
>  --direct=1 --numjobs=8 --runtime=60 --time_based --group_reporting \
>  --filename=/dev/block/mapper/xx-verity
> 
> But it will degrade the performance of 512K synchronise sequential reads
> on our devices.
> For example:
> ./fio --name=read --ioengine=psync --rw=read --bs=512K --direct=1 \
>  --numjobs=8 --runtime=60 --time_based --group_reporting \
>  --filename=/dev/block/mapper/xx-verity
> 
> A parameter array is introduced by this change. And users can modify the
> default config by /sys/module/dm_verity/parameters/use_bh_bytes.
> 
> The default limits for NONE/RT/BE is set to 8192.
> The default limits for IDLE is set to 0.
> 
> Call verity_verify_io directly when verity_end_io is not in hardirq.
> 
> Signed-off-by: LongPing Wei <weilongping@oppo.com>
> ---
> v3:
> 1. set the default limit to 8192 bytes for none,rt,be;
> 2. set the default limit to 0 bytes for idle;
> 3. fix the mistake in v2 that verity_verify_io won't be called when
> verity_use_bh return false;
> v2:
> 1. change from use_bh_blocks to use_bh_bytes;
> 2. update documention;
> 3. set the default limit to 4096bytes;
> 4. call verity_verify_io directly when verity_end_io is in softirq;
> 5. bump version of dm-verity;
> ---
>  .../admin-guide/device-mapper/verity.rst      |  8 ++++-
>  drivers/md/dm-verity-target.c                 | 30 ++++++++++++++++---
>  2 files changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
> index a65c1602cb23..f7fb5ea3c0df 100644
> --- a/Documentation/admin-guide/device-mapper/verity.rst
> +++ b/Documentation/admin-guide/device-mapper/verity.rst
> @@ -143,7 +143,13 @@ root_hash_sig_key_desc <key_description>
>  
>  try_verify_in_tasklet
>      If verity hashes are in cache, verify data blocks in kernel tasklet instead
> -    of workqueue. This option can reduce IO latency.
> +    of workqueue. This option can reduce IO latency. The size limits could be
> +    configured via /sys/module/dm_verity/parameters/use_bh_bytes. The four
> +    parameters correspond to limits for IOPRIO_CLASS_NONE,IOPRIO_CLASS_RT,
> +    IOPRIO_CLASS_BE and IOPRIO_CLASS_IDLE in turn.
> +    For example:
> +    <none>,<rt>,<be>,<idle>
> +    4096,4096,4096,4096
>  
>  Theory of operation
>  ===================
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index e86c1431b108..4d6148ed02e8 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -30,6 +30,7 @@
>  #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
>  
>  #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
> +#define DM_VERITY_USE_BH_DEFAULT_BYTES	8192
>  
>  #define DM_VERITY_MAX_CORRUPTED_ERRS	100
>  
> @@ -49,6 +50,15 @@ static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE
>  
>  module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
>  
> +static unsigned int dm_verity_use_bh_bytes[4] = {
> +	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_NONE
> +	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_RT
> +	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_BE
> +	0				// IOPRIO_CLASS_IDLE
> +};
> +
> +module_param_array_named(use_bh_bytes, dm_verity_use_bh_bytes, uint, NULL, 0644);
> +
>  static DEFINE_STATIC_KEY_FALSE(use_bh_wq_enabled);
>  
>  /* Is at least one dm-verity instance using ahash_tfm instead of shash_tfm? */
> @@ -652,9 +662,16 @@ static void verity_bh_work(struct work_struct *w)
>  	verity_finish_io(io, errno_to_blk_status(err));
>  }
>  
> +static inline bool verity_use_bh(unsigned int bytes, unsigned short ioprio)
> +{
> +	return ioprio <= IOPRIO_CLASS_IDLE &&
> +		bytes <= READ_ONCE(dm_verity_use_bh_bytes[ioprio]);
> +}
> +
>  static void verity_end_io(struct bio *bio)
>  {
>  	struct dm_verity_io *io = bio->bi_private;
> +	unsigned short ioprio = IOPRIO_PRIO_CLASS(bio->bi_ioprio);
>  
>  	if (bio->bi_status &&
>  	    (!verity_fec_is_enabled(io->v) ||
> @@ -664,9 +681,14 @@ static void verity_end_io(struct bio *bio)
>  		return;
>  	}
>  
> -	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq) {
> -		INIT_WORK(&io->bh_work, verity_bh_work);
> -		queue_work(system_bh_wq, &io->bh_work);
> +	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq &&
> +		verity_use_bh(bio->bi_iter.bi_size, ioprio)) {
> +		if (in_hardirq() || irqs_disabled()) {
> +			INIT_WORK(&io->bh_work, verity_bh_work);
> +			queue_work(system_bh_wq, &io->bh_work);
> +		} else {
> +			verity_bh_work(&io->bh_work);
> +		}
>  	} else {
>  		INIT_WORK(&io->work, verity_work);
>  		queue_work(io->v->verify_wq, &io->work);
> @@ -1761,7 +1783,7 @@ static struct target_type verity_target = {
>  	.name		= "verity",
>  /* Note: the LSMs depend on the singleton and immutable features */
>  	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
> -	.version	= {1, 10, 0},
> +	.version	= {1, 11, 0},
>  	.module		= THIS_MODULE,
>  	.ctr		= verity_ctr,
>  	.dtr		= verity_dtr,
> -- 
> 2.34.1
> 

