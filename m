Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06AC4F888
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 23:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668470; cv=none; b=RdgwH++qvpm/bK/taPj4cUal8BItEl3RXIDA2UXG0JtGm20P2QubPKet145qqUxWjcn3CQwJDXTKLYQJSG4qGDCt0FusiZ4QM1X4HPNA82Azr4fz+/ANrKensUDsDPbLxIauEXBsOOykWHUHeKYarJJkZWVvK21o7fydca7nH88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668470; c=relaxed/simple;
	bh=ru98vq4enDKJaA6AbOY6HePE6BW/e39AtqUFr1SA1eU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XtKrCJ54DoYhesLC8Fqf0iDcBSnqhbbtUOp92kSYjcX8bPO7g0gVdOA/KNcVWbVg/HBbsrKotNumBVUdJK3ZH/Xtkmi6HjxTC6iyyN00dt2+DqvC/iLnf98GtO9LBqRemUQSFMTJU+jLl6mFQXfHciqs75jx+gjIgrmuKL/EZU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QFwLwBSC; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QFwLwBSC"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dd3c6c8dbbso2233825ad.1
        for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 16:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711668468; x=1712273268; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bCjm33wW7K1Ph4Bsfelc544yZvvykuRqTR/BQI/H9BQ=;
        b=QFwLwBSC0nnvKeExNnSvuI0Aq5ft/6kkIFMJKkIEJr5EAirTYvRMGewb8WrvihblWN
         HNCcDwvspzutPPZDXPUN1VDrBPqx/1hWy/UTYFIi9vM/54m7PdyI2fztGh17OqEVVk4A
         AKAXtx8+9181M53fU6wtZQYVwTNRRjmTgdxp9fpO3ppqPDymk1Ob0kSBBzNudWb9w0z7
         hvY6kMBwiTR3Q3KMrTIfB+hVPV+pEZvB+SGC2poapMo2+DrdAOR+W+ve6Bd4FIt+g0xc
         FIEj9Z8vfOodFzYd7W1xfbA9i8x0oyLBzi7xEM3UOkkamajsmCZ1eOIjCcYPWUtzgsQS
         27MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711668468; x=1712273268;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bCjm33wW7K1Ph4Bsfelc544yZvvykuRqTR/BQI/H9BQ=;
        b=RN5Hq2s0bkbu5eRAigfwMIsCo3/qlzPGX6NrHxE0PZQRz5vX+lfs+U0SimD09HMrbu
         Mr8vZlP5uz7J8J4vvL1l1CfPRQrmvyZP8PPkYPlhtPfPbePprThHZxL927mXC2vx4MyH
         EHVaExbiM0Q6hXr7f9HJbehZvD1HztFRzS7QbV4ODg7zerL6DZPIpP7VdKwW1G77Re9F
         vfRHAWk5uVylZ+AMDJd9IBdI/QetjL4cw5AzYX6rYDupwUNyHK1O0FAqPJr2BIP0uYlC
         r5PtLW97Zg4UGqlBMleIxc7AERB1pvMMubFR53+E+vkV9oOfyUG0YgADwsF0gNQOEjtl
         PLBA==
X-Forwarded-Encrypted: i=1; AJvYcCW5F6svpFQX0RQHXblVE6l2p1Ex6Z+1LzScTO+E5BAcSFTI+4c1XUKyD1yv0jV58OgvkB23OlVbIL5wn+XiSEiGyaxp58MjRTU=
X-Gm-Message-State: AOJu0YyXj6dS19t59xTSpBx6EDp9l4YJjoI11082lzR1c92quSMDRQqh
	SatvQXka0L+H3EhQAVp/HvUAp8cl5/DRVpE/wQG/7N7EpqsobgLgUp2K+Hp+0/Q=
X-Google-Smtp-Source: AGHT+IEzRSgPscwrQROpiBW893aXOX7Rqe6qefWWB6pwH5sKBp8T5k7GdQKDIPe0gtsPnzS2djJ3tQ==
X-Received: by 2002:a17:902:b205:b0:1df:fbc3:d130 with SMTP id t5-20020a170902b20500b001dffbc3d130mr951768plr.1.1711668467993;
        Thu, 28 Mar 2024 16:27:47 -0700 (PDT)
Received: from [192.168.201.244] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id x21-20020a170902ea9500b001dcf91da5c8sm2198892plb.95.2024.03.28.16.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 16:27:47 -0700 (PDT)
Message-ID: <0b15c2ad-71c0-4cc6-b00b-293966525a97@kernel.dk>
Date: Thu, 28 Mar 2024 17:27:46 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v3 00/30] Zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <171166712406.796545.15002324421306835511.b4-ty@kernel.dk>
 <67a6eeea-253f-4568-b73d-aa05173cdb41@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <67a6eeea-253f-4568-b73d-aa05173cdb41@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 5:13 PM, Damien Le Moal wrote:
> On 3/29/24 08:05, Jens Axboe wrote:
>>
>> On Thu, 28 Mar 2024 09:43:39 +0900, Damien Le Moal wrote:
>>> The patch series introduces zone write plugging (ZWP) as the new
>>> mechanism to control the ordering of writes to zoned block devices.
>>> ZWP replaces zone write locking (ZWL) which is implemented only by
>>> mq-deadline today. ZWP also allows emulating zone append operations
>>> using regular writes for zoned devices that do not natively support this
>>> operation (e.g. SMR HDDs). This patch series removes the scsi disk
>>> driver and device mapper zone append emulation to use ZWP emulation.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [01/30] block: Do not force full zone append completion in req_bio_endio()
>>         commit: 55251fbdf0146c252ceff146a1bb145546f3e034
>>
>> Best regards,
> 
> Thanks Jens. Will this also be in your block/for-next branch ?
> Otherwise, the series will have a conflict in patch 3.

It'll go into 6.9, and I'll rebase the for-6.10/block branch once -rc2
is out. That should take care of the dependency.

-- 
Jens Axboe

