Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2119E4DEC1B
	for <dm-devel@lists.linux.dev>; Mon, 12 Oct 2026 20:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791836474; cv=none; b=p4sTVAl6WJzPPu98ZpXnAvIvA1CdGWvENCFYO3coPz13Oyv5IuF/RI5SyGpbjeHc4sQ16zgJURE1GOHu3b35SvU/EA65ni+Kf3RAAbbdDqVN5ryqWTUjlGfJCmVjaSNO5WvHFdKzG627j0JjWXGr5Hrt658/fY3QFLyD8NkcCOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791836474; c=relaxed/simple;
	bh=7UIEB3A73ofI1JEPEVW7u76mIWqiduCC1j8GOZ2rTrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lisT8AjLhPXhPxSDc1m0qIRbb2EfWT78pZtp6Eb/2mc/4DoeqKk/hDnkI0c0TLpU6awiYt67c+xJ0+WDYB6r8XN0jeaIkaLUW39+v+vOw5SfGd/fFlkueZBms+adHrpnTIUES5AMFKM3lzZ+grSwBBd2nfv6MbkNuA84/fbcMcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=0MBUt6CQ; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="0MBUt6CQ"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6de1ca1b05aso1475730eaf.0
        for <dm-devel@lists.linux.dev>; Mon, 12 Oct 2026 13:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1791836472; x=1792441272; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7YdOwQKvIOtKNWjhAuzTAXTxb0yaTLWKFCpvhJolByA=;
        b=0MBUt6CQmM1ykWrzSDO2yVbTbf0YE5M8lsKYwJKjpkBmultaXeh84S4JWnegGhMtnl
         zFP7fwUHrjiu2AVVkvA32lfcEa2cpnHn7zQXZVCryDS8FS938VyTcT3MKbuSAUPAO6Q2
         AdNuwZh3BHbpgSwO0sfMmCSYjQnooWPuYzqo2zvtyDo5669dwUVCnvIizsdelnaupAZX
         ZaoSAubf9t0Hp5/shfyugNwnKbD4a/Vv67RrpZVmr6biobOpZwk55oI6smYcmKomZoq/
         nwX0zoWsbCuOjwE7igrFQSwiqJcj8FmyKrPUnc+MpDecn9G4QGKBD13BWh15viabKOfR
         g2YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791836472; x=1792441272;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7YdOwQKvIOtKNWjhAuzTAXTxb0yaTLWKFCpvhJolByA=;
        b=Vv2vznOcisz8ZSGc6Ugm7P1fbj+4l1joYNiGcxjko+4kvvhC3dRUVsP9Ej9G5sjPOq
         dkluY+xHWoR6PRN7bWolG+FszarbNRJGTcFyqlXtTgRdqIawR3O+GRvGGaluyziUtq3H
         0VOJw+laKjXLinsTp9Nl4c4fhAtX/B/oa/D6e9q9EvOa9gY7HOOrHJ+FEZflNWAS4OZK
         WNrvyCfHkpUy1V/vXdPSQYvQPJYDf5BVOZ8QB0pNXH7bx0Tj/VgcbHJ6PRYT4HSFVKdN
         fPgvclGBAdarGgy25TQkrcNNUsZqsrwLvjJPIvTBPwhHS1DuT5Jkzt69PsSCD2QoKJMd
         KE0g==
X-Forwarded-Encrypted: i=1; AKwUvBynkeoj4a//yrxy5fDZEhhoXr+dSUA8pRc3Ckss7vB3H4Vr0qSjoIdIGlLbUZf9vwSAuFNPibdNuw==@lists.linux.dev
X-Gm-Message-State: AFq9FYJoTj0mZTrVEojRqx/1iK/zD8xN1M6oIffjAjGJnfd/2tVVY3Oo
	JKUBw8R8E1qklrqaAXrTyD2nti99+fWYa6UuNdHqtFYbzHDm9IiKTspQZf8B13U7SeI=
