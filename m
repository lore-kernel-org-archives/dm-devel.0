Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0390ADDC3
	for <dm-devel@lists.linux.dev>; Wed,  3 Apr 2024 01:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712106086; cv=none; b=BJI460Nor1bBWYExhI0+BQQLKgdtAYZKJlm7ahvBE0xzLsAI3/g2hPNcgyHw+8VSQLAfAgaqjC0t8hdC/pedzcYbfAEvVEicrLbXagLZGbx0kDvaEtQPItaNJRT/+67/lCDrJmF+0cU1P/DtbAORDyyhBXU2UILHQqTSDW8CpZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712106086; c=relaxed/simple;
	bh=oxq1cMg7RGrZHNssKE2eJeggwHOvoX2G+56i2ws/Nig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dSfDiXUv0iokKrw2CmRSrn8aBpMu6PiMGvGN8KP1zKudEQq/FXNFsEs5R13rrlZv4yy10kwK/Ax5mB8pmotP2bVJPpYsMlf35FKNp0nXU8fm376LmO+5QhF0EVyp7alfqq1VTFaZeyWrx7weEmjXMe/sMRDxlNHb/p91VEmJFzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OY2eRq+6; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OY2eRq+6"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1def81ee762so15321025ad.0
        for <dm-devel@lists.linux.dev>; Tue, 02 Apr 2024 18:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712106083; x=1712710883; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bVq/F6jwmyuusQdHnZ4WViSQjual7NBb8Hrq3g+KgzU=;
        b=OY2eRq+6TxqjJUM2bpZb4UtINkcUuwBnM8/apdjaOFT3GIyaLcaS6Yt7V1Ca6cZh0x
         nxu3dCcs6KmsjzuxjQyt1oA1guor6K6kqHZR23nzQrWqsYn34e0WYDjFlSMg1WcwfDg4
         IEeiU8VFTziy3SgwZPqfEwTMedpA5R8dTGcre4Brw9ixrAF/mI2k8GtnQxLXwyx473Gt
         8y4T5imWxVe7VFXxIO4MgpJrq3IWaZ3Q/NdYIY8Sp2ltst6ylNPhZVtNKEugdsFelcda
         E1f35HsSDUlDhMuq0exzXYrMFutW12pn9jK093z3h3AntPEGyNSTMjNVx6U76/d36u+9
         r82g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712106083; x=1712710883;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bVq/F6jwmyuusQdHnZ4WViSQjual7NBb8Hrq3g+KgzU=;
        b=rVHYQf2nRH9o9AxuCcqynyOAQC86sKql5X6YJuUMHBAsdxSnk5kYBl6mU/1u54LlAt
         nDDduXc/67ruH9pPLxrj19z6pCWTVVrVFIAOYOBBLPM6hOP0bJo5PFg/liCMvSFFkucd
         339h90um7DROk6YqU3ixhX1gBdSRSJFWc5ky2WZzYQDTm9q9GZPkEYp71I0dulrqHmr9
         1p90x7EHdgAVa/4we1MNPDeFwZD+bcNY1GagmBT6eZo0V1NDkbRcwR5k/LkQXlHfuXCT
         85oYZNKn30rJ8H0Bho7f9Y3c1n4QuTltGjnOdnejK/AaaY5Fsdt0L9HS79Yc0KYQRaEJ
         2rxw==
X-Forwarded-Encrypted: i=1; AJvYcCWYJIUnyuJeHk108XV6F2kZPcPU8E8WT/+KqLgWr7DPBg0r5bbgtCmfZ+3G3Z5of3DYhb5NotxciJxKuusiWeN2zo+eh8XfcQk=
X-Gm-Message-State: AOJu0YwCUfI3qXZmk+GwBenijBBJjqTj5ttvxLVDWkIxnIIoVS1Ozf16
	+Hw7Rc+/xQXLqh89t4siCwX2T3y0SEZw/JBiy7+bNQOP0mqBoo1q1KTaZ7ZTsqY=
X-Google-Smtp-Source: AGHT+IGJhXKwl0JdEUOdgu34QyQrsf18ALIOaqHxaO+yI+l2ba4JnRblQLZM3qjRUlxHmlFK3QYxCA==
X-Received: by 2002:a17:902:b18c:b0:1e0:c887:f93f with SMTP id s12-20020a170902b18c00b001e0c887f93fmr15507773plr.1.1712106083237;
        Tue, 02 Apr 2024 18:01:23 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id k5-20020a170902694500b001e038619e34sm11769300plt.221.2024.04.02.18.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 18:01:22 -0700 (PDT)
Message-ID: <a68d7e70-d82f-4a09-8b9c-db5e902a3663@kernel.dk>
Date: Tue, 2 Apr 2024 19:01:21 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/28] block: Introduce zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
References: <20240402123907.512027-1-dlemoal@kernel.org>
 <20240402123907.512027-8-dlemoal@kernel.org> <20240402161213.GB3527@lst.de>
 <e923b1cf-9683-4029-8a39-c66aa8fb2647@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e923b1cf-9683-4029-8a39-c66aa8fb2647@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/2/24 5:38 PM, Damien Le Moal wrote:
> On 4/3/24 01:12, Christoph Hellwig wrote:
>>> +static inline struct blk_zone_wplug *
>>> +disk_lookup_zone_wplug(struct gendisk *disk, sector_t sector)
>>> +{
>>> +	unsigned int zno = disk_zone_no(disk, sector);
>>> +	unsigned int idx = hash_32(zno, disk->zone_wplugs_hash_bits);
>>> +	struct blk_zone_wplug *zwplug;
>>> +
>>> +	rcu_read_lock();
>>> +	hlist_for_each_entry_rcu(zwplug, &disk->zone_wplugs_hash[idx], node) {
>>> +		if (zwplug->zone_no == zno)
>>> +			goto unlock;
>>> +	}
>>> +	zwplug = NULL;
>>> +
>>> +unlock:
>>> +	rcu_read_unlock();
>>> +	return zwplug;
>>> +}
>>
>> Did we lose an atomic_inc_unless_zero here?  This now just does a lookup
>> under RCU, but nothing to prevent the zwplug from beeing freed?
> 
> Nope. When disk_lookup_zone_wplug() is called directly, it is always
> for handling requests/bios which are holding a reference on the plug
> and because there are requests/BIOs in-flight, the plug is marked as
> busy (BLK_ZONE_WPLUG_PLUGGED or BLK_ZONE_WPLUG_ERROR are set). In such
> state, the plug is always hashed given that
> disk_should_remove_zone_wplug() retturns false for busy plugs. So
> there is no reference increase here. The atomic_inc_not_zero() is in
> disk_get_zone_wplug() which calls disk_lookup_zone_wplug() +
> atomic_inc_not_zero() within an rcu_read_lock()/rcu_read_unlock()
> section.

But doing a lookup under rcu, dropping it, and then returning the unit
without an increment is just a horrible pattern. Regardless of whether
it's safe or not. And as most callers do the atomic_inc anyway, some of
then outside rcu lock, this looks horrible buggy.

Please just unify it all and have it follow the idiomatic rcu lookup
pattern, which is:

rcu_read_lock();
item = lookup();
if (atomic_inc_not_zero(item->ref)) {
	rcu_read_unlock();
	return item;
}

rcu_read_unlock();
return NULL;

as that is well understood, and your code most certainly does not look
safe nor sane in that regard.

And probably kill that atomic_inc() helper you have as well while at it.

-- 
Jens Axboe

