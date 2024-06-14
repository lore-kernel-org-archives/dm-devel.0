Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C9E16C878
	for <dm-devel@lists.linux.dev>; Fri, 14 Jun 2024 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381769; cv=none; b=UUOfGJ62BySUPPucU6ifaJELcUHog0TPsVOA3xRUspyU3XWWc2026xs32xsmckzV5x1C8jmb29jxFAt6NmK4RuY1VfMlnNO7iHQ45edfLPbpMHGpZUUK3PBH/aW8IEiyjP4sLOGHEPpDOArAJmznf56TIopHVwRFW/ceSvpUXQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381769; c=relaxed/simple;
	bh=Aad19hIjxSUfEbYh1/pSP2sHGv1iCwO+UAJvrB+cZ08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D57D4XapqxxvXK+SzzDAISdf9xMNWhvAUE0lT1cQWMtFI8y9nLNUw1dQ4GDg/M5slXRaaO06LAvUK6LrkOYg9gQlns6KOFbXaz+vwgAskBdi5rctEfSUgqmvxcfNSrPzwCRRz6anam6ofCKXNJJ5KljJo1ikVfear3Hr4pqsRDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nHzrOi7Z; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nHzrOi7Z"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7041a382663so73085b3a.2
        for <dm-devel@lists.linux.dev>; Fri, 14 Jun 2024 09:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718381764; x=1718986564; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BDixbra1HnV5DPgXv78teb+z8r3TOra1wJTUjH08YD4=;
        b=nHzrOi7Znmk2k7ROTSk9VaBOX02JdoWWJBm8V8gcBHuwyFTDQO9U1c2qbiGm8cY4Av
         bj48p6D2IqUCrWfZixaYrYGpEbNqnJgN3IiDnBH/CAML6DMNBsrbtkZ78dMXNht6Qeb/
         3FDkrAqijc730n4nJqWtJcbUuEHJ866qWNDVqZpWjzT0ZZJUDqQ33uhsI8T2FZLXMdIC
         bADrJUU+9eAYuHchVvuLWSBBXPI3Y/tOee/u4ADZGjLguk+9W8xBoqPSUmQw5z+Wm3qh
         6y/xSDwQopI3tOzpq29RBDJbfudAmjERuSMdsB+QkGUea4a+5+haNJQdieWBXS8vERPK
         JMeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718381764; x=1718986564;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BDixbra1HnV5DPgXv78teb+z8r3TOra1wJTUjH08YD4=;
        b=uV4O/DWP1mKHQiGxki9L4mwn/ZkPPyI1QkqtlXJ1PhAJt95vlLUokltahLV+49gVOj
         s6yNmw4nVCbrlvC0cRUKLgjd6hqNW91m+RoyUQEuxMa7qBJYyBzEZ3K4T9PkmZ55bDNP
         Ox74Vkw8dI8T1sBJSFV0sZ2LMhexkVXW8OtPPyVyfCavvXlVZTxkjKG/pejEl5qiTWn1
         ioOH83yNm9rRMegYGNFPsYtVXDKeviUz+qv4tSrNnFJtOrM+77shob/zKrLol5IvXG4Y
         ELBOAnElWiG4NrOkm3XSLc/G4PEE12Ennxes3GBvMZDcXLzyQZ2+L5hysEk+icCWn/4C
         qKSg==
X-Forwarded-Encrypted: i=1; AJvYcCVeGtyW03nuOSR9aRjxGMWAp3LOvm1dobtGfxRxYoI/13VZ/N6NPR5rebmhW0BKeEJAUFPH9/dzowpq129gEMe6247VTrX0GkA=
X-Gm-Message-State: AOJu0YxiPoHqJNyWfuAXboZkrr+iweUK56Jb1D2N+IiZcRFNgQOSl/Sh
	mWa548R8LIcyVaXo4+s77TjctmTl56+TbxV/ag8za/sy/fTWJh/8jJZh6EN+Lic=
X-Google-Smtp-Source: AGHT+IHcxyIgaaVTPfM4bd/lwoK3Ws05v5eakEhv+baleiJUj4MZMdoqwGuHfLvaj6ML51yAKT62Sg==
X-Received: by 2002:a05:6a21:6d98:b0:1b4:e10c:62bd with SMTP id adf61e73a8af0-1bae7ed3e48mr3699835637.2.1718381764289;
        Fri, 14 Jun 2024 09:16:04 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb8d98bsm3224419b3a.191.2024.06.14.09.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 09:16:03 -0700 (PDT)
Message-ID: <6c5d4295-098c-4dc2-8ad2-f747a205f689@kernel.dk>
Date: Fri, 14 Jun 2024 10:16:01 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: move integrity settings to queue_limits v3
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240613084839.1044015-1-hch@lst.de>
 <f134f09a-69df-4860-90a9-ec9ad97507b2@kernel.dk>
 <20240614160322.GA16649@lst.de>
 <af0144b5-315e-4af0-a1df-ec422f55e5be@kernel.dk>
 <20240614160708.GA17171@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240614160708.GA17171@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/14/24 10:07 AM, Christoph Hellwig wrote:
> On Fri, Jun 14, 2024 at 10:04:28AM -0600, Jens Axboe wrote:
>>> That sounds like you didn't apply the above mentioned
>>> "convert the SCSI ULDs to the atomic queue limits API v2" series before?
>>
>> That might indeed explain it... Surprising it applied without.
> 
> Also as mentioned a couple weeks ago and again earlier this week,
> can we please have a shared branch for the SCSI tree to pull in for
> the limits conversions (including the flags series I need to resend
> next week) so that Martin can pull it in?

For some reason, lore is missing 12-14 of that series, which makes applying
it a bit more difficult... But I can setup a for-6.11/block-limits branch
off 6.10-rc3 and apply both series, then both scsi and block can pull that
in.

-- 
Jens Axboe


