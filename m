Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C184381A3
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 08:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744272163; cv=none; b=BF9q7MavAjNuj8Lb3+F4tb5uL4mMuURUiqu5Fxc0kbflYlD1SN7rpk/N/9vTjcQzzsY9tI6AsATW/Y2kIeNnhtyfAb2pEenQtEoHf+E3kXqJOxkQQYCn0jplNRlk0yf0/gK+/Z0bE4ymiMAVCpKjjUzEWasJCyDKKZkkj8WGAcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744272163; c=relaxed/simple;
	bh=FWMAWP5O4EU6k/drHq6Cf5wbMPgc9j/wQo6afN0XxRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DzuI6AHfDkBwQCPymF8yzT5E1KN69tTsggwjzRQwqu5mcRqjfpaG9qsyzuaVQDceoQx29YB+2ryXsKOCXNxU1HoMRCzNaghKLiAAwTjZlpX/AucnGL4BivYZ/1Y87K3B3ybYJzAn9JpYRDMYjMXpwhfWa3DPNqD14Y4SZ6m4aP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b2rjQKFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b2rjQKFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D3BC4CEDD;
	Thu, 10 Apr 2025 08:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744272163;
	bh=FWMAWP5O4EU6k/drHq6Cf5wbMPgc9j/wQo6afN0XxRc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b2rjQKFTH59VzzsTkyiQQQN4hRwGW/jBzxh+mgENUsoByEKgDOIMMwjjn77vE5l6Y
	 1cDttcKD4Ie7M/wJjrNyxuOztPkraHikYmA2Qn/DA7ZFB0wgvIAkMrtrCDa7W41wbk
	 s218EV8Cq+MgTRA1SVfidqkI0jHj1sttKYskYo6KFCnOCZ1/55dc40RU1jaL+onZux
	 DItAFHZqm5z/6nWR/TqGUq09XhWZwcYtS7dG44WqPhiYdV1Ya30fcByRdatxTHqij/
	 OZr8LPqNDmqQ2gavv5XecfaI4R1GJhKvf8D8PUYoYjAj05BNrL2iEWRJBWVrGnxN5X
	 K3WiTp+lrW+6g==
Message-ID: <df1c183b-3228-4785-ab31-a21d8165abcf@kernel.org>
Date: Thu, 10 Apr 2025 17:02:00 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-delay: Prevent zoned write reordering on suspend
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20250410043311.990675-1-dlemoal@kernel.org>
 <20250410075431.GA763@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250410075431.GA763@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/10/25 4:54 PM, Christoph Hellwig wrote:
> On Thu, Apr 10, 2025 at 01:33:11PM +0900, Damien Le Moal wrote:
>> When a dm-delay devie is being suspended, the .presuspend() operation is
> 
> s/devie/device/
> 
>> first executed (delay_presuspend()) to immediately issue all the BIOs
>> present in the delayed list of the device and also sets the device
>> may_delay boolean to false. At the same time, any new BIO is issued to
>> the device will not be delayed and immediately issued with delay_bio()
>> returning DM_MAPIO_REMAPPED. This creates a situation where potentially
>> 2 different contexts may be issuing write BIOs to the same zone of a
>> zone device without respecting the issuing order from the user, that is,
>> a newly issued write BIO may be issued before other write BIOs for the
>> same target zone that are in the device delayed list. If such situation
>> occurs, write BIOs may be failed by the underlying zoned device due to
>> an unaligned write error.
>>
>> Prevent this situation from happening by always handling newly issued
>> write BIOs using the delayed list of BIOs, even when the device is being
>> suspended. This is done by forcing the use of the worker kthread for
>> zoned devices, and by modifying flush_worker_fn() to always flush all
>> delayed BIOs if the device may_delay boolean is false.
> 
> Is that scenario specific to dm-delay?  I think the same applies to
> any other target that supports passing on bios to zoned devices.

Don't think so. The delayed BIO list is a dm-delay thing only. dm-linear,
dm-error or dm-crypt do not delay BIOs like dm-delay so we do not have BIOs
being issued in the pre-suspend context.

> 
>>  	spin_lock(&dc->delayed_bios_lock);
>>  	if (unlikely(!dc->may_delay)) {
>> -		spin_unlock(&dc->delayed_bios_lock);
>> -		return DM_MAPIO_REMAPPED;
>> +		/*
>> +		 * Issue the BIO immediately if the device is not zoned. FOr a
>> +		 * zoned device, preserver the ordering of write operations by
>> +		 * using the delay list.
>> +		 */
>> +		if (!bdev_is_zoned(c->dev->bdev) || c != &dc->write) {
>> +			spin_unlock(&dc->delayed_bios_lock);
>> +			return DM_MAPIO_REMAPPED;
> 
> Don't we only need to do that if anything is queued up due to a
> suspension?  Then again having a different patch might be premature
> optimization, it's not like anyone cares about dm-delay performance
> almost by definition :)

True. I can add a list_empty check here. Will send a v2 with that.


-- 
Damien Le Moal
Western Digital Research
