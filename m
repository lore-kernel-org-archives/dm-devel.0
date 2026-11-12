Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794522178;
	b=4/DrhSDcSOHvnM3TlE1t2mNURbnxmvkJrbblAyAQak4g8kl6LinZitLHZ6RWa/abedaO
	 TKC22OMeIDpcOtQdlHsgJ4GlmXO2oRPcf+YWglJEETPLF4lkYneJ1dHEdq/jcQBigyJYQ
	 EnmBwrcLddsb0JyEQxHhFgV+MV3vE0JVpaq4qJpxHEpV1NVKuaW09sJ97H6ou2M5WV/pO
	 Qhh9Dss05megCDkcEBygk5y0es520aVxGk15wBMeQI+uzex78eRiqPyeZIsHx1+iFVkXm
	 uPbaBBhvjzTXDC/MZb5WBJUnBqZNyTH4viVZYV06q6m8NY7f/WhgyZXkG93LLHDsj0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794522178;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=FXTOhNrZ12I8y3GDlfhK3N8wnDJl6WeN76bC3bk11uk=;
	b=jqS8x9u6euFKpx51oc/VkUQH9nH/KIy5WkTk9W9znmX4rb4o2HCnnIk+eSr9MugMwFic
	 32MmiL3YU/ldPbD5+T27fNvxlX2N9iOUdKRH4x8rzLWD93I6F9Jsgo+ivV5lwQir5delV
	 5c5VL2A2L3H8JTMgIswnStOPJknsEQ+2p1/zB1HQym4/tWcsOx2lIZoRqhKTClPcPNlEI
	 GsGykhXVDeJq3QmPjnvz4y5ccQEI/1tTVxXK3UtlcYqkZSbVzMHm89I6m9vZyrchXY0hJ
	 w2k68FOiTMDgDh+avXP6PydNiJFgzvwRiPAbN5L8oUdd9G0YmzKm3JZN7Wz+kUc6D+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oQRW1kpy;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16648606A31C
	for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 22:22:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16648606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oQRW1kpy
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a215e64962so4423205e9.1
        for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 14:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794522176; x=1795126976; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FXTOhNrZ12I8y3GDlfhK3N8wnDJl6WeN76bC3bk11uk=;
        b=oQRW1kpyx/16oOi6t/w5Gak+LNrQwm1TIX6qAWhmdCvN94/f6PW8xNG3knvXeTWBFF
         SDEWPNjWsKTCWtF0aHdPct/M9RMnURnqofkZw+WWGmDog+ciN3RrWVJqREFhdbkrUWpy
         EzutklOn+sHelRsAfomGEikMo/Ln+0tH0h2oj2bQucZw2/3nLFzSAOjjQLjZIM16DGMA
         qucoebJRYGJ5u/JKv9ZSN7bNgfhVFP9oEaHEykXVCSjbL/Ij/07gomnZm+CTMKBPa4pN
         Mhp1MHeeY4mbBQG6b/2lLl2r8jC+iWlNCB37gz0AWY7PEqoA50GuDg5xi5oJhr73iJWT
         yYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794522176; x=1795126976;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FXTOhNrZ12I8y3GDlfhK3N8wnDJl6WeN76bC3bk11uk=;
        b=WIcycGYzY8lPTpH/LhXhUFGCEfCr72Xr8YmhkrPEEX3fQWZxlXRhiTt2QfpGI6GbO6
         FI3xjo8zy8tomq/yNC4zdVkHGLA4kJNynvzD5ajngt7xO2Q4F6dteajV8XY/K6b5wXtQ
         ppzP7TuLBHLDAeOmnmgnSc14aqFbo9XGLTeGN0G2bTuHjnQWcxRfuyVzRjMSp01ZfeUF
         QSEhbmiuUSwyZEKPWmiS5cO4PNMcpgEFKQIbBTd3a4FUJhEZcQ5OG2xJ+8/0cQey2TX+
         pJ52RYsHHWjK9PuOuiK5Sl5Wo+p9SZePTkD7NoFkIBKzqmETglHnEyFSjfCNgG+TTS5P
         pKRQ==
X-Forwarded-Encrypted: i=1; AL+hErESzupVCbnEjJSuzGdXejpR6/Y7Yk6fn4aKLoUq0qsrzhTKAh0zXuROuDIFHVJtlkj7J3zPNYqV4g==@lists.linux.dev
X-Gm-Message-State: APuU4Z+v50sXdxqprpbqqkWtk3TQYZueHGVsZqrBR+1+IQr7v0/qI3K/
	acA7DUVvPSESTtYIT4fmNNYSIhuBCk2TXNm2xVCogg8fXWtFWRt4x49E
