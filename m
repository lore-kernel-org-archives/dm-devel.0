Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2D02B9A4
	for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 18:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737571687; cv=none; b=QW13If/2tCtl85IfH2iOwbFafahI3oIfjU/CZSQJhNN00QYKzkjL2NzpyFDzXFrBaKsNQfMBKBfc9zmYxj1N2UgCBdpSjF38UNtZMHObdHOC75elRABww/lzmfvygSi4CYwHjVrZxbGXqYd/6fkGyKTVRiRcdOxZ8MaQR9xVJE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737571687; c=relaxed/simple;
	bh=B+Br86g9Cx9av7JvqeTLRPiHB1tJrcv+deuF2XGxdHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RiR7mVwToe6uXp09KRyo5pvAK6GYaZGBk1iDilzSR2yd/xN+pKzXknqPpuYgcX2040e8/RK14Ng0Cu2EIVdHOXehWZnnmS8GCWDnsBfAlB/3LYfMfi/JTsz6gcdhNFbrGeRQcvrB1O7mmydyk/goL1GjPvgVSrEq6AIXdrDMquI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gdAHKvU2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gdAHKvU2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737571684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FA9NcZooGB1HfIs0ThRu97SmPFLuNi9EcOm5DQhWP3Q=;
	b=gdAHKvU2WeiSVtluwHEDgGa0juDnU6fpmOk1IPuSlDntSRoxFqBnjNrhUC5rJTda0j6/6F
	kQdg15lU/96u+gHnv3lQSlqDRtcM6HS8tRlasE+BDhlXNxQqa5pEho9xwKxB+XfhdJgcaS
	AsH/ov+UyASivnPc3LUUPIgI8ChhYQs=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-Lr0o4hFyPayv24vkT9Qh3g-1; Wed, 22 Jan 2025 13:48:02 -0500
X-MC-Unique: Lr0o4hFyPayv24vkT9Qh3g-1
X-Mimecast-MFC-AGG-ID: Lr0o4hFyPayv24vkT9Qh3g
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-46c83bc370bso3759431cf.0
        for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 10:48:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737571682; x=1738176482;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FA9NcZooGB1HfIs0ThRu97SmPFLuNi9EcOm5DQhWP3Q=;
        b=cVetkqQVj7x+A63STKhyJWWECHFEQnzlICcD/pS5f9h6g5tOoAj1fsAr0tlSj6PxxL
         jm31MSLqWZ2tLnH5kgl7EKKJ6SG7iMvQkRcJGYzlM9LIqweA9/jrDPQy6YMc7sdNO+aN
         O0fpe/29v36q/ltdQV+zLKP/0nLHmLxonfxPwuz5JWsaGE2w21Hx2YOxKL4o5r6EnwnW
         BV//JaaYjsW13uQt9LMOHybC5tiYY3XMqBB3zEZCyvm4znH+DV6K6SlZDHNTE0qFvGu7
         tNh0VQA+1LDhP0HQksTlw0l39LvgwLN+amvxJiRcDCuJZEkMngPpH9lkSsYO765RC+hY
         Ww3A==
X-Forwarded-Encrypted: i=1; AJvYcCV0T7drwt2w8okwvJVr0d8gl/iDYjNCtI8tf82P8zUBPOlGGkeB5YmAZ8jPH7V2S7pBVWo04Q5grA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0KSdg0566YEA+QCi1FFwKoLO5dJqXQvFlYli88HJ/fYewwpgl
	YTetHMMVoTLpcT8xwF6OIP/2D/zdwAyb7y36J/SQMw6Uv0I1IywDGPnwemAHIB634CUe2zYjtE8
	39mgw73hfNUHMJ0YwJD4ATqKmrPDwds80L9o8tVHM39MUFF1BJPqkQaQu
