Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE39FDDD4;
	Fri,  5 Jul 2024 01:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141714; cv=none; b=tzH1LIbb1b/EJ5cfSWzyevt1skMgQBYEJugBatcNcYvQT7KY13fo18TRsjeSmQYwVsz6rPmFDs8+MRxLQ/Ah/VESJA+AhxyBWrUw/kOEoidvTx+bT6UjldX6yckidFeEjsDAnunEje8nYRFl72/B7ps/Hq2A/59Qtjw+oNUY/bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141714; c=relaxed/simple;
	bh=HXe0ywAFlOXtUCdSL6OqLY+vhisCdaCJNOQRsWkmYYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RoIT0E+975cua4mG2xtvmbvreEwz2IuY+OHJkCI1zLkFap+1OhpuHtSv6W36Owey7QHlRP3q1sbzFXypjmFGztsj6DvN2maMvrkzXlVYIysqcYSoVu6Omz1nWCmIyha9Sx8S+vG1kNpZdyhovXDSZ8MAumoypfM16eiqXwohD3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QhsXGNnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QhsXGNnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597F5C3277B;
	Fri,  5 Jul 2024 01:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720141714;
	bh=HXe0ywAFlOXtUCdSL6OqLY+vhisCdaCJNOQRsWkmYYE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QhsXGNnIQWRaMQi5EHMsvYD6Mk1fJQNl4KB0usxy+ekI8z9VXN8ExFaxK3qchpD+/
	 NMZ/6B/KWmGwJ73TrkNfMB6QXKm31Qstz+5vlnWaZmThpw2D+it9tj7LQeyzNZUbEC
	 MktYlS/4w1MaKwjyg3TVdDCBuNp+HW3qh2F2gXubgzE1N/ae/52/N+Yfg5jsYvUCy+
	 O92qncv4bIUU3/MSE7LJFx5T0wIVO/ssg25V7YrnlknVoxvOc+BDXnn2Y9Kkgi0Mkk
	 bl+UIhXpGjPAEkzI7kQUkxxI0HkDpa3oodmMY/LM+2+38T5+cE89Ku3Zrh8zkAsuuF
	 DC2sTIkNr+mJA==
Message-ID: <afefbd10-e680-47c3-bd18-b3f2aae35a15@kernel.org>
Date: Fri, 5 Jul 2024 10:08:32 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-table:fix zone block_device not aligned with zonesize
To: Mikulas Patocka <mpatocka@redhat.com>, Li Dong <lidong@vivo.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 "open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>,
 open list <linux-kernel@vger.kernel.org>, opensource.kernel@vivo.com
References: <20240704151549.1365-1-lidong@vivo.com>
 <cd05398-cffa-f4ca-2ac3-74433be2316c@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <cd05398-cffa-f4ca-2ac3-74433be2316c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/5/24 00:29, Mikulas Patocka wrote:
> 
> 
> On Thu, 4 Jul 2024, Li Dong wrote:
> 
>> For zone block devices, device_area_is_invalid may return an incorrect 
>> value.
>>
>> Failure log:
>> [   19.337657]: device-mapper: table: 254:56: len=836960256 not aligned to
>> h/w zone size 3244032 of sde
>> [   19.337665]: device-mapper: core: Cannot calculate initial queue limits
>> [   19.337667]: device-mapper: ioctl: unable to set up device queue for 
>> new table.
>>
>> Actually, the device's zone length is aligned to the zonesize.
>>
>> Fixes: 5dea271b6d87 ("dm table: pass correct dev area size to device_area_is_valid")
>> Signed-off-by: Li Dong <lidong@vivo.com>
>> ---
>>  drivers/md/dm-table.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index 33b7a1844ed4..0bddae0bee3c 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -257,7 +257,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>>  	if (bdev_is_zoned(bdev)) {
>>  		unsigned int zone_sectors = bdev_zone_sectors(bdev);
>>  
>> -		if (start & (zone_sectors - 1)) {
>> +		if (start % zone_sectors) {
>>  			DMERR("%s: start=%llu not aligned to h/w zone size %u of %pg",
>>  			      dm_device_name(ti->table->md),
>>  			      (unsigned long long)start,
>> @@ -274,7 +274,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>>  		 * devices do not end up with a smaller zone in the middle of
>>  		 * the sector range.
>>  		 */
>> -		if (len & (zone_sectors - 1)) {
>> +		if (len % zone_sectors) {
>>  			DMERR("%s: len=%llu not aligned to h/w zone size %u of %pg",
>>  			      dm_device_name(ti->table->md),
>>  			      (unsigned long long)len,
>> -- 
>> 2.31.1.windows.1
> 
> Hi
> 
> This probably won't compile on 32-bit architectures because the operators 
> for 64-bit divide and modulo don't work there.
> 
> Please, rework the patch using dm_sector_div64.

This patch alone will not allow non power of 2 zone size drives to be supported
as the block layer will reject such drive in the first place. This patch should
be part of a larger series enabling such support. On its own, it is a NACK from
me for this change.

-- 
Damien Le Moal
Western Digital Research

