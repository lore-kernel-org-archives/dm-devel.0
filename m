Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CE471B50
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 19:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713211000; cv=none; b=h+2pH0iZJj7cfxOw2ZtfA8OgfMU6cLWXoT7xSEsHGNpKf7CQ4TKmcpA52yOkX4UIvfItwoEU7Jf6Z4SJ9IT2GVOXs1L8yRC8mcZSQzvoWTvW7Klo3CnnYKqsT/xQmBAHYjuvbGZwkpbnzcojrNGUfWLdIN/6DVibgaFDgB0l2sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713211000; c=relaxed/simple;
	bh=dC4s91t5qBKCHyNN5rKv1IPrdoB6zaDEwfafoSCR91k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=e6EHqaZL6NOPO6u3PE+v09QM5z4l9703BerJUIPZ5GVtkqtlDabXKSvbKs03jr+kGptkfH7QBcuXXj6kZJvjBkgPiGdiB9VmzVnYDn8/lUFAjqzvb9ClBGO8jM4JXhSfL6w8/6GlZxj6yLEV6STYGNqBHxF5whg7qLiIPOrHpf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aJuWdSE9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJuWdSE9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713210997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bG35vuPs2gV03R4SJtXJmpy8yBrYHYtZhZ+cuQSMSRM=;
	b=aJuWdSE9aFGy20ITAUtWEzgy2VTWO1DfO9WLeEv2wY/JkefOJq25myEAsIJhng4G0Eqrv4
	uxJlTS8lb2oFGUJFVESkqaerB7mkMRIsShpA0Z7X90jNnyx/kyyqbEGJFXdp0ThIn670/F
	E9cY4Fwg93S3J7d61APGEu+g2SzYKtU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-j4tBiozYMmCGmqNKkxZLYA-1; Mon, 15 Apr 2024 15:56:34 -0400
X-MC-Unique: j4tBiozYMmCGmqNKkxZLYA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BCF6104D509;
	Mon, 15 Apr 2024 19:56:34 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DC159492BD4;
	Mon, 15 Apr 2024 19:56:33 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id C53D230BFED5; Mon, 15 Apr 2024 19:56:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id C08373FB54;
	Mon, 15 Apr 2024 21:56:33 +0200 (CEST)
Date: Mon, 15 Apr 2024 21:56:33 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev, 
    Eric Biggers <ebiggers@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, 
    Daniel Lee <chullee@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] dm: Change the default value of rq_affinity from 0 into
 1
In-Reply-To: <20240415194921.6404-1-bvanassche@acm.org>
Message-ID: <20cf8b38-6c5b-9a10-6a7b-5d587a19eed@redhat.com>
References: <20240415194921.6404-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10



On Mon, 15 Apr 2024, Bart Van Assche wrote:

> The following behavior is inconsistent:
> * For request-based dm queues the default value of rq_affinity is 1.
> * For bio-based dm queues the default value of rq_affinity is 0.
> 
> The default value for request-based dm queues is 1 because of the following
> code in blk_mq_init_allocated_queue():
> 
>     q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
> 
> >From <linux/blkdev.h>:
> 
>     #define QUEUE_FLAG_MQ_DEFAULT ((1UL << QUEUE_FLAG_IO_STAT) |	\
> 				   (1UL << QUEUE_FLAG_SAME_COMP) |	\
> 				   (1UL << QUEUE_FLAG_NOWAIT))
> 
> The default value of rq_affinity for bio-based dm queues is 0 because the
> dm alloc_dev() function does not set any of the QUEUE_FLAG_SAME_* flags. I
> think the different default values are the result of an oversight when
> blk-mq support was added in the device mapper code. Hence this patch that
> changes the default value of rq_affinity from 0 to 1 for bio-based dm
> queues.
> 
> This patch reduces the boot time from 12.23 to 12.20 seconds on my test

Are you sure that this is not jitter?

I am wondering how should QUEUE_FLAG_SAME_COMP work for bio-based
devices.

I grepped the kernel for QUEUE_FLAG_SAME_COMP and it is tested in 
block/blk-mq.c in blk_mq_complete_need_ipi (this code path is taken only 
for request-based devices) and in block/blk-sysfs.c in 
queue_rq_affinity_show (this just displays the value in sysfs). There are 
no other places where QUEUE_FLAG_SAME_COMP is tested, so I don't see what 
effect is it supposed to have.

Mikulas


> setup, a Pixel 2023 development board. The storage controller on that test
> setup supports a single completion interrupt and hence benefits from
> redirecting I/O completions to a CPU core that is closer to the submitter.
> 
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: Daniel Lee <chullee@google.com>
> Cc: stable@vger.kernel.org
> Fixes: bfebd1cdb497 ("dm: add full blk-mq support to request-based DM")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/md/dm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 56aa2a8b9d71..9af216c11cf7 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2106,6 +2106,7 @@ static struct mapped_device *alloc_dev(int minor)
>  	if (IS_ERR(md->disk))
>  		goto bad;
>  	md->queue = md->disk->queue;
> +	blk_queue_flag_set(QUEUE_FLAG_SAME_COMP, md->queue);
>  
>  	init_waitqueue_head(&md->wait);
>  	INIT_WORK(&md->work, dm_wq_work);
> 

