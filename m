Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858FE200B0
	for <dm-devel@lists.linux.dev>; Thu, 20 Mar 2025 12:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742475541; cv=none; b=pv0RfbTtKU+y+7zKJI5I1XyJ8CF1Cn+F07b1AyMYuq+N8Mjm6WwJjrYdCSFUVuUWkqEuatfsJLjgwFPvRYEgf+6mz5E5I26ONkCkNAvyAf2aXnrvyypLVRHxq2yTV7P39qVf25ck+e1cDiMqtZScJmnwB8VBWRiY2LSngSzJq6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742475541; c=relaxed/simple;
	bh=QJbjoUU1hkaoY/YmGkvIJJhYaQzGERVBOCIcORbR4ww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gqYs6eA936oPNMHs1Fxrz5EvAlPKjxpIZ1C3Kpnjb8DOIkQsDPXZGtkSbDA962MoYM5Z9PBSgdk4GkejUsRvEYHt1/yenIGukBvHYpFxusfXAEd7HUlAArfWWyc3D7yLAL18+OkOJ3saQlLEkzP7bCNyKdv5P7Eaedb37ZEuLwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hw3pIrqc; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hw3pIrqc"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3cf880d90bdso2745255ab.3
        for <dm-devel@lists.linux.dev>; Thu, 20 Mar 2025 05:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742475538; x=1743080338; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iVnHryLbM4HSGexWSoyzqAnHzYi2U3F+uNUwYKaXBbg=;
        b=hw3pIrqcm7elWzU7fRscpQV14Pae/He1QqL0QSx/e7yk/0jJxiZjgaaJq9kPzOIy7J
         p9FKgpdU2EL0WfexYXieDGUwPh+L/1MXd9xQBe7T7UmkpoJespkTtg8obQ3yamMaB3Jh
         JQiNgwPU1DTyqoWV44EtZ8dQQZLzW9OjAY2LSB5xyRhTl9uLzLiph3IEWNIeEtGzhtk8
         wSpEJQWOQhBOKiyXkUVLh89etQx0ClPIigzqlNv9RxoTEnBD7VZpRVXwspubo25LEpGj
         ITedLTdU0HFZjKv8uW/XRBHZ80xdpxNhu6HAKFECEUJqwBdwqOqM6XfeNuaUfLlJ3Rd/
         cb3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742475538; x=1743080338;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iVnHryLbM4HSGexWSoyzqAnHzYi2U3F+uNUwYKaXBbg=;
        b=lWMrtY5ESFyUDsrzmyoH5/Afj3/Mcjf+fGXBbQJPT2vNSuroC3mOPR26uHdj3imu9P
         O9b+3Z8rY05cOM1WR/wDOqW/+/B7YrPShCfuxbbaDUqqku1DT0GP98yC0AXLW2jVRBY0
         1K32S2NV8zPavPNcTHfQ6dnW5XdHPcNNTPQpKU18KuxQxuoawBBRw1EcvCAhYg+9weUn
         UVoSJrX92w8Ugz3qUDSCZmcrpAeui63sci3WYRHqEIJtPm3GgDueZ9dwTLzD3MCZzpYX
         /mut3j1rayoBVo3PyxJl3hn01L9ebCbCrLQGNlvmuzTn6CV8m4KWZ8hkT++5MlC0054C
         TfbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmz0Tl3VIHIJdFM/m4jsRL+hiq9sNiF137Y6H4fmIQs+IRPaFPbFqLpFHTGnaNpLsuLkKZWmQUvw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyGzlhYk8LtgiXh28RmK/5Cs93Wb6f5A9UDBUAO0TeKrUXZfvKK
	c3hr364uPUaZMWB8ntNlFUDEUMeXoNNnhMCLztp47lnXTAOQtNHSllTWNVsZ8y0=
X-Gm-Gg: ASbGncvB8oMB5wmMhoWbQexwRoULw1Mi2EyppzoHSFqYdbrcVxaATy0fVS0yUSXOrq+
	pJvD9rGXI+uVhZPdqpZCE4p2CUIDEWj7klsrc1aw2uYKFlIVnYh41OLWy/cnNuuAf79V0nZwoNI
	Gnln1vjOBaAWU8hxWhDdTe6eBFzgLCsxtGwnHxi+Z/JTE5XHXMIv/4BrOwg3PQleHz8lm2qf//3
	yPMGVWfe5uzCT0hwICvkHwzdB/cbr0KxPIskkrGPj3+lp95EkHUcENSs0jBQAw3v0r3Mfi3McxP
	PpWrc6vU8EWWspo9WXfEtOZHsh1J0rAZ2FcylWHlxw==
X-Google-Smtp-Source: AGHT+IFc/x57QJZx5favzhvE8V/QLoHjC7cHsoOW38xsaVU+AcJ3TJmBZSKivizLO8YzuV9hrOmDqg==
X-Received: by 2002:a92:ca05:0:b0:3d5:893a:93ea with SMTP id e9e14a558f8ab-3d58ebeb656mr26601915ab.13.1742475538571;
        Thu, 20 Mar 2025 05:58:58 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637198eesm3716437173.50.2025.03.20.05.58.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 05:58:58 -0700 (PDT)
Message-ID: <5f6c8dec-103b-4aa3-affd-f08fdf68f1dc@kernel.dk>
Date: Thu, 20 Mar 2025 06:58:57 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATC] block: update queue limits atomically
To: Ming Lei <ming.lei@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev
References: <ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com>
 <Z9mJmlhmZwnOlnqT@fedora> <d5193df0-5944-8cf6-7eb6-26adf191269e@redhat.com>
 <Z9ocUCrvXQRJHFVY@fedora> <6ebdd2ae-8fc2-4072-b131-a7c0da56d3f2@kernel.dk>
 <d04fcd9f-b4a7-100a-e9a4-b0d4d45b372b@redhat.com> <Z9t709DZs-Flq1qS@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Z9t709DZs-Flq1qS@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/19/25 8:22 PM, Ming Lei wrote:
> On Wed, Mar 19, 2025 at 10:18:39PM +0100, Mikulas Patocka wrote:
>>
>>
>> On Tue, 18 Mar 2025, Jens Axboe wrote:
>>
>>>> Yeah, it looks fine, but I feel it is still fragile, and not sure it is one
>>>> accepted solution.
>>>
>>> Agree - it'd be much better to have the bio drivers provide the same
>>> guarantees that we get on the request side, rather than play games with
>>> this and pretend that concurrent update and usage is fine.
>>>
>>> -- 
>>> Jens Axboe
>>
>> And what mechanism should they use to read the queue limits?
>> * locking? (would degrade performance)
>> * percpu-rwsem? (no overhead for readers, writers wait for the RCU 
>>   synchronization)
>> * RCU?
>> * anything else?
> 
> 1) queue usage counter is for covering fast IO code path
> 
> - in __submit_bio(), queue usage counter is grabbed when calling
>   ->submit_bio()
> 
> - the only trouble should be from dm-crypt or thin-provision which offloads
> bio submission to other context, so you can grab the usage counter by
> percpu_ref_get(&q->q_usage_counter) until this bio submission or queue
> limit consumption is done

Indeed - this is an entirely solved problem already, it's just that the
bio bypassing gunk thinks it can get away with just bypassing all of
that. The mechanisms very much exist and are used by the request path,
which is why this problem doesn't exist there.

> 2) slow path: dm_set_device_limits
> 
> which is done before DM disk is on, so it should be fine by holding limit lock.
> 
> 3) changing queue limits from bio->end_io() or request completion handler
> 
> - this usage need fix

All looks reasonable.

-- 
Jens Axboe

