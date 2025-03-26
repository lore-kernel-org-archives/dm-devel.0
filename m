Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29C01A83E6
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 12:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742993750; cv=none; b=G5x24Q9Pj/6OjtYa6mt8BzodbYiSGPXzvDMA0lAFzeRSoe9YPDRZxIDnnR77gzN8DbW5xywOrcuqiSaMc/8J+ESWx/9v79gKwUSd6TTGhXcHNafzYJqYVXpaCuYcEx5/ER+dFlzZnuGowqrT1Bfn6mdRWosAjUWc7DYub+lXfhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742993750; c=relaxed/simple;
	bh=m/K7I6E7XsYd8a1TILWocVq7+S87lxnEGFjhL6e9nWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mHoyj8CfdJKDY7zJzNB3+1xQzgXD+GWr4YMqosl0Zrm5TliJHNE2N0sZtrurhhu2n6ncZqPOqi5unplB9yBKYmqSnJsKiOYS640gN4C6rtilobQhFjQzzmp7DUfpLpWN0jGZkJCXY5mv3RsU64XTMYRUuyFvRCtscpULCBR+3S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i41tugmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i41tugmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2150C4CEE2;
	Wed, 26 Mar 2025 12:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742993750;
	bh=m/K7I6E7XsYd8a1TILWocVq7+S87lxnEGFjhL6e9nWQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i41tugmOs1c6o8+izcBPIRQ7ZuRuNIkof6zDn4DqjLsh9Yc7ogwceK97Dni7WlsqN
	 bgNSt4yNqk+B9N3ptAsj0G81MU/7hZJwyuNd6EBP0pfzUcILo+MXwtGOcyVUwiPE5I
	 VFaJdCpg9QSJ9/jSE7p9lhBdvxlZ3PUGA2orxXjt5Yi9gkoF1daa71JNt4jPnK4w8v
	 pmHA04Q2hM6ky+Yz67UiDLV6ER+2skscdZ4v1yoi0CjfO5AVLGJQrndM81UDZcRJr9
	 Lh8bW+XVcPCq31u4AItTeYbUY2MaFpEOLNMs2lykQXY0njvCKH9BqAg8Ja+I6q6mv2
	 RMVA19CMQ0Lsw==
Message-ID: <1b09a5a4-437b-466a-a238-8d4cb5526942@kernel.org>
Date: Wed, 26 Mar 2025 08:55:48 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-delay: support zoned devices
To: Benjamin Marzinski <bmarzins@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev
References: <20250321071816.1674943-1-hch@lst.de>
 <Z92naQRO2DrpMnXE@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <Z92naQRO2DrpMnXE@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/03/21 13:52, Benjamin Marzinski wrote:
> On Fri, Mar 21, 2025 at 08:18:16AM +0100, Christoph Hellwig wrote:
>> Add support for zoned device by passing through report_zoned to the
>> underlying read device.
>>
>> This is required to make enable xfstests xfs/311 on zoned devices.
> 
> On suspend, delay_presuspend() stops delaying and it doesn't guarantee
> that new bios coming in will always be submitted after the delayed bios
> it is flushing. That can mess things up for zoned devices. I didn't
> check if that matters for the specific test. Setting
> 
> ti->emulate_zone_append = true;
> 
> would enforce write ordering, at the expense of adding a whole other
> layer of delays to zoned dm-delay devices. Since this isn't really
> useful outside of testing, I think that could be acceptable if necessary
> (it would require us to support table reloads of zoned devices with
> emulated zone append, since tests often want to change the delay).
> However it would probably be better to see if we can just make dm-delay
> preserve write ordering during a suspend.

delay_presuspend() calls flush_delayed_bios() with flush_all == true. So all
BIOs will be flushed in the order they are queued in the delay list, which as
far as I can tell is the order in which the user of dm-delay issued the BIOs. So
for writes, the order is preserved as far as I can tell.

-- 
Damien Le Moal
Western Digital Research
