Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EBB34572F
	for <dm-devel@lists.linux.dev>; Sun,  8 Feb 2026 06:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770531677; cv=none; b=LrB8QrFBZQfOdimCxC6f6HTzbN9cI/hH68z5E3KfbMnOW6da+eMPf98IZ3FPVtVRR7dUfAxN6I6h6txM9xLQ+XMoNmLREMvrijOBRAkkO7PvYAektGl6kC/QbooC0qdS04A+oMxiNnWAa6fwo8lJGkUb0s3xRcMlj/qChI+VzIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770531677; c=relaxed/simple;
	bh=icSYaXK3CoH7JYytfswkh+qUzCBauUgvYf2+Z4mC8D0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=sN6AyAREZDH/Fn1ba0TckRqvwx/6dqaXlk0Rd99+VXcYAYjtTbR4BL4Nx9BfjOn8fx9ise1jynbF+f26IBJK/1JPjSvSW6nPoF36GcMR/HvHwNtvO0XemXOyvlfR/S72G7lWHrilvFHmjVeVMiM/3f2WZsvjnMlNQwXgNm+cKls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LP3tXMKl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LP3tXMKl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770531676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8VE5Ny+tVu3mEKfo+elkhrIq2FxH5N//a++dnU6IQdg=;
	b=LP3tXMKlDSC7Me4zwdm9wBLftXcG1J0FLdH4ZuRETWmgmfabIsjF6p2E09dbyEGkuwqJwn
	n9kZ9w96aSAwGw+EoJFe9bI+F7Fc8de/cBwa9MrHr8/6V3XuNB0RFGscb/OaV3WNAm2o4r
	tBBRzSsUKsdUn3xmNlnRXvw49xMZx8U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-283-44DZAFX5MWqNLIz5874OaQ-1; Sun,
 08 Feb 2026 01:21:12 -0500
X-MC-Unique: 44DZAFX5MWqNLIz5874OaQ-1
X-Mimecast-MFC-AGG-ID: 44DZAFX5MWqNLIz5874OaQ_1770531671
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 015141956089;
	Sun,  8 Feb 2026 06:21:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C8E918003F6;
	Sun,  8 Feb 2026 06:21:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6186L82j971832
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 8 Feb 2026 01:21:08 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6186L7QZ971831;
	Sun, 8 Feb 2026 01:21:07 -0500
Date: Sun, 8 Feb 2026 01:21:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: jaeyuel.im@lge.com
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] dm init: ensure block device is ready before creating
 mapped device
Message-ID: <aYgrU8MpeTqJjTMl@redhat.com>
References: <20251212000955.171808-1-jaeyuel.im@lge.com>
 <20260206050526.930530-1-jaeyuel.im@lge.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260206050526.930530-1-jaeyuel.im@lge.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: AhihFE6ou19tQniB8apftva745p_Gd69lUyGkd07jvA_1770531671
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Feb 06, 2026 at 05:05:26AM +0000, jaeyuel.im@lge.com wrote:
> From: "jaeyuel.im" <jaeyuel.im@lge.com>
> 
> The current implementation of dm_init_init() uses early_lookup_bdev() to
> wait for the device node to appear. However, early_lookup_bdev() only
> verifies that the device node exists and returns the dev_t. It does not
> guarantee that the underlying block device structure is fully initialized
> and ready for I/O operations or to be opened.
> 
> On certain platforms (e.g., embedded systems with specific storage
> drivers), this can lead to a race condition where dm_early_create()
> attempts to open the device immediately after early_lookup_bdev() returns,
> but fails because the device is not yet fully ready. This results in boot
> failures as the mapped device cannot be created.
> 
> This patch adds an additional check using blkdev_get_no_open() after
> early_lookup_bdev() returns. This ensures that the struct block_device is
> actually available and the device is ready to be opened, effectively
> preventing the race condition.
> 
> Changes in v2:
> - Pass autoload parameter for new blkdev_get_no_open()
> 
> Changes in v3:
> - Exported to a public header for both blkdev_get_no_open() and
>   blkdev_put_no_open()
> 
> Link: https://patchwork.kernel.org/project/dm-devel/patch/20251212000955.171808-1-jaeyuel.im@lge.com/
> Signed-off-by: jaeyuel.im <jaeyuel.im@lge.com>
> ---

You should put the description of your version changes here, after the
triple dash, so that they aren't part of the actual commit message. 

>  drivers/md/dm-init.c   | 14 ++++++++++++++
>  include/linux/blkdev.h |  3 +++
>  2 files changed, 17 insertions(+)
> 
> [snip] 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 72e34acd439c..7f4a05b536ca 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1873,4 +1873,7 @@ static inline int bio_split_rw_at(struct bio *bio,
>  
>  #define DEFINE_IO_COMP_BATCH(name)	struct io_comp_batch name = { }

If you're adding declarations linux/blkdev.h, you should remove them
from block/blk.h, so the functions aren't declared twice.

Also, IMHO it seems more natural for these declarions to placed near the
related bdev_file_open_by_dev() and bdev_file_open_by_path() ones
earlier in this file.

Finally I Added Jens and linux-block to the CCs, since the patch
includes changes to the block files. FYI, scripts/get_maintainer.pl can
help you send your patches the right people and lists.

-Ben
  
> +struct block_device *blkdev_get_no_open(dev_t dev, bool autoload);
> +void blkdev_put_no_open(struct block_device *bdev);
> +
>  #endif /* _LINUX_BLKDEV_H */
> -- 
> 2.34.1
> 

