Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7B61E04AC
	for <dm-devel@lists.linux.dev>; Mon, 24 Feb 2025 21:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740432933; cv=none; b=cepaQSsmAFO3/jbl4OQxXv6meueRmlJGYHjlluyhTKvqeeeLTuzGmrF7qs1a+U43lu997Luc82kmvbplFbbCL95/ktMTjOAWs+Y+3jj/qUCqDeOUoypE/JvJeiMCzf/i2Y9VcSCltju6nO0nSiH9RTAhlG1uDF57ud8Sss0N+rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740432933; c=relaxed/simple;
	bh=HKFgbJe85ro1I3Cv4FVFNIewgSojGE0garDF4gsLnSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ypu9/8Ghe/Q6X8vaOVNYVafzQ2GEFZHBTj/eeq0Obo6vu2f8AhlJ0VKjgM5jotxNrD72eneLKJeNPQK+sbhbwiCVJXu45wDaRY2mf00tCfh3X8janEmmHFLTE3T6qyMGlT8SzK1EsqRWKNnVidnDlglqhl3e1FYRCjI1JJTuN+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hXvV6I68; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hXvV6I68"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740432931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0/jXlR/Le9lWGSmSvDAKdopMBB0lF8rm0fusWxSlkn0=;
	b=hXvV6I68Qq2pgWveEPIGzXB/v+RMjS5EZHKd+BAZPHWHy+D8NcT1m8ysRd6Hmiyygq5S88
	a5CUL6Tc7412RWdyrppslCyUfFU/sG9r0jKCe5yKjnMBbKZj2UPZVw+MQrQNJL6HFFFd3m
	Wj/M878mQUmC6Dcp1muZqIqeoooX4FA=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-pqs_THHPN7-WoHM8Cjv-aQ-1; Mon, 24 Feb 2025 16:35:27 -0500
X-MC-Unique: pqs_THHPN7-WoHM8Cjv-aQ-1
X-Mimecast-MFC-AGG-ID: pqs_THHPN7-WoHM8Cjv-aQ_1740432926
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7272137bb36so5343785a34.2
        for <dm-devel@lists.linux.dev>; Mon, 24 Feb 2025 13:35:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740432926; x=1741037726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0/jXlR/Le9lWGSmSvDAKdopMBB0lF8rm0fusWxSlkn0=;
        b=ltdtOjy7tUJ0eUIOcZ1yuMN2W3O4jwLU1dFHXXc8P60UOX8nxJISEtk3mncclzb3B9
         hTD0Sd2i9D8HprtB+Sq2ct/GKzJNPgVTNTviMkqQJhsSSYJJf65YyUGDbhffsdkEewTH
         XkrJobbUaOK5dyr2tDUuHFqf7NuII0Ifxt5xpwKvPQO2AW0pV/zVDjg6LxsKcUusSpu8
         soI124gF/U4+8VREh18vYC/vX8eyoYxDrE2bPP7sy0R786YEFxhrumDRaeCpNHolbPCc
         uVNvWINC6VmQeIvQCi1LcCNfxtZjD7flo171EGKWaYb5MqKWrHS8wt7fo7hjoheAwNgj
         lkxA==
X-Gm-Message-State: AOJu0Yy6quzYcqnTeyI9fLz1+vPGnNVZMJ9YpNBbd7+RATwQKoLpqjA/
	Ld9z4l/PAq1MBIvtScaw26GUxJvVGFRQ+jNjYppPndGY+3szqAIF9ZpwK1mozAYeC9I9BMmR6gq
	VhvSaD+FbN7PaV3puFtsKgWlUDK8eOKv7ygliTsM3nqq/mz57/tk61zJe
