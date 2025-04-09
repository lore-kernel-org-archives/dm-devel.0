Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D673FFD
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 05:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744178283; cv=none; b=YezcpKxA+qpesarbc5iPN/M9p2mxRV9LisRskzfobXpUCz8TiGr9Ce9pZ/+h3o14qdZoFEBXflBQtyGbGOskgg4ZN9x3uMv2JrRmwFDw+bmmV3NgqsD+jljLpA3FZNyujIESoJarE5dfKGq9jCFoR6b6/81u55+0SMD3+lpxdE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744178283; c=relaxed/simple;
	bh=DXqCtHLelD7HtQaGDA4XiIjsBfjqB4GeS9/qJpCumpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=esx+ui583sMihrZ6ulaa1+qb1kUI2oRJLIHlLMfBqAnB5xenWas1Hl3w+uLb3xqo6Dji7+YYCrfVO3/H4aqj4EeNsKBptlp6aPNWrpsqTe44fvPAmLhf3ryg0aNQ+zQVArrjDZFPEHP27WoeTzJ9l2h+iXgkMrVpDKRdY3ts+ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OVYg3YBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OVYg3YBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084C6C4CEE3;
	Wed,  9 Apr 2025 05:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744178283;
	bh=DXqCtHLelD7HtQaGDA4XiIjsBfjqB4GeS9/qJpCumpc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OVYg3YBLGNHmcBRHkzGZVSPrg7de5XuJQ1l8vmtV25WZ34/kVmg/5p7LdaDMDebpW
	 aJmhS6tsnY9f/BpaV7vOUonOstzHd1WfDszkDxpPVuM6m4TeTn8A/9rqlGdvF0X+13
	 2RjSQnLZe0IuUIY9oyFfu3mBN9RQLNiOqUCKXrtEJclXBy1IR+zbtnjnH8V2UljckY
	 UAZfU4n/K3WHrASV3QWGW5Bv+1UHd/WoBPP0LRYrJQqHrP+SiMe4dUTHCAKs+5T3KZ
	 qUNVXSt5D6Q0Md7MXv5Y0+UJ0kyGMVBGZftbdSUvi9SMOi/3CXaKLtmntUDmBkDgCc
	 Sh2ybQoV9pSew==
Message-ID: <80aac95b-d7e6-4d97-bb43-5894c8b4f940@kernel.org>
Date: Wed, 9 Apr 2025 14:57:20 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] dm: handle failures in dm_table_set_restrictions
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>
References: <20250408235159.4128838-1-bmarzins@redhat.com>
 <20250408235159.4128838-4-bmarzins@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250408235159.4128838-4-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/9/25 8:51 AM, Benjamin Marzinski wrote:
> If dm_table_set_restrictions() fails while swapping tables,
> device-mapper will continue using the previous table. It must be sure to
> leave the mapped_device in it's previous state on failure.  Otherwise
> device-mapper could end up using the old table with settings from the
> unused table.
> 
> Do not update the mapped device in dm_set_zones_restrictions(). Wait
> till after dm_table_set_restrictions() is sure to succeed to update the
> md zoned settings. Do the same with the dax settings, and if
> dm_revalidate_zones() fails, restore the original queue limits.
> 
> Fixes: 7f91ccd8a608d ("dm: Call dm_revalidate_zones() after setting the queue limits")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Looks all good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
