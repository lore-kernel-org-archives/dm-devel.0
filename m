Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A53E261573;
	Wed, 25 Jun 2025 12:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750856090; cv=none; b=EGcnJB6Q6hv2NzLimvqCu6V6Mjav/WoBmreYGzM5L1zmTpNYfz1XaMFdiIANxxG7IhJ0HtNnqaI/Dqwklh2r0RGx8ytaWjUKchHEiXZ7N/AalG1wq9lw+EfIjzVGW9rCg5qLwlzd2VpG4VrKcuqd+Q1LVm92piA8sJIc1fpcR4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750856090; c=relaxed/simple;
	bh=nw+EqUMsJnRR1nDSTj/B3Pymkp2IlKbQj0K1fAYq1HY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=foV4E0937PTEMrZMUTwT/ZVO++CBi/tmJhZI89EuVojwn9pT1ICvZ9fd8vNP86vkylkc4fjWbhtQC3me3uk4iKJ8nV1Y53JaklA7Vo8mu2ECkOoLWquK+xSid1WVUUZ16vSIRNU3n+0V7pKmIZUiBfeBEXtgKNGum3kW5XWAG/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nq6fJ15X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nq6fJ15X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57343C4CEEA;
	Wed, 25 Jun 2025 12:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750856090;
	bh=nw+EqUMsJnRR1nDSTj/B3Pymkp2IlKbQj0K1fAYq1HY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nq6fJ15XM/Te3gwwY33N29uhT1cIzFWtDTBG/1KwbrIVaD0BpaqHftQEz/Aw4Hi9z
	 B1LQAGYutlAKfno0qTWgp+BdRVRYCgK7wQBJM6ZsnjV0s3cji9mmwiNzyl/Rxxue6E
	 824tZElht1j9Sk5ChAm2D46vcqpSYG1mist/H8Y/dDhkvyLls6W60t6PMWyhUyQCQu
	 qh+YLWhq24EBMb9Mtr5KFtxH3UnKQsrT6KH/gCSpppRiW+11P2uDMigUZSsqHYjVxt
	 BFdApBpx47imiqKrP4/UgqgWBUv8FGiHCXkGnmkrv0/NRpVqvMjBa4T3PJN3ckDw/V
	 sVIJpuN2K/R1g==
Message-ID: <07d71ad1-a6de-474b-bee4-a64180284802@kernel.org>
Date: Wed, 25 Jun 2025 21:54:48 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] dm: dm-crypt: Do not split write operations with
 zoned targets
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Bart Van Assche <bvanassche@acm.org>
References: <20250625055908.456235-1-dlemoal@kernel.org>
 <20250625055908.456235-4-dlemoal@kernel.org>
 <96831fd8-da1e-771f-7d19-8087d29f2af1@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <96831fd8-da1e-771f-7d19-8087d29f2af1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/25 19:19, Mikulas Patocka wrote:
