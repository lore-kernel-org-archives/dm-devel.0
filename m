Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE26A50;
	Fri,  2 Aug 2024 00:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722559719; cv=none; b=NzPs8In+xqwHoC6YRCcxe6BKVHBAqGM5wC2TQ0Odk64W0PumjUcMEHk0KQ5vzlyiPs8wsm/+DFV5p8OZDApBIQ4d+w/NVsltXr3ryygF5BLzRnCzlEvIPzHGizOkY4RsOz5I3raf/jZ9j6Af5mTSdQsW1bW5gq2ryqOXwVJg6zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722559719; c=relaxed/simple;
	bh=z2Ypbucmsx8mN9LyhdC7ERjcd1dC+64EKj6aMekxZ5k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=itoZ4Dy8ZNboSEfhhyjo4Agc7V18FdY4UdEBAjBscvowejwAOgBh+MVohVDqA88/7lntd4SV/EAHfZewGiCX8dKcgnBEyAbn/i0MKixzjzhK5F3lLW+IwRgPDqe8UccJ2LEsfDVmded48dpnWysHR2bKeN+VWFILYejgOnFssAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YsVlI9wm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YsVlI9wm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC48C4AF0A;
	Fri,  2 Aug 2024 00:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722559718;
	bh=z2Ypbucmsx8mN9LyhdC7ERjcd1dC+64EKj6aMekxZ5k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YsVlI9wmdF6LY9NRK+vTXJFhiBVd50AHPFwwVuPYkX8KXP0wx08klAHMoFiT6J2we
	 fLMGeOTDYp1n81P9qnKHuWvB/nfGiXNgENcnYdJoAw9WxE3XlzNkmTl+VKwCgGPasy
	 zj5WTKiB4fLoAXUvRyD12H/kYhYauz/bAdc80i3Ye1VWw1lSLOHkUsSjPfb/ldJ2EX
	 beF4oHtoLyEQi+slz8qz6pfvL6qOStX8rSpGKUlixTcUvGch1rKKMF1W7Vy2kDYQRO
	 TcCa7dtdTmTwAECw9KmrC85idLIU3q54k1dBal5xDQ3xkZbGYOQfCh5bUCT6ko23Ds
	 OanBfcH8kux4w==
Message-ID: <e53fefdf-2141-4a50-95a9-b135597a48f3@kernel.org>
Date: Fri, 2 Aug 2024 09:48:37 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] dm: Remove unused declaration dm_get_rq_mapinfo()
To: Yue Haibing <yuehaibing@huawei.com>, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240801133121.3021871-1-yuehaibing@huawei.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240801133121.3021871-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/1/24 22:31, Yue Haibing wrote:
> Commit ae6ad75e5c3c ("dm: remove unused dm_get_rq_mapinfo()")
> removed the implementation but leave declaration.
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

