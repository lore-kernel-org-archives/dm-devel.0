Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA3B25B0AB
	for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 19:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778613991; cv=none; b=ohj9cf86DUCeZTfLU//8u1E1n74JRCx1MeneBzg49uS1iQuJm6NumHtvqy/cSArb3vl99z/IahzhMig3aHnXlDkmrB2HKCBjteKzw06u/iOfmJDPrFd1jshy3EWg77hVWBueYpz0biFnXvqeWhcH18z6tawOInc8zEo5LcxQNAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778613991; c=relaxed/simple;
	bh=euoI4PPeaG/b9i+C9vEfTdv3opOcikxhPWZLnVe/p4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e/Chxl21ksktEFnXTTUJ3XJkAIH0PnpgOZOmc2IM2I5BRk0VPqXBTcMVIVIP7azNz2mGokAMNCpvj+hiwnGSi1kxo4uux0p2pNQrkBoJh5V5aYvIp2MLc17r2JHQnZ5z0Wae9R38Js72asusc+UXpLjh8W4zNu3fW5kIfEmTp20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TuRemFqx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TuRemFqx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778613989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k4AzCvSdNNhjAAnsXynhzn5YrFcbmq+M9y9a+CAp+ow=;
	b=TuRemFqxwFupmPsUSVS07oQ5usvDbquETbKgW3nady/f5unxMKk9SoGVsIkPmgKifT33pt
	3J1mjTocS8RFx4RWbHEo6+YA/ACtuX7YcQe2YbEYO5vjhBK9w67FwAWAk+oy5rM/t5hOtZ
	u6GBMFirNsS9zrB33cpL9KGqcmA+eNA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-B3iks4HCOESmFSOCGL6yoA-1; Tue, 12 May 2026 15:26:28 -0400
X-MC-Unique: B3iks4HCOESmFSOCGL6yoA-1
X-Mimecast-MFC-AGG-ID: B3iks4HCOESmFSOCGL6yoA_1778613987
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8badccc9194so31293076d6.1
        for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 12:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778613987; x=1779218787;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k4AzCvSdNNhjAAnsXynhzn5YrFcbmq+M9y9a+CAp+ow=;
        b=DpaY3A6DGcaQoC89fbHoOTndJBTk9ZGmhot9xfw3zQj391RBil7hMvYUIK44xNsYI1
         Ee+yr2NBrHlA/ZQzKtVfEzSVqBjqCDaRNwDJ3iTXj6fiOwtv9YmLe1Ca0PSw3Jks8w8i
         Ia/yvolCLZu/0orqGvl1HLgRlQRmcLD7tDgkbuENirZLBARJ6D2b8SwkQvfC4nMoiWv6
         ynALP9Jm6VdmRzUzqZeERGdCk0ik/EyLO4pH836YJRSb3xG/MaUlQKNrcTh9qevVANLA
         SgQ/MtxIHU4EVKZPPpRehEyvlpa0avplPl/f959mVQascXO2btq+1X95cKtiuCJkVbFX
         M81w==
X-Gm-Message-State: AOJu0Yy7YcCX4VDn/zZ+qHDfshMwNnrs4hCtbvWAJJIlH1F9GQqUq4bX
	QDewG9Z+xc54konKfuhT4sw/tFAI4zd2oIpiZbW3dCuTes9Ov1ok3/FxWCsnujoECSH3RoDOk6L
	oHzeK6IceC5Gw1J+cmlaYxThg4i5VqvQGLojR4PxNMkH0XYlpwg7VSxa/hQI/
