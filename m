Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EA721CC63
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 19:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752176299; cv=none; b=SbfZVmblDXWt9oJ+iligKiLHgQu8i343mW2cv7WNkng7hiEM+6VQDSvuDsD9m2SSbGdI/DARZo9g+Z0HznxSdndRVwx70LT56vGzL9nHeLeZiLU4memxLcNSf/l2W7HKboDQWhsZz8jInhcaoHB3t86GfkAL12Fnb+vCliuC+GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752176299; c=relaxed/simple;
	bh=EpydmMEOedsVf9xlOOFMQVdj+4qdah4TYOqtOW4VX24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PIGU7D/Nsp6N0y3Wf047A1profThbtqQU/vBm6UP5+TVPP+/fOo5EEtje9FHVexWRLT8Z8oFHxqF7ag9WfHvOrgNpzbIXofF6Wkq8oWZuUN3EVvoHkqoL5jPIJlfINqF7BkJM/6I/1LIInK4Plw96Y3ZKo9mgldOvuBPQZaPMYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zk0KmteT; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zk0KmteT"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ae6fa02d8feso43632766b.0
        for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 12:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752176296; x=1752781096; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WnEX1TkLqy9l59pKwou4uYZ1ch+138+GFzDcgWn3s6s=;
        b=Zk0KmteTBdIHMVnmP5U/LQbdOED6yRkIOJRteFdWrJpzD4ncrPYX1td6iMS3tM88wz
         lDhGtqm4TpyGfwUz9rMfB85GTDYo1u4oTs2tKVxHfPrIsb1LLLLfEuIQFCSWyBBwHON7
         c0YJ1dy2t0cZH3N+njQG3c9QgV4DfNkDrAfjQTU0i2rZWqZsgzAyM+qnXpyDE7EpAtDk
         KnmbVf0OK8tQAV9eKRf7ssIPrYcksDgc+kbPGj45nxF59HIfNxuxqOHztIEWkZCshdDY
         lrTyFPoSHoa1rMio0oEtfGv1x3Er4FqfIgxjJ5+mGjfs2CUhkn0Vpl1sf44floqltdgx
         TO5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752176296; x=1752781096;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WnEX1TkLqy9l59pKwou4uYZ1ch+138+GFzDcgWn3s6s=;
        b=uCCW2DYGkayJDsxAE/qCmscRhfa29OvJUQawuR9UNUp+OZpBaFW7fnBS2iLRIJRsF/
         uH5D54H+KdiHFNTGwhxJKmQQ/SeGJ0GssLVfMv8/1UGQY9ycLtonD/fQZQWAiWpA8LQr
         vxIGt2g8ILS+Yo5jtzsS0HNrzQxvCSNndPQxkGFb2ZufWlUu68KRUAStKBtIzg5cdYFm
         3GnqE1Zdw2xmXkO8xxoyq9HWeahg18oMYxr7myzQmLRImu7BcRvYfURP/qFBWTB7hYAE
         uzX/xrD5W47wXoBTzg+jhPiFZYk/GP9ojo9IRi3iVQvF4i9Ky33qGeXpSdjt+Ide4p6v
         fMRA==
X-Gm-Message-State: AOJu0YwmejeHd4Uw/gtIu5qhEmFdtgySqPulP7HaAB0ipPfJlctbJ0p1
	100k584yZ3hyraI/hHikHl6tbFpJlBSc0eprP81FL5MZmS8Lkc7Wkt4nRQ94rUKHBHM=
X-Gm-Gg: ASbGncvrUycvVKULNdHqfL12KKYr4jyBXfWiaYBC1GtYZr8YIVQyrf9XtIgbSe+Sb2p
	FU5sftqSb/lVvZNByVi7/toTZFm0rdfXyN5bIElaOAZ4NJYJOC0qevkD6HgoA1KxhDliK0aY+1U
	cgBCFVd2bLRt3MFnwnJFuKIQZJQyz3gGj7xuav/6dpuAvqbUrn2g8C3kAg7QA8/RaUqtXknmzUL
	oDLznGAj1MVSYTUvtIK+6ccZUU9v9lhNV+eitinPRnDAUORZgmBMU3g3xs/rvmvMk9sHNGnHtpn
	Fbz2dRSnEXOtB44UVYLbLpUVZHe/EdG7axnvRf8PshD5oHJip8pGk4WGbHvFZuGGmg3ASHEjnsD
	ceSyJSwa5rniZ9kW2ASfoNw==
X-Google-Smtp-Source: AGHT+IGJOc+4RDACMBukNiCxNVgm8dPuY7s+X5X43NXOAupNr15X0TRH6k/v7AWJIHBMj48ZmCPKrQ==
X-Received: by 2002:a17:907:1b26:b0:ade:4593:d7cd with SMTP id a640c23a62f3a-ae6fca442f9mr38264366b.13.1752176295927;
        Thu, 10 Jul 2025 12:38:15 -0700 (PDT)
