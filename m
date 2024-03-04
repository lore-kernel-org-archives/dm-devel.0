Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E743117998
	for <dm-devel@lists.linux.dev>; Mon,  4 Mar 2024 11:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709551173; cv=none; b=Wlmo8sYt5WSOnFAlyr7qOMrhWQhnBrhsbuFU8ZWubSKbt/z29+pPkuQuiXCzEfqoInAMaI6b5rWNXH37aFCIZW779ysIBi2Ea8ltAUmwfiMV77CQAC2AQZ9SvD3Iq7QxT06xkWM2EPLQQBAOwl/bsBXB3TI30Qu/sfFX0gLsGcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709551173; c=relaxed/simple;
	bh=iGNbstdIv42ZXKM8MLRtiUGbrrEdeHRjxY69DVqQ94M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=iD+viXlYSZf6evUbHWz8lmQrb4WHxGif2G9PLj2nOX6o95MNxoXentvgFoa80i/4WJdlRHvr4ZXJKMjksXyvnWqfyAFnMtbqdcsmzYoDWDpsPMm9uPlxtmDUUyYPzKfNtdNGjZlY29Io/u0A1AggFti7wCzBd3Y+WGkBqCgVirc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a7xbbL/T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a7xbbL/T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709551170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+ucyqhNYCZRP49JDcFOyps+hgM+GI2QNx6+9wCK0xlQ=;
	b=a7xbbL/Tkq1w+yaukS4AmFILYoD5NCOl6usa3kdou3sh20QXg4/ZWqNuiIsbLSAmBACGJe
	GC06VoxkR0Hk2lRc6cAC5JrAR88RVLNy98NX0j2hfxMmrvm8uF/oqnLSUPkZCUxDh/Flql
	tMK+9wNsWCS+uLm/D05RdzCTCl/BIsM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-wnzUu95ZPwmG9DqAxwjFiA-1; Mon, 04 Mar 2024 06:19:19 -0500
X-MC-Unique: wnzUu95ZPwmG9DqAxwjFiA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-412e355e2abso4433495e9.2
        for <dm-devel@lists.linux.dev>; Mon, 04 Mar 2024 03:19:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709551158; x=1710155958;
        h=content-transfer-encoding:in-reply-to:autocrypt:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ucyqhNYCZRP49JDcFOyps+hgM+GI2QNx6+9wCK0xlQ=;
        b=KAnolIDvIiyMCaIYRY1sTAzz2/Ok2nE9U5w41s2hdXmV6B/sKB4SfdFcZhcERqdpLA
         Wtv92GXjodG6ohw7bcBp2HiNboxrX7jFLH6AcxxnKTc3U9nayFDuog/jv79q3oYXyemP
         YDS5C5EnM7jvfjGecO4tEJfNfYCNLhgebVCX1/jzRUf7khlAqU2/ns0ktSGuTuNGVEU4
         0EQq/87y16J/BmZFhatuYtN96vdoqd0b26kf6JxKYfEDRmLi6fGMNbNWzDQdXgsCb8Uj
         XRflDxAEa+uLRiCIMENSRLg6QxGz6MTEH5WsADXAxb8j/xxiK2MndUVa15i3ZC224SCV
         Grng==
X-Forwarded-Encrypted: i=1; AJvYcCXTmhFRiEjfGvPd864Js0OteIhSlCDACZ9PRfwh6SfQx5OQqEE1upumNolm/CiHTcuJa9OE3z8vW1E89nBJtpoyYZGd1N59WnQ=
X-Gm-Message-State: AOJu0Yyracv1V7Mdvp61RZdOwclG1tKYzOdtyEHr2fdOYQzhXCrcZx7K
	ST7ME83/F9ohP3U30+0IxsNxN/7mOqa6yUoEEFeB+M7pGyl4Coi4s6flrf2H2OZMMx0Dwj/wSIC
	5oT0cPWRACULuyjOFldUPEfx2UMda1/Bi/7sYyv5KzenL/jT9BraIdUNh
X-Received: by 2002:a05:600c:474a:b0:412:bf52:9ac2 with SMTP id w10-20020a05600c474a00b00412bf529ac2mr7001579wmo.14.1709551158254;
        Mon, 04 Mar 2024 03:19:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG6uLilmuvhFbK+tdlyAHyf9XJZVV0SPKptDpkBtiN3sLZXwf3WY8U2p/nACyYrgvqCGDCVVQ==
X-Received: by 2002:a05:600c:474a:b0:412:bf52:9ac2 with SMTP id w10-20020a05600c474a00b00412bf529ac2mr7001557wmo.14.1709551157917;
        Mon, 04 Mar 2024 03:19:17 -0800 (PST)
