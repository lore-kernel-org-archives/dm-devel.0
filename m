Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BCB4503A;
	Thu,  6 Jun 2024 05:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717652931; cv=none; b=oEL3fimv+k55PxzDaAwro5GR0mURyl51KjWHlvuszYnrqKOAmaly2PQuwN3/pKY7gnwkfSzhH3gSHsE3A3G7d3ott2x8GspyTEfpLQ8eu810/0unxGPFzJyVgX7zxFcE4VvKcUFPZlq1HfzVrlBtd0wUuCDpjzWT4uVEH/+5KGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717652931; c=relaxed/simple;
	bh=to9lXwD8y4GZjNah3zFD/tfg5rqM2gIiYcIWJfm8jYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ui1jrogjzm4qQDpaKQsjyOPxwt5DQvcZlGG0DWskxMFuNhxG6d9rNAXBwvevZ5tj2kUrPutByaaQ2JkYCmboC/LYyBjhR81vNkTaMDkV/efdC1fBVZebXg7ejp7v0dv2Z4ujf0pwv0F6ISHK31rQHYG9Jpi/LADliv341qko/YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZEjTEaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZEjTEaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA55C2BD10;
	Thu,  6 Jun 2024 05:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717652931;
	bh=to9lXwD8y4GZjNah3zFD/tfg5rqM2gIiYcIWJfm8jYo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eZEjTEaI+W5h7tOxe8xUIKqAVAJB3nH7xDikt+h/QidCvFkqw3mMF+xjHq2WP8lnV
	 bjv5V+N/A+QwJ15dfT1lFDUFg1PZwOoIHX5crBmBR0mJGrAODb33nsQ5eVPLz4Ib2k
	 EANujo2p4jx4tvShrr0NAbwKv0RCkaNiapXaJ6qCFx9ya7usetACknRSb18xrLL6Qt
	 ScezNZfg16N5uRAqe9+3M6r5S33HgyKm35RzVFhUmhY7jlemg0xk3iF2XytbdUC4Zz
	 XaArJ58SHcModLDiSMe+PK4FYRvuzJTI5A7QJGTiN/qY05Rq3RkOn6nF5kFvtQgGoh
	 17rnOeJLXNUHw==
Message-ID: <de8d7ddb-10a0-43d8-8c6b-179bed1d25f4@kernel.org>
Date: Thu, 6 Jun 2024 14:48:48 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] dm: Improve zone resource limits handling
To: Christoph Hellwig <hch@lst.de>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20240605075144.153141-1-dlemoal@kernel.org>
 <20240605075144.153141-3-dlemoal@kernel.org> <ZmDA5fmZMNGM1oFl@redhat.com>
 <90629a40-e45f-490b-bef6-436839d91b92@kernel.org>
 <20240606043958.GA8331@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240606043958.GA8331@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/24 1:39 PM, Christoph Hellwig wrote:
> On Thu, Jun 06, 2024 at 08:52:32AM +0900, Damien Le Moal wrote:
>> Unless you have a better idea, I think we need to pass a queue_limits struct
>> pointer to blk_revalidate_disk_zones() -> disk_update_zone_resources(). This
>> pointer can be NULL, in which case disk_update_zone_resources() needs to do the
>> limit start_update+commit. But if it is not NULL, then
>> disk_update_zone_resources() must use the passed limits.
> 
> I think the right thing is to simply move the call to dm_revalidate_zones
> out of dm_set_zones_restrictions and after the queue_limits_set call
> in dm_table_set_restrictions.

Indeed, that is a simpler approach. Resending with that fixed.

-- 
Damien Le Moal
Western Digital Research

