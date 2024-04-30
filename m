Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358DD1C0DF2;
	Tue, 30 Apr 2024 23:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714521253; cv=none; b=IQGYJtFOQ075m4TJfsQLO86+MzXkhiMVJLEfwjMKZEwY29ccGiZ+/aF9UfsWFK91PApP3a5jFTt5272WMmQWIubmI+YWs34j39obyInMi9WEcNsiO8Jt+tVEdTcVcCcXKMlo9F36Nhbxy6pzVcQvh6NJof+POM6s2UQa9Y7EaYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714521253; c=relaxed/simple;
	bh=16TKyee9xwfwynR6ebfGiZnEQ4JTQhjjnPkcYzMGjIY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=l8KBRhi+BSr1wgFOLf+fz7AL5zpxo1PzxMUu1UgMVrlrkt8tDK8boV4XNeP4Fe7ByOvoe565Lhp2Q1AtPUa0sByPo1vunznI/CWvgMpABU6tBVGg3+0IcQJLe5YvbgzsAYIzcjWTWGL5vtvclUA0HoSEZdlNj1BF75iKtepf3sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4L3vpKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4L3vpKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF98CC2BBFC;
	Tue, 30 Apr 2024 23:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714521252;
	bh=16TKyee9xwfwynR6ebfGiZnEQ4JTQhjjnPkcYzMGjIY=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=J4L3vpKzfDbnGvjyGwPx4o+3jpRelBE4WA5BjBj5RfOY04334GZmTlkfmymRgkNPl
	 tp+UzmVW/E0crMGmNpnVEVxKPvqX3YpC0s3+32S5xuq+SxYlEtEmdBUeGRbdqEreJI
	 sfbfGu5lqx6yi7r+oPskU1cKxWU4uEbemRnkMlMC9sxIq5t0uirnWF0VMiwxxR5G6S
	 +qwGmlhR1ZgAgd6uPDzyy2POo31rIpOS5jmPNrB3gqD1iXzJ9Gpm/O5NX+mlRTnZUD
	 btfRS1ObNSITYVpl6Jk2Up8moLtK9UwLRQkfZoISB1AiQ8bTOYgU/Es+gDVaW5HDCk
	 C/WI6e/hIBjJg==
Message-ID: <a15959d6-fbf1-4819-9fcc-45b48975da48@kernel.org>
Date: Wed, 1 May 2024 08:54:10 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] block: Fix zone write plug initialization from
 blk_revalidate_zone_cb()
From: Damien Le Moal <dlemoal@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-4-dlemoal@kernel.org> <ZjENmQ6d0tayg_YR@infradead.org>
 <c3df1441-94a1-4b7b-b9ed-733d1a1a0639@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <c3df1441-94a1-4b7b-b9ed-733d1a1a0639@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/1/24 07:50, Damien Le Moal wrote:
> On 5/1/24 00:26, Christoph Hellwig wrote:
>> Looks good:
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>
>> Although I suspect that at some point blk_revalidate_zone_cb should
>> grow separate helpers for the conventional and sequential required cases
>> as the amount of code in that switch statement is getting a bit out of
>> bounds..
> 
> Yep, will clean that up later (next cycle).

I did it now. It is a nice cleanup. I added a patch to the series for that.

-- 
Damien Le Moal
Western Digital Research

