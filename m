Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610F318A6A8
	for <dm-devel@lists.linux.dev>; Tue, 25 Mar 2025 21:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742937471; cv=none; b=IJSxX6dUGTTaGlDDx1p1P6gYjxXOsUq8JAW5u2JWcC7KJFmmF7w5Q/BuaGwt9UQpFVdkFDwxXSc029UFOwxdkkrflp03RLWoJfgUoxmJ6r3AF2TIYsAj24Ieb//AeC7XaxX4lgiQMQstjs+HlbigP0hXA0w6uPtTOTMZe/Wh2hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742937471; c=relaxed/simple;
	bh=UJV58HEHZw2tH1Jc1yGhxksnpGgdE09+ZxdOZvGOzqU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nTkRIemNDN3ENkHp7dZjs8f/ZSAsySDrMWu/+aZTbXrl8j9xNJfp/6OOLkiqCLhd2vEKB7pOy1RklXrdv+aH1mRDwPbKncg8jktnr400rngIKBRUPCkGCdE7ooEGUtAr6ONsJltpDmPitOUG+oEh+/WNlDqeDyyoEZ1iBHScA80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BnZVWq64; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BnZVWq64"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742937468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5AaB7BazDeyn6WXrQ6YewUv1Mg+fuZiGuFUOSBk7qY8=;
	b=BnZVWq64k7kITRA/ks3KNdLC9JgWAU8eAOBkUgTgvwp+40NApEPFrGbwJw8VbYmXupUV1N
	WjvBiPDgt1DmGvB+df8QZOXzGpyzBZXVzNMPsaGJNBvoK/DhvSt4EjdXIXxrdreYM/Yjzf
	nvKzPwwdNM+Op4HElTvCRPyOpXW51U0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-33-_ZsUi0zCNn-XCMwH6a3yBw-1; Tue,
 25 Mar 2025 17:17:46 -0400
X-MC-Unique: _ZsUi0zCNn-XCMwH6a3yBw-1
X-Mimecast-MFC-AGG-ID: _ZsUi0zCNn-XCMwH6a3yBw_1742937465
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 626F6195E92A;
	Tue, 25 Mar 2025 21:17:45 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F537195609D;
	Tue, 25 Mar 2025 21:17:43 +0000 (UTC)
Date: Tue, 25 Mar 2025 22:17:38 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: LongPing Wei <weilongping@oppo.com>
cc: snitzer@kernel.org, Alasdair Kergon <agk@redhat.com>, 
    dm-devel@lists.linux.dev, guoweichao@oppo.com
Subject: Re: [PATCH] dm-verity: support block number limits for different
 ioprio classes
In-Reply-To: <20250325104942.1170388-1-weilongping@oppo.com>
Message-ID: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com>
References: <20250325104942.1170388-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wTBo5ZeKoUQ-XPcUMich85SlIF12IHgm6tgCPLm7UjQ_1742937465
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

I think the patch is OK, I just suggest these changes:

- set the limit for the number of bytes, rather than the number of blocks, 
because different dm-verity devices can have different block size

- run some benchmarks and set the default values according to the 
benchmark results

- increase the target version number

- add a note about this feature to 
Documentation/admin-guide/device-mapper/verity.rst

Mikulas


On Tue, 25 Mar 2025, LongPing Wei wrote:

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
> default config by /sys/module/dm_verity/parameters/use_bh_blocks.
> 
> The default limits for NONE/RT/BE/IDLE is set to UINT_MAX to keep the
> original behaviour.
> 
> Signed-off-by: LongPing Wei <weilongping@oppo.com>
> ---
>  drivers/md/dm-verity-target.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index e86c1431b108..1e0d0920d6a9 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -30,6 +30,7 @@
>  #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
>  
>  #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
> +#define DM_VERITY_USE_BH_DEFAULT_BLOCKS	UINT_MAX
>  
>  #define DM_VERITY_MAX_CORRUPTED_ERRS	100
>  
> @@ -49,6 +50,15 @@ static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE
>  
>  module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
>  
> +static unsigned int dm_verity_use_bh_blocks[4] = {
> +	DM_VERITY_USE_BH_DEFAULT_BLOCKS,	// IOPRIO_CLASS_NONE
> +	DM_VERITY_USE_BH_DEFAULT_BLOCKS,	// IOPRIO_CLASS_RT
> +	DM_VERITY_USE_BH_DEFAULT_BLOCKS,	// IOPRIO_CLASS_BE
> +	DM_VERITY_USE_BH_DEFAULT_BLOCKS		// IOPRIO_CLASS_IDLE
> +};
> +
> +module_param_array_named(use_bh_blocks, dm_verity_use_bh_blocks, uint, NULL, 0644);
> +
>  static DEFINE_STATIC_KEY_FALSE(use_bh_wq_enabled);
>  
>  /* Is at least one dm-verity instance using ahash_tfm instead of shash_tfm? */
> @@ -652,6 +662,12 @@ static void verity_bh_work(struct work_struct *w)
>  	verity_finish_io(io, errno_to_blk_status(err));
>  }
>  
> +static inline bool verity_use_bh(unsigned int n_blocks, unsigned short ioprio)
> +{
> +	return ioprio <= IOPRIO_CLASS_IDLE &&
> +		n_blocks <= READ_ONCE(dm_verity_use_bh_blocks[ioprio]);
> +}
> +
>  static void verity_end_io(struct bio *bio)
>  {
>  	struct dm_verity_io *io = bio->bi_private;
> @@ -664,7 +680,8 @@ static void verity_end_io(struct bio *bio)
>  		return;
>  	}
>  
> -	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq) {
> +	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq &&
> +		verity_use_bh(io->n_blocks, IOPRIO_PRIO_CLASS(bio->bi_ioprio))) {
>  		INIT_WORK(&io->bh_work, verity_bh_work);
>  		queue_work(system_bh_wq, &io->bh_work);
>  	} else {
> -- 
> 2.34.1
> 

