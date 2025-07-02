Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F30E30AAB1
	for <dm-devel@lists.linux.dev>; Wed,  2 Jul 2025 14:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751467984; cv=none; b=RwEdkR+LK8t/BhOHV17ERIpG6tyW0gtu3s82I0Dfhl7aJAyj0sK859OXEFUfAHjj2B/l/9H/jfKKQ62j6jtm8iemP1hLCgs9RUhobXNhzSJ+th2wMntoSOok+D8A3qLcYsx5xOwRnBTEQIu5Oz9SnYWBBLmbwHIUV3MSTAzn4Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751467984; c=relaxed/simple;
	bh=1czxn8sEJrwh8Sb5DBYJzEDLgBogkTU+8+YFGNfJ5p0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GjzP8e9p/TSGEsVT8Of99A9tz/RdVkcYs8n42+THCk1YgCM4Y2W6JxQITypjd5f/4Gro9XskM/hDLXLsJKuTmbdgYe2Vq84qNvlyuhywiUqLnEJCso7r6+P/WGpcYo1LfEfKELGPzumkxAUrS7Ayz4Psc33AI5JWUZRuvvehMuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SvqP/UrX; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SvqP/UrX"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a6f24ef3acso739043f8f.3
        for <dm-devel@lists.linux.dev>; Wed, 02 Jul 2025 07:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751467981; x=1752072781; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B8C1E8Kh1L5DFNA7napP8JtAHjrocXALarLTItHCHto=;
        b=SvqP/UrXYgg2LcN9ZSobzEH3eHZhgmopSE2WiBGiykuyy2vaIjX+VPFv9Cwljy0Fys
         i23n2zDBymEL6Y/wZCsnkg7cs1v+oTOf7DrUrCYMAUo3jn7fr8gEgje7dINKs3+B6xBs
         K9koI7Vf/5VKhKmviiFd9L+ELDGrHNwXNd6x2vMHrilHxKVTCQmNQ26KKWW4S/IFDA4t
         /WwtnVpyU1+HZ8W4kJCbF5W8m+rfLqRplNNOYoVHT6F1MwGPvTEmS4aXGCREFvgHlZFi
         /yq5jN/2jz5So4G8tE+tPemVBwOHOKxx5ahpmYbI6Gp0QqXLeotG21pWwpe544tRprrV
         Yf1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751467981; x=1752072781;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B8C1E8Kh1L5DFNA7napP8JtAHjrocXALarLTItHCHto=;
        b=vROTzg4dgPvx6fuZCoVbYf9yDXoOgmEoNYAl4mRMdkQ0zs3/P/aPKHQlnaDVtycPTH
         9iFuB9LrDx20qU8P04vLud9rDVZt9i3K+ja/yXUIarlsx2GrXyqBBKGzLRruWAdqwhNk
         HvQ0xtEnLDAKNoOPoql7BmxrL3d9zuMhV2Dku0ncE/wNDarlk/FVDPFp8TD9WkTW4WkY
         amzxMzDEhrHwyyMkEjivGDD4BnfaZbmSI5+H+FUej0aFCPpVi4i/OSnSgduQ0uARHqip
         6YtyiNuy2Tn6oKSnulQ4b50W40qqK7qrr54ujS8oThd4plLtm8CbQ1NIEPkTb2WqoksT
         YV8g==
X-Forwarded-Encrypted: i=1; AJvYcCVDkedI01UyutmqAk/mlMEHEnYO82wG45g7AF7k8M1WQEnP54a0scgYG2eSAsO8aik6sKHT5s1OtQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyRmZAOph90uAhfOQDOsvOncvdxZ7D49wTtmtzeZYKJ8cWMd7au
	kQWuLSAJ5tLMuMzN6Z2JQnipqjdBmszBPB1TIpwjd9XIaWSW8LyQhjs=
X-Gm-Gg: ASbGncsgF23b3SfurBZdiYNg5hHQTvH4/CvxaiWCeitMHbwhcNWuI66Iit9Xe9uIiH9
	7SmzhEYXGU7GB0KpjY7xjBLQxOS9vufXmoVEsOBrrP3e8TgLUJI8li9O8ifxtWqjFvqdaqkZR4Z
	M6M2emYq25cOhG5HOcjP/XEdJoyVXS00+CG8AdUj8nXAngWPB1ca7Tstr+crOVF1KYiwNYCdQoM
	dh+Cb+jU7Pj/mWD35hYTd3FLErlQWIllU0jw2R+g7vggEvV5AtuBQ76YtQnQLJiyLCQUd6Ml1Mc
	n6FylxE8/ZwiCprhG5fRK45Qa2T6es5yNRB96WzM/vBRInDdp8XFmJmXtLW+RgVkr8Js6/B8yUN
	ecyaxUcH/miI3UZv+bvB+JVMtpdbk3mqTVKe/
X-Google-Smtp-Source: AGHT+IH4laCVXPr/SteN0flcUwv3S6OQeC8QokqUDPtVMA1RE2+4mclykQ5QpdIgf8frNAotPxD63g==
X-Received: by 2002:a05:6000:2b08:b0:3a5:2ee8:ee1d with SMTP id ffacd0b85a97d-3b20067a0d0mr619223f8f.16.1751467980930;
        Wed, 02 Jul 2025 07:53:00 -0700 (PDT)
Received: from localhost (148.red-80-39-52.staticip.rima-tde.net. [80.39.52.148])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e52ca4sm16393120f8f.58.2025.07.02.07.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 07:53:00 -0700 (PDT)
Message-ID: <c5c09220-4174-4912-8884-46b0ff936eb8@gmail.com>
Date: Wed, 2 Jul 2025 16:52:59 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] md: dm-ps-*: delete version strings
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 DM-DEVEL ML <dm-devel@lists.linux.dev>
References: <20250625111918.219963-1-xose.vazquez@gmail.com>
 <3480a823-c12a-81d4-5293-fc2052bf25bc@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <3480a823-c12a-81d4-5293-fc2052bf25bc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/30/25 3:19 PM, Mikulas Patocka wrote:

 >> On Wed, 25 Jun 2025, Xose Vazquez Perez wrote:
 >> [...]>> diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
>> index 969d31c40272..cbb0ac63bb7a 100644
>> --- a/drivers/md/dm-ps-service-time.c
>> +++ b/drivers/md/dm-ps-service-time.c
>> @@ -20,7 +20,6 @@
>>   #define ST_MAX_RELATIVE_THROUGHPUT	100
>>   #define ST_MAX_RELATIVE_THROUGHPUT_SHIFT	7
>>   #define ST_MAX_INFLIGHT_SIZE	((size_t)-1 >> ST_MAX_RELATIVE_THROUGHPUT_SHIFT)
>> -#define ST_VERSION	"0.3.0"
>>   
>>   struct selector {
>>   	struct list_head valid_paths;
>> @@ -344,7 +343,7 @@ static int __init dm_st_init(void)
>>   	if (r < 0)
>>   		DMERR("register failed %d", r);
>>   
>> -	DMINFO("version " ST_VERSION " loaded");
>> +	DMINFO(" loaded");
>>   
>>   	return r;
>>   }
>> -- 
>> 2.50.0

> I think this isn't needed. The version doesn't do any harm.

Wrong information is provided to the user.
The code is modified, but the version remains the same.

Usually MODULE_VERSION has the same problem in the kernel tree.
