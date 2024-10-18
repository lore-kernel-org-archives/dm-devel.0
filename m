Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65C9156F5D
	for <dm-devel@lists.linux.dev>; Fri, 18 Oct 2024 03:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729222015; cv=none; b=kF6qFT3ElfDv+rqm2iYoDV0qKO02fVqA50C618dlEh5HBkYSFsgUVsfXPiaw96HLssnrBgFVzAyxc63wbMwJqSFBezRsepUiwc3oK5a4sseW7iC7m5ItQqvO+//i3MkYJ98f7ZfiowWY7IYxPWx0nt3jTrPU7PwgT9J+ajFG2JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729222015; c=relaxed/simple;
	bh=pp0xdFEq2xvTLyyQpNjgiFlzJ7fppjTZ/wj9ohuCh4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fprPOHt9MAlw7JkgQIVCfMMGo/aySpqrc/WoXQP2GoJfInEfg6W8DfkejSjfXgURxrb2rB3zBRIllJd4OR3B5M0yDN4oaelstaauDrIS5Fzb48lGa4BL4vvWT8DAjFQVs2MCEMClACuCi3vtenQ0DMTYxkjwZ7KCo/jVMiArRHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EDG4Rb79; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDG4Rb79"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7b153047b29so64504685a.3
        for <dm-devel@lists.linux.dev>; Thu, 17 Oct 2024 20:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729222013; x=1729826813; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RRFYsm7JQn6FoiV+R8mnl3y+fSii5MhmQCkaq6Im0Kk=;
        b=EDG4Rb79XsPpVO7ol/7MwysOEI+F00nvhhoSE9JGWnCqErebjI1l6Hxqk3qFpzNPRS
         OdQ4uXODlIN8V4pHW+QvbBNVZseKWNQKSxG5JRUk9YuUg95MNcy+YRv1iB2Fi3+p6owE
         bys8VWDC69XM+XShwAyPnoZW5msvUxoeyFkt+gvkah43zuwk1LQ1+M6nZMQBFO05Qt9m
         gD5/vD83PiABMXVqMBdkXlty3JyMdAj5hY7J6Oa11gH13QHq26H9EuDrUxYv6v7Y4Vn0
         iw09grDHcBHb9a937aO/EXiEe3dbBlSqEqKL4Rkj81CnW0iJdpUWshxzrLyUffcWDN0l
         /YPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729222013; x=1729826813;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RRFYsm7JQn6FoiV+R8mnl3y+fSii5MhmQCkaq6Im0Kk=;
        b=ETsQQEk3chpMMQHPdu4WSwOpv+AI9KIKKe5QW2LYVzl2HXYvYQw+gypyHiGfX9oWI7
         L40VJCkMkhduEqHpIxN6GmAOrUR58iPLOnH/CyZScrFfi8hWBJY5/1BT9l10YDsWTjJ9
         VUB6iD5x9av0ea/c5mHlsUrRtl0AlYmWKxoayBQN8uC8fGdMeHxQ9DDdBUfHx9A0NEFL
         TDQE5SWF9Sz8Qs+g3kCrd3dOs2dMVLozGQ7r1ixoFJbhzRtQK6AzP48IiQmMT0fViXY3
         /LAtQ77Zdd1vzTimSp4rPIMJYL5+OOI5G2juhEY+0fxqdu7o/zvRVTOXweGgtQuNDdXy
         bPTA==
X-Forwarded-Encrypted: i=1; AJvYcCXbu/6+fcnQe1oW5GIt2x1thDtWVHopz+68eMAP2bnfm/0pwEjMGtwCPH0+BhaTT7/gGK/XValofA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yztx/ijlluTmCOw7jezo4ou2M8UC5kCqkTDjKFGTPEq3JBxxl6L
	ZRkcID4VpSAfC/ynNmu9XqsF9P113eE6FQ/2RnzRbgOVKZw1Ey1o
X-Google-Smtp-Source: AGHT+IGbNm4J7504L9d7tSHokebTr/bSREZo9pNVg4bVFxle2lyocyWjoZsfEt0kWM+ekwkhqpJNeg==
X-Received: by 2002:a05:6214:3d13:b0:6cd:4972:59af with SMTP id 6a1803df08f44-6cde150b8famr20524116d6.14.1729222012692;
        Thu, 17 Oct 2024 20:26:52 -0700 (PDT)
