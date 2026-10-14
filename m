Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18492525A7E
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 13:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791985261; cv=none; b=Qh7PkEAIXH8JBHF7yi35ha5aW9+jO715XcOxgtKSFVfazhnOwo91gquZK8D52DeJsvx36oQUihMxQld3DhbxPpXERE8vqx5kUjOdwJJL9ukyclQfu67lDajjdnfjZZjYruSDeEcSnWngQnYuu3uYMcG2wcwfflY85joiTBbpd1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791985261; c=relaxed/simple;
	bh=CWLcIVm0rcAVB8dmp3rQdpqenCY0+xLEuROFe1QppjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H8auZbdneTXW+oordqfWg0887CyGzo3nsnfSPty1KD4nP/vsqsFk66mOL6f1RbFs7Gy9NJequz+VQclcp5nTHmQH+Qgu09RyF2l8Cx76UGgZxWPgB+HXcCRmMWMUWhG1pPBu2/LiizgskL5m1oJMfRXyvQ5BRlQWn8aS6rcUjs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=aAPii2tT; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="aAPii2tT"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-82621039b6bso665365a34.1
        for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 06:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1791985257; x=1792590057; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TI1InYuhv2BOMB8UNQLzhmzx2APX9vyjkfAbRr4ddfE=;
        b=aAPii2tTdro89kPqo1+WtG34SDVyvpE1pZRsCpq+WIRqvgjhnH6bl57tWDsXtpABNB
         vJy8SAMlIC0tF4PW3kK8hSLhZ60L1kRGZLSF7lCDPc0jYhllPW6JwJcjkdyAeGWIwBVL
         6byaQN6ohJwXHiG7UFTAen1nw3k2p8tkYBv1daIdSWg995sBTGsHKaC6K8vEHP0sYjOL
         AtqAEOM5UVKUuZLO9OMFue33lOqkN86hoVRqbvYRwl9M/T2wk0pL/+2TS4mk3DzbUjF4
         2K/wo02qsX7r6dsfFW5aiSkW/58izGf6exECfEgdfqgSlQOKwIWypx6vOK5A8AdgWzF0
         6Q1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791985257; x=1792590057;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TI1InYuhv2BOMB8UNQLzhmzx2APX9vyjkfAbRr4ddfE=;
        b=Jt09Ge1/lgbRvhIQWOAGx16g5dq3mHmk3qXdothPF4jKbKNjd+eRxmEq8PzOlSOCEu
         bdOm4mGJ17lPSxzzN6G2P415k7Dr4dMV+HIJQ8/GO3q44zL/SWru7FjZNfNKAM4P3jk5
         ClNdpqC4eTFxVHzvRMGspENKSPndsa3LGsAwFex2ddyC2ilOt2IPscIDlM2ZdoGnH6Yx
         h3/o6OTs7ciyYiaXqCa/52zw6moGdOWiDuKSkmOwVfzbzjEHWMFIfXf8ED/8JsNpi+D+
         6fHlqIUK/DiGqe4qI5zejyCs7cpfQ+0K1AhwBqHz6XdJxWfQW9wNMogZafVCX5Ib+xqG
         ztUg==
X-Forwarded-Encrypted: i=1; AKwUvBxQZH/rqlUf5d7+LegqMAalnvGTZeRbcHf7fha+Gm9vxL2DXouVexOUeV8KqwIbJ2w2fLmLdetefw==@lists.linux.dev
X-Gm-Message-State: AFq9FYLOQQFk9WaELXjAgP0Gu4SuY6hD4MBYDeNYYnE4717rTOXWecw3
	/MR7gKH6BQTXvotHcaZ81RwrzJz8priDeFl/uFKnWD9beYnB6kgHRiVnIW8Y6AGwYTE=
X-Gm-Gg: AYBFou1htx3W7P15gC7axLdcXM7VOLhfZ3ej0S7MSEZ/ZufCclvcMVvludQsdnWYSa4
	23njydy69tx3WTnwuW2ysiUtdGYAPY8pD/rRQWWE0M6QL02VMMhV7+EsYBzaRg/aTkt56VWAKez
	NVK+XB21rAPLqFercd+QBn4wtP/EWVuATa8zUq6G6KljOz5+6VeoYay1nTHaQBoyoXtRgANnrh4
	QZG+X0p4oKy9EehEGEMZni2oURCgRlGo8c8g1m8PfLbweuSdwODfCpS3WPdF1qSe6ZhELY1Ln14
	7l0QH1kKaTtwZ63uR+HNC3/nihshdVE+eB8qf98JOULk6+3bG2WyM2QbmTdGr6W44wNknn+b0FR
	A/QuieGo09DWVzWFGP5moichgrpzmYM1ZvKN9ON/aI4ztd/vmzHkejFPvUVZnxqLh4EVO3hkTO8
	BI/IjrmRx4W+/7eJHf9K0TaOUX5AmG2PBjER185W0d99fhTy7YtQ6thYjQYWwW7+LJQ3B23KNsB
	26z+oJcV9reloI2ypLPeOYbYItwHYlnjfzociPqD3UxQSDi5+tmsX6xFg==
X-Received: by 2002:a05:6830:67e4:b0:812:4cc7:4afe with SMTP id 46e09a7af769-830969d183fmr14838309a34.17.1791985256814;
        Wed, 14 Oct 2026 06:40:56 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-83038f822dcsm14657364a34.10.2026.10.14.06.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 06:40:56 -0700 (PDT)
Message-ID: <81e6538c-977c-4b45-bd44-242ce5e00dd7@kernel.dk>
Date: Wed, 14 Oct 2026 07:40:54 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 13/13] io_uring/rsrc: add dmabuf backed registered
 buffers
To: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>,
 Matthew Brost <matthew.brost@intel.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
References: <cover.1791975048.git.asml.silence@gmail.com>
 <4aa230df871ee275536f367087b44ebfebb88cc1.1791975048.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4aa230df871ee275536f367087b44ebfebb88cc1.1791975048.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A few nits:

> diff --git a/io_uring/dma-buf.c b/io_uring/dma-buf.c
> new file mode 100644
> index 000000000000..1a1a88640823
> --- /dev/null
> +++ b/io_uring/dma-buf.c
> @@ -0,0 +1,66 @@
> +#include "dma-buf.h"

Needs SPDX license header.

> diff --git a/io_uring/dma-buf.h b/io_uring/dma-buf.h
> new file mode 100644
> index 000000000000..a876a9e5e272
> --- /dev/null
> +++ b/io_uring/dma-buf.h
> +static inline int io_attach_dmabuf_map(struct io_kiocb *req,
> +					struct iov_iter *iter,
> +					unsigned issue_flags)
> +{
> +	bool nowait = issue_flags & IO_URING_F_NONBLOCK;
> +	struct dma_buf_io_map *map;
> +	struct io_buf_dma *bd;
> +
> +	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
> +		return -EOPNOTSUPP;
> +	if (!(req->flags & REQ_F_DMABUF))
> +		return 0;
> +
> +	bd = req->buf_node->buf->priv;
> +	map = dma_buf_io_get_map(bd->ctx, nowait);
> +	if (unlikely(IS_ERR(map)))
> +		return PTR_ERR(map);

No need for unlikely() with IS_ERR(), it already includes that.

-- 
Jens Axboe
