Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A0A332EAA
	for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 19:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764098355; cv=none; b=Lqp6rAWOwK+JNjPgeNO/0X8ZxCF4d7RBSPke+gAo2I2BZtDAaymhie2sfj3XnerRxwqwhyHtRQYKkcf8wmFdmgx8f1dm9TE902XPxwGGqSipIUeiNC8CHvASBt9pUzN/bQhe445INRBGdIQwRTyJPMXgD/M8cuGUVndY3QbHizc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764098355; c=relaxed/simple;
	bh=45sbcsoq0xhsn+W5aOkv0g/ik59ollw7OK4nkRDzkZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dKyZ6VA1n0f8vC9xei2iaGs7LhsDAi9E0k4v4GAhbQdVGff9TlBDZPLpIfjfYChPPmtA0oRgmw/eNZJHIpcvselhMOYaBDsVKaBdeZslJGVATTXa3eE6ecfUMHxe2Zq0VKgcHW/jnGOy1CxMDPYAqhXTosV6XDiwYgGoHPKEeXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=amf/2w5M; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="amf/2w5M"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-4331709968fso25259645ab.2
        for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 11:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764098352; x=1764703152; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mUfqGNY8yNMCOlzV27bzhMu4chO9eJxWxW9kWFtTcZI=;
        b=amf/2w5MXa+VQWfIG4E+SdI14KxTtbG8VD36E5F78zaZfSyYN1nhwyIikcXzc7iBoq
         8pp9Nsn8+Aj2K6Sarz2cgCKrjKZDi3vltE3iy3Ua+eWpxrumMnnWQrhJd3Gjps662VWT
         cYsk1yAfmSZqAwGVkGS88yys9I4n3Qzv+ESiopW7vrlLj99TLba516p1FrY5k13lQCxs
         Jgsf4WtfK1uWFAdMVJDS87SBYZ6toooTHfqd8ZHsYV1B5soVjg3OUC+6jCZUs0HSMxzh
         W7fYMO831/X1CxM0nJbTxvPfre/H0jnhMs4gThFv1r10bCaKSwOGf6zNpdB4JcyplY40
         W/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764098352; x=1764703152;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mUfqGNY8yNMCOlzV27bzhMu4chO9eJxWxW9kWFtTcZI=;
        b=pG9qNtYvMK/6zH0vRkGQXHACewhcBXWzxDKF7oBGK50OiwWPK/4qwn9CzcHfkYKRcp
         ay25tUCu5gbWOOaUz82YlAv6aHyXkHfiVUKulCz6jlRpz+IQ5bVepQgDh8LKt5v6BXqj
         GSuqPQNRh1gNlXuZElK4DS9NbVL1Kppgk+Uu8uNrBJgce9EhGfGr0smPBNYnSHOPuChy
         0z07qCdxHJlim7RRablz0ve04SgOgwxUG/p/LxgITHix4bbk+rHmTmEnJEPUBO3JzA3W
         vzNDxJH4cKEsXfYkBH51htJpE8hdSVV4AkyjmTUDi4b2/dWg+PUy9BlCMXYLpIMHNZ/T
         sj9A==
X-Forwarded-Encrypted: i=1; AJvYcCWFIlfP6L8+uYQh6Gjliz9bnuDoz4BooiRBXSNeW1ZMoqLppRrlFUcd01NLs552/WptUmA5TZmedg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyFwudlOg+nyTxca1Zp/EcvmUygyauI1sdfdGO6tCPzI4a1+C6W
	N1r8El8m5iSF8v8/2aJxK+DVhYLVg50lwcHeQ0dHwaAupCOjLfU6aew5n0+CM08UbiM=
X-Gm-Gg: ASbGncuHXrJrqs/GJrz4Z8O0MfG20ef+xBfyo/j8dSlB4QGc+Pvs8nstIRzmzgOTphV
	h7N6yiModu50t3+m/Fdx7USPZgsfT2mldX1gp4Z/L8sOZQlcP8qi6A+hddZHVfTNobqkEfQ+71z
	Ut9o/leZ3BwQPxGpx/9yTpJJHwW23dOUAM42muWM78slc/g0Fkc7RxNS4aVuYPZX5zikXlIX0gU
	yy51cmWuq29kp2Fbe8tjXtVwpJONaEPuwtxYLKfiPAZxczqF4ga7TtHLvTBYi3c/usqaF1Mh7kj
	zLqPI8Ov5hfdPmPYtG+Ga+VYptJ2HKD+XPvUyfb1YmOXfA8hzujJKTueeLB0M+6O9Ypy+ZECxE/
	dtnEA00VHJCNKv3gsixW2yduINpr3Q3A1p49ooVaRDrCNMg5v/Gi8K/br5H2lZZNL5vnRX7hXrN
	bCAa1FGg==
X-Google-Smtp-Source: AGHT+IFQEaswkUqFfWJbDMiqY0I1VozYHdfo1ZahjMrEfHe7a5FmQfgVW6+5KRthy6ytF5ENx/5MzA==
X-Received: by 2002:a05:6e02:330e:b0:434:70cd:e27d with SMTP id e9e14a558f8ab-435b8e6957fmr145921635ab.24.1764098352527;
        Tue, 25 Nov 2025 11:19:12 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b954b48ed9sm7452092173.50.2025.11.25.11.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 11:19:11 -0800 (PST)
Message-ID: <a192b8dd-6d67-475c-972e-a88d6d8b8e5a@kernel.dk>
Date: Tue, 25 Nov 2025 12:19:10 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/6] block: ignore discard return value
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, yukuai@fnnas.com,
 hch@lst.de, sagi@grimberg.me, kch@nvidia.com, jaegeuk@kernel.org,
 chao@kernel.org, cem@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, bpf@vger.kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-2-ckulkarnilinux@gmail.com>
 <e3f09e0c-63f4-4887-8e3a-1fb24963b627@kernel.dk>
 <851516d5-a5e8-47dd-82e0-3e34090e600d@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <851516d5-a5e8-47dd-82e0-3e34090e600d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/25 12:09 PM, Chaitanya Kulkarni wrote:
> On 11/25/25 09:38, Jens Axboe wrote:
>> On 11/24/25 4:48 PM, Chaitanya Kulkarni wrote:
>>> __blkdev_issue_discard() always returns 0, making the error check
>>> in blkdev_issue_discard() dead code.
>> Shouldn't it be a void instead then?
>>
> Yes, we have decided to clean up the callers first [1]. Once they are
> merged safely, after rc1 I'll send a patch [2] to make it void since
> it touches many different subsystems.

OK, that make sense. I'll queue patch 1.

-- 
Jens Axboe