X-Gm-Gg: Acq92OFHKvHH8zV7uGXa5P88niLutGxD0r+N84I7s822vsgLKH4ixnvEecYO/8/LUlC
	7h3pZhLiUAE3b2cXfhKrb76M20UuE1JiF7fbQcCEFE91h75D8bqLd71hbZY+K2MaqzBQD0q/CyI
	1GVPxdWXPW5D+tW8W0+2AvhQ5pPYO3pYNYd/COOcmzl782xkvWwOI9P9NZ5K7xh4MsAIO/+sZD7
	g8gemYvYXF0xUZWwqT+l5YzajkmYPXfzCmpsTlFrjlx1V9LUgobr6tXaelOJ6eBglS72EZlWif+
	F9+GX9R0Z3jahJ0GAkg1ddwffEKPnG8P+404If1SFbfFOLRxFI2OwVb0iAleFKKJWa9i0gnC0jx
	hE5nONm8av/78WyQHqY1LgELiN5Y2U7zIY6QtZAaDDdf9358AKSFLy7FyeuTHA5DoyCzDPA==
X-Received: by 2002:a05:6214:328c:b0:8ac:b39b:e745 with SMTP id 6a1803df08f44-8c7bbd6b490mr4086876d6.33.1778613985329;
        Tue, 12 May 2026 12:26:25 -0700 (PDT)
X-Received: by 2002:a05:6214:328c:b0:8ac:b39b:e745 with SMTP id 6a1803df08f44-8c7bbd6b490mr4085466d6.33.1778613983760;
        Tue, 12 May 2026 12:26:23 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:2500:540d:8da2:f197:6711? ([2600:4040:530f:2500:540d:8da2:f197:6711])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b53d0702aasm371099756d6.43.2026.05.12.12.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 12:26:23 -0700 (PDT)
Message-ID: <b775c420-da70-4568-afd6-3a3aabbe6b10@redhat.com>
Date: Tue, 12 May 2026 15:26:22 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] dm: add deviceless messages
To: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>,
 Bruce Johnston <bjohnsto@redhat.com>
Cc: dm-devel@lists.linux.dev
References: <3bdbd9fa-52ce-ab52-569f-29d4a30c6780@redhat.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <3bdbd9fa-52ce-ab52-569f-29d4a30c6780@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aVePSaPGTFQanv8Jf2SvDLMd-0lptwMOozG2JOBNyPU_1778613987
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/12/26 9:36 AM, Mikulas Patocka wrote:
> The VDO code needs to perform some calculations before creating a device.
> The calculations should be performed in the kernel, so that the same logic
> is not duplicated in the kernel and in the userspace.
> 
> However, currently it is not possible to call a device mapper target
> when no device exists.
> 
> This commit solves the problem by adding "deviceless" messages. If the
> message starts with '%', the name is a name of a target, not a name of a
> device. The message will be directed to the target by calling the
> "deviceless_message" method. The target can perform the requested
> calculations in this method and return the result back to userspace.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

I do wish that we could clean up the message interface. The sector 
number argument is completely meaningless for a deviceless message, so 
in theory we could distinguish this case by omitting the argument, e.g. 
"dmsetup message <target_type> <command>" and not require the special 
'%' notation, either. But that looks like it would require a lot more 
rearrangement of the message handling code.

I agree this does what we need, so...

Reviewed-by: Matthew Sakai <msakai@redhat.com>

