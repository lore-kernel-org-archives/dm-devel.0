Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ACF193409;
	Fri,  6 Dec 2024 03:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457328; cv=none; b=LGqQ2JK6GG2/PdRrphl8cqUsbeY+F6RDfTq0cDlt1F9a3ZCN03EiUhgT9z4kAXW5FLweuHT8Wl9WxMH9i+X95vj2mVilcVSZnqiaPbgjujtS/dIpAH22Uf8fMapnOKug1z5AbovlaPPwdrtjewywM+YC/kS5R1KGB6JjmPTNUEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457328; c=relaxed/simple;
	bh=5diGRU2W7cSelvGSJZrcPBFdoo/g9HLXkcLr1UJqdTI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=sMwXIYDmafNxcwV830I4ABPiVhHMxBKhGHOojCGoRq+QUvEXES3ttiJkClHSVeMxMuunWWmHx7ElgIoSXMaU4mCH0RqffbIZSIeXUlr+fswwv97nbuEWwekDvZ5Xu1/PM9i+knsB0+ZoYQUggYpKMJakTb/VPkA/f5sC93U+Lds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQtq2tAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQtq2tAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F5AC4CED2;
	Fri,  6 Dec 2024 03:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733457327;
	bh=5diGRU2W7cSelvGSJZrcPBFdoo/g9HLXkcLr1UJqdTI=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=XQtq2tAl45xWdiL05TahULN955UlEqqAq5ubYRFH7Yq+tJXSbaWcrGwlPiDgJeVvX
	 u51uFKF7NvKthRyjp0PQ1EK4Sr6SbSH75RzOXjrYm8wviEbqs/3b38FOpU3LvT24jy
	 8t/QNfGDoMT6NLApzDBF9Ma+s8wjZ7qUmuDIsd+VnxlxCP7eS4MtKQS6hyA7xJoXH8
	 MlTBq9lStSbC13MKxHZKLn/h9hFV3sNpxB1zt69kcfidEZ7TIOMIO26ZqCSHBKM3k2
	 V7aimArG0HkUmSTx7//SQM5DuJG0hwVB57XVvv6LDbNlFdH5MyB40hEAs8Dki3m45G
	 2RMKwS+1/1arw==
Message-ID: <2e94a099-51fd-4eb6-a463-53cebbc71413@kernel.org>
Date: Fri, 6 Dec 2024 12:55:25 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Zone write plugging fixes
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 dm-devel@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
References: <20241206015240.6862-1-dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241206015240.6862-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/6/24 10:52, Damien Le Moal wrote:
> Jens,
> 
> These patches address potential issues with zone write plugging.
> The first 2 patches fix handling of REQ_NOWAIT BIOs as these can be
> "failed" after going through the zone write plugging and changing the
> target zone plug zone write pointer offset.
> 
> Patch 3 is a bigger fix and address a potential deadlock issue due to
> the zone write plugging internally issuing zone report operations to
> recover from write errors. This zone report operation is removed by this
> patch and replaced with an automatic recovery when the BIO issuer
> execute a zone report. This change in behavior results in a problem with
> REQ_OP_WRITE_ZEROES handling and failures in the dm-zoned device mapper.
> That is fixed in patch 4.

I forgot to mention that I will followup these fixes with a cleanup of the
report zones API and its callback function interface to clean it up as patch 4
introduces an indirect user callback call that is not very pretty.

> 
> Damien Le Moal (4):
>   block: Use a zone write plug BIO work for REQ_NOWAIT BIOs
>   block: Ignore REQ_NOWAIT for zone reset and zone finish operations
>   block: Prevent potential deadlocks in zone write plug error recovery
>   dm: Fix dm-zoned-reclaim zone write pointer alignment
> 
>  block/blk-zoned.c             | 507 +++++++++++++++-------------------
>  drivers/md/dm-zoned-reclaim.c |   4 +-
>  include/linux/blkdev.h        |   5 +-
>  3 files changed, 229 insertions(+), 287 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research
