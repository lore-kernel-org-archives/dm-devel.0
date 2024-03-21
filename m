Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475E784A5A
	for <dm-devel@lists.linux.dev>; Thu, 21 Mar 2024 14:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031149; cv=none; b=FkFIeiSaEDN2FhQUaSgQ5PxmWnM32RG+wGUSKoUVhetogSkETxy+zdqcWPgN1hnBIks89Mm9kSZF9dxh7s7ptVrNmsYXg1Hye4OG2HGDAzBUG/kloDR+ZXnHpZNw9ocHqsTHb3zr0WR7ZvL+bEvEWCwTMrHBH9HdsPLqOrycAnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031149; c=relaxed/simple;
	bh=P2DFYMTjCNfvEQJxpQoG3wIyPELp4qXze9+m5kIN8Cs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TxXsKc8PMtmRSLPMGuP5UbipG5W7gHZQ2TBQ/s4TyO6hNLK5lTxUGZeq5cJQfX1f0hx3dFEXifFqhFYl9dQc8hMCmtrcxg8LYEBau6Fj8TF8+Ag9KNl5NW40VmRMD0c2nLMu/hInL9K15kYXdqhWzczMHBybtBaE3rg4zzH+KlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WAn4RALW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WAn4RALW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711031147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9duhmYv7aQVTzyvKDlOOvm7NExbzUCh42BrdU4huCQw=;
	b=WAn4RALWdvZvi/K1Ngr77hpUILQyMbLaSQAc04vCVROO+5ob0YayoYQKskNkTQy/TUIXaz
	EBt0PNxmVIdcpnl8k18B7HP3a8nHUmO5FgONzcdMqSjUtI2dWxY5I1D4om2gjbhjfUl8oL
	aA+FLi3hTBJbz5lByVt+7kvgMvAIyxs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-FkgGIi5xP4KRrd6OL5dxxQ-1; Thu, 21 Mar 2024 10:25:44 -0400
X-MC-Unique: FkgGIi5xP4KRrd6OL5dxxQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-78a087e8b70so181412985a.1
        for <dm-devel@lists.linux.dev>; Thu, 21 Mar 2024 07:25:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711031144; x=1711635944;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9duhmYv7aQVTzyvKDlOOvm7NExbzUCh42BrdU4huCQw=;
        b=wKPyrMzWZp35X+MtUQJpnt61Emw1YQ2Ryj+wl82SibOUU2Lu6HHCSNoU78jsji259q
         ZuVUaqB54HF15dannd5h/OUJ4mzX+BQkh6tf886DohHxI3oEbFyO6nKCrM3tkOISL8Yh
         MxQDIPu5iAlG4zpUmW6HJSj1qQ2+NM+XQyDTrMvg6V+iZoZfG6Lwtvt74KXkaUcnWyTD
         rfDcnNZeCzkWH5jedDx9TavIRpbu0HTGugCL+hxRmtekDOOxvkro59a7DxoKb9KylNyR
         Vf40ajQZyqUVgPwvqw+AENmJQkJrqcZFydXwoYs45NQq+tfStHobf+/x5xHPMFWyglLv
         FAPg==
X-Gm-Message-State: AOJu0Yx5wpq0ZLlyuSjwbHL2HoJ5OOrdlRV72SOB8UJIUWjxOnQlAX8+
	dRTnOkxQQxL4EIPjO7ZZI4nB4HPn87Fn3cFyhDJ7TyVlN1/AKjP5o7NATMo6fYAVKvxUw8vMjN8
	bGRx555c4YGUjvSijZSA/o9tMsiN8hmZR+g1yESxAQaXeNwJ+tTRlYaN+
X-Received: by 2002:a05:620a:1a28:b0:78a:3524:11f with SMTP id bk40-20020a05620a1a2800b0078a3524011fmr1800457qkb.10.1711031144114;
        Thu, 21 Mar 2024 07:25:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0dlRNWfs8nasV4PlLK9gDMYqweNgRFJKrZMHIIqUA8KuSuEk1g03OEqUvzHeMwQXmrwKSog==
X-Received: by 2002:a05:620a:1a28:b0:78a:3524:11f with SMTP id bk40-20020a05620a1a2800b0078a3524011fmr1800426qkb.10.1711031143804;
        Thu, 21 Mar 2024 07:25:43 -0700 (PDT)
Received: from [192.168.1.164] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id vr17-20020a05620a55b100b00789ea5b08bcsm5479686qkn.23.2024.03.21.07.25.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Mar 2024 07:25:43 -0700 (PDT)
Message-ID: <7f0a1378-18ae-5f3e-0e2d-2c371e4dc7b5@redhat.com>
Date: Thu, 21 Mar 2024 10:25:42 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] dm vdo: use kernel byteswapping routines instead of GCC
 ones
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Ken Raeburn <raeburn@redhat.com>
References: <fe10f7bf2332c868deb88bb59967fa1880b1b34f.1710970229.git.msakai@redhat.com>
 <20240321035203.GA2387@sol.localdomain>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20240321035203.GA2387@sol.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 23:52, Eric Biggers wrote:
> On Wed, Mar 20, 2024 at 05:44:05PM -0400, Matthew Sakai wrote:
>>   static __always_inline u64 getblock64(const u64 *p, int i)
>>   {
>> -#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
>> -	return p[i];
>> -#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
>> -	return __builtin_bswap64(p[i]);
>> -#else
>> -#error "can't figure out byte order"
>> -#endif
>> +	return le64_to_cpup(&p[i]);
>>   }
>>   
>>   static __always_inline void putblock64(u64 *p, int i, u64 value)
>>   {
>> -#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
>> -	p[i] = value;
>> -#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
>> -	p[i] = __builtin_bswap64(value);
>> -#else
>> -#error "can't figure out byte order"
>> -#endif
>> +	p[i] = cpu_to_le64(value);
>>   }
> 
> This is very broken.  What you're actually looking for is get_unaligned_le64()
> and put_unaligned_le64().  And they should be folded directly into the caller.
> 
> - Eric
> 

Thanks for the suggestion. We'll work on a v2 to include this.

Matt

