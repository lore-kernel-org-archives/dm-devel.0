Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D062BE020
	for <dm-devel@lists.linux.dev>; Fri,  7 Nov 2025 03:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762485052; cv=none; b=nNaAMAtnnLlDIm+FSJ/dSpXTVzkuvCQ5dBXarMY0rHhCKo99836JV4qbRWQHGTY2jY2YdZTzTw9aRJZ6JITbpFzRqilq+vvFe1Nh9L9p+wGrXxaet324QwYmYe+sJIExeD13Gwl+hGEc0QQ0ScMYcTMemtCdZyotw1onaEB7+g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762485052; c=relaxed/simple;
	bh=bVndKLz4WWzdRbN8QqEEfQaLYG/SmxT81yy1UIm+xO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=il4WobwdaCj0WK2NAlZAeFmmw7ak0LStnPjPr8iAP36838lGt0tuBNkz1QUGChnJC+NHOyqHlwXHO5h7T7ViqcKkg/hA6NjhFYzm3iqoJhLt4VLzVBUnSK4GtEd++aMFlsNsmKQJWAd7Y7wCNKDfvFK62BXXMHhJQexq44I1jtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ok2ivbex; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ok2ivbex"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3418ac74bffso240364a91.1
        for <dm-devel@lists.linux.dev>; Thu, 06 Nov 2025 19:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762485050; x=1763089850; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i46Y/krdgcKkTJacghGNlzht3AVpERglOI1oMeQg+GM=;
        b=Ok2ivbexj2HzgrjOVdGsTVPxDWov1aTVJszUcL9OYfri9Zqdi5zNqKPiW6vHaQXIS+
         fzep4IQOP8zUS08+5Aii0jT6+YZi4UKh+SoLQug4Z94wvicHtD8UG0PybxqGmo5MeF9N
         MfumDek+KWRhrnKOmd/ciaqlaBq2NHGX68/vxgET/5s9sFUQFaZAGIb0d9ercttQO3BL
         hn1wkD00IyXSxfPNqVROCqP/MKpJi35j5q3DfIDMEu994rYTuHH2QxeG4MALavwiUYrw
         MRlFRD/j7d0QfQaxGmYGjw6g9/n+oR3Ch6T8utSR7yRt5K6HBv783rFWQC5GripTiUuP
         R9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762485050; x=1763089850;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i46Y/krdgcKkTJacghGNlzht3AVpERglOI1oMeQg+GM=;
        b=VFci2i6GWzJSeDFgNuUPQJQM36sw6o9qzn+I1Cvxc9UOG6RELTzzeJqbSbCOfo+F/p
         G0S2Ey+pZTqmEeWYOJWcSp/ZtsOLJAz5k9CS2ao0OJwA4CUfrtWbACu6qln71uwE48wb
         97SjtcmVF9rjJ9gYMMbStmst9MC+qqsl1iOuAaNu6q1xl8ZUl5q62e9OmwQpLwZLbRc7
         WjTkoqwe9N0Ac16pGBg70ULYRkqaLpsPsUFahNuc1JuV2oPAEaFI0RFlzq7hpL7azNT0
         4NuyySj0o8fnLhtSPk4ccDCy7Y1vKIpR3BZGr4Bs10Ut2yxkm42nm7IxoZKMBwVAM9ov
         i5uQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkm/vrKLao/LuTlh8AuymuDJ6Vm4CfJ/AeGI/BWCByirIspwg4xOW5PMvXov253Rg5G7zUpMKRBg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyUi3in7YLc7GADN5BrudPQZeABwo3ue+8V0flswVI2DlFq02oZ
	hs7M41pP4ggsCRWpJuMgZwbuko2SIlNvBhZiMoRsGY4Nnz6MBYDn/5hG
