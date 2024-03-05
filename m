Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C186F6025A
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 08:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709626147; cv=none; b=hyN2+oyrmCfiMdJFRHKzNQMTFucEOGyHDg+dixAf5YaRG/Xm0PCJTPWtLY6JoGOiWICV+5eSqCRY2RRyG00vPW5Yt0vTpYfQcQ8CPdU1YegMNJkAXwnkvT1bnZaX1ggQI2cpwoHdFGyXKc71s+DasYF5hF1/1znKKCKvipt/MwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709626147; c=relaxed/simple;
	bh=QalZe5onIdTUXomDbTm8PZ7zhYJHP7+tOWgHbk9yTJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e45TC7OOnk9wE+XqVtE/vytb4BgvDvGZL1byIRfE+1R+vewyvbncm4ySUpDcSEusVMbTHXoSrAUgKq5k2nqj4aPTDxLenUQ7LXlrVbH3rNZfROYjzQJ3VN5ZJEIvMEzIl0RLztuoBs0dcYIqN4GHBgIgr7vOM72GYckzmHma/Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HqILTfF9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HqILTfF9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709626144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=20eC+L1veBMZB9eTgC7k6yzvOieUX+/Euc9ArRQoBvM=;
	b=HqILTfF9Y9+3qyvpGq6tOAaqXVu879/5nNvNEtG03n35S5zT5hBrLhxLVgTLNez9vTpgij
	F+KWqeA9bqUozw2YTmXcr/+X97ffsKc7Zh2YzR8bvfEACv0eBmGkZ5lR6ZfWDtHsesJtqM
	B6fne8lovdCf0YtZ/NyZb67A3teJHK8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-HS7GwaE2MUa613C5WRPW_w-1; Tue, 05 Mar 2024 03:09:03 -0500
X-MC-Unique: HS7GwaE2MUa613C5WRPW_w-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-412dbc77740so16853885e9.2
        for <dm-devel@lists.linux.dev>; Tue, 05 Mar 2024 00:09:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709626142; x=1710230942;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=20eC+L1veBMZB9eTgC7k6yzvOieUX+/Euc9ArRQoBvM=;
        b=EOHdWw7dDNvuNZ3hdgwbiuPMcJDrc25KOgSdzqzUDEMt6eNC6IJwKba6HpwNYA2aDF
         vb+v9D/Mn2U6d7LqIIHtgW/EjNJsjy/JOBF1YTs/MOuaqVYWN4NEcq7Nvc1GRE7FS9y6
         QlgR0P8dyaS+whmE60Ty3G9PRp1qsy9LcR2tzF5Cs4Y3pJtHjQLJFhXpbeqjzgI01lKe
         4/HhjIT+ScW3aBX19nujrTVMpLTF4g8SaYP2xucq6xoTQBxGrqgrohpdzjPxE2SO/I+g
         AkQqTYN4J5U7woDg5PH99LTyNconxvGZW/p99IC5OyRLVoGjewQvaFIFFVHtY0bZX7VH
         xonw==
X-Forwarded-Encrypted: i=1; AJvYcCWtFpNTaok331Kn3IhKj3XybRneMpMepEpn37USa8YBy5cQCTZ18SdcDguXVgvdai4gO83vLQAvodiHXbWvHGStUKQvPeSDg5c=
X-Gm-Message-State: AOJu0Yy1+H6lQBL3AE1Sg78HwcvtVTm+HE5HfNJSUvrrGUs3SEcvs5kz
	FSctjzCKQkjuLhTz+a5afzsmm5tCHFK9qecUKJq3Jhk+uj8qhWU7lQbUvYeuuSafylJiTmWLN0v
	nk3PI5BYhJ4eFmvYc5Oz9vyN8SawmiOkDJoip1NZkSxoLmSqU6tPp+ne0
X-Received: by 2002:a05:600c:1f18:b0:412:dda9:102a with SMTP id bd24-20020a05600c1f1800b00412dda9102amr5294077wmb.21.1709626142246;
        Tue, 05 Mar 2024 00:09:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEseAMcfTRsVuqMTQ/TiEO4FU1u9Sreklk4NSTEbSdYE2ZkUzsf24vlOzBd4b00YaB62bwYyw==
X-Received: by 2002:a05:600c:1f18:b0:412:dda9:102a with SMTP id bd24-20020a05600c1f1800b00412dda9102amr5294059wmb.21.1709626141802;
        Tue, 05 Mar 2024 00:09:01 -0800 (PST)
Received: from [10.43.17.192] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id jl24-20020a05600c6a9800b004126732390asm19904357wmb.37.2024.03.05.00.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 00:09:01 -0800 (PST)
Message-ID: <ea76e097-2ced-4052-9ba5-eb9dac9f412b@redhat.com>
Date: Tue, 5 Mar 2024 09:09:00 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/7] 10-dm.rules: don't deactivate devices for
 DISK_RO=1
To: Martin Wilck <mwilck@suse.com>, Zdenek Kabelac <zkabelac@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev,
 Hannes Reinecke <hare@suse.de>
References: <20240301224011.11117-1-mwilck@suse.com>
 <20240301224011.11117-3-mwilck@suse.com>
 <b884374b-2f6f-4c7f-acba-b4c730ae03ff@redhat.com>
 <044ce4d6dad7873de1104568e5bd86361997d073.camel@suse.com>
