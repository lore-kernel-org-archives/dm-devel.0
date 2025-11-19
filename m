Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E4B224D6;
	Wed, 19 Nov 2025 03:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763522332; cv=none; b=G2SXxrUK1evOXJbHImLgKoqUiKgGPO7jZrztVo602S+KeOKDXhQ9HayRuQeoblanGLXfcf1vKhYjAu08++H1LBbLTMIcpOKCbyY4nja8FvRsYbUettahlyQvqEdk3JgzBskwEH9uBhRw+yQIhACW1F0ZGDSAlAkSLHXkhQEChr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763522332; c=relaxed/simple;
	bh=E3DF++tFrql/hNnPhJQeHVmGnq+1kdEbHXsivsl7HyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ioIqIXVs8tLJCSR2hlpI58RWD+M4uu8fN5OCNqQrDeZ5d6eCwfMbZDQ52GBigE9O/9TTHpT2IW4oUFudyW8xzWfvfdizjltkzLTUpZZtK6aV+vKWCWAsrj5R1HaPwcWEr5mgYXOpeDvlKeFMHw2euFT8ApWMTeAXaEBXPCgGrWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tIoI6+l2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIoI6+l2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B529C4AF0F;
	Wed, 19 Nov 2025 03:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763522331;
	bh=E3DF++tFrql/hNnPhJQeHVmGnq+1kdEbHXsivsl7HyQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tIoI6+l2b2ijo3g1jSSKKQW/ODTp/9Jgvj0M04jLLZldVjZPK9jjYzYR2sWTOHkAZ
	 OfOfRRsHAverJIB2+v3PHuE1Bg2OUCVUpx5dua4cJ1V5nQ/QYfdY8OzzbjNe9nWPGk
	 xVskLRF0+B39JivbJ9p2z0fm9IjDOelW7Njs/4m5sgXoDltKmqOO2eHlWdmvwkWK4F
	 g/nf5ZYT+mw8cOYnDMlpwtCFD0HzfM17G/tsUst8BUk/IXZLAxJ9XfVrQaXFU834/e
	 duiLmbcejdKoOYKBkwmx/kgmip/PLBzKQtnifnOraJ7cHz/jOZWy/q435kMORkgiKr
	 1Zr79mz6lqwRg==
Message-ID: <479228a9-c30b-4c7e-9129-ebf12ab2ec04@kernel.org>
Date: Wed, 19 Nov 2025 12:18:46 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] dm-kcopyd: use REQ_ZWPLUG_UNORDERED
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev
References: <20251118070321.2367097-1-hch@lst.de>
 <20251118070321.2367097-4-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251118070321.2367097-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/25 16:03, Christoph Hellwig wrote:
> Use the new REQ_ZWPLUG_UNORDERED bio flag so that even copies to
> sequential write required zones can queue up writes bios as soon as the
> reads finish.  This simplifies the code and reduces the submission
> latency as all writes are immediately available in the zoned write plug
> list when the previous write completes instead of going through two
> layers of queueing.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup !

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
