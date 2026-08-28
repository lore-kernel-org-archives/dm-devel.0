Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DCDE54B
	for <dm-devel@lists.linux.dev>; Fri, 28 Aug 2026 07:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787902063; cv=none; b=P2ICBdaYsiQgeSs1he7K7DT+imgm4lf2ucAkanW8bvOPpwHSU4ZKqUQjdSq3GKQ0aS/EBxg0fPzIqImVrSuzXYbrqJYfGGefeM2sJKSr4up2XtKwn9Pq79a06P4lcmTkJ4imhl7ixynChfLtySjgjWWaWPvLoQt1cK1KHAkc2wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787902063; c=relaxed/simple;
	bh=l4EqyS9AJzsLqkTePVhh1dkAPqLmgronu2x7G0uvCEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GDEl6BwTiPhHzwH33z401Y2yKAObSde4hUbnP8n0MhURqfanXZbXUTuCQezcQ6hkyglQhhI1nTvaOuDlsXm+6qwkJGXL2qE4reH1eWV2PXg4kuN087acQw7fkOMBLVnv+ILTJzY0BRYteiS6vVpnvSBla8yKBJ7MTZlOWTuSN9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mxLM+3Iw; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mxLM+3Iw"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-495590dde14so5668575e9.0
        for <dm-devel@lists.linux.dev>; Fri, 28 Aug 2026 00:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787902060; x=1788506860; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+9WqNl1x/BE1QGYYgPLTy8LGnXJjHA8qb+UChqsY0GE=;
        b=mxLM+3Iw5ivcTfR96om/gvQ13Q0vfAskBLq2AdyozyaXSmoFshWuHl/m2khsnpT1d0
         QtVUC5wUVsrdoPIBPnWEJrclWi22YkNx4EMGn3i0VBRXocv66Y+WtSkrxunV3YZfF3/r
         6LTfqlRTgL3yHqMXfcOtsjSmKOBYtwCVHIZ4SFeMWhLtudLybjBeiKUzq7aN5XTy5hCz
         CBVEvc9den1EUDTSSnAGxoIsMEas8yZibTn1ZdLE5ecf0jU6ms7rXKisFRD/TP2UmkOl
         QkbszBkr+4oMqNy/PBIjs4tHjKsQWJ+uXJOZamaeosu5ki0Zy983ARuxKKusU1upvD0B
         FLEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787902060; x=1788506860;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+9WqNl1x/BE1QGYYgPLTy8LGnXJjHA8qb+UChqsY0GE=;
        b=eXnP7cxRSIE2YDc1n0IGYJhmsAqZAaWZ9PJZhLkKnNhgD4aXvzON2ehDGaaKEhExqM
         IPFC8HHZVBPcAEKZRdK7qZ8iZHvKERq/dJVTolDEUg2AgLTClmNG87M/2CuhP1jtS0JC
         kNl/WkheUteKLhkq1HesMO7JkcHaKmSn1V0Et5glM22ES2maIt3HdaeVNGkhW9BiQ4yK
         XnNN2HC22/XZorb5yUklkAHBkJicsd8sjl7QFl7gALfa1VkI0P9kj/Q3NjUcAIc89bCf
         bCCz2pcscLBeqc/TU4QDPgCYR64rTXTTsxPPpnnx2Grfi5lTT1VlE5ubldR0ptQe3Nk7
         w61Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro6TzlE+gHm2bHz4W/ZvClUihlKEBOeLf5gGQ2H+ffpKSZ9MqMnNawAd6aoC9MUhbynqDSvv2uJTQ==@lists.linux.dev
X-Gm-Message-State: AFuF++lLXVZUhEJFecbeY0NpEtZiajiz22lIpPEcwpP4jG8V/usHa9fe
	DnGZzDP7oagKesfogyQWfz9ecgfQNvJhd19wSw8KVLgbuC8AcaYSWE0PCdJCyw==
X-Gm-Gg: AR+sD1219zrvG3vBFAI6QkQweK0psbEdAipjlSRKr+TjgsKcGu5ucLJTKMUSEd8TxoA
	1eWCMrA3SfdKH4roenkgjZ/x0ySh+V5KB5GT65EaNIxbIkumvT5WOZ/XNWMLetDSiLkdsWgEeta
	lCKMHL81qgyEeyHXMihZCTkr3A2eLVEbdFMOGoTGq0kHCVmdSq1q0A4pUx9zTZotnBMvEvRuSxb
	IFxszClaF56W9SKvM7L+BAXy8HAl0OK9Dnwt4oKYSsbDAnoisHcIiFGd6WTh/ZiJOktttIwmjiZ
	n4qBAGJQdaN64ceJLpuGjUUJ/HWV/DEuokhOZFxv4/5G0jgOHUxMEzY3QKsgJ7R5bV13GEOlMCh
	oS6d9pG9yHHEXCHJSoTC3uP0KfwyxnRrom+SE96FgRNE1nJx4ErhtScaSwCG+nYw+ZmFlRNRapc
	fNvCnyV4zzGGwTGCQ2LEQH8IB+DnbhiA0frWHr43TqHP2jKaYxQ69aCrPazAswlTL7/UygU/DW0
	nh7Qn+mjWgF9CMAjcGQ9L2+bKGeZVRTMjRj8+gK
