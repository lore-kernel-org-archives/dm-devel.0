Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B14A154BE3
	for <dm-devel@lists.linux.dev>; Thu, 22 Feb 2024 17:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708622159; cv=none; b=r+UQs8vFL2xMUpt6hXgKmQdJSSczX2GbIqG7TCetDaIAQp+YPG+tTH6gxINkfcviKJaiXNxRrwOcy1eh+gNdqMSq3pYUHpXYZGVblQ6WArE4hYpNTS5xkHwWrt7OsjOYHG+BPGxXmHPore93H0iGFk2B14l8DIM9GJeniU9Wlzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708622159; c=relaxed/simple;
	bh=+uy9JLp+vVMfKJN72L01rcvqqBFHw2cwNGmOxKPGsos=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VLq37btjQqXoAWhNepoSwtehVVPml0zYy5uzX+SxBufUKNBel75+5MHZ9q5L+NdTvR0kLRL2YuLmoOtMjH8CWcpJ4o6fbcc2K7ZpErI7h1nEfxczNc8SKsEvdfwlusC/6bBwosbV20tfAKaGoEJk4W899YVARBTzKWizMfqcpS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OIIrwNq7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OIIrwNq7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708622156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oiN/ydMpJlHjOU/e8CRpGQ/0tq27wPt1nlJOG4HNtHw=;
	b=OIIrwNq7hsZgZx0RlGavRDKmNEBO7lHrcJtzxdeGeCNvldbX9vbJeoHiRYto5wVZ/QOX0n
	9rmAv3RauOxP6Kacx9mZknb6XwzzE3FXQCQcHszFqP6HprigWiloMJTOB6vECMuLPO4K/E
	RsN2inVCpET/uJu4FszdTYE/bY9sb3A=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-62SiKyciMA24B01bIi2R6A-1; Thu, 22 Feb 2024 12:15:52 -0500
X-MC-Unique: 62SiKyciMA24B01bIi2R6A-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-68f8e8012b1so290406d6.1
        for <dm-devel@lists.linux.dev>; Thu, 22 Feb 2024 09:15:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708622150; x=1709226950;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oiN/ydMpJlHjOU/e8CRpGQ/0tq27wPt1nlJOG4HNtHw=;
        b=pwC/zt0mmieECCex6FN2ucYxwKdpvou6c9LvAj+X/aHpJfwFkfyKcRSTopXzPtruY1
         YPnaEUX4aYhH1R3YE6gB7PP4Mzh6n5Y3YR34CSoldSjpa3Tmm10gAEdYm4QPRzI7HelK
         RXQOOu90feKL/bktWq6x9AyJNv5eZTlBmlp/zlBw62ivEooJ+52lLC+t+GLdmxK+QQHK
         3j4TIY9546RHmh6BCbgfURtlhbM2dFEKBYqmcnYWvqk7TCIN4KY7N8wlbtt/EoH3/UEX
         M4X4iCp/isv1afUJ3TJFHOOiSuMuL+PdUYm9LTJ1ofS6ldhh5jygW3qYNBi75CGy6hcD
         Xgsg==
X-Gm-Message-State: AOJu0Yy2ws32CrnYfOwomqcOmryedXW4qDbBoc5Anrq8nuABYgw3nxOB
	i2GYXNPU0zOJK/c1AaYKEwNVRgSxSZYmXCP5NnqTmzlRN0wiLPz0+h8dKbDKBnnMx3ImHoENBJ0
	Nc8GPE+kteazl+OnDFviHjFnbbyUUmUxrIsXHArMqmW8NnFp9d8UQdWfQ
X-Received: by 2002:a05:6214:4001:b0:68f:36a0:5e8b with SMTP id kd1-20020a056214400100b0068f36a05e8bmr17746973qvb.47.1708622150765;
        Thu, 22 Feb 2024 09:15:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQlNmq9qd+GLd1QY4wiV/+KqqdndJ4NIT8fXgxGKvRPuhnpQZsa9vH0Rgd/OkImVPpJYd8Jg==
X-Received: by 2002:a05:6214:4001:b0:68f:36a0:5e8b with SMTP id kd1-20020a056214400100b0068f36a05e8bmr17746959qvb.47.1708622150467;
        Thu, 22 Feb 2024 09:15:50 -0800 (PST)
Received: from [192.168.1.169] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id ob6-20020a0562142f8600b0068c39b7a7cfsm7129510qvb.12.2024.02.22.09.15.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Feb 2024 09:15:50 -0800 (PST)
Message-ID: <b8474363-4eb9-ed06-2464-e958a5c9c397@redhat.com>
Date: Thu, 22 Feb 2024 12:15:49 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/8] dm vdo: Modify mismatched function name
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Abaci Robot <abaci@linux.alibaba.com>
References: <20240221091731.7007-1-jiapeng.chong@linux.alibaba.com>
 <20240221091731.7007-8-jiapeng.chong@linux.alibaba.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20240221091731.7007-8-jiapeng.chong@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/21/24 04:17, Jiapeng Chong wrote:
> No functional modification involved.
> 
> drivers/md/dm-vdo/vdo.c:276: warning: expecting prototype for vdo_read_geometry_block(). Prototype was for read_geometry_block() instead.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=8273
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>   drivers/md/dm-vdo/vdo.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
> index 23a4f1d1b6dc..411c58341173 100644
> --- a/drivers/md/dm-vdo/vdo.c
> +++ b/drivers/md/dm-vdo/vdo.c
> @@ -266,7 +266,7 @@ static int __must_check initialize_thread_config(struct thread_count_config coun
>   }
>   
>   /**
> - * vdo_read_geometry_block() - Synchronously read the geometry block from a vdo's underlying block
> + * read_geometry_block() - Synchronously read the geometry block from a vdo's underlying block
>    *                             device.
>    * @vdo: The vdo whose geometry is to be read.
>    *

Thanks for the reports! I'll apply these soon.

Matt