From: Peter Rajnoha <prajnoha@redhat.com>
Autocrypt: addr=prajnoha@redhat.com; keydata=
 xjMEY7QY9hYJKwYBBAHaRw8BAQdADIHZn5yeZYFV18ewwf4iudpl1ARfj4rnxX5xiSoJ15vN
 I1BldGVyIFJham5vaGEgPHByYWpub2hhQHJlZGhhdC5jb20+wpYEExYKAD4CGwMFCwkIBwIC
 IgIGFQoJCAsCBBYCAwECHgcCF4AWIQQhe3cZL8e9dSzFIwXndmZANt+EqwUCY7QZ9wIZAQAK
 CRDndmZANt+EqzosAQDXhWudIjLSGoWGPKgluEWw5B5LtAX+kW2OG7loCDzI2AD/fp3Xec8K
 JY7HrSqO98YMPbT98+YRjiopJSk75TcAogzOOARjtBj2EgorBgEEAZdVAQUBAQdALfG8fuls
 uqLPtrJ5tYb36UtqNlu6Bw9ME/Ou+FRGG1cDAQgHwngEGBYKACAWIQQhe3cZL8e9dSzFIwXn
 dmZANt+EqwUCY7QY9gIbDAAKCRDndmZANt+Eq22lAQDXlKMGQxkD0FZes94uihIZlhFwGjrX
 dVfZsxfwEvuJfAD/XLGDegnKVERbF6YTfdsbVngSlOX/Tu/fxAFTg0JfdQU=
In-Reply-To: <044ce4d6dad7873de1104568e5bd86361997d073.camel@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/4/24 17:09, Martin Wilck wrote:
> On Mon, 2024-03-04 at 11:48 +0100, Peter Rajnoha wrote:
>>
>> Yes, I'd like to get rid of this rule, but, unfortunately, there's
>> one
>> issue during the DM device creation/activation.
>>
>> For example, if I try:
>>
>>   dmsetup create --readonly --table "0 1 zero"
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
>> If we remove the DISK_RO rule, then the
>> DM_UDEV_DISABLE_OTHER_RULES_FLAG
>> is unset for uevent 2), which in turn causes the SYSTEMD_READY=0 to
>> get
>> dropped, which in turn will start all the systemd hooks because the
>> device is considered "ready" for systemd then.
>> But the DM dev is ready only after uevent 3) that comes with the
>> DM_COOKIE. So we still need to cover this scenario.
> 
> As event 2) doesn't have DM_COOKIE, I don't think we need to bother
> about it much. IMO we should treat it like a synthetic "change" event,
> which has almost no effect as far as dm is concerned.

Well, partly yes, but the important thing here is that the other rules
don not consider this as something they should react on. Here, it's like
the (genuine) "add" event for a DM device that has almost zero value to
others (we still need the table to get loaded and the device resumed for
it to be usable).

That's why the DISK_RO uevent was marked with DUDORF flag in the
original 10-dm.rules as anything before the activation mark is simply
considered spurious.

> Event 3) doesn't have DISK_RO=1 set. If any later rules are interested
> in the state of write protection, they need to check the "ro" sysfs
> attribute instead.

The unfortunate thing about the DISK_RO, unlike other events, is that it
is triggered *before* that DM activation (DM activation == table load +
resume). Also, frankly, I don't like this event at all - it's just
notifying about one of the many device attributes. A question then
arises: "Why don't we have uevents for changes in other attributes?",
but that's how it is for now and it's probably for a separate debate.

Till now, we've been marking that DISK_RO uevent as spurious completely.
But yes, we should have probably done that only in case it happens
before the activation, not if the device is already activated, if that's
the case too.

> 
> It would make some sense to be able tell later rules that they don't
> need to bother with a given uevent because (from device mapper PoV)
> nothing relevant has changed. I am not sure if we should use
> DM_UDEV_DISABLE_OTHER_RULES_FLAG=1 for this purpose. "Don't bother,
> nothing has changed" is not the same thing as "don't bother, you can't
> access this device right now", which to my understanding is the meaning
> of DM_UDEV_DISABLE_OTHER_RULES_FLAG=1.

Actually, depending on the perspective, the DISK_RO uevent happening
before the activation is that kind of "you can't access this device
right now" (because it has not been activated fully yet).

> 
> Actually we have DM_ACTIVATION=1 to tell other rules that they do need
> to take action. Later rules only need to rescan a DM device if
> DM_ACTIVATION=1; in all other cases they could just import properties
> from the db. Currently kpartx and lvm are the only rules that check
> DM_ACTIVATION.

Yes, indeed, good point, the DM_ACTIVATION=1 is a little helper so the
rules which need to react *only on the event where the DM device has
just been activated/reactivated* with a new table.

It is set in two cases, IIRC:

  - on genuine "change" event where a new DM table is activated (a
resume after table load)

  - on synthetic "add" event *after* the device has already been
activated before (to cover the coldplug/udevadm trigger --action=add)

If there's a case where other rules do care about reacting only on this
particular event, then they should check DM_ACTIVATION, yes. But is
there such a case for other (non-dm, non-dm-subysystem) rules?

For the DISK_RO, it's about whether it comes before or after the
activation, not whether the DISK_RO is set with the activation at the
same time (which is not, it's a separate event). For this case, we don't
have anything to check right now - we just simply "disable" all the
events coming before the activation.

-- 
Peter

