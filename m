Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5FD39EF00
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 09:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772618117; cv=none; b=EL0b3NOG5qpM9y1YVWDl0lEPaHnmn0DD/MAlpXOogMqhCJyf/bq0rJgoU6qYzNt4BHZdkN2UJyU1P9eJ7XpCmwql/QVsO3kZl2DxTfR4a4jsqNRGo+e3wT+3NSmPPi32/V3Jw9/gshD86h4xLteAtK4K3Q8mz/thXLeffB29t48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772618117; c=relaxed/simple;
	bh=O0MRU27ew/SrQhFalT8ZdeJNDqEp5zlC+Wu0Yqesj+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KKKRpOv08mGRTDiAcgFtk8yeljqp85QKi+YJIWKnm9mxQFDvA2zpfsDAaZ3YByA+EH63eWHPSQK552oUrrCVkdD7IDuJdhtLGn8I4p9OfKFUPbQEvyO7CXczWLRsePD0KUR2rGRc3ooC2kxl0M1dDbkBcMbEvi8h2DyRQp9EGVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l1QhhrAQ; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l1QhhrAQ"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-439b78b638eso3225273f8f.2
        for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 01:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772618115; x=1773222915; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HhXPnr03Y/leMepxSCjQSHMXa+oDzBD6QYUvs+/AppA=;
        b=l1QhhrAQeLW/VM55StS23UCMUdSwOsikwQaDWtUeY0L9cz0GHqP0RRGl09vo2jSgRz
         AonRliYn3OcnPhQyD/+VZrRg4Rf7Is021iY3OEZd3YVdSLm5x9+TKZrZrVXSWK5hsGFo
         4XAtnK52spTjNXnuS9Ll997h0i0WVYZVbNfyQDiPs6x54ZIekIX3MGFX4l1Q1MbBy2Py
         DNzJSnf95/w+LNpsQ7vpcRke89EGepFrWqFAOipXSNwA38aFU+AYVeyWAxwtFdZO65WM
         SaL1Dhuj/9uFR8XdwieofutFUej+bXEShi9Y3ftPVVeEkuzzFzUQ484qP3KkRwPn90Mv
         AdWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772618115; x=1773222915;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhXPnr03Y/leMepxSCjQSHMXa+oDzBD6QYUvs+/AppA=;
        b=YnkF329S17Sp4hV1d32Vu4JYwc32NrDLdxnyKqTNlXkXC9T4EP037sRsoP5w8ceHBi
         SMcKHZp3/EBSGBEThQl0+w36fMRbx6LVMfy6r89PLyHGMVAPnnjCT4j/4UVsjwIUdviS
         hRWmYpvDQi92tDUoLn6ElNvM9BYhyIEGOjsq7haGZI4915+6LqzQ7xneRQYznOD/ipFV
         d4YjryJ/6+cMgCN32o7NV2FGKHeZ2YYGY97aYsKSvfU5DfwJxeTOy/+jxwwhKJXgl+SB
         wCkEf34lIrsi0Eh8VzUWK0s9gl4+KxwFggDxTB6sPJGW3BctCEcw9E8piRs7Og37Gudu
         kkyw==
X-Forwarded-Encrypted: i=1; AJvYcCVYWo+WtBPkX79oi/pJskwiHGDbVlDSjU/Z5nU/W2womOcjyFprZBKFlqCYabvTxJjZTb4Sl0/T2A==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8ThxCmLa1Zd47MjdoJTwNCr6yPmoh45FalYIvDha6ZHgpi7oT
	LVpj8WwWAWcMFIMVKxeedi3l+KUPJiDg93Ehia0abxaHaFUbkpYepsLe
X-Gm-Gg: ATEYQzxIBxS3PfuNcHFxsER4o+nJrdXPnMgMLO7OIHl1pBC3kwHvvCBoBS7NpxkfZgS
	0Hgmu2whGq8e7Wg3HAYXEToprrqlGbqQxiRp47BnARWh8jaSg1Yb2/wOE0NCRTjzIF5G8vfdbPA
	K6ufOuolyB0WmewPR+S0K+fbLVMrbaWXWHhoCSescAeue9pkANoNGzuRUb5hwA2CiHcKBPpRRMk
	nG1xfEZCzVVHG9WlFNjkZyut/pNvsDKSJeRctOBo4agV+wWgEeB64mF2h0f6y4BbUcnI+hd8CWo
	sAxSHpyIvx/0PzYMh18ShRyFsOKjt4cbkG3wa1D3VfE6n6d+zn9NK+kYR4X5rr8ZK5pAnk0gauZ
	jLWHTG5gpnRN7YG2YpNOESIWzzPq4hXKUOSIfg/fDxB1kEPicqLoaJGf/NIW3JUEKSkok6ZPLAF
	ugW+St/8/fsZTrHstwAKOzgeJtsFWZmp+7ytIsS2o=
X-Received: by 2002:a05:6000:1885:b0:439:b788:73ab with SMTP id ffacd0b85a97d-439c7fe63e5mr2428249f8f.49.1772618114586;
        Wed, 04 Mar 2026 01:55:14 -0800 (PST)
Received: from [192.168.1.116] ([176.74.141.242])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439c4489279sm9971477f8f.20.2026.03.04.01.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 01:55:14 -0800 (PST)
Message-ID: <97515a2e-38a8-4795-ba6c-45bc3b6cc507@gmail.com>
Date: Wed, 4 Mar 2026 10:55:13 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: testmgr - block Crypto API xxhash64 in FIPS mode
To: Eric Biggers <ebiggers@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: Joachim Vandersmissen <git@jvdsn.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 linux-crypto@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev
References: <20260303060509.246038-1-git@jvdsn.com>
 <aab5ptuamQ7d_tTi@infradead.org> <20260303193102.GA2846@sol>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20260303193102.GA2846@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/3/26 8:31 PM, Eric Biggers wrote:
> 
> Maybe the device-mapper maintainers have some insight into whether
> anyone is actually using xxhash64 with dm-integrity.

Someone requested to mention it in integritysetup man page
   https://gitlab.com/cryptsetup/cryptsetup/-/issues/632

I think there were more reports people are using it in some specific cases.

Milan

