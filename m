Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05946175A99
	for <dm-devel@lists.linux.dev>; Fri, 24 Jul 2026 01:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784856539; cv=none; b=lct8eBpeE4ELFhIklxZ5eCIH/eCMZUq5+WOvNXSTThrp630XGU8dz5gZfyxaQKxC0mGn4O9bkIYmWNy5Y8rNdrhvQW3xIA8Ar80TITDzolNViji5D/IV4TIKesD4nTooQBMUaUY+7RUwDHDlrteby4oHX4WYS4uUAMWicqtLsVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784856539; c=relaxed/simple;
	bh=qi3e3cjbAcDME5Ej8PXjqzrbwtis2VVg5ZeBd0Je62M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lJB/wxpMXLJcUZLxJFGj11E1ac0DuZGuFJVFnKHn8v10FOv0XqgFKd1bZWBl+zT7HWW8Ek6Lyqeo254UJSl5djvQ9DmzJMOPWcBa2SqfmjXNbtsNqOBJm9RWTaPsJfOLNc/wverNcRWzZjE7Xq5WWND5lDxPcS1v65U9DX6XD0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F4aumVje; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F4aumVje"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lFDdw+zqdpgzMvdZH/Tt4F5NsysNdCnq5Q7hIMdeUdo=;
	b=F4aumVjezFD09w2sCrP3j0sArMnb8RDB60rADrad1+Jq5rCN/aAlHH0KzHXu84TETrtnJj
	m7v3JWjyUsDkxeWkHJZTjC7yZi5PvnltVr0v20pW+0Y0k52ShpAFQxC7dyJY4/YR2g2cRJ
	YbuaZ4lHVaCOdVjNetHLjRdLTl8kUMM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-tKD_bVJENCyUQle5SrrzRg-1; Thu, 23 Jul 2026 21:28:54 -0400
X-MC-Unique: tKD_bVJENCyUQle5SrrzRg-1
X-Mimecast-MFC-AGG-ID: tKD_bVJENCyUQle5SrrzRg_1784856534
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5276aa86d00so23220431cf.2
        for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 18:28:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784856533; x=1785461333;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lFDdw+zqdpgzMvdZH/Tt4F5NsysNdCnq5Q7hIMdeUdo=;
        b=Ckzzf3OQpCb1Ko4cxRLnAI6fgozG7A1R/8bJpcDztRKSDN9LQPPgi1gV91BSYSgCiu
         C/IyW0fR/NkoTV+ZoXrtKgtkGgwUctBOFPXPEv9LAVdxxhzky/AlXFeIhIMpFzLuFX9n
         UHdSF7JzkUJbQFRFHHx2ahWe+M7JYFYErP3lbzFrcR6Z8CHk7g43M95eVce/kwCWMmAC
         BpVY3lVS5nvhArzcMEeKN7LJrx/OrPjEe3iC6SKCKbmqNRgPqvMHhIbZcBtK2Ld1nMS3
         SwauFTyShYDyeD+figiY6NEnD9Sd/qVo3SMzWgQdRa0TTNRA98UpAM62MclbtrK8DOFw
         Wp3w==
X-Forwarded-Encrypted: i=1; AHgh+RrzCvptvLEcMHxkSBrrJmG4nNX6BDGXFDHo/t0AvJSa8R9AXZat9vbN9ImACFz8gRi1C9Yp9crhIA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwpFgdgvdO3ys16UwVu+bGDvfAcsQoeY/UCGqkH+oKFcAT9nC7G
	3JpFoMFwdlllQgo9RLhd9exGGjmSfY2ZLJH4bh2jS3KTqPuyZ6qtMiqHQ78A1tbUJT08MFNG2/a
	AMhTxGtLAKyXXOJGDpax7j5ZD1KIaFY7iIkSBF81Szjj0YXTYBm6DM3x4k6zyXwlWkO1c
X-Gm-Gg: AR+sD10a8IzPdAr+XJ1zZRMR9TLKdUYQqZqzaIE8xLJuyGX1JoXatbRZl/LFJ56Nh4N
	m2rwZH/lBVfFMUkIN8Hnv8IH0ykNx2ehmRAmDTeyCFRIEsZ+L73yjS00eR5I2q1ozStV1EQUwvV
	GiQFXS6Oa+gjNp6F5fRrTEVLYBb+rkhoRBiKIP5LjV68CQfsq5NKTpNC6kbILuwsLVKqpDPYVIY
	DNVLOLUGl0ANLXnVJfeI8B/LDIA7VTNSQcg0b7yU+MUWox16J313kq7TIYqEFZ+YVwZlaGsBDyh
	G5rFHKeTvibQMfugzH4KpVDWsxuB+47zVNdPNvY+xG9NAuMnkSuRvQNj1XyidfDhCpRuNgK5CpM
	1+5BKjHJSN97kYcZ/MAGxhBarWKX1uMLksql4JqBvkpMOpWDa
X-Received: by 2002:a05:622a:2b4f:b0:527:6d4a:1970 with SMTP id d75a77b69052e-5283de68b0emr49059371cf.38.1784856533309;
        Thu, 23 Jul 2026 18:28:53 -0700 (PDT)
X-Received: by 2002:a05:622a:2b4f:b0:527:6d4a:1970 with SMTP id d75a77b69052e-5283de68b0emr49059051cf.38.1784856532497;
        Thu, 23 Jul 2026 18:28:52 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:b400:d348:ae32:97a6:8a0d? ([2600:4040:530f:b400:d348:ae32:97a6:8a0d])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-527d402cb05sm45796231cf.31.2026.07.23.18.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 18:28:51 -0700 (PDT)
