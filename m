Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092071EDA3E
	for <dm-devel@lists.linux.dev>; Tue, 25 Mar 2025 12:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742904476; cv=none; b=WUS/nGMqAijaIHz+OSokPLOdqbjKTpdsX21cXdNC5utbY27uypB0cuBgXHjUbFKRLozt+H3TWMZ6bGjQ2EHOz8YV9gDXk6d6k2+hGR9Gw6Z1Kt0V+97f0GT9Sx0Zla7aH9q2B2rSrlmGGQKwvOD8KugJXCzkqzabI6GWyxb0TGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742904476; c=relaxed/simple;
	bh=JQ1TpxTKj7bHKUFtiQYwXPYZoIvBGgCe4Vq1CTZEOiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qsGkCgBVJx0NNYsRuFLPn1SoSlAPrxtpZ7SwtZTUNnboPLvztjgIFUk84D8IsiE11psY6fuVoiNtRkM4nQ42kz9PomaapetYz+c3v2ZzCi+I79u27DTqw1FliLXIVj8VOJ5XE/JZWOqCJqrm4TFz15uVa6Zcc6hp5bga2ScKI3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AXuUSggi; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AXuUSggi"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6eb16dfa988so57206316d6.2
        for <dm-devel@lists.linux.dev>; Tue, 25 Mar 2025 05:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742904471; x=1743509271; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Okq+mg4uFBVtDo/RBthK8NxTaYPQv+RJPHG910HZ6TU=;
        b=AXuUSggiVA5DDVP8YsyX4xiiFHWut/Io6kLeiPU7F8wI8g4hJ35WyayP295QIGbEmH
         ahyjpBbrR29o81HaVk7OY4Ns+mLABDF2NoCsrB0M+qS3wVaGC75AsGhR1JQFwHgvYzoU
         0hFbDq+3GQNG1KeXuoEsztYyogWImrVMuf+GwIpKxe0g7cIj/6v6sb1i1k+F0RgFMPkc
         qCF3IKZkNVC/aD0m7G2gXPCSjEf2+KYONAZRp10fhECToq1sdVKwF0douzZW7bGZASSz
         6QdmWtqWpfK8iJWm6FBILRmO+fOnXyhU6TgHpo9C8wH5yHnATAyu9Qtrxxq5UDoLTaDr
         4Kvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742904471; x=1743509271;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Okq+mg4uFBVtDo/RBthK8NxTaYPQv+RJPHG910HZ6TU=;
        b=uV045gDlzTkUsmHMJBE7aOYM2qLTvifHo2A/2AyBA4dXT4gXmq0djb91G+WNrdID5X
         yqm0RHQ2nQKISzGtoqVJZ9hQdAmnJGN7fY+vnOhdfp59J1jKZnRjkAS9qCPXbUiZIOaM
         cVfTrGOw6uVacJwcShYEFaS6CNJRAlW0G348E3ldd4FBNlTMarMYcemIKrXlWw5ChFMg
         oeuhlmhRsENnMb8l9o5+lwwNzvUfNwZj6FlwazGSW2FiP7f+zi20AhkL7Wcm3Bic+dBA
         +oGWuqGUVj5iFGjTaN6mxLIQGBdZXIS5Q3cCF/gP0j1j5n6VO8a5n/ZQZrGcw6bNI4b/
         rHyw==
X-Forwarded-Encrypted: i=1; AJvYcCXQROUiUii3PF9g3utE41BJ2TtedvAkDQYAOJ/7iRrM+Sv6pQgTa90WDi8x1QIIxSsIRgDyBsPURA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzdg/u4u/8Oz5QApYtBjgJQS4nHzSwvtTg4iybb8rKykn+wqFW/
	xpUKuaENyV5A4eGznrIgL5Dho9leG8kEmcb8B7O/wcrQR2w7GCUwVGg6jLbz8Nw=
