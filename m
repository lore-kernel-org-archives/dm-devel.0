Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD8354673
	for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 13:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732023474; cv=none; b=LXiSDv7ZYPCycjwjVNhu5ZpaLt9S1VoScyD3c66e20ZSdHcjsI9YVL+YgnQbh+/AmxKXFHfG4ZYu0UYbLp5mtkiZWEr3dMJvOX1z19ZK+TpmAynXE3MTGChXF8mjG6dNTcO4uiiDJyy0O65xbAeWDLSWyM5bECGJYR0YAUUA0bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732023474; c=relaxed/simple;
	bh=PhSglGtt7Gp0lDkxlZfE9M/UkVEvFpI3nAyPpmCdXz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=c15AIbczyIrunqIfFAwEuNXze/NCAhISqZsRhhsi15fydDXTxEfucez7+/xOnch8SQ4tQoZvB1ZzeNHjC7/uWR/J4eJMgjeMW5ubWeMccv/pdcRQa6zNnDEue6guG2GVoLHrO1BJtYKqeoq4U0GSDjIIKVcczAFWHs27H44Fnww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bm8qNclz; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bm8qNclz"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-431616c23b5so31401255e9.0
        for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 05:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732023471; x=1732628271; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mP08cOf6XzhNx0aXJG3MH1Swi68FyR4DINeBRh56qT0=;
        b=Bm8qNclzUW20GNf5X6NSS9nHAvtNTOWappojKsN+FVUeu49H9xCDwFGOY4xVCsFvVq
         Ul5rfZcLa0KFHZz26Y5Ahu483ow7QTfCsaiJICcqpfpMUH9X95wStyRA2rc9O0xOsmSV
         1hOnQQoaY+ppdqKzG11dUtl8Jyoyf15L7EkbZrR1cvcoSvGV6+2iPOZhiRdUJI5Q3xup
         UprI2JdfUPbdtbifFrjdaCgp1/kpueN54lRZ2HGqLIknOGTzeIKsFGMK6Z21WE8PzSnQ
         6pTR7q3GCkOghE3DU3lNoqb9I7mUJKKHgE6oAPkQzBe3oug3aRkGpt4zYQw6bnd4i1P+
         jvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732023471; x=1732628271;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mP08cOf6XzhNx0aXJG3MH1Swi68FyR4DINeBRh56qT0=;
        b=Bz/4hlx00mnOb8YFJXXxwRL2lpSYBmXYOlVvTcCKr4/JhwI5o98Fc6fsMYkSy+sLZm
         koJIQeN2loPTF/bM9jv+yXrJCbRnqVBrME0RAaRohsIztHa0hYg2I7C0Cmx8rlsaYSg1
         Z5gqX+NTME5f90ddk5xMY44Emz5M1E9XSAfmnIrEtiuFnDKh/+R1yq3F2Jq0bVZ+5JgR
         3fck2lbZpBWsaljuWrN2Y1Sw43gb9T029fkmj4Pk7y1X189wlOAKnrZVtLkp2jXmKDVF
         Cf/qcqdPZvf7ss5xPHOJTnWYVjErsNi1acAu8+u6iyT1kGD7VsvKXMoXtu+o3EWjOC0c
         u0PQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWhHqC9widYPa/ANXaa/MHJL5wTn6XXQMxJqNx9XfAQECEni9T1+liiRV60XRycJkS4gQ7eKlz8A==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywgk3vMAGnNhffMDtTUDuGr3JKQrw1NPf64idrfEmT+zPRz+7jr
	CGv3HNxWVCYB3Tr2URrv+qUeyDZ7fcLu+SjQNEtlf4g1tTHkR2mv
X-Google-Smtp-Source: AGHT+IErjspJywL0NTP+uGvwijGsoLMoQMuhFaGutnyMGXBNxCpMMfZAmq6VMA3gNZGj6hpjgUbzoA==
X-Received: by 2002:a05:600c:3b0a:b0:431:52da:9d89 with SMTP id 5b1f17b1804b1-432f57a984fmr28045755e9.1.1732023470529;
        Tue, 19 Nov 2024 05:37:50 -0800 (PST)
Received: from ?IPV6:2a03:a900:1000:7e9:403e:7c8b:351b:f333? ([2a03:a900:1000:7e9:403e:7c8b:351b:f333])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da27fcb4sm200922245e9.23.2024.11.19.05.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 05:37:50 -0800 (PST)
Message-ID: <686de51b-3de3-4c78-b503-1a8effe79d8a@gmail.com>
Date: Tue, 19 Nov 2024 14:37:49 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (Re ** 4)[1]: Extending "thin_trim" (about pseudo-raid)
To: =?UTF-8?Q?Thomas_Br=C3=BCcker?= <public0x05bf@bluewin.ch>,
 dm-devel@lists.linux.dev
References: <d50d1467115519a407d7a987e3e1fa0a.squirrel@main>
Content-Language: en-US, cs
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <d50d1467115519a407d7a987e3e1fa0a.squirrel@main>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 19. 11. 24 v 3:11 "Thomas Brücker" napsal(a):
> Dear Mr. Kabelac,
> 
> I have (at first) not been aware, that at the end of your mail, you asked
> me probably 'about pseudo-raid'. It is difficult for me to give you an
> abstract definition of it, so I give you an example:
> 

Hi

Hmm I'm not even sure I want to know here more details about this construct :)
but why don't you just simply create 'regular' raid4 LV  where those legs are 
located on the same storage device/PV ?

It's certainly not a 'default' nor 'suggested' way of using raid, however
with 'lvcreate --alloc anywhere'  you can certainly create any sort of mapping
without doing those very strange dmsetup mapping yourself.

And while I can 'see' a small value in having the same data stored multiple 
times on the same drive - the protection you get from this is close to nothing 
- especially with  NVMe/SSD - where they in the most cases collapse in a 
'total' way - so you simply have no access to drive at all. However what you 
get for 100% is a major drop of your storage performance.

With prices of storage these days I'd simply recommend to simply use the raid 
the way it's supposed to be used.

Regards

Zdenek