Message-ID: <178a5039-1817-4e13-8937-12eee8b26cc6@redhat.com>
Date: Thu, 23 Jul 2026 21:28:50 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] vdo: add zstd compression support
To: Rhajune Park <june@pythonplayer123.dev>, dm-devel@lists.linux.dev
References: <20260723161350.1080473-1-june@pythonplayer123.dev>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20260723161350.1080473-1-june@pythonplayer123.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IXQAKnuwfIyw3DN54GJPFiVjmDYUByIZj5Q619D2Dxg_1784856534
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Rhajune,

I have to ask, what is the motivation for this change? Do you have a 
workload that shows some kind of improvement from this proposal?

About a year and a half ago, shortly after the linked discussion, we did 
make an effort to try to add zstd compression as an option to dm-vdo. 
You can see some of the discussion here:

https://github.com/dm-vdo/vdo-devel/pull/241/

The summary version, though, is that, because of the way dm-vdo handles 
compressed blocks, it is not very sensitive to the choice of compression 
algorithm, and we were unable to really find any use cases where 
changing the algorithm made dm-vdo operate better in any way.

So, unless you can demonstrate some improvement from this change, it 
looks like a lot of complication for no actual benefit. There's no 
reason for us to accept this.

Matt

On 7/23/26 12:13 PM, Rhajune Park wrote:
> Allow for newly created VDO volumes to select zstd for compression.
> Uses geometry version 5.1 for zstd volumes.
> 
> Link: https://lore.kernel.org/dm-devel/CAAiJnjoGn4Jn6O-SWAaAzwNk4DhEiCFUA0Q0X2RLdrHH7NR5qg@mail.gmail.com
> Assisted-by: opencode:gpt-5.6-sol
> Signed-off-by: Rhajune Park <june@pythonplayer123.dev>
> ---
>   drivers/md/dm-vdo/Kconfig         |   2 +
>   drivers/md/dm-vdo/Makefile        |   1 +
>   drivers/md/dm-vdo/compression.c   | 176 ++++++++++++++++++++++++++++++
>   drivers/md/dm-vdo/compression.h   |  27 +++++
>   drivers/md/dm-vdo/data-vio.c      |  20 ++--
>   drivers/md/dm-vdo/dm-vdo-target.c |  47 +++++++-
>   drivers/md/dm-vdo/encodings.c     |  58 +++++++---
>   drivers/md/dm-vdo/encodings.h     |  23 +++-
>   drivers/md/dm-vdo/message-stats.c |  20 +++-
>   drivers/md/dm-vdo/types.h         |   9 ++
>   drivers/md/dm-vdo/vdo.c           |  44 ++++----
>   drivers/md/dm-vdo/vdo.h           |   6 +-
>   12 files changed, 374 insertions(+), 59 deletions(-)
>   create mode 100644 drivers/md/dm-vdo/compression.c
>   create mode 100644 drivers/md/dm-vdo/compression.h
> 
> diff --git a/drivers/md/dm-vdo/Kconfig b/drivers/md/dm-vdo/Kconfig
> index 2400b2bc4bc7..eafd82e7af4a 100644
> --- a/drivers/md/dm-vdo/Kconfig
> +++ b/drivers/md/dm-vdo/Kconfig
> @@ -7,6 +7,8 @@ config DM_VDO
>   	select DM_BUFIO
>   	select LZ4_COMPRESS
>   	select LZ4_DECOMPRESS
> +	select ZSTD_COMPRESS
> +	select ZSTD_DECOMPRESS
>   	select MIN_HEAP
>   	help
>   	  This device mapper target presents a block device with
> diff --git a/drivers/md/dm-vdo/Makefile b/drivers/md/dm-vdo/Makefile
> index 9476957bfbf4..c9cd6ba3c7d7 100644
> --- a/drivers/md/dm-vdo/Makefile
> +++ b/drivers/md/dm-vdo/Makefile
> @@ -9,6 +9,7 @@ dm-vdo-objs := \
>   	admin-state.o \
>   	block-map.o \
>   	completion.o \
> +	compression.o \
>   	data-vio.o \
>   	dedupe.o \
>   	dm-vdo-target.o \
> diff --git a/drivers/md/dm-vdo/compression.c b/drivers/md/dm-vdo/compression.c
> new file mode 100644
> index 000000000000..1bb63d4783c0
> --- /dev/null
> +++ b/drivers/md/dm-vdo/compression.c
> @@ -0,0 +1,176 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright 2026 Rhajune Park <june@pythonplayer123.dev>
> + */
> +
> +#include "compression.h"
> +
> +#include <linux/lz4.h>
> +#include <linux/zstd.h>
> +
> +#include "constants.h"
> +#include "funnel-workqueue.h"
> +#include "memory-alloc.h"
> +#include "status-codes.h"
> +#include "types.h"
> +#include "vdo.h"
> +
> +struct vdo_compression_context {
> +	void *compression_workspace;
> +	void *decompression_workspace;
> +	zstd_cctx *zstd_cctx;
> +	zstd_dctx *zstd_dctx;
> +	zstd_parameters zstd_parameters;
> +};
> +
> +bool vdo_is_valid_compression_level(int level)
> +{
> +	return level >= zstd_min_clevel() && level <= zstd_max_clevel();
> +}
> +
> +int vdo_resolve_compression_level(struct device_config *config, char **reason)
> +{
> +	if (config->compression_algorithm == VDO_COMPRESSION_ALGORITHM_LZ4) {
> +		if (config->compression_level_set) {
> +			*reason = "Compression level is only supported with ZSTD";
> +			return VDO_BAD_CONFIGURATION;
> +		}
> +
> +		config->compression_level = 0;
> +	}
> +
> +	return VDO_SUCCESS;
> +}
> +
> +static void free_compression_context(struct vdo_compression_context *context)
> +{
> +	if (context == NULL)
> +		return;
> +
> +	vdo_free(vdo_forget(context->decompression_workspace));
> +	vdo_free(vdo_forget(context->compression_workspace));
> +	vdo_free(context);
> +}
> +
> +void vdo_free_compression_contexts(struct vdo *vdo)
> +{
> +	unsigned int i;
> +
> +	if (vdo->compression_context == NULL)
> +		return;
> +
> +	for (i = 0; i < vdo->device_config->thread_counts.cpu_threads; i++)
> +		free_compression_context(vdo_forget(vdo->compression_context[i]));
> +
> +	vdo_free(vdo_forget(vdo->compression_context));
> +}
> +
> +static int make_lz4_context(struct vdo_compression_context *context)
> +{
> +	return vdo_allocate_memory(LZ4_MEM_COMPRESS, 1, "LZ4 context",
> +				   &context->compression_workspace);
> +}
> +
> +static int make_zstd_context(struct vdo_compression_context *context, int level)
> +{
> +	size_t workspace_size;
> +	int result;
> +
> +	context->zstd_parameters = zstd_get_params(level, VDO_BLOCK_SIZE);
> +	workspace_size = zstd_cctx_workspace_bound(&context->zstd_parameters.cParams);
> +	result = vdo_allocate_memory(workspace_size, 8, "ZSTD compression context",
> +				     &context->compression_workspace);
> +	if (result != VDO_SUCCESS)
> +		return result;
> +
> +	context->zstd_cctx = zstd_init_cctx(context->compression_workspace,
> +					    workspace_size);
> +	if (context->zstd_cctx == NULL)
> +		return VDO_BAD_CONFIGURATION;
> +
> +	workspace_size = zstd_dctx_workspace_bound();
> +	result = vdo_allocate_memory(workspace_size, 8, "ZSTD decompression context",
> +				     &context->decompression_workspace);
> +	if (result != VDO_SUCCESS)
> +		return result;
> +
> +	context->zstd_dctx = zstd_init_dctx(context->decompression_workspace,
> +					    workspace_size);
> +	return (context->zstd_dctx == NULL) ? VDO_BAD_CONFIGURATION : VDO_SUCCESS;
> +}
> +
> +int vdo_make_compression_contexts(struct vdo *vdo)
> +{
> +	unsigned int i;
> +	int result;
> +
> +	result = vdo_allocate(vdo->device_config->thread_counts.cpu_threads,
> +			      "compression contexts", &vdo->compression_context);
> +	if (result != VDO_SUCCESS)
> +		return result;
> +
> +	for (i = 0; i < vdo->device_config->thread_counts.cpu_threads; i++) {
> +		struct vdo_compression_context *context;
> +
> +		result = vdo_allocate(1, "compression context", &context);
> +		if (result != VDO_SUCCESS)
> +			return result;
> +
> +		vdo->compression_context[i] = context;
> +		switch (vdo->geometry.compression_algorithm) {
> +		case VDO_COMPRESSION_ALGORITHM_LZ4:
> +			result = make_lz4_context(context);
> +			break;
> +		case VDO_COMPRESSION_ALGORITHM_ZSTD:
> +			result = make_zstd_context(context,
> +						   vdo->device_config->compression_level);
> +			break;
> +		default:
> +			return VDO_BAD_CONFIGURATION;
> +		}
> +
> +		if (result != VDO_SUCCESS)
> +			return result;
> +	}
> +
> +	return VDO_SUCCESS;
> +}
> +
> +size_t vdo_compress_block(struct vdo *vdo, const void *src, void *dst,
> +			  size_t dst_size)
> +{
> +	struct vdo_compression_context *context = vdo_get_work_queue_private_data();
> +	size_t size;
> +
> +	switch (vdo->geometry.compression_algorithm) {
> +	case VDO_COMPRESSION_ALGORITHM_LZ4:
> +		return LZ4_compress_default(src, dst, VDO_BLOCK_SIZE, dst_size,
> +					    context->compression_workspace);
> +	case VDO_COMPRESSION_ALGORITHM_ZSTD:
> +		size = zstd_compress_cctx(context->zstd_cctx, dst, dst_size, src,
> +					  VDO_BLOCK_SIZE, &context->zstd_parameters);
> +		return zstd_is_error(size) ? 0 : size;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +int vdo_decompress_block(struct vdo *vdo, const void *src, size_t src_size,
> +			 void *dst)
> +{
> +	struct vdo_compression_context *context = vdo_get_work_queue_private_data();
> +	size_t size;
> +
> +	switch (vdo->geometry.compression_algorithm) {
> +	case VDO_COMPRESSION_ALGORITHM_LZ4:
> +		return (LZ4_decompress_safe(src, dst, src_size, VDO_BLOCK_SIZE) ==
> +			VDO_BLOCK_SIZE) ? VDO_SUCCESS : VDO_INVALID_FRAGMENT;
> +	case VDO_COMPRESSION_ALGORITHM_ZSTD:
> +		size = zstd_decompress_dctx(context->zstd_dctx, dst, VDO_BLOCK_SIZE,
> +					    src, src_size);
> +		return (!zstd_is_error(size) && size == VDO_BLOCK_SIZE) ?
> +			VDO_SUCCESS : VDO_INVALID_FRAGMENT;
> +	default:
> +		return VDO_INVALID_FRAGMENT;
> +	}
> +}
> diff --git a/drivers/md/dm-vdo/compression.h b/drivers/md/dm-vdo/compression.h
> new file mode 100644
> index 000000000000..74ec1577460e
> --- /dev/null
> +++ b/drivers/md/dm-vdo/compression.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright 2026 Rhajune Park <june@pythonplayer123.dev>
> + */
> +
> +#ifndef VDO_COMPRESSION_H
> +#define VDO_COMPRESSION_H
> +
> +#include <linux/types.h>
> +
> +struct vdo;
> +struct vdo_compression_context;
> +struct device_config;
> +
> +#define VDO_DEFAULT_ZSTD_COMPRESSION_LEVEL 1
> +
> +bool vdo_is_valid_compression_level(int level);
> +int vdo_resolve_compression_level(struct device_config *config, char **reason);
> +int vdo_make_compression_contexts(struct vdo *vdo);
> +void vdo_free_compression_contexts(struct vdo *vdo);
> +
> +size_t vdo_compress_block(struct vdo *vdo, const void *src, void *dst,
> +			  size_t dst_size);
> +int vdo_decompress_block(struct vdo *vdo, const void *src, size_t src_size,
> +			 void *dst);
> +
> +#endif /* VDO_COMPRESSION_H */
> diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
> index 370d4239ba31..fb78ef719509 100644
> --- a/drivers/md/dm-vdo/data-vio.c
> +++ b/drivers/md/dm-vdo/data-vio.c
> @@ -13,7 +13,6 @@
>   #include <linux/jiffies.h>
>   #include <linux/kernel.h>
>   #include <linux/list.h>
> -#include <linux/lz4.h>
>   #include <linux/minmax.h>
>   #include <linux/sched.h>
>   #include <linux/spinlock.h>
> @@ -26,6 +25,7 @@
>   #include "permassert.h"
>   
>   #include "block-map.h"
> +#include "compression.h"
>   #include "dump.h"
>   #include "encodings.h"
>   #include "int-map.h"
> @@ -1423,7 +1423,6 @@ void release_data_vio_allocation_lock(struct data_vio *data_vio, bool reset)
>   int uncompress_data_vio(struct data_vio *data_vio,
>   			enum block_mapping_state mapping_state, char *buffer)
>   {
> -	int size;
>   	u16 fragment_offset, fragment_size;
>   	struct compressed_block *block = data_vio->compression.block;
>   	int result = vdo_get_compressed_block_fragment(mapping_state, block,
> @@ -1434,10 +1433,10 @@ int uncompress_data_vio(struct data_vio *data_vio,
>   		return result;
>   	}
>   
> -	size = LZ4_decompress_safe((block->data + fragment_offset), buffer,
> -				   fragment_size, VDO_BLOCK_SIZE);
> -	if (size != VDO_BLOCK_SIZE) {
> -		vdo_log_debug("%s: lz4 error", __func__);
> +	result = vdo_decompress_block(vdo_from_data_vio(data_vio),
> +				      block->data + fragment_offset, fragment_size, buffer);
> +	if (result != VDO_SUCCESS) {
> +		vdo_log_debug("%s: decompression error", __func__);
>   		return VDO_INVALID_FRAGMENT;
>   	}
>   
> @@ -1753,7 +1752,7 @@ static void pack_compressed_data(struct vdo_completion *completion)
>   static void compress_data_vio(struct vdo_completion *completion)
>   {
>   	struct data_vio *data_vio = as_data_vio(completion);
> -	int size;
> +	size_t size;
>   
>   	assert_data_vio_on_cpu_thread(data_vio);
>   
> @@ -1761,10 +1760,9 @@ static void compress_data_vio(struct vdo_completion *completion)
>   	 * By putting the compressed data at the start of the compressed block data field, we won't
>   	 * need to copy it if this data_vio becomes a compressed write agent.
>   	 */
> -	size = LZ4_compress_default(data_vio->vio.data,
> -				    data_vio->compression.block->data, VDO_BLOCK_SIZE,
> -				    VDO_MAX_COMPRESSED_FRAGMENT_SIZE,
> -				    (char *) vdo_get_work_queue_private_data());
> +	size = vdo_compress_block(vdo_from_data_vio(data_vio), data_vio->vio.data,
> +				  data_vio->compression.block->data,
> +				  VDO_MAX_COMPRESSED_FRAGMENT_SIZE);
>   	if ((size > 0) && (size < VDO_COMPRESSED_BLOCK_DATA_SIZE)) {
>   		data_vio->compression.size = size;
>   		launch_data_vio_packer_callback(data_vio, pack_compressed_data);
> diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
> index 1d8375cc3c3e..bbbb60818aac 100644
> --- a/drivers/md/dm-vdo/dm-vdo-target.c
> +++ b/drivers/md/dm-vdo/dm-vdo-target.c
> @@ -18,6 +18,7 @@
>   #include "block-map.h"
>   #include "completion.h"
>   #include "constants.h"
> +#include "compression.h"
>   #include "data-vio.h"
>   #include "dedupe.h"
>   #include "dump.h"
> @@ -678,6 +679,32 @@ static int parse_one_key_value_pair(const char *key, const char *value,
>   	if (strcmp(key, "compression") == 0)
>   		return parse_bool(value, "on", "off", &config->compression);
>   
> +	if (strcmp(key, "compressionAlgorithm") == 0) {
> +		if (strcmp(value, "lz4") == 0)
> +			config->compression_algorithm = VDO_COMPRESSION_ALGORITHM_LZ4;
> +		else if (strcmp(value, "zstd") == 0)
> +			config->compression_algorithm = VDO_COMPRESSION_ALGORITHM_ZSTD;
> +		else
> +			return -EINVAL;
> +
> +		return VDO_SUCCESS;
> +	}
> +
> +	if (strcmp(key, "compressionLevel") == 0) {
> +		int level;
> +
> +		result = kstrtoint(value, 10, &level);
> +		if (result || !vdo_is_valid_compression_level(level)) {
> +			vdo_log_error("optional parameter error: invalid ZSTD compression level \"%s\"",
> +				      value);
> +			return -EINVAL;
> +		}
> +
> +		config->compression_level = level;
> +		config->compression_level_set = true;
> +		return VDO_SUCCESS;
> +	}
> +
>   	if (strcmp(key, "indexSparse") == 0)
>   		return parse_bool(value, "on", "off", &config->index_sparse);
>   
> @@ -851,6 +878,8 @@ static int parse_device_config(int argc, char **argv, struct dm_target *ti,
>   	config->max_discard_blocks = 1;
>   	config->deduplication = true;
>   	config->compression = false;
> +	config->compression_algorithm = VDO_COMPRESSION_ALGORITHM_UNSPECIFIED;
> +	config->compression_level = VDO_DEFAULT_ZSTD_COMPRESSION_LEVEL;
>   	config->index_memory = UDS_MEMORY_CONFIG_256MB;
>   	config->index_sparse = false;
>   	config->slab_blocks = DEFAULT_VDO_SLAB_BLOCKS;
> @@ -1893,6 +1922,16 @@ static int validate_new_device_config(struct device_config *to_validate,
>   				      struct device_config *config, bool may_grow,
>   				      char **error_ptr)
>   {
> +	if (to_validate->compression_algorithm != config->compression_algorithm) {
> +		*error_ptr = "Compression algorithm cannot change";
> +		return VDO_PARAMETER_MISMATCH;
> +	}
> +
> +	if (to_validate->compression_level != config->compression_level) {
> +		*error_ptr = "Compression level cannot change while the VDO is active";
> +		return VDO_PARAMETER_MISMATCH;
> +	}
> +
>   	if (to_validate->owning_target->begin != config->owning_target->begin) {
>   		*error_ptr = "Starting sector cannot change";
>   		return VDO_PARAMETER_MISMATCH;
> @@ -1943,6 +1982,12 @@ static int prepare_to_modify(struct dm_target *ti, struct device_config *config,
>   	int result;
>   	bool may_grow = (vdo_get_admin_state(vdo) != VDO_ADMIN_STATE_PRE_LOADED);
>   
> +	if (config->compression_algorithm == VDO_COMPRESSION_ALGORITHM_UNSPECIFIED)
> +		config->compression_algorithm = vdo->device_config->compression_algorithm;
> +	result = vdo_resolve_compression_level(config, &ti->error);
> +	if (result != VDO_SUCCESS)
> +		return -EINVAL;
> +
>   	result = validate_new_device_config(config, vdo->device_config, may_grow,
>   					    &ti->error);
>   	if (result != VDO_SUCCESS)
> @@ -2983,7 +3028,7 @@ static void vdo_resume(struct dm_target *ti)
>   static struct target_type vdo_target_bio = {
>   	.features = DM_TARGET_SINGLETON,
>   	.name = "vdo",
> -	.version = { 9, 2, 0 },
> +	.version = { 9, 3, 0 },
>   	.module = THIS_MODULE,
>   	.ctr = vdo_ctr,
>   	.dtr = vdo_dtr,
> diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
> index d75e023df637..a388976f3028 100644
> --- a/drivers/md/dm-vdo/encodings.c
> +++ b/drivers/md/dm-vdo/encodings.c
> @@ -22,17 +22,17 @@ struct geometry_block {
>   	u32 checksum;
>   } __packed;
>   
> -static const struct header GEOMETRY_BLOCK_HEADER_5_0 = {
> +static const struct header GEOMETRY_BLOCK_HEADER_5 = {
>   	.id = VDO_GEOMETRY_BLOCK,
>   	.version = {
> -		.major_version = 5,
> -		.minor_version = 0,
> +		.major_version = VDO_GEOMETRY_BLOCK_MAJOR_VERSION,
> +		.minor_version = VDO_GEOMETRY_BLOCK_MINOR_LZ4,
>   	},
>   	/*
>   	 * Note: this size isn't just the payload size following the header, like it is everywhere
>   	 * else in VDO.
>   	 */
> -	.size = sizeof(struct geometry_block) + sizeof(struct volume_geometry),
> +	.size = sizeof(struct geometry_block) + sizeof(struct volume_geometry_5_0),
>   };
>   
>   static const struct header GEOMETRY_BLOCK_HEADER_4_0 = {
> @@ -291,24 +291,30 @@ static void decode_volume_geometry(u8 *buffer, size_t *offset,
>    * vdo_encode_volume_geometry() - Encode the on-disk representation of a volume geometry into a buffer.
>    * @buffer: A buffer to store the encoding.
>    * @geometry: The geometry to encode.
> - * @version: The geometry block version to encode.
> - *
>    * Return: VDO_SUCCESS or an error.
>    */
> -int vdo_encode_volume_geometry(u8 *buffer, const struct volume_geometry *geometry,
> -			       u32 version)
> +int vdo_encode_volume_geometry(u8 *buffer, const struct volume_geometry *geometry)
>   {
>   	int result;
>   	enum volume_region_id id;
>   	u32 checksum;
>   	size_t offset = 0;
> -	const struct header *header;
> +	struct header header = GEOMETRY_BLOCK_HEADER_5;
>   
>   	memcpy(buffer, VDO_GEOMETRY_MAGIC_NUMBER, VDO_GEOMETRY_MAGIC_NUMBER_SIZE);
>   	offset += VDO_GEOMETRY_MAGIC_NUMBER_SIZE;
>   
> -	header = (version > 4) ? &GEOMETRY_BLOCK_HEADER_5_0 : &GEOMETRY_BLOCK_HEADER_4_0;
> -	vdo_encode_header(buffer, &offset, header);
> +	switch (geometry->compression_algorithm) {
> +	case VDO_COMPRESSION_ALGORITHM_LZ4:
> +		header.version.minor_version = VDO_GEOMETRY_BLOCK_MINOR_LZ4;
> +		break;
> +	case VDO_COMPRESSION_ALGORITHM_ZSTD:
> +		header.version.minor_version = VDO_GEOMETRY_BLOCK_MINOR_ZSTD;
> +		break;
> +	default:
> +		return VDO_BAD_CONFIGURATION;
> +	}
> +	vdo_encode_header(buffer, &offset, &header);
>   
>   	/* This is for backwards compatibility */
>   	encode_u32_le(buffer, &offset, geometry->unused);
> @@ -316,8 +322,7 @@ int vdo_encode_volume_geometry(u8 *buffer, const struct volume_geometry *geometr
>   	memcpy(buffer + offset, (unsigned char *) &geometry->uuid, sizeof(uuid_t));
>   	offset += sizeof(uuid_t);
>   
> -	if (version > 4)
> -		encode_u64_le(buffer, &offset, geometry->bio_offset);
> +	encode_u64_le(buffer, &offset, geometry->bio_offset);
>   
>   	for (id = 0; id < VDO_VOLUME_REGION_COUNT; id++) {
>   		encode_u32_le(buffer, &offset, geometry->regions[id].id);
> @@ -332,7 +337,7 @@ int vdo_encode_volume_geometry(u8 *buffer, const struct volume_geometry *geometr
>   	else
>   		buffer[offset++] = 0;
>   
> -	result = VDO_ASSERT(header->size == offset + sizeof(u32),
> +	result = VDO_ASSERT(header.size == offset + sizeof(u32),
>   			    "should have encoded up to the geometry checksum");
>   	if (result != VDO_SUCCESS)
>   		return result;
> @@ -352,6 +357,7 @@ int __must_check vdo_parse_geometry_block(u8 *block, struct volume_geometry *geo
>   {
>   	u32 checksum, saved_checksum;
>   	struct header header;
> +	struct header expected_header = GEOMETRY_BLOCK_HEADER_5;
>   	size_t offset = 0;
>   	int result;
>   
> @@ -363,9 +369,22 @@ int __must_check vdo_parse_geometry_block(u8 *block, struct volume_geometry *geo
>   	if (header.version.major_version <= 4) {
>   		result = vdo_validate_header(&GEOMETRY_BLOCK_HEADER_4_0, &header,
>   					     true, __func__);
> +		geometry->compression_algorithm = VDO_COMPRESSION_ALGORITHM_LZ4;
>   	} else {
> -		result = vdo_validate_header(&GEOMETRY_BLOCK_HEADER_5_0, &header,
> -					     true, __func__);
> +		switch (header.version.minor_version) {
> +		case VDO_GEOMETRY_BLOCK_MINOR_LZ4:
> +			geometry->compression_algorithm = VDO_COMPRESSION_ALGORITHM_LZ4;
> +			break;
> +		case VDO_GEOMETRY_BLOCK_MINOR_ZSTD:
> +			geometry->compression_algorithm = VDO_COMPRESSION_ALGORITHM_ZSTD;
> +			break;
> +		default:
> +			return validate_version(expected_header.version, header.version,
> +						"geometry block");
> +		}
> +
> +		expected_header.version.minor_version = header.version.minor_version;
> +		result = vdo_validate_header(&expected_header, &header, true, __func__);
>   	}
>   	if (result != VDO_SUCCESS)
>   		return result;
> @@ -380,8 +399,10 @@ int __must_check vdo_parse_geometry_block(u8 *block, struct volume_geometry *geo
>   	/* Decode and verify the checksum. */
>   	checksum = vdo_crc32(block, offset);
>   	decode_u32_le(block, &offset, &saved_checksum);
> +	if (checksum != saved_checksum)
> +		return VDO_CHECKSUM_MISMATCH;
>   
> -	return ((checksum == saved_checksum) ? VDO_SUCCESS : VDO_CHECKSUM_MISMATCH);
> +	return VDO_SUCCESS;
>   }
>   
>   struct block_map_page *vdo_format_block_map_page(void *buffer, nonce_t nonce,
> @@ -1650,12 +1671,14 @@ static int vdo_compute_index_blocks(const struct index_config *config,
>    * @nonce: The nonce to use to identify the vdo.
>    * @uuid: The uuid to use to identify the vdo.
>    * @index_config: The config used for structure initialization.
> + * @compression_algorithm: The algorithm to use for compressed data.
>    * @geometry: The volume geometry to initialize.
>    *
>    * Return: VDO_SUCCESS or an error code.
>    */
>   int vdo_initialize_volume_geometry(nonce_t nonce, uuid_t *uuid,
>   				   const struct index_config *index_config,
> +				   enum vdo_compression_algorithm compression_algorithm,
>   				   struct volume_geometry *geometry)
>   {
>   	int result;
> @@ -1669,6 +1692,7 @@ int vdo_initialize_volume_geometry(nonce_t nonce, uuid_t *uuid,
>   		/* This is for backwards compatibility. */
>   		.unused = 0,
>   		.nonce = nonce,
> +		.compression_algorithm = compression_algorithm,
>   		.bio_offset = 0,
>   		.regions = {
>   			[VDO_INDEX_REGION] = {
> diff --git a/drivers/md/dm-vdo/encodings.h b/drivers/md/dm-vdo/encodings.h
> index 67ff0ff2ffda..9c5180a76a48 100644
> --- a/drivers/md/dm-vdo/encodings.h
> +++ b/drivers/md/dm-vdo/encodings.h
> @@ -64,7 +64,12 @@ struct packed_header {
>   enum {
>   	VDO_GEOMETRY_BLOCK_LOCATION = 0,
>   	VDO_GEOMETRY_MAGIC_NUMBER_SIZE = 8,
> -	VDO_DEFAULT_GEOMETRY_BLOCK_VERSION = 5,
> +	VDO_GEOMETRY_BLOCK_MAJOR_VERSION = 5,
> +};
> +
> +enum vdo_geometry_block_minor_version {
> +	VDO_GEOMETRY_BLOCK_MINOR_LZ4 = VDO_COMPRESSION_ALGORITHM_LZ4,
> +	VDO_GEOMETRY_BLOCK_MINOR_ZSTD = VDO_COMPRESSION_ALGORITHM_ZSTD,
>   };
>   
>   struct index_config {
> @@ -102,6 +107,18 @@ struct volume_geometry {
>   	struct volume_region regions[VDO_VOLUME_REGION_COUNT];
>   	/* The index config */
>   	struct index_config index_config;
> +	/* The algorithm used for compressed data. */
> +	enum vdo_compression_algorithm compression_algorithm;
> +} __packed;
> +
> +/* This volume geometry struct is used for sizing version 5. */
> +struct volume_geometry_5_0 {
> +	u32 unused;
> +	nonce_t nonce;
> +	uuid_t uuid;
> +	block_count_t bio_offset;
> +	struct volume_region regions[VDO_VOLUME_REGION_COUNT];
> +	struct index_config index_config;
>   } __packed;
>   
>   /* This volume geometry struct is used for sizing only */
> @@ -811,10 +828,10 @@ vdo_get_index_region_size(struct volume_geometry geometry)
>   
>   int vdo_initialize_volume_geometry(nonce_t nonce, uuid_t *uuid,
>   				   const struct index_config *index_config,
> +				   enum vdo_compression_algorithm compression_algorithm,
>   				   struct volume_geometry *geometry);
>   
> -int vdo_encode_volume_geometry(u8 *buffer, const struct volume_geometry *geometry,
> -			       u32 version);
> +int vdo_encode_volume_geometry(u8 *buffer, const struct volume_geometry *geometry);
>   int __must_check vdo_parse_geometry_block(unsigned char *block,
>   					  struct volume_geometry *geometry);
>   
> diff --git a/drivers/md/dm-vdo/message-stats.c b/drivers/md/dm-vdo/message-stats.c
> index b4c919780c22..3d6f035c838e 100644
> --- a/drivers/md/dm-vdo/message-stats.c
> +++ b/drivers/md/dm-vdo/message-stats.c
> @@ -34,6 +34,17 @@ static void write_u32(char *prefix, u32 value, char *suffix, char **buf,
>   	*maxlen -= count;
>   }
>   
> +static void write_s32(char *prefix, s32 value, char *suffix, char **buf,
> +		      unsigned int *maxlen)
> +{
> +	int count;
> +
> +	count = scnprintf(*buf, *maxlen, "%s%d%s", prefix == NULL ? "" : prefix,
> +			  value, suffix == NULL ? "" : suffix);
> +	*buf += count;
> +	*maxlen -= count;
> +}
> +
>   static void write_block_count_t(char *prefix, block_count_t value, char *suffix,
>   				char **buf, unsigned int *maxlen)
>   {
> @@ -461,10 +472,13 @@ static void write_index_config(struct index_config *config, char **buf,
>   int vdo_write_config(struct vdo *vdo, char **buf, unsigned int *maxlen)
>   {
>   	struct vdo_config *config = &vdo->states.vdo.config;
> +	char *compression_algorithm =
> +		(vdo->geometry.compression_algorithm == VDO_COMPRESSION_ALGORITHM_ZSTD) ?
> +		"zstd" : "lz4";
>   
>   	write_string(NULL, "{ ", NULL, buf, maxlen);
>   	/* version */
> -	write_u32("version : ", 1, ", ", buf, maxlen);
> +	write_u32("version : ", 3, ", ", buf, maxlen);
>   	/* physical size */
>   	write_block_count_t("physicalSize : ", config->physical_blocks * VDO_BLOCK_SIZE, ", ",
>   			    buf, maxlen);
> @@ -473,6 +487,10 @@ int vdo_write_config(struct vdo *vdo, char **buf, unsigned int *maxlen)
>   			    buf, maxlen);
>   	/* slab size */
>   	write_block_count_t("slabSize : ", config->slab_size, ", ", buf, maxlen);
> +	write_string("compressionAlgorithm : ", compression_algorithm, ", ", buf, maxlen);
> +	if (vdo->geometry.compression_algorithm == VDO_COMPRESSION_ALGORITHM_ZSTD)
> +		write_s32("compressionLevel : ", vdo->device_config->compression_level,
> +			  ", ", buf, maxlen);
>   	/* index config */
>   	write_index_config(&vdo->geometry.index_config, buf, maxlen);
>   	write_string(NULL, "}", NULL, buf, maxlen);
> diff --git a/drivers/md/dm-vdo/types.h b/drivers/md/dm-vdo/types.h
> index 0d60a88aa086..8d92a8bef3c3 100644
> --- a/drivers/md/dm-vdo/types.h
> +++ b/drivers/md/dm-vdo/types.h
> @@ -205,6 +205,12 @@ struct thread_count_config {
>   	unsigned int hash_zones;
>   } __packed;
>   
> +enum vdo_compression_algorithm {
> +	VDO_COMPRESSION_ALGORITHM_UNSPECIFIED = -1,
> +	VDO_COMPRESSION_ALGORITHM_LZ4 = 0,
> +	VDO_COMPRESSION_ALGORITHM_ZSTD = 1,
> +};
> +
>   struct device_config {
>   	struct dm_target *owning_target;
>   	struct dm_dev *owned_device;
> @@ -225,6 +231,9 @@ struct device_config {
>   	unsigned int block_map_maximum_age;
>   	bool deduplication;
>   	bool compression;
> +	enum vdo_compression_algorithm compression_algorithm;
> +	int compression_level;
> +	bool compression_level_set;
>   	struct thread_count_config thread_counts;
>   	block_count_t max_discard_blocks;
>   	block_count_t slab_blocks;
> diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
> index d0d4e0262be2..1340279701f6 100644
> --- a/drivers/md/dm-vdo/vdo.c
> +++ b/drivers/md/dm-vdo/vdo.c
> @@ -31,7 +31,6 @@
>   
>   #include <linux/completion.h>
>   #include <linux/device-mapper.h>
> -#include <linux/lz4.h>
>   #include <linux/mutex.h>
>   #include <linux/spinlock.h>
>   #include <linux/string.h>
> @@ -45,6 +44,7 @@
>   
>   #include "block-map.h"
>   #include "completion.h"
> +#include "compression.h"
>   #include "data-vio.h"
>   #include "dedupe.h"
>   #include "encodings.h"
> @@ -465,7 +465,8 @@ static int __must_check vdo_format(struct vdo *vdo, char **error_ptr)
>   	};
>   
>   	uuid_gen(&uuid);
> -	result = vdo_initialize_volume_geometry(nonce, &uuid, &index_config, &vdo->geometry);
> +	result = vdo_initialize_volume_geometry(nonce, &uuid, &index_config,
> +						config->compression_algorithm, &vdo->geometry);
>   	if (result != VDO_SUCCESS) {
>   		*error_ptr = "Could not initialize volume geometry during format";
>   		return result;
> @@ -508,7 +509,6 @@ static int initialize_vdo(struct vdo *vdo, struct device_config *config,
>   			  unsigned int instance, char **reason)
>   {
>   	int result;
> -	zone_count_t i;
>   
>   	vdo->device_config = config;
>   	vdo->starting_sector_offset = config->owning_target->begin;
> @@ -540,6 +540,8 @@ static int initialize_vdo(struct vdo *vdo, struct device_config *config,
>   	}
>   
>   	if (mem_is_zero(vdo->geometry_block.vio.data, VDO_BLOCK_SIZE)) {
> +		if (config->compression_algorithm == VDO_COMPRESSION_ALGORITHM_UNSPECIFIED)
> +			config->compression_algorithm = VDO_COMPRESSION_ALGORITHM_LZ4;
>   		result = vdo_format(vdo, reason);
>   		if (result != VDO_SUCCESS)
>   			return result;
> @@ -550,8 +552,19 @@ static int initialize_vdo(struct vdo *vdo, struct device_config *config,
>   			*reason = "Could not parse geometry block";
>   			return result;
>   		}
> +
> +		if (config->compression_algorithm != VDO_COMPRESSION_ALGORITHM_UNSPECIFIED &&
> +		    config->compression_algorithm != vdo->geometry.compression_algorithm) {
> +			*reason = "Compression algorithm does not match formatted volume";
> +			return VDO_PARAMETER_MISMATCH;
> +		}
> +		config->compression_algorithm = vdo->geometry.compression_algorithm;
>   	}
>   
> +	result = vdo_resolve_compression_level(config, reason);
> +	if (result != VDO_SUCCESS)
> +		return result;
> +
>   	result = initialize_thread_config(config->thread_counts, &vdo->thread_config);
>   	if (result != VDO_SUCCESS) {
>   		*reason = "Cannot create thread configuration";
> @@ -563,23 +576,12 @@ static int initialize_vdo(struct vdo *vdo, struct device_config *config,
>   		     config->thread_counts.physical_zones,
>   		     config->thread_counts.hash_zones, vdo->thread_config.thread_count);
>   
> -	/* Compression context storage */
> -	result = vdo_allocate(config->thread_counts.cpu_threads, "LZ4 context",
> -			      &vdo->compression_context);
> +	result = vdo_make_compression_contexts(vdo);
>   	if (result != VDO_SUCCESS) {
> -		*reason = "cannot allocate LZ4 context";
> +		*reason = "cannot allocate compression contexts";
>   		return result;
>   	}
>   
> -	for (i = 0; i < config->thread_counts.cpu_threads; i++) {
> -		result = vdo_allocate(LZ4_MEM_COMPRESS, "LZ4 context",
> -				      &vdo->compression_context[i]);
> -		if (result != VDO_SUCCESS) {
> -			*reason = "cannot allocate LZ4 context";
> -			return result;
> -		}
> -	}
> -
>   	result = register_vdo(vdo);
>   	if (result != VDO_SUCCESS) {
>   		*reason = "Cannot add VDO to device registry";
> @@ -788,12 +790,7 @@ void vdo_destroy(struct vdo *vdo)
>   
>   	uninitialize_thread_config(&vdo->thread_config);
>   
> -	if (vdo->compression_context != NULL) {
> -		for (i = 0; i < vdo->device_config->thread_counts.cpu_threads; i++)
> -			vdo_free(vdo_forget(vdo->compression_context[i]));
> -
> -		vdo_free(vdo_forget(vdo->compression_context));
> -	}
> +	vdo_free_compression_contexts(vdo);
>   	vdo_free(vdo);
>   }
>   
> @@ -1031,8 +1028,7 @@ void vdo_save_geometry_block(struct vdo *vdo, struct vdo_completion *parent)
>   {
>   	struct vdo_geometry_block *geometry_block = &vdo->geometry_block;
>   
> -	vdo_encode_volume_geometry(geometry_block->buffer, &vdo->geometry,
> -				   VDO_DEFAULT_GEOMETRY_BLOCK_VERSION);
> +	vdo_encode_volume_geometry(geometry_block->buffer, &vdo->geometry);
>   	geometry_block->vio.completion.parent = parent;
>   	geometry_block->vio.completion.callback_thread_id = parent->callback_thread_id;
>   	vdo_submit_metadata_vio(&geometry_block->vio,
> diff --git a/drivers/md/dm-vdo/vdo.h b/drivers/md/dm-vdo/vdo.h
> index 9a63f5d45ce3..dc09c828b5c6 100644
> --- a/drivers/md/dm-vdo/vdo.h
> +++ b/drivers/md/dm-vdo/vdo.h
> @@ -170,6 +170,8 @@ struct vdo_administrator {
>   	struct completion callback_sync;
>   };
>   
> +struct vdo_compression_context;
> +
>   struct vdo {
>   	char thread_name_prefix[MAX_VDO_WORK_QUEUE_NAME_LEN];
>   	struct vdo_thread *threads;
> @@ -269,8 +271,8 @@ struct vdo {
>   	u64 starting_sector_offset;
>   	struct volume_geometry geometry;
>   
> -	/* N blobs of context data for LZ4 code, one per CPU thread. */
> -	char **compression_context;
> +	/* Compression state private to each CPU worker. */
> +	struct vdo_compression_context **compression_context;
>   };
>   
>   /**

