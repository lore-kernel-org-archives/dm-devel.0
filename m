Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39D71A76A4
	for <dm-devel@lists.linux.dev>; Mon,  4 Nov 2024 23:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730764215; cv=none; b=j3ZC7wgymbFzWNAYPhmGNo+g69MDvQSlGW8Ru5RQ68HW2k8TNMSxtn/o4i3/7Iy2sQiK5qW4OvtsnmSLuXh5RY14X1O1d6IjLT4Gqix1vSWSUoK7ONiTdKEYwSI4KoTHTqhG0vGZb0q1NWvSEivPURgrJ0/vi21U3rXS9Rs/poc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730764215; c=relaxed/simple;
	bh=Wacav9rSiftcbTQ8k4ZdrSjFcMU6xqF6khCaPbV+iVc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ggPizpoeTH2GF7xUmkV0tqlJUa5V9kpap9JazWyv60BS8Sw/BUFcPbeK1zNWHVXa+jYRC3dElp5UmFnwixZM4Zp8n5UKeDUb8nCDyinAZ/5HnCWYXrj1F/3rttCPlADs2ep+/SVcsyh7Zk1XHPoGvHYaMQYe05+UY71xr+e2FMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WfS5CJG9; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WfS5CJG9"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-37d6716e200so546125f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 04 Nov 2024 15:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730764212; x=1731369012; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EHyz6PqbFUPnViwx2pe8SAk2t9PuaBGC2w9E91LMtfY=;
        b=WfS5CJG92COvfDJtHs4DI+L6SyKNEOJuPXk3+8A+yQpuZOIf0iF7eu4TqlDdEOkRR/
         UxB5WH2y2nTCSXKx9j2dRKO86bwGsvn/H9ch6N2GuVpnDfj9HSmB8huxt7DffPrQP0yS
         IR5hZ4rC/hVBnBk+Rho+64ujrn+Je4n/pW6gadR2noQTt698HWCGNSbCpe6cbX6Oo0sE
         O2dGucfHnRlxOMO4G9IIqUi77jK3bT42ZoKEffTZ4zAwwm5K3m/vcKBZkolHPzAYBgyt
         ydgTTQnnvCqjB25FFHoIdkfcpDkKN2csSuFEzK7+N2+h6aBjnaibtxC/CC1w5I9BPYic
         aKCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730764212; x=1731369012;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EHyz6PqbFUPnViwx2pe8SAk2t9PuaBGC2w9E91LMtfY=;
        b=ScRmBwz2Hhot6GvAIRtb03ikxoW+pMJ8XU2gETMMFQlxcAK6OJm7lJpLvX5bCKdkbn
         H54MHAHVmQv5nGo1E1yxxcT5mOPmxpiVV46uqczzlCyhdOZRI2NLnZGHIKrg9OJO8eOF
         N8ZKebQLZrF2THHHatEnBkhOxY35+GopB23G+Eu5kiShJe2dk9KroJs3OiOQvE4ZTO2a
         JBHzH3disJTiB0Iqvep1VLHD7hMAjfXNHlvieqH/N+OvowdXpkFMyDx9oQJKlJqWICeh
         Lxi5kEtBDQ+52mbLEwA7d4NlnGnUphb0vFHZD/PO1dFtB42nw90OL6AdU6v2u19A9KQn
         7+kA==
X-Forwarded-Encrypted: i=1; AJvYcCWnRPu0NT6x8NIrd98Rey5St2oTdTUQGv8mwo5hbjqEMPwr0vPGlllT/LGgaUGbKvLGInXzHUkyAg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1/PMZWl8HSn2jTzyFxv7KX211p1bS2lRsPya966IAxS2xi9NL
	wgG7PjJvp0f0c4RrvV2KlSFZRB3ndgE/Dui/1yD6/i93MbPXbM0=
X-Google-Smtp-Source: AGHT+IFH6zZHe8C3h1ivqqTLs/Xklpb5BO0OQ0kdiDnMTlAF/865pEN9W6nVS2UsjRKkxDnxIQ2QoQ==
X-Received: by 2002:a05:600c:1c1a:b0:42c:ba83:3f08 with SMTP id 5b1f17b1804b1-4319ac743a0mr129836035e9.2.1730764211744;
        Mon, 04 Nov 2024 15:50:11 -0800 (PST)
Received: from localhost (145.red-81-44-150.dynamicip.rima-tde.net. [81.44.150.145])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4327d5ab297sm168152785e9.8.2024.11.04.15.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 15:50:10 -0800 (PST)
Message-ID: <2cea56e4-d065-41a4-aa12-54243f738717@gmail.com>
Date: Tue, 5 Nov 2024 00:50:08 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: remove hwhandler from all hwtable
 configs
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@lists.linux.dev>
References: <20241010161806.14950-1-xose.vazquez@gmail.com>
 <1ecfb9236dd2703d90727b3468dfe3381987b4b4.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
In-Reply-To: <1ecfb9236dd2703d90727b3468dfe3381987b4b4.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/3/24 10:21 PM, Martin Wilck wrote:

> On Thu, 2024-10-10 at 18:18 +0200, Xose Vazquez Perez wrote:
>> Useless, automatically handled by the kernel since 4.3.
>> (4.3 was released nine years ago)
>>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Benjamin Marzinski <bmarzins@redhat.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>   libmultipath/hwtable.c | 44 ----------------------------------------
>> --
>>   1 file changed, 44 deletions(-)
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>

Two previous ones are pending:
https://marc.info/?l=dm-devel&m=172722205013845
https://marc.info/?l=dm-devel&m=172842303913121

Thanks.
