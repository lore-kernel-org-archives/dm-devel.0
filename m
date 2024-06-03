Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF7264F;
	Mon,  3 Jun 2024 00:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717375442; cv=none; b=pgv1cZfjhVt3MwCvsO1ejkCqvJsTzeSuAv8iCZkAAR6sz1Afx5UdXJpCk0OLe6qI/gBinmVQxPxDfFrj/Cq+nIQb0itfV4xFi9/GpBZ5lq/lQWkm+nBpiIXhJyddudgpk+HU0j0lFbNnHvLNv88djNfZZRTztmPPhi2yJeFqkfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717375442; c=relaxed/simple;
	bh=zy2YPPVNzlgkVZ66NO91bSuuTW04wziYPdap5/nroWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EeifQwu8ZIPkkMAiZBxDHs7FYPkCsnstBA9ql1x0Wy3pruiuxYSQqB5GHyKuKv/1kyO9L+/JrRWXDeRbIhXk8sEWsyEfJO3LECfZD4AyvtIVdaFf/qpGqH8fEcK6eNuU8GbMPw75lRYr/2OOY/tWvKX2DRmawG/4nLduOFw3uBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mqV8fwqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mqV8fwqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37633C32789;
	Mon,  3 Jun 2024 00:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717375442;
	bh=zy2YPPVNzlgkVZ66NO91bSuuTW04wziYPdap5/nroWI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mqV8fwqJBJcqHxGaXz+E3pErnKk4Gw/2tsZXv31+UoM0is/nEgDaFVUY1sg4nMgXG
	 64QooCfvl2F/iXIn44S9IgsSLpvzX9OWgLZzeqbg+mKB5ZRr5NvcYWjh+kjY/UTVI4
	 VZLs2P3wUkv/5TU4igbMnsKsJtXHPfFoYzohQyWWtgitg4GUQwSptwLOrD+yaVst9T
	 oWgQkUAVFf/SytB+kHsG+iNfABH9WG+F2GMMvcklJIflDyDg7AAazanpFeTjPy4Ia2
	 LVNzbTRLx4nmJUhfVHwllx5wy/qXrDayEhY/7UMXathpqg7YZBDNz7Km/sQe7iJjQ2
	 6k/rvaKaPpyIA==
Message-ID: <7d9f257a-48af-4978-b8f1-46b88eda9af8@kernel.org>
Date: Mon, 3 Jun 2024 09:44:00 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] dm: Improve zone resource limits handling
To: Christoph Hellwig <hch@infradead.org>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-5-dlemoal@kernel.org> <ZlokTjm-l-7NWyhV@redhat.com>
 <ZlqxqZqixQ_POHvc@infradead.org> <ZlqymFGC8Wy4Hp7v@infradead.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <ZlqymFGC8Wy4Hp7v@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/1/24 14:33, Christoph Hellwig wrote:
> On Fri, May 31, 2024 at 10:29:13PM -0700, Christoph Hellwig wrote:
>> On Fri, May 31, 2024 at 03:26:06PM -0400, Benjamin Marzinski wrote:
>>> Does this mean that if a dm device was made up of two linear targets,
>>> one of which mapped an entire zoned device, and one of which mapped a
>>> single zone of another zoned device, the max active zone limit of the
>>> entire dm device would be 1? That seems wrong.
>>
>> In this particular case it is a bit supoptimal as the limit could be
>> 2, but as soon as you add more than a single zone of the second
>> device anything more would be wrong.
> 
> Actually even for this case it's the only valid one, sorry.

Not really. I think that Benjamin has a very valid point here.
Image target 1 mapping an entire SMR HDD with MOZ1=128 max open limit and target
2 being one zone of another drive with MOZ2=whatever max open zones limit.
For such mapped device, the user can simultaneously write at most 128 zones and
these zones can be:
1) all in target 1 -> then the mapped device max open zone limit of 1 is silly.
128 would work just fine.
2) 127 zones in target 1 and the 1 zone of target 2: then again the mapped
device max open zone limit of 1 is overkill and 128 limit is still OK.

Now if MOZ2 is say 16 and we map more than 16 zones from target 2, THEN we need
to cap the mapped device max open zone limit to 16 as we can potentially have
the user trying to simultaneously write more than 16 zones belonging to target 2.

So the cap on the number of zones of the target I have is not correct. What I
need to not blindly do a min_not_zero() of the limits and look at the number of
zones being mapped. That is, something like:

	if (target_nr_zones > target_moz)
		moz = target_moz;
	else
		moz = 0;
	mapped_dev_moz = min_not_zero(mapped_dev_moz, moz);

And same for max active limit. And we still need a cap of the limits on the
number of zones mapped at the end, when setting the mapped device limits.

Let me cook a V2 of this patch, with *lots* of comments to clarify this.

Note: I am also writing some blktests cases to test all this. I will add more
setups with challenges like this to ensure that the right limits are set.

-- 
Damien Le Moal
Western Digital Research

