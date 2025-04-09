Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C79B5464E
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 06:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744179756; cv=none; b=R9h+M2Z6yiyBADz1qmpZVkPO6SSBcERDebonMkr0Jdoxw7oFR3OGyZKR/0sw1TvHgvem5mibS7ZLTrOKKNxfL9415dMzW25EEEg2j2iQHKxZx/x1eJPrxv9WrbsU/xrnJd9bMxwFfi1Dbu3kgzQFiM5dtR/KWjZK0BadVkyypEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744179756; c=relaxed/simple;
	bh=VVw+TbmjUIziPRoSEIOb/ko+d1K/vpuQQhM9YZ1gWbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mf7aFdKVnCEFkNyG02TOTN8FqjMnWjHj5Gtaw+jFpKV8p8gdD5dkfgnaK9Lb9u9E21U2i7p3XLMMyTJZYH2nrbVNolmvsz/dHNnXsCpxY18VF5Wmr0g3v/gZl6ZKcUXBxSWwRD/ZTIZKlC0HXL+PCzz9vjvMS6mPkjcWr5mUcXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qFb2ohIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qFb2ohIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF975C4CEE3;
	Wed,  9 Apr 2025 06:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744179755;
	bh=VVw+TbmjUIziPRoSEIOb/ko+d1K/vpuQQhM9YZ1gWbI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qFb2ohIGIENO2R3YCpLswu1jQInNq6p0CZ2h2rd3ua4Opkqya5yZ28P3vzYd8g4Eu
	 A1pPxlubJPYTvAq4kKAcAI4a5zFjKzMwySadPTkqnesQ/Yi/BNQ7v192wc3CfJghi7
	 2yQc0P6pOJQwc3nhQ3gt5C9CKorvtIsHin1wlRoF29EkaEmd+L3ps2cZuL7SqkLSK4
	 2haYTq+odV4dXiYXOChNQksZdcD2hSaNt82Q+c7Vnj06F8VRKUhKhVYEO+TQZIliYK
	 JrYQAnIigm2QKWj5+r05UeXKvL2xZTVF9gJA5r0f4npH7ZXzotezNd6oqXPSRFnpTs
	 s9vPHIAEENR7Q==
Message-ID: <91f9d04e-34c9-4a77-b781-97d74ba07c55@kernel.org>
Date: Wed, 9 Apr 2025 15:21:53 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] dm: fix native zone append devices on top of
 emulated ones
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>
References: <20250408235159.4128838-1-bmarzins@redhat.com>
 <20250408235159.4128838-7-bmarzins@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250408235159.4128838-7-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/9/25 8:51 AM, Benjamin Marzinski wrote:
> If a DM device that can pass down zone append commands is stacked on top
> of a device that emulates zone append commands, it will allocate zone
> append emulation resources, even though it doesn't use them. This is
> because the underlying device will have max_hw_zone_append_sectors set
> to 0 to request zone append emulation. When the DM device is stacked on
> top of it, it will inherit that max_hw_zone_append_sectors limit,
> despite being able to pass down zone append bios. Solve this by making
> sure max_hw_zone_append_sectors is non-zero for DM devices that do not
> need zone append emulation.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
