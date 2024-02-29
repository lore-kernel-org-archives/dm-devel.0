Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3828C36AE5
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 02:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709172667; cv=none; b=GU6vzJQoq0IiYs9Y5Mk0CErRwnYJfwc+dF6wzCdLd8PR3MMK807e3HCooG4BljajKS+Hvu04x0PU+x7k9HgRB9hf1qVfpaPOjyB7jeRIXTvQvG+6l+GMDaKaeHV2uY8PPg2ZS7v0xVyvX6El5Pd/MrJXDL/Spm84UOtSIjfCV0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709172667; c=relaxed/simple;
	bh=/dli9NzKDUlc8m+eNI7xFfLRpi/JkeuC0P4iaFpB2DU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lsfw2hOB6bBDbMC5ZsuMV2rEV4iuLG/dj9mhCWRz8g4MfO2GnUk3jLTGtEwnl3MvitTP3yZROC+gcX/ec5tNnkOV4zDUce1Naz9kLrvnMzrjk6leMASoKl3cXlURCzB8OkPN7l/nf3iEaec5uaN0qVWBIYBg7g8Inv0nRR/g6DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Da+2m1v7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Da+2m1v7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709172665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gNJXcMKg/H8/hlnteu56zfMe6xk0cck9emthVMHdz9I=;
	b=Da+2m1v7RyFRLFt/IPbcG6RpOBalgEifKQA+g8NTKMIw5SPI+4mYesH3dvFIeUiUa236PF
	7UaTPsjmJzuik2xphzLzLKXbmRpTQP9BTkMfy4n/j5dwkzBGyameb+Ei8iDUoZghCu4Uge
	Bi9lgVZoJj9711W31t53a/J/qvpxqfY=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-KogCTzS4N0SyeGtumpFJNw-1; Wed, 28 Feb 2024 21:11:03 -0500
X-MC-Unique: KogCTzS4N0SyeGtumpFJNw-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-365b4dc6c3eso4962765ab.2
        for <dm-devel@lists.linux.dev>; Wed, 28 Feb 2024 18:11:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709172662; x=1709777462;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gNJXcMKg/H8/hlnteu56zfMe6xk0cck9emthVMHdz9I=;
        b=PEyZVJiHtqIxuHugZuCA/JrbzM+zaDJVFkyKKHwbtwZiSrt7g4JQqAqVYXr6IRTexS
         UjWaEO0yABblzyWMyVotyYB29JjESal2F8XQ4vsCBK6SK0SukYQq6TIROaxUn1SKQ/lj
         g7MMGZIQL2uQ5uYbGOsCX/VK0zcmikZ2Mej5foUZ+AIFvNXMqFno33Sy2tZdRuLqZwMF
         o4LAwZ6KflsxsmFNmx4VDAyTRJlBUreIo+bKeq6FKdGxCiTgUdGWJBmTl9MlSciu1thX
         tVValmSEj7YiSMkdkrfA5WWKO4vayfSLTZrHqiwV7YN86FFfDR0Auhrg7R6cZwfv4akn
         7bNg==
X-Forwarded-Encrypted: i=1; AJvYcCUj/C6bgZH4UHGdsKoIK3PiD2l5wvAx7XajWzcVEO30dDqTbzEyF2YyzJVdEb8Vwz/JqnkfFEvwCKXZ5sbCmC0jN+EU0gxuF4c=
X-Gm-Message-State: AOJu0Yzid57/4KCQTFTqzZpaMOfvcrrapBMTDBmHDZuQP+P7T3ZXXoqf
	2Vq5iDJf1K5RZMQWTUbl3Y0JACLPf47csuNluhlABe4VEfW5Z0UWrS4giLVU+Dsb6R++mmMW3w/
	0CdV2OIxxrHCGnKiNB/JIwleDuiQJ46x4TX29rJFbKUT17rBebZ8SPbkZ
X-Received: by 2002:a05:6e02:506:b0:365:1158:2828 with SMTP id d6-20020a056e02050600b0036511582828mr913275ils.15.1709172662767;
        Wed, 28 Feb 2024 18:11:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEP9FxoguV6Q0tsCv3Hhxq7PWUuVECiu0SjUHkrxUEwbQ/rkc7kC9d3FN8zjmrEV4a+LErhnA==
X-Received: by 2002:a05:6e02:506:b0:365:1158:2828 with SMTP id d6-20020a056e02050600b0036511582828mr913259ils.15.1709172662482;
        Wed, 28 Feb 2024 18:11:02 -0800 (PST)
Received: from [10.72.120.8] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u2-20020aa78482000000b006e48b41aba7sm130197pfn.12.2024.02.28.18.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 18:11:02 -0800 (PST)
Message-ID: <60d75867-8fb7-4c67-96f7-3e5ba65bdbd9@redhat.com>
Date: Thu, 29 Feb 2024 10:10:54 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/14] md: don't suspend the array for interrupted
 reshape
To: Yu Kuai <yukuai1@huaweicloud.com>, mpatocka@redhat.com,
 heinzm@redhat.com, blazej.kucman@linux.intel.com, agk@redhat.com,
 snitzer@kernel.org, dm-devel@lists.linux.dev, song@kernel.org,
 yukuai3@huawei.com, jbrassow@f14.redhat.com, neilb@suse.de, shli@fb.com,
 akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com
References: <20240201092559.910982-1-yukuai1@huaweicloud.com>
 <20240201092559.910982-6-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20240201092559.910982-6-yukuai1@huaweicloud.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2024/2/1 下午5:25, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
>
> md_start_sync() will suspend the array if there are spares that can be
> added or removed from conf, however, if reshape is still in progress,


Hi Kuai

Why md_start_sync can run when reshape is still in progress? 
md_check_recovery should return without queue sync_work, right?

> this won't happen at all or data will be corrupted(remove_and_add_spares
> won't be called from md_choose_sync_action for reshape), hence there is
> no need to suspend the array if reshape is not done yet.
>
> Meanwhile, there is a potential deadlock for raid456:
>
> 1) reshape is interrupted;
>
> 2) set one of the disk WantReplacement, and add a new disk to the array,
>     however, recovery won't start until the reshape is finished;
>
> 3) then issue an IO across reshpae position, this IO will wait for
>     reshape to make progress;
>
> 4) continue to reshape, then md_start_sync() found there is a spare disk
>     that can be added to conf, mddev_suspend() is called;


I c. The answer for my above question is reshape is interrupted and then 
it continues the reshape, right?


Best Regards

Xiao

>
> Step 4 and step 3 is waiting for each other, deadlock triggered. Noted
> this problem is found by code review, and it's not reporduced yet.
>
> Fix this porblem by don't suspend the array for interrupted reshape,
> this is safe because conf won't be changed until reshape is done.
>
> Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need reconfiguration")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6c5d0a372927..85fde05c37dd 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9374,12 +9374,17 @@ static void md_start_sync(struct work_struct *ws)
>   	bool suspend = false;
>   	char *name;
>   
> -	if (md_spares_need_change(mddev))
> +	/*
> +	 * If reshape is still in progress, spares won't be added or removed
> +	 * from conf until reshape is done.
> +	 */
> +	if (mddev->reshape_position == MaxSector &&
> +	    md_spares_need_change(mddev)) {
>   		suspend = true;
> +		mddev_suspend(mddev, false);
> +	}
>   
> -	suspend ? mddev_suspend_and_lock_nointr(mddev) :
> -		  mddev_lock_nointr(mddev);
> -
> +	mddev_lock_nointr(mddev);
>   	if (!md_is_rdwr(mddev)) {
>   		/*
>   		 * On a read-only array we can:

