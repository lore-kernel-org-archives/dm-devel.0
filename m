Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1774022068D
	for <dm-devel@lists.linux.dev>; Mon,  4 May 2026 17:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777914193; cv=none; b=fwGCoCBHMotPn++HTR+USpNEjZwJKv91xmWznO8HujbeGZGC6mAHNbda1TE8/QFxJ3dmu9eX23ssauiqY4PpLRQOQ+/vugXCHH1TnFcr8q3piAjQijj/mHTUFXRU1/21c8hJay7yANghPJxpz5Vwct/sPkxJ5cICHJnzOqRBiAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777914193; c=relaxed/simple;
	bh=PRV/qWeWb/XiCIzIf9AL97yu+OihhbXqr1TGCmjhMq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o+qdfkgZ73OGcB5zAucjjdRzR27BX3Map3kpIXeJ37H66KmEnb7bVuaKG0Ok9Vqlb1W4YJTI4zl7rv95z8UImoFOnIsDw7jwTrZVCbjd9iL/nQ1sF5gWW5QSxU3ru7Lw2lc4RGNZbwZk+L+vvIw7ULb0gGSbVQGOPmDh9fUiww4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P3JkijGv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3JkijGv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777914191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JX9gaMBkYl4YEwHY9ku097zktKsDkI2nWGiRX1MzedQ=;
	b=P3JkijGvqDyr/YvNuPF/ZfLdqO3QA8iJw3dAyDjFV5t6Zc47myR7WoumgRiqTsHpH6cXYX
	ABsg5lwpQUPvKkZnRJfY9Tvx1bZ9qL/ISfqIdPu0RPFktVc9aAI1hE5mnWgbb25e1eA0A8
	jNC2+5F26i0zRMSihJtNBAUlgVpEy5A=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-jZY5PRsHOYun662Oavlalw-1; Mon, 04 May 2026 13:03:09 -0400
X-MC-Unique: jZY5PRsHOYun662Oavlalw-1
X-Mimecast-MFC-AGG-ID: jZY5PRsHOYun662Oavlalw_1777914189
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8ae752c5273so10229256d6.2
        for <dm-devel@lists.linux.dev>; Mon, 04 May 2026 10:03:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777914189; x=1778518989;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JX9gaMBkYl4YEwHY9ku097zktKsDkI2nWGiRX1MzedQ=;
        b=H7MMTnF0RAG0KKVtusTAskyfIlDSNhrn9Y4m1dPjxdCuGJVdalneZQqXFzC1SWR80Z
         XTDV+UQbDvTWylOUvrSQOaeHRSYvxjvH0ly4YjJFU4LQEXS97MPwO2xRRr3BsEv+jjp4
         uC8CM17n8i43Oki6/K8lmSAhTXKsE5xfT3H9ygFhUox8fGsjdGvQ40B8wKhgLSKQiz2n
         OppFWOBVeYw2LpHueeUHypZQUBGWeba/DfKe11twFwCcdSACSxP5VqZNd3I0FIVGi9Cj
         PjN6cOmdIpndEI0pdcOrm/1L6Pug7dibQ8kK5kUi4tUCzt/uTKbU2o2LITrusA4klAMU
         gldw==
X-Forwarded-Encrypted: i=1; AFNElJ9hp+Db573Fvk6lzr+kbdpC2X/WK4H3UireNWRhSw8yEzUCx27y8tscM2+27nh9y5gWf/O+/KpODg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx05lai8c0q/McPgh6xd0r9GSJwtSj0fSgvnHzcxQZpYLINNuiA
	95GX9SGdC7r7dHZfEy4PJbMtJ8SjV4RaM1pMm9xS5Y2aS3Lv6quHuyfLC8ZwlQnLC9RDVjMVPOI
	15yj8Gkmo7Ez0QoUlHQXuplSFrf71ivYGVCiYbxzpRkeDHRMhw0KeOnDfyw58
X-Gm-Gg: AeBDievDe2UsNwUwpE+KU2KLcXaqz7kPGL6P6qxfnt7SKTMhZpj2RQ/86Pa8wRrp+Kb
	AYcZ8UOD10BvsHv3GZjZIgq97XxjrVM8bEbNScvNX0AG913ytEr/4jr6WArnmzP82ClyoeTOqmC
	Mhh3drDk+1HwlZJOlQY0XjooAQqdhBNZP/lmJFRRfN9zeUqcTWztRFM1Bg5vrinybNsemUYcqrD
	nDLpclWH9tlw/7a62X3XeOHG73CtqcMT30TzbefZ9EfO0pqscf0XJHL9ksXXhYejPKjUlWN+rSi
	gBFatT2bGHwS4PUD+l+jz+ePnQxVpkpWmcyaTVLx6eHg1rBNxhBZYAq27kF05rxizgkwuo6JsR+
	02k59ZNeE1WqI2JuiV8ZxSXZ6MgE4RSltrZX77+mQ090CMzTiQeNLk/b+hdAjauk/FxP5R9Hrns
	UPURXe
X-Received: by 2002:a05:6214:318c:b0:89f:4a69:44b9 with SMTP id 6a1803df08f44-8b66863abfdmr174327346d6.40.1777914189082;
        Mon, 04 May 2026 10:03:09 -0700 (PDT)
X-Received: by 2002:a05:6214:318c:b0:89f:4a69:44b9 with SMTP id 6a1803df08f44-8b66863abfdmr174326946d6.40.1777914188468;
        Mon, 04 May 2026 10:03:08 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:2500:540d:8da2:f197:6711? ([2600:4040:530f:2500:540d:8da2:f197:6711])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b538b1d953sm140335956d6.3.2026.05.04.10.03.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 10:03:07 -0700 (PDT)
Message-ID: <3cc1960e-0780-49ed-b186-267212259844@redhat.com>
Date: Mon, 4 May 2026 13:03:07 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm vdo: add optional Intel IAA-backed compression support
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "..." <439291857@qq.com>, dm-devel <dm-devel@lists.linux.dev>
References: <tencent_C10B5DDE03BCA1510BF6D23F384A4C120308@qq.com>
 <a986902e-014c-2df6-4e0d-de99a62f90f2@redhat.com>
 <b3033f45-ec82-4c01-9234-5616bd9877b1@redhat.com>
 <1f86bcf5-eb34-6df6-e69a-7be0ff9240cd@redhat.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <1f86bcf5-eb34-6df6-e69a-7be0ff9240cd@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eb1TfQOleOtvHOqpbCJgMppus-2QURD5r_qYsfPV9vw_1777914189
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/4/26 12:01 PM, Mikulas Patocka wrote:
> 
> 
> On Wed, 29 Apr 2026, Matthew Sakai wrote:
> 
>>
>>
>> On 4/29/26 11:24 AM, Mikulas Patocka wrote:
>>> Hi
>>>
>>> I think the best way how to support it would be to modify the VDO target
>>> to use the asynchronous compression API (so that it could use arbitrary
>>> algorithms). Then, the support for IAA could be plugged in easily with
>>> little or no extra code.
>>
>> I agree that this is the right approach, but supporting arbitrary compression
>> algorithms will require some significant changes on its own. dm-vdo currently
>> has nowhere to store information about what algorithm is used for which
>> blocks, so it would require reworking the metadata. (We would probably store
> 
> You can store the algorithm in the superblock and use it for all blocks on
> the device. This would be not as flexible as per-block algorithm
> specification, but it should be relatively easy to implement - and it
> would allow you to evaluate whether different algorithms improve
> performance or compression ratio.

We could do that, certainly. It means picking the compression algorithm 
at format time, which also means no existing vdo volumes could take 
advantage of it. But we'd still need an upgrade for existing volumes to 
handle the new superblock field. I think managing the compression 
algorithm per-block is not that much more work, especially since I've 
already written much of it.

>> the extra compression information in the compression block header.) This
>> metadata rework in turn will require some effort to make sure we can continue
>> to support existing users who will want to continue to use dm-vdo volumes in
>> the current format.
> 
> Mikulas
> 

