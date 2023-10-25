Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AE5125A8
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 07:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFrRZTKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDB8C433C8;
	Wed, 25 Oct 2023 07:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698217898;
	bh=gRKDOBt1rpkyoGCs6mtl7AwpDYmlEG4GkE3o6sEByBM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NFrRZTKe6JPAYWGV6CnDKR+o59PzVlcu7Otq2s+NR2OHNUuCitumXMnGS1JT8/uQj
	 2JI0ARg7zJnpwf8LEri56B+lLjGj9WjjKOOhmhoehi9mpF99X3mWcm+AhwYVBKKQiy
	 7z/YxLIGnjm0IvstDWhcHTRjefDxK9X7Et4RI6f1v4IPFu6Ujynu87W5S3i25FgDa2
	 5phGfYLkti+msJL8ZzuHF+DF6XFXoI5suBvQ6YYyoGd9NVWRikMkllVTnUgxSeYQpf
	 k3mZWWNgtied+wwNdhtBff9wxhQ+FC+7Q33MlzJvJbj6IyhPxceGqXgvMmeQyaR/a1
	 0Sl1RMT1bzgqw==
Message-ID: <5c5e2e8e-7d4b-4a61-880d-4009903441a6@kernel.org>
Date: Wed, 25 Oct 2023 16:11:36 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: error: Add support for zoned block devices
Content-Language: en-US
To: Naohiro Aota <Naohiro.Aota@wdc.com>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
References: <20231023224513.344380-1-dlemoal@kernel.org>
 <fuyglwmrwyvrx6w3vwi2zlkpxqc5mafnf5cehill5vovnwfhmh@ddzacow35ki5>
 <8410daaa-8f6e-46bd-ae4a-c9c362156b77@kernel.org>
 <khah3n74c2rnfpz23thr2ue3qxiekuvklykuukaoyiblivh6gc@3xcwytv7ofkm>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <khah3n74c2rnfpz23thr2ue3qxiekuvklykuukaoyiblivh6gc@3xcwytv7ofkm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/25/23 15:21, Naohiro Aota wrote:
> (Updating dm-devel address...)
> 
> On Wed, Oct 25, 2023 at 02:53:17PM +0900, Damien Le Moal wrote:
>> On 10/25/23 14:22, Naohiro Aota wrote:
>>> On Tue, Oct 24, 2023 at 07:45:13AM +0900, Damien Le Moal wrote:
>>>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>>>> index 37b48f63ae6a..5e4d887063d3 100644
>>>> --- a/drivers/md/dm-table.c
>>>> +++ b/drivers/md/dm-table.c
>>>> @@ -1600,6 +1600,9 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>>>>  	for (unsigned int i = 0; i < t->num_targets; i++) {
>>>>  		struct dm_target *ti = dm_table_get_target(t, i);
>>>>  
>>>> +		if (dm_target_is_wildcard(ti->type))
>>>> +			continue;
>>>> +
>>>
>>> This seems tricky to me. Currently, dm-error is the only dm target having
>>> DM_TARGET_WILDCARD. But, can we expect that will be so forever?
>>
>> Yes, I saw that. Not sure. Mike ?
>>
>>> Also, I considered what happens if the backing device is non-zoned
>>> one. dm_table_supports_zoned_model() returns true in that case. But, it is
>>> still reported as non-zoned as we copy non-zoned queue limits. So, it is
>>> OK ... but it is a bit tricky.
>>
>> Returning true for dm_table_supports_zoned_model() is not an issue. As the name
>> of the function says, this checks that the device table is OK with zoned device
>> but does not force the dm device to be zoned.
> 
> I see. I just think it's confusing as it also checks the backing devices
> for other cases.

The checks are for target types and devices, to ensure that they are compatible.
dm-error has no backing device, so the checks are reduced to checking the target
type flags for zone support.

>>> Instead, how about implementing the .iterate_devices just like
>>> linear_iterate_devices?
>>
>> Because that would change how dm-error needs to be setup. Currently, there are
>> no arguments needed for the table entry for dm-error. If we define the
>> ->iterate_devices operation, we'll need a backing device and mapping start
>> sector. Changing the dmsetup command line for all users is probably not the best
>> approach... Unless I am missing something...
> 
> I thought we could just return 0 when there is no backing device. But, I see,
> we need a start sector to call the callback function, which is pain.
> 
> Then, how about continue the loop if (dm_target_supports_zoned_hm(ti->type)
> && !ti->type->iterate_devices) ? The target declares itself supporting
> zoned_hm and having NULL iterate_devices implies there is no backing
> device. Then, we can say that target supports the zoned model naturally.

We could, but the point is that dm-error cannot be combined with other targets
in a single table. If dm-error is used, it is everything, so there is no point
in the iterate device loop. This is confusing as many examples out there seem to
imply that dm-error can be used to emulate errors for a range of sectors only
but that does not work.

E.g., something like this:

dmsetup create err_disk << EOF
  0 8 linear $dev 0
  8 1 error
  9 $disk_size linear $dev 9
EOF

does not work because dm-error does not have an iterate_devices method.

This is why I implemented the zone support like I did instead of touching the
iterate loops.

But I would like to hear from Mike about this if there is a better way of doing
things.

-- 
Damien Le Moal
Western Digital Research