> ---
>   drivers/md/dm-ioctl.c         |   57 +++++++++++++++++++++++++++++++++---------
>   include/linux/device-mapper.h |    4 ++
>   2 files changed, 49 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-ioctl.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-ioctl.c	2026-05-06 22:15:36.000000000 +0200
> +++ linux-2.6/drivers/md/dm-ioctl.c	2026-05-11 12:53:37.000000000 +0200
> @@ -1743,6 +1743,33 @@ static int table_status(struct file *fil
>   	return 0;
>   }
>   
> +static int message_for_module(const char *target_name, unsigned int argc, char **argv,
> +			      char *result, unsigned int maxlen)
> +{
> +	struct target_type *tt;
> +	int r;
> +
> +	if (**argv != '%')
> +		return 2;
> +
> +	tt = dm_get_target_type(target_name);
> +	if (!tt) {
> +		DMERR("unknown target name %s", target_name);
> +		return -EINVAL;
> +	}
> +
> +	if (!tt->deviceless_message) {
> +		DMERR("target %s doesn't support deviceless messages", target_name);
> +		r = -EINVAL;
> +	} else {
> +		r = tt->deviceless_message(argc, argv, result, maxlen);
> +	}
> +
> +	dm_put_target_type(tt);
> +
> +	return r;
> +}
> +
>   /*
>    * Process device-mapper dependent messages.  Messages prefixed with '@'
>    * are processed by the DM core.  All others are delivered to the target.
> @@ -1788,10 +1815,6 @@ static int target_message(struct file *f
>   	char *result = get_result_buffer(param, param_size, &maxlen);
>   	int srcu_idx;
>   
> -	md = find_device(param);
> -	if (!md)
> -		return -ENXIO;
> -
>   	if (tmsg < (struct dm_target_msg *) param->data ||
>   	    invalid_str(tmsg->message, (void *) param + param_size)) {
>   		DMERR("Invalid target message parameters.");
> @@ -1811,9 +1834,19 @@ static int target_message(struct file *f
>   		goto out_argv;
>   	}
>   
> -	r = message_for_md(md, argc, argv, result, maxlen);
> +	r = message_for_module(param->name, argc, argv, result, maxlen);
>   	if (r <= 1)
> +		goto out_deviceless;
> +
> +	md = find_device(param);
> +	if (!md) {
> +		r = -ENXIO;
>   		goto out_argv;
> +	}
> +
> +	r = message_for_md(md, argc, argv, result, maxlen);
> +	if (r <= 1)
> +		goto out_md;
>   
>   	table = dm_get_live_table(md, &srcu_idx);
>   	if (!table) {
> @@ -1838,14 +1871,13 @@ static int target_message(struct file *f
>   		r = -EINVAL;
>   	}
>   
> - out_table:
> +out_table:
>   	dm_put_live_table(md, srcu_idx);
> - out_argv:
> -	kfree(argv);
> - out:
> +out_md:
>   	if (r >= 0)
>   		__dev_status(md, param);
> -
> +	dm_put(md);
> +out_deviceless:
>   	if (r == 1) {
>   		param->flags |= DM_DATA_OUT_FLAG;
>   		if (dm_message_test_buffer_overflow(result, maxlen))
> @@ -1854,8 +1886,9 @@ static int target_message(struct file *f
>   			param->data_size = param->data_start + strlen(result) + 1;
>   		r = 0;
>   	}
> -
> -	dm_put(md);
> +out_argv:
> +	kfree(argv);
> +out:
>   	return r;
>   }
>   
> Index: linux-2.6/include/linux/device-mapper.h
> ===================================================================
> --- linux-2.6.orig/include/linux/device-mapper.h	2026-04-27 19:06:34.000000000 +0200
> +++ linux-2.6/include/linux/device-mapper.h	2026-05-11 12:45:45.000000000 +0200
> @@ -93,6 +93,9 @@ typedef void (*dm_status_fn) (struct dm_
>   typedef int (*dm_message_fn) (struct dm_target *ti, unsigned int argc, char **argv,
>   			      char *result, unsigned int maxlen);
>   
> +typedef int (*dm_deviceless_message_fn) (unsigned int argc, char **argv,
> +			      char *result, unsigned int maxlen);
> +
>   /*
>    * Called with *forward == true. If it remains true, the ioctl should be
>    * forwarded to bdev. If it is reset to false, the target already fully handled
> @@ -214,6 +217,7 @@ struct target_type {
>   	dm_resume_fn resume;
>   	dm_status_fn status;
>   	dm_message_fn message;
> +	dm_deviceless_message_fn deviceless_message;
>   	dm_prepare_ioctl_fn prepare_ioctl;
>   	dm_report_zones_fn report_zones;
>   	dm_busy_fn busy;
> 

