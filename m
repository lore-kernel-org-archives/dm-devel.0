Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198A7258EFF
	for <dm-devel@lists.linux.dev>; Mon, 10 Aug 2026 13:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786368620; cv=none; b=AjqwUiGH1ErlqjVs75pfKlsyeF9OePsyj1d7iYu3TXZztSbgUZToEdg+FiDjYnme7HClkZHIYWoZkmkcarORTOMNXLYkfzH8GpPa0qCvX3XF5RtXjof5rIzf17bY8WUhEcNABfCgvaPXRDkIa6I9pGfWb9CPU4t5Sv6ekrBkbIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786368620; c=relaxed/simple;
	bh=RoroVpYgjks1KIS+UmuCL1RFjqy5V3yZLLt81K46oMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OPMbCZd2iNHFAji3I9GuhoIk3TPqWAv/vf1dNOC5CJjQUbhFwpdPLyAgnr0cbXNiPoQ5hhlZ5gGCln0evTFK1HjpyjgibROBt+QvBZ7kVADziXe3vNblLwqrRnHkvg2xjBYOsI0gaMMPl/QUagjzasX5RtqGyPHyDcIvBUsbc4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eF7L7jDd; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eF7L7jDd"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4955de8797cso12489035e9.3
        for <dm-devel@lists.linux.dev>; Mon, 10 Aug 2026 06:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786368617; x=1786973417; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r0OOgcYKgSLo07uor8VD/jjqDggG/DbvUijlifQq0Dw=;
        b=eF7L7jDd72Bb802Guq8XOi93LmI8+FDaf66TolYL+3wlmbvp1EdNCaYS4KNdGOCPDo
         VV1uDqgeIz6mcbdHE6sv3wrwjZ0q/maB00hfp2CiHWFrD8bHt1Tdvow3B6RIV2/Ho8qW
         wtYDKw+0Y2f6ICNM2hIToNZfeQhmEr3W4rcYOPTOPV3W7DXXhPoA8nSP29njo6ihmBdT
         UkElMshvlFe88Ex5Ps95gTqmW4I/1oQj4nTATL4ZDGm5L4rNzLa0BVtq56Lqa6qCsGsq
         E9Cmj3uEL5NuP1f5Y/dJtZINM3KyuZwjfGm8QnmEpYfN9bV05i3YG3VbPE61++pUm8bj
         EaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786368617; x=1786973417;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r0OOgcYKgSLo07uor8VD/jjqDggG/DbvUijlifQq0Dw=;
        b=EGD1wwDPjBJ9jPsrWeHfOSWZAHrrNFYB+ZzVMk5z8A3ayjfspTNDDTr5ZAARS1eTqd
         IAV4UD7EC1z74IBIBpaFhEVyy2v4Q1cuy++J+XDyeM3MemOFCgUu+DcpLEmGKs/TTO8U
         6AS1luqac5qgH1g2Lm4X5W8gSRDLE87eFyOmPo/YXezcGKrLLQejEZUFEPSEg7r++1dD
         Dy6TFjEcUnIidcMwT4BzPaS4vAU+YrqsvOZkE/Y7wvTKlRRnGbefgV2XvjKQsXW/P7Dy
         FAzpI+HTLG+k9FlGoTniE8Zwrm8NarMp861I/kpG+coeaeguz43gG1GFJdjvMhWou1yh
         ZOxg==
X-Forwarded-Encrypted: i=1; AHgh+RqLdoaKBq9UxavYD1H339YxTUbeIeWW5skHxUtoQf5n7ShcIA7uCRyi1jJTboRRRnh34tJ4n0qsUw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4EWm5zejHXYqXHH3EHpW6P/j59NU7Ppk/oB7nokrH3d8PqpJ0
	KpATd8bN/KopPLiXt4D7OZ8LdMSHLKrfN3Wdj26XtBs/tTb+O+fZOJcf
X-Gm-Gg: AR+sD10NH8dekyKJD4AMb0ssE8KD9un2WdxnpfQXJwnrM36Jd0rqPisK7O2XwXWP9dK
	V8/Ka2zD81GKCAfy/we0eKveySFPBDBOCVg6yBjOcCpUcU6ili1iYu5nJBBpccSzq2TU4zHCYr8
	00CKNleep7nga8jS3DmZhiMD/U500F2Bvt1MNfulVYPA7Pwkg+zRf3kpTPTktXtn9Zt/lwoIuoZ
	behwptjjQ2XQQFO1VKxdQmBNem11Uo5Jp4VOrhrsVGYFaMTG4PnKCwh1tSpyCUrB6yS6l6C9DP4
	Q9hDW2XlkR8YYiuIDB+n9lNqPv5iM6UQgmKDOEwtut+KFfrJZICWzuKYVBQekcMtPkrbSakzzjd
	IANTeuHC3+Zzglqj5+RakbXSbGwN8+uuSwFTG0sChULpuHgw0KiqpG7ZWC+wHVfkgFpVQDsfNkB
	aaAToND4YzQel3oxWFYo2/UP0TeFL7pfTzsuUszl9QnIB/a9eXkGWj3RN8SG8HVP7/jg==
X-Received: by 2002:a05:600c:a4b:b0:496:c2fd:1731 with SMTP id 5b1f17b1804b1-4997291d4f6mr17593395e9.1.1786368616965;
        Mon, 10 Aug 2026 06:30:16 -0700 (PDT)
Received: from [192.168.1.220] ([176.74.141.242])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002206effsm31694433f8f.32.2026.08.10.06.30.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 06:30:16 -0700 (PDT)
Message-ID: <f1fa5146-7b45-4019-85af-5e4727ffd200@gmail.com>
Date: Mon, 10 Aug 2026 15:30:15 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] dm-integrity: replace forgeable discard filler
 with a keyed sector marker
To: Shukai Ni <shukai.ni@kuleuven.be>, Mikulas Patocka <mpatocka@redhat.com>
Cc: "agk@redhat.com" <agk@redhat.com>, "snitzer@kernel.org"
 <snitzer@kernel.org>, "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
References: <20260728143350.44279-1-shukai.ni@kuleuven.be>
 <20260728143350.44279-2-shukai.ni@kuleuven.be>
 <5a838e63-f772-7ef9-ab45-8bc2c1ccae87@redhat.com>
 <2d413e76-2709-4d11-8bd8-b34bb7465368@gmail.com>
 <4f5d02ce-5861-6d72-83ae-70018e63b6d3@redhat.com>
 <AS8PR08MB8996C972D432810063500AAFE8DE2@AS8PR08MB8996.eurprd08.prod.outlook.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <AS8PR08MB8996C972D432810063500AAFE8DE2@AS8PR08MB8996.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/10/26 2:42 PM, Shukai Ni wrote:
>  > I updated the patch at the top of the linux-dm repository, so that keyed
>  > discard can be set, but not disabled.
> 
> Thank you, I checked the updated patch. The current code looks good to me.

FYI, this is integritysetup support MR:
https://gitlab.com/cryptsetup/cryptsetup/-/merge_requests/955

Milan