> 
> 
> On Wed, 25 Jun 2025, Damien Le Moal wrote:
> 
>> Read and write operations issued to a dm-crypt target may be split
>> according to the dm-crypt internal limits defined by the max_read_size
>> and max_write_size module parameters (default is 128 KB). The intent is
>> to improve processing time of large BIOs by splitting them into smaller
>> operations that can be parallelized on different CPUs.
>>
>> For zoned dm-crypt targets, this BIO splitting is still done but without
>> the parallel execution to ensure that the issuing order of write
>> operations to the underlying devices remains sequential. However, the
>> splitting itself causes other problems:
>>
>> 1) Since dm-crypt relies on the block layer zone write plugging to
>>    handle zone append emulation using regular write operations, the
>>    reminder of a split write BIO will always be plugged into the target
>>    zone write plugged. Once the on-going write BIO finishes, this
>>    reminder BIO is unplugged and issued from the zone write plug work.
>>    If this reminder BIO itself needs to be split, the reminder will be
>>    re-issued and plugged again, but that causes a call to a
>>    blk_queue_enter(), which may block if a queue freeze operation was
>>    initiated. This results in a deadlock as DM submission still holds
>>    BIOs that the queue freeze side is waiting for.
>>
>> 2) dm-crypt relies on the emulation done by the block layer using
>>    regular write operations for processing zone append operations. This
>>    still requires to properly return the written sector as the BIO
>>    sector of the original BIO. However, this can be done correctly only
>>    and only if there is a single clone BIO used for processing the
>>    original zone append operation issued by the user. If the size of a
>>    zone append operation is larger than dm-crypt max_write_size, then
>>    the orginal BIO will be split and processed as a chain of regular
>>    write operations. Such chaining result in an incorrect written sector
>>    being returned to the zone append issuer using the original BIO
>>    sector.  This in turn results in file system data corruptions using
>>    xfs or btrfs.
>>
>> Fix this by modifying get_max_request_size() to always return the size
>> of the BIO to avoid it being split with dm_accpet_partial_bio() in
>> crypt_map(). get_max_request_size() is renamed to
>> get_max_request_sectors() to clarify the unit of the value returned
>> and its interface is changed to take a struct dm_target pointer and a
>> pointer to the struct bio being processed. In addition to this change,
>> to ensure that crypt_alloc_buffer() works correctly, set the dm-crypt
>> device max_hw_sectors limit to be at most
>> BIO_MAX_VECS << PAGE_SECTORS_SHIFT (1 MB with a 4KB page architecture).
>> This forces DM core to split write BIOs before passing them to
>> crypt_map(), and thus guaranteeing that dm-crypt can always accept an
>> entire write BIO without needing to split it.
>>
>> This change does not have any effect on the read path of dm-crypt. Read
>> operations can still be split and the BIO fragments processed in
>> parallel. There is also no impact on the performance of the write path
>> given that all zone write BIOs were already processed inline instead of
>> in parallel.
>>
>> This change also does not affect in any way regular dm-crypt block
>> devices.
>>
>> Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>  drivers/md/dm-crypt.c | 49 ++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 39 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
>> index 17157c4216a5..4e80784d1734 100644
>> --- a/drivers/md/dm-crypt.c
>> +++ b/drivers/md/dm-crypt.c
>> @@ -253,17 +253,35 @@ MODULE_PARM_DESC(max_read_size, "Maximum size of a read request");
>>  static unsigned int max_write_size = 0;
>>  module_param(max_write_size, uint, 0644);
>>  MODULE_PARM_DESC(max_write_size, "Maximum size of a write request");
>> -static unsigned get_max_request_size(struct crypt_config *cc, bool wrt)
>> +
>> +static unsigned get_max_request_sectors(struct dm_target *ti, struct bio *bio)
>>  {
>> +	struct crypt_config *cc = ti->private;
>>  	unsigned val, sector_align;
>> -	val = !wrt ? READ_ONCE(max_read_size) : READ_ONCE(max_write_size);
>> -	if (likely(!val))
>> -		val = !wrt ? DM_CRYPT_DEFAULT_MAX_READ_SIZE : DM_CRYPT_DEFAULT_MAX_WRITE_SIZE;
>> -	if (wrt || cc->used_tag_size) {
>> -		if (unlikely(val > BIO_MAX_VECS << PAGE_SHIFT))
>> -			val = BIO_MAX_VECS << PAGE_SHIFT;
>> -	}
>> -	sector_align = max(bdev_logical_block_size(cc->dev->bdev), (unsigned)cc->sector_size);
>> +	bool wrt = op_is_write(bio_op(bio));
>> +
>> +	if (wrt) {
>> +		/*
>> +		 * For zoned devices, splitting write operations creates the
>> +		 * risk of deadlocking queue freeze operations with zone write
>> +		 * plugging BIO work when the reminder of a split BIO is
>> +		 * issued. So always allow the entire BIO to proceed.
>> +		 */
>> +		if (ti->emulate_zone_append)
>> +			return bio_sectors(bio);
> 
> The overrun may still happen (if the user changes the dm table while some 
> bio is in progress) and if it happens, you should terminate the bio with 
> DM_MAPIO_KILL (like it was in my original patch).

I am confused... Overrun against what ? We are now completely ignoring the
max_write_size limit so even if the user changes it, that will not affect the
BIO processing. If you are referring to an overrun against the zoned device
max_hw_sectors limit, it is not possible since changing limits is done with the
DM device queue frozen, so we are guaranteed that there will be no BIO in-flight.

I am not sure about what kind of table change you are thinking of, but at the
very least,  dm_table_supports_size_change() ensure that there cannot be any
device size change for a zoned DM device. And given the above point about limits
changes, I do not see how a table change can affect the BIO execution.

Do you have a specific example in mind ?

Or is it maybe the if condition that is confusing ?

	if (ti->emulate_zone_append)

applies to the target, so *all* write operations (emulated zone append writes
and regular writes) will be handled by this and bio_sectors(bio) returned, thus
avoiding a split for all write operations. Maybe using:

	if (bdev_is_zoned(bio->bi_bdev))

would be clearer ?

-- 
Damien Le Moal
Western Digital Research
