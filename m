Received: from smtp.smtpout.orange.fr (smtp-80.smtpout.orange.fr [80.12.242.80])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BEC31B80E
	for <dm-devel@lists.linux.dev>; Tue, 29 Sep 2026 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790698927; cv=none; b=hBZKDr2iH4qWA+mEyG/meN+nBjKeWTtUjH91TpMnKj9hhfjWAip6n1hFuIuzb71/l3dnYBdZlt5nKx4RhqZYurJ6bvmhXCk/y7qFZeUlFVViZ4aRlca8kFMwD583UP3TAvSZy0s8GoCxuqLn4Ls9TzxUmpqizJPyfw5UUi7H0oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790698927; c=relaxed/simple;
	bh=SPsJ46zQ3cpUQvCQs2LGwEVPCihPlg7Yokg21P/WkrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=Xi/ts4ea3b4JcOJSC5nbbxWn4QOlzgC+sUzBeV+AOzOSfX0fw5Yo1gMl8jUGwyY9n8Rytq7j2hB7kuzfA7HTPg6Dp3y1VuqwWbn2vKNxgFw/kBHq0JpbVgQcLVjOy15fTUcyBwZm6fsqTJbVqA2KDmLsE8jZLcTQgqPediN+l6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=eORPkq/K; arc=none smtp.client-ip=80.12.242.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="eORPkq/K"
Received: from [IPV6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e] ([10.65.86.61])
	by smtp.orange.fr with ESMTP
	id BaRhx8n1rxLvOBaRhxVPHv; Tue, 29 Sep 2026 18:12:45 +0200
Received: from [IPV6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e]
 ([IPv6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e])
	by smtp.orange.fr with ESMTPSA
	id BaRRx1oDtLJYiBaRSxYYGg; Tue, 29 Sep 2026 18:12:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1790698358;
	bh=/CYIGon90Dpyxdyj2gt7ks36c8ww0+aJ1J2OviNXcD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=eORPkq/KW8MQ+EAJSBy1x5irQF+H5qrTe5xccMDxElj9P2uXgSBHPxUwVpHTVCll6
	 5SVS/MDDhsDAZGN4AAL0A+pqjb3JpY0oiJi4RmA5a2LsMfvbHjAfYgoydzIlArDdd3
	 1gNGXNA6SYakaOVh4qsBVXhu7PPIDqHRVc+uJ/UQNcK+k5bW0OlHVkqB8NEKLzVQbj
	 WrWFK64mS0JYUGD9+lH3bZ6lo+erqhiqIDJbsj/gkK48oHXui/eMVQUzABmKt1pdft
	 A2BL3SeatpaJfbpiuXOHSGDlcAsarPXrMFwp14ziu6eev4OWwWLbbyK8angPUWfxcq
	 OziQJNEFIbFpw==
X-ME-Helo: [IPV6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 29 Sep 2026 18:12:38 +0200
X-ME-IP: 2a01:cb10:785:b00:26fb:aefb:6cd2:db0e
Message-ID: <2620af49-ddd9-4df6-848a-d7c93e8a1c03@wanadoo.fr>
Date: Tue, 29 Sep 2026 18:12:29 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/13] dma-buf: introduce initial file I/O
 infrastructure
To: Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1790602223.git.asml.silence@gmail.com>
 <c33046bbadce5a2f14aa1874270ec2d10def58ef.1790602223.git.asml.silence@gmail.com>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-Language: en-US, fr-FR
Cc: agk@redhat.com, akpm@linux-foundation.org, anuj20.g@samsung.com,
 axboe@kernel.dk, bmarzins@redhat.com, brauner@kernel.org,
 christian.koenig@amd.com, dm-devel@lists.linux.dev,
 dri-devel@lists.freedesktop.org, hch@lst.de, io-uring@vger.kernel.org,
 jack@suse.cz, joshi.k@samsung.com, kbusch@kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, linux-nvme@lists.infradead.org,
 matthew.brost@intel.com, mpatocka@redhat.com, nj.shetty@samsung.com,
 phil.cayton@intel.com, sagi@grimberg.me, snitzer@kernel.org,
 sumit.semwal@linaro.org, tushar.gohad@intel.com, viro@zeniv.linux.org.uk,
 william.power@intel.com
