Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7552A8C1
	for <dm-devel@lists.linux.dev>; Thu, 22 May 2025 02:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747881912; cv=none; b=jKLTRu1DT+PxffjIpscx5/BYFhR7Un5b9yQBLoA5MbsQh2APJtvViK91qIWttJHk88wCY1kYERRpsO03I5eOAGz9W6TDY7JU5VQ96IOflfpgSEkWNPXSRN8AxoQ4T+vPxpRWII7XVubwolsshMPVSVyJXYTqBXUVAc/3AgjUaf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747881912; c=relaxed/simple;
	bh=b2tFUOcFaU8/z8Y9B16lfLYJUbe8cN5VjQ+FiXJzkV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pdB+TZEt3oMDNUZKYT6p71HPnWth0nvwUkZtWsZSvZy3VUBzpS1ldoOYHWPEnisjnydKkGgI9UWF6S8s+EDOqkjqMNSliUEPIE9ZX33Or3MYgAV00tHu58i4y0zj0AggvBKoQGHVU/i9oMU13fcml9QMEX7Pnhp/i1kKbaurcyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G/jE+2sp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G/jE+2sp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747881909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M35WiklwLEM7n9kBzWJK2ilErFUxO4JXpQma6IcbyPI=;
	b=G/jE+2spzaFu8dhXtRMM1Wjva3iX6JqfNo0d7KT5VA1yjSB8YSWc7ZCOIrn+nWoD4Ep00a
	BtMM4WB9FSpfqNAdSSvuNbeMy302WYEyMJeZFLJhnmM13UBTZXKjtudTDlrvzbx/y1/KGT
	Bs8yMz4DDUH4KVG+DYiE3U6Wg7FxWRQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-FTLj6o2ANZqjyQhtDX6p6A-1; Wed, 21 May 2025 22:45:08 -0400
X-MC-Unique: FTLj6o2ANZqjyQhtDX6p6A-1
X-Mimecast-MFC-AGG-ID: FTLj6o2ANZqjyQhtDX6p6A_1747881907
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2320502023fso45038565ad.2
        for <dm-devel@lists.linux.dev>; Wed, 21 May 2025 19:45:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747881907; x=1748486707;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M35WiklwLEM7n9kBzWJK2ilErFUxO4JXpQma6IcbyPI=;
        b=M3F5tTmm4orSoXNt10JzYstBeZQPPN6HK8sTHlapbUANC+0nP06GMCQPDL3UPY+gmV
         jR6a7oKM/sOJXYZVTr5QHSnBeP9uQDSsEthL9DwihAXQS8sKpF1ce50FK3nRc1Wd4QhE
         tsJYSdUjMbGJQuFlMXqly63LtD+vSSgt8x6+NPbQt6xAipM4kW0fKcVpxh6SGGYEVblm
         ZrY7YX7WyEocVKDRf3yAT9vQZ8k4CF3wwg94AizIlFyCNInHSgl50WX5UUa+asZFpWp7
         JKE78mN7W10dLeFjur1lY7IDaPi8LwwnMKiWFeqAqAzl6zc6NcIg4QmFueUbxRt4C2CF
         QB6Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5IrKHGN203AYRgblUQ0oxwEcgfYpFwM96hRwS8r315JDQvdaDYmqUAeQ4yp+P38dC+gJrB+IKAQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxzhKBYsf8qhMIY2tBbQrYCI4zp5cQ58hgbX5YT0L4vKLPERTRQ
	eYEJmjMlxhjGNh7RMqGNK/6so5O+pMZaxe8NyEZRfH5NHZJoYW+97w5DThq1R9UHfVtOelkSSJO
	w10I5NygOhAa+Q/WYw6xvQB/E5yC+OrDMBVYAX2oVsOpxr+UwN63ROkc4W321
X-Gm-Gg: ASbGnctQC1K5YBhqao88vRPv2tF/Muyuu/EDQM97TiXNKvFLhvl49Fo+e22R0ocr43L
	DoVcagCPgCOX6KugpH0BhmJqazqczWTfUYAhZ9aoXeDwVeiHDIoAWy8fqBcGNT3WTAa2uc2G2aY
	/X/xnE3wYmFBNzG84Yz0aTtY05YpLrlkM0G2BrMhu+Ns476zyeWenNkOEykd08Hr7IC1LqkJ9vg
	5kUqi6OFWCqvVTBhZd/2a/bk2YdjlxYitcdXf6gz2WIvyFg3+Y8X5KZaxcRj3nof7UTpOr3AQ5D
	I2aGtuHmTXvwaTZSy3X/RaTL
X-Received: by 2002:a17:903:32cf:b0:231:d108:70e with SMTP id d9443c01a7336-231d4519cbdmr325018665ad.21.1747881906905;
        Wed, 21 May 2025 19:45:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOp/SkYhql8LCpt4oWjlqEqTveLmbtaUgtGMqdGfMwAidanfeudR0jBgAwd2ULTi028zTefA==
X-Received: by 2002:a17:903:32cf:b0:231:d108:70e with SMTP id d9443c01a7336-231d4519cbdmr325018315ad.21.1747881906500;
        Wed, 21 May 2025 19:45:06 -0700 (PDT)
Received: from [10.72.120.27] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4ed25a9sm99694515ad.223.2025.05.21.19.45.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 19:45:04 -0700 (PDT)
Message-ID: <22e043cb-866d-4c0d-8d92-866750460ab6@redhat.com>
Date: Thu, 22 May 2025 10:44:57 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC md-6.16 v3 07/19] md/md-bitmap: add a new helper
 skip_sync_blocks() in bitmap_operations
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, colyli@kernel.org,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 yukuai3@huawei.com
Cc: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
 <20250512011927.2809400-8-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20250512011927.2809400-8-yukuai1@huaweicloud.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fOuc_azRIDrOB8w-TO3t3G7nHv_90MDvUWIDYdp1vGE_1747881907
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/5/12 上午9:19, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
>
> This helper is used to check if blocks can be skipped before calling
> into pers->sync_request(), llbiltmap will use this helper to skip


typo error s/llbiltmap/llbitmap/g

> resync for unwritten/clean data blocks, and recovery/check/repair for
> unwritten data blocks;
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md-bitmap.h | 1 +
>   drivers/md/md.c        | 7 +++++++
>   2 files changed, 8 insertions(+)
>
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 41d09c6d0c14..13be2a10801a 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -99,6 +99,7 @@ struct bitmap_operations {
>   	void (*end_discard)(struct mddev *mddev, sector_t offset,
>   			    unsigned long sectors);
>   
> +	sector_t (*skip_sync_blocks)(struct mddev *mddev, sector_t offset);
>   	bool (*start_sync)(struct mddev *mddev, sector_t offset,
>   			   sector_t *blocks, bool degraded);
>   	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4329ecfbe8ff..c23ee9c19cf9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9370,6 +9370,12 @@ void md_do_sync(struct md_thread *thread)
>   		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>   			break;
>   
> +		if (mddev->bitmap_ops && mddev->bitmap_ops->skip_sync_blocks) {
> +			sectors = mddev->bitmap_ops->skip_sync_blocks(mddev, j);
> +			if (sectors)
> +				goto update;
> +		}
> +
>   		sectors = mddev->pers->sync_request(mddev, j, max_sectors,
>   						    &skipped);
>   		if (sectors == 0) {
> @@ -9385,6 +9391,7 @@ void md_do_sync(struct md_thread *thread)
>   		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>   			break;
>   
> +update:
>   		j += sectors;
>   		if (j > max_sectors)
>   			/* when skipping, extra large numbers can be returned. */

