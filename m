Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85C28485
	for <dm-devel@lists.linux.dev>; Sun,  7 Apr 2024 14:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712501828; cv=none; b=gvR+ntOv2bJCAVrzV7j8g6JhkdGizaKiX6YFWwltM2Ox/SKu5XNfaYbIh79dyIkIBc0jMw3Nlr2lFNu1kMmrZ+39BvLHPRWqd4e3PISth0cr7of8pAhEv3dW1JeL0PKNNGzIWcd//axvmGdStiU5n5m6ZmSZCY8tm+V9bIB+IxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712501828; c=relaxed/simple;
	bh=e4fwXOUyYq6mV6uhvLjPhbnGjuszMvN9URKWpUlfXvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SeqSHCc6TBvK3TaMyfW/AWVZ4vX+9r7FsEu3r9aRKbzM+pg6zilxpHkPyr7ZvlloejVpNFZk5IZ2u8p0/Wu13eB5R1csMES0aWY3S50SAXXPbOFiEbodc1a79XU0VPyM/ryEsMpKsw75oLEOjGsPF69r/q2OAHcxBJZpj88ofQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-78d54a3e462so97949085a.0
        for <dm-devel@lists.linux.dev>; Sun, 07 Apr 2024 07:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712501825; x=1713106625;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f9UKQt8oRXG6Dh8pSrRfOqttC99MPstJOYP5P6LSjTI=;
        b=vnDyCR/X8IXidDfQojDuYg0SNSaWep1TLpQA2wom3GxmkBGshOowd5Lgcc2Q41EL/5
         SRo2ZtPqEl3VqEVvsRY5HipETIQ5L/Bv/PpEy3o5MqDfdUl+vCksS1MCf3H00FCFznLY
         Q55CO586gPk7vJWzQ6zfz6m4fiy1QH0vPFHz6bXn+F1zgEXn3EL27n8DIKpjeOvsZBrx
         M8dvnC6NdRID/5WR9yutZnhxEfAzeWKUwd/eQXdm84ffs/vJQuxhnybsHKbKSnEsEN9n
         dMLLLlwROhczfPxg4MuslxxxqxI2vm4Q4KMnJUOVu27rcAnqFRKXgllWfTNSRH993pS0
         wc+g==
X-Forwarded-Encrypted: i=1; AJvYcCWsa9iOObi6ewcGuAegq6RhJ4RjDdJmRRX/iywK6yCN4dbMFfhNJ9/5ZBKxjOtLTYSMnUP5zRQmjl/fhqjJCOhAmR7/mvnwqlI=
X-Gm-Message-State: AOJu0YwRrZe/ofn/b08qCSHi5pLjYxCopmXU3C3PcY19p44ZrOYcm1g4
	wR18HH3aWsPsry5NxeYvc7wZpWcYDajRqWVElySk0IS5r8RSi/sZjUliWgeLfQ==
X-Google-Smtp-Source: AGHT+IFOCt5ITUSZM9yD/CST7Tn+uc5Nrf1bq7XmB0Gqa35jK1G/uyfDDNQaypFMkPS1UTQNfQ/K9w==
X-Received: by 2002:ae9:e412:0:b0:78a:22bd:d980 with SMTP id q18-20020ae9e412000000b0078a22bdd980mr7153654qkc.64.1712501824869;
        Sun, 07 Apr 2024 07:57:04 -0700 (PDT)
Received: from localhost ([64.44.118.111])
        by smtp.gmail.com with ESMTPSA id bq12-20020a05620a468c00b0078d64195031sm328312qkb.31.2024.04.07.07.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 07:57:04 -0700 (PDT)
Date: Sun, 7 Apr 2024 10:57:02 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	janpieter.sollie@edpnet.be, Christoph Hellwig <hch@lst.de>,
	dm-devel@lists.linux.dev, Song Liu <song@kernel.org>,
	linux-raid@vger.kernel.org
Subject: Re: block: allow device to have both virt_boundary_mask and max
 segment size
Message-ID: <ZhK0PvAtXfIfHG4t@redhat.com>
References: <20240407131931.4055231-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240407131931.4055231-1-ming.lei@redhat.com>

On Sun, Apr 07 2024 at  9:19P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> When one stacking device is over one device with virt_boundary_mask and
> another one with max segment size, the stacking device have both limits
> set. This way is allowed before d690cb8ae14b ("block: add an API to
> atomically update queue limits").
> 
> Relax the limit so that we won't break such kind of stacking setting.
> 
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218687
> Reported-by: janpieter.sollie@edpnet.be
> Fixes: d690cb8ae14b ("block: add an API to atomically update queue limits")
> Link: https://lore.kernel.org/linux-block/ZfGl8HzUpiOxCLm3@fedora/
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: dm-devel@lists.linux.dev
> Cc: Song Liu <song@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-settings.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index cdbaef159c4b..d2731843f2fc 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -182,17 +182,13 @@ static int blk_validate_limits(struct queue_limits *lim)
>  		return -EINVAL;
>  
>  	/*
> -	 * Devices that require a virtual boundary do not support scatter/gather
> -	 * I/O natively, but instead require a descriptor list entry for each
> -	 * page (which might not be identical to the Linux PAGE_SIZE).  Because
> -	 * of that they are not limited by our notion of "segment size".
> +	 * Stacking device may have both virtual boundary and max segment
> +	 * size limit, so allow this setting now, and long-term the two
> +	 * might need to move out of stacking limits since we have immutable
> +	 * bvec and lower layer bio splitting is supposed to handle the two
> +	 * correctly.
>  	 */
> -	if (lim->virt_boundary_mask) {
> -		if (WARN_ON_ONCE(lim->max_segment_size &&
> -				 lim->max_segment_size != UINT_MAX))
> -			return -EINVAL;
> -		lim->max_segment_size = UINT_MAX;
> -	} else {
> +	if (!lim->virt_boundary_mask) {
>  		/*
>  		 * The maximum segment size has an odd historic 64k default that
>  		 * drivers probably should override.  Just like the I/O size we
> -- 
> 2.41.0
> 

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
