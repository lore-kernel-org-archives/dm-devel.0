Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA892046A3
	for <dm-devel@lists.linux.dev>; Wed,  8 Jan 2025 22:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736376277; cv=none; b=pqDqmmTaef58m7510Ad7JdgsmhZkMR3MMcm8bLlKb+Ry8iVn87+MybsAislyRV/qwskZwZ7ZJhlMXNoGXmeyx8arjJGAk6XwDQTb2FzVieSNADERfHeL/vccNMIp89OQ3BwtHtqfIgYqH8zV75Hj9QldTkq/PB8sBsERXshwHDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736376277; c=relaxed/simple;
	bh=poleoVaI0q6tx9Hm52GnsA+leziODa+1byTkc3l1P3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZGVps7USzM+pG8fj3b6DWzMzHk3kBdR2mH6HdVo7stnya2SOBw5A4H5w/WZDJVhZOsqiwga7qcuWI1+DgaKrMbzrXcGxwmECWkPz3ee47cpFWR6fSPiMtrbMaDu8mdgvMgreyHxhfEwuzsrlC4UeCwQIyPhdtnxQbJsw6tZZqwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fld/AGP1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fld/AGP1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736376274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ThvP+0+k+VZgLp2vSCgmUNo9IP7bU0ag/O1mEnImvpg=;
	b=fld/AGP1eJz1VUqZbaWfUXhm2dPxeXm79t+vRTKu8VFO3pNZ5g9vvpQAXgZUidwqd9aLJJ
	0IXQJ0t8fzq/vQjE4JGCqFra609oTB4gi05YOuFjRFGh5RIgzoALDlWKODzIDe3G0iMt5k
	rJV9FsojZDlhlk/P9gpSQfiGjLAac7A=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-vao5dXyXNAOVwjnX39Z8dQ-1; Wed, 08 Jan 2025 17:44:33 -0500
X-MC-Unique: vao5dXyXNAOVwjnX39Z8dQ-1
X-Mimecast-MFC-AGG-ID: vao5dXyXNAOVwjnX39Z8dQ
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6d8f78fdad0so6669056d6.2
        for <dm-devel@lists.linux.dev>; Wed, 08 Jan 2025 14:44:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736376273; x=1736981073;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ThvP+0+k+VZgLp2vSCgmUNo9IP7bU0ag/O1mEnImvpg=;
        b=bjHBVa+DWSezI1NzvfN6EVFBfmVQD46W0X8blpoPf+ZbqgJvN93WsLCAO8qXS71jeU
         UgHfbYy6HBA8/wHFmzFQ07coeLyw4p3V2qdJdRa3tBvZ30+gBcs7B7aTIOrZAeiZEkVu
         Te8FG6RyDEGy9Md3205CVTlYg2ZMnnaOsJ3HAzPLoOMZ8PnJ/2cTn9qmkaXWoHnvgu9Z
         NUmpYsN6wqrEoD+d4nhkwnER+6uHbD/MtQsLM9hDw/glgi6bTR0jRc4nU2bSl/15hu3F
         0vJLpMbaKS3czBZEYCwDpOPae/OnwHHNgzi0sSsLO/eWebfD1Lbnw9qI+d3lgtxX5dvA
         CmJA==
X-Gm-Message-State: AOJu0YytEMYsPnXgBQP31V2Wm8rwe7GQPeryVnq20IoYx0PEcpOzwsyV
	UzcXaeB1sYZBdIIrBjXjlU5U2Ti3irGVIKodc4sYT8PeAEnNKjHNZuhynOA7fRr8Lu3kg5n+ypM
	Jj3iHCAq3boB55WUVTV1sb7zQVws/5JG8LtD64qI8yT/P7JqK3VN89TaX
X-Gm-Gg: ASbGncsP9SFA0bamDdkxIEtABIVM202/xkIF5z+llmWdcUj/s3jPeGSmSO+98zZmQj9
	+5Nzye8aW7gy8jMTznuCifPbe60XK3+xPg7agcVg3klmll0zyc/PLtiCNaXBfvHnxamTpuzTKQD
	fhtNaqv1UhquXVnuXGtcs/thbe2iIKtd40NdtTCAt35Ohzic63wdU0MlT025ccgt1j3HvjFcAl0
	CD9hH8JD0HJH0QqnIhWKi7/T7SD7OiOQOD9yflW6YsyPejdgXmVx3QGNQ==