X-Gm-Gg: ASbGncvkL5cl2XSwyVjdCjEDFmpRSAm8VQGHDOZhAEBVahqb7tibYTFkNio7/vRdQco
	xPRlCTPEY4jE1cR3SurmH2sXGQ7tOQ+XSFrENgXOJb7BqyWw/AUERRN5nwOPbTc3Ha1SCNIJ784
	1AlIkVOsCxWEEU7BDUUDUN+5XGyKLU5ml3X0K6/cmN9oo4KpQ7P92wke6XSI6gW3SpEzYHsl9Gf
	fW6etyRp6Uu7S3oPYtyuUJM1j68XEWUGlYBkwhlE0OWR5audHaiR9fPAYLd/PSSV4fR0f4YsUP0
	6jNLB6HVcrs2kkBJsLWSo6El+DJPm5UJamGdpArzHgpmSzk3C3Ms/NFngZWulLY=
X-Received: by 2002:a05:6830:498d:b0:727:ec1:73ad with SMTP id 46e09a7af769-7274c1aa2d6mr10485018a34.11.1740432926485;
        Mon, 24 Feb 2025 13:35:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHxhxHsdz5oA8WE5Hm6i9E1D5tf0Owa1iMWjQ/OgB44fvLIgqC0t8VdUsPq9d22TewcmM0C4A==
X-Received: by 2002:a05:6830:498d:b0:727:ec1:73ad with SMTP id 46e09a7af769-7274c1aa2d6mr10485004a34.11.1740432926126;
        Mon, 24 Feb 2025 13:35:26 -0800 (PST)
Received: from ?IPV6:2600:4040:5308:c200:54b1:d513:186b:5015? ([2600:4040:5308:c200:54b1:d513:186b:5015])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7289dee21d5sm36796a34.26.2025.02.24.13.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 13:35:25 -0800 (PST)
Message-ID: <68bc2c36-27f1-43ff-937a-bff77b1f3f08@redhat.com>
Date: Mon, 24 Feb 2025 16:35:24 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm vdo indexer: reorder uds_request to reduce padding
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Ken Raeburn <raeburn@redhat.com>
References: <20250220233310.1342059-1-msakai@redhat.com>
 <90acf9f1-3133-e8b3-650f-f0c669cd2a43@redhat.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <90acf9f1-3133-e8b3-650f-f0c669cd2a43@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mhtxfWJF-4z_nOd3GyYM1-SYEDHq38i1dQ-Lm8M1m9I_1740432926
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 6:33 AM, Mikulas Patocka wrote:
> 
> 
> On Thu, 20 Feb 2025, Matthew Sakai wrote:
> 
>> From: Ken Raeburn <raeburn@redhat.com>
>>
>> Reorder fields and make uds_request_type and uds_zone_message packed,
>> to squeeze out some space. Use struct_group so the request reset code
>> no longer needs to care about field order.
>>
>> On x86_64 this reduces the struct size from 144 to 120, which saves 48
>> kB (about 12%) per VDO hash zone.
>>
>> Signed-off-by: Ken Raeburn <raeburn@redhat.com>
>> Signed-off-by: Matthew Sakai <msakai@redhat.com>
> 
> Hi
> 
> This patch doesn't apply due to conflicts. Please resend this patch
> against
> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
> branch remotes/origin/for-next

Sorry about that, I'll send a new version.

