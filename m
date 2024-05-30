Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F4625634
	for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 20:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717101641; cv=none; b=aEjP6FxvIbm2X30txhMOLVh5P6luI7O2fVfpoYglt2uMSw7XOqp0+AcN2zL6+e0c+9/MD31GLHY0Zco7dEj3zdOqAlNGOJjFBlKK7kBq+gCg8WShLZB466xGnILMuNizeigLNsbREL81BOAMNp6LUS6F/AdDvGZztNQflioETPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717101641; c=relaxed/simple;
	bh=AKngulMmLfU7YDyaE28LkF8ok53MobClOxdVCSUHi1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hXEffXkM8/AGyG0iw9aJ2j//caXFovrs4DP13hx/il07zLAzEYDw8OVTOoxLtDFR5zBOml5IQJmHo7Wz4T/Hq1L10u7gOMhpnlkYTzRwKrWYNfkCgWPeZrDNo8yukX6z2Vqx8rmeJLjMBFTSI3tbeuWHDFuNERpjKtcdv0RvrU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Y13KIQFm; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Y13KIQFm"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VqynL4PNBz6Cnk9B;
	Thu, 30 May 2024 20:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717101635; x=1719693636; bh=Fg6O7ErVDV/y9HcuOrWg18vq
	P0vTCZMGBnZ/3D3DoA0=; b=Y13KIQFmgKHqO+vJrEFYKmx7mTnIFXwRl4nQ6++B
	i1Q4ksD8cfr03yhY32izWl2HV3N/P5YosihlKxAV14/dJsI4IAu5+BjI9QIz9xZ2
	usPJcErREM5CTxEddPyR0nphJjEWTZMPqvygClq9SAzFiw/1/EZjEgfGsEWgvdWG
	2tKZA04Kba1BqATG7UU/62H8R7GPqzql/ku8JgiyIgzK2lZs22INpsNyCBbKJNLc
	vLl3rFtihPoKbwaCmLiS3B5IqXh3BE5jLgxAwc6HRbcYlc6Fc/1IbSpwXg86vkqF
	47cV1v8WgMCz4unUmV8JNU6WCBQBGeZzJPBpehmc38cEUw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VUx2anOILgn0; Thu, 30 May 2024 20:40:35 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VqynH2ZR8z6Cnk90;
	Thu, 30 May 2024 20:40:35 +0000 (UTC)
Message-ID: <dd8d296e-a2e6-462d-9e4c-cbbc2d166097@acm.org>
Date: Thu, 30 May 2024 13:40:34 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] block: Fix zone write plugging handling of devices
 with a runt zone
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-4-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240530054035.491497-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/29/24 22:40, Damien Le Moal wrote:
> A zoned device may have a last sequential write required zone that is
> smaller than other zones. However, all tests to check if a zone write
> plug write offset exceeds the zone capacity use the same capacity
> value stored in the gendisk zone_capacity field. This is incorrect for a
> zoned device with a last runt (smaller) zone.
> 
> Add the new field last_zone_capacity to struct gendisk to store the
> capacity of the last zone of the device. blk_revalidate_seq_zone() and
> blk_revalidate_conv_zone() are both modified to get this value when
> disk_zone_is_last() returns true. Similarly to zone_capacity, the value
> is first stored using the last_zone_capacity field of struct
> blk_revalidate_zone_args. Once zone revalidation of all zones is done,
> this is used to set the gendisk last_zone_capacity field.
> 
> The checks to determine if a zone is full or if a sector offset in a
> zone exceeds the zone capacity in disk_should_remove_zone_wplug(),
> disk_zone_wplug_abort_unaligned(), blk_zone_write_plug_init_request(),
> and blk_zone_wplug_prepare_bio() are modified to use the new helper
> functions disk_zone_is_full() and disk_zone_wplug_is_full().
> disk_zone_is_full() uses the zone index to determine if the zone being
> tested is the last one of the disk and uses the either the disk
> zone_capacity or last_zone_capacity accordingly.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