X-Received: by 2002:a05:600c:8885:b0:49b:909e:922e with SMTP id 5b1f17b1804b1-49b91c4884amr56116125e9.10.1787902059836;
        Fri, 28 Aug 2026 00:27:39 -0700 (PDT)
Received: from [192.168.8.101] (194-212-249-235.customers.tmcz.cz. [194.212.249.235])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9266be71sm79603525e9.2.2026.08.28.00.27.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2026 00:27:39 -0700 (PDT)
Message-ID: <9a9ff56c-b8c0-4025-9ed2-3627bb7b3cf5@gmail.com>
Date: Fri, 28 Aug 2026 09:27:37 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] `aes-gcm-random`: per-key invocation limit
To: Shukai Ni <shukai.ni@kuleuven.be>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Jo Van Bulck <jo.vanbulck@kuleuven.be>
References: <AS8PR08MB8996C8D4732C4AE5806F7890E8AD2@AS8PR08MB8996.eurprd08.prod.outlook.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <AS8PR08MB8996C8D4732C4AE5806F7890E8AD2@AS8PR08MB8996.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/27/26 9:18 PM, Shukai Ni wrote:
> Dear device-mapper maintainers,
> 
> Thank you for maintaining `dm-crypt` and `dm-integrity`. As part of a
> broader analysis of full-disk encryption in Linux, we identified a
> low-severity, defense-in-depth concern involving `aes-gcm-random` that
> we would like to understand better.
> 
> The `aes-gcm-random` implementation generates a random 96-bit IV for
> each sector encryption, but the device-mapper path does not count
> invocations or rekey automatically. The original paper [2] recommends
> IVs longer than 128 bits for this construction. Was 96 bits chosen for
> a particular compatibility, performance, or implementation reason?

IIRC due to the limitation of kernel GCM implementation.
Using 96-bit nonces is a known weak property of GCM mode for years.
  
> Section 8.3 of NIST SP 800-38D limits the RBG-based IV construction to
> 2^32 invocations across all instances using a given key. This bound is
> conservative: as shown below, the expected first collision for uniformly
> random 96-bit IVs occurs after approximately 2^48.3 invocations.
> Nevertheless, IV reuse violates GCM's security assumptions and can
> enable tag forgery, undermining both its confidentiality and integrity
> guarantees.
> 
> In our 16-core test environment, we measured the rate of pure IV
> generation and projected an expected first collision after approximately
> 30 days. We would be happy to share further details about our setup and
> methodology. We also recognize that this is an idealized projection and
> assumes a strong attacker who can continuously monitor the disk, as may
> be possible in a CVM deployment. Nevertheless, this is one of the
> deployment scenarios in which `dm-crypt` is used.

If anyone using it in this scenario, then it is insecure anyway.

An attacker model that can record all writes can easily replays individual sectors,
including auth tags. It is just not secure in this scenario.

And it is intentionally designed this way to avoid complexity.

> Ideally, the random IV would be made longer, following the recommendation
> in [2]. If that is not feasible, could the `dm-crypt` documentation state
> the 2^32 per-key limit and require userspace to rekey before reaching it?
> The kernel could also warn or refuse further writes when an in-memory
> per-mapping counter reaches the limit, while userspace remains responsible
> for accounting for key reuse across mapping reloads.

Please no.

If you want to help, then please focus on promoting better AEAD modes
(we have AEGIS in kernel, for example).

Using AEAD in dm-crypt was meant mainly to show that AEAD can be used in this
context and increase security, despite it is not ideal and cannot achieve
ideal conditions here. The whole FDE concept is designed to protect offline devices.

It can be probably used in different scenarios, but you just have to
understand its limits.

When writing [2] I expected we will have better encrypted filesystems with
properly used authenticated encryption these days....

Milan

> Kind regards,
> Shukai Ni and Jo Van Bulck
> DistriNet, KU Leuven
> 
> ## Collision estimate
> 
> For independent uniform `b`-bit IVs, the expected number of invocations
> before the first collision is approximately:
> 
> ```text
> E[N] ≈ sqrt(pi / 2) * 2^(b / 2)
> ```
> 
> For `b = 96`, this is approximately `2^48.326`, or `3.53 × 10^14`
> invocations.
> 
> ## References
> 
> 1. NIST, *Recommendation for Block Cipher Modes of Operation:
>     Galois/Counter Mode (GCM) and GMAC*, SP 800-38D,
>     https://doi.org/10.6028/NIST.SP.800-38D
> 2. Milan Brož, Mikuláš Patočka, and Vashek Matyáš, *Practical
>     Cryptographic Data Integrity Protection with Full Disk Encryption*,
>     IFIP SEC 2018,
>     https://doi.org/10.1007/978-3-319-99828-2_6