> I accepted the other 3 patches.
> 
> Mikulas
> 
>> ---
>>   drivers/md/dm-vdo/indexer/index-session.c |  6 +--
>>   drivers/md/dm-vdo/indexer/indexer.h       | 53 +++++++++++------------
>>   2 files changed, 27 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/md/dm-vdo/indexer/index-session.c b/drivers/md/dm-vdo/indexer/index-session.c
>> index aee0914d604a..aa575a24e0b2 100644
>> --- a/drivers/md/dm-vdo/indexer/index-session.c
>> +++ b/drivers/md/dm-vdo/indexer/index-session.c
>> @@ -100,7 +100,6 @@ static int get_index_session(struct uds_index_session *index_session)
>>   
>>   int uds_launch_request(struct uds_request *request)
>>   {
>> -	size_t internal_size;
>>   	int result;
>>   
>>   	if (request->callback == NULL) {
>> @@ -121,10 +120,7 @@ int uds_launch_request(struct uds_request *request)
>>   	}
>>   
>>   	/* Reset all internal fields before processing. */
>> -	internal_size =
>> -		sizeof(struct uds_request) - offsetof(struct uds_request, zone_number);
>> -	// FIXME should be using struct_group for this instead
>> -	memset((char *) request + sizeof(*request) - internal_size, 0, internal_size);
>> +	memset(&request->internal, 0, sizeof(request->internal));
>>   
>>   	result = get_index_session(request->session);
>>   	if (result != UDS_SUCCESS)
>> diff --git a/drivers/md/dm-vdo/indexer/indexer.h b/drivers/md/dm-vdo/indexer/indexer.h
>> index 3744aaf625b0..d765f24328eb 100644
>> --- a/drivers/md/dm-vdo/indexer/indexer.h
>> +++ b/drivers/md/dm-vdo/indexer/indexer.h
>> @@ -8,6 +8,7 @@
>>   
>>   #include <linux/mutex.h>
>>   #include <linux/sched.h>
>> +#include <linux/stddef.h>
>>   #include <linux/types.h>
>>   #include <linux/wait.h>
>>   
>> @@ -73,7 +74,7 @@ enum uds_request_type {
>>   	/* Remove any mapping for a name. */
>>   	UDS_DELETE,
>>   
>> -};
>> +} __packed;
>>   
>>   enum uds_open_index_type {
>>   	/* Create a new index. */
>> @@ -226,7 +227,7 @@ struct uds_zone_message {
>>   	enum uds_zone_message_type type;
>>   	/* The virtual chapter number to which the message applies */
>>   	u64 virtual_chapter;
>> -};
>> +} __packed;
>>   
>>   struct uds_index_session;
>>   struct uds_index;
>> @@ -253,34 +254,32 @@ struct uds_request {
>>   
>>   	/* The existing data associated with the request name, if any */
>>   	struct uds_record_data old_metadata;
>> -	/* Either UDS_SUCCESS or an error code for the request */
>> -	int status;
>>   	/* True if the record name had an existing entry in the index */
>>   	bool found;
>> +	/* Either UDS_SUCCESS or an error code for the request */
>> +	int status;
>>   
>> -	/*
>> -	 * The remaining fields are used internally and should not be altered by clients. The index
>> -	 * relies on zone_number being the first field in this section.
>> -	 */
>> -
>> -	/* The number of the zone which will process this request*/
>> -	unsigned int zone_number;
>> -	/* A link for adding a request to a lock-free queue */
>> -	struct funnel_queue_entry queue_link;
>> -	/* A link for adding a request to a standard linked list */
>> -	struct uds_request *next_request;
>> -	/* A pointer to the index processing this request */
>> -	struct uds_index *index;
>> -	/* Control message for coordinating between zones */
>> -	struct uds_zone_message zone_message;
>> -	/* If true, process request immediately by waking the worker thread */
>> -	bool unbatched;
>> -	/* If true, continue this request before processing newer requests */
>> -	bool requeued;
>> -	/* The virtual chapter containing the record name, if known */
>> -	u64 virtual_chapter;
>> -	/* The region of the index containing the record name */
>> -	enum uds_index_region location;
>> +	/* The remaining fields are used internally and should not be altered by clients. */
>> +	struct_group(internal,
>> +		     /* The virtual chapter containing the record name, if known */
>> +		     u64 virtual_chapter;
>> +		     /* The region of the index containing the record name */
>> +		     enum uds_index_region location;
>> +		     /* If true, process request immediately by waking the worker thread */
>> +		     bool unbatched;
>> +		     /* If true, continue this request before processing newer requests */
>> +		     bool requeued;
>> +		     /* Control message for coordinating between zones */
>> +		     struct uds_zone_message zone_message;
>> +		     /* The number of the zone which will process this request*/
>> +		     unsigned int zone_number;
>> +		     /* A link for adding a request to a lock-free queue */
>> +		     struct funnel_queue_entry queue_link;
>> +		     /* A link for adding a request to a standard linked list */
>> +		     struct uds_request *next_request;
>> +		     /* A pointer to the index processing this request */
>> +		     struct uds_index *index;
>> +		     );
>>   };
>>   
>>   /* Compute the number of bytes needed to store an index. */
>> -- 
>> 2.45.2
>>
>>
> 

