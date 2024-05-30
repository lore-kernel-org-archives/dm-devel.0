Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB7D12BE91;
	Thu, 30 May 2024 11:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067379; cv=none; b=GxmVisUYvHmm+DyYpK3YLgj8MpgajADUxaBIZYFRDGkSWLLvmdV/vxPDac4pPGSuZgdbICqPRTmuVllPimxMxDCZHcZsOIGCZZjeMj6ruQsDd956guY9OePoamsFRUo1dJv1j//X7wwg6i2RjlonlCHCqPEDa1tPVswRI2Cb3q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067379; c=relaxed/simple;
	bh=HeZxGnvMZ7Iclw9p2NasiojNVxxMm4UZ04WpvYt6hQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qU1N33nlBS/aiC5wpnexArqb8oXhwRvNJWHdWhODJXes4R2sJVhSnnsTzKzVeDYLELq58c+q6p2VPIZxzIKO14H+iAxnbwYEIBPrTHi55JO4SxN5a5VOFtyArvEmfg5hPXf9WCJI8P29LB767QmjXrGa63ConSkDnonvx18xWpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gx1w/7wx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gx1w/7wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56694C2BBFC;
	Thu, 30 May 2024 11:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717067379;
	bh=HeZxGnvMZ7Iclw9p2NasiojNVxxMm4UZ04WpvYt6hQ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gx1w/7wxl+t3+TxsUCoMpuxOEr20FzUgjP5rNB6RIx7sXhJ6T4W6LvhJUd0sjsCHR
	 e+4jcnEp8wtXokBLyuOei7Ad92cVX2A4z6Z6U8WwKYumwlckNN1gJlFZlmq5XjSln+
	 vZOEXgxhBl8ev7ujJzyXDSG++FpJkDQHkbRte5/uL2D090VTdeermWIqYMEJZzQrVg
	 OjS2nuuOOfHBH/qDRUs41pSJmasCVxSnrkLvtohvzcSnX3KKGWnR0XzwyulWSmvdsP
	 NMFil2Xsyz6NcRrUeKdrsDxG7JYzxhbY6v/K7TRKIniqkqYauUHDovo6XhHcse/kJV
	 VR5gj/wJPqw9g==
Message-ID: <c61058da-831c-4872-8032-69d3405db228@kernel.org>
Date: Thu, 30 May 2024 20:09:37 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] block: Fix zone write plugging handling of devices
 with a runt zone
To: Niklas Cassel <cassel@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-4-dlemoal@kernel.org> <ZlgspRAZQ4lmqBcC@ryzen.lan>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <ZlgspRAZQ4lmqBcC@ryzen.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/24 16:37, Niklas Cassel wrote:
[...]

>> +static bool disk_zone_is_full(struct gendisk *disk,
>> +			      unsigned int zno, unsigned int offset_in_zone)
> 
> Why not just call the third parameter wp?

Because it does not have to be a plug write pointer. And even then, zone write
plugging uses offset in a zone as write pointer values :)

[...]

>>  static void disk_remove_zone_wplug(struct gendisk *disk,
>> @@ -669,13 +683,12 @@ static void disk_zone_wplug_abort(struct blk_zone_wplug *zwplug)
>>  static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
>>  					    struct blk_zone_wplug *zwplug)
>>  {
>> -	unsigned int zone_capacity = disk->zone_capacity;
>>  	unsigned int wp_offset = zwplug->wp_offset;
>>  	struct bio_list bl = BIO_EMPTY_LIST;
>>  	struct bio *bio;
>>  
>>  	while ((bio = bio_list_pop(&zwplug->bio_list))) {
>> -		if (wp_offset >= zone_capacity ||
>> +		if (disk_zone_is_full(disk, zwplug->zone_no, wp_offset) ||
> 
> Why don't you use disk_zone_wplug_is_full() here?

Because this function does not modify the zone write plug write offset. So we
cannot use it.



-- 
Damien Le Moal
Western Digital Research

