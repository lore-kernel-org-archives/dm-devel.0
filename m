Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B712938F9D
	for <dm-devel@lists.linux.dev>; Mon,  4 Mar 2024 11:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709551640; cv=none; b=H3bjXmxz4mNm2VI6XizFFFqDF7j8y1cabjduSeIIZ4dJc6o8faQ7z3sDn2svFd2I6k7LSiwUkJUV1pkXxflmNgrQ09DuaMBmwBlfxFc7IUpPB770GtEzwhzb1Yn6USkfshg1zPDzho+AE1QrgpHSzaly5WInRLHDTvXh9RdoCJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709551640; c=relaxed/simple;
	bh=NGYyyTSQnjBEMXs2vRYcHkLT9Y5nRoosDCA5vAwPckU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=OMThyuU2O8SSEC9qkp9ULoVw0/HqztirMEchbx/u5D/fzvXbmauBFJsBAOlpUIZUkKssJLW/z8OwOH2dpTaX10jk3hfH8CHGkKA0/2QSEYCS0H1IXfXIBKkw+oc8EfEofZAk+5KBeqrW0BTLFCYJAqoRu0CNyGe8ij7xlUUHoss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Exdm3nqZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Exdm3nqZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709551637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FBVMATWuYOy7BS4nCbh49sh86+ikOBmanBKXv+e6/Dg=;
	b=Exdm3nqZVySPi6cOmqirxKiM90vSNtt/XfTnmWSsV6AFtIMjZMhWZ7C0YC68Esgdw75otU
	vMTVixXAUSNfrTgZBAO0Y7XnWnxomJtpHQ+t57gSXgZzXz/N1xVNmC6nk7or4leqE3ZmIM
	/bOzgXJBmEj2VbGYfa6gZdddT9xUgvk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-ydcmaJoAM3yYJmL_vWUt8w-1; Mon, 04 Mar 2024 06:27:16 -0500
X-MC-Unique: ydcmaJoAM3yYJmL_vWUt8w-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2d33e6f838dso29131421fa.0
        for <dm-devel@lists.linux.dev>; Mon, 04 Mar 2024 03:27:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709551635; x=1710156435;
        h=content-transfer-encoding:in-reply-to:autocrypt:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FBVMATWuYOy7BS4nCbh49sh86+ikOBmanBKXv+e6/Dg=;
        b=Kkg20/fYtkdP/hLqOZaugMHAOgz8Foe9t8lkmP1DeNCc9M3bKZlpz2FODs5WXNDm66
         JKJ2x9gMcX+JH0zufQLcmQJBo3ntQ7rO2UD0DyH1LM4TgirJo6diij9L8YbUnXtmFV/R
         EXvVJZNz/loESkXUxgFluZ0sWYD8AcMR5C4hgpTsuKf+apj0oD3AAySZyOpZt62NhDMr
         aThzSRLrNcZH5tdQKzKczWsqxvuuxK3a6V+gcPsxwWJWAtDQ23EHEBu5Rp5PsugqQtbN
         +fFCGT7DdIRs907NLq6espvWOoaTUZ6Io+M59fV3Qm4FsA/7XOoX2floCgwj8FCUvaHB
         2q+A==
X-Forwarded-Encrypted: i=1; AJvYcCUTOrW7//L1fbhNrQrNmmZIedTuNcWrCvHvjdC12d9dFoYloeNIZ67XITq5Gm8g/5wTxIjgHdzb4jq9f6qeoKLeuDXfw77dkN0=
X-Gm-Message-State: AOJu0YwBk2/8ZpGKU6oK9s4iz7q80SCEnzDf/Dm9jyxdFjZ8x3EM1eVX
	pvvBR7I2TGTeh3dH2KjTZbY+rrLeQlMBUJGECPwMCZHj2uFXo4yJ4KyPX/02kcptl0GQU4NANj8
	BeAjz9iYkGn5YxP4Nk4kFb2sJ2PNhhT8YgvDr0wsSVN5QPmrjJLEXDJfO
X-Received: by 2002:a2e:b179:0:b0:2d2:4160:bb73 with SMTP id a25-20020a2eb179000000b002d24160bb73mr6025034ljm.3.1709551634884;
        Mon, 04 Mar 2024 03:27:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH8d2VEQZM5fT5mLQC9gGOpmQKdcm5iS9b1fRhXM5JwNM6koNEwx+a36Qjq3VlIlDnoNMviKA==
X-Received: by 2002:a2e:b179:0:b0:2d2:4160:bb73 with SMTP id a25-20020a2eb179000000b002d24160bb73mr6025022ljm.3.1709551634534;
        Mon, 04 Mar 2024 03:27:14 -0800 (PST)
Received: from [10.43.17.192] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id fa10-20020a05600c518a00b00412e17d5f83sm3797046wmb.14.2024.03.04.03.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 03:27:14 -0800 (PST)
Message-ID: <9c68e2b7-64e6-4e3d-83ea-5229ea7eff60@redhat.com>
Date: Mon, 4 Mar 2024 12:27:13 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/7] 10-dm.rules: don't deactivate devices for
 DISK_RO=1
From: Peter Rajnoha <prajnoha@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>, Zdenek Kabelac
 <zkabelac@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev,
 Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>
References: <20240301224011.11117-1-mwilck@suse.com>
 <20240301224011.11117-3-mwilck@suse.com>
 <b884374b-2f6f-4c7f-acba-b4c730ae03ff@redhat.com>
 <537880de-21ad-4dcc-92a7-a80092757ba7@redhat.com>
