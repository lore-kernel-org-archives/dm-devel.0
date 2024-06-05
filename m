Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A02513A400;
	Wed,  5 Jun 2024 06:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717570511; cv=none; b=ZA2CpYDNiPa29xoDGEGIdAW9DFBYsUXjk9jDzpuPakDpV0On7+eGa+q/wBGW2JdGSkTWzL236Px2TjiE4FD3VRCHAa56GzujOfS+ptUNua3asrsHrt9Oj6NF3pAZm/BZHxlhL8hsaly/YQ7bo0+ZW0VrOVzQjQcixoXiduL56iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717570511; c=relaxed/simple;
	bh=iXleuDabFNHa+VZiUPMAAZkflOGRUl09HmGi1BdroOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vCO565R4BGvkrafKQWXbXcFN/GjBKSJXlwkS1Twf7PNK7RIUQVAyCM3uN4IVl2tK8o33Xy9hPPzGkRmL+UEezIrimuRxU1/uNWplCfOXgyZmw4UnFI85YfFSJKLYbEo5xgh4802cF8N0Z4a5RTQwCjJM8rcFvBS3f32bmBHFzEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZxOu5Bgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZxOu5Bgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C122BC3277B;
	Wed,  5 Jun 2024 06:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717570509;
	bh=iXleuDabFNHa+VZiUPMAAZkflOGRUl09HmGi1BdroOs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZxOu5Bgzf7qMtU0I1xl5k1x96E22vfZyr1IFukzAi19OQQu69kNv0axdT3Bq1Jwbt
	 e2JZ3Pz3iLZ2xYfK8CHUNyEw9L3r9ZC929R7Tz7Oon0q3Bmtu2yfKlo+CYsBIlmBzz
	 jkpv0pIVGtuxRZeBToYw6+EEx0Bm7U+LAqTWzmnTj8WU69qB4YkLks9FNVEW6sBE+B
	 Bhx18HrvIm9JR1/rHwLYCEjZr2m+C7DZUAr8y/7rpKTHjhN26S/D0d7SKU/w1gn2aS
	 oZNGP95RLcRInmbR29qmYofawGPE6XZu5JnBlg9s3aVDPAH5DKadnNpRZVaPIYZYES
	 HuqYtmV2NE9tQ==
Message-ID: <7a542065-e8b2-49fa-8d5d-fe37766ff1ed@kernel.org>
Date: Wed, 5 Jun 2024 15:55:07 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] dm: Improve zone resource limits handling
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20240605063907.129120-1-dlemoal@kernel.org>
 <20240605063907.129120-3-dlemoal@kernel.org> <20240605064910.GB14642@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240605064910.GB14642@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/24 15:49, Christoph Hellwig wrote:
>> +	/*
>> +	 * If the limits are larger than the number of mapped sequential zones,
>> +	 * assume no limits. Note that blk_revalidate_disk_zones() also executes
>> +	 * this adjustment, but only for mapped devices that use zone write
>> +	 * plugging, that is, for mapped devices needing zone append emulation.
>> +	 * So for DM devices using native zone append of the target devices, we
>> +	 * need to adjust the zone resource limits here.
>> +	 */
>> +	if (lim->max_active_zones > zlim.mapped_nr_seq_zones)
>> +		lim->max_active_zones = 0;
>> +	if (lim->max_open_zones > zlim.mapped_nr_seq_zones)
>> +		lim->max_open_zones = 0;
> 
> Is there any good reason to not just do this unconditionally in common
> code?

I can. I need to tweak the early return for the case where the DM device does
not use zone write plugging. Let me do that.

-- 
Damien Le Moal
Western Digital Research

