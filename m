Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757C62F3C37
	for <dm-devel@lists.linux.dev>; Mon, 22 Dec 2025 14:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766413835; cv=none; b=KDNE+fcUJQPCinzidGFR+uuvh4Z5DNnKrSID6Kes0coTPuemF9V2LVs+yAiTjDQtuJzA5m0z2AkgsqTSXpqqeF3RxejpAEZZHX57KFAl07MR4tBPjeV/aJ9bGg0y6pXTRZarWImiuABbVrf29YBzpVwbk1KysSLOhaiNzY8xJo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766413835; c=relaxed/simple;
	bh=lmeaF80rxP/r7wFVLoT6l7p5dFKkh2OqObHEyvw5eQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XBRPKxF0mw5aRd3j9z/rN3I0KuM6Nd+oyDfOjwvWia4Ziv96K2OH4EMAolF7BiRUa4r1wDQ6JolC7bMmRPeJrK7pQ+kOTA/nmqu5Byk+OuLES6KHEFtIvUcpUh/HFu7xb3rxBACQKrThXO3/Js4PXHmVlDYwOWEfGZmGviFn3eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fz3nlgT4; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fz3nlgT4"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477aa218f20so24943235e9.0
        for <dm-devel@lists.linux.dev>; Mon, 22 Dec 2025 06:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766413831; x=1767018631; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xceDlGB4gnpEa/IWDfP/jxRGc+WbMW8IjsXZTKzDbBg=;
        b=Fz3nlgT46GG4qJcLosvE3lBtNNx6aLAdx4hDQ5X1Kq2ZwO8S6J5shDx7pxPQueUvzV
         C1SuMo9A2C51BvhOibJt0N+qROpFyseh4mlAa+1/852+HrJLUh48ycBGKq5LGoVcGf/k
         mpFC0ycya4f8db1gCLQ6vDoNwibPvjKl2D2X3zmZ+hUKdNbpzJ1E+ytjdC/xZbfVoevr
         c1T4ttc/5zh6DWkxi2n7gwm4SvmI+zucmFKwG1Jpz1qvFauRzcSDeLhMO5jmyN7QaU/x
         6LfhiXqFvZs0GzNZm7mFvkTwk5zVAP95iPCXuN+6YCzxF2Zxw0UKDs+in4ZMNvsClz1o
         bxQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766413831; x=1767018631;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xceDlGB4gnpEa/IWDfP/jxRGc+WbMW8IjsXZTKzDbBg=;
        b=BoLqUFllTVTIV360TJx6vfnlusEaBnVlWQmg1oHhorVIkDRPCH2pRS8mqorPn+vdN2
         WgCQfD+VtbU0iCEMx3vnm7XN3FA+jJMbB8FhQbp5g9rmvPIvXhElRjbMN5zXzyzFeIkJ
         xQkZEdv7RXRC0WAdqpHle30K0T4GUa6wWdUNbwjtAditrM1G3BUvOy9xq3rCF0u+ykd3
         RSUhn6XFmQRrMoGujIrZoVgEWh+NLw/zpIEReyLkaRADKpHNen6okq+gkMAMy1Z4LZZx
         PGRiyBY6NvJX866c6nCWRwFRD68cykN8n2BbOGaHA+VZxFJHvPXA6oJnIpAwOBUXEufq
         E3lg==
X-Forwarded-Encrypted: i=1; AJvYcCVe5Pph6kGArcAvQTmrKOYxN3Mo1AvYx+g+rDdyWp87wi97YHF62ZVvvacjDgdLdWl7V4G02Ibc5g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwbvYcaCj2Oql6f0Y18OJE/JK2dXhfVcE2c/3AvY7uWzPDFRe2L
	V2W78tG1TQg/yOu/fdgkYgwSzU56O3/Z68VikNq07pKNgeyB2LMuiOUI
X-Gm-Gg: AY/fxX5QazmwdY37pCCUO2RfAszqhyCwGd3wVbuE5Yc39rfloJTxB7cofo4VZXtZnFE
	nUt9O+nep96E5oR5o11M57KGuVYTOb9QX/3sSfGuhz67NhZH9+xE7F7vrrt3ZBCBXPX2NSLLiZ4
	6pDr1bi2z8jZeVw+AHplbxM4BHBeqnEtrfpTKttuU2Jes1+hLqXPHIEh93fW5bAQrnc2CkCe13R
	GM3Tm1fb3Q1DkpDSwCScub4+vjDCDZS+EhsvT+uZA3E6bwEAA7pDtXUuk2jMA9uo6TLFnjzdPEz
	gTYj34gNBQO0+7w69vLeEUBkO67ua9gtL9xBo59lkCF2V6dT6gfMyOc74MVz/XW05LrSWtAL/IM
	gDMOnyHXf9PW4EbTXZEcMq3qSHdyIu1tgxTxb9V/MssauWW4UpQUEl+3Ss8FNxO+uJaneg0D221
	9wgdA1ckv/Z9nxEwY=
X-Google-Smtp-Source: AGHT+IEFGMlMHAuj2t+FwfO3aDdcqqe1sPVhNCnJLFQ8/RULk33AJt8lpzsAzCcs94xLljnnwpMqKA==
X-Received: by 2002:a05:600c:4e8e:b0:477:9f34:17b8 with SMTP id 5b1f17b1804b1-47d195330dcmr109688345e9.1.1766413830463;
        Mon, 22 Dec 2025 06:30:30 -0800 (PST)
Received: from [192.168.1.27] ([176.74.141.242])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d28a33adcsm37348705e9.18.2025.12.22.06.30.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 06:30:30 -0800 (PST)
Message-ID: <9027c5d6-3eb6-456a-a939-24639a3e5278@gmail.com>
Date: Mon, 22 Dec 2025 15:30:28 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm-verity issue on 6.19
To: =?UTF-8?Q?Nuno_Gon=C3=A7alves?= <nunog@fr24.com>, dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com
References: <CA+mKM5kAB0_CWDU41v8=8mLp3cd6qwhuSFenjw-17wcjvshHbQ@mail.gmail.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <CA+mKM5kAB0_CWDU41v8=8mLp3cd6qwhuSFenjw-17wcjvshHbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/22/25 12:57 PM, Nuno GonÃ§alves wrote:
> I know nothing about DM, but the issue happens when doing a ioctl
> DM_TABLE_STATUS with params:

What do you mean by params? Status should not need any special params on input.

Anyway, dm-verity in 6.19 now reports also number of error-corrected blocks in status line.
If FEC is not used, it contains "-", for example

# dmsetup status test
0 417792 verity V -

> 1 /dev/loop0 /dev/loop0 4096 4096 9 9 sha256
> 48048ef2c63d1c69a817508db0d3ff387ce33b10ec8fd0972bd29268836014a0
> 46c92f189b2036f93ec5805fb956adc134f8c17513bb51502f5cf92cf64fefe7
> 
> And after calling it params was expected to be empty (\0), and now it is "V -".

Could you please be more specific what command/ioctl you call here
and post exact steps to reproduce different behavior here?

The string above is table (dmsetup table), not status (dmsetup status).

Isn't you code just confused by a new parameter in status line?

Milan

