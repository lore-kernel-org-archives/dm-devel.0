Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9BACA64
	for <dm-devel@lists.linux.dev>; Fri, 24 Jan 2025 19:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737746781; cv=none; b=bMsS81LuDcsVLYkZyweFFfVEAp1U4YDbAMP9200Qz2K+lZM114vu+X6tuAaBDhLANpGXRWbUtW4Akg7be/v3KLvQ7DBm34YrvKjsv3XUeSOfhofUa8knGefzO9GYyp26bwUGO+i/QUPqBStNE34oBd6SB/0YUFThpm5XWzclW9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737746781; c=relaxed/simple;
	bh=ws9zJ8Y/52Ey76QPWx97URGnrT2qVGA/qICp2csHl5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qUjrIG46ZCAdsM8mFNT8yYK79ZgpisJqFXmJXmfj+QItpUZLGXFODLEsxELnQjpSeDDgbrJnIdss6VmKaeUHo05EtaP4QvC2gshT2pE5fbMXqGbIIFDUbGM348yPi9LijVEr4kVaec52KK6q3h/JGPZvkpTvsIxzVjYSpquCmJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X8I86Sfq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X8I86Sfq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737746778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XVqr3k6+vkqkfmTSGjrnRfrATe0V+ku9dsM6UV6TwE4=;
	b=X8I86SfqgCTLsulbFc+HBXtIzDRp2mXJQYt3idm7Qc3AUOXtlUZBTlU7ZAHyYrI9OCiJiO
	fPpsMGr6CT3JBQ12y5exvwgDk7ZwV79SP1t46m0zZh+KtAgxA5gu9uyx37iE9ZCCXfgynz
	pF0YOaiDFUSAiTWgYaKH00UMOS9wpOk=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-BMEUaQR3O2qkb1CIs1sSmw-1; Fri, 24 Jan 2025 14:26:16 -0500
X-MC-Unique: BMEUaQR3O2qkb1CIs1sSmw-1
X-Mimecast-MFC-AGG-ID: BMEUaQR3O2qkb1CIs1sSmw
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-e5505f613e5so8976073276.0
        for <dm-devel@lists.linux.dev>; Fri, 24 Jan 2025 11:26:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737746775; x=1738351575;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XVqr3k6+vkqkfmTSGjrnRfrATe0V+ku9dsM6UV6TwE4=;
        b=fb+9meg/PeseERcVdLnosgxpJph+Q1yeuPoym6EOhGwVCCy7k5cE8DFGFL0yrVBbWH
         G9vc/sMCmibq5fU2gRTJUVBpA0UIKcuHlsbDruYi5lzpz3iAY3SDLz1lf3ERMmfItzE/
         Xxw6VOWiJe6cyINqsBz+bEGWWd5p8xBgQ3zKdzrSolKitwJD+cDSWcdKEJg1nSA0fYVr
         V4otsHqC0wpuOhKOlay9YYwGXUJ6UJVOgA05K1J+V1ArVJ53BbSrXBUcWh7Q8TsKBEBK
         GtUfV2BjZV2wN1/Kb9M0Nh+pufmd2W8ESOBZJjC5p9fJmfT7IE0zJr46tyGxLdaRwl8T
         EGDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtyld/4aH8ZKlGriKQrGxyVXpKMYu4fH9K6OHjgktASdkvaYOlMlPsR+qKISVQTTsh+MOf7ifHVg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzi0r04K0G0oVWVdEkeWEkuZDsWEFoOJxp55riyyF7kPhczu1e5
	zFH6KTpBk/9qlXq6VnsL9y/Iow3T2W0u+ZoZd0LRHi9BVQ7hDmf1sOGlLlpFSl4Jd3i6XNo0AC7
	fG6UwAXM4umEO/JJyAZddM5DEqTcxX27/LM4+d19Q9DVwWSId8YCPTcE/
X-Gm-Gg: ASbGncv8YTPIasucmUrCrn8fVI7/W1nG0CCd+yC6tLC/yKhnm2gnD2nS2t49K5WQEKb
	4ke+2pA1FuH5Og1CoR2rvpoTec5ifTUAyW996NvZAjV2hWC3z3UsZ+ayBI9YhfqzahxbR7psG2m
	vXNlCjhjGTndEyqQSfvmJvOOJbJzVcbC9dkk4XRB3MRP4ZfYNsxOVTvr5rIrMvZuGMBbkVmf+aT
	aJjpspIrpQ81NBpwg3gbAyFiwvv3DVG1XQKk+EI8v2dX1KHs4VtqTEC8yBKnFTARgtkums=
X-Received: by 2002:a05:690c:6612:b0:6ea:6644:ddf8 with SMTP id 00721157ae682-6f75829ae26mr36800067b3.0.1737746775641;
        Fri, 24 Jan 2025 11:26:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEd1JLyS7YWHGUJ7hh9G2NQ4STBYt1PkjUoUuHOQ7yBSoEPdYmBFh4xq5w0vNcueEoKO7Ywug==
X-Received: by 2002:a05:690c:6612:b0:6ea:6644:ddf8 with SMTP id 00721157ae682-6f75829ae26mr36799967b3.0.1737746775372;
        Fri, 24 Jan 2025 11:26:15 -0800 (PST)
Received: from [192.168.1.165] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6f757a03e0bsm4461917b3.82.2025.01.24.11.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 11:26:15 -0800 (PST)
Message-ID: <2a01b7d3-5463-4638-84e6-5ab56fb64685@redhat.com>
Date: Fri, 24 Jan 2025 14:26:14 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm vdo: use a short static string for thread name
 prefix
To: John Garry <john.g.garry@oracle.com>, dm-devel@lists.linux.dev
References: <ba07663c444baf7dfe539f41f9cb088354af4106.1737584895.git.msakai@redhat.com>
 <3be87d52-2e0f-494e-8583-a80680b0a4ec@oracle.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <3be87d52-2e0f-494e-8583-a80680b0a4ec@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UKpeHDwNoKflqmL9230xadjr6oLqiQ-lVWmkNVTu-j4_1737746775
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 1/24/25 8:28 AM, John Garry wrote:
> On 22/01/2025 22:30, Matthew Sakai wrote:
>> Also remove MODULE_NAME and a BUG_ON check, both unneeded.
>>
>> This fixes a warning about string truncation in snprintf that
>> will never happen in practice:
>>
>> drivers/md/dm-vdo/vdo.c: In function ‘vdo_make’:
>> drivers/md/dm-vdo/vdo.c:564:5: error: ‘%s’ directive output may be 
>> truncated writing up to 55 bytes into a region of size 16 [- 
>> Werror=format-truncation=]
>>      "%s%u", MODULE_NAME, instance);
>>       ^~
>> drivers/md/dm-vdo/vdo.c:563:2: note: ‘snprintf’ output between 2 and 
>> 66 bytes into a destination of size 16
>>    snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
>>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>      "%s%u", MODULE_NAME, instance);
>>      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Reported-by: John Garry<john.g.garry@oracle.com>
>> Signed-off-by: Matthew Sakai<msakai@redhat.com>
>> ---
> 
> Looks ok:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
> btw, maybe there is some #include which is not required since 
> MODULE_NAME is no longer referenced. I am not sure.

I think I can cut at least one. I'll respin the patch.

It's not completely clear to me; does the Reviewed-by: tag supersede the 
Reported-by: tag, or should I include both?

Thanks.

> Cheers
> 