Received: from [10.56.180.205] (syn-076-188-177-122.res.spectrum.com. [76.188.177.122])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cde1366d72sm2925836d6.116.2024.10.17.20.26.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 20:26:52 -0700 (PDT)
Message-ID: <ef3c9a17-79f3-4937-965e-52e2b9e66ac2@gmail.com>
Date: Thu, 17 Oct 2024 23:26:49 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] dm-inlinecrypt: Add inline encryption support
To: Christoph Hellwig <hch@infradead.org>, Eric Biggers <ebiggers@kernel.org>
Cc: Md Sadre Alam <quic_mdalam@quicinc.com>, axboe@kernel.dk,
 song@kernel.org, yukuai3@huawei.com, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, adrian.hunter@intel.com, quic_asutoshd@quicinc.com,
 ritesh.list@gmail.com, ulf.hansson@linaro.org, andersson@kernel.org,
 konradybcio@kernel.org, kees@kernel.org, gustavoars@kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-hardening@vger.kernel.org, quic_srichara@quicinc.com,
 quic_varada@quicinc.com
References: <20240916085741.1636554-1-quic_mdalam@quicinc.com>
 <20240916085741.1636554-2-quic_mdalam@quicinc.com>
 <20240921185519.GA2187@quark.localdomain> <ZvJt9ceeL18XKrTc@infradead.org>
Content-Language: en-US
From: Adrian Vovk <adrianvovk@gmail.com>
In-Reply-To: <ZvJt9ceeL18XKrTc@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/24 03:44, Christoph Hellwig wrote:
> On Sat, Sep 21, 2024 at 11:55:19AM -0700, Eric Biggers wrote:
>> (https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/drivers/md/dm-default-key.c),
>> and I've been looking for the best way to get the functionality upstream.  The
>> main challenge is that dm-default-key is integrated with fscrypt, such that if
>> fscrypt encrypts the data, then the data isn't also encrypted with the block
>> device key.  There are also cases such as f2fs garbage collection in which
>> filesystems read/write raw data without en/decryption by any key.  So
>> essentially a passthrough mode is supported on individual I/O requests.
> Adding a default key is not the job of a block remapping driver.  You'll
> need to fit that into the file system and/or file system level helpers.

fscrypt isn't the only thing that would use such functionality. If you 
put it in the filesystem layer then you're only serving fscrypt when 
there are other usecases that don't involve filesystems at all.

Let's say I'm using LVM, so I've got a physical partition that stores a 
couple different virtual partitions. I can use dm-default-key both 
underneath the physical partition, and on top of some of the virtual 
partitions. In such a configuration, the virtual partitions with their 
own dm-default-key instance get encrypted with their own key and passed 
through the lower dm-default-key instance onto the hardware. Virtual 
partitions that lack their own dm-default-key are encrypted once by the 
lower dm-default-key instance. There's no filesystem involved here, and 
yet to avoid the cost of double-encryption we need the passthrough 
functionality of dm-default-key. This scenario is constrained entirely 
to the block layer.

Other usecases involve loopback devices. This is a real scenario of 
something we do in userspace. I have a loopback file, with a partition 
table inside where some partitions are encrypted and others are not. I 
would like to store this loopback file in a filesystem that sits on top 
of a dm-crypt protected partition. With the current capabilities of the 
kernel, I'd have to double-encrypt. But with dm-default-key, I could 
encrypt just once. Unlike the previous case, this time there's a layer 
of filesystem between the block devices, but it still can't do anything: 
the filesystem that stores the loopback device can't do anything because 
it has no idea that any encryption is happening. fscrypt isn't being 
used, nor can it be used since the file is only partially encrypted, so 
the filesystem is unaware that the contents of the loopback file are 
encrypted. And the filesystem doesn't know that it's encrypted from 
below by its block device. So what can the filesystem do if, as far as 
it can tell, nothing is being encrypted?

Best,

Adrian

