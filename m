Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3A32EF9C7
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 16:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752164343; cv=none; b=gopDDPkFukM2EU4joGDzcoYwZgCoo5/jGsxR0P/5jAQqZ5ndOgV6zgDDP/J2aUiP4zzpUzQDZTd0YrETieF5dB/nZ6dIwTxF6XAqAXrmtP76Ce21DyOGdeaFJfh8HKkJeIR0JreScCvjqTZb4i1aTakdqgjJePdt7+cL3cTJq40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752164343; c=relaxed/simple;
	bh=aMhz7G6444lp0t2BlAIkDrFJd4RHoaYI3G/tjwB0F0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lBkNNF0QegLu9XPEhH+56EHdQPSAjF9+lv0hTky+FdG0nVEUFXSVPJZwyrmea45Mb4HjdQvGN/UJ7Cp2ZE5CTUSHZzRHwZ4cjlllSIjZVCM+oSbGLqos4tLH8jQKt59agXFKD7s4ffqBuQBuBog4AMWQtkJZu0c5y4nqAETF5vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EJP93p7P; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EJP93p7P"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ae0ccfd5ca5so158281866b.3
        for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 09:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752164340; x=1752769140; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aMhz7G6444lp0t2BlAIkDrFJd4RHoaYI3G/tjwB0F0o=;
        b=EJP93p7PLi4ZTMDLiLHP26L4IAc/7rl5CjU7VLGT+PypL4ETnzLR4WvYznbXolNO0Q
         jMjkstfV83zMzSQvLlSSgJYBQvFJDRot+gV8NfFNRpe127Ym9kHHoKFi0fL5AVF41CvT
         T3xb67rOu3fO+ljr4wlkQPQMiJjNirjGrdC6pZxSwkJ7O35evK9wF0nBUEVTZSxLqZBA
         CXvRVlkPuqWhCnxfcoPNVHAXMtrCvg3gVq0lZEqGkqfRjy+p586fNuyl84JD4zEKTI+t
         lMSjk2dfwk+SoezFK+YzTQgIrhibpQsgQ5qoyMb+1KKkFGgovVCEEMLv5KTDcSHWh/CY
         9YXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752164340; x=1752769140;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aMhz7G6444lp0t2BlAIkDrFJd4RHoaYI3G/tjwB0F0o=;
        b=ADmd+F8ILi50Ila4PdC8vxyQ0TMpfPBaQf7elt7X8AEn4eMRD9lPpPOvGo83r7VBox
         QD8+rb3Ognhx/K2RFqfplfNd8qi2Ehmh4TCXalVMAGpJeoP9Wo6I1gdzPJzMWI/Lo4Km
         cYdrur3kG7OLFxPM6V3o++MVIzQ6b+c1sWjHJDbNOoQoA1HyqEBvHkpdFWuELlV1Teo8
         onlp+4gGmiDcES5vXnzVQtCEqCh74Jhh8xdtdO4Q2Ee4u7aIvWWiifRnuhbtM0CbIPgS
         Unow/Ppmpqp2wrIMMm2bB9vfS0EJX59UA8aAEp7ip0KW4dE4m2eykEGHrHO8MsVO9kLO
         OdPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWw0GC1+qvCYYQpCns5YlRxarXmyA9aHp1WIgybuqqyHKQ39h9R+lZ/Fe/yKISQB2108IWp+N5dpw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwXlcvW0IJd2AsfvwmU4mR+ReuyS+H/sHLb3rd4bJFdyvUDX95O
	nbjffoVGbiXGStDGESDePYKwD2iHsImeDeR8HTl+Q5BTvyTQiEf44iux
X-Gm-Gg: ASbGncugIAh/prQe54xFe/v+MD0jc/esDfnl3Wd6UcB5V6ZyCnFT6dU27akP2D3M62l
	P9KoG8pVWLUnBxRgq+V5VL33nGew0hcBcaIv+i1NOx3oYX4Yb9bSMzA92hebXFmKvowv/VgIeJs
	Y5OHxA2SIfamMGjtTWavokiSSYH6bjumIncQTPbsoCeAqldl8lCHSRYKPMoeltxm1pXdcMLD1/v
	Hb49jxuvr+Gf8gAY7o3Ng7cgLe/VraypYdwN9eAZwixfoQB6rI3zM6L/e6qySbfrM3F4fhU4Jsv
	xhnUXWQi6RSVKzJZt9r1lr1BzJhdDzWo46ciCVb5UIITJKJPzI4IMUrg/Y7rbT8P3jgO1Uw5sY3
	mGgfjI2bD6rI=
X-Google-Smtp-Source: AGHT+IFsGMHvPg9GE82d2emVMb24Mqx2gELI0MrgC2RoOr8gHqJrHUVM93grDXqaNzsLo+hhqNv7Dw==
X-Received: by 2002:a17:906:9f91:b0:ae3:a799:8e84 with SMTP id a640c23a62f3a-ae6e6e3eef8mr329012566b.8.1752164339691;
        Thu, 10 Jul 2025 09:18:59 -0700 (PDT)
Received: from [192.168.2.22] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e82645dbsm155933366b.93.2025.07.10.09.18.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jul 2025 09:18:59 -0700 (PDT)
Message-ID: <130123c7-da36-4ac9-8366-5ad811360eee@gmail.com>
Date: Thu, 10 Jul 2025 18:18:58 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm-verity: remove support for asynchronous hashes
To: Bart Van Assche <bvanassche@acm.org>, Eric Biggers <ebiggers@kernel.org>,
 dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Sami Tolvanen <samitolvanen@google.com>
References: <20250709190902.49554-1-ebiggers@kernel.org>
 <1ee8338a-b19a-409a-bbe6-2068893b8abc@gmail.com>
 <48bd1925-94b6-4913-9cbc-f348e4dc4ae6@acm.org>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <48bd1925-94b6-4913-9cbc-f348e4dc4ae6@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/10/25 5:55 PM, Bart Van Assche wrote:
> On 7/10/25 1:28 AM, Milan Broz wrote:
>> Just one nitpick - could you please increase minor version of dm-
>> verity target, so we have information in debug log that it is a
>> patched version?
> Others are convinced that version numbers have no place in the upstream
> kernel and that all version information should be removed from upstream
> kernel drivers.

Others are convinced that this information from the log is very useful,
which is why we report all versions as the first step in cryptsetup tests.

This says nothing about detecting the availability of certain functions -
that is done by just trying the ioctl.
That was the discussion you are probably referring to.

I understand what you are saying, but device-mapper was constructed with
some logic that allows many variants of mapping table parameters and
reporting version is very useful to reproduce compatibility issues.
It saved me a lot of time.

Thanks,
Milan

