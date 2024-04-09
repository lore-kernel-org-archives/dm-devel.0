Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6CA12DDAC
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 13:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712667882; cv=none; b=JaKpzxHJCuAknNUqd05r80AO1RESpORRYtkS07dyaPEafMiEuh/zGsJtRZxCf/WPWEcXzJvFS46OD1YrRrhU5g81JyrLF5EIUaAPXRmkv4TxX32xPeP44upEbIRJos24joyrdmzw2YTIGuhFvr0JZqKLB3kNvaaPqV/VG92v9FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712667882; c=relaxed/simple;
	bh=Oe0dftIFiQOgvzXuVnuUEqlIbsFaIyCRkBFfcwWvNEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AoG9R259vH2M3z9eeRrH/n/3ry2P7eUHJlnmlS5T9kWLr4ZdjLrd0IG+MFfBFOQfFkxcbjlaqaoEw2cCP25lkhpt1+NwDgH8+ucQr2aR7SBgEQDr7Rah7QNQ1zXVLSpIWbk74BSsizaIxaubmY5KNq2OmXYljQ5C+qcwlp00Q4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DIBDlHTo; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DIBDlHTo"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a51b008b3aeso396181966b.3
        for <dm-devel@lists.linux.dev>; Tue, 09 Apr 2024 06:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712667879; x=1713272679; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=V2uIkzOvmpGiqw0cLeb9e8G4pSBEeuk8eYr+Px4tn7M=;
        b=DIBDlHTosq8K4nCTwinCdBWpEjQmB1HElQFEsugtOTyznlbme7E2kK8xVAWXvVbsC+
         QfSDUUcVVQbW4dLKycnGsUv7UXKTKGYQ7mGth9c5K/KtMR9x8RaNXzhD5Fq6t/wbl2cy
         W0cGwoSYJTsT5ZnFP9c4IJiP+9bwO2vLBz+f1R41ijxYd0Fo2eK//FbaNmbiQwBolpjZ
         TyYWpeb163gB5Z46uDxy0R4M0Xi6sZ3Q+O8i+jiIob7a4ePNymWJbv7RvLxINwmuu3Cd
         GULOMRfopki7jYMrxVrcqaWil3CJR/lXrIGFv232gBly65XhXg276EodhqB4kakRtbmA
         H4yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712667879; x=1713272679;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V2uIkzOvmpGiqw0cLeb9e8G4pSBEeuk8eYr+Px4tn7M=;
        b=qMcmwbeU9+9u3p5YL9K5/ZU3wonNE1AVH+ag31qF7tbadM/qZxBjQLh2At+tgZSaAO
         EVqMp4ns51NlqFdauZZ6S5QrGlu5egoVDnTHei5tFScrdXYn2BXCU6aafZivrl0PAFMS
         VnnHiiP3EJFh9HNiIL2W7TxARMe4G2FfPeLRyavyD9OiD+kNV/q5V7nxgee2fOoYxZZM
         K3xch5M+bSUlTBiQQNh8rkl6FDnFkvyPgbMcF8N8jyFatSL9Zp6qXDRWNt0jocjJPjgg
         d10XyXSNK+yRfIstD5tsNM+ewSrVknv2QNybuAtl/qG7D0jjP93wWmQyKOpy7UQvxCLZ
         ygBw==
X-Gm-Message-State: AOJu0YybYUXKVHgKzZalz+1Jw7rnKtceP4sBTIQn3fky5zOrwbrJAmZv
	VwLl+2qQ/VxpVBnEBH7q9Su4eI7LGGI8i7nz+5LGaV0QEjCS3/kP
X-Google-Smtp-Source: AGHT+IHw7SUUKUT4mquMtau8QI8YTl0OgLNK0Pp5fyycau54l2LjS66s9wrk9AtvuEb+I0myygK3Cg==
X-Received: by 2002:a17:907:c28a:b0:a51:b666:b372 with SMTP id tk10-20020a170907c28a00b00a51b666b372mr8672049ejc.27.1712667878480;
        Tue, 09 Apr 2024 06:04:38 -0700 (PDT)
Received: from [147.251.42.107] (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id x1-20020a170906134100b00a519ec0a965sm5628786ejb.49.2024.04.09.06.04.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 06:04:37 -0700 (PDT)
Message-ID: <970419e5-9f14-4b73-97a8-ceea45da240c@gmail.com>
Date: Tue, 9 Apr 2024 15:04:37 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend] dm-crypt: add the "high_priority" flag
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, yangerkun@huawei.com,
 Bart Van Assche <bvanassche@acm.org>, "Alasdair G. Kergon" <agk@redhat.com>,
 Laurence Oberman <loberman@redhat.com>
References: <f53ff8a9-da8e-da35-cdf8-3bd260d9af33@redhat.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <f53ff8a9-da8e-da35-cdf8-3bd260d9af33@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/24 9:36 PM, Mikulas Patocka wrote:
> It was reported that dm-crypt performs badly when the system is loaded[1].
> So I'm adding an option "high_priority" that sets the workqueues and the
> write_thread to nice level -20. This used to be default in the past, but
> it caused audio skipping, so it had to be reverted - see the commit
> f612b2132db529feac4f965f28a1b9258ea7c22b. This commit makes it optional,
> so that normal users won't be harmed by it.
> 
> [1] https://listman.redhat.com/archives/dm-devel/2023-February/053410.html

It is pity that we need an optional flag here leaving decision to the user
(I would prefer a magic workqueue setting that will self-tune automagically.)

I guess people will set it and forgot about it (until some problem reappears)
- as we can store persistent performance flags for LUKS2, so this one will
be a new option there.

...

> @@ -3399,18 +3401,22 @@ static int crypt_ctr(struct dm_target *t
>   	}
>   
>   	ret = -ENOMEM;
> -	cc->io_queue = alloc_workqueue("kcryptd_io/%s", WQ_MEM_RECLAIM, 1, devname);
> +	cc->io_queue = alloc_workqueue("kcryptd_io/%s", WQ_MEM_RECLAIM |
> +				       test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags) * WQ_HIGHPRI,
> +				       1, devname);

Just one nitpicking though:

    test_bit(...) ? WQ_HIGHPRI : 0

looks more clear/readable to me (but I guess test_bit should always return 0/1 only).

Milan
