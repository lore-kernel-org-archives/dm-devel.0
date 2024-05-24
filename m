Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4132739FF4
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 13:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716558589; cv=none; b=UNTt8b+xi0M4LBbYchVQ44Is2FhEW2kebhDmCnFYFLwDuYBkG9w06aRstho1q229sv53/ZxNLcO5Io/Zb6pfFBYhKsP4AMPlgqc3j2M/Jrybi/7XOCWDugH5vY4WYpRImeEmC03XjHBXIWl7ziprq5MgWuc+9ajlAPI/RuyRzIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716558589; c=relaxed/simple;
	bh=33WjeXVtBHAXy63Mf535PLvhmvIzrIQ3eRV0TsVNwu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d/X9HuXq/kw/Bltkr7tzz4+E+KFOe3jKAHG0r7gGd1Sy4E7YL0BvN1P+0q6TKYGmAonYmkX20sqFY2RaAHZrYsWw8JI5gTjuIa+SggvfCZRASPdiRdhjQS2wHS600krFu5jVzaeFEw5jpafQb5RxFd/PSJC8h5d1W4y4zzm4K1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=udMQqJ4/; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="udMQqJ4/"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vm5y24RR3z6Cnk9B;
	Fri, 24 May 2024 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1716558584; x=1719150585; bh=2dvz9sp9zWTB7DPElSQMRYR+
	icXkhtOC/upc0cGQvlk=; b=udMQqJ4/MLmcfiopcGm4McjwZd/aAENQTTnTCIp1
	/fKqKO0dKUlV2bgHrRN4XMUfwlF6C2xDea24BJSrCdeFQCDnm2tfIKS+l1RENXDA
	ZR4/FcE/WmlnPPvCdMN1rP5+TRkUhQ1gUhpP8nXJiG7P6JBGsVCuMedIwXcTGbNG
	3zV7pjGIYXRqPLX1jw9xqOA6+UNfaZ6I27rEm6IZs8Zs9qsEgCVQGuO9EkpD+7P+
	c/9u/xTc8t5O02x8dhMCJ/UDgbAGMYKtY6Bh4RlJiNJnToZPuE29i8/dqDetgQ05
	MdAmCu4ldXCRtVs5cvjBCNj0/CenlZ6DAogLf80hNoe7lA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bjwhK9LPaoOC; Fri, 24 May 2024 13:49:44 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vm5xy4nHrz6Cnk98;
	Fri, 24 May 2024 13:49:42 +0000 (UTC)
Message-ID: <cbfd280d-188e-4dc9-82a0-4052e58a4bb2@acm.org>
Date: Fri, 24 May 2024 06:49:40 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: check for max_hw_sectors underflow
To: Hannes Reinecke <hare@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev
References: <20240524095719.105284-1-hare@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240524095719.105284-1-hare@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/24/24 02:57, Hannes Reinecke wrote:
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 524cf597b2e9..0cdca702e988 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -133,6 +133,8 @@ static int blk_validate_limits(struct queue_limits *lim)
>   		lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
>   	if (WARN_ON_ONCE(lim->max_hw_sectors < PAGE_SECTORS))
>   		return -EINVAL;
> +	if (WARN_ON_ONCE((lim->logical_block_size >> SECTOR_SHIFT) > lim->max_hw_sectors))
> +		return -EINVAL;
>   	lim->max_hw_sectors = round_down(lim->max_hw_sectors,
>   			lim->logical_block_size >> SECTOR_SHIFT);
>   

Why is lim->max_hw_sectors checked before calling round_down() instead
of checking that round_down() returns zero?

Thanks,

Bart.
