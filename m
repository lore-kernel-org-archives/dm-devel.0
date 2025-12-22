Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DE63218A6
	for <dm-devel@lists.linux.dev>; Mon, 22 Dec 2025 15:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766416391; cv=none; b=Wt4kvxmVL/PSwiFNhER0hp5KEm0PBFA2Lc+gNbwDBcFPUKy+a8z25ff5nXnpTYqzv4OquqqTb8QwSf321d2tSwZWULWEFjz3CkN5xDOwIxETG8L/Z3B8w1PczVSKoevl7G1ZZAu9j3/WHFNWbTzoNjUu51NlQNEec6kPPvo7c/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766416391; c=relaxed/simple;
	bh=Va4ICYDJTWGWFOPwDzlSH1hQbtgJ/Ee84/CTAWfUr78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=maa8GYnG8fYMu//c743ebsIZWCBGGP5iWtRky82wbSxv7OVftfQz6clsCnjDBTllYlDsxglHrGE+NzI7jCOM67Edns9hQJtTU0naVCvAHqMLMZwmtn39LDRnS0IJPpPowHpitrkVYDskyEg7B34Y/H4fETUUgTIIK4iR5YbyQpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kg80Pj17; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kg80Pj17"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-477b198f4bcso26520375e9.3
        for <dm-devel@lists.linux.dev>; Mon, 22 Dec 2025 07:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766416387; x=1767021187; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Va4ICYDJTWGWFOPwDzlSH1hQbtgJ/Ee84/CTAWfUr78=;
        b=Kg80Pj17uCtNm/jLX2O8BrRWgZV7rXmaT0ch35pn4zEwY4iiLVPowAYl25lenR6TDa
         xmMJzBOVq0cnTxGfXPZ5lKq+fBRfd035aI0qh/tqaJe67OzUeozDxWlwNn+9QU8y9P/M
         RGFCuR0HSrjrnVBFnaBR57Qb5l+DjWatySnOuEcKGJlloxXJmS1d1WCDmLvqoEYVdWMS
         b021wgaPd2Vd4TqvkKHYTpIlt6bO9/g5qm/36dYc8XIbuy5+NDv+8sRvdzolm6EqVWqP
         Jn85W72HWIh0HoQxbXfLtmqNiul/NUmmUhofh13pD0rxwFjf9iK5WnIOK5YJJo3fwO7Y
         zBfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766416387; x=1767021187;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Va4ICYDJTWGWFOPwDzlSH1hQbtgJ/Ee84/CTAWfUr78=;
        b=XcX/E+tFvjBqJKlKCLGv5EBuMo6MtOBgmWE0UQkvvkwbR/ciclYUcQsTs11MW8Pfaz
         mVQgpjlChtP+Knbf/wqGHQdmT84VCwXn7liydkpXgmoJVIrpkfGQw9F8BhVG0Yu55R53
         zninHDMKbVZug3pZnA57FwV1vpLoPw7GDtu5IuHlwTepXbdpq51Mai4frz1ZM+Ohphid
         /QR2Q5q/C0poiu9sW7hUyYSL6f+RwUCQWiYsqeAwbfNrJBtFt9161B6RAIwFg5NdNowz
         fdrI4HMyQApCugXSY4CtkpujC2PdjYaFQjXLXgcqQy8+VqoD/DVJKFSvbF2yUve2fw00
         mryw==
X-Gm-Message-State: AOJu0Yw0UfaRj0mDw7GOPcfLxRTBDyaF6LhVOIG1h6trCRD+2qBxKk/6
	JbEoOMNnnRntSRTlmmCX0PhzVBrCMl4X8PJkXunl9EBh0y8UGIpoSfYk
X-Gm-Gg: AY/fxX7iiUrBIN6zeSaELVKLjw82WtuVAOlyVxf6efmUvBmabgn2MsRsrXNIqQXXWCk
	AHzV/mjSAbrdzVbjjcFyfJyBZdgDYT9bvKC64xYsWl56ecWXRrWiAhrgkDzT/FyJPK4zq1xLXnY
	4YMXzUzxyFFDOJrM95xbDVItFN6gmQ/nMwr5K2SIu0M5UcmhYyYPoj+N60wEo+kXdTzeDSjKcUP
	2PzCvvfrZoeDXrTEAhC2juKaC2OrWvusxXCxV44iVWrP3ggAFk2zQFCV9xG2f2e418QMow/aw2U
	TvbO709tYxIcymd9Pf7CypHngPmBTGqpcZWDXirRgK8Ek89ayLBXAw9z1Qoq4322U0TCAkxXVKz
	NwBOVjMkSAK/PyL9HPGcc4NPx/it7S0FyuGjy91zWlrdMugytMuAhN0boYfcPZ+DhBSHjXWqmgP
	I3I80h/oDhvXp/z5s=
X-Google-Smtp-Source: AGHT+IG0IoDw/WsawtOalNWNn3EGylf+z1+Iv+5gFdr7+QSWCRLfs97MQQjqtXXcjxq0577xzmJ7Og==
X-Received: by 2002:a05:600c:1d1d:b0:477:a21c:2066 with SMTP id 5b1f17b1804b1-47d19532f48mr108069635e9.5.1766416386725;
        Mon, 22 Dec 2025 07:13:06 -0800 (PST)
Received: from [192.168.1.27] ([176.74.141.242])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be274e407sm247668465e9.8.2025.12.22.07.13.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 07:13:06 -0800 (PST)
Message-ID: <0cabd3cf-232a-46f4-9ca6-b1df7fe675d5@gmail.com>
Date: Mon, 22 Dec 2025 16:13:05 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm-verity issue on 6.19
To: =?UTF-8?Q?Nuno_Gon=C3=A7alves?= <nunog@fr24.com>
Cc: dm-devel@lists.linux.dev, mpatocka@redhat.com
References: <CA+mKM5kAB0_CWDU41v8=8mLp3cd6qwhuSFenjw-17wcjvshHbQ@mail.gmail.com>
 <9027c5d6-3eb6-456a-a939-24639a3e5278@gmail.com>
 <CA+mKM5kC_rPcfOnKrvdJoDPKW3j3ATdouwrJV+Jx8kXa5u-gxg@mail.gmail.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <CA+mKM5kC_rPcfOnKrvdJoDPKW3j3ATdouwrJV+Jx8kXa5u-gxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/22/25 3:39 PM, Nuno Gonçalves wrote:
> I opened a issue with RAUC after your answer suggests there was no
> regression in user land API.

It was an addition to the status line, it should be "compatible".

That said, we were quite lucky in libcryptsetup to not fail on parse here
(I added support for this field for veritysetup recently) but I can imagine
it could break other code.

For more information, see this patch in 6.19
https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ae97648e14f7907f4b0e0b295eb2fdcf43806f9d

Milan

