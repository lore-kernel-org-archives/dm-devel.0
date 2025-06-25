Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A8A2D3EC2;
	Wed, 25 Jun 2025 23:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750894885; cv=none; b=O5OoNZgtEeqPyYtnkA53kMDGvQ2CFdGyMRWf/p3Hrkca9umN7+LHwIr/tzud8z+aU+pXJ+zNjjGxYI2kA7JzraQZlmVafj8cNqYTdFfl/L457BcTTfn9Xk22WiT+VYLpV2d4pyhtKna+G8hHF/w+e31rjLwApop2pvdv4UFDe+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750894885; c=relaxed/simple;
	bh=JVOkVvO3QhDTkIBQzFanllrOinQMrWF1B9Za0KqM7Lw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sTwZmuE5qCqZDWxtwo043fwG5TXyPxTvcLuRv62EsK6MwcBNQRuoEy3ZM64VKPEJpLxY3b8/O9pfZKfQjYrxzIy3gdcDx4BABoEl3YwB1HEb3k8A5B1HO2pRWHtxtsNFXY+fSudmLcMcc6ZfwyrrufY2lfkhN6MrQH6RuiVYwPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3hfdE9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3hfdE9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFB3C4CEEE;
	Wed, 25 Jun 2025 23:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750894884;
	bh=JVOkVvO3QhDTkIBQzFanllrOinQMrWF1B9Za0KqM7Lw=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=S3hfdE9Ol72PdFBGgK0CVNogiIXVaNdRfruPTXNbpSk8R4V78hCfNTkIsL4WYrGs3
	 gkcR+gDIOc3K3ZdpmSd9i7u00NNd7iquOJUO7N1FP8yV79YqtN3ZGSOAhsoH/WuOOj
	 C5rK9vjL/f5/zge7UOC079BzX1U1nu8Z/xI3wiwlJ1uogYtUOjVU9CgnEXzg4cgf8B
	 z0TtY08UNFBKhj2URHEzeoz2A4OjZd730b30oHkt5isL6dV972sozbsogKi/lGWIuP
	 U5bxm7tVwJafbwAelpKlMVItrZVXxyl78radvkM25Yhwg1eFw7aOnGHE7uMgGKYDui
	 n7CZ/NBeYMijw==
Message-ID: <4f4408fd-c87c-4982-bad1-87798add9516@kernel.org>
Date: Thu, 26 Jun 2025 08:41:22 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] dm: Always split write BIOs to zoned device limits
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20250625093327.548866-1-dlemoal@kernel.org>
 <20250625093327.548866-4-dlemoal@kernel.org>
 <654fed1e-ce53-4386-a966-97c50931e9b5@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <654fed1e-ce53-4386-a966-97c50931e9b5@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/26/25 01:34, Bart Van Assche wrote:
> On 6/25/25 2:33 AM, Damien Le Moal wrote:
>> +	/*
>> +	 * Mapped devices that require zone append emulation will use the block
>> +	 * layer zone write plugging. In such case, we must split any large BIO
>> +	 * to the mapped device limits to avoid potential deadlocks with queue
>> +	 * freeze operations.
>> +	 */
>> +	if (!dm_emulate_zone_append(md))
>> +		return false;
>> +	return bio_needs_zone_write_plugging(bio) || bio_straddles_zones(bio);
> 
> Changing the dm_emulate_zone_append() call into a
> disk_need_zone_resources() call or a disk->zone_wplugs_hash test
> probably would make the intention of the if-statement more clear.

The comment is not clear enough ?

> Additionally, bio_needs_zone_write_plugging() already tests
> disk->zone_wplugs_hash. Isn't the dm_emulate_zone_append() call
> superfluous because of this?

Yes, I think it is. But I did try to minimize changes given that this is a fix
which is not small already...

I will do more testing and send follow-up cleanup patches.

-- 
Damien Le Moal
Western Digital Research
