Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5F122084
	for <dm-devel@lists.linux.dev>; Thu, 18 Apr 2024 14:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450619; cv=none; b=WowaCP9S5AseS8HYgA7xosHDT17WI97UIHWTKDukRbGzXqxQWvRYQ2jWK3uL24+AAo09ppWX/Lh9zMnv8vY7lOygZ+h9Exx27eMwUwoklgEwzOHsI4dwTxKpGNbB400i71tzbCs5FEhQyhuDVmzOko+5ezrb292uH4hn0aF+HLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450619; c=relaxed/simple;
	bh=9/TQR1IEgTwqNlCPaqpr/Jnitj09THPvfGG3tVGKatE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cfj/1F3ZD2sYXBgyOORmXEOmtszbcDavQWCUxFtvwwsUqzPAgKQON2kHCzkxr1kXYqHAPjQTYYdL/gcCf1/u1HvaSsWMj/WVBNmzxBVBhXqi+uXlk+fYPKfRp0Ds0PeU8qkG1rTGHtS6QCvIve3uWC/HnZ4g7O+qI3fUlnCKhvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bqbPe2XA; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bqbPe2XA"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5f760eebd79so27313a12.1
        for <dm-devel@lists.linux.dev>; Thu, 18 Apr 2024 07:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713450616; x=1714055416; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s34+6Noa47tUC6nDFg281DMAoJ2FA4565ND1y1auC10=;
        b=bqbPe2XA3QJee5BMdxsTQELRIBQUCeDoaWPMGvbjJXc7s/Lu83C/xjMfsB+5fWjDxW
         AXBWSAF+csUx8JOBk/zL1d8ShMLKf/1+Dlh5OAfpUmerErt48cvzoJ7GEdhMJbwHzgOb
         0PZP5Eu8bkTX2h0p+pveMiZ0tiqmkehkhGvPrmeKL7xaVFf8cu6u4hoQ03gLbwRgsk7e
         fajze9wiZzo8vtLJLDQODDt3ffWiEcNXg/HfCzfU50eHJcZO7dKM+b8wZTp4MlV8M3dF
         qyormK6RH+N0zizVeR8Xw+85UKW7Rps13LEEW1iFTo3WRItxcXTpLHGBviFhaK2+IxZF
         9SUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713450616; x=1714055416;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s34+6Noa47tUC6nDFg281DMAoJ2FA4565ND1y1auC10=;
        b=t9eAZWzQr6Yr0Ye/SHApl8vMQKJqxQp7qchnNDuViFjRrgzd8p/RI7eFNU1LKKRKoq
         4ydHmDtt/o+jR6/RkwKl06jbdeFztv3uXHd/xqlNmQ2mCBBIwHL/Xq64+QjMCym0FP+M
         EHAfeCHyovsaFE6/PjmraJHzDkyVMVu3aukyWzWG1yklCtKkIx1PFWb36AEL0qDi/g0j
         WEtxOpR80BCvcrdEYngGP2MIGg/a1ADohXxmcKiAETionUQ5d2F79HC/BH2P8w4LEbmC
         ETmeTcQvccHhj5ZYvUjvuEz2FB3ekE/7fK3dfiROK/BCIK5FuHloIlX9YTW2Lpa0bD6Q
         0BoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtavCm1fQlk9x1w+2QsGKXctFJ6Zxb14U4MrwzwUmwpMKNLChQ58TpfilFYuQkcNY3RjHjFnONgDkL+G07zA02SFNzn88lCt8=
X-Gm-Message-State: AOJu0Ywwh5pYglsj4C86QmxMKdb7yKaWmADHo4RTwAnb42RcwueKSnfE
	zNoU7vvgiuqPBoF5+xZYuosn27rTd29hw39o56Y1M8my6g3AovjNBgYXvrVWAYY=
X-Google-Smtp-Source: AGHT+IE/r+6kGQWQgTrRuvZsXt5Jk/7zTOFdGOX/gMa9HL2erOx+JLXrmh+ZxfohkV9kQ/nVsaSU0A==
X-Received: by 2002:a05:6a00:6013:b0:6ed:6944:b170 with SMTP id fo19-20020a056a00601300b006ed6944b170mr3128716pfb.1.1713450616403;
        Thu, 18 Apr 2024 07:30:16 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v10-20020a62ac0a000000b006eadf879a30sm1578618pfe.179.2024.04.18.07.30.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Apr 2024 07:30:15 -0700 (PDT)
Message-ID: <5f3d434b-e05c-445f-bee5-2bb1f11a5946@kernel.dk>
Date: Thu, 18 Apr 2024 08:30:14 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] completion: move blk_wait_io to
 kernel/sched/completion.c
To: Christoph Hellwig <hch@infradead.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Snitzer
 <msnitzer@redhat.com>, Damien Le Moal <dlemoal@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
 Waiman Long <longman@redhat.com>, Guangwu Zhang <guazhang@redhat.com>,
 dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <31b118f3-bc8d-b18b-c4b9-e57d74a73f@redhat.com>
 <20240417175538.GP40213@noisy.programming.kicks-ass.net>
 <546473fd-ca4b-3c64-349d-cc739088b748@redhat.com>
 <ZiCoIHFLAzCva2lU@infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZiCoIHFLAzCva2lU@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/17/24 10:57 PM, Christoph Hellwig wrote:
> On Wed, Apr 17, 2024 at 08:00:22PM +0200, Mikulas Patocka wrote:
>>>> +EXPORT_SYMBOL(wait_for_completion_long_io);
>>>
>>> Urgh, why is it a sane thing to circumvent the hang check timer? 
>>
>> The block layer already does it - the bios can have arbitrary size, so 
>> waiting for them takes arbitrary time.
> 
> And as mentioned the last few times around, I think we want a task
> state to say that task can sleep long or even forever and not propagate
> this hack even further.

It certainly is a hack/work-around, but unless there are a lot more that
should be using something like this, I don't think adding extra core
complexity in terms of a special task state (or per-task flag, at least
that would be easier) is really warranted.

-- 
Jens Axboe

