Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF281CDA0B;
	Mon, 10 Mar 2025 23:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741648602; cv=none; b=iEz8oerCJIc+/mWiJkVQVZlsytvut1OX/E+2iSWWdL9wiVnJZm+HMUXu99Wv/2QgpJglplXqiDZQlUKcsVZV/7RPV+Lgxxcg4Av9bMitBsGIm5FU4KBsTpDLZZxdFsSi1bhrzUIgkLeC5yhaJ3DkwsOkHzyLsRu+UDtAJkle980=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741648602; c=relaxed/simple;
	bh=6LZhPg/WqxFLpgCMaQms8fGCDa9Yushijqvunj1bDFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BaC3Xd0cXMrxY/tjW8m1eMo6LaSb7GtTfxZkyMBmrA8oJA3FPI/ZK5NTEDKiQIUFDdiQlQyyZN5+DEK9yRBhntpSJuFPmUb520GZSTIYmID0RuH22rnmYLQ2+w/DIA6wftehhq2nnlWsDvgc14R2sjtN5PhmOfuEmRFj2J0Y9Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLf7BABi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLf7BABi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8896C4CEE5;
	Mon, 10 Mar 2025 23:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741648601;
	bh=6LZhPg/WqxFLpgCMaQms8fGCDa9Yushijqvunj1bDFA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cLf7BABi0EzBsIpCURbbBma1wAm8WUtjEQwSeFu/svt1P5IS2remdlAe08wEluHdQ
	 UImQQEMFbCSNpfbUB5GQSNhY0rduSbv/wr28LGzqIkMqWyzOYqTkRXvYdZruTyV2ZJ
	 akfNF4doV3Y7MPfJWvvarba5Fyh1zLn330OVLt5Ii483kGicdmn9TlktYBbq+SqNaT
	 2lh6CZozkG/xiVEHtLYW+gRwZ+Ro33aj/PmVDkwjZaFVdRQS+Q49yYitGO/WyDph90
	 DS9fnkeacC9x4mvHEMTz/GMBgMldpf1UAlm+CCpIlm87RKNsHe6Y4pbYRupbrq5JdC
	 Dc1PkuQhqNQOQ==
Message-ID: <28901e7c-a538-4819-8f46-9a18d8a20bcb@kernel.org>
Date: Tue, 11 Mar 2025 08:16:39 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] dm: handle failures in dm_table_set_restrictions
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <20250309222904.449803-4-bmarzins@redhat.com>
 <9b5ff861-964d-472c-9267-5e5b10186ed3@kernel.org>
 <Z88jTxQqoLitl4ee@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <Z88jTxQqoLitl4ee@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/11/25 02:37, Benjamin Marzinski wrote:
> On Mon, Mar 10, 2025 at 08:25:39AM +0900, Damien Le Moal wrote:
>> On 3/10/25 07:28, Benjamin Marzinski wrote:
>>> If dm_table_set_restrictions() fails while swapping tables,
>>> device-mapper will continue using the previous table. It must be sure to
>>> leave the mapped_device in it's previous state on failure.  Otherwise
>>> device-mapper could end up using the old table with settings from the
>>> unused table.
>>>
>>> Do not update the mapped device in dm_set_zones_restrictions(). Wait
>>> till after dm_table_set_restrictions() is sure to succeed to update the
>>> md zoned settings. Do the same with the dax settings, and if
>>> dm_revalidate_zones() fails, restore the original queue limits.
>>>
>>> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>>> ---
>>>  drivers/md/dm-table.c | 24 ++++++++++++++++--------
>>>  drivers/md/dm-zone.c  | 26 ++++++++++++++++++--------
>>>  drivers/md/dm.h       |  1 +
>>>  3 files changed, 35 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>>> index 0ef5203387b2..4003e84af11d 100644
>>> --- a/drivers/md/dm-table.c
>>> +++ b/drivers/md/dm-table.c
>>> @@ -1836,6 +1836,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>>>  			      struct queue_limits *limits)
>>>  {
>>>  	int r;
>>> +	struct queue_limits old_limits;
>>>  
>>>  	if (!dm_table_supports_nowait(t))
>>>  		limits->features &= ~BLK_FEAT_NOWAIT;
>>> @@ -1862,16 +1863,11 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>>>  	if (dm_table_supports_flush(t))
>>>  		limits->features |= BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA;
>>>  
>>> -	if (dm_table_supports_dax(t, device_not_dax_capable)) {
>>> +	if (dm_table_supports_dax(t, device_not_dax_capable))
>>>  		limits->features |= BLK_FEAT_DAX;
>>> -		if (dm_table_supports_dax(t, device_not_dax_synchronous_capable))
>>> -			set_dax_synchronous(t->md->dax_dev);
>>> -	} else
>>> +	else
>>>  		limits->features &= ~BLK_FEAT_DAX;
>>>  
>>> -	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, NULL))
>>> -		dax_write_cache(t->md->dax_dev, true);
>>> -
>>>  	/* For a zoned table, setup the zone related queue attributes. */
>>>  	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
>>>  	    (limits->features & BLK_FEAT_ZONED)) {
>>> @@ -1883,6 +1879,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>>>  	if (dm_table_supports_atomic_writes(t))
>>>  		limits->features |= BLK_FEAT_ATOMIC_WRITES;
>>>  
>>> +	old_limits = q->limits;
>>
>> I am not sure this is safe to do like this since the user may be simultaneously
>> changing attributes, which would result in the old_limits struct being in an
>> inconsistent state. So shouldn't we hold q->limits_lock here ? We probably want
>> a queue_limits_get() helper for that though.
>>
>>>  	r = queue_limits_set(q, limits);
>>
>> ...Or, we could modify queue_limits_set() to also return the old limit struct
>> under the q limits_lock. That maybe easier.
> 
> If we disallow switching between zoned devices then this is unnecssary.
> OTherwise you're right. We do want to make sure that we don't grep the
> limits while something is updating the limits.
> 
> Unfortunately, thinking about this just made me realize a different
> problem, that has nothing to do with this patchset. bio-based devices
> can't handle freezing the queue while there are plugged zone write bios.
> So, for instance, if you do something like:
> 
> # modprobe scsi_debug dev_size_mb=512 zbc=managed zone_size_mb=128 zone_nr_conv=0 delay=20
> # dmsetup create test --table "0 1048576 crypt aes-cbc-essiv:sha256 deadbeefdeadbeefdeadbeefdeadbeef 0 /dev/sda 0"
> # dd if=/dev/zero of=/dev/mapper/test bs=1M count=128 &
> # echo 0 > /sys/block/dm-1/queue/iostats
> 
> you hang.

Jens just applied a patch series cleaning up locking around limits and queue
freeze vs locking ordering. So we should check if this issue is still there with
these patches. Will try to test that.

-- 
Damien Le Moal
Western Digital Research
