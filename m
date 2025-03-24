Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AAA25D536
	for <dm-devel@lists.linux.dev>; Mon, 24 Mar 2025 14:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742827819; cv=none; b=Fasdo4A0VRN7W2e32fW7SMZbtJQdUyVTkHg2UzGbMmZpRMJstJESaCCbCBj914CQiGAYhXyLiZAFxlVdRI97xK5YlvhnlWoAp/1fsNJLJA4FF4dn5aIiK9UZd+tVguf5S8voZUZXI9Bo9laSMApi08PBwLDKkSXB3C5T9QZaCuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742827819; c=relaxed/simple;
	bh=HleYglh6SNoemWJqyHcoVtw2MuympvSfAw3VGgl39t0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=k2teBxnsW/DfzDUnU1Rqv8CWvQswxMGfBsacS6XfkzDNSmsQgcnn7pdhzNHDgcDY1KyjzQ1UMaOwuCcaELrquaAdIZIkuygAB+SbHMsIVOcq1zpmcXu/DoieLO2B1IIEeZwU9Lzz2zUkni23YqBVgHsbpNEejFO/g+VWWxcIdAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Pd4O56q8; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Pd4O56q8"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7c55500d08cso436959685a.0
        for <dm-devel@lists.linux.dev>; Mon, 24 Mar 2025 07:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742827816; x=1743432616; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WJpqac8FkfRl4dKUqOI+g7NBf1RZg0PdmYi66ba3tmk=;
        b=Pd4O56q8cu9DwqsmwAYda45PU0A2Tv+RkhCx6wPvY1cjZdiOKD2IXRZNFnZrUCyt7l
         pAxg8Xcqlyu0Z3L9mGpPpyMTGQhacoxEgy4GlECj+9DLw2lLTeX4QHCArXSNT1J1y4TS
         9hFaI1IXaLMVRMUJNA+B8MQota9znRl8xnCx1qQjwKhRDbLYfzC9zGqdotj9Iu5oxZwX
         mjPSebxrNr02+0lFyZ0/deuwHll113ZWGJQov0JbXl8M86FNqQFxq9G+9slIL0ctVrcg
         Yy3Z1Av1RUC5n0NvVMTxfCRbf2XSdt3oe6QLN5mXZJghhtybD/0FJNbjNH5zGlfMAUq0
         xVrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742827816; x=1743432616;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WJpqac8FkfRl4dKUqOI+g7NBf1RZg0PdmYi66ba3tmk=;
        b=ZkrAtU0rOiP7gbNrQ0idMbWYoSD/qgZ0K/StJ10fOzfd/z3cFD/RAWdJWZyaqeUSzA
         Qlq9MD2UMRjkZhZb7VMJPVCzWTrV7rq93IGMJT+zqC+pjJbZOLUs2wz7Je73eanizPp2
         gYPToCIaxynOsR88RITOd3zLsehx7dZ8mrJVDL7li3MZjgGV8xpIXeIHUfKvb9IeQVG2
         j70rJBXP9+EI4g8xfgWybn604tDKRonrj1btezlOxK1qKgTNOpUv6c5XJzrgOrPs2NrB
         aTWZ/yRsfI+EoTzOzhCsY2r1la9Lq0bT82/LiqLiFEfow+T9poYGiQ4KMbszy1p8U+GA
         vS4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXL/7WQOfWNscZwKDROKN+qBRsppFfzeCXRECKVdaK7oX+Wpgr3pRxFZkQeOGWgaxaGx+crmFnnPQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7PaG282sqog4w6WeNcqInO+sgaAB4VTNfS+WwS805pXLhoaIr
	ZnWWoCIs8jrZA52YnnNThRjjuFotICy5vg6qCq+lie0dnIurMM/qXKY8K+TTHxQ=
X-Gm-Gg: ASbGncts4ppVjU1Jo6oRYzEmiuMFTH7QApEmGzfIgMRZa4YtK+TexeX9BGiATttEP9d
	i9sWHEuX0ECmAWVa62nEivopeM6O9SLIBoxtIWk5nv7e0Gol8cFpHSeCzgeCKK6H/fK2fIuAv34
	F5wVohs75qIl8e1nxvTB4fqDtThJNaEnLQF0sIyfuhWpIeBE1SuLlzWhECI6ouIinchr9FqI9jN
	krmiozh48LQCV9FROgW5AWnaYRsqmpwEzOAtu5/XvrK/yJ2699raEFbIhQpdacyWuVy7haMIIP6
	ITA1fEodh52T//pKdex+jCsS9Zjh9YENCaZuRSYowTMkFWdiFbkz
X-Google-Smtp-Source: AGHT+IFd6Qt3Tu+MlBCaaufmT6WIx1BbRwRxZfYtd4svimdm5Al9jd5KGVJUXvCyTu5MAy37bMvQKg==
X-Received: by 2002:a05:620a:3906:b0:7c5:4c44:db9a with SMTP id af79cd13be357-7c5ba1ee96emr1722409085a.37.1742827815673;
        Mon, 24 Mar 2025 07:50:15 -0700 (PDT)
Received: from [172.22.32.183] ([99.209.85.25])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5b935f1c1sm516602285a.117.2025.03.24.07.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 07:50:15 -0700 (PDT)
Message-ID: <aed4f9cd-863b-44b8-bc24-68ac67eb75f2@kernel.dk>
Date: Mon, 24 Mar 2025 08:50:14 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 0/5] loop: improve loop aio perf by IOCB_NOWAIT
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jooyung Han <jooyung@google.com>,
 Mike Snitzer <snitzer@kernel.org>, zkabelac@redhat.com,
 dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20250322012617.354222-1-ming.lei@redhat.com>
 <174266520675.800027.959344570613955585.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <174266520675.800027.959344570613955585.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/22/25 11:40 AM, Jens Axboe wrote:
> 
> On Sat, 22 Mar 2025 09:26:09 +0800, Ming Lei wrote:
>> This patchset improves loop aio perf by using IOCB_NOWAIT for avoiding to queue aio
>> command to workqueue context, meantime refactor lo_rw_aio() a bit.
>>
>> In my test VM, loop disk perf becomes very close to perf of the backing block
>> device(nvme/mq virtio-scsi).
>>
>> And Mikulas verified that this way can improve 12jobs sequential rw io by
>> ~5X, and basically solve the reported problem together with loop MQ change.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/5] loop: simplify do_req_filebacked()
>       commit: 04dcb8a909b5b68464ec5ccb123e9614f3ac333d
> [2/5] loop: cleanup lo_rw_aio()
>       commit: 832c9fec8e2314170c5451023565b94f05477aa7
> [3/5] loop: move command blkcg/memcg initialization into loop_queue_work
>       commit: a23d34a31758000b2b158288226bf24f96d8864d
> [4/5] loop: try to handle loop aio command via NOWAIT IO first
>       commit: dfc77a934a3acdb13dadf237b7417c6a31b19da8
> [5/5] loop: add hint for handling aio via IOCB_NOWAIT
>       commit: 4c3f4bad7a6e9022489a9f8392f7147ed3ce74b1

Just a heads-up that I had applied this for testing, not necessarily to
get included. To clear up that confusion, I have retained patches 1-3
for now, and then we can queue up 4-5/5 later when everybody is happy
with them.

-- 
Jens Axboe
