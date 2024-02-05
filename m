Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CF0482C7
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 17:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707153765; cv=none; b=g3t5B0mQUgJ4C8i9U5uPIi0cfe655EpaIAFBLi8zEhGrqwwCCzL8Do2qEkFEricPPReAUfqRyTOnJxz2TEcWy64uprl1miJCae8XcnKDXZ92Kv1qu4wc0mZEIYT2fmLKIjJSsdIEb+LFJRkgqZzrgOWkV+2ZMQEFp8N+3QY0LRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707153765; c=relaxed/simple;
	bh=rzqN431/0aFvVGyPoirlgSiA9EtHtgM6EwzRYeMYXjg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DctuB8+sncHyLnK0DvibxQndPf5gI4Y+HjbXs73c7K0FxcsTGTKpv/58id/IPvsgyTa0UNgNNwTbNAmRJZI3/csxEWk0lGSHYr4DY9W6iUBwhe9MCmnZgRju5bnPT2xNRdt+thlnMaHXQ1cWaFHtYLdLpj/vh6nI3dLTdzovVJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d95d67ff45so30159105ad.2
        for <dm-devel@lists.linux.dev>; Mon, 05 Feb 2024 09:22:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707153764; x=1707758564;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IalXHzJuat3LJZIgHKzunyxRi3LxXhikJ5SB7/hDzeE=;
        b=b2XAlSohfC5XDh2IKmx8+obtHAYhGVZTMCmtV2VQ6z/SlyAEoD8cyM9sx50pKSm0Xs
         HH+oyxBCN3J8em+aHclcdoBvT3gMXSYtDtasjhJuUldm1NZfNO7Tmjz/ke3ZZo/n+cJK
         5CWO8CTms67Hfu57+dQctTVjHGSG+m0yBcVyB9Ut+7DNGmaA/AMAwhZdV7rP8GTUzYcC
         HLni8DrZ9Ds9S/NSslYY4gqD8swRH9gqB6ohmTMXpOAeUgjCRcpLFO4lGfqN/8p3PPn3
         e8zfp2q676Dd2DE3qP5FIvmY5X+K/LjxJAXdm4YjrvlQatmS6QunOOXPMgT1gvuGL0+J
         CJaw==
X-Gm-Message-State: AOJu0YxBerBNew3br0ArklX36kaXQKNykm7D8cRocFgPtNMkUyYuvAlN
	jKAdAdSdMxiowobuDQBLnQb1JJEQ4RVwdfsUl1A4yskj8f2/avboXgwc2Kee
X-Google-Smtp-Source: AGHT+IHoi8+1WshRSGm+IGf/Yw7iTstHiFjfPvL03FSyN+wpNPX7zJGik5WEk6gJr8ulRWlAqZuS2w==
X-Received: by 2002:a17:902:e842:b0:1d9:c187:3f7a with SMTP id t2-20020a170902e84200b001d9c1873f7amr170085plg.60.1707153763592;
        Mon, 05 Feb 2024 09:22:43 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXIi6Hs40oOk5GAqPcqohHEJzf3wZyHM5iNA+C6Bqy4EfZyfuqfTyBWNvggDSOcyK6RK0rGYsu2duM9fxAmSiHYHFxYCl12hsO1FzNQMHX0SwSdFXUNVP8+Y6jm51Zvk9BGnIc7c8sm+Yq16fw70zOZYpWaFiWo597cfu2ozwJb7Rm2WsOWxY5/oLqq+qNRLtb83Q6jHDFVGXk7kSX7crXUgJ8GpOFZkvEU+07iS7j8imgS5RmZvmeNw9DjL1+RbZu1dQ==
Received: from ?IPV6:2620:0:1000:8411:be2a:6ac0:4203:7316? ([2620:0:1000:8411:be2a:6ac0:4203:7316])
        by smtp.gmail.com with ESMTPSA id r20-20020a170903411400b001d8ec844fe7sm103169pld.283.2024.02.05.09.22.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 09:22:43 -0800 (PST)
Message-ID: <7a326c42-5839-4487-9a5c-db35a4ee03d4@acm.org>
Date: Mon, 5 Feb 2024 09:22:42 -0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/26] block: Restore sector of flush requests
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-2-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240202073104.2418230-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/1/24 23:30, Damien Le Moal wrote:
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index b0f314f4bc14..2f58ae018464 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -130,6 +130,7 @@ static void blk_flush_restore_request(struct request *rq)
>   	 * original @rq->bio.  Restore it.
>   	 */
>   	rq->bio = rq->biotail;
> +	rq->__sector = rq->bio->bi_iter.bi_sector;

Hmm ... is it guaranteed that rq->bio != NULL in this context?

Thanks,

Bart.

