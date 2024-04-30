Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C38184136
	for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 19:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714503897; cv=none; b=uDFvI0Sbb8p4cWjnB5IB0JCiy7pree7gFWP/h+O6kttLv+WJte8juX4llZUfL7lKxP6LC3X8MRxArig270fA3C4HfTowqcJe/QYbSgjN+tjBLjKiuO2MPSMLeczmxOIuLmeisS3lhyzEBgPFEzJ3U5OTB05SaqJGbkzfHI89JOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714503897; c=relaxed/simple;
	bh=PUmwHRkZpZ8husnv2UW+PtgNM5uFoU+77Xz3woX3+jM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q4aKXiweCVmcBmPhIINim5LoglMF2vnX8txAtJV+TcNiPoyQYg+/eJzgAKb6dgYZ/EtTFlRhg3zZMIZnnaRA8WoUITUztt/LSQvHTFFkzTdtBWQEgXIDx4YgrQc94NxL8hqsvnaA2Fr7c2RmQxN/rjt1hEeWiJ8r0ZQoVk+Bx9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=19+jpnWX; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="19+jpnWX"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7d9c78d1087so37688839f.2
        for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 12:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714503894; x=1715108694; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8YdF3doTeWlJMwEbx+LBvN0OsrsY2e10ycxw5Z87MJI=;
        b=19+jpnWXzrDWx25UDXriuluLgMwlYATokFUYIFJ98dWhHx7Hjq7Ew3TotcaP6gKgl3
         Tat1gFdXzEA2c36B0TMP8+l6PaPtr7FOUHIHXSUxRE82yGW3XIcNBd43qHze7JyJ+s+m
         VjHEjbkpspF+EBOy+8jju3GGBDTh/H168BeNJh4IOVrWSfQ3EmHIRG4CVAQjUq2BdJaE
         oref2GkOrcLCMGRok6z0UHVdvb+8NfmpDzdmRyl+NsXbIYmiePLLY7Mb6Q+HzTgoRFbD
         zSAijtsqR750YvGaUXCYnODSout2zZjtXbZI6YSZEamSIACQJscH7tiXeKziRxe9yko0
         wLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714503894; x=1715108694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8YdF3doTeWlJMwEbx+LBvN0OsrsY2e10ycxw5Z87MJI=;
        b=adck6yTHaSGfCGYIarB/oOczumQpFGfWuSZErrg2XroQcMGIp/u2n4KyGgtHGSV0th
         972DtsycsU5mmrbnouLIYaq/ej3YJOOTqFnkgaLe5Fz6mTGp/6MYGcLofiLvn/Awk2Os
         O6O68D8v+nHWZ5I44eMlxLfi0Br5G5Zfb8gHglBOOmG2uzBRQo4SRKBqCniyxeexgFC+
         UlPlCAkDmpZDmtYt0Fxty6rcjqz6hLIHfRP2Re+a8z/YpAaszUp3mp5Vkl05Fctv+M6r
         dgmq2obDltdVs1qcYj5VdixcQhTHitKvl3rLn9dXNmGsAer7YNPz0aoLWhj8ZaMxpioZ
         F9hw==
X-Forwarded-Encrypted: i=1; AJvYcCVuO7ZYW1bCTH6nb9bYIkR+VYrTbIlx9r5eOwaNep4xaeLsf/o3rxB9bDW+hbANtRQCTo7rcwsvpEGZ6ZmjH4NavJ4AYFS/t24=
X-Gm-Message-State: AOJu0YzajWHnWx6UnmTPCeSdIHyaQLLzNXZ7XdJ/A5BW8rZpfx6xjExu
	K1qx4iPQR0JNPLna+5W4hdwJkGQGG8u5YqQ3lx3yl2rEgAqszVDG/fKjzpU3A9g=
X-Google-Smtp-Source: AGHT+IFVgLw+AgihydySRNu2M5TSCR05W5WyJs9fmLGdJVjuB078XWLK7FYrKmSFDiHD1ZNqTIIUkQ==
X-Received: by 2002:a05:6602:2bd6:b0:7de:e495:42bf with SMTP id s22-20020a0566022bd600b007dee49542bfmr779930iov.1.1714503894503;
        Tue, 30 Apr 2024 12:04:54 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g3-20020a05660226c300b007deaecfe190sm2315494ioo.7.2024.04.30.12.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 12:04:52 -0700 (PDT)
Message-ID: <4c54e3c8-83ed-46dd-b437-2f01ab1cb866@kernel.dk>
Date: Tue, 30 Apr 2024 13:04:51 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] block: Exclude conventional zones when faking max
 open limit
To: Christoph Hellwig <hch@infradead.org>, Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-3-dlemoal@kernel.org> <ZjENF8spyEWrGwws@infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZjENF8spyEWrGwws@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/30/24 9:24 AM, Christoph Hellwig wrote:
> On Tue, Apr 30, 2024 at 09:51:20PM +0900, Damien Le Moal wrote:
>> +	/* Resize the zone write plug memory pool if needed. */
>> +	if (disk->zone_wplugs_pool->min_nr != pool_size)
>> +		mempool_resize(disk->zone_wplugs_pool, pool_size);
> 
> No need for the if here, mempool_resize is a no-op if called for
> the current value.

Still cheaper than the function call though, so I think that's
the right way to do it.

-- 
Jens Axboe