Autocrypt: addr=prajnoha@redhat.com; keydata=
 xjMEY7QY9hYJKwYBBAHaRw8BAQdADIHZn5yeZYFV18ewwf4iudpl1ARfj4rnxX5xiSoJ15vN
 I1BldGVyIFJham5vaGEgPHByYWpub2hhQHJlZGhhdC5jb20+wpYEExYKAD4CGwMFCwkIBwIC
 IgIGFQoJCAsCBBYCAwECHgcCF4AWIQQhe3cZL8e9dSzFIwXndmZANt+EqwUCY7QZ9wIZAQAK
 CRDndmZANt+EqzosAQDXhWudIjLSGoWGPKgluEWw5B5LtAX+kW2OG7loCDzI2AD/fp3Xec8K
 JY7HrSqO98YMPbT98+YRjiopJSk75TcAogzOOARjtBj2EgorBgEEAZdVAQUBAQdALfG8fuls
 uqLPtrJ5tYb36UtqNlu6Bw9ME/Ou+FRGG1cDAQgHwngEGBYKACAWIQQhe3cZL8e9dSzFIwXn
 dmZANt+EqwUCY7QY9gIbDAAKCRDndmZANt+Eq22lAQDXlKMGQxkD0FZes94uihIZlhFwGjrX
 dVfZsxfwEvuJfAD/XLGDegnKVERbF6YTfdsbVngSlOX/Tu/fxAFTg0JfdQU=
In-Reply-To: <537880de-21ad-4dcc-92a7-a80092757ba7@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/4/24 12:19, Peter Rajnoha wrote:
> On 3/4/24 11:48, Peter Rajnoha wrote:
>> On 3/1/24 23:40, Martin Wilck wrote:
>>> DISK_RO=1 is set in the environment of a block-device uevent if and only if
>>> the device has just been set read-only by a driver by calling set_disk_ro().
>>> It is not synoymous with the "ro" sysfs attribute; the device could very well
>>> be write-protected if DISK_RO is not set. Probing should be possible even if
>>> this flag is set, because blkid and friends usually don't write to the
>>> device. Upper-layer subsystems that do need to write would need to check the
>>> "ro" sysfs attribute rather than DISK_RO.
>>>
>>> Skip the DISK_RO check in 10-dm.rules.
>>>
>>> Signed-off-by: Martin Wilck <mwilck@suse.com>
>>> ---
>>>  udev/10-dm.rules.in | 3 ---
>>>  1 file changed, 3 deletions(-)
>>>
>>> diff --git a/udev/10-dm.rules.in b/udev/10-dm.rules.in
>>> index 4ffd3e2..c08d829 100644
>>> --- a/udev/10-dm.rules.in
>>> +++ b/udev/10-dm.rules.in
>>> @@ -50,9 +50,6 @@ ACTION!="add|change", GOTO="dm_end"
>>>  # kernels >= 2.6.31 only. Cookie is not decoded for remove event.
>>>  ENV{DM_COOKIE}=="?*", IMPORT{program}="(DM_EXEC)/dmsetup udevflags $env{DM_COOKIE}"
>>>  
>>> -# Rule out easy-to-detect inappropriate events first.
>>> -ENV{DISK_RO}=="1", GOTO="dm_disable"
>>> -
>>>  # There is no cookie set nor any flags encoded in events not originating
>>>  # in libdevmapper so we need to detect this and try to behave correctly.
>>>  # For such spurious events, regenerate all flags from current udev database content
>>
>>
>> Yes, I'd like to get rid of this rule, but, unfortunately, there's one
>> issue during the DM device creation/activation.
>>
>> For example, if I try:
>>
>>   dmsetup create --readonly --table "0 1 zero"
>>
>> Then I get these uevents:
>>
>> 1)
>> ACTION=add
>> DM_UDEV_DISABLE_OTHER_RULES_FLAG=1
>> DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG=1
>> DM_UDEV_DISABLE_DISK_RULES_FLAG=1
>> SYSTEMD_READY=0
>>
>>
>> 2)
>> ACTION=change
>> DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG=1
>> DM_UDEV_DISABLE_DISK_RULES_FLAG=1
>> DM_UDEV_DISABLE_OTHER_RULES_FLAG=
>>
>>
>> 3)
>> ACTION=change
>> DM_COOKIE=6335392
>> DM_COOKIE_DISABLE_OTHER_RULES_FLAG=
>>
>>
>> The uevent 3) coming with the DM_COOKIE is the actual event when the
>> device is ready for use (that's the uevent notifying the DM device
>> resume/activation).
>>
>> If we remove the DISK_RO rule, then the DM_UDEV_DISABLE_OTHER_RULES_FLAG
>> is unset for uevent 2), which in turn causes the SYSTEMD_READY=0 to get
>> dropped, which in turn will start all the systemd hooks because the
>> device is considered "ready" for systemd then.
>>
>> But the DM dev is ready only after uevent 3) that comes with the
>> DM_COOKIE. So we still need to cover this scenario.
>>
> 
> Hmm, this doesn't even work with original rules!
> 
> The 99-systemd.rules has:
> 
> SUBSYSTEM=="block", ACTION=="add",
> ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", ENV{SYSTEMD_READY}="0"
> 
> which applies only to "add" uevent, not "change". This means that
> SYSTEMD_READY="0" is even dropped for the DISK_RO="1" uevent even if it
> is marked as DM_UDEV_DISABLE_OTHER_RULES_FLAG="1".
> 
> This is actually a bug. But a minor one, because here we always have the
> change uevent with DM_COOKIE coming right after the DISK_RO change
> uevent. So there's almost no window practically.
> 
> Now, I'm asking myself why we have the 'ACTION="add"' in the systemd
> rule at all. Why is it not just checking  DM_UDEV_DISABLE_OTHER_RULES_FLAG?
> 

Oh! :)

https://github.com/systemd/systemd/commit/35a6750d9e26b26b423fbe815bead7d750210d8d

-- 
Peter

