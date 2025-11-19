Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635AB20013A;
	Wed, 19 Nov 2025 03:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763521763; cv=none; b=Vi6JteFg3T8jvpyg6ibREkD75nS56sMEQK6bgj+XrNyxS7AhSqxXFZ8HIOILL+P8pfBerqCJ0RHQDCZbFV0nGdF4JAFn9q9UnuWxDZJ8bsNXdRDjHIqjvUMfYdbxWEaUw7h10ZVBHsBHD43fqZwLGqSp+BoXZLaJAnsIbWwYYo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763521763; c=relaxed/simple;
	bh=IY1ZSGuNVG8n3akLPyxT/m6RozNuxx45nMvrXGrtQPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gQsGuhxn7EYWYpQ4cxtSjqAeYny/ywNJdKo/H1Ek8Ww6sRONRw+gH7HvRlA0C91XkV0XdoBEze72D8z3yMym+QdrXfgejEfIZhBkN9SVdHu2FrFQMVdgRvLkHm/dgLs2i6BhifS9lyyIUoDTXp71O/8qiQAtE+vJsS6VLrBPjIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ip0wh9H+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ip0wh9H+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08B4C4AF0F;
	Wed, 19 Nov 2025 03:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763521762;
	bh=IY1ZSGuNVG8n3akLPyxT/m6RozNuxx45nMvrXGrtQPw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ip0wh9H+yC7Q2BkyXn5mdBy6UTTCZZofqyquBVMQctO1/kDVqhaoxGTcXakgi9k2C
	 FPlwFuSHx2hnPRG27iLaTks21NFpQxvL4twVy0x7TceHRxYZN/ArNuN97WvQAVO5o4
	 3UQSSND3sB3Ux6KwZZHAzAN1MuXA0xK2drz0XyH0TXZXZOw4kFg8PhCFounEASO533
	 zHYICf/yOkW0gWDshyI1OkHW/OiHtnSMAjn1OX0OhGe9uXicugmBdIP5kIh7YtGZDX
	 xduKP4ELxoiZTQUC0HdH5GtuHp3yU+4hvM0/ExCX+RnfFIDcuyHgqle98krXccbrSh
	 vpnfUk2/xcq7w==
Message-ID: <66d29741-13a6-42a5-bf34-ddbcb32975d0@kernel.org>
Date: Wed, 19 Nov 2025 12:09:19 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] block: add a bio_list_add_sorted helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev
References: <20251118070321.2367097-1-hch@lst.de>
 <20251118070321.2367097-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251118070321.2367097-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/25 16:03, Christoph Hellwig wrote:
> Add a helper to insert a bio into a bio_list so that the list remains
> sorted by bi_sector.
> 
> While it is on the upper hand of the size for an inline function, it is a
> trade off for having it with the common helpers, but not bloating the
> kernel unless the so far only user is enabled.  If it gets more widely
> used moving it out of line should be considered.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
