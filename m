Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01740480DDF
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 17:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778693109; cv=none; b=VjtjfxckIDf4Lm3kCxtKfmphdpUF5Jk5AJRGlXPBNDszZZ9+IWmrvJ0L7yNv8mJKQhtNtfJ0biZ3j5jNRvb05QcvlK1XczSvjxrZdrM9tz6hFbtb3uiahTcSrhZToF6Z8GHS6e9XHonOOofd8ByB+XLTzy5SABZX6rG1XTbLJyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778693109; c=relaxed/simple;
	bh=lOr+kq+Ya8i8/qQ71G03gxzz1/AiOir6/gocXmwpXZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OvRhj1w9wsQx9SCDtVbFLZ/0x+03zhdO69tCLzvcbKfs2ifG5GOyJsIIoaaEJTFCYUuTJJNU01UTS0ovU1aINLn3GsFF+rvBuL9K6hjxnHMDhhiO7U5TOPHuRQ/8/G+mYBgHcs6oJRbC6t3unkZqr3VPdwCW/1OG4Ut1P5XtowI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gvIvuPc1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gvIvuPc1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778693103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HYG5odowQLBHAZXfx93AtvT8BGKY4INevpS1Al27kCE=;
	b=gvIvuPc1CRc8fPJz7VxZy/Cb9zgQkpuxtK01/EQTo3xpbISknbx2T7G7M38SlUE1cors6q
	dRU7SO2piHq+4ayrOCffnKesYifV67geJ1ewwUa9GTa80fWlmzMAJPCq69Owkw07uh8Vot
	IPzG5rD9He3UEjkFBj+0pDqBxFjdrjY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-LtWp5U8OOXmQvNRdaQADrA-1; Wed, 13 May 2026 13:25:02 -0400
X-MC-Unique: LtWp5U8OOXmQvNRdaQADrA-1
X-Mimecast-MFC-AGG-ID: LtWp5U8OOXmQvNRdaQADrA_1778693102
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-90e311df56eso429690985a.1
        for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 10:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778693102; x=1779297902;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HYG5odowQLBHAZXfx93AtvT8BGKY4INevpS1Al27kCE=;
        b=D3yjU1x9cSk1gRLVQ2WJQMNfz9dCXCP54phJ2HrVgD60Mkngpk03ElJPOzMHE2oTO+
         NHhUdCGKWIvXM2l2mK2OfoVsCAOmcqr56g3yFDLgnQuj10u2zKvTFj5i+8VKZgJDCe+O
         2qFkiO+cWZxvkLrMazJJu2Bz0BVcAuvIRRUV7WkrCZpPQNqDjpOLK+MozkxmPbdXqaUZ
         PMozfLdKZEfFznFIjPkc3OF9eYd68H73J8Bub/QhnJBp6vG5pE00SGdRDybRm2/J9Y07
         0YvkPipgkasMGuNBzfswQhep2nLGkQGuPN/6FT+9dsHMWLOmsQyblR/SY+Rn1BWLGT35
         RPbA==
X-Gm-Message-State: AOJu0YwR595qPtoZx10twVrTn5SefTPBoELEHQ9B/yvllroXax8BN5uN
	V+wozMsD1rzcK+0RWYORiVIEsLMynOOgZAOEjHuCVPX+bWQi/QocN9cUtiq7tTH7kHjB76Ynp3I
	LBjHU5GRrI5SzUbITQUDOrqUVdLoDOJeFRnGiOdT58GP9eW/d2BhP0jYUMzYO
X-Gm-Gg: Acq92OF2Z5ghHrv3egN6nWUJTqzqtFpTXj9lLNDrbHyVVdx0A9ZzPDdrM8gOlhtQsB5
	FiLcfGsHR0e6MLi7xOkCCUk8SpQ4LwZxXfVVYBQ4DWb5mFOOi+NJTT+ilG7RNQRQdTz4Ugx+cD0
	IKuBjnbos2ygQMv7H+eSI5DHgzrHM6MKIuAQRJaXLe8gTcZhJvmNYpVmRa0yAaiT6ndzhZogMZF
	YWgsq+owuB7oAWeAnd0+DDKw1wZRYpoNnE6SARZvST0ZdtZe00U7W56yPpUWLopitQOuIFvGMsw
	pGGtku7jmmnlmD1OZSlfQ7ZzQO8/WSGgejAbNjQbVCQLEHeMUZ9hBGbFW/mWQzcHtq5FDuOwTnx
	OEBHNr+yqjBbl1TGv5Ubku3atmd3eHMrNhVb4dn73E9VuGXUAXfZF3+nI5O4bAObSC6TP5g==
