Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEAB13BADA
	for <dm-devel@lists.linux.dev>; Wed,  6 Mar 2024 18:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709748994; cv=none; b=i7sF/sW7AMK3XrL0zkWpS8LKSOurfFTKwPFnNS07jwJF3btO731FRTxoWiZbZcfEUbyFsEkcycZzvOun4YhjmnmNXjVHgQK3hT48IdDH2Ilus8NhbTp3HwWxOB9MEoD98IwOOSjMrtIyMahw7vcRTMYYIXPCVyI0gzayC3TnhWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709748994; c=relaxed/simple;
	bh=pbEvCseieK6L2c3rcEGEsvWRILJg0nDOUunX4PpiElE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RQ/ObZIuQK06Sc9S43bARRyNEIm2Fis95xLiaQQoNxOzIGio/pNsGUNcxQDYclHbdXHf//2QG3sNh8Ffp6RN2Zo+rj+7YtX9W+S+o086Yv6bIYTnpx90smeKRrL64qIfpnlBirABZAnskzo5smdWRc4zx6FCldZIKdAI4nEEq04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ScXyIBZY; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ScXyIBZY"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7c876b9d070so1450339f.0
        for <dm-devel@lists.linux.dev>; Wed, 06 Mar 2024 10:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709748990; x=1710353790; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+l/MrEAlbBKrCNbsFNy2QYcZrNF0TaMhrFqasjtFp7E=;
        b=ScXyIBZYIhTGzwQWALesciYTdVaMpSTrxsxp6SjhPjMGkXE3oh9aq/YzklO/enEuhy
         nAW1IuQjpPJ8QuEr2+iJIUZT8P8dIzMJfvz7+kviBHcm8LDEsRw8QUg00ZSFmcOG7uCD
         TJ7oPAzD6tdD02XzfZwnDOqMdbzR+aFq1eBST97gcqlzT81uPxBp2TAKZcQhOjcfJ4ZY
         2AsU7RICVOgke3Cv2oQ4iQpJCXP3jU73fNeKOz/3SzJ2rN++BomU+NozXydahzI80E5I
         Owss2hjQiurB6yAw2LCR56ZQojD0Mm0jpZgy7YKQFhZ2DZ7v96tvn+aNH4Ylaj99+zxk
         f8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709748990; x=1710353790;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+l/MrEAlbBKrCNbsFNy2QYcZrNF0TaMhrFqasjtFp7E=;
        b=bI9SojHjcQU2sFOeQOrkRFNyR81O7aMTkAX9G7741rddroa+aZQK1Ah+K51Y5S6DcD
         L6ie0WcbVTI+trFSYRVgiNdxiB3e6TNsBrhKiWPl1rYukuu9PTVuzPAUOR33x4jbDKj5
         tMhZSCOqq5ojG2rdMkhVFBIcJeBTu/Uzb7U9v0RvLmVUKt+sMNkNtFULpkNRXFOMzGFo
         vqjHn6aU6/bqkW9BpVNxh2KxO9dBcl3tq3uV3liKKcqX87Z+vNq4H3oI4Q/efuQ4X0F0
         2bsE48Ops5xkhiVVZ3y/R40XIcb4EJGzveagHeMlbAwxXyGfk3rZxF8Qv3Lz5FILrZB6
         E8+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUmsPBfKwUr+TUFPPmd9BkjbV00pqrQ5CBWMgQaAJBCLze1G8XOy4xUN2erZSTrxPiCfEGL0a81E96vQlm2hEIju7cxlyL8E1U=
X-Gm-Message-State: AOJu0YyKaWIVMMZo6kztTBwLux4cZ+n+9m/LWJnpgZn0wl4pEWtqpflL
	/k+3jA/IK5BG98L91GLYxcpSoHlIFQLn7d4wFkZJFO+NeApu9Orv5LCBn2lr/Q0=
X-Google-Smtp-Source: AGHT+IGMyqTag7tmYNyL6UvZ56l5Z8viSUuBX/9fvmY/Jvy4SmbtZSycErlRsDHsaibl8qfkfSpXww==
X-Received: by 2002:a05:6e02:19cd:b0:365:fe09:6431 with SMTP id r13-20020a056e0219cd00b00365fe096431mr298093ill.3.1709748990595;
        Wed, 06 Mar 2024 10:16:30 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v4-20020a056e020f8400b00365cdc51c7esm3507366ilo.30.2024.03.06.10.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 10:16:30 -0800 (PST)
Message-ID: <ba70eba5-a23c-4364-824b-83a70e26d0cc@kernel.dk>
Date: Wed, 6 Mar 2024 11:16:29 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.9 20240305
Content-Language: en-US
To: Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 Xiao Ni <xni@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Junxiao Bi <junxiao.bi@oracle.com>,
 Dan Moulding <dan@danm.net>
References: <1C22EE73-62D9-43B0-B1A2-2D3B95F774AC@fb.com>
 <Zehh9BvpfsG0tAEs@infradead.org>
 <CAPhsuW4jfcYqpoPGT8gtyZsuYjLsWodC8UM9pL0dtnc4GSoumQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAPhsuW4jfcYqpoPGT8gtyZsuYjLsWodC8UM9pL0dtnc4GSoumQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/6/24 10:27 AM, Song Liu wrote:
> Hi Christoph,
> 
> On Wed, Mar 6, 2024 at 4:30?AM Christoph Hellwig <hch@infradead.org> wrote:
>>
>> Hi Song,
>>
>> can you also send the queue limits changes on?  I'd really like to
>> have all non-scsi queue limits updates in 6.9 and have been working
>> hard on that.
> 
> Sure! Here it is.
> 
> Jens, could you please also pull the following changes.
> 
> This set by Christoph converts md to the atomic queue limits update API.

You could've just replied to the thread with "Reviewed-by" like I
suggested, would've saved both of us some time! Anyway, pulled.

-- 
Jens Axboe

