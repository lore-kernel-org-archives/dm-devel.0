Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81ACB23AD;
	Wed, 25 Jun 2025 06:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750832216; cv=none; b=UauZcDXuwMTssFGI3RRkfMoZ4RQGt5j5kSS6Iqm1gggpit7LYSQse9bIgn2xQyC7axmqvJZjh+5Xu5QDqGrJD8xIBAYoZWcceTbJ31FY5qK5zPLgPEeX12kctIJpU+eGt1Vk7eDNkP3E1TFN0fgJzEoGGuOqCzqpcKHOnkxY5oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750832216; c=relaxed/simple;
	bh=+pfjAdG6ySqdoLNCepBHlTtdox4YwE9jFZJZXYaBdX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uew1V+zYVKGzApOcGlVKLfAajMS40haSsX2tXLh1gASCefJypS1PyZVXM/S/jL9F5y7rNINnoOifANwDPYvS0VSE6uMxRvBtJ6eNHfy0hjeTh558IwCTuufFRo/aCYpOWQpRqyal6g97BMfChCCx5w9Jjmtk+q3Ep7BJLPneSVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HSdMd24D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HSdMd24D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19ECDC4CEEA;
	Wed, 25 Jun 2025 06:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750832216;
	bh=+pfjAdG6ySqdoLNCepBHlTtdox4YwE9jFZJZXYaBdX8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HSdMd24DmdubH1wmo3e9NLXSdWZCUfEYadTSCHJgnJ9KNakzb4nVlY3xCpmvnoMVE
	 S2kpFWk8toez+RXzQz8K+k3tp73HQfgIBeBaaV/gYGSGAzXmfCdJRBJrdcWDsbv4P4
	 3pk3neUqENF6/t3XoFMkd3h9/F7DGBjdhP3hN1qZXOCQlzGtQVMFdS9Vnz5qDsnj9M
	 dboONweuHRiZ7PRbXtXl6Fe8LeUqp3+2OK7jUvscrdDzwxEszQKjIpGoOFjFEljntd
	 6nygj5yrvHrIOReo6bZMmh9ZQj+NmTFrwn0mgT47L+3yWSdfHdKvOhmtrYPr9KNBo1
	 KSVs/7RiD1mCQ==
Message-ID: <576bb6dd-18b1-4c78-b848-51577d99b124@kernel.org>
Date: Wed, 25 Jun 2025 15:14:51 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] block: Introduce bio_needs_zone_write_plugging()
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Bart Van Assche <bvanassche@acm.org>
References: <20250625055908.456235-1-dlemoal@kernel.org>
 <20250625055908.456235-2-dlemoal@kernel.org> <aFuTYxdeAzG1iSl9@infradead.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <aFuTYxdeAzG1iSl9@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/25 3:12 PM, Christoph Hellwig wrote:
> On Wed, Jun 25, 2025 at 02:59:05PM +0900, Damien Le Moal wrote:
>> +bool bio_needs_zone_write_plugging(struct bio *bio)
> 
> Can you use this in blk_zone_plug_bio instead of duplicating the logic?

I thought about doing that, but we would still need to again do the switch/case
on the bio op. But the checks before that could go into a common static helper.

> I also wonder if we should only it it, as despite looking quite complex

This does not parse...

> it should compile down to just a few instructions and is used in the
> I/O fast path.
> 
> 


-- 
Damien Le Moal
Western Digital Research