X-Received: by 2002:a05:620a:258a:b0:90c:f935:490d with SMTP id af79cd13be357-910b150779amr61210885a.43.1778693101957;
        Wed, 13 May 2026 10:25:01 -0700 (PDT)
X-Received: by 2002:a05:620a:258a:b0:90c:f935:490d with SMTP id af79cd13be357-910b150779amr61207285a.43.1778693101475;
        Wed, 13 May 2026 10:25:01 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:2500:540d:8da2:f197:6711? ([2600:4040:530f:2500:540d:8da2:f197:6711])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bc83b0f9sm13616585a.29.2026.05.13.10.25.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 10:25:01 -0700 (PDT)
Message-ID: <42b95a54-be6f-484e-b639-9479d265094d@redhat.com>
Date: Wed, 13 May 2026 13:25:00 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] dm: add deviceless messages
To: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>,
 Bruce Johnston <bjohnsto@redhat.com>, Milan Broz <gmazyland@gmail.com>,
 Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@lists.linux.dev
References: <290dd28a-e750-cbe9-f1a6-67bcf4b6fbb6@redhat.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <290dd28a-e750-cbe9-f1a6-67bcf4b6fbb6@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zU3RVIWrGJv-tR2Ld4uCg7-oWSSVfh8LTxMlzR3LNd4_1778693102
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/13/26 12:16 PM, Mikulas Patocka wrote:
> Hi
> 
> Here I'm releasing the second version of the deviceless messages patch. I
> discussed it with Alasdair and we concluded to change the format of the
> message. If the device is "." (note that this name is rejected by the
> kernel, so no device with this name could exist), the message is
> considered deviceless.
> 
> You could send the deviceless message to the linear target with:
> dmsetup message . 0 linear Hello
> 
> Mikulas
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> The VDO code needs to perform some calculations before creating a device.
> The calculations should be performed in the kernel, so that the same logic
> is not duplicated in the kernel and in the userspace.
> 
> However, currently it is not possible to call a device mapper target
> when no device exists.
> 
> This commit solves the problem by adding "deviceless" messages. If the
> message is directed to a device ".", the sector number is ignored and the
> first argument is the name of the target the message should be delivered
> to. The other arguments are passed to the target's deviceless_message
> method. The target can perform the requested calculations in this method
> and return the result back to userspace.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

I do like this format better.

Reviewed-by: Matthew Sakai <msakai@redhat.com>

> ---
>   drivers/md/dm-ioctl.c         |   60 +++++++++++++++++++++++++++++++++---------
>   include/linux/device-mapper.h |    4 ++
>   2 files changed, 52 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-ioctl.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-ioctl.c	2026-05-12 15:40:22.000000000 +0200
> +++ linux-2.6/drivers/md/dm-ioctl.c	2026-05-13 14:52:23.000000000 +0200
> @@ -1743,6 +1743,30 @@ static int table_status(struct file *fil
>   	return 0;
>   }
>   
> +static int message_for_module(const char *target_name, unsigned int argc, char **argv,
> +			      char *result, unsigned int maxlen)
> +{
> +	struct target_type *tt;
> +	int r;
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
> @@ -1788,10 +1812,6 @@ static int target_message(struct file *f
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
> @@ -1811,9 +1831,25 @@ static int target_message(struct file *f
>   		goto out_argv;
>   	}
>   
> +	if (!strcmp(param->name, ".")) {
> +		if (argc == 1) {
> +			DMERR("Empty message received.");
> +			r = -EINVAL;
> +			goto out_argv;
> +		}
> +		r = message_for_module(argv[0], argc - 1, argv + 1, result, maxlen);
> +		goto out_deviceless;
> +	}
> +
> +	md = find_device(param);
> +	if (!md) {
> +		r = -ENXIO;
> +		goto out_argv;
> +	}
> +
>   	r = message_for_md(md, argc, argv, result, maxlen);
>   	if (r <= 1)
> -		goto out_argv;
> +		goto out_md;
>   
>   	table = dm_get_live_table(md, &srcu_idx);
>   	if (!table) {
> @@ -1838,14 +1874,13 @@ static int target_message(struct file *f
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
> @@ -1854,8 +1889,9 @@ static int target_message(struct file *f
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
> --- linux-2.6.orig/include/linux/device-mapper.h	2026-05-12 15:40:22.000000000 +0200
> +++ linux-2.6/include/linux/device-mapper.h	2026-05-12 15:40:22.000000000 +0200
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

