Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7E53BF680
	for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 06:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782368722; cv=none; b=GqRwIsEK3URRww/qM8HMNsxAMGq/RPuCNqsDfOgi9ZHxgw2tuC4LWDoqLLnh+HsUtQhaQ8RdXF2Xxb3oyOEItuCIBx+MC3l/vHjWEwxm/30tKRI8SeattdaSGxIPM426/oiA60f1afeLA/DywpgAz4imSoOxa6vAET/U+iaze3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782368722; c=relaxed/simple;
	bh=qXA6ULZkv8oJgJwj+qS5+6Nhr2SF+6R7xL8CFM+ZMxA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RR8ZZzqbe5bnvyLBESkwZlwvduo6ZCnQhJOZoagDJxtiEuV9yKiaNKf5gwaKn1Mk60ZoSOU8jeaofvxCXkyD7OF+wXhrcIVdrv1M/d+U3y9z5AFgm7ZmMhB4s9oSdVqA8UKJxq52eNWBwGAtJ4FPiwf8cmQu4odgKO0CMShPmfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=K4y6ekxy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=e+15EXVx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=K4y6ekxy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=e+15EXVx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="K4y6ekxy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="e+15EXVx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="K4y6ekxy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="e+15EXVx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 96DBC75902;
	Thu, 25 Jun 2026 06:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=40bmXoSAYyOr8paufFtJbfAWd8QNorNcC7qv1y8PyGk=;
	b=K4y6ekxyPv2A93S2oRmz/reDM7qYmN7ohb8vCnvnO0s1p/gQ/NLHMYastnd90My1KNT7TB
	qQ/kBT5xn0Mb2fPyBM0654iyTfGYfDTjAdHeqjcN7ntF9SmywUDnf5IYHfOuRPPhYKyYcx
	8Tzu3wQJW+qolacB/4MzGG6tMLi1bRs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368719;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=40bmXoSAYyOr8paufFtJbfAWd8QNorNcC7qv1y8PyGk=;
	b=e+15EXVxjS5F/FLp6pPlkHiq/NQfJUlZTqNyI+SScdkCWsbESArjsdiPrsc7gG4QAbQvUp
	lHlkUmi6it5hSTBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=40bmXoSAYyOr8paufFtJbfAWd8QNorNcC7qv1y8PyGk=;
	b=K4y6ekxyPv2A93S2oRmz/reDM7qYmN7ohb8vCnvnO0s1p/gQ/NLHMYastnd90My1KNT7TB
	qQ/kBT5xn0Mb2fPyBM0654iyTfGYfDTjAdHeqjcN7ntF9SmywUDnf5IYHfOuRPPhYKyYcx
	8Tzu3wQJW+qolacB/4MzGG6tMLi1bRs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368719;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=40bmXoSAYyOr8paufFtJbfAWd8QNorNcC7qv1y8PyGk=;
	b=e+15EXVxjS5F/FLp6pPlkHiq/NQfJUlZTqNyI+SScdkCWsbESArjsdiPrsc7gG4QAbQvUp
	lHlkUmi6it5hSTBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42B95779A8;
	Thu, 25 Jun 2026 06:25:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mbJjDs/JPGq2RAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 25 Jun 2026 06:25:19 +0000
Message-ID: <f3aebd6e-9351-4235-834e-e057b2cfa0be@suse.de>
Date: Thu, 25 Jun 2026 08:25:18 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] loop: set dma_alignment from the backing file for
 direct I/O
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Cc: dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
 brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
 Keith Busch <kbusch@kernel.org>
References: <20260624170905.3972095-1-kbusch@meta.com>
 <20260624170905.3972095-4-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260624170905.3972095-4-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On 6/24/26 7:09 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Direct I/O user pages are forwarded to the backing file unchanged, so
