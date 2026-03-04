Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2D72FFF89
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 08:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772612707; cv=none; b=VvnvGwK6yEN9TyNF176D5zdEFP+FOYeH13ZJU5+ovdOkM0YHtY0E68ijY7eYx6XQAWc/QFJnw7j1VEwHuGHDPGFhWP5uzL5UAxZVi4EzDpkEPIbCjhTFWLCyjqf+7LRpg1RXwmg4Y5V5fDE2l+iyLvqWHnuR0JlRoj1RVk4l9KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772612707; c=relaxed/simple;
	bh=bPCfj4BVgAlp0WCLschiKG5cQEwIgpAUohTcP3I0/Ig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BY0y+V07EL+lL86MWB8Wl1k+g10aS17xle0hEvPAGb55kkzHgEEc+dprSKzKzR3eXrOLzGeaQraRuYVwHLG9iHjypo5VHLhPEMQnF0CuNUTKy/CfKpOqU/NsifWiTA1CilQkzN4poKDc3/vVHnkGluxhmi9RIq6slUtFGrT84W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CTgzNP/E; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CTgzNP/E"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-483a233819aso64040825e9.3
        for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 00:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772612704; x=1773217504; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=485qL9Bol3ttlOIlH/DB6ibgkrc2ZHJwMdW86SfUejo=;
        b=CTgzNP/EGi2aAmPsSGWmbZi9dLI3jkQhc6DxeZUrZCkWr+Xtp5ZCqe9jdShMZo7Ig9
         OMiDlm3FfBfdY3GcBgL/wc1ro9cL+uNxdHPwyMgF7MUxDt87a+YVNisO2NBWb2FCcTBS
         KZd4Xn6c8LFcdsxhDS+6AY2LdXrE4wn0jG9h17OAnhoIdCZ3xXYxrqiuzn5w4lEiEVI9
         5r6G7Z9l2lHqj1HYt2DvNqCybm6ei8/mSW1tKoQ6deNpn4l6JFVv4Mn0+Aic2VgSOWa8
         +WA8XPXezb7Bb9CASBGBDrnCcW4QuYRpJRtDY68nstyEy+UvM3+CZEx6l/Jhaj6WLL7d
         gy+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772612704; x=1773217504;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=485qL9Bol3ttlOIlH/DB6ibgkrc2ZHJwMdW86SfUejo=;
        b=VkgB1O6ouWY9yPl/Ffo/H/z1lRqHRDTMx3CYp0SdfuLABcv6KAmcbaA7vAb04fNwBq
         4zoBUyK82DzhJGPxqelf77f4ZogfQOb/JwgwUTjOb/gwcmQ0d2+vgZ9FL+z74ifwqCEn
         L+nyE0RiRQucyEIEX0Hxoybgxyu977PWI8XMJ6pSDkya5GopyW2KI3aTHMW0gh1nhDmN
         FIWJIZuerhB6oqAiWovo7GPGMrYca8ZnZWWteRzDWt0aTt5TnUk5UCM6Fc4i/1+BI6kc
         heYPSK/bRRR5SNJNJnwFtU4uJvs3FNoRTLwKvY6PkCo5Sqq+6ivcpPKS/lDNbadwtMWT
         LGZA==
X-Gm-Message-State: AOJu0Yw2OgXaCjfWGX//zR4H7qtwpn2o7Yi066hx5qkOUqq1aSLkhCFH
	IihpUvXdKaemqK0Lp98JKbcaQpxQ3LVucAtWBEJwomLUYdPqV+vOPQ5V
X-Gm-Gg: ATEYQzyhRvZINrpleeL5n5aryuN7HEP+VXKUR9r8OX+QLvPDKj3NV3oqGW1JVxawGdd
	tsGc8Tf3Zp2ivBvJmqX/ewi0A95zgV+aIHUtlpoin54QuIR5PO8fZF6MHWQrgon2LSDfyrl7Veb
	4808VAa821iJQ25xpuG5XmnjZB0iITEkrbPrZumJtef1W7iBBJD5UGXqCzpoO1IDqjVIcrm92Zz
	1b6SO5nANVLONOLNWvsXiqHeqLVVr00Ej0ViQaL5nNHg6wtTIdo/+0WGHf8gRloUG+KZ4aRDNTH
	2rrTtrhdc9p9rY1yNRH1v73q1HHp4X4JiBujyWg+TCAwlFJ+cmf9O5BzKtwhjIrwTU2N8wwgMm/
	hWoEJBf9R8uYZgroDvk25DsgTka/bNwVESZOgDXYpBPDBIvIBrxomlH9e8vWai3Ffr5dBbvn7R4
	Y/KLxCLIPts1zYwsV4mwX2CSlwqjyhLfvJjzHd+JbvncpUu94v
X-Received: by 2002:a05:600c:190e:b0:480:4a90:1af2 with SMTP id 5b1f17b1804b1-485198bb48fmr19315005e9.35.1772612703852;
        Wed, 04 Mar 2026 00:25:03 -0800 (PST)
Received: from [192.168.2.14] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b8807a4esm19682255f8f.4.2026.03.04.00.25.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 00:25:03 -0800 (PST)
Message-ID: <690a74be-4707-4bf8-8c71-685dd8831664@gmail.com>
Date: Wed, 4 Mar 2026 09:25:02 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/22] dm-verity: more FEC fixes and cleanups
To: Eric Biggers <ebiggers@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org
References: <20260206045942.52965-1-ebiggers@kernel.org>
 <CABCJKufKYMPcjiviWdGR=h5HVAmavwacsSdMNPQaaXeeL+GoFw@mail.gmail.com>
 <20260303201656.GE2846@sol>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20260303201656.GE2846@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/3/26 9:16 PM, Eric Biggers wrote:
> Unfortunately the verity-compat-test script isn't in very good shape.  I
> opened a pull request to clean it up:
> https://gitlab.com/cryptsetup/cryptsetup/-/merge_requests/890

The testing suite was written mostly as a volunteer effort for cryptsetup
to cover userspace interoperability, so it uses mostly parameters that
worked properly with many ancient kernels (root=2, etc.).

The testsuite was not intended to test the kernel in the first place,
similar to the dm-crypt one. Despite that, it has found many kernel
bugs in the past, apparently because the kernel itself lacks proper tests.

As I am the primary author of this test and have not been paid for working
on cryptsetup for years now, I have really enough of this "your code is shit,
I know better" approach without even cc'ing us.

We try not to touch tests much (e.g., refactoring) unless really necessary,
to prevent accidentally introducing regressions.
If there is a QA team validating it, it would be much simpler, but each
corporation cares only about its own corporate sh^W products.

Your approach is going exactly in the opposite direction, rewriting only
parts you are interested in, according to your taste. So now we have multiple
approaches in different scripts. I am really tempted to reject this, as it will
add us much more effort in the future.

That said, I want to add new tests there, but please at least try to think
about it from this point of view.

Thanks,
Milan

