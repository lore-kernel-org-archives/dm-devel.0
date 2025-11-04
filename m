Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2154733F8A4
	for <dm-devel@lists.linux.dev>; Tue,  4 Nov 2025 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762282849; cv=none; b=d0g2Df/9Up/v22+S3AHcKgsp7sm2Q+4AFh5rXFHT6TwZNPBPNFLuVwDXTqjIt+ulYgV2ytCQtQFj4BPkpnlPoO+44o9EcwhCTSXel7bzS2d/EaaWDsbxXc1gmPsS+3UdGU+cY1QH4EdhYCRX0XtW3XWODHoCvAvJpPAcDXLDKIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762282849; c=relaxed/simple;
	bh=rZcGwmQLcueA+pKrWGVQC0oWEavs3MSHLzu7gfG36V4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JIqvIIj1gZXcOZgm3QOO58ICpcC4OYe2ZCFvkkh4wOoEcdSIooJucxDkuUhg7LJCFtLI4NOsdw5P4PMZKDI+78EaZZqDrfQuh4i0F9OU8cec9rcSwnXQi1EvIH3RPaYQO73sN/x8aVyjobyrd2m3+IkhjGEz7PK+m3uBuNUkp6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jl2qi6oN; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jl2qi6oN"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d1Hpj6RDkzly6Vc;
	Tue,  4 Nov 2025 19:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1762282843; x=1764874844; bh=EJw2W4R20I0tbP9KTHA+4Oke
	v2/0KvJztiMzbhvTnNI=; b=jl2qi6oNwA87r19QHd4bFtJjfr4Oj17sQMNvOQf/
	RhOyR0SYK/HZoqEHVr9wvC/wNUZ3OYoCrVChC4LCEm/umbw4ZKaTl9H/tD5hri+E
	RlAdb2J8XEwP1U0KfDJoEcaVcD/A+sz2aqCeTn9JTtAjcg/8g+4jF8RRypVPznDX
	jl4/eWdb4dezQf8mmXcSrYLMApLTdv3zGENS3zLDzjqhZJ3cKV52htqveEmWNzO9
	v91zGwYfZ8mghDT7lwawv60A62wi4zFveUDXWitoN2PpznE5/ZRkMXWZJMTfjdTm
	dCSfhuXAjpLY1bM8A4OlD3rq+gzjuRimgNpHBF6bsgJ4Qg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ktQnhIQwp04c; Tue,  4 Nov 2025 19:00:43 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d1HpQ08l3zm0XTn;
	Tue,  4 Nov 2025 19:00:28 +0000 (UTC)
Message-ID: <0cb7eefb-4501-47e8-805f-6e8737ca6bb5@acm.org>
Date: Tue, 4 Nov 2025 11:00:27 -0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/15] block: introduce BLKREPORTZONESV2 ioctl
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 Keith Busch <keith.busch@wdc.com>, Christoph Hellwig <hch@lst.de>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.com>
References: <20251104013147.913802-1-dlemoal@kernel.org>
 <20251104013147.913802-12-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251104013147.913802-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/25 5:31 PM, Damien Le Moal wrote:
> - * @BLKREPORTZONE: Get zone information. Takes a zone report as argument.
> - *                 The zone report will start from the zone containing the
> - *                 sector specified in the report request structure.
> + * @BLKREPORTZONE: Get zone information from a zoned device. Takes a zone report
> + *		   as argument. The zone report will start from the zone
> + *		   containing the sector specified in struct blk_zone_report.
> + *		   The flags field of struct blk_zone_report is used as an
> + *		   output only and ignored as an input.
> + *		   DEPRECATED, use BLKREPORTZONEV2 instead.
> + * @BLKREPORTZONEV2: Same as @BLKREPORTZONE but uses the flags field of
> + *		     struct blk_zone_report as an input, allowing to get a zone
> + *		     report using cached zone information if BLK_ZONE_REP_CACHED
> + *		     is set.

Was it promised to add information in the above comment about the 
differences in accuracy between the two ioctls? See also
https://lore.kernel.org/linux-block/97535dde-5902-4f2f-951c-3470d26158da@kernel.org/

Thanks,

Bart.
