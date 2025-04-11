Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267A628D857
	for <dm-devel@lists.linux.dev>; Fri, 11 Apr 2025 08:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744360922; cv=none; b=btw0JFj3iQq7AwYwEPVIqYflNbrCcRUhOmgc82XPP9WeJldG9zIVTE6kNjVD7uGBfJDdFZ2Qq3I1pAIm0msyc+SLQtPlwQDLhcqcU+1zkOdJjnzkZVA2eg3jE+2xICm4XXL5gnKmgS2+a4SXCcopQZFv8umzjEku5r7dBciDQ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744360922; c=relaxed/simple;
	bh=N6msE6fWmT8+/+mO0RPCrvKlRrGhZiGVb5jPedVx7qI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tvb4+bHFDXtnjG7CHX1/msxxljYUqVMr0eG6zx3UEyl4IYdr9UZJGcga9fJIpi/y3je8J5IP+f441XWOVZY1cTQ3u8eQWkk8BblPXyNTbbe1pEYMqC/HSsfXJ3Slo7aIjSEAKImFdXrIiR02G5LPIC38UJ5Wk5Xr1kv1jQwWALY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S/nwmnTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S/nwmnTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0916C4CEE2;
	Fri, 11 Apr 2025 08:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744360921;
	bh=N6msE6fWmT8+/+mO0RPCrvKlRrGhZiGVb5jPedVx7qI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=S/nwmnTV1gbO+hr8+Bw+Rlg9E3k2e1vle8zSRMpv4QC+LSY9OtMaQoUhvma23Bk1q
	 3K25onhzp5ljUsdiLip7RgnH3B4rMJWZ85vN1rb6RjzyAAxnA1WPxDz5fcmZ5C9D5X
	 1lOHUs4dbPvCCL7zV3dX3+PxOkWlsbPZd751Cqikszyskn0YAgiEhpknXP0OMKvZtq
	 LPiwRZY1W0OtzHXvpmg8OARTUtmOf1h/RLtiiyNAjF5bCNvzOrNx2fkLyXF3x8C5Yh
	 e6LcFunEUxAPyCEZECEiHE0Iga2jaTIDtato41XZyS7AZMPxLBUgyv/Gu0Ts5cebnP
	 xTB1ibuuXFY3Q==
Message-ID: <80cfd413-1bee-4ed1-a49f-163a28d0b426@kernel.org>
Date: Fri, 11 Apr 2025 17:41:59 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] dm: fix issues with swapping dm tables
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>
References: <20250410194943.9326-1-bmarzins@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250410194943.9326-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/11/25 04:49, Benjamin Marzinski wrote:
> There were multiple places in dm's __bind() function where it could fail
> and not completely roll back, leaving the device using the the old
> table, but with device limits and resources from the new table.
> Additionally, unused mempools for request-based devices were not always
> freed immediately.
> 
> Also, there were a number of issues with switching zoned tables that
> emulate zone append (in other words, dm-crypt on top of zoned devices).
> dm_blk_report_zones() could be called while the device was initially
> setting up a zoned table and creating zoned resources or could possibly
> fail to end a srcu read section.  More importantly,
> blk_revalidate_disk_zones() would never get called when updating a zoned
> table. This could cause the dm device to see the wrong zone write
> offsets, not have a large enough zwplugs reserved in its mempool, or
> read invalid memory when checking the conventional zones bitmap.
> 
> Finally, any DM device created on top of a device emulating zone appeads
> will automatically have zone write plug resources created for it, since
> max_hw_zone_append_sectors will always be 0 for a device stacked on top
> of a device max_hw_zone_append_sectors = 0
> 
> This patchset fixes these issues. It deals with the problems around
> blk_revalidate_disk_zones() by only calling it for devices that have no
> zone write plug resources. This will always correctly update the zoned
> settings. If a device has zone write plug resources, calling
> blk_revalidate_disk_zones() will not correctly update them in many
> cases, so DM simply doesn't call it for devices with zone write plug
> resources. Instead of allowing people to load tables that can break the
> device, like currently happens, DM disallosw any table reloads that
> change the zoned setting for devices that already have zone write plug
> resources. Finally, it deals with the max_hw_zone_append_sectors issue
> by making sure that it is non-zero for zoned DM devices that do not need
> zone write append emulation.
> 
> Changes in V4:
> - Fixed typos in 2 commit messages (patches 4 and 5)
> - rephrased comment in dm_revalidate_zones() (patch 5)

I gave this a quick spin and did not detect any issues.
So feel free to add:

Tested-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
