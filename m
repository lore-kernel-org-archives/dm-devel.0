Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A2A12F58A
	for <dm-devel@lists.linux.dev>; Fri, 16 Feb 2024 15:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708098749; cv=none; b=HglzDBYaDareEn/P6FooeYyCjJDa1M15JIkKz8WzCEKN+UGXCAoQrI6fnd883NHm4RaUUr2ELbTTicUelhpoaUpO29/zRKm5Gx5tz4/JjXR63bZjEjr115rctyqXWyNYq45QS3zn7A1XjZELGmaTIwCcB6PccF+ekyauS87K2EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708098749; c=relaxed/simple;
	bh=zQHxIDjjwvENEklHG5+P+nAsCfKvOL33RSYN/au5iDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=heWooLIbrDat5d2m+zv6LxoLST47cN+OTGUmMhdmygANxn01dbXGxIcAEGy2lH30yNRq6v5scO4R8Wd6m/6zQSUHJfaXk1T5zmh3Kalq9gkzWvrz8f/h3PPB4hceJeYg/P0RdbDzedyrFsPlDD6bOXrfOq7KzADCRTtP+LzTGIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Et9XXUmw; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Et9XXUmw"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7c3e01a7fdeso81185539f.1
        for <dm-devel@lists.linux.dev>; Fri, 16 Feb 2024 07:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1708098747; x=1708703547; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4UuLv5UoKgwS5Sbj+Drkana4tgYiAyfKFVJYKCmoJVg=;
        b=Et9XXUmwFM69WBtibIxAwc4l0IonKvK1vSpi8tziiZ0WAkgfjyIQ/5iIrJ/zrjnEUa
         PTzxBPsavGFpsBKBSUOUIPkvwXQa8D0Qjlkh9Oz5v4lG0sBUA2sEV4XwBtKldnm1JM/N
         iodFlwBN/M4gO56ybkicDN9uIdTWFiKL7JpBYC9GvQp/2QMmaLiq9X0jlCf0ev8LPcoE
         e2WA2S4w4Ihn0BoofSRkqp/DzY7T7dTqoINAF3P9iPcYmCnFRbi4bBOq7e4GqZBtqwHD
         jObNNf0DZlaZtxLeh+fFG4O7ikiQwCKukUecR9q0G1cbaxxaSFvM/7WxWExk5MoAKcUN
         1hrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708098747; x=1708703547;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4UuLv5UoKgwS5Sbj+Drkana4tgYiAyfKFVJYKCmoJVg=;
        b=HTcj/vkheSRMGukEtO0mKgSI8AIOzEHxueogs7uFpiwNoTAWFIIdvK5apy4vbulMSO
         VJf25Qbw31cgjZb43E3+v9vZPjdWBCJhKfIlVHYoYcQeu6rFCQmXOGgcp5y6TBGfLppQ
         yQmUGqonT2LSzuGRvI9Rc2p6DPbZRE23RoV8Cyn7Diigjv+BfvQwMlWMLcaasBxiX2rs
         3CWNYnpcSc/8qEnMGDxFpm0GQjfTkGp579mmyz5l8gmpjCzv7XRfnqeHBnUtp3O7NSBz
         1Iv1vFsZa6a1TxM2PH2CMlXqqev+7UK39eGoOhd2wWWOnz+euZmarfVIwpl8VByiTie4
         NsAw==
X-Forwarded-Encrypted: i=1; AJvYcCUYFHC/STaqB02Ve4TI4zLxj8WGdpfYi7Vstnuqu6vPbI25imzVMiDyscp2FLTSkoMxUwivw5dDGougioIRNNvFOb1GX8TpYnk=
X-Gm-Message-State: AOJu0YxuzK/ee4TV348ASzVRlU3Kl3Uty5r8kCKBBD9jthWiSdQTGu2t
	qVgjU20WtAqqWZ+3Rs7KEJsFCMUI5DG7AEWdb6zkaLCUNY2fzT06DAyRztlMg/g=
