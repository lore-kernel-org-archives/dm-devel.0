Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B38F5258;
	Tue, 11 Mar 2025 00:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741651260; cv=none; b=ZkX3ua1IfCDzXPKjsDjgui4Vkfg5JNXm0CweE0gYKseDxXx3l4I/tLKt3XZJ4kDGLfrOIvpspjO73dwqRjIgEONluC1I5aE6BoZ6Dz4Fohz7iqQxujqGr/8JNVnx4O1HPOqgkwRJhQloPL3YTM0hzvNO6u37JVkm26iKPMdJL0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741651260; c=relaxed/simple;
	bh=/TPN2tuwQS7g2pZFqu9CAb3x0cuedC161qmzjfTvCpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DCvm+mE9/1XOrOlZxKpsUCML14EZPAMZsELKvekRRcGMaoy9Oygv9S3P8WD8XGVhiIUwKLaP6yr8DaV/F7Gl6e47oEW9/tGH+L/RqonxsKXfhu24jdQbdc4RdAA6dbMACcxjV+0rEbQ+PM1tkVxgYQJi0WZhF8oBTujONIMRAyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s5B85Fqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s5B85Fqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23367C4CEE5;
	Tue, 11 Mar 2025 00:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741651260;
	bh=/TPN2tuwQS7g2pZFqu9CAb3x0cuedC161qmzjfTvCpo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s5B85FqtcQyKUaEY9Y6o6TODxVMr33jBUE09nPtUqFY5/jBRHnKWz9xFTYsMCruMj
	 ajv74Lnx1bJu+yQGhO12XlN30umAm3YW/PD7G9kEnEs3o5ZBVL0KTjZ5BWru/fKitT
	 SUY7rP90yQLwM/koZ1LviJbalFFzKzaH0wmwRuBGEuLwthwmuF2XDvFkokG3fh6yVU
	 bIAZau+54EjhGL5AmWK9AyfkLEjugzraGlAZUYSje0gZTXhK3sz3JqDCEBdn7aGlee
	 /h0Q6l44gBFND0iYmDA9sSjSSJG2uRdbU2OvplXgxGjWvoBXdAra65CpxI8G6uL9tO
	 QFFcwnbpGfV9Q==
Message-ID: <cde5f2fb-a7af-49a3-b660-382f4ad80fbe@kernel.org>
Date: Tue, 11 Mar 2025 09:00:58 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 7/7] dm: allow devices to revalidate existing zones
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <20250309222904.449803-8-bmarzins@redhat.com>
 <7e0a1b47-3c96-4864-80b0-813f357845ad@kernel.org>
 <Z88k2RD6s5KpuxOD@redhat.com>
 <ab56c408-c98d-4333-b4f1-c3f380008e12@kernel.org>
 <Z8948_PSARorliqn@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <Z8948_PSARorliqn@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/11/25 08:42, Benjamin Marzinski wrote:
> On Tue, Mar 11, 2025 at 08:19:29AM +0900, Damien Le Moal wrote:
>> On 3/11/25 02:43, Benjamin Marzinski wrote:
>>> On Mon, Mar 10, 2025 at 08:59:26AM +0900, Damien Le Moal wrote:
>>>> On 3/10/25 07:29, Benjamin Marzinski wrote:
>>>>> dm_revalidate_zones() only allowed devices that had no zone resources
>>>>> set up to call blk_revalidate_disk_zones(). If the device already had
>>>>> zone resources, disk->nr_zones would always equal md->nr_zones so
>>>>> dm_revalidate_zones() returned without doing any work. Instead, always
>>>>> call blk_revalidate_disk_zones() if you are loading a new zoned table.
>>>>>
>>>>> However, if the device emulates zone append operations and already has
>>>>> zone append emulation resources, the table size cannot change when
>>>>> loading a new table. Otherwise, all those resources will be garbage.
>>>>>
>>>>> If emulated zone append operations are needed and the zone write pointer
>>>>> offsets of the new table do not match those of the old table, writes to
>>>>> the device will still fail. This patch allows users to safely grow and
>>>>> shrink zone devices. But swapping arbitrary zoned tables will still not
>>>>> work.
>>>>
>>>> I do not think that this patch correctly address the shrinking of dm zoned
>>>> device: blk_revalidate_disk_zones() will look at a smaller set of zones, which
>>>> will leave already hashed zone write plugs outside of that new zone range in the
>>>> disk zwplug hash table. disk_revalidate_zone_resources() does not cleanup and
>>>> reallocate the hash table if the number of zones shrinks.
>>>
>>> This is necessary for DM. There could be plugged bios that are on on
>>> these no longer in-range zones.  They will obviously fail when they get
>>> reissued, but we need to keep the plugs around so that they *do* get
>>> reissued. A cleaner alternative would be to add code to immediately
>>> error out all the plugged bios on shrinks, but I was trying to avoid
>>> adding a bunch of code to deal with these cases (of course simply
>>> disallowing them adds even less code).
>>
>> I am confused now :)
>> Under the assumption that we do not allow switching to a new table that changes
>> the zone configuration (in particualr, there is no grow/shrink of the device),
>> then I do not think we have to do anything special for DM.
> 
> If we don't allow switching between zoned tables, then we obviously
> don't need to make DM call blk_revalidate_disk_zones() on a zoned table
> switch. I was just saying that I know that this patch would leave
> out-of-range zone plugs behind on a shrink, but that is necessary to
> allow shrinking while there could still be outstanding plugged bios
> attached to those plugs.
> 
> So, if we wanted to allow shrinking, then I think this patch is correct
> (although erroring out all the out-of-range bios would be a cleaner
> solution). But assuming we don't allow shrinking, then you are correct.
> We don't need to do anything special for DM.

OK. Got it.
As mentioned, I think we really still need to allow switching (or inserting ?)
dm-error. In that case, calling blk_revalidate_disk_zones() should still be fine
as long as there is no change to the zone config, which is true for dm-error. Do
you agree ?


-- 
Damien Le Moal
Western Digital Research
