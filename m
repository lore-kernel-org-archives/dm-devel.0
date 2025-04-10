Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2174278F4F
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 00:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744246655; cv=none; b=W2YpT3NjXuVyvLui6blvNeVIoOSaS6KAwVygEhBKhDFruY6waot6DDXVm5FMXepMkiLXFM5zQVH3Iaq85tjFiDPZOwDUcjDk9/WCP+iK2LouFDvgOB/fjRhWikn/flaeyXtIB1eu8lcT0D3uYtuzjKFBEooMwHkoei/Ms0MmPQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744246655; c=relaxed/simple;
	bh=Um7vF0RgFUaRTJkF0UDlcE2vhCMbneDPMMIDzC2NZ+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dD7QPO2uVwmuHgooLxu6pTJu2FN/NCY1E2hsKh7altQjxPqSU6c8Bgz2IVPSBX41BDWCTvnk+hOZOOX9cKhdL1z/Y9dJt/Vp+nSECeRs/3a6FOfH9nWxLJJQ46UNcIgYKRqnxhM8zu5rL77k0Kp9Z9QH63AKePI2/wcAG5JhrZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sOmE+9z+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sOmE+9z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF47C4CEE2;
	Thu, 10 Apr 2025 00:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744246654;
	bh=Um7vF0RgFUaRTJkF0UDlcE2vhCMbneDPMMIDzC2NZ+I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sOmE+9z+sHbCt6nbUkT4ppPvucKqB1+7VXYv90IMAUt6rFL/SMj6wnBmPOfaKCmYP
	 eeVbQxyWkNeM6beV4CLtsS7rSLpHEYF3MioVbFBue850Dnv8D720Fg85aHyU5W+vLW
	 IiWUgk+IoA3sCacgP9JcuP1rDNMEZKI8ddHTvwciW/AWEIMCJBRDaFB727iw7MzP9o
	 djsNSFhk/qSqMw+dT+WEUCJvYgRF7JCRHDTYTPsk7UsXPPsHzYM3knPUObuvpUmcka
	 HUDvTNBlV7GgQdwgpWet01JQdWPAvid8BmiUl7q1qWtmrbyJUTJeYJw9mVDnvPxWi3
	 nHlD9WzOVbRRg==
Message-ID: <abdd07c2-5ef8-4edf-93ce-19807fe37368@kernel.org>
Date: Thu, 10 Apr 2025 09:56:52 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] dm: limit swapping tables for devices with zone
 write plugs
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>
References: <20250408235159.4128838-1-bmarzins@redhat.com>
 <20250408235159.4128838-6-bmarzins@redhat.com>
 <2fb19069-5e02-4f5a-9f8a-b362e08dffe3@kernel.org>
 <Z_bVTz1rgfmcPt9h@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <Z_bVTz1rgfmcPt9h@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/10/25 5:15 AM, Benjamin Marzinski wrote:
>>> @@ -1873,11 +1898,17 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>>>  		limits->features &= ~BLK_FEAT_DAX;
>>>  
>>>  	/* For a zoned table, setup the zone related queue attributes. */
>>> -	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
>>> -	    (limits->features & BLK_FEAT_ZONED)) {
>>> -		r = dm_set_zones_restrictions(t, q, limits);
>>> -		if (r)
>>> -			return r;
>>> +	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED)) {
>>> +		if (limits->features & BLK_FEAT_ZONED) {
>>> +			r = dm_set_zones_restrictions(t, q, limits);
>>> +			if (r)
>>> +				return r;
>>> +		} else if (dm_has_zone_plugs(t->md)) {
>>> +			DMWARN("%s: device has zone write plug resources. "
>>> +			       "Cannot switch to non-zoned table.",
>>> +			       dm_device_name(t->md));
>>> +			return -EINVAL;
>>> +		}
>>
>> I am confused with this one. We can only have zone write plugs if the device is
>> zoned. So it seems that the check for "if (dm_has_zone_plugs(t->md)" should
>> really be inside dm_set_zones_restrictions(). Or is this trying to detect a
>> table change that would switch the device from zoned to non-zoned ? If that is
>> the case, regardless of the zone write plug initialization state, we should
>> never allow such change.

And I was wrong on this one: using dm-linear to map only conventional zones of
an SMR HDD, the DM device will *not* be zoned but the underlying device is. So
this check is fine since the dm device will not have wplugs in that case.

> I don't think that, for instance, allowing a linear device stacked on
> top of a zoned device to get remapped to stack on top of a non-zoned
> device runs much more risk than allowing a linear device to get remapped
> in any other case? This is currently allowed, and I don't believe anyone
> has complained about it. I would rather assume that the user knows what
> they are doing, instead of disallowing things that aren't obviously
> wrong, and won't cause system problems if they are (aside from the
> problems that naturally result from putting the wrong device in your
> table line). But if Mikulas and Mike think it would be better to
> disallow this, then I'm fine with that.

OK. Let's leave things as you have now.

>>> +	if (get_capacity(disk) && dm_has_zone_plugs(t->md)) {
>>> +		if (q->limits.chunk_sectors != lim->chunk_sectors) {
>>> +			DMWARN("%s: device has zone write plug resources. "
>>> +			       "Cannot change zone size",
>>> +			       disk->disk_name);
>>> +			return -EINVAL;
>>> +		}
>>> +		if (lim->max_hw_zone_append_sectors != 0 &&
>>> +		    !dm_table_is_wildcard(t)) {
>>> +			DMWARN("%s: device has zone write plug resources. "
>>> +			       "New table must emulate zone append",
>>> +			       disk->disk_name);
>>> +			return -EINVAL;
>>> +		}
>>> +	}
>>
>> I have some concerns about this: what if the new table has the same capacity
>> and the same zone size but the types of zones changed ? We are not checking
>> this here and we cannot actually check that without doing a report zones. So I
>> really think we should just use the big hammer here and simply only allow the
>> wildcard target and no other change.
> 
> I don't see how this could lead to accessing invalid memory, which was
> my big concern, with these patches. The worst that could happen in an IO
> error, AFAICS. Disallowing all table loads except for the error target
> would keep people from being able from things like changing options on
> the dm-crypt target. Again, that is just my preference, and I'll defer
> to Mike and Mikulas on how this should be handled.

Yeah, but these IO errors that can happen would be hard to debug/understand...
But as you said, given that this has never been checked/prevented before and
that no one complained, let's keep this as is. Your example for dm-crypt is
indeed a valid case.

>>>  	/*
>>>  	 * Warn once (when the capacity is not yet set) if the mapped device is
>>>  	 * partially using zone resources of the target devices as that leads to
>>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>>> index 292414da871d..240f6dab8dda 100644
>>> --- a/drivers/md/dm.c
>>> +++ b/drivers/md/dm.c
>>> @@ -2429,6 +2429,12 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
>>>  	size = dm_table_get_size(t);
>>>  
>>>  	old_size = dm_get_size(md);
>>> +
>>> +	if (!dm_table_supports_size_change(t, old_size, size)) {
>>> +		old_map = ERR_PTR(-EINVAL);
>>> +		goto out;
>>> +	}
>>
>> And I guess we could probably move the "wildcard-only is allowed" change check
>> here as that would further simplify the revalidation code. No ?
> 
> If we are disallowing any zoned device to reload its table to something
> other than an error target, then yes. It can go here. If we only care
> about zoned devices that emulate zoned append, when we need to wait till
> dm_set_zones_restrictions() where we determine that. Since we already
> need to handle failures in dm_table_set_restrictions(), moving it
> doesn't simplify the code much.

OK. So with the commit message typos fixed, feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