X-Gm-Gg: ASbGncuWiaEy1P1psbzVkInIAwdzUalY9+7TshuROzLmxtiasrELUSnfnl0zCUrK6QD
	9S2wqFnRLgNvvHFRYfuSRRbI9ZO+B/dn9UAYFJxHxeCSQbZZ9HDjHpK9sICARebeozT3z8A+U89
	80/mOIKnfqBmfflW/SDWYu8hi8F2gaug/dakEfPhqGdNEOCoLVUkUjgCdoBr0srM2loHfiBUyAC
	UqiAh3GZWw7of8iB6tdMri/CEv00sgrIyCOP6DdzmhMDcAWaS4cRNhj3o0+2NicwA9zNxk=
X-Received: by 2002:ac8:7d84:0:b0:458:1e37:f82 with SMTP id d75a77b69052e-46e5b83c5a5mr7042411cf.18.1737571682402;
        Wed, 22 Jan 2025 10:48:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHCLx8MzjODyZZbUWHLHj1EloS7O/uBuL2RFFhI+rM8XU/eghD15DcRazCRfgQguFwRxPvOSA==
X-Received: by 2002:ac8:7d84:0:b0:458:1e37:f82 with SMTP id d75a77b69052e-46e5b83c5a5mr7042181cf.18.1737571682073;
        Wed, 22 Jan 2025 10:48:02 -0800 (PST)
Received: from [192.168.1.165] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be61473bc5sm684290085a.20.2025.01.22.10.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 10:48:01 -0800 (PST)
Message-ID: <6ae9f881-2ad9-4583-a199-c5425bab93d6@redhat.com>
Date: Wed, 22 Jan 2025 13:48:00 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm vdo: use a short static string for thread name prefix
To: John Garry <john.g.garry@oracle.com>, dm-devel@lists.linux.dev
References: <9146ca1541ef988061c22eddd03ae5f5905fc78e.1737513476.git.msakai@redhat.com>
 <9c6e2bec-55d0-4e76-87c5-1b660de548f5@oracle.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <9c6e2bec-55d0-4e76-87c5-1b660de548f5@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rAeWlfC14qckddONBYamXFV_Ak3COkacZKIcoe1ug8o_1737571682
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Thanks for looking at this.

On 1/22/25 10:19 AM, John Garry wrote:
> On 22/01/2025 02:42, Matthew Sakai wrote:
>> Also remove MODULE_NAME, which is now unused.
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
>> Suggested-by: John Garry <john.g.garry@oracle.com>
> 
> I am not sure that I did suggest this fix, but I did report this issue.

Fair enough, I'll change the tag to Reported-by:

>> Signed-off-by: Matthew Sakai <msakai@redhat.com>
>> ---
>>   drivers/md/dm-vdo/vdo.c | 8 +-------
>>   1 file changed, 1 insertion(+), 7 deletions(-)
>>
>> diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
>> index a7e32baab4af..40b3ff8c49cc 100644
>> --- a/drivers/md/dm-vdo/vdo.c
>> +++ b/drivers/md/dm-vdo/vdo.c
>> @@ -142,12 +142,6 @@ static void finish_vdo_request_queue(void *ptr)
>>       vdo_unregister_allocating_thread();
>>   }
>> -#ifdef MODULE
>> -#define MODULE_NAME THIS_MODULE->name
>> -#else
>> -#define MODULE_NAME "dm-vdo"
>> -#endif  /* MODULE */
>> -
>>   static const struct vdo_work_queue_type default_queue_type = {
>>       .start = start_vdo_request_queue,
>>       .finish = finish_vdo_request_queue,
>> @@ -559,7 +553,7 @@ int vdo_make(unsigned int instance, struct 
>> device_config *config, char **reason,
>>       *vdo_ptr = vdo;
>>       snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
>> -         "%s%u", MODULE_NAME, instance);
>> +         "%s%u", "vdo", instance);
> 
> if you think that this is the right thing to do, then ok..
> 
>>       BUG_ON(vdo->thread_name_prefix[0] == '\0');
> 
> is there still some value in this check?

No, not really. I'll remove this in the new version.

>>       result = vdo_allocate(vdo->thread_config.thread_count,
>>                     struct vdo_thread, __func__, &vdo->threads);
> 