Received: from [192.168.2.22] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-611c9523a6asm1253337a12.19.2025.07.10.12.38.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jul 2025 12:38:15 -0700 (PDT)
Message-ID: <993d3ac8-8d49-422d-9f8e-c42b3af609ee@gmail.com>
Date: Thu, 10 Jul 2025 21:38:14 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm-verity: remove support for asynchronous hashes
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 linux-kernel@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Sami Tolvanen <samitolvanen@google.com>
References: <20250709190902.49554-1-ebiggers@kernel.org>
 <1ee8338a-b19a-409a-bbe6-2068893b8abc@gmail.com>
 <20250710161012.GB604603@google.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 xsFNBE94p38BEADZRET8y1gVxlfDk44/XwBbFjC7eM6EanyCuivUPMmPwYDo9qRey0JdOGhW
 hAZeutGGxsKliozmeTL25Z6wWICu2oeY+ZfbgJQYHFeQ01NVwoYy57hhytZw/6IMLFRcIaWS
 Hd7oNdneQg6mVJcGdA/BOX68uo3RKSHj6Q8GoQ54F/NpCotzVcP1ORpVJ5ptyG0x6OZm5Esn
 61pKE979wcHsz7EzcDYl+3MS63gZm+O3D1u80bUMmBUlxyEiC5jo5ksTFheA8m/5CAPQtxzY
 vgezYlLLS3nkxaq2ERK5DhvMv0NktXSutfWQsOI5WLjG7UWStwAnO2W+CVZLcnZV0K6OKDaF
 bCj4ovg5HV0FyQZknN2O5QbxesNlNWkMOJAnnX6c/zowO7jq8GCpa3oJl3xxmwFbCZtH4z3f
 EVw0wAFc2JlnufR4dhaax9fhNoUJ4OSVTi9zqstxhEyywkazakEvAYwOlC5+1FKoc9UIvApA
 GvgcTJGTOp7MuHptHGwWvGZEaJqcsqoy7rsYPxtDQ7bJuJJblzGIUxWAl8qsUsF8M4ISxBkf
 fcUYiR0wh1luUhXFo2rRTKT+Ic/nJDE66Ee4Ecn9+BPlNODhlEG1vk62rhiYSnyzy5MAUhUl
 stDxuEjYK+NGd2aYH0VANZalqlUZFTEdOdA6NYROxkYZVsVtXQARAQABzSBNaWxhbiBCcm96
 IDxnbWF6eWxhbmRAZ21haWwuY29tPsLBlQQTAQgAPwIbAwYLCQgHAwIGFQgCCQoLBBYCAwEC
 HgECF4AWIQQqKRgkP95GZI0GhvnZsFd72T6Y/AUCYaUUZgUJJPhv5wAKCRDZsFd72T6Y/D5N
 D/438pkYd5NyycQ2Gu8YAjF57Od2GfeiftCDBOMXzh1XxIx7gLosLHvzCZ0SaRYPVF/Nr/X9
 sreJVrMkwd1ILNdCQB1rLBhhKzwYFztmOYvdCG9LRrBVJPgtaYqO/0493CzXwQ7FfkEc4OVB
 uhBs4YwFu+kmhh0NngcP4jaaaIziHw/rQ9vLiAi28p1WeVTzOjtBt8QisTidS2VkZ+/iAgqB
 9zz2UPkE1UXBAPU4iEsGCVXGWRz99IULsTNjP4K3p8ZpdZ6ovy7X6EN3lYhbpmXYLzZ3RXst
 PEojSvqpkSQsjUksR5VBE0GnaY4B8ZlM3Ng2o7vcxbToQOsOkbVGn+59rpBKgiRadRFuT+2D
 x80VrwWBccaph+VOfll9/4FVv+SBQ1wSPOUHl11TWVpdMFKtQgA5/HHldVqrcEssWJb9/tew
 9pqxTDn6RHV/pfzKCspiiLVkI66BF802cpyboLBBSvcDuLHbOBHrpC+IXCZ7mgkCrgMlZMql
 wFWBjAu8Zlc5tQJPgE9eeQAQrfZRcLgux88PtxhVihA1OsMNoqYapgMzMTubLUMYCCsjrHZe
 nzw5uTcjig0RHz9ilMJlvVbhwVVLmmmf4p/R37QYaqm1RycLpvkUZUzSz2NCyTcZp9nM6ooR
 GhpDQWmUdH1Jz9T6E9//KIhI6xt4//P15ZfiIs7BTQRPeKd/ARAA3oR1fJ/D3GvnoInVqydD
 U9LGnMQaVSwQe+fjBy5/ILwo3pUZSVHdaKeVoa84gLO9g6JLToTo+ooMSBtsCkGHb//oiGTU
 7KdLTLiFh6kmL6my11eiK53o1BI1CVwWMJ8jxbMBPet6exUubBzceBFbmqq3lVz4RZ2D1zKV
 njxB0/KjdbI53anIv7Ko1k+MwaKMTzO/O6vBmI71oGQkKO6WpcyzVjLIip9PEpDUYJRCrhKg
 hBeMPwe+AntP9Om4N/3AWF6icarGImnFvTYswR2Q+C6AoiAbqI4WmXOuzJLKiImwZrSYnSfQ
 7qtdDGXWYr/N1+C+bgI8O6NuAg2cjFHE96xwJVhyaMzyROUZgm4qngaBvBvCQIhKzit61oBe
 I/drZ/d5JolzlKdZZrcmofmiCQRa+57OM3Fbl8ykFazN1ASyCex2UrftX5oHmhaeeRlGVaTV
 iEbAvU4PP4RnNKwaWQivsFhqQrfFFhvFV9CRSvsR6qu5eiFI6c8CjB49gBcKKAJ9a8gkyWs8
 sg4PYY7L15XdRn8kOf/tg98UCM1vSBV2moEJA0f98/Z48LQXNb7dgvVRtH6owARspsV6nJyD
 vktsLTyMW5BW9q4NC1rgQC8GQXjrQ+iyQLNwy5ESe2MzGKkHogxKg4Pvi1wZh9Snr+RyB0Rq
 rIrzbXhyi47+7wcAEQEAAcLBfAQYAQgAJgIbDBYhBCopGCQ/3kZkjQaG+dmwV3vZPpj8BQJh
 pRSXBQkk+HAYAAoJENmwV3vZPpj8BPMP/iZV+XROOhs/MsKd7ngQeFgETkmt8YVhb2Rg3Vgp
 AQe9cn6aw9jk3CnB0ecNBdoyyt33t3vGNau6iCwlRfaTdXg9qtIyctuCQSewY2YMk5AS8Mmb
 XoGvjH1Z/irrVsoSz+N7HFPKIlAy8D/aRwS1CHm9saPQiGoeR/zThciVYncRG/U9J6sV8XH9
 OEPnQQR4w/V1bYI9Sk+suGcSFN7pMRMsSslOma429A3bEbZ7Ikt9WTJnUY9XfL5ZqQnjLeRl
 8243OTfuHSth26upjZIQ2esccZMYpQg0/MOlHvuFuFu6MFL/gZDNzH8jAcBrNd/6ABKsecYT
 nBInKH2TONc0kC65oAhrSSBNLudTuPHce/YBCsUCAEMwgJTybdpMQh9NkS68WxQtXxU6neoQ
 U7kEJGGFsc7/yXiQXuVvJUkK/Xs04X6j0l1f/6KLoNQ9ep/2In596B0BcvvaKv7gdDt1Trgg
 vlB+GpT+iFRLvhCBe5kAERREfRfmWJq1bHod/ulrp/VLGAaZlOBTgsCzufWF5SOLbZkmV2b5
 xy2F/AU3oQUZncCvFMTWpBC+gO/o3kZCyyGCaQdQe4jS/FUJqR1suVwNMzcOJOP/LMQwujE/
 Ch7XLM35VICo9qqhih4OvLHUAWzC5dNSipL+rSGHvWBdfXDhbezJIl6sp7/1rJfS8qPs