X-Gm-Gg: ASbGnctPMK0PiOwJTvUYQay5cRpjY7hGLFcdg4ni2uvJNmhebmzW6ATRpPaifJNXsKM
	gUKLNvIND1NbzX2RLd5/bGfa6UX5Do/l/G97ZXmTFezaVR9HPOhAT8VLCDxcGvKqpuPxQTBAAqC
	HJovTE5sJn9jptOhSltPx5ls86mTSc8LiZ37vamJUBI9jNEPimwIhE8Z8mswCTnHzNfD0yERCZw
	uCObOT/texCetojqT8Dw4yOuZxQ9QNJj2kOuD+mXTrOXNfnlVjA1kclp4GlfYqctPXDKhAjAHLt
	KwSe9hjIb7qSlHUtyXHOht8/qY0itrbJvcgF56BFltqbWShKV4WO4HPNTksDPC0ow3UhzqX0EGN
	qwU0RjJ9J6SgW3eWXesHlceuWya6QXI2nzn3n9K0ergDs7lKjho5dLMPknC1Fw3KkCyi78qqatI
	WJWuOpHCxG3aLCTcasPjD0f2reycZGGb8hVg==
X-Google-Smtp-Source: AGHT+IEKsZMxCivCN51cR3Bqtnd2JdA7jWtWCRkbHDz+7vwikOKSUG9YtkgV/st1M66Tqc7mIScgog==
X-Received: by 2002:a17:90b:1cce:b0:33d:a0fd:257b with SMTP id 98e67ed59e1d1-3434c58a161mr1696621a91.36.1762485049696;
        Thu, 06 Nov 2025 19:10:49 -0800 (PST)
Received: from [10.189.138.37] ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096b889sm43296915ad.14.2025.11.06.19.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 19:10:49 -0800 (PST)
Message-ID: <399dbfbb-401f-4e67-8794-efb7f09f0c78@gmail.com>
Date: Fri, 7 Nov 2025 11:10:46 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dm: BUG on REQ_ATOMIC in dm_accept_partial_bio()
To: Mikulas Patocka <mpatocka@redhat.com>,
 John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
 dm-devel@lists.linux.dev, michael.christie@oracle.com,
 martin.petersen@oracle.com
References: <6428d43a-ded8-c368-2057-39620bdf8546@redhat.com>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
Cc: Yongpeng Yang <yangyongpeng@xiaomi.com>
In-Reply-To: <6428d43a-ded8-c368-2057-39620bdf8546@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/25 23:01, Mikulas Patocka wrote:
> Any bio with REQ_ATOMIC flag set should never be split or partially
> completed, so BUG_ON() on this scenario in dm_accept_partial_bio() (whose
> intent is to allow partial completions).
> 
> Also, we must reject atomic bio to targets that don't support them,
> otherwise this BUG could could be triggered by stray bios that have the

double could.

Yongpeng,

> REQ_ATOMIC set.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>   drivers/md/dm.c |    9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm.c	2025-10-13 21:42:47.000000000 +0200
> +++ linux-2.6/drivers/md/dm.c	2025-11-05 14:43:32.000000000 +0100
> @@ -1321,6 +1321,7 @@ void dm_accept_partial_bio(struct bio *b
>   	BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
>   	BUG_ON(bio_sectors > *tio->len_ptr);
>   	BUG_ON(n_sectors > bio_sectors);
> +	BUG_ON(bio->bi_opf & REQ_ATOMIC);
>   
>   	if (static_branch_unlikely(&zoned_enabled) &&
>   	    unlikely(bdev_is_zoned(bio->bi_bdev))) {
> @@ -1735,8 +1736,12 @@ static blk_status_t __split_and_process_
>   	ci->submit_as_polled = !!(ci->bio->bi_opf & REQ_POLLED);
>   
>   	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
> -	if (ci->bio->bi_opf & REQ_ATOMIC && len != ci->sector_count)
> -		return BLK_STS_IOERR;
> +	if (ci->bio->bi_opf & REQ_ATOMIC) {
> +		if (unlikely(!dm_target_supports_atomic_writes(ti->type)))
> +			return BLK_STS_IOERR;
> +		if (unlikely(len != ci->sector_count))
> +			return BLK_STS_IOERR;
> +	}
>   
>   	setup_split_accounting(ci, len);
>   
> 

