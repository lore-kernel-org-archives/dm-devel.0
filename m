Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7454F171AA;
	Thu,  2 May 2024 09:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714642644; cv=none; b=KjWopG8HkcpK84wpuHaenDH5SZ7ONJeBMCHeMHISwX1vC+TjdscGH7ECP7SFg0EchrD2Is2Y5anHavhNhu/F0IDPuKnknfn7LLad8f4/gObm+xBEqD8ZH9V1nYCSjt5LE94czRHnZ9GVDlbzcA473/VcWCusdj4Pe9KOYz95HG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714642644; c=relaxed/simple;
	bh=fbmqAnRpKIuB8APRk5fSKVuC+VT6tJcSKzu30jMaNUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aXE9CZLZHc95MBiuczgKMHoMSBc5Hg/uBQb4M4MXexzJ1l0YmEhWxaB6QD5qlktevAjEq85AMADSfaP791SzNahcpU53RuQxFa4VygPeAtqtB//OtNyIxL71TjUA6Eb2dKT5MQO3JElaJQLYO9hzyhEqI0qODrXNQa60kzKw2d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BabjEkXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BabjEkXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BF9C113CC;
	Thu,  2 May 2024 09:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714642644;
	bh=fbmqAnRpKIuB8APRk5fSKVuC+VT6tJcSKzu30jMaNUY=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=BabjEkXb/mJrL1iGag2p+sMNkAthTYmP6seKrea9kOfrp0A24lUMPO1ap4pOaOTpe
	 Er0KAVD8KuA2TpxlU5NSO0l0dySQBAwMTtCxHq2GLH4rBb/jEElwjCSRN8yQDabyxN
	 aAaZiIHOf42o3fZYnLs1yvYTUuf2m7QIjC4hVWV644WMKSU5f7JrvaqLOZHYWg2fCW
	 T9YWSiRqSK6xBw8eVHa714tMTcQQVI4P2duy54GycVjG8YqhLYJ1awlIPPj61h6Far
	 xMVQiJ6OnU71gJj26Zh7Zo6b0VXjascfjAC5Z3OtzU3j478hefWU+WTzbY79cG4Fiy
	 e3MUW7z59tTDg==
Message-ID: <8116c2dc-dd47-4678-9974-100006ffd0f7@kernel.org>
Date: Thu, 2 May 2024 18:37:21 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/14] block: Fix reference counting for zone write
 plugs in error state
To: Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-5-dlemoal@kernel.org>
 <d4f71b64-b2d3-4350-b502-bbcfcc9614ce@suse.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <d4f71b64-b2d3-4350-b502-bbcfcc9614ce@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/2/24 15:01, Hannes Reinecke wrote:
>> +static inline void disk_zone_wplug_set_error(struct gendisk *disk,
>> +					     struct blk_zone_wplug *zwplug)
>> +{
>> +	unsigned long flags;
>> +
>> +	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR)
>> +		return;
>> +
> 
> I still get nervous when I see an unprotected flag being set.
> Especially in code which is known to race with error handling.
> Wouldn't it be better to check the flag under the lock or at
> least use 'test_and_set_bit' here?

It is protected: this is always called with the zone write plug spinlock being
locked.

> 
>> +	/*
>> +	 * At this point, we already have a reference on the zone write plug.
>> +	 * However, since we are going to add the plug to the disk zone write
>> +	 * plugs work list, increase its reference count. This reference will
>> +	 * be dropped in disk_zone_wplugs_work() once the error state is
>> +	 * handled, or in disk_zone_wplug_clear_error() if the zone is reset or
>> +	 * finished.
>> +	 */
>> +	zwplug->flags |= BLK_ZONE_WPLUG_ERROR;
> 
> And that is even worse. We might have been interrupted between these
> two lines, invalidating the first check.

Nope: zone write plug spinlock is locked.

> 
> Please consider using 'test_and_set_bit()' here.
> 
>> +	atomic_inc(&zwplug->ref);
>> +
>> +	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
>> +	list_add_tail(&zwplug->link, &disk->zone_wplugs_err_list);
>> +	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
>> +}
>> +
>> +static inline void disk_zone_wplug_clear_error(struct gendisk *disk,
>> +					       struct blk_zone_wplug *zwplug)
>> +{
>> +	unsigned long flags;
>> +
>> +	if (!(zwplug->flags & BLK_ZONE_WPLUG_ERROR))
>> +		return;
>> +
>> +	/*
>> +	 * We are racing with the error handling work which drops the reference
>> +	 * on the zone write plug after handling the error state. So remove the
>> +	 * plug from the error list and drop its reference count only if the
>> +	 * error handling has not yet started, that is, if the zone write plug
>> +	 * is still listed.
>> +	 */
>> +	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
>> +	if (!list_empty(&zwplug->link)) {
>> +		list_del_init(&zwplug->link);
>> +		zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
>> +		disk_put_zone_wplug(zwplug);
>> +	}
>> +	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
>> +}
>> +
> 
> Similar comments to above: you are clearing the flag under the lock,
> but don't check or set under the lock...

And similar comment: this is called with the zone write plug spinlock held. So
no race with the flag handling. What is racy is the error handling because we
can only hold disk->zone_wplugs_lock at first, and have to release that lock
before we take the zone write plug spinlock (otherwise we would have lock order
inversion). And the error hanlding needs to do a report zone, so no zone write
plug spinlock either, and in the meantime, the user may do a zone reset or reset
all... Hence the trickery here to look at if the error handling work already
took the plug out of the list for processing or not. If it has, then the error
handling will do what is needed with the error flag.

-- 
Damien Le Moal
Western Digital Research

