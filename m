Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB2F3A8CB;
	Thu,  6 Jun 2024 08:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717661029; cv=none; b=cwT6e/VZu3rqmFHARRaHM/WwDU/aZqcguDAmkqkvTC1qPtoWRN4Spn0T/wwy+pdA07fGihLZBGPFrZ6e0fsIH+ZkOcdBm1Nfxe9z+0NAlUnXrY++8vXHRWiRFckYHB330OIAWzBjhv0kNbieuYredOve+RvDRzYEd+pUpV4Sblg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717661029; c=relaxed/simple;
	bh=m1I+dMZoaqlsTr6YkfeLXRcvMDBoExpebbV8N25k8rs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XbueeDUQfiCxr4HqidfFh2ffGy0XIjtdxQ2E0kLohINN3MTbRjxOmgXAAj4jXcqB61ALgevHM5gX4RmouuNZjrdo5RuEmdfOg1I2KwoGIGUmF305kUn9qGv9xMp1/CXvyYYc9cqSDFVMu9yiJXmSmchVzwFRo8odVK3LOKHlhco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DuBqEUnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DuBqEUnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90317C32782;
	Thu,  6 Jun 2024 08:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717661029;
	bh=m1I+dMZoaqlsTr6YkfeLXRcvMDBoExpebbV8N25k8rs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DuBqEUnKGSnWxqvcED0LDOGPUcwpSKGhZ/xBiBLu9bnnaFuNkMsVfGcWZs4c3o30K
	 NZYmC3zVZjKI0NeOeYvdWFCM5fHXHI56IvCxxRioWMref9QdHoi4boG0aqOmp5TwDn
	 ys4Laz+A4+7jqnGOZKx/MbHhvGpUBXK8snnFJRHIv9pCk+ImfMwuFi0bn2Xj4lkQGo
	 biX839piFZVlbuAUgH4uf/W+OY0qzw23hBVPTKWdYaUxvIU8Ir3lTd5XSby5t06zkL
	 3xmkevYivp3EBGJBWbvWwFU1z2dqyiAqqq5DVb1ioSG1nxxnJESD/9tnn95fKvWaUW
	 4dz0dh7L0EhmA==
Message-ID: <4d110235-6bda-44be-beea-2b9242e7bdde@kernel.org>
Date: Thu, 6 Jun 2024 17:03:47 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/4] dm: Improve zone resource limits handling
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20240606073721.88621-1-dlemoal@kernel.org>
 <20240606073721.88621-4-dlemoal@kernel.org> <20240606075813.GB14059@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240606075813.GB14059@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/24 4:58 PM, Christoph Hellwig wrote:
>> +static int dm_set_zone_resource_limits(struct mapped_device *md,
>> +				struct dm_table *t, struct queue_limits *lim)
> 
> Is there much of a point in splitting this out of
> dm_set_zones_restrictions when almost nothing is left in
> dm_set_zone_resource_limits after this changes?

Indeed, we can merge the code and avoid the additional function.
Will do that.

> 
> Either way the logic looks good to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

-- 
Damien Le Moal
Western Digital Research

