Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833E32FF660
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 17:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763571671; cv=none; b=ED8HUyfx/ZEPcAVHvPIyBdvd5NHEEPWIreEPUpprcSr7cYbQm9cAB0qTAa80IP0pRYvG1G3petS/3yuHWRQnD5aI0HK0WeMCmTFngqFp+zLoGlni5JlrDTQdCoslgja9Ssqa7Y17wE934UAVAQQKZ1ncF8aO0AFViBpJWdQmAoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763571671; c=relaxed/simple;
	bh=S+g2O7p94RosAqIDLahmLjRW/MydzsAFbfENsPa65W8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kaBibh+AoNDXQ9brV5cZ3p1CW9qsY4pD0WDHZgePWV1L6VepALwGlbVVwq+gBMkOnYUJObHCbF7bWYYcKly61ib93gGNmZ9L1yhYjgSwiiRHcHHhs19tsobwyjr6UrShA7wIVZTI2nEnBf05Q64q6PJukI6fhUm1+KEq23+u6Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qetSyNDp; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qetSyNDp"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-94905c3e2a4so46061639f.1
        for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 09:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763571668; x=1764176468; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cPw9uCkFvNA6PQCNX1TL4ZbkMo01ysJzYJr/l6U8Vyk=;
        b=qetSyNDptarYhZUEBImZ33tgmQxvy1cqdE7mpqVxix59NqVp/A7nnjVFfX3K9jIPFB
         LGkK0yBTykdCtP8XK+bPzBgUdWRgqhP39qSr9G9HGKqWQR6giYTJAX4hKlkzZvgejhbw
         KpYXvgjtji8wV+Du3Sr1gExsPO/K1bfpqepQhFkwEGHS0I8ZkTQGU5UJ0lPcBAWO0DIz
         HMLxOa+AsEkIoM8qcYuUFDMEOScU4fMpdWT4xRbHGtxrSrv7EuE+zIv1vyjXJC+cwooE
         +MxiJI9vo9nhItROXe0H6XMlImNdPO+0P3Fl6vX7MlDfYeyn+wUAK9WiYgi4UZywu6KW
         kqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763571668; x=1764176468;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cPw9uCkFvNA6PQCNX1TL4ZbkMo01ysJzYJr/l6U8Vyk=;
        b=vfbh8W3YU7UozURHO6yz2YhAvi+2ugMhJisM1Sf8wzl8CR4utRRi5ugVlZEg7oIBI+
         BjXF76NCuQ4jvX0LqKkbxmR2sq+A3bzgj+Gk2L2u1cPT+hvDimG84YRi/zJobgK231wB
         CW2uvJtjDulXSqOiZBMs6WT3d2p918lHxGm7JO7hQp5sqg3W61rfj4Knoufl7RUF2BYb
         DUr+1dloGo0uYCbow5cVX9A825AplGW41JvSLhXKpl15G2PM0B8dkApg5gS9IGQKg1AJ
         lD/hmhNLLmv/hf0bOvJi1841AVhLZ28bh0/VuTd3ktH1zhUU8PqNSJgwQWiOAdsMphb7
         tMZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdyiE2DsFS7GYeb1+x9KChbFgeIXQV5MUTLzZdPZ3IQjSWadoxjcYrwK7ICRIKG2cHDruHWvv/Uw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxWQ0ySTAk3lAaNEOWlvxNaTInmGR7EqWdRXmXAZlu5k1G7cjp4
	Bj9UTC6jYkCS/8ZBHqxMay0BZwDXS6RfPyK53ZNrpzkqRVPlb1JH0Xiv/qqy1DCjMPk=
X-Gm-Gg: ASbGncu8ZMrg6PW1OVdOQHK3hAcMbWohZGpJiK/+FrHZ03xt91kLxPL/3yAJivYWYr9
	CLyydIv1hijaR76TpHq2+noE682u107mvZEzFtnOW0D7lSWYVGDwTGruJvEHO6Yd4wcgjVxir54
	k0Zltmq9HMPa9Rkk5+x6Z1hZd3YHlFj6VScP2Ltx6S5MtqxzQ970NMtjiNiNFDNGtgaNT1YsLca
	FlgJHmoHkXkXfQkkKCXFQFgPIy/deo0OE16hGaez71SbjV26knBeIImfLOaiXQsNEuZsulPXLRh
	WmABLfnC9/S6UifqYC1Jv95Yi+wq2r7odOuSi4jnlzf4jW+gBnuxZcdYG4yv1eGIbX/3Vkror+2
	98FzJOGRFuZaiSraCKaarIns3vLDRD0OEnjR4VmxzZZ3S3H6G8lxYJaMZLxgBwR7kxbjDg27zb1
	8190vpDko=
X-Google-Smtp-Source: AGHT+IE2kxjS0yAG6GVYp2OCmpVNdv4loPq+aa5O9jQG6Qcw+IMJqxGOrGh2WjEVj74aOlxlbHQ9xw==
X-Received: by 2002:a05:6638:c1e8:b0:562:6587:e697 with SMTP id 8926c6da1cb9f-5b80c3bc4d6mr3251546173.2.1763571654771;
        Wed, 19 Nov 2025 09:00:54 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7bd32e141sm7591110173.44.2025.11.19.09.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 09:00:54 -0800 (PST)
Message-ID: <7cf8b8de-0ed9-4182-aa84-de29f16f37f0@kernel.dk>
Date: Wed, 19 Nov 2025 10:00:51 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: add a flag to allow underordered zoned writes
To: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev
References: <20251118070321.2367097-1-hch@lst.de>
 <f385de59-5bef-4ddf-b363-edf76f88d855@acm.org>
 <20251119075800.GA23083@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251119075800.GA23083@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/25 12:58 AM, Christoph Hellwig wrote:
> On Tue, Nov 18, 2025 at 10:10:33PM -0800, Bart Van Assche wrote:
>> Is the following deadlock inherent to this approach?
>> - Several bios are present on zwplug->bio_list and these bios cannot be
>>   submitted because their starting offset is past the write pointer.
>> - No new bios can be allocated because all memory is in use.
>> - A deadlock occurs because none of the queued bios can be submitted
>>   and no new bio can be allocated.
> 
> This can if the number of in-flight bios is larger than bio mempool
> reserve.  Which is real, but we also have this in various other
> submitters that hold bios to submit in a list.  This suggests it is
> mostly theoretical, but I'd still love to address it for all these
> cases.

The default bio pool size is 2 entries, which is perfectly fine for the
"normal" alloc-and-submit cases. But yes if you're doing a bunch of
allocations before submitting, then it could certainly deadlock if the
normal allocation fails and we end up sleeping in the mempool waiting
for previous unsubmitted IO to finish.

It's certainly a bit tricky to handle... But definitely something we
should take a stab at, as it basically voids the forward progress
guarantee and is surely something that will cause production workload
deadlocks if REQ_ZWPLUG_UNORDERED is used.

-- 
Jens Axboe