X-Gm-Gg: AYBFou2t/TWIr7eC466UHkdEpDvF1Uyas6kUFyCrO/soIPW5p/AoMLXblwq7PG8peV0
	5hWB4n4G8AaP4maVK4eayDF36EwXvKrR5ZRy8oqSCuupC777b/u/XMrQ2VinUgn9zcXTt46fAZ2
	0An55RATN/zdOVIMsZUlZG1tgZImvZPyjaAB9aiO0gutiT4reMNn82AuxnblLFG6MXdH20bYpeo
	DvA84qRJBtwRmYj+s/AvFgCenZTxhRPJAGjT1bvGuYxthMBUfmaT+x1Cp+n4d1ikJNXRB9/GZBE
	CY5yU40KtpLI19S8GWX4rcdtgC9vkT698Rh03W3aX5cNIqeFSSpC6aj80cY1zrc6FUnvEJWP31E
	KmaLILJGmihbxkvJ0qnU+DxvQ9WEnzbowST08oH8aGTnvHbw788qNft8ebzSp5sQpAxyNkQXhSd
	aQXU1gajqvDC8Qm6Siao9kktPlwp0OxDoiDnwRH34JK2898RCrJJuY3hDHL5x7Te0/HJhCDRNes
	gwj8DM/IQWc4qM4DeCzcN41E7hVlMNNLGqHiYAJSX2gGeHWhdcHj2ms2rJ9NiEmr0p4iAyyBR44
	wRHw3M7zNf87h7VUsJ0yCuq7sEF9cqHlFe5CjqiMUaqRBFBkBNVZVg==
X-Received: by 2002:a05:600c:8b05:b0:4a4:4d57:8462 with SMTP id 5b1f17b1804b1-4bb55a99ed0mr13271495e9.24.1794522176352;
        Thu, 12 Nov 2026 14:22:56 -0800 (PST)
Received: from [192.168.2.14] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2842e6sm100830085e9.4.2026.11.12.14.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 14:22:56 -0800 (PST)
Message-ID: <01e0bd88-9033-4244-baea-9a1fda095b96@gmail.com>
Date: Thu, 12 Nov 2026 23:22:55 +0100
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: x86 - remove aegis128 support
To: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
 Ard Biesheuvel <ardb@kernel.org>, Antonio Quartulli <antonio@mandelbit.com>,
 =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
 dm-devel@lists.linux.dev
References: <20261112164419.1769428-4-ardb+git@google.com>
 <20261112164419.1769428-5-ardb+git@google.com>
 <20261112202329.GA815040@google.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <20261112202329.GA815040@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/26 9:23 PM, Eric Biggers wrote:
> On Thu, Nov 12, 2026 at 05:44:17PM +0100, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> Even the people that are invested in Aegis appear to have lost interest
>> in aegis128: it did win the CAESAR competition but is no longer covered
>> by RFC 10032, which does list some other variants that competed as well.
>>
>> So let's delete it.
>>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> 
> AEGIS-128 might be used by dm-crypt, e.g. if anyone passed
> '-c aegis128-random' to cryptsetup.  I added dm-devel and Milan Broz to
> Cc to comment on the feasibility of removing it.

AEGIS was introduced to kernel for dm-crypt to have real AEAD mode,
I do not think there is any other user.

At that time, there was nothing better.

Unfortunately, I am afraid it is used in some systems and removing it
completely could create issues for users. What you can do is to mark it
obsolete and expect it can be phased out later...

...

> But clearly AEGIS-128 is a mistake.  It has a hardcoded amount of
> parallelism that is much too small for current CPUs.  That was very
> clear when I looked into optimizing it with AVX-512: it just does not
> work, and it uses only a quarter of the CPU's resources.
> 
> That's resulted in AES-GCM now being much faster, as well as the people
> promoting AEGIS having abandoned AEGIS-128 and now advocating entirely
> for other variants like AEGIS-128X4 instead (despite that unfortunately
> still having a hardcoded amount of parallelism).
> 
> AEGIS-128 doesn't fare super well on the nonce front either, with it not
> being nonce-misuse-resistant, and its 128-bit nonce being only an
> incremental upgrade over AES-GCM's 96-bit nonce.  (Compare to
> XChaCha20Poly1305's or XAES-256-GCM's 192-bit nonce, or to AES-GCM-SIV
> which is nonce-misuse-resistant.)

AES-GCM is not good replacement due to that 96bit nonce.

I think other modes cannot be used in dm-crypt for AEAD mode, we will need
to check what is missing.

Milan

