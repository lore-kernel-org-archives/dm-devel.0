Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF251D61A3
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 04:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749614431; cv=none; b=cmh4vf2KMW9Qu2K7J4hxrjkpzhMoQNC8DjfgtXnUMuz1PONPX2UMep5NPiNqypBkjPQCQcbKgQNcEsYJva8UyGRVuH3ImzqoaNaMGp3872iaCMnpQNccLuH4wXoVT2mU3wp0EW3860aBulsl+byo+DEnhwm3b4rbEZvgoVvoOPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749614431; c=relaxed/simple;
	bh=m+k6EZmyv9k88y1mHqlxCIry56OlHgyAsTSPtnTotI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dIeIHP8DGXfrBj9K8VxvqzFqsZtFQwjmAWa01a21453Nea9JvbSELx0g6JUBaG373su+jRfF6qI29CE+3l+yw8yxEGf4nHIwMyRTxyGY8tRwLm0Xd+828uG5OLb3MFPr9siPCQp8nP/Tm5D1KPELeSQrEuvkDDLJulL/XtnLJBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyPur5Cs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyPur5Cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F107EC4CEEE;
	Wed, 11 Jun 2025 04:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749614430;
	bh=m+k6EZmyv9k88y1mHqlxCIry56OlHgyAsTSPtnTotI0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oyPur5CsZIl9+clcu0uteWdkxjjvETiAKoR48jwALy3UCjS+Mx+UjnYPikxA1hoFE
	 wYTKp+wU6NGwBBYd5MYdessKEOPnqLLshfVcU4jVw3uRAygaBhDMD2mJsIvkaW6cJM
	 J0kCTOUtIVMLpELrQH3XK5sHOvqo1CIsCkmQd2Tp1PzGKVkbnQJCreI9XZTi08MSAk
	 5mtX6GbhIXFfo58+Xt8vjkakQDr82ubjwZ8QN3cHfixLp81+Myy7VvobcrmtWZZIfD
	 jADYn+pwZ4LRTbITWUzMx7rrNYr8I4dEgj2r4CpE3P7jL1G0bIPh0JJ80YB55yyfHI
	 NBPoPOcOBwM3g==
Message-ID: <62be55ad-a52e-49b4-90ec-a1f6bcf04550@kernel.org>
Date: Wed, 11 Jun 2025 12:58:44 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dm: Check for forbidden splitting of emulated zone
 append operations
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20250611011340.92226-1-dlemoal@kernel.org>
 <20250611011340.92226-3-dlemoal@kernel.org> <aEj3-S0aJWU5iEVg@infradead.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <aEj3-S0aJWU5iEVg@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/25 12:28 PM, Christoph Hellwig wrote:
> On Wed, Jun 11, 2025 at 10:13:40AM +0900, Damien Le Moal wrote:
>> @@ -1322,6 +1323,7 @@ void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors)
>>  	BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
>>  	BUG_ON(op_is_zone_mgmt(bio_op(bio)));
>>  	BUG_ON(bio_op(bio) == REQ_OP_ZONE_APPEND);
>> +	BUG_ON(bio_flagged(bio, BIO_EMULATES_ZONE_APPEND));
>>  	BUG_ON(bio_sectors > *tio->len_ptr);
>>  	BUG_ON(n_sectors > bio_sectors);
> 
> Shouldn't all these be WARN_ON_ONCE and error return instead?

Yes, I would prefer that, but that would be a more involved cleanup.
I can switch to doing that instead of this simple check.


-- 
Damien Le Moal
Western Digital Research
