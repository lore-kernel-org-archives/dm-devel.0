Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2168513A3EF;
	Thu,  6 Jun 2024 07:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717660678; cv=none; b=kr0mThBAzmsOfS8uJLHs3YQzXMqFFsUjwkb9ChnIVwO5lFzezoPBVmFfAQGTUO0d6ku8XWLJaO8OX5PkwCd7LiYePsWqrjiaGfZed5djSFDKH+zd0I+2lTtyRqitXfNd80OMgrgsd//ME2XVT9NcJQuZq8J3YFh2ZE9ppQgy+Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717660678; c=relaxed/simple;
	bh=bGM5fgJeXdYBQ6ounNmCdLT4fMX5txwyPV3AxOYpiVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WZPH236CK9pH3RRihQ7OVVlw2NWcf4LyLT+Htjf68X+3fcOG3/qc54LzfV2qvcTRagVATou6tKGUjwxgCKrOxiMyVzOzbCVlfXrjRhqcR5NH4vJ7krnQzQ0N0YOVdGLbvH3nOS9r01vEz/6LCOhCgHdy5T0oi68ngThV7dCvglk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H6NEUJy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6NEUJy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70A6C4AF50;
	Thu,  6 Jun 2024 07:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717660677;
	bh=bGM5fgJeXdYBQ6ounNmCdLT4fMX5txwyPV3AxOYpiVg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H6NEUJy3Yxu1ZLVN7Hkt1kG34CkrXZDYVFtqxSPpSnqkoKtuqo7hOrcZbOMAHxUE/
	 9/cnvQ0madbRZM1amQ8gEQvd+bH9S5FMR1dpX2VuGOEYRyEkshOneaio8SzdHU8cvL
	 MNbVhc/nbGToxefVZ71brwuFCeFN3cl/zmQbFWtmYFzKBMhT53MSxopomI4Z+IeT68
	 sV8v7AexRJSD+RfzNkBra6lehmhq6uvgwRnIqp4zaN+LzGwTr3papaZ6YUX7gTZEes
	 o41VSkkzUBuXyapx5zwcJKBZwP+pKwzYlFvXqyucwFPn/kRZ7IXaKrkCrz7OJh1Fr4
	 GRfCmkxkRiwtg==
Message-ID: <7dc3ad21-7920-4b98-b2d1-ff1f4d534997@kernel.org>
Date: Thu, 6 Jun 2024 16:57:55 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] dm: Call dm_revalidate_zones() after setting the
 queue limits
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20240606073721.88621-1-dlemoal@kernel.org>
 <20240606073721.88621-3-dlemoal@kernel.org> <20240606075425.GA14059@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240606075425.GA14059@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/24 4:54 PM, Christoph Hellwig wrote:
> On Thu, Jun 06, 2024 at 04:37:19PM +0900, Damien Le Moal wrote:
>> dm_revalidate_zones() is called from dm_set_zone_restrictions() when the
>> mapped device queue limits are not yet set. However,
>> dm_revalidate_zones() calls blk_revalidate_disk_zones() and this
>> function consults and modifies the mapped device queue limits. Thus,
>> currently, blk_revalidate_disk_zones() operates on limits that are not
>> yet initialized.
>>
>> Fix this by moving the call to dm_revalidate_zones() out of
>> dm_set_zone_restrictions() and into dm_table_set_restrictions() after
>> executing queue_limits_set().
>>
>> To further cleanup dm_set_zones_restrictions(), the message about the
>> type of zone append (native or emulated) is also moved inside
>> dm_revalidate_zones().
>>
>> Fixes: 1c0e720228ad ("dm: use queue_limits_set")
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>  drivers/md/dm-table.c | 15 +++++++++++----
>>  drivers/md/dm-zone.c  | 25 ++++++++++---------------
>>  drivers/md/dm.h       |  1 +
>>  3 files changed, 22 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index b2d5246cff21..f0c27d5a738b 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -2028,10 +2028,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>>  	    dm_table_any_dev_attr(t, device_is_not_random, NULL))
>>  		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
>>  
>> -	/*
>> -	 * For a zoned target, setup the zones related queue attributes
>> -	 * and resources necessary for zone append emulation if necessary.
>> -	 */
>> +	/* For a zoned table, setup the zones related queue attributes. */
> 
> s/zones/zone/ ?  Or is my grammar dector way off?

Nope, it is my fingers and brain which are off :)
Will fix that.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks.

-- 
Damien Le Moal
Western Digital Research