X-Gm-Gg: AYBFou2tNdABAYYmGyBNKbLd2K+/TBY/vfPqdVqkW7HdzY/thVyQAre8NeWn0avmdok
	R3PXinJHtFC59CP8E6kyhjr/Q1AJ6MSMs1883sIf7xaH/ab+DrsQTN7LeJilogEB8RSqeLQMGyb
	Zg16OUG40sOrsVYGMJJ6MVdfMxbr7dUuNbVLXMkiWMi7amOPUKJ0tw7EOVIinkuOVD81M84UT7m
	omkshZnrTbp+TdpjCuN6mT4lFdMZHU7jO8iysc2v2rG/2yWNdQbQWfkmQiGef+dDmrlHT1uJN+s
	DgFsai35gpnYhwUHSYzSeFyiIQ5SaiGW7EYkWdYfrDoQfeEaXdkq3s7rN91en3lHTmqJTNvRGjJ
	C0ogrUpo3SU3ECH+LsZ1vNVXI8e0/Ayie08qxn9/8ri3JzNR2vzxeEh3tLIGVxwZNFhgH4GNGDF
	Cb2Eb6TV7Qo7iWuWZNWJcia4x7mmVBjRqYdm4IgM40u4jMn9k9KRmNnjPjZPdpPDDKZRYL26iUt
	nAIp0rV4ruOxXGdGEJn5RH+V3kste0FHPU9PIM5euKo+DeXHKr2TBNIzw==
X-Received: by 2002:a05:6820:162a:b0:6f7:75ab:f969 with SMTP id 006d021491bc7-6f775bb41f5mr1943854eaf.66.1791836471882;
        Mon, 12 Oct 2026 13:21:11 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6ef02d91a5asm10237414eaf.14.2026.10.12.13.21.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 13:21:10 -0700 (PDT)
Message-ID: <07d36bc7-637f-4554-9d6f-039e88852dc6@kernel.dk>
Date: Mon, 12 Oct 2026 14:21:03 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/13] block: add dma-buf support for raw bdev
To: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org
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
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
References: <cover.1791336930.git.asml.silence@gmail.com>
 <CGME20261007014324epcas5p2a7f3b03f118c9a1d1c633fe839ed1e46@epcas5p2.samsung.com>
 <af2b48a490186edf38f1d4a5dfd9513574f7a350.1791336930.git.asml.silence@gmail.com>
 <bbb87d6b-b7a3-487a-8be4-27f3f9ce4a1b@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <bbb87d6b-b7a3-487a-8be4-27f3f9ce4a1b@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/8/26 6:27 AM, Anuj Gupta/Anuj Gupta wrote:
> On 10/7/2026 7:12 AM, Pavel Begunkov wrote:
>> +static int blkdev_init_dma_buf_io_ctx(struct file *file,
>> +				      struct dma_buf_io_ctx *ctx)
>> +{
>> +	struct block_device *bdev = file_bdev(file);
>> +	struct gendisk *disk = bdev->bd_disk;
>> +
>> +	if (!(file->f_flags & O_DIRECT))
>> +		return -EINVAL;
>> +	if (!disk->fops->init_dma_buf_io_ctx)
>> +		return -EOPNOTSUPP;
> 
> dma-buf doesn't work with PI: bi_dmabuf_map aliases bi_io_vec, and 
> blk_integrity_iterate() walks it as bvecs to generate/verify the 
> checksum. rw-dmabuf liburing test hangs on a PI enabled NVMe. Something 
> like below is needed:
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index e929f94b25c7..1b7f8cbbda8b 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3150,6 +3150,12 @@ void blk_mq_submit_bio(struct bio *bio)
>                  goto queue_exit;
>          }
> 
> +       if (unlikely(op_is_dmabuf(bio->bi_opf) &&
> +               bdev_has_integrity_csum(bio->bi_bdev))) {
> +               bio_endio_status(bio, BLK_STS_NOTSUPP);
> +               goto queue_exit;
> +       }
> +
>          if ((bio->bi_opf & REQ_POLLED) && !blk_mq_can_poll(q)) {
>                  bio_endio_status(bio, BLK_STS_NOTSUPP);
>                  goto queue_exit;
> diff --git a/block/fops.c b/block/fops.c
> index e9da48ab73be..6c6700df943c 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -976,6 +976,8 @@ static int blkdev_init_dma_buf_io_ctx(struct file *file,
>                  return -EINVAL;
>          if (!disk->fops->init_dma_buf_io_ctx)
>                  return -EOPNOTSUPP;
> +       if (bdev_has_integrity_csum(bdev))
> +               return -EOPNOTSUPP;
>          return disk->fops->init_dma_buf_io_ctx(bdev, ctx);
>   }

Can you send a separate patch? I've queued this series up for some
testing.

-- 
Jens Axboe
