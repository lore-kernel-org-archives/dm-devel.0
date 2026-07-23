Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D4B47424E
	for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 16:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823674; cv=none; b=VlLgK1idcIZkoJNjSxZ+GVdUKGRuyomFaJ60eFaXxfxQrLAUlqAdqigIg69M6Zk4NnWBfF5ccw4q9EmnKl59mlPRJB/N9jIpx/IiWKGTkG8i+RSEFNS8hcTIvllEvw7T1Hdklns6efCwT4fhqapNLNr/4XI8xQpdmmWFn9o8HxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823674; c=relaxed/simple;
	bh=1479Bzn4MnWSD2y+NvESjn+7vYjp7wnzwOwmWhZL0fQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=BReUlJh8lsTfTPDNea98EJ0nDwCe1bRcp+HISE6m4jvfHVoqWT2KOIFS/gsyhZ2sMpiPRdR5c28I+3wP9udumFlEebpjjg4PjL+7P1mnjSbzDkJU7YYdNZbLOXrmz5OsiIyOORIQlANGZCkfx1LS3dPbQI6Q+xkkBDvaD8ZZtD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hhm4y3ez; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hhm4y3ez"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784823665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5JpOvw+7tzkdUn/yyaVBpy6G/ikIqcOMNKXfm1ZMPNk=;
	b=Hhm4y3ezgEPml4bLnuBItneiCcCjDwNfhMm85ISbIUnS5yHTmcDtub38ez82DkGj8hHdXN
	JZOYPYClQ5rdE/E/w8A67Mny8+lEOxm30u4K9OqqJhyFZsl1bqMLmlx9Bu+mJvVIrU7r+E
	++hTgt0Csem1Zp9FoyOsP0h6xbfzGDc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-2YGgM6SMO7WKLslLuE1REw-1; Thu, 23 Jul 2026 12:21:03 -0400
X-MC-Unique: 2YGgM6SMO7WKLslLuE1REw-1
X-Mimecast-MFC-AGG-ID: 2YGgM6SMO7WKLslLuE1REw_1784823663
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51bf321d786so10860441cf.1
        for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 09:21:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784823663; x=1785428463;
        h=content-transfer-encoding:content-type:in-reply-to:references:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5JpOvw+7tzkdUn/yyaVBpy6G/ikIqcOMNKXfm1ZMPNk=;
        b=QXC1s8F/H+2NCrA3KOpwESfM8tDab8BfUBeMFy8nY1OY9R0aZ+XGJFtP7CBqHqIPhb
         QSoxHdHcJ1JMfr8MxMHoC6S8fu3hB6HeBaGuenasxOa2ouf5RPtwgbsr99qsBRkiD9J5
         LBrDmk0z2UHOFyOhROdQHmoJjtW4EHqryjAoh3KcM+UxliF1WUIm3PXt8wfLjCw4DPba
         GSgy8cX7TNZmBaK2shrGACjwmQC/OcK1eGcIxrT5US6djTn0MzKP39lZKcxdN+O4MBOw
         +LJiZYT2whxvAYRq/Q4Q0ywXByAC/xmf8PFLVfgwAuz4EQ3aDfCkeQt6EwIfE2gYfSee
         E8mA==
X-Forwarded-Encrypted: i=1; AHgh+RqB9NzUNoQqiqVOCmPESW5skFPMpAvvCJJGvgSugVc8OSHXY0cI61sK4k2CyWT/a0G/KE39ahAg/w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzWCq4VfQQR/64ZzJXSSJXtDhI0aI8JpgFe7k9BxqJDpbcceVVZ
	hKTS4XPrrkZdFpegJoVP4LWxMcKudS/VnEJ2QThzis7bEYKuYE2uhCbe+lmeYe/pyjjf1NDtF4g
	8o+5kHrMdK1i9P0AFxqLJMbVoUIPJhvurooYu7aHo0YhGiv9fIpIvcVNNsiAvdJReUzNq
X-Gm-Gg: AR+sD11C0DMo4YPD4g2zu+FQ+V7fRUdgqGts9ZoGMHKE/YLVa+j+mBDjMqzER0iO3ke
	UJSYBx7G+PtwCtIvS0S7xjyE+F4JjdOpXCrRpfMoj50N4MFxSWvvWI5yTxhzKpxWB47kq0h57kM
	GulaCWS4MupmNc6c4yrppku/WkZJubFK6k3aGW+sCoz3bMIwd1vmk/eOcgcxPpUwQfZZe/nFiEX
	FuhWhOiVTpEppg2Xl7Qgs1S9MfR6kzxzy4jZ51b4hsWMHbv76+v+kaFyyazWv0DsVwY1vuu9Pq9
	e3Kjheoq+vC08W7znrKNZjju7LSMCXQmLUhiu/V1LVZux40lBhMd+QWFO6i1ORK+pJMpc7EEofP
	0vQNH00SuLPzZQk2mDVTcqFaoQDFX8ftx54qMxGBxrOazNCIK