In-Reply-To: <20250710161012.GB604603@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/10/25 6:10 PM, Eric Biggers wrote:
> On Thu, Jul 10, 2025 at 10:28:55AM +0200, Milan Broz wrote:
>> On 7/9/25 9:09 PM, Eric Biggers wrote:
>>> The support for asynchronous hashes in dm-verity has outlived its
>>> usefulness.  It adds significant code complexity and opportunity for
>>> bugs.  I don't know of anyone using it in practice.  (The original
>>> submitter of the code possibly was, but that was 8 years ago.)  Data I
>>> recently collected for en/decryption shows that using off-CPU crypto
>>> "accelerators" is consistently much slower than the CPU
>>> (https://lore.kernel.org/r/20250704070322.20692-1-ebiggers@kernel.org/),
>>> even on CPUs that lack dedicated cryptographic instructions.  Similar
>>> results are likely to be seen for hashing.
>>>
>>> I already removed support for asynchronous hashes from fsverity two
>>> years ago, and no one ever complained.
>>>
>>> Moreover, neither dm-verity, fsverity, nor fscrypt has ever actually
>>> used the asynchronous crypto algorithms in a truly asynchronous manner.
>>> The lack of interest in such optimizations provides further evidence
>>> that it's only the CPU-based crypto that actually matters.
>>>
>>> Historically, it's also been common for people to forget to enable the
>>> optimized SHA-256 code, which could contribute to an off-CPU crypto
>>> engine being perceived as more useful than it really is.  In 6.16 I
>>> fixed that: the optimized SHA-256 code is now enabled by default.
>>>
>>> Therefore, let's drop the support for asynchronous hashes in dm-verity.
>>>
>>> Tested with verity-compat-test.
>>
>> Hi,
>>
>> I shortly tested it with veritysetup too, also on 32bit.
>> And I like this patch (I wish we can remove the async thing from the dmcrypt too...)
> 
> IMO we should do it for dm-crypt too, though it's going to be a slightly
> tougher sell there because it actually goes through the trouble of using
> the async API "properly".

We tested async by replacing dm-crypt/dm-verity arg with cryptd(%s-generic).
Nice, if it really works, but... I think it is time to simplify it.

Thanks,
Milan


