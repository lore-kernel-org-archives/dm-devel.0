Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D58D2727FC
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 15:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752160129; cv=none; b=reAhWfy4Uoq3Uly7WFCAoTv5VP0LgZQLwW3e7v/2tCJz0Pgf3P2cf4aXa6SiXma3Bm4En/AOJTSqQ/1nbYJCEtOyriHpn8BxiMJB2D+Y5pGzKI9Z9AmnYZ7t90yYG/T8iEFl32mte+Ztg3Q648FjB8pChuxTHFUPYOlnsxl+idY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752160129; c=relaxed/simple;
	bh=QyVa336Ax4fYxIVQnHT2lv1xl803ARX1EKCvvArbBpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qo7Zs4iNzbnO03RFmnU/p8I1jU58wqkwhJ3Qnh8lyNnHKMhtJB5bYd4acHWpwATfy+n/In7UYn3wcM5AVJVmMOtqp03O6n6fgoH3Jkxloluk5SAkbPaQBKaLzGCVQD/18t38/AtHoHlHcf02uU4xpy+1odSp2/d0TQl3fuNk83s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hUwWmIBe; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hUwWmIBe"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-86efcef9194so44876439f.0
        for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 08:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752160127; x=1752764927; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ge1nC4yCBIiNPQ1G0qBajhIAzAiOK+EhF/zLDgsIM/U=;
        b=hUwWmIBeci3LWWFkpAuI5O/Y0KFoBhmdSGDdcPPWkeeEy0ymZDiQ4WP1BdvB7DjfkE
         VxRg0ekiW1oJln1W1pyO3jo+BWOaw8RFiGrHnLb9IEMl89CaBLuqf2pwwxDzGB12CJ23
         6+j+F2KSmeyUI+zOu6GHg5FpSI4Ijpo7yyKmvh6SZ1NaV2tAAqywEW9tCfKMziFTQZeP
         PYkJGY52nf1aCiDv7Z/Xta9lYctQcb0vIvCiZLRU44T5r0lF/X/yLJGg2CBpCpDl9mK/
         Kp/BsVY2xoksPM5nvhA+CLEMxPDPo8s1lwpJFSUJHMnVBUeBhtlAdMXTWMiarZqmOXb+
         pPMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752160127; x=1752764927;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ge1nC4yCBIiNPQ1G0qBajhIAzAiOK+EhF/zLDgsIM/U=;
        b=CjKgpx/mQ0GiKbN6zVg0FBLQQj1r4mHYo7kPXQAy33gI5fH6RCuz+L1n9G58m2sUJ2
         HgLgt1+H3jGNMDku+bvMmit5DiHMK/kgYNbehoOm7NWL5pJSPHzzWgk1jKzoTbaxCV5I
         LXl6LWiw1D/x95ULlV6GBNw8KUQLTXemQWSxiV4nm0UgFbdLBb8oLg1ok8h+vuuTiCDF
         7hvOLZQ5oCCaL6Y9S6VPHlfreb4AvUZfYqxguRvll6j9jywTT13bic6q4JCRCnjX3zSy
         lGdE4gvRrsEknEP/909R2cnhxDGq/OMYsFheQuSADfsqq4UUSFjS5ckFWH/2LSVtCFse
         M3eg==
X-Gm-Message-State: AOJu0YwB0XZExIuV7y/H17Gr5e4KnVf0V6u+8QU8jxOzPn5jJHOSNXh2
	SKVs/tm7yTlF2KMCjeaejXMr67kx7YNKPWmS38+FMrdvRCYtL/Pf0R/5NyzZdT3hrUc=
X-Gm-Gg: ASbGnctww6SItvZRf+coU7bgY+U270R7wHTbOM1pIZIFWoTWNou2ayNR3/5pcwHcj4e
	UxSf6FqEqka1VkDSDylNqSDuhlM0zHEKpiSnKerJvNHWve/0t3osagNTWRRktU4fW1yx7ADZHLd
	Q9NGDmE+dUm2O/N+Lqs6m7LtmWHgI95hCd2alZhDVQacqHrBRXB8vjPfaX0v5tyC0tt12FZpYAy
	oG19wR4Uw8d9LC171NRuXSCLbv0Tw6IehBOMwV+7Ivd3Y/ZoWMZUKaIRDZrU8JR6p3iyg3ExxPZ
	UlpgKCwWs4i3MOXTrkRodsNJacxCV6cqVFcfh0LQ/zVQTduLVH0uYS3PeZ7hgdR5j/Lh8w==
X-Google-Smtp-Source: AGHT+IGmdMCnI9PM5J20YVfQZv3O6vQotnLPNVuRWKQQFulsqOrvRtJsNYHyRleOJsO9cj/dzaQlSw==
X-Received: by 2002:a05:6602:13c2:b0:873:47fb:a455 with SMTP id ca18e2360f4ac-87966269ef0mr451794739f.2.1752160126577;
        Thu, 10 Jul 2025 08:08:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796bc5bc60sm41323839f.47.2025.07.10.08.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jul 2025 08:08:45 -0700 (PDT)
Message-ID: <04620cc5-7c3a-4e4f-87ce-b691d9b57917@kernel.dk>
Date: Thu, 10 Jul 2025 09:08:44 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/6] block: sanitize chunk_sectors for atomic write
 limits
To: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
 nilay@linux.ibm.com, cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 ojaswin@linux.ibm.com, martin.petersen@oracle.com,
 akpm@linux-foundation.org, linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20250709100238.2295112-1-john.g.garry@oracle.com>
 <20250709100238.2295112-3-john.g.garry@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250709100238.2295112-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/9/25 4:02 AM, John Garry wrote:
> Currently we just ensure that a non-zero value in chunk_sectors aligns
> with any atomic write boundary, as the blk boundary functionality uses
> both these values.
> 
> However it is also improper to have atomic write unit max > chunk_sectors
> (for non-zero chunk_sectors), as this would lead to splitting of atomic
> write bios (which is disallowed).
> 
> Sanitize atomic write unit max against chunk_sectors to avoid any
> potential problems.
> 
> Fixes: d00eea91deaf3 ("block: Add extra checks in blk_validate_atomic_write_limits()")
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  block/blk-settings.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index a000daafbfb4..725035376f51 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -180,6 +180,7 @@ static void blk_atomic_writes_update_limits(struct queue_limits *lim)
>  
>  static void blk_validate_atomic_write_limits(struct queue_limits *lim)
>  {
> +	unsigned long long chunk_bytes;
>  	unsigned int boundary_sectors;
>  
>  	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES))
> @@ -202,6 +203,13 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
>  			 lim->atomic_write_hw_max))
>  		goto unsupported;
>  
> +	chunk_bytes = lim->chunk_sectors << SECTOR_SHIFT;
> +	if (chunk_bytes) {
> +		if (WARN_ON_ONCE(lim->atomic_write_hw_unit_max >
> +			chunk_bytes))
> +			goto unsupported;
> +	}

Unnecessary indentation here. Why not just:

	chunk_bytes = lim->chunk_sectors << SECTOR_SHIFT;
	if (WARN_ON_ONCE(chunk_bytes &&
			 lim->atomic_write_hw_unit_max > chunk_bytes))
		goto unsupposed.

Also avoids splitting a comparison over multiple lines, which is always
annoying to read.

-- 
Jens Axboe
