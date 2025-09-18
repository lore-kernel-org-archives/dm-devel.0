Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5172FF164
	for <dm-devel@lists.linux.dev>; Thu, 18 Sep 2025 11:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758193690; cv=none; b=rxdUBqmh6e+Q2pMg/uLBO+Y/E8LQqkas8MgWjPUEFzp7ITWDV3EZFsvo8Ah9KnJW8JidYNZSNSyDA7gL+fhd9N8wOiGc9B1E3DDf3Kb0YwmOFHJ4272UoIYIxCLEjuZBrJDz2cE07fwR/URZPzcNJQ/6qqJr+NS6G5WSxuoZIvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758193690; c=relaxed/simple;
	bh=qBFWlAzQl4WkssVO7PVWWZdcucXWBXEiPT7NX2RDoG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ipZo9OsOG/oTzKGpqsbKD1ABqxOmvNjOiK9iNl6N6VUeTg30FuItTxXi0jN1GhqBB2Hv7R+7ENQAsXldYhbV0Y0TYo3GLfGdN/sdSleb0OykKditPZP5pLG2frpdzgbM0mUvhJ33NbWGcb5Yd3Uh7JBDxRxOtUBzpXZ3aL7lO5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WWnNt3az; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WWnNt3az"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45f2cc29fd8so1230335e9.2
        for <dm-devel@lists.linux.dev>; Thu, 18 Sep 2025 04:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758193687; x=1758798487; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OEf+IUjwmWIL0hpi34Cdy1I96SmkD8AQLyEkUuI2pOE=;
        b=WWnNt3azprh+eDnbalPtA5ej+Hynu+W4TKkBBRXTwvXEORUrALdZl9L8QPVwdhI3YF
         grv0DTtqpiyxSP44+Ru1GLvfmJWA4sHnQtYkOazTyCMb3xaRjzUMB1episuQtIUhAzfU
         kV/AzJTOu2y3Tk2NMf3+3ZHKydMfAzEC59AWdWX1I9/+DROmz5H/hnVsIsV5t3Sdklag
         hlT43PsWEss0cC4H5q6lbxHzFOi9smVWOqgRYWu1VmEq9NePK4yxEyYzdryyMD5Ts7pZ
         WiN1r9ojvqU41Zkb2rzaHwt9QitJky3crmm4RP63xUeybKJhWPTPI0vMLevbwMOywh1u
         DKfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758193687; x=1758798487;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OEf+IUjwmWIL0hpi34Cdy1I96SmkD8AQLyEkUuI2pOE=;
        b=fJdGtWvMrVsR6UzgYlsOJhKPmcavZbexKYziaqmz21oOJHunA5giuXUmiFK04HBFCc
         pxNxnfAd2y3EoXvFqSU2ZLKsmGa0IIVyihDmbL4fnAbmDuq5CjpG3/h2V7JR/HJx8VU1
         zu0Cugf5SVux24rdNE3zCy8xmtqfx0pguf1VoqfFIA7FD/9PM9kNShlaxDdJGIOykC3T
         TxuqbJ6xHbBMAg2uuJ2yYMWnd123y2roHPmreM3mSZlrhcg06u38DOJD4dBMltitAlsq
         XuE+7WzpHBOnu1830FKpqZCVlL1QyF0hGa3oEwKVytsgKunB/bphzYzEjM4HzZ6HKLr6
         t6gg==
X-Forwarded-Encrypted: i=1; AJvYcCXYaXDioVmv1HNRWMV4BDiDfBiaVPBpT2ZtNVHfAmt50B1CqZpmLMwKioc3eltWo5WEXNd3eavISg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx567C6Iadj6rnSHwg16vAV6h9NzVMPLyR+6tUHb4V1wNUqCMy8
	VuvSS7ucFN/njGlFMfgzc11goztpNiOvFWsnC6jX7Lshm9aIJz4jNvw=
X-Gm-Gg: ASbGncvzE4SNKYyA42EpBRdv0TPG2PR0xMgTkR8K0VQyQpGDT2RRnhwesok3zCZicK7
	JpfThMACQCkA78YJ+ntajIy36p9cZnmQo4hTuYsqGMxBh5qDEEe+TyjNsjaijUwwH2CeSESlQys
	RQH6BdxhaUclQp8FTqGaMPNdhiIlCw9WHMlEKRdsKj0Q0SOcq2hfuYCnd/lmYGi7tigPMZ1miZv
	umPlEzlD3fuf4lH/cIcw5m1Ef2lU1XvIKaz0x3DGmkBCWAmz2K8tsuIfyqjQHUmWiIeX0rpkC5U
	XWG+9OekjH4EeXNhde1ch8o/3Gfy4QETd++jXzRafbdt8scuPO8U4Cjlk+PE8lolvvPJU2E2ETf
	KiOo1+OrOjytihKPTvtekOoYA5j23xQLsLs2NN+v1wxmYVI5kLhltt7mc8WyW6MhV0co76HuY0q
	z5FaQ=
