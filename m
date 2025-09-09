Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF0D350D79
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 19:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757445792; cv=none; b=QaHTTFkwNK0iflCu/c5X4tcm1L4w7uNXebCrLY4eR/gyAKuRg+gWUtK6TxzALdBKlA8oIiFIuBMslbf/YrcxtQsiVIBcNXYkMm0T+iVKuQ7pKQggIu0brXQBmfgZsX6BIr1qOuCF6W2M22vf5ZH+VpWPBu6EINS47l+nDmF5HqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757445792; c=relaxed/simple;
	bh=Dr41Tcqata/raqAboRNakNManKKV7R8cd3/aEJ1vBTY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=JLiocYsc+bx/OWWPJdGfqVYEzuFQDU8aCzBls5aXRyWEdL/+hdVXZKYLbvsM+lOCcmlpxbKuBKogWXtXzAwyu/yeooXm04G8LNCmnQIAZ3Kq2Ti4teD2To1fnoGSWTbijj4iXF8/E3rvYw6Jj01GZ8RXK8o20tCbPmlWXqu8e8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=afKHlGNk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="afKHlGNk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757445789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KaahEf6JZRZ6NZ6hGjJioziPQJonllTKnhQkCCQ9Zy0=;
	b=afKHlGNk4Pnxa3W4skjN5v4/8YOjgS/LpUQ8gk0qjqSRqtutlBCq87RbsLDIr4YtLYsyws
	LinqYF5cs2LJ2B88aFuegGUfgrzHvDn0rKYfqH1GHccqkP6iGgdk0lAw7wiDBmX42hDwVg
	Ynyc0ZRGyw5nzRsJnJfC+wTFhfESEd8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-vNK7gwP6P_yEIOTui1rcPw-1; Tue, 09 Sep 2025 15:23:08 -0400
X-MC-Unique: vNK7gwP6P_yEIOTui1rcPw-1
X-Mimecast-MFC-AGG-ID: vNK7gwP6P_yEIOTui1rcPw_1757445788
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-806f812a0aaso1496862785a.3
        for <dm-devel@lists.linux.dev>; Tue, 09 Sep 2025 12:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757445787; x=1758050587;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KaahEf6JZRZ6NZ6hGjJioziPQJonllTKnhQkCCQ9Zy0=;
        b=YvV00j4/gYWV2X3uQGLyg1HffZYDzOWp1OglQQNmK0yAlibNZxZxwzqiDRUMjl5kH6
         2E4lEhwATjLxlr+afkVsJVH6+TA7bGXCtwosBAv+FkO6bdnDo+976n8/fp1DpoOuDzIs
         1cRBd5ZkOX4lcadgXqq1e31SE2RMxToppLA5GJbXZXhHnRyPlqhxUG+FJpPjIcdU4VB4
         UB2BWr5Q6dHfeYMxSE0aVTzoniCQ62QJ9Y5QurPhwqE1cvtLZxCRn2mC+7noVUeWJfEh
         X6KulrN6eFlV6yrHGY5dRxpoVNC4Ux61B6xabCAqqZQbVeXav62gb+J7GOmiOKiCylay
         i9QQ==
X-Gm-Message-State: AOJu0Yxj4OvJT2JM2iiKf1kI3oNRCbHHofcHSYwkE6tu9ZIeKJUEJ8+o
	/nTttyA6QeM6FXXj9k+ItCsavhHZTRHma0zYxKnCVlZpsWEl1Qo5RVqO06wyMV0vG2n2sjh4Ul6
	UPdcajqDX9f3cqRrSe9412q6yozZB8/4rxdKWNuCuWIUlF1n6nVpP+3ZqxzJj
X-Gm-Gg: ASbGnctGwyh+nrIFY/5YIatC1COGUDwjNLbJRw+koB4pstzz4A7U9YeHB5LQdd+yZz4
	R14otRa31SYI28EKRZC1gMWAMPdwEAV9tv25c0m1dQb0NI1cv+te9JITp9+0nqvuP4Z/ldwAvOk
	AVf4kvDj67JN9pum1oiuj1UIKFrIrGeGX8fxFFa6f63NHYQLw/PvIXxszix9sJ51iMV3hpQWjMD
	MtQkI560CQ93oApuWCU+BxMEpXZoQj88u1IAxuAaYZ5b/tPgjFz5DOxeaVvCn0M2Z6Mtv9qmfOq
	7+3X1dWqsFhIGAL8aLzaPbl21Ff351s7/rFdYWMeMoMTmRuay4qHJg4zx261lN1UpukILwj6h54
	xJHQpEhJBBcam