Received: from [10.43.17.192] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s6-20020a05600c45c600b004129e8af6absm14314773wmo.33.2024.03.04.03.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 03:19:17 -0800 (PST)
Message-ID: <537880de-21ad-4dcc-92a7-a80092757ba7@redhat.com>
Date: Mon, 4 Mar 2024 12:19:16 +0100
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
Autocrypt: addr=prajnoha@redhat.com; keydata=
 xjMEY7QY9hYJKwYBBAHaRw8BAQdADIHZn5yeZYFV18ewwf4iudpl1ARfj4rnxX5xiSoJ15vN
 I1BldGVyIFJham5vaGEgPHByYWpub2hhQHJlZGhhdC5jb20+wpYEExYKAD4CGwMFCwkIBwIC
 IgIGFQoJCAsCBBYCAwECHgcCF4AWIQQhe3cZL8e9dSzFIwXndmZANt+EqwUCY7QZ9wIZAQAK
 CRDndmZANt+EqzosAQDXhWudIjLSGoWGPKgluEWw5B5LtAX+kW2OG7loCDzI2AD/fp3Xec8K
 JY7HrSqO98YMPbT98+YRjiopJSk75TcAogzOOARjtBj2EgorBgEEAZdVAQUBAQdALfG8fuls
 uqLPtrJ5tYb36UtqNlu6Bw9ME/Ou+FRGG1cDAQgHwngEGBYKACAWIQQhe3cZL8e9dSzFIwXn
 dmZANt+EqwUCY7QY9gIbDAAKCRDndmZANt+Eq22lAQDXlKMGQxkD0FZes94uihIZlhFwGjrX
 dVfZsxfwEvuJfAD/XLGDegnKVERbF6YTfdsbVngSlOX/Tu/fxAFTg0JfdQU=
In-Reply-To: <b884374b-2f6f-4c7f-acba-b4c730ae03ff@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/4/24 11:48, Peter Rajnoha wrote:
> On 3/1/24 23:40, Martin Wilck wrote:
>> DISK_RO=1 is set in the environment of a block-device uevent if and only if
>> the device has just been set read-only by a driver by calling set_disk_ro().
>> It is not synoymous with the "ro" sysfs attribute; the device could very well
>> be write-protected if DISK_RO is not set. Probing should be possible even if
>> this flag is set, because blkid and friends usually don't write to the
>> device. Upper-layer subsystems that do need to write would need to check the
>> "ro" sysfs attribute rather than DISK_RO.
>>
>> Skip the DISK_RO check in 10-dm.rules.
>>
>> Signed-off-by: Martin Wilck <mwilck@suse.com>
>> ---
>>  udev/10-dm.rules.in | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/udev/10-dm.rules.in b/udev/10-dm.rules.in
>> index 4ffd3e2..c08d829 100644
>> --- a/udev/10-dm.rules.in
>> +++ b/udev/10-dm.rules.in
>> @@ -50,9 +50,6 @@ ACTION!="add|change", GOTO="dm_end"
>>  # kernels >= 2.6.31 only. Cookie is not decoded for remove event.
>>  ENV{DM_COOKIE}=="?*", IMPORT{program}="(DM_EXEC)/dmsetup udevflags $env{DM_COOKIE}"
>>  
>> -# Rule out easy-to-detect inappropriate events first.
>> -ENV{DISK_RO}=="1", GOTO="dm_disable"
>> -
>>  # There is no cookie set nor any flags encoded in events not originating
>>  # in libdevmapper so we need to detect this and try to behave correctly.
>>  # For such spurious events, regenerate all flags from current udev database content
> 
> 
> Yes, I'd like to get rid of this rule, but, unfortunately, there's one
> issue during the DM device creation/activation.
> 
> For example, if I try:
> 
>   dmsetup create --readonly --table "0 1 zero"
> 
> Then I get these uevents:
> 
> 1)
> ACTION=add
> DM_UDEV_DISABLE_OTHER_RULES_FLAG=1
> DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG=1
> DM_UDEV_DISABLE_DISK_RULES_FLAG=1
> SYSTEMD_READY=0
> 
> 
> 2)
> ACTION=change
> DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG=1
> DM_UDEV_DISABLE_DISK_RULES_FLAG=1
> DM_UDEV_DISABLE_OTHER_RULES_FLAG=
> 
> 
> 3)
> ACTION=change
> DM_COOKIE=6335392
> DM_COOKIE_DISABLE_OTHER_RULES_FLAG=
> 
> 
> The uevent 3) coming with the DM_COOKIE is the actual event when the
> device is ready for use (that's the uevent notifying the DM device
> resume/activation).
> 
> If we remove the DISK_RO rule, then the DM_UDEV_DISABLE_OTHER_RULES_FLAG
> is unset for uevent 2), which in turn causes the SYSTEMD_READY=0 to get
> dropped, which in turn will start all the systemd hooks because the
> device is considered "ready" for systemd then.
> 
> But the DM dev is ready only after uevent 3) that comes with the
> DM_COOKIE. So we still need to cover this scenario.
> 

Hmm, this doesn't even work with original rules!

The 99-systemd.rules has:

SUBSYSTEM=="block", ACTION=="add",
ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", ENV{SYSTEMD_READY}="0"

which applies only to "add" uevent, not "change". This means that
SYSTEMD_READY="0" is even dropped for the DISK_RO="1" uevent even if it
is marked as DM_UDEV_DISABLE_OTHER_RULES_FLAG="1".

This is actually a bug. But a minor one, because here we always have the
change uevent with DM_COOKIE coming right after the DISK_RO change
uevent. So there's almost no window practically.

Now, I'm asking myself why we have the 'ACTION="add"' in the systemd
rule at all. Why is it not just checking  DM_UDEV_DISABLE_OTHER_RULES_FLAG?

-- 
Peter