X-Google-Smtp-Source: AGHT+IG8uQ3JjV3c0JDUkJsmmZ5+Lv5LjpuACGts+kzj2aaW6csSLFxbCMV6mf47lZ74hxUJe+Z+zw==
X-Received: by 2002:a05:6000:1449:b0:3e5:5261:7ffa with SMTP id ffacd0b85a97d-3ecdfa4fe0dmr2262639f8f.9.1758193686882;
        Thu, 18 Sep 2025 04:08:06 -0700 (PDT)
Received: from localhost (85.red-80-39-42.staticip.rima-tde.net. [80.39.42.85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee074121b2sm3215090f8f.27.2025.09.18.04.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 04:08:05 -0700 (PDT)
Message-ID: <c97167e3-efb8-4a77-9882-662594b77654@gmail.com>
Date: Thu, 18 Sep 2025 13:08:04 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] multipath-tools: add Acronis Cyber Infrastructure to
 hwtable
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20250910194205.145919-1-xose.vazquez@gmail.com>
 <20250910194205.145919-2-xose.vazquez@gmail.com>
 <aMMNV-_0nX0gOdXM@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <aMMNV-_0nX0gOdXM@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/25 7:56 PM, Benjamin Marzinski wrote:

> On Wed, Sep 10, 2025 at 09:41:57PM +0200, Xose Vazquez Perez wrote:
>> Source: https://dl.acronis.com/u/software-defined/html/AcronisCyberInfrastructure_3_5_users_guide_en-US/accessing-iscsi/accessing-iscsi-targets-from-linux.html
>>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Benjamin Marzinski <bmarzins@redhat.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>   libmultipath/hwtable.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>> index 1a78c36d..12e10577 100644
>> --- a/libmultipath/hwtable.c
>> +++ b/libmultipath/hwtable.c
>> @@ -1371,6 +1371,21 @@ static struct hwentry default_hw[] = {
>>   		.pgpolicy      = GROUP_BY_SERIAL,
>>   		.no_path_retry = 30,
>>   	},
>> +	/*
>> +	 * Acronis
>> +	 */
>> +	{
>> +		// Cyber Infrastructure
>> +		.vendor        = "VSTORAGE",
>> +		.product       = "VSTOR-DISK",
>> +		.prio_name     = PRIO_ALUA,
>> +		.pgpolicy      = GROUP_BY_NODE_NAME,
>> +		.detect_prio   = DETECT_PRIO_OFF,
>> +		.features      = "2 pg_init_retries 50",
>> +		.pgfailback    = -FAILBACK_FOLLOWOVER,
> 
> I'm not sure about the pgfailback setting. the FAILBACK_FOLLOWOVER mode
> is not something that is really needed for a specific array type. It
> works like FAILOVER_IMMEDIATE, but it's designed to work so that if
> multiple nodes are using the same multipath device, and one of them
> loses access to the highest priority pathgroup but the others don't,
> multipath won't keep switching pathgroups back and forth. The nodes that
> can see the higher priority pathgroup won't automatically switch back to
> it, since they weren't the ones that switched away from it. So the
> setting is more for a specific use case, and not a specific array type.
> 
> On the other hand, it is what the vendor tested, and with a single
> machine accessing the multipath device, you usually only switch away
> from the highest priority pathgroup because you lost access to all the
> paths in it. So it usually won't get stuck on a lower priority pathgroup
> while a higher priority one is usable, although that could happen.
> 
> Thoughts?

Yes, it is a weird value for pgfailback. But it's in two docs from
different vendors:
https://dl.acronis.com/u/software-defined/html/AcronisCyberInfrastructure_3_5_users_guide_en-US/accessing-iscsi/accessing-iscsi-targets-from-linux.html
and https://docs.virtuozzo.com/pdf/virtuozzo_hybrid_infrastructure_6_2_users_guide.pdf

I don't even know who the real manufacturer is.