X-Received: by 2002:a05:6214:2686:b0:6d4:36ff:4356 with SMTP id 6a1803df08f44-6df9b220effmr87000746d6.19.1736376272783;
        Wed, 08 Jan 2025 14:44:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGURAiwb6lbdNU0b7V6BLwJH/uZtQUTuwHPhZfn/mCPVlKbCoQmtOJ8pGvdiESveJFLACsblA==
X-Received: by 2002:a05:6214:2686:b0:6d4:36ff:4356 with SMTP id 6a1803df08f44-6df9b220effmr87000496d6.19.1736376272407;
        Wed, 08 Jan 2025 14:44:32 -0800 (PST)
Received: from [192.168.1.165] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dd180eaad2sm194802466d6.6.2025.01.08.14.44.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 14:44:31 -0800 (PST)
Message-ID: <d0742bb0-bd51-4338-97a2-6454d806de90@redhat.com>
Date: Wed, 8 Jan 2025 17:44:31 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm vdo: Fix W=1 allmodconfig build error
To: John Garry <john.g.garry@oracle.com>
Cc: dm-devel@lists.linux.dev
References: <20250106141731.1341034-1-john.g.garry@oracle.com>
 <1d3beb46-c244-4ecf-8bd6-1895954c8e4d@redhat.com>
 <a9b32c24-f380-4a0b-a59f-16e2e87a833b@oracle.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <a9b32c24-f380-4a0b-a59f-16e2e87a833b@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yDnS1K68liuoHFZhB8A9pVsYFG4nsWPYq6jkYbtLV0w_1736376273
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/7/25 4:49 AM, John Garry wrote:
> On 07/01/2025 01:24, Matthew Sakai wrote:
>> Hi John,
> 
> Hi Matt,
> 
>>
>> I'm all for getting rid of warnings where we can, but I'm not 
>> convinced this is the right approach here.
>>
>> First, we use snprintf here because we really do want to limit the
>> string to 15 bytes.
> 
> Out of curiosity, why is that?

A dm-vdo target creates several threads to do its work. The 
thread_name_prefix is intended to be a short string at the start of the 
thread name that allows users to easily distinguish these dm-vdo threads 
from all others on the system. But it should not be so long that the 
dm-vdo threads cannot be distinguished from each other.

Now that we're talking about it, I think it's probably even better not 
to use the full module name, but instead use a short static string like 
"vdo".

> BTW, as I understand, for CONFIG_DM_VDO=m, the module name is "dm_vdo". 
> So why different MODULE_NAME if MODULE is not defined ("dm-vdo")?

That is a historical artifact and it should just get removed. The module 
name should just be a constant string. I could write up a patch to do 
this if you don't want to. It might take me a couple of days though 
because I'm still dealing with some holiday backlog.

Even after we do this, I still think the prefix string should no longer 
rely on the module name.

>> Making this constant larger doesn't maintain that. This change also 
>> increases the size of struct vdo (in vdo.h) by about 50 bytes. While 
>> that's not a lot, it does seem unnecessary.
>>
>> In practice, we know that the our module name is only about 6 bytes, 
>> and the instance number will never be more than 3, so snprintf will 
>> never actually truncate anything here. Would checking for a non-zero 
>> return value suppress the error?
>>
>> I'm also confused because I don't understand the difference between 
>> this line and the similar use of snprintf at drivers/md/dm-vdo/funnel- 
>> workqueue.c:430, which I presume does not trigger a warning?
> 
> For that snprintf usage, the compiler just doesn't know the possible 
> length of @name, as it is a pointer. That is why it is a good reason to 
> use snprintf.
> 
>>
>> Anyway, I'd be happy with a version that suppresses the warning 
>> without changing the size of any structures.
>>
>> Matt Sakai
>>
> Thanks,
> John
> 
Matt