X-Gm-Gg: ASbGncvBMIgZApHKECQqkn1ugViv1lSHOEKpCj80wCFOZe1j0h9ZsC1dPAiop1a4dcD
	7ZCWnSr0IVe/WH6cNIN1uUmBPefij23DZbFFgXlkuhK/u3oCD0WJG3710BbQR7mfeMi17lGTf98
	Czo7PAPR85/RTJWmwTYk1DrmYLG+iy1VT/gSqm46DqvG0xzhDJ9/Fbo+6hHRv6wVehBmdFn2r0B
	sdOPgoLSrpcafOIwA+Ny4NY3/vVep0U6dmZHIx+4wvgRyhgEkH3IPFwYIoJK1TvZRzoFznPgEj2
	lPuyrYCA5fYHb9heMskpxTyRx9rMgt1cYCQYJuY=
X-Google-Smtp-Source: AGHT+IHqicVlC93dvwSl9Qz1oKifaNh6kQc42JeoTNRZgv88WZm1Psn2JQRI1NAYAnQNKrlf6RzuWg==
X-Received: by 2002:a05:6214:2488:b0:6e8:9086:261 with SMTP id 6a1803df08f44-6eb3f27d9aamr238853416d6.3.1742904471435;
        Tue, 25 Mar 2025 05:07:51 -0700 (PDT)
Received: from [172.20.6.96] ([99.209.85.25])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eb3ef1f841sm55496406d6.44.2025.03.25.05.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 05:07:50 -0700 (PDT)
Message-ID: <034a62be-1458-407d-9595-c8263fc74ae7@kernel.dk>
Date: Tue, 25 Mar 2025 06:07:49 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 0/5] loop: improve loop aio perf by IOCB_NOWAIT
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Jooyung Han <jooyung@google.com>, Mike Snitzer <snitzer@kernel.org>,
 zkabelac@redhat.com, dm-devel@lists.linux.dev,
 Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
References: <20250322012617.354222-1-ming.lei@redhat.com>
 <174266520675.800027.959344570613955585.b4-ty@kernel.dk>
 <aed4f9cd-863b-44b8-bc24-68ac67eb75f2@kernel.dk> <Z-IN_qS0Z3Tw_fHX@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Z-IN_qS0Z3Tw_fHX@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/24/25 7:59 PM, Ming Lei wrote:
> On Mon, Mar 24, 2025 at 08:50:14AM -0600, Jens Axboe wrote:
>> On 3/22/25 11:40 AM, Jens Axboe wrote:
>>>
>>> On Sat, 22 Mar 2025 09:26:09 +0800, Ming Lei wrote:
>>>> This patchset improves loop aio perf by using IOCB_NOWAIT for avoiding to queue aio
>>>> command to workqueue context, meantime refactor lo_rw_aio() a bit.
>>>>
>>>> In my test VM, loop disk perf becomes very close to perf of the backing block
>>>> device(nvme/mq virtio-scsi).
>>>>
>>>> And Mikulas verified that this way can improve 12jobs sequential rw io by
>>>> ~5X, and basically solve the reported problem together with loop MQ change.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [1/5] loop: simplify do_req_filebacked()
>>>       commit: 04dcb8a909b5b68464ec5ccb123e9614f3ac333d
>>> [2/5] loop: cleanup lo_rw_aio()
>>>       commit: 832c9fec8e2314170c5451023565b94f05477aa7
>>> [3/5] loop: move command blkcg/memcg initialization into loop_queue_work
>>>       commit: a23d34a31758000b2b158288226bf24f96d8864d
>>> [4/5] loop: try to handle loop aio command via NOWAIT IO first
>>>       commit: dfc77a934a3acdb13dadf237b7417c6a31b19da8
>>> [5/5] loop: add hint for handling aio via IOCB_NOWAIT
>>>       commit: 4c3f4bad7a6e9022489a9f8392f7147ed3ce74b1
>>
>> Just a heads-up that I had applied this for testing, not necessarily to
>> get included. To clear up that confusion, I have retained patches 1-3
>> for now, and then we can queue up 4-5/5 later when everybody is happy
>> with them.
> 
> Fine.
> 
> I'd see the reason if there is, looks not see it anywhere, :-)
> 
> And it should have been posted on mail list.

There's no reason, it's what I emailed above. It's just that 4-5/5
aren't fully reviewed yet. We can still make 6.15 if folks are happy
with it, just wanted to ensure it had enough time on the list to ensure
that that is the case.

-- 
Jens Axboe
