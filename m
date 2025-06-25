Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B272C1A2
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 15:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866495; cv=none; b=frMjJWoYirWqJotQn2m+1/PHvSsvqzZQbNLZbuRfFbg8xY1QqWziEAS5MRc/eIbLkkP8p0O04xSLaO+TbyDGs7r7lqBY6Oh0J/HobuieMH5t21wB9xvuXYbXotpjsdA5cd3WhF6/Y8hUO83P2qFmE7MWLfjaQXHai5wRySH5EB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866495; c=relaxed/simple;
	bh=7o5VkU9SFyMDyvjbu2OHkFkxCR5C30AGDl+xnpCJSqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kYQEY0he6MWKeidvNNu2++tMyraX9Is6KpGwDd8uUKx5ThxCOcbiRREZfmi/yHRGGmkU5Z+3tj9MIAY1IErrpKnnSifdHjHGGBkAWkEMV7CR+TIeZRx7nWB/EDH3xqwwhu4Vo+fG8E/CLuY+ReFziSCIh6YZKiYvx/1HjFoA8mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uegHB6vE; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uegHB6vE"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bS5nS6T8rzm0gbh;
	Wed, 25 Jun 2025 15:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750866491; x=1753458492; bh=viFYFSnZ8bLGCWdK4nSwTORc
	z+rOkp8LJ9hrkreHbRo=; b=uegHB6vEPDOVku84f8+ng9lXN8y4iFSYIz6of/hF
	lruDbsO+vnD63G5YH+XrDYvwmZDU+OaJImLz/aBAX8FaWHeW07fDUwVGg/7TRcpr
	TgPuhY2OhX5L/slAzU+aoaNZELKW+49eKuEEbOe3YCWiC6jWrz2N/kzfzm+Hze15
	V6rWREny3Mc/uHDIUoUOj5Eo/dMegu2at4RSUwfhzXtsixpeZVRMABxZ4/tXTbnv
	8+MzuKw0RPscHLoUQCxuL0JHErjMhhyTW75VkvgcbIHWTfbdZ0kJzs8ur+g00/9J
	3t+bvTTF3KYuliuTvO/3CGZWH+LVVsxU4Sy+PYKikDymCg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TDSp8Z-4t6Zo; Wed, 25 Jun 2025 15:48:11 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bS5nL5htFzm0pKW;
	Wed, 25 Jun 2025 15:48:05 +0000 (UTC)
Message-ID: <38ddf5f9-80e4-4909-b5cc-cef0ffce19dd@acm.org>
Date: Wed, 25 Jun 2025 08:48:04 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] block: Introduce bio_needs_zone_write_plugging()
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20250625093327.548866-1-dlemoal@kernel.org>
 <20250625093327.548866-3-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250625093327.548866-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/25 2:33 AM, Damien Le Moal wrote:
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 4806b867e37d..0c61492724d2 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3169,8 +3169,10 @@ void blk_mq_submit_bio(struct bio *bio)
>   	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
>   		goto queue_exit;
>   
> -	if (blk_queue_is_zoned(q) && blk_zone_plug_bio(bio, nr_segs))
> -		goto queue_exit;
> +	if (bio_needs_zone_write_plugging(bio)) {
> +		if (blk_zone_plug_bio(bio, nr_segs))
> +			goto queue_exit;
> +	}

Why nested if-statements instead of keeping "&&"? I prefer "&&".

Thanks,

Bart.
