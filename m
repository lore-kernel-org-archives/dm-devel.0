Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F80F19B
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 01:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716514487; cv=none; b=nXAQNdqni5QSMrC44qzwpAktdJaI2djunmf576d2BNtScvmufdcr8qFAo1BlTg9ICnAEMa3yKH1Ja9xxyiYR7xddYrgzIWVi1u/Z9/z1DK51p5bVoyh1SmJ7g4BIai8uBgmSl72WJc/UXv0snlk1SF5taa2nYoPIYydDdKV4c6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716514487; c=relaxed/simple;
	bh=6eqPKy9djQ44kxy9/4ekHNwI380SgUbokve8MKOW5nw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MXRxWAz9seR3K9hgYORo5TlvYARZX8gUMDRV2zd4/h+onzQvAc6V3JMEWi5zRuMcioMPB7NzPbnHRQYwEFpzNs0mNq4+hJQjE+L0LXz5ni26ezyrJKFMUKoKZPwPAJf4UzRMn5NtUtdZyrxy4QHONtvbPJLETtWDsiyj7tl01e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZmVBaLNt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZmVBaLNt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716514484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u7zyDSjhpyorp5nAJxno7CoO9uDDRfWCi8vAJwbr4pI=;
	b=ZmVBaLNtugFwMpqoRDYPDBLUdUpZU30Cdy6U4iInlSoczqkQGr8ITKWSi/zTtHfwf1s5oI
	kiTBMGFJ3zwTge3EwWuGolmigj3UoaMg/4ErEXy/qmeAVLsCv5DZGN+QT5ignVZIh1cb/+
	XaMVPg7enYqWW3s881ni0lYzaqsYsRs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-cpdfBXW7MLuFxc5cpj84mQ-1; Thu, 23 May 2024 21:34:43 -0400
X-MC-Unique: cpdfBXW7MLuFxc5cpj84mQ-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-792ff5345c6so66213185a.1
        for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 18:34:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716514482; x=1717119282;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u7zyDSjhpyorp5nAJxno7CoO9uDDRfWCi8vAJwbr4pI=;
        b=sbIAUkN1px9DJO1wFP8xSmHWqTEyz0T8ljzCJJKo82qki/sWNM+fBZON+8xhWlU9KX
         Dn7LMMCXh+zpyr5LaBhkakrVBcNfZZmv73hZmWptm22uhgyOxwa2XzQb0YHTW0T3ueuU
         RU4LDycVDJcbQ/jgNiiZp0WNxfLbCZBdYfYXKuhIv73GmQ01hfAMKaBvrAnG7Gc3jfgC
         UY4N/Dnc85x+ViKc6aMb2n1cAIoRMsMMqvFZNNuo/1YoYVRJX2gsha5GbP//BIbQwqz9
         ooMo9p4Jpi6Zhz0NZciVaXCzGQzlQCfKbiP3PEtGwPfRgT7hJ0qiqLYIjpkwtpfRZKAj
         xFVw==
X-Gm-Message-State: AOJu0YxNNmT6O1iFQduYwttnkbTujUtsqO4BMlZhB7+H4oUb+pwHs71K
	IgRgq6Eq0ua6yBef080CCt2sy//D6k7LPeOg0R0Cog6OEyJyuZep2zYvtpKqB3WAo/bRHLN1kId
	AwaZ+9AdoXJzaqOoAbyADGb4Q6IOxqLVuf/eJEZ2k+veQfeVrUG+YnOQw61Bqr4HuYJE=
X-Received: by 2002:a05:6214:5c07:b0:6a0:8559:d137 with SMTP id 6a1803df08f44-6abcdaa8559mr9297916d6.61.1716514482632;
        Thu, 23 May 2024 18:34:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdkDT3EyxEf+gntyix61idG5hT7+VI8hQowuVB9g+Y0LHc/PAp4h7v2266c9W7+jo6cv+TeA==
X-Received: by 2002:a05:6214:5c07:b0:6a0:8559:d137 with SMTP id 6a1803df08f44-6abcdaa8559mr9297736d6.61.1716514482293;
        Thu, 23 May 2024 18:34:42 -0700 (PDT)
Received: from [192.168.1.175] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ac070dc638sm2357546d6.35.2024.05.23.18.34.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 18:34:41 -0700 (PDT)
Message-ID: <cc86b717-e060-2d73-88a6-1625285c47c5@redhat.com>
Date: Thu, 23 May 2024 21:34:41 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] dm vdo: remove unused struct 'uds_attribute'
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20240523210716.309324-1-linux@treblig.org>
 <5c063045-4bce-14e4-9930-77cc0ed2edad@redhat.com>
 <Zk_ozpHryOiMLx_Q@gallifrey>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <Zk_ozpHryOiMLx_Q@gallifrey>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 21:09, Dr. David Alan Gilbert wrote:
> * Matthew Sakai (msakai@redhat.com) wrote:
>> On 5/23/24 17:07, linux@treblig.org wrote:
>>> From: "Dr. David Alan Gilbert" <linux@treblig.org>
>>>
>>> 'uds_attribute' is unused since
>>> commit a9da0fb6d8c6 ("dm vdo: remove all sysfs interfaces").
>>>
>>> Remove it.
>>>
>>> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
>>
>> Yes, this was clearly an oversight on our part. Feel free to add:
>> Reviewed-by: Matthew Sakai <msakai@redhat.com>
> 
> Thanks for the quick review.
> Is this something you'll send a pull for, or do I need to
> ask someone else to include it?

No need to do anything else, I think. Mike (or Mikulas), can you
include this with the next set of device mapper patches?

> Dave
> 
>>> ---
>>>    drivers/md/dm-vdo/dedupe.c | 5 -----
>>>    1 file changed, 5 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
>>> index 117266e1b3ae..39ac68614419 100644
>>> --- a/drivers/md/dm-vdo/dedupe.c
>>> +++ b/drivers/md/dm-vdo/dedupe.c
>>> @@ -148,11 +148,6 @@
>>>    #include "vdo.h"
>>>    #include "wait-queue.h"
>>> -struct uds_attribute {
>>> -	struct attribute attr;
>>> -	const char *(*show_string)(struct hash_zones *hash_zones);
>>> -};
>>> -
>>>    #define DEDUPE_QUERY_TIMER_IDLE 0
>>>    #define DEDUPE_QUERY_TIMER_RUNNING 1
>>>    #define DEDUPE_QUERY_TIMER_FIRED 2
>>
>>