X-Received: by 2002:ac8:5812:0:b0:51c:7b12:120a with SMTP id d75a77b69052e-5283dfe38dfmr35702791cf.88.1784823662758;
        Thu, 23 Jul 2026 09:21:02 -0700 (PDT)
X-Received: by 2002:ac8:5812:0:b0:51c:7b12:120a with SMTP id d75a77b69052e-5283dfe38dfmr35702431cf.88.1784823662198;
        Thu, 23 Jul 2026 09:21:02 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:b400:d348:ae32:97a6:8a0d? ([2600:4040:530f:b400:d348:ae32:97a6:8a0d])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-527d402cb05sm38183461cf.31.2026.07.23.09.21.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 09:21:01 -0700 (PDT)
Message-ID: <57be9af6-aaf6-4f44-a639-cae6f8416c89@redhat.com>
Date: Thu, 23 Jul 2026 12:21:01 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] Documentation: device-mapper: document VDO zstd
From: Matthew Sakai <msakai@redhat.com>
To: Rhajune Park <june@pythonplayer123.dev>, dm-devel@lists.linux.dev
References: <20260723161350.1080473-1-june@pythonplayer123.dev>
 <20260723161350.1080473-2-june@pythonplayer123.dev>
 <9c6bd25c-80c1-426a-b22c-5b3f3a8ae372@redhat.com>
In-Reply-To: <9c6bd25c-80c1-426a-b22c-5b3f3a8ae372@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F4z1NH8TkAwpi9WDu0fdaMZwtC33D1SEhCc2We7PT-4_1784823663
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Sorry, ignore this, I missed the first patch. I'll write a longer reply 
to that one.

Matt

On 7/23/26 12:18 PM, Matthew Sakai wrote:
> This is attempting to document a feature that does not exist in dm-vdo.
> We cannot accept this.
> 
> Matt
> 
> On 7/23/26 12:13 PM, Rhajune Park wrote:
>> document zstd compression with dm-vdo
>>
>> Assisted-by: opencode:gpt-5.6-sol
>> Signed-off-by: Rhajune Park <june@pythonplayer123.dev>
>> ---
>>   .../admin-guide/device-mapper/vdo.rst         | 21 ++++++++++++++++++-
>>   1 file changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/admin-guide/device-mapper/vdo.rst b/ 
>> Documentation/admin-guide/device-mapper/vdo.rst
>> index 8a67b320a97b..24a6b26bb990 100644
>> --- a/Documentation/admin-guide/device-mapper/vdo.rst
>> +++ b/Documentation/admin-guide/device-mapper/vdo.rst
>> @@ -171,6 +171,20 @@ Miscellaneous parameters:
>>           Whether compression is enabled. The default is 'off'; the
>>           acceptable values are 'on' and 'off'.
>> +    compressionAlgorithm:
>> +        The algorithm used to compress data. The acceptable values are
>> +        'lz4' and 'zstd'; the default for a new volume is 'lz4'. The
>> +        algorithm is recorded when the volume is formatted and cannot be
>> +        changed afterward. If specified when loading an existing volume,
>> +        it must match the recorded algorithm.
>> +
>> +    compressionLevel:
>> +        The Zstd compression level. The default is 1; negative levels 
>> are
>> +        accepted when supported by the kernel Zstd implementation. This
>> +        option is invalid with LZ4. The level may be changed after fully
>> +        deactivating the volume, but not by reloading an active VDO 
>> table.
>> +        It does not affect the readability of data written at another 
>> level.
>> +
>>   Device modification
>>   -------------------
>> @@ -178,6 +192,8 @@ A modified table may be loaded into a running, 
>> non-suspended vdo volume.
>>   The modifications will take effect when the device is next resumed. The
>>   modifiable parameters are <logical device size>, <physical device 
>> size>,
>>   <maxDiscard>, <compression>, and <deduplication>.
>> +The <compressionAlgorithm> parameter is a format-time property and is 
>> not
>> +modifiable.
>>   If the logical device size or physical device size are changed, upon
>>   successful resume vdo will store the new values and require them on 
>> future
>> @@ -255,7 +271,10 @@ The messages are:
>>       config:
>>           Outputs useful vdo configuration information. Mostly used
>>           by users who want to recreate a similar VDO volume and
>> -        want to know the creation configuration used.
>> +        want to know the creation configuration used. Output version
>> +        3 contains physicalSize, logicalSize, slabSize,
>> +        compressionAlgorithm, the Zstd compressionLevel when applicable,
>> +        and index configuration fields.
>>       dump:
>>           Dumps many internal structures to the system log. This is
> 

