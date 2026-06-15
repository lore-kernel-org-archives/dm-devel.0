Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D069B3ED13B
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 13:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781528841; cv=none; b=KaqGjUnyFjQG3AW8vZ5sBBrxc/ux/RyBqqW+87xSm9QKdtL0SOrxrnnFASASryJQMg1ao57p8NY0b9p1r0Q/SDxSuQg046N0vNN7H5iaj0IJLR63A1uuqRXJh1aiuM2Uj9sp2AF4gP3mAdYfrdbIXZLW+yCzZKvoRZIPzEcPevU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781528841; c=relaxed/simple;
	bh=LwM6R1rbq7AdAL/BPAXh1rvftskyM6UJW23qH3xDUOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=j0spXNLVjfsQXJUQI6mju2K4Rv5HeFo42yGqmKVKVh7j46lNoLmr9T6mId7dIifUt9mZFsIwiryWe7zoS7YICed6y0do15MC6e+y1t8+JdU1Tsj3fPRjRAV0OCZFAvNvVvWVlUJM3M++k+BY5PsvkWknB5xxRSiGC5dMK1CPQ1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lh/ao9jP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lh/ao9jP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781528839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rro0lRZrX1p8ERhwndG34Xc1qvU6VJ/ms4ahQKnw6io=;
	b=Lh/ao9jPzD0I0ctuu3W4rBou2Pd+wdXJcFdrtFM6NSqLb4hGRxK91JoAcWtit+xoEP7Kdo
	Q/KYxinjfzgYpwVq6wMJa8TMIPC3l5j+wlq5ZCwMSppGygIObSQEcKLDVbY5HIgIUfwo+f
	DmHZVy/+oQ2OqPgm2dzwPIL1enPJfN8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-Gfbk8_K7PC2n5es6NuEX8w-1; Mon, 15 Jun 2026 09:07:17 -0400
X-MC-Unique: Gfbk8_K7PC2n5es6NuEX8w-1
X-Mimecast-MFC-AGG-ID: Gfbk8_K7PC2n5es6NuEX8w_1781528836
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490aadb1386so21896555e9.0
        for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 06:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781528836; x=1782133636;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rro0lRZrX1p8ERhwndG34Xc1qvU6VJ/ms4ahQKnw6io=;
        b=HP/zwbbJ7YbVYDd3QIGKtUR5ScsZfbvjBG3CwF01v0oQiJxLwMxPkqVWshFV45TOpf
         GqANdZ/X39YTQ5wb48CAs+UxEdAYFQ3oLnMNqQQCJBgOlck5xoFxAI9tFTr6pXhG8N1k
         rpFoBxD0EAEzMXDVLNv6t6rMFs6YSXiiWyxBuAki2wkoJT0layJ5Yr4INrvXQo1C3Iv5
         pMJ+0orwBte3HjI8WRBbXa2f2tbkdii9+Vyh7Ktw+FSM9A3ouew9rK22etQ2fmA+uXd1
         VArnyqvfk6OCM8FZ6rpf/zOqz6TCVhkWXfu5ae075iH6PoNQAXxQsmyWzJv3c25EGuAQ
         bs8g==
X-Forwarded-Encrypted: i=1; AFNElJ849uzf5qcoYpLAad02Vye/9Z2+KfT6/M7UBCwW4ew4QIxEno2fFZewSiW7FeojQd5xAWHGsP9l/A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyIAg0X+uORdHBHJmiWJiySWbGg5QJF50b5e4Wn+rZFnxXwLmlj
	MrejqeOkh6Cms4aVvE/1JFWDRO6e4sVp6UdJIj1uk3Pdw9xBrFMMl4bvIqiNjnRGyjgG9iErIhX
	C5+yun3nITR5t0Fba03p9gw7bRnNKCoD0O/vfKo04mD1P1y5AjA/8DgYU4QQo
X-Gm-Gg: Acq92OEdN2O/FBS5jNU6n97jTQ8+h3TX/WH38mzYYPS/OoDDMf5slibxroatehX78fK
	IA9J1UVbd1mfIuld1wHY1qRUrrDhTBbrXlzg+Ol62+s+SLxfFK8h8rwOj2tmJVqYLQtF4YmHoX7
	NQx5FHoDZXHDO0B+QEHLeoVclZ5RMQwbQ+Xq1uzMGfQCLFZCfgrgZ3Ggz2u/PGkCS+8WaenMw/f
	IbWM/6iBlZZUnK2mAdtB7t2eat669qx+prYlrESh/06xAvpyBivTQSWw4PPsnnufEa/FbckSYfn
	VaxrkRWIE/2CtkJtaXOh7p2n90ze8vgw63pRTMnyM52IYNZpM907UaFcKCvTBSo9FflI+ah7Hba
	QZW4y/aVMbnM1
X-Received: by 2002:a05:600c:c171:b0:48a:53cb:8604 with SMTP id 5b1f17b1804b1-490ec4dfb03mr142701335e9.14.1781528836114;
        Mon, 15 Jun 2026 06:07:16 -0700 (PDT)
X-Received: by 2002:a05:600c:c171:b0:48a:53cb:8604 with SMTP id 5b1f17b1804b1-490ec4dfb03mr142700705e9.14.1781528835510;
        Mon, 15 Jun 2026 06:07:15 -0700 (PDT)
Received: from [10.43.17.48] ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea4a128csm342321565e9.0.2026.06.15.06.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 06:07:14 -0700 (PDT)
Message-ID: <31e178fc-ed41-45d9-9e85-2d114f4222a4@redhat.com>
Date: Mon, 15 Jun 2026 15:07:14 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
To: "Dr. David Alan Gilbert" <linux@treblig.org>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev
References: <ai7rnH20IYeSmY8s@gallifrey>
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: RedHat
In-Reply-To: <ai7rnH20IYeSmY8s@gallifrey>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Pb83vWPDSz9mjQWiq_oka5RjK38GCpA1W-NwQmN6k2M_1781528836
X-Mimecast-Originator: redhat.com
Content-Language: en-US, cs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dne 14. 06. 26 v 19:57 Dr. David Alan Gilbert napsal(a):
> Hi,
>    I've got a repeatable raid hang/warn and would appreciate some pointers
> as where to debug.
>    (I've been logging stuff on  https://bugzilla.kernel.org/show_bug.cgi?id=221535 )
> 
>    This started off as debugging a case where I'd get my RAID1 (on the host)
> getting a reliable 'rescheduling sector'/disk failure while running the qemu block test suite
> during a qemu build, but then I tried to build a smaller discrete
> test, and now I've got a simply triggerable warn and test hang.
> There's no errors from the underlying SATA layer on the storage,
> everything resyncs just fine.
> 
> I've got an existing LVM vg ('main') with two mirrors on sda2, and sdb2
> which are SATA disks.
> 
> # lvcreate --type mirror --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2
>

Hi

It's probably worth to say here - the '--type mirror' is the OLD (historical) 
DM mirror target implementation - this target is now in the not so active 
development as users are supposed to be using newer (and faster) md wrapped 
'--type raid1'

So if you use   'lvcreate -m1 ....'   you get 'auto-magically' this mirroring 
target.

But this obviously doesn't fix the problem if old mirror target...

Regards

Zdenek

