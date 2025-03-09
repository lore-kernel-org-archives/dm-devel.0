Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A5A21B185;
	Sun,  9 Mar 2025 23:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741562844; cv=none; b=GhzZYkdG//SrgJHGHf67xq1ImBjdG/Nii6hB1jHI744jwWLvEisFPKDv2Da+VKJGFNwQGvwAIIFH1dmX/4pIkpD4NCBHelEIjjRXxs4AoELpnq8KiMSF8gE/Vpsre6MfIcZ3OQLH9r3N+xbtVOoSZ0V0vg8LWvnIPk4Xpa8sW18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741562844; c=relaxed/simple;
	bh=cFacDOoKaxXYgUaaKYf35dSKgEzT5DIRzeKhsxzzfjE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rfK3P8rW0mFjZAewXikWntA7cA83IuV2ni2rfoubBFD2FZPeYcJFhSP/9VAou5ta3bYD82H/3Qm4YBWQIU3TZr2bksFo3wQRtUcKg9m/pGZCYJMTE/Ms/UCylOV2kCJYtezMR7TmhYGWxQh5975sQZ6W9IMJKTNgTsTIt6qNMns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cRKz9sOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cRKz9sOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DE8C4CEE3;
	Sun,  9 Mar 2025 23:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741562844;
	bh=cFacDOoKaxXYgUaaKYf35dSKgEzT5DIRzeKhsxzzfjE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cRKz9sOWbsRt8xwj8sSqhKAHY93snR2rif2ckA6y4uofzOJAQLp/Pgemm4gsQGrYb
	 mNhAPOy8tHHqhxZc2ueagWN6qa4YW8zcRxT2SAzjC8UdjVeP4SG6WXy6jAzsLYhvSu
	 7d2xKCGB23142aq9cMkQT4nyRrKh9+frn0+wwkkmcWHw/a1HFjPePhrj+GPXwfX+VA
	 2ZRn1I6eupqrUSw28y5hEpfw0XySvnWsVOjZ/lLbgC1Bw0La5oWqi4NQizPBnkhkTB
	 i32ssiCuor/8gkXJzf5EMWmq+yuMDCOG1T5q5BHcb8GlBHpdvs+6pgg0qiavn0bCGh
	 kQuPYYcAUgGPg==
Message-ID: <bebc9f33-a1e2-4824-9f30-e0c90ea2a740@kernel.org>
Date: Mon, 10 Mar 2025 08:27:22 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] dm: fix dm_blk_report_zones
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <20250309222904.449803-5-bmarzins@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250309222904.449803-5-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/10/25 07:29, Benjamin Marzinski wrote:
> If dm_get_live_table() returned NULL, dm_put_live_table() was never
> called.  Also, if md->zone_revalidate_map is set, check that
> dm_blk_report_zones() is being called from the process that set it in
> __bind(). Otherwise the zone resources could change while accessing
> them. Finally, it is possible that md->zone_revalidate_map will change
> while calling this function. Only read it once, so that we are always
> using the same value. Otherwise we might miss a call to
> dm_put_live_table().
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
