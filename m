Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB2F31B834
	for <dm-devel@lists.linux.dev>; Fri,  5 Sep 2025 15:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757085402; cv=none; b=gkB/H/0yeujhXDW+hiSbA2AhlBdhFq+ijANH7qj5EBJ1VfZQ3pFgmEjTxewYT3ZMIqWzmjAF5pJHrtY54QP5MdlOAAvkhyILLJLOsCO+q+i/JwgcudJi6XwjS93lo9RWUgppqwoLLERkKDIixTqFbMSM6kn1v0LAmc56ilyGSec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757085402; c=relaxed/simple;
	bh=KiRGpNUUMIDMEkc7B3GWZkLyE3LPPxFzAzvs9wTj6UQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MgX6N8OgR0bdEoB4TrtmwIDQtXd+emc3woNQNDl8SdGTm9bHekLqAMCOQ6SIXAY508/OXVyWFVqmpEbt7Fzaejmdbh41gri4EKY5WIQ8q+URWUo/0G0OMyAPWrQH0B5/4K8F5xg80/IZNtub92U/T9NmXBmZ36S2E+hJL8H1oNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RkiQ4u/l; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RkiQ4u/l"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45b89c07bb2so548265e9.0
        for <dm-devel@lists.linux.dev>; Fri, 05 Sep 2025 08:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757085399; x=1757690199; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7cquwYb3RAsWIGCvRwuFIMC2iF1JAGWJ6TBeuQ7eO4o=;
        b=RkiQ4u/lpTX5DGvk8n327tA8NTrbXdBwtwT5lW1BHeFmZy6adFEWGBwB5YAvGune/x
         aIttEBe2mRPuJwpqsmjf+5MS+vFV/6mtCi882OF0qVmryT7lJoyymk3X1nRskxC7JVs/
         wNcHTb2QFnJmo/sB2Aj3uTdqbOh5OwvEhpaRWMFV6Zm7HkddiU6djM1OoHe5zNNqk7hD
         h/7MWALRY751ynZX/3ODoMkYgh7qVCSn7ht6JjGhc3+gSCMtCW0YjAL5GTC4NvGtaBHP
         CTIt3prWo9xEttcpVDP+Xk8Twrj4xSqHEZb6ncJXq0J/1PhaZcjAfXRZM2DbBoVYRw0w
         v9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757085399; x=1757690199;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7cquwYb3RAsWIGCvRwuFIMC2iF1JAGWJ6TBeuQ7eO4o=;
        b=p78T9v2rLdggvUvNli2MgICmtoCEVSdX1eCXb1uzd+z889+P38hMfQPkCm4xT94bvO
         UBO0ZfjMBq1gMAfl9S3ahAHl+FWC1UhU2eqCtsEW6NiLiATH8obMqEEG/KHCQtGRDUg2
         6P50zWh7zn9GogSy2pvgNCMcR3nh9ivBH7sEaqe867y3gmtimLQtcUxBni4TJy6XTve3
         ZlNfLi4QxtnFgYm5NuuyHDYZZ158PzJ9Df1jfKLYp2MpYwXs80IHVVJewmvdTSOD+dqX
         0+/duTTm6LwMrmo+DH4CiJmz4MgF0+OuC5b/R/J7hWLjLqQKnR/qvrmUkG5KtVLlU3jZ
         faAg==
X-Forwarded-Encrypted: i=1; AJvYcCWZ16ZanG6xvoLu6rA5L7GgGlw9/MXMYAGsL7WXAgw0B45bwdd+ATsdwY1w53puy7M/vEGYkkoQLA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxEShYhuq21OMnuyItSAeTNX0oZB8Bfj+EsrIuYT/zmUjQAjvtp
	S6VTOhm3m5wXegs/DVId+vu0m7CTVIBBEG8BD3++IU9+ClQ8tUmuOujRafBd2t4=
