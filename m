Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6E52882B7
	for <dm-devel@lists.linux.dev>; Tue, 15 Jul 2025 01:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752543330; cv=none; b=SVdm+vRaMZPshnMxtmKKQHh/U1axlh9Ba7vjVh2nc46tSR5CRt/JUh0+xqZRShJVfUyJ1t35dUJCfmuuYEM7pi907YpSWsseYu/mcqymoSfmMgMOwdu48ZTeV4MHsMVCWhqPxkeMl0GkB47aRAiIMAbuDZfzoocmpYm23GJ0A8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752543330; c=relaxed/simple;
	bh=DirssM/qiyECs+ZxPsgzPOCIKRmGradbgmdXcGo10pM=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mT7zfmPmCsx18ongJSDptt6aJ9i+YnWU0JID3kwyQI4QFgnXCTPSQkKtVowX7IOJen68yB530wlFV5djPf3snjrt2+WhXzRGA14bSw4sgfm5KZCmOXN0EpXUoLoNU3VGfBrDnykpHt8pdPA8pvFRWKHEQbBAT8nZ+958KghlpkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JyZt/eqO; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JyZt/eqO"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-237e6963f63so28968675ad.2
        for <dm-devel@lists.linux.dev>; Mon, 14 Jul 2025 18:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752543328; x=1753148128; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:cc:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kWqU4b5GJwzvnOMkfXSAT9qnGHhw/SUAFqCu4AE8WQU=;
        b=JyZt/eqOfhV/aqh9lBKI2Yc5fIGj8dJo9d2IbxZ3QHaeqjouGOS/YSSmBKuw/W30nx
         dNq7faOiX/J43+9Uj18afG3Hf23uScRG7jrdI9Aa8bz6+yOAO9Ghs8NzhTUmaE1xoIHc
         uhrhnuSEmxfJ6VAuzp31KMywQkE84Jb2QDtkYx2jbw5hOCv07lx3QfO185ALMM9tF/Nb
         056wvSBk/Od+zFkX3W4FmH0L32WJIj0YcwXpMmse+Xzw2Y+jqF7TdjBEGVfNx1jBcNuO
         8VIop8PvTGdqWWoYX2Uze1cP0AO1j7KOUewhvddrueAdGwy2n2I7nL8kc888BSvhEd3S
         LFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752543328; x=1753148128;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:cc:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kWqU4b5GJwzvnOMkfXSAT9qnGHhw/SUAFqCu4AE8WQU=;
        b=Iz5SZPO+6zqPIk3+Fhgwp4tRfizAZHKJWUSa2KziRF3C7By99TkIFAykIuenoqPGFJ
         7KQ+yuZcsUN6OAtxYnde5h+TXnDddBI/p3qkj3XpP9o3zT1JGJqg1R37O8sHDFmZ5BiS
         q4mvmrfTDbcMi+GhUFAMRBdl2HCIPznyIuSLftQ+zhWxPKLy6krpQkPon3c5ySY6GbIp
         gVcdHpUAGEiv8lsEiy8IdfRL0YZZiBl7Dr8Pfyenk6DvTkOCPsS6jx+XmYLIlyZseOxg
         A9KbVK2b6EIkqoYM5epjsXnLedPOIdPc/R3V4sbCGx7nu2qGat+1tCp36qBLx1eDVukU
         u8EA==
X-Forwarded-Encrypted: i=1; AJvYcCXonMPPDLuYoSWTlATNvHx5Y9gNKzvHyJxqN7be3ui4OlpmfvFsDn/be1ldVbbqcN+JV/4MwLVxzw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yycjk+MLI7h7u/UTmUXWKXEUJ+QJHYzSVJxqLK99zj8+InYnalp
	EdhddF3lO2MftANLHZlWq5loBnqPKbAmYJ9yNuV5E+ap4IVxhvIEcuQH