In-Reply-To: <c33046bbadce5a2f14aa1874270ec2d10def58ef.1790602223.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 28/09/2026 à 15:32, Pavel Begunkov a écrit :
> The goal is to be able to natively use dma-buf in the read-write / IO
> path. This patch adds basic building blocks serving as a glue and API
> between drivers and upper layer subsystems providing the uAPI. Later
> patches implement it for NVMe raw block devices and expose it to the
> user space via io_uring.
> 
> There are two main objects. struct dma_buf_io_ctx and struct
> dma_buf_io_map. The ctx is used during initial registration and serves
> as an interface between the upper layer user like io_uring and to the
> importer subsystem / driver. The map represents the actual dma map
> established for the target device[s] with dma_buf_map_attachment() and
> stored in a device specific format. The context is created via a new
> file operation ->init_dma_buf_io_ctx.
> 
> The ctx-map separation exists to support map invalidation (see
> dma_buf_io_invalidate_mappings()). A ctx can create
> multiple maps during its lifetime, but there can only be no more than
> one (active) map attached to it. Invalidation drops the active map
> if present, and the next map will only be attempted to be created
> once there is a new request that wants to use the dma-buf IO ctx.
> 
> The primary task of the dma_buf_io_map object is to count requests
> using it and to wait for their completion when we want to destroy the
> DMA map.
> 
> [un]mapping and any work with dma addresses is delegated to the
> importer driver via an ops table stored in the ctx, see struct
> dma_buf_io_ops. Only the target driver / subsystem knows about devices
> it wants to use the dma-buf with, especially in case of multi-device
> filesystems or stacking in the future.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---

Hi,
a few nitpicks below, should it help


> +static void dma_buf_io_kill_maps(struct dma_buf_io_ctx *ctx, bool final)
> +{
> +	struct dma_buf_io_map *map;
> +
> +	scoped_guard(mutex, &ctx->map_mutex) {

guard() is enough. This saves indentation.

> +		if (final)
> +			ctx->maps_killed = true;
> +
> +		map = rcu_dereference_protected(ctx->map,
> +					lockdep_is_held(&ctx->map_mutex));
> +		if (!map)
> +			return;
> +		rcu_assign_pointer(ctx->map, NULL);
> +		percpu_ref_kill(&map->refs);
> +	}
> +}

...

> +int dma_buf_io_ctx_create(struct file *file,
> +			   struct dma_buf *dmabuf,
> +			   enum dma_data_direction dir,
> +			   struct dma_buf_io_ctx **out_ctx)
> +{
> +	struct dma_buf_io_ctx *ctx;
> +	int ret;
> +
> +	if (!file->f_op->init_dma_buf_io_ctx)
> +		return -EOPNOTSUPP;
> +
> +	ctx = kmalloc_obj(*ctx);

kzalloc_obj() and save the memset() below

> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	memset(ctx, 0, sizeof(*ctx));
> +	ctx->dir = dir;
> +	ctx->dmabuf = dmabuf;
> +	get_dma_buf(dmabuf);
> +	mutex_init(&ctx->map_mutex);
> +	mutex_init(&ctx->map_create_mutex);
> +	atomic_set(&ctx->active_maps, 0);
> +	atomic_set(&ctx->all_maps, 0);
> +	refcount_set(&ctx->refs, 1);
> +	init_waitqueue_head(&ctx->maps_wq);
> +
> +	ret = file->f_op->init_dma_buf_io_ctx(file, ctx);
> +	if (ret) {
> +		kfree(ctx);
> +		dma_buf_put(dmabuf);
> +		return ret;
> +	}
> +
> +	if (WARN_ON_ONCE(!ctx->dev_ops ||
> +			 !ctx->dev_ops->map ||
> +			 !ctx->dev_ops->unmap ||
> +			 !ctx->dev_ops->release))
> +		return -EINVAL;
> +
> +	*out_ctx = ctx;
> +	return 0;
> +}
...

CJ