X-Gm-Gg: ASbGncuadAni2FLdoyMZGBDWH3kEHHPKnjdPQPePW1JmpFbX76KsOr1cP/tHaFcpOBk
	kuiwasbCC+HL30UZQcbJeQF8+w8JH2v+p01YHlitM2VC5FYzBLwC965BjYtevc8pWXxn2Nl0ujy
	1/LS6hSWIfn/KiRREruEAyCusRyTLCHZDm267N2kytKEtxeVFjINZUheoNRYeevdhdruIMW1JSd
	qjah1gYoD8jNBFiBz1Mvy/FAFQOjbYqnV6z/fohM6nzD5eAKFyP7TboYVb/Mb5CKelExg/H7vml
	P6s2iDGMt5e0rNrlU2rkbOIAxfGIgdyXeHtUJKeKm4cBc5438z/YvS10RKByGU0/6t1VQhJKPwf
	jeapO7d9dKX5fTYBjXVF6HRtnxGP8onH7oBYOC8oJqOl8ciEfYeBB7piZjg==
X-Google-Smtp-Source: AGHT+IHXnFl0dMBbh01MvtJAkbiToqNIs/bYOKeiBJrzoDB0zgi+pY+EQEr8v9U42jXRi4tNupWHJQ==
X-Received: by 2002:adf:f8c1:0:b0:3e2:ac0:8c5e with SMTP id ffacd0b85a97d-3e20ac091a4mr2034916f8f.4.1757085398831;
        Fri, 05 Sep 2025 08:16:38 -0700 (PDT)
Received: from localhost (6.red-88-6-255.staticip.rima-tde.net. [88.6.255.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45c447244c4sm136466935e9.6.2025.09.05.08.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 08:16:38 -0700 (PDT)
Message-ID: <c4e4e746-71c4-4a9e-b20e-6e57ef222ff5@gmail.com>
Date: Fri, 5 Sep 2025 17:16:36 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] multipath-tools: remove checker from Huawei OceanStor
 NVMe
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@lists.linux.dev>
References: <20250321084649.16093-1-xose.vazquez@gmail.com>
 <3c601bea9fdb45b7a284faa9023eef33de014e9b.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <3c601bea9fdb45b7a284faa9023eef33de014e9b.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/21/25 11:52 AM, Martin Wilck wrote:

> On Fri, 2025-03-21 at 09:46 +0100, Xose Vazquez Perez wrote:
>> A keep alive timer is implemented in the NVMe-oF protocol by default,
>> which acts like a path checker.
>> Therefore, change path_checker to default, "none" for NVMe arrays.
  > I'm not sure about this. NVMe keep-alive will check the connection to
> the NVMe controller, while our path checker is designed to check the
> availability of a given NVMe namespace, which is only almost the same.
> 
> With the "none" checker, multipathd will simply trust the sysfs state.
> We have seen issues in the past (e.g. with the LIO target) where even
> use of the TUR checker resulted in paths being reinstated by multipathd
> even though they weren't actually usable, causing them to toggle back
> and forth between UP and DOWN state. I can imagine this happening for
> NVMe, too.
> 
> Does it do any harm to keep the directio checker enabled for NVMe as an
> extra safety guard?
> 
> Most people will be using native kernel multipath for NMVe these days.
> I consider dm-multipath on NVMe as a feature in maintenance mode, and
> I'd prefer applying only necessary bug fixes in the area.

Relevant info to support it at: https://github.com/opensvc/multipath-tools/commit/fbe89f4

>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Benjamin Marzinski <bmarzins@redhat.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>   libmultipath/hwtable.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>> index cf39a50d..862bfdaa 100644
>> --- a/libmultipath/hwtable.c
>> +++ b/libmultipath/hwtable.c
>> @@ -1100,7 +1100,6 @@ static struct hwentry default_hw[] = {
>>   		/* OceanStor NVMe */
>>   		.vendor        = "NVM[eE]",
>>   		.product       = "Huawei-XSG1",
>> -		.checker_name  = DIRECTIO,
>>   		.no_path_retry = 12,
>>   	},
>>   	/*
> 