X-Received: by 2002:a05:620a:28c4:b0:7f9:1f6b:67fa with SMTP id af79cd13be357-813be440672mr1186303385a.11.1757445787475;
        Tue, 09 Sep 2025 12:23:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLY5kexLTwmeWexP1KElG9GzegYJmUBuptStZfbFZ+i//+RQxgQVoBsSR7G6dKU9Eld5w6MQ==
X-Received: by 2002:a05:620a:28c4:b0:7f9:1f6b:67fa with SMTP id af79cd13be357-813be440672mr1186300685a.11.1757445786985;
        Tue, 09 Sep 2025 12:23:06 -0700 (PDT)
Received: from ?IPV6:2600:4040:5308:eb00:a77e:fec5:d269:f23e? ([2600:4040:5308:eb00:a77e:fec5:d269:f23e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-81d97fdcc6fsm14133085a.42.2025.09.09.12.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 12:23:06 -0700 (PDT)
Message-ID: <1788ec12-c362-440a-b63e-fc720bd5a18d@redhat.com>
Date: Tue, 9 Sep 2025 15:23:06 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] dm-vdo: Refactor VDO_ASSERT usage in
 start_restoring_volume functions
From: Matthew Sakai <msakai@redhat.com>
To: Ivan Abramov <i.abramov@mt-integration.ru>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
References: <20250908222410.223574-1-i.abramov@mt-integration.ru>
 <340645fa-5c6b-4b28-bd56-63088d4705da@redhat.com>
In-Reply-To: <340645fa-5c6b-4b28-bd56-63088d4705da@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QB3AZN_Bjg4ebO6zlMm8tBSZ6TuwcOecbuffquHLpXQ_1757445788
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/9/25 2:58 PM, Matthew Sakai wrote:
> On 9/8/25 6:24 PM, Ivan Abramov wrote:
>> There's an incorrect VDO_ASSERT macro usage in
>> start_restoring volume_index() and start_restoring_volume_sub_index(),
>> since assert's return value is not used anywhere.
>>
>> Thus, use VDO_ASSERT_LOG_ONLY macro in such cases.
>>
>> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>>
>> Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
>> ---
>>   drivers/md/dm-vdo/indexer/volume-index.c | 8 ++------
>>   1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm- 
>> vdo/indexer/volume-index.c
>> index 12f954a0c532..99608f14400a 100644
>> --- a/drivers/md/dm-vdo/indexer/volume-index.c
>> +++ b/drivers/md/dm-vdo/indexer/volume-index.c
>> @@ -832,11 +832,9 @@ static int 
>> start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
>>           decode_u32_le(buffer, &offset, &header.first_list);
>>           decode_u32_le(buffer, &offset, &header.list_count);
>> -        result = VDO_ASSERT(offset == sizeof(buffer),
>> +        VDO_ASSERT_LOG_ONLY(offset == sizeof(buffer),
>>                       "%zu bytes decoded of %zu expected", offset,
>>                       sizeof(buffer));
>> -        if (result != VDO_SUCCESS)
>> -            result = UDS_CORRUPT_DATA;
> 
> This is not a correct fix so we should not take this.
> 
> This assertion (and the one below) should only fail if the stored 
> metadata has been corrupted, but in that case we definitely need to 
> return the error and fail the load.
> 
> You are correct that we don't seem to use this result, but the correct 
> fix is to return UDS_CORRUPT_DATA when this assertion fails.

Replying to myself, feel free to correct this patch, or I can probably 
get to posting a proper fix later in the week.

> Matt
> 
> 
>>           if (memcmp(header.magic, MAGIC_START_5, MAGIC_SIZE) != 0) {
>>               return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
>> @@ -924,11 +922,9 @@ static int start_restoring_volume_index(struct 
>> volume_index *volume_index,
>>           offset += MAGIC_SIZE;
>>           decode_u32_le(buffer, &offset, &header.sparse_sample_rate);
>> -        result = VDO_ASSERT(offset == sizeof(buffer),
>> +        VDO_ASSERT_LOG_ONLY(offset == sizeof(buffer),
>>                       "%zu bytes decoded of %zu expected", offset,
>>                       sizeof(buffer));
>> -        if (result != VDO_SUCCESS)
>> -            result = UDS_CORRUPT_DATA;
>>           if (memcmp(header.magic, MAGIC_START_6, MAGIC_SIZE) != 0)
>>               return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
> 

