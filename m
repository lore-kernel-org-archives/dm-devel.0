Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8C261FC4;
	Thu, 30 May 2024 23:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717113500; cv=none; b=K7JBBR6EgUtqKk/fRAJA3s26p6AA5h3mkfA9XfsQCImg06Ut+0uYq2d+1zkUL7vT9dHOQ3PJKY6fOQqKOJ993Rcx4ZDS4aMe6UfJzcKzuatTSJrUYAiPb/b1AFZyzMtjx7MFvW/0JbcjmTa6hrTlFBEPn6brClXJlyOcMn84viw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717113500; c=relaxed/simple;
	bh=rezVI8yhf8PY/WJB+M/RvsHarK624QE0EwmULuTx9qU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WjKeR21cwx6nT0tUyOUi0BSSajSwTfef/yUW6fMsKpepbAZYD9x/Q/y3Puk/aaWao4Gp6UWTd1za52xk7W1EMbcdeEM2G9d8PkFBUkK+/VlkK9nDFUrlIPry7fkmWxh1uq8zvACZcD/VGkUVspD6VT7mOYvAIArQjUHF9MYyo3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5f/1Ehv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5f/1Ehv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B50C2BBFC;
	Thu, 30 May 2024 23:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717113499;
	bh=rezVI8yhf8PY/WJB+M/RvsHarK624QE0EwmULuTx9qU=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=B5f/1Ehvt1Wj3dnvQTJa0dqtv1pv5A8bsjR44mBVsOv9Ym/UnZsysbhVkzQM+r4wL
	 nURyEMPgw1JEu4iOsd7fPK8yAlLHsnP8XzNR3XNz/s/mdcb+NaCDlK0yaNjn2gZbX0
	 b+epsQ/poam5PyiRB8l6DeQJZjata82Jp0BVjblkWS8cZ4qma/UaqJijFy63z6dkYM
	 laFbOcr/VhoiFRFq6kIh439WQSmv/QQgVXpTOeMLsKlD0osSfGSNYk97NNRhodl75h
	 DJumcF8Q2b+sCyZ/oIv6+Uh8Ks9PjUR6SUM07BLULEWbj6RgtOpK/LXLpspKsJDXcK
	 hx0wf1EuB4ydg==
Message-ID: <99352774-5be7-4e13-93cd-6368ac7ddabd@kernel.org>
Date: Fri, 31 May 2024 08:58:17 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Zone write plugging and DM zone fixes
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <1599ad1c-4395-46eb-9b9b-7439850a8300@kernel.dk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <1599ad1c-4395-46eb-9b9b-7439850a8300@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/31/24 6:03 AM, Jens Axboe wrote:
> On 5/29/24 11:40 PM, Damien Le Moal wrote:
>> The first patch of this series fixes null_blk to avoid weird zone
>> configurations, namely, a zoned device with a last smaller zone with a
>> zone capacity smaller than the zone size. Related to this, the next 2
>> patches fix the handling by zone write plugging of zoned devices with a
>> last smaller zone. That was completely botched in the initial series.
>>
>> Finally, the last patch addresses a long standing issue with zoned
>> device-mapper devices: no zone resource limits (max open and max active
>> zones limits) are not exposed to the user. This patch fixes that,
>> allowing for the limits of the underlying target devices to be exposed
>> with a warning for setups that lead to unreliable limits.
> 
> Would be nice to get the dm part acked, but I guess I can queue up 1-3
> for now for 6.10?

Yes please.

Mike, Mikulas,

Could you please review patch 4 ? It is a long standing issue with DM but now
that zone write plugging fakes a smaller 128 max open zones limit for drives
with no limits, zonefs gets confused and tests fail. So it would be great to
get this patch in for 6.10 as a fix.
Thanks !

-- 
Damien Le Moal
Western Digital Research

