Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179E83009C8
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 14:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757513619; cv=none; b=MiUlTTG1/FGmOdixGzQz5Oyc1jzmsFjA541EjHeLIOk9OZ7E1Yn1lZWPA1xWoyQuHyMWpiNQGIYxSTH+0J2eAYTVS+fPVLoCaTl7wBoN74RSN2zt2RUWDm84LLdYY+y/2+6R94cdlGtk3LlBKLeMffD51OB/WXgjcnyjE8rWe08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757513619; c=relaxed/simple;
	bh=pwwjTU4yR1Q+x8oCRR+nk1TLa65UQ0xwLTL1VLJSogs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nB7OtvmaNcCxl1y2mS+0/3+tiQfUf/HMl6+3IPb8oxBvWHxeQk21+nWfxgCO+AeVnlWOcs69TZF8tVb261YndLFGY0crW8+CbLJ+oxwwkoTKq83rpd2Vw4IxxenulG62HWUMl7BaLVIp7Zxer9X8VsUJVnNiIrvI7RXlJaU1lIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mwgzi/mJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mwgzi/mJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75D4C4CEEB;
	Wed, 10 Sep 2025 14:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757513618;
	bh=pwwjTU4yR1Q+x8oCRR+nk1TLa65UQ0xwLTL1VLJSogs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mwgzi/mJ3UaUzCRDvOzcMJcf17GPFUQGk+S1AKW3YUy+dIMjeZ+PJWAV30iX/s0U9
	 6D1QebGzdpbj68QyxG3dMIxxNcjvjuQrw4WAGZPNVvpQa6ac4vqbrGo5z4OWjIoDL9
	 WEi7Uki8WvAWRNdBtDlAfqtyc/qLFgcliLE2wyb3CwfEJx0icMdxdRL4WDfdpjdCrG
	 sIjCIqqACtoHImmCfr8I2DyKbsJiA2JRgYvL3EbUHXynHFMeVLjDjaUxXG64MXsW6Q
	 7mpv99qGmnflZkRUvMXAeo6SFq9qiMtDUbEEW9lrJZGzm41fDOA8nor+zN6dCWTEDi
	 wZMP2q4IPMu+Q==
Message-ID: <abcd6435-2fa6-4536-8243-420306dc13a2@kernel.org>
Date: Wed, 10 Sep 2025 23:13:36 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: Preserve the order of REQ_PREFLUSH writes
To: Bart Van Assche <bvanassche@acm.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
References: <20250909182641.3496300-1-bvanassche@acm.org>
 <aec57265-20e4-4012-b3ae-8cb9c375da60@kernel.org>
 <f4ca5122-a24d-4d37-8b90-2fdc2aed7699@acm.org>
 <f3c4dfe5-5930-4fde-bf33-1a5004a98b23@kernel.org>
 <0113cd80-b743-49b6-8e5a-ca0dda4a01e9@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <0113cd80-b743-49b6-8e5a-ca0dda4a01e9@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/25 23:02, Bart Van Assche wrote:
> 
> On 9/9/25 6:38 PM, Damien Le Moal wrote:
>> Then please rewrite the commit message to clearly state that and add Fixes tags
>> as appropriate.
> 
> Hi Damien,
> 
> Do we agree that sending REQ_PREFLUSH and data as a single bio instead
> of as two bios is a performance optimization that neither affects which
> data gets written nor the behavior in case of a power failure? Do we
> agree that the Fixes tag should only be used for bug fixes and not for
> performance optimizations?

Yes, fixes tag apply to patches that fix a problem. I know that.

Your commit message was mentioning a problem but was not clear since it was
mingled with write pipelining, which is not upstream.

For the REQ_PREFLUSH, I did spend a lot of time with the flush machinery to get
it to work with zone write plugging (when I was developing that). I probably
should have spent more time with DM handling of that request. I do not recall
exactly what it does. Would need to reread the code, but I am too busy for that
until next week. So I cannot comment about what you are trying to do. Make your
commit message clearer to help reviewing please.


-- 
Damien Le Moal
Western Digital Research