X-Google-Smtp-Source: AGHT+IHrUiej7yFWlHnP9s7250iMaB2JeyRPBgFUS7lY1WV3rbY8kPKQiQ+iQejR4JASuqBjKZnwyQ==
X-Received: by 2002:a05:6602:1302:b0:7c4:5529:5818 with SMTP id h2-20020a056602130200b007c455295818mr5979560iov.4.1708098747464;
        Fri, 16 Feb 2024 07:52:27 -0800 (PST)
Received: from [192.168.1.132] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z26-20020a02ceba000000b0047401a9b8cesm32736jaq.106.2024.02.16.07.52.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Feb 2024 07:52:27 -0800 (PST)
Message-ID: <f0c51f71-dae8-447f-bbdb-73d2ce607893@davidwei.uk>
Date: Fri, 16 Feb 2024 08:52:25 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] net: tcp: tsq: Convert from tasklet to BH workqueue
Content-Language: en-GB
To: Eric Dumazet <edumazet@google.com>, Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com,
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, msnitzer@redhat.com,
 ignat@cloudflare.com, damien.lemoal@wdc.com, bob.liu@oracle.com,
 houtao1@huawei.com, peterz@infradead.org, mingo@kernel.org,
 netdev@vger.kernel.org, allen.lkml@gmail.com, kernel-team@meta.com,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 David Wei <davidhwei@meta.com>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-7-tj@kernel.org> <Zc7zLsEhDzGkCH9m@slm.duckdns.org>
 <CANn89iKDsJPY=QQrTHK0Jw=s=A_G_GzcOA0WsqXaytWAVV3R4Q@mail.gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <CANn89iKDsJPY=QQrTHK0Jw=s=A_G_GzcOA0WsqXaytWAVV3R4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024-02-16 01:23, Eric Dumazet wrote:
> !-------------------------------------------------------------------|
>   This Message Is From an External Sender
> 
> |-------------------------------------------------------------------!
> 
> On Fri, Feb 16, 2024 at 6:31 AM Tejun Heo <tj@kernel.org> wrote:
>>
>> Hello,
>>
>> On Mon, Jan 29, 2024 at 11:11:53PM -1000, Tejun Heo wrote:
>>> The only generic interface to execute asynchronously in the BH context is
>>> tasklet; however, it's marked deprecated and has some design flaws. To
>>> replace tasklets, BH workqueue support was recently added. A BH workqueue
>>> behaves similarly to regular workqueues except that the queued work items
>>> are executed in the BH context.
>>>
>>> This patch converts TCP Small Queues implementation from tasklet to BH
>>> workqueue.
>>>
>>> Semantically, this is an equivalent conversion and there shouldn't be any
>>> user-visible behavior changes. While workqueue's queueing and execution
>>> paths are a bit heavier than tasklet's, unless the work item is being queued
>>> every packet, the difference hopefully shouldn't matter.
>>>
>>> My experience with the networking stack is very limited and this patch
>>> definitely needs attention from someone who actually understands networking.
>>
>> On Jakub's recommendation, I asked David Wei to perform production memcache
>> benchmark on the backported conversion patch. There was no discernible
>> difference before and after. Given that this is likely as hot as it gets for
>> the path on a real workloal, the conversions shouldn't hopefully be
>> noticeable in terms of performance impact.
>>
>> Jakub, I'd really appreciate if you could ack. David, would it be okay if I
>> add your Tested-by?

Yes, that's fine.

> 
> I presume memcache benchmark is using small RPC ?

It is not a benchmark but a prod shadow, but yes the requests are small.

> 
> TSQ matters for high BDP, and is very time sensitive.
> 
> Things like slow TX completions (firing from napi poll, BH context)
> can hurt TSQ.
> 
> If we add on top of these slow TX completions, an additional work
> queue overhead, I really am not sure...
> 
> I would recommend tests with pfifo_fast qdisc (not FQ which has a
> special override for TSQ limits)
> 
> Eventually we could add in TCP a measure of the time lost because of
> TSQ, regardless of the kick implementation (tasklet or workqueue).
> Measuring the delay between when a tcp socket got tcp_wfree approval
> to deliver more packets, and time it finally delivered these packets
> could be implemented with a bpftrace program.