> the backing's DMA alignment requirement applies to them. Track the
> backing file's dio_mem_align and advertise it as the loop device's
> dma_alignment if it is larger than the default so we advertise proper
> limits and misaligned I/O is rejected early instead of being dispatched
> to the backend.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/block/loop.c | 46 ++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 38 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 310de0463beb1..5fe61d542f8b7 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -54,6 +54,7 @@ struct loop_device {
>   
>   	struct file	*lo_backing_file;
>   	unsigned int	lo_min_dio_size;
> +	unsigned int	lo_dio_mem_align;
>   	struct block_device *lo_device;
>   
>   	gfp_t		old_gfp_mask;
> @@ -447,26 +448,37 @@ static void loop_reread_partitions(struct loop_device *lo)
>   			__func__, lo->lo_number, lo->lo_file_name, rc);
>   }
>   
> -static unsigned int loop_query_min_dio_size(struct loop_device *lo)
> +static void loop_update_dio_alignment(struct loop_device *lo)
>   {
>   	struct file *file = lo->lo_backing_file;
>   	struct block_device *sb_bdev = file->f_mapping->host->i_sb->s_bdev;
>   	struct kstat st;
>   
>   	/*
> -	 * Use the minimal dio alignment of the file system if provided.
> +	 * Use the dio alignment of the file system if provided.  The incomoing
> +	 * request's bio_vec is forwarded to the backing file unchanged, so its
> +	 * required memory alignment becomes the device's dma_alignment when
> +	 * used for direct-io.
>   	 */
>   	if (!vfs_getattr(&file->f_path, &st, STATX_DIOALIGN, 0) &&
> -	    (st.result_mask & STATX_DIOALIGN))
> -		return st.dio_offset_align;
> +	    (st.result_mask & STATX_DIOALIGN)) {
> +		lo->lo_min_dio_size = st.dio_offset_align;
> +		lo->lo_dio_mem_align = st.dio_mem_align - 1;
> +		return;
> +	}
>   
>   	/*
>   	 * In a perfect world this wouldn't be needed, but as of Linux 6.13 only
>   	 * a handful of file systems support the STATX_DIOALIGN flag.
>   	 */
> -	if (sb_bdev)
> -		return bdev_logical_block_size(sb_bdev);
> -	return SECTOR_SIZE;
> +	if (sb_bdev) {
> +		lo->lo_min_dio_size = bdev_logical_block_size(sb_bdev);
> +		lo->lo_dio_mem_align = bdev_dma_alignment(sb_bdev);
> +		return;
> +	}
> +
> +	lo->lo_min_dio_size = SECTOR_SIZE;
> +	lo->lo_dio_mem_align = SECTOR_SIZE - 1;
>   }
>   
>   static inline int is_loop_device(struct file *file)
> @@ -509,7 +521,7 @@ static void loop_assign_backing_file(struct loop_device *lo, struct file *file)
>   			lo->old_gfp_mask & ~(__GFP_IO | __GFP_FS));
>   	if (lo->lo_backing_file->f_flags & O_DIRECT)
>   		lo->lo_flags |= LO_FLAGS_DIRECT_IO;
> -	lo->lo_min_dio_size = loop_query_min_dio_size(lo);
> +	loop_update_dio_alignment(lo);
>   }
>   
>   static int loop_check_backing_file(struct file *file)
> @@ -940,6 +952,19 @@ static unsigned int loop_default_blocksize(struct loop_device *lo)
>   	return SECTOR_SIZE;
>   }
>   
> +static void loop_set_dma_limit(struct loop_device *lo, struct queue_limits *lim)
> +{
> +	/*
> +	 * Direct I/O forwards the user pages to the backing file unchanged, so
> +	 * track the backing's DMA alignment requirement as the mode is toggled.
> +	 */
> +	if (lo->lo_flags & LO_FLAGS_DIRECT_IO)
> +		lim->dma_alignment = max_t(unsigned int, lo->lo_dio_mem_align,
> +					   SECTOR_SIZE - 1);
> +	else
> +		lim->dma_alignment = SECTOR_SIZE - 1;

Nit: we never set this previously, so we could drop this line.

> +}
> +
>   static void loop_update_limits(struct loop_device *lo, struct queue_limits *lim,
>   		unsigned int bsize)
>   {
> @@ -961,6 +986,7 @@ static void loop_update_limits(struct loop_device *lo, struct queue_limits *lim,
>   	lim->logical_block_size = bsize;
>   	lim->physical_block_size = bsize;
>   	lim->io_min = bsize;
> +	loop_set_dma_limit(lo, lim);
>   	lim->features &= ~(BLK_FEAT_WRITE_CACHE | BLK_FEAT_ROTATIONAL);
>   	if (file->f_op->fsync && !(lo->lo_flags & LO_FLAGS_READ_ONLY))
>   		lim->features |= BLK_FEAT_WRITE_CACHE;
> @@ -1416,6 +1442,7 @@ static int loop_set_dio(struct loop_device *lo, unsigned long arg)
>   {
>   	bool use_dio = !!arg;
>   	unsigned int memflags;
> +	struct queue_limits lim;
>   
>   	if (lo->lo_state != Lo_bound)
>   		return -ENXIO;
> @@ -1434,6 +1461,9 @@ static int loop_set_dio(struct loop_device *lo, unsigned long arg)
>   		lo->lo_flags |= LO_FLAGS_DIRECT_IO;
>   	else
>   		lo->lo_flags &= ~LO_FLAGS_DIRECT_IO;
> +	lim = queue_limits_start_update(lo->lo_queue);
> +	loop_set_dma_limit(lo, &lim);
> +	queue_limits_commit_update(lo->lo_queue, &lim);
>   	blk_mq_unfreeze_queue(lo->lo_queue, memflags);
>   	return 0;
>   }

Otherwise looks good.

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