X-Gm-Gg: ASbGncuAbcKSLfvuvYMVliSYuoWIT+gTWoXeJCsFK4RAiP5WkgL6YVY9fZ/B57hUNaP
	0WsHFKrx/GH9QZUANo2/D4E97PK6lgiecMenUdy4/rt35GFmZ749CxGa3pCXHVkkzzlNtx4E8wL
	HFFbF7WueQriFFEb1cFd2PJl2Hwy8+w/CvDMqgc1MMEo5V/TdQhPhk7t2n0syVgDHaP7poW65V0
	JKXsOWn6WP8MBRNga76mgWI20XIdflQ0Vtd6ci2/mjTDOIy4MyPzCaHooECfH/OrglhLeQjTquj
	sDwyuc4rv0me8Ttz4o45ehim3/y1UqzPQg6kjVkTOzXJzGhd/a4kBiPbtIkjvneUk7hZG89aX00
	H1JnhF3qO8JAhtATba8TitGVrkG5KFWP1ww==
X-Google-Smtp-Source: AGHT+IHVvu1Myyf/p5AZNRKIaeRyNcKdGWZQBlbrWkXNlWKeq2HAAdsjdVVls1Dm9jFU3glmnLRX8w==
X-Received: by 2002:a17:902:e544:b0:23c:8f17:644c with SMTP id d9443c01a7336-23dee29622cmr226727975ad.35.1752543328542;
        Mon, 14 Jul 2025 18:35:28 -0700 (PDT)
Received: from [10.189.144.225] ([43.224.245.249])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de4334005sm99598725ad.158.2025.07.14.18.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 18:35:28 -0700 (PDT)
Message-ID: <17dbffb9-ded6-4605-a7bb-b6f2624313ed@gmail.com>
Date: Tue, 15 Jul 2025 09:35:21 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: shengyong2021@gmail.com, shengyong1@xiaomi.com, agk@redhat.com,
 snitzer@kernel.org, nhuck@google.com, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Wang Shuai <wangshuai12@xiaomi.com>
Subject: Re: [PATCH] dm-bufio: fix sched in atomic context
To: Mikulas Patocka <mpatocka@redhat.com>
References: <20250710064855.239572-1-shengyong1@xiaomi.com>
 <673ddfed-d874-9ffe-c2fe-a741e8fc69f1@redhat.com>
Content-Language: en-US, fr-CH
From: Sheng Yong <shengyong2021@gmail.com>
In-Reply-To: <673ddfed-d874-9ffe-c2fe-a741e8fc69f1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 01:17, Mikulas Patocka wrote:
> 
> 
> On Thu, 10 Jul 2025, Sheng Yong wrote:
> 
>> From: Sheng Yong <shengyong1@xiaomi.com>
>>
[..]
>>
>> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
>> index ec84ba5e93e5..caf6ae9a8b52 100644
>> --- a/drivers/md/dm-bufio.c
>> +++ b/drivers/md/dm-bufio.c
>> @@ -2742,7 +2742,9 @@ static unsigned long __evict_a_few(unsigned long nr_buffers)
>>   		__make_buffer_clean(b);
>>   		__free_buffer_wake(b);
>>   
>> +		dm_bufio_unlock(c);
>>   		cond_resched();
>> +		dm_bufio_lock(c);
>>   	}
>>   
>>   	dm_bufio_unlock(c);
>> -- 
>> 2.43.0
> 
> Hi
> 
> I accepted this patch. I changed it to:
> 
> -               cond_resched();
> +               if (need_resched()) {
> +                       dm_bufio_unlock(c);
> +                       cond_resched();
> +                       dm_bufio_lock(c);
> +               }
>          }
> 
>          dm_bufio_unlock(c);
> 
> so that we are not hammering on the dm bufio lock when scheduling is not
> needed.

Hi, Mikulas,

Thank you for the update. It looks good to me.

thanks,
Yong
> 
> Mikulas
> 

