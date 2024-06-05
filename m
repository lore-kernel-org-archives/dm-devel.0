Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81898139D0A;
	Wed,  5 Jun 2024 04:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717563309; cv=none; b=cwPmcFqBmBf4MUB59hCxN0nOFH8LESgHPZIOLWXleajWHBKKpuesJVqTrxSrvavc3HuuYWDs7JbQHWhT7YRitqoZcSKZYBFeAzVgVLHzDxMmb0zPdk2dCXkdq9rw+9xKdTiTOPBSVyfv/Zt5INwo/Z3VlP1chhHkU4gyKREGYDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717563309; c=relaxed/simple;
	bh=bPxpSSVKfmFUoDuHuSRNB7QwXJdMRKEq4TJ8UU1ggYw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rPCadpu8NnPhVaoF88yY+qfhCKh07ZOD7UR2oVfzXc+5nPahXqDj/mWN2jte+GwMXn0J85MWc1v1coOxOmoXgplI/EEVr1OxvhhHG+8gg7cq7Xc5N6ic5YYI6ZSWaf65Z+B5Nq4fjl/nGfuegeqwQrIqHi11PS9KHm9ijpWd5kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qme6MEGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qme6MEGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2D0C32781;
	Wed,  5 Jun 2024 04:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717563309;
	bh=bPxpSSVKfmFUoDuHuSRNB7QwXJdMRKEq4TJ8UU1ggYw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qme6MEGW0ztIsLPWL3fAfJYIc1VztBEXRjhAYgFbEHQZhAACgXhbt0pin8jYhUF+n
	 tmZfM1EHDQlcsizTzJzpCcEfQreu/LIpt8MwL/AZC4c/IpzgiJfztsuBiYYHD6k883
	 7Zylh+upgtBQRN5sA51EYUsz/F+bHPmk9z28w4bI81wZJZcB016DXA2JZo8mkZRbTP
	 idZIwsx22w58Yw2y3SkRMKqZRZzE/sPfzYQZnA/cdmKCWeCKF2oWKnMzRFFyx8GS0j
	 gHJhNeHj9Sdotr/FVcoFS9HP4znZsde/lpsPBYKPkVLUb5RiaLZRs4mFC5ZZt4ONVk
	 usezzDcWz3aYw==
Message-ID: <83d7a9a9-c7a9-44bf-98cb-1c7be8e7fbe8@kernel.org>
Date: Wed, 5 Jun 2024 13:55:07 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] dm: Improve zone resource limits handling
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20240605022445.105747-1-dlemoal@kernel.org>
 <20240605022445.105747-3-dlemoal@kernel.org> <20240605042311.GB12183@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240605042311.GB12183@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/24 13:23, Christoph Hellwig wrote:
> On Wed, Jun 05, 2024 at 11:24:45AM +0900, Damien Le Moal wrote:
>> The generic stacking of limits implemented in the block layer cannot
>> correctly handle stacking of zone resource limits (max open zones and
>> max active zones)
> 
> ... for DM.  All other limits stacking ends up in a single top device.

I know. And I do not see your point here.

> 
>> +	/*
>> +	 * If the target does not map all sequential zones, the limits
>> +	 * will not be reliable.
>> +	 */
>> +	if (zc.target_nr_seq_zones < zc.total_nr_seq_zones)
>> +		zlim->reliable_limits = false;
>> +
>> +	/*
>> +	 * If the target maps less sequential zones than the limit values, then
>> +	 * we do not have limits for this target.
>> +	 */
>> +	max_active_zones = disk->queue->limits.max_active_zones;
>> +	if (max_active_zones >= zc.target_nr_seq_zones)
>> +		max_active_zones = 0;
>> +	zlim->max_active_zones =
>> +		min_not_zero(max_active_zones, zlim->max_active_zones);
>> +
>> +	max_open_zones = disk->queue->limits.max_open_zones;
>> +	if (max_open_zones >= zc.target_nr_seq_zones)
>> +		max_open_zones = 0;
>> +	zlim->max_open_zones =
>> +		min_not_zero(max_open_zones, zlim->max_open_zones);
> 
> Given that your previous patch already caps max_open/active_zones to the
> number of sequential zones, duplicating this here should not be needed.

Indeed. Will remove this.

> 
>> +	/* We cannot have more open zones than active zones. */
>> +	zlim->max_open_zones =
>> +			min(zlim->max_open_zones, zlim->max_active_zones);
> 
> Same question about the capping as in patch 1, and same comment about
> the duplication as above.

Yes, we can remove this one too.

> 
>> +	if (zlim.max_open_zones >= zlim.mapped_nr_seq_zones)
>> +		lim->max_open_zones = 0;
>> +	else
>> +		lim->max_open_zones = zlim.max_open_zones;
>> +
>> +	if (zlim.max_active_zones >= zlim.mapped_nr_seq_zones)
>> +		lim->max_active_zones = 0;
>> +	else
>> +		lim->max_active_zones = zlim.max_active_zones;
> 
> And once more here.

Yep.

> 
> 

-- 
Damien Le Moal
Western Digital Research

