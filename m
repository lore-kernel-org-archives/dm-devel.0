Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB5E848D
	for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 09:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707731494; cv=none; b=L15xqwign9BH4OEGs+eFnnS3FYbilmytCJyYqDNiwuUq9SEL3hAw5b3RYTR0SZNdt/bBYj9dhsO7v0IDPDqFszu1LHGpLF9MOP3DiwdSnDgtMVBQ9eNGBjBkqC8fiR+aVse+ZzuCle9F3M/Z0vKQOq51PZYQv1c9QJGQzikoU+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707731494; c=relaxed/simple;
	bh=NKHbwiJzik4F3BTXzr8KIadlLZ8qJViw/CUMPNhEK58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eLct5N2TYGck0s7bct6y+ea59I+gDfyDjKm7SND1usufmwnjDZkzNKwvINTLa7nQagvnxspp1R/UBtJd519swKd8oU9/+9JWVQF53Tw4srFcomtNlre0iA7dOALl2XGL33bwzQTL/CqA1nzlxtsROtlOplBE3f6/EdEhemQjY7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KFxIceQK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KFxIceQK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707731491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7qM1WHiKppSJeluWSi2kIcYil9kLDIkdER54ou5zPJo=;
	b=KFxIceQK0Jxgu8nDV7v33cvPyZqdv5z4cXWnI8rXaBho3bWZWVQgHRxnEViQiikfUacjrg
	HYLywALIw7YRLKKGpZi/Cb8I+ZXGyMU11rE5IJlcr8oP/yQ7TDF4/TExw9sHoybnO3Q/0/
	7jlDpUiwkkmpi/hhH4jxycCbxBiO5LM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-39mCWgU-NIu-YwCd91zvlQ-1; Mon, 12 Feb 2024 04:51:30 -0500
X-MC-Unique: 39mCWgU-NIu-YwCd91zvlQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33b6e35044cso835618f8f.0
        for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 01:51:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707731489; x=1708336289;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7qM1WHiKppSJeluWSi2kIcYil9kLDIkdER54ou5zPJo=;
        b=j/epcCh+ZXTCJT3fWklvMrfKJrZ3gZypB10cv6pp0WILAY5xoPKzTOhwUnkeWRLPJW
         URbq/YJXuX4XHZY/jj+CKhvQX1V8gsKldBNLBKc1g8Ybr/EKPltSQdpp3IhbOdrJt7TO
         UkWZo4uFX7MUME06pGHzh1mvB1kM2pSikAF4xE/Ef0B11zpnMekD7NGzNW3n3TMmnB9j
         LdEGwoBnxgoq6qkGqA1CwH+660TzBxZRtuvBhdQc3QuvBaGZUT/bHEfCPgHcMhF2EWu8
         QSP+sGe4hGtzCFhiLPQARwIGoRj9ZqXVVIbQfANuOG9Ur1L6ZACyaDWJprjTR3h7Jq5N
         lQpg==
X-Forwarded-Encrypted: i=1; AJvYcCUQGt8gWXLTFsritdP62gowjmrgTDR0vtVPV5OOxunVmURfoHbfi6nqh3R2Z/0WGHrKjAHHcUlx/w54oa4/hYySZIm4rMimkLY=
X-Gm-Message-State: AOJu0Yzh6B+QQGRxjUqmBK7LMNg/XCzBY22JYyYhbktli5og3H31okXg
	1YIPjJmM1h0HV1zKP2A2MDCwXfJj+SkkpzAmmN6iG7s9Te+k24eaYB/nt7idoMew5TlSnNE6GCb
	3gmhwAXaTqXMucA0zpm8DmsPuc/HgHGXah07P92TFlN5PUZ52Qc2h6NtX
X-Received: by 2002:adf:fdc4:0:b0:33b:1aed:c084 with SMTP id i4-20020adffdc4000000b0033b1aedc084mr6116366wrs.22.1707731489102;
        Mon, 12 Feb 2024 01:51:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2L6Z4/zveDo+5UJ4+W6/RH3T0kb2/j0c2mMxR0Jh/g98xez5ZKbgeV2Lu0NUFmfu+eZ53tg==
X-Received: by 2002:adf:fdc4:0:b0:33b:1aed:c084 with SMTP id i4-20020adffdc4000000b0033b1aedc084mr6116352wrs.22.1707731488763;
        Mon, 12 Feb 2024 01:51:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU5B6svCjZAQM5FwwzCuIrRuiOohGB2kdV09SOErnxmsy8H//+GYHM7YdyvxyB5QafJROzaj1Y6rpVJ7YdEi1TjCaC3/edz7f+4ApLVKoj9Z0hev6LzoiX8i9OUT4xvruCHAHiPNClCisphjhl0MIpLDISGTVWu1ABOGuhK9rdkBOwvrmh11e/NshHnm+khoO0KSkbCV0zBuomohdbu
Received: from [10.43.17.17] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k8-20020a056000004800b0033b47cf3221sm6269363wrx.35.2024.02.12.01.51.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 01:51:28 -0800 (PST)
Message-ID: <4a9e62ec-f93a-4739-a406-2c6d2138258a@redhat.com>
Date: Mon, 12 Feb 2024 10:51:27 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: About DM_UDEV_DISABLE_OTHER_RULES_FLAG and DM_NOSCAN
To: Martin Wilck <martin.wilck@suse.com>, Zdenek Kabelac
 <zkabelac@redhat.com>, David Teigland <teigland@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev,
 Heming Zhao <heming.zhao@suse.com>
References: <61638dc821c08cd97f6ac53150c5b0120f732deb.camel@suse.com>
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
In-Reply-To: <61638dc821c08cd97f6ac53150c5b0120f732deb.camel@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/9/24 22:58, Martin Wilck wrote:
> Hi Zdenek, Peter, David, Ben,
> 
> I have been pondering the device-mapper udev rules a lot lately, and I
> believe I have found glitches in the logic of the device mapper udev
> flags that I'd like to bring to your attention.
> 
> TL;DR: change I propose:
> 
> * use DM_DISABLE_OTHER_RULES_FLAG consistently as a flag meaning
>   "upper layers should leave this device alone until told otherwise",
> saved between uevents in the udev db
> * use DM_SUSPENDED consistently as a flag meaning "upper layers
>   should keep their hands off this device temporarily", not saved
>   in the udev db.
> * don't use any other flags in upper layers, including 13-dm-
> disk.rules.
> 
> This implies:
> 
> * stop setting DM_DISABLE_OTHER_RULES_FLAG from DM_SUSPENDED
>   in 10-dm.rules
> * check DM_DISABLE_OTHER_RULES_FLAG instead of DM_NOSCAN in
>   13-dm-disk.rules
> * check DM_SUSPENDED in 69-dm-lvm.rules, 80-udisks2.rules
> * stop using DM_NOSCAN in 11-dm-mpath.rules and 66-kpartx.rules

Hi Martin!

It is surely possible we could do some improvements and optimizations
here - all the rules are a result of long evolution where we were fixing
various issues on the way. So if we could shoot down some complexities,
that would be great...

On the other hand, we need to be really careful, because even a tiny
change here can cause troubles if we omit some case.

I'll surely go through your suggestions, thanks for diving deep into
that! Just please give me some time so I'll remap all the paths through
the rules in my head :)

Note that we're working with 3 levels of logical rule separation here:

  1) DM base (10-dm.rules, 13-dm-disk.rules, 95-dm-notify.rules)
  2) DM subsystem (11-dm-lvm.rules, the mpath rules, ...)
  3) all the "other"

As for the very original intentions of the
DM_UDEV_DISABLE_OTHER_RULES_FLAG - this one was supposed to be the *only
one* to check for in "other" rules so they don't need to bother about
checking other states/variables ("other" here means other than DM and
any DM subsystem). One simple variable to check for others - an ideal -
otherwise, we would be having a hard time to persuade others why they
need to add complex checks in their rules/applications.

Yes, there's the unlucky exception in the 99-systemd.rules which needs
to check the DM_SUSPENDED to import the "SYSTEMD_READY" from udev db,
otherwise we had been running into an issue with stopping systemd device
units prematurely (actually, this was an issue spotted much much later
on after years of using the rules without this rule). And we haven't
found a better way to check for this condition. This is mainly because
systemd is also a "device" manager/tracker in some way through its
"device" units, besides udev itself. I simply gave up there and admitted
the check for DM_SUSPENDED case.

The DM_NOSCAN was actually just a helper and a more human readable name
for "DM_SUSBYSTEM_UDEV_FLAG0" within LVM subsystem *only* at first.
It is used during LV initialization - the wiping/zeroing of the LV
before it is pronounced as usable - that's why, when it is set, we
signal to "others" the DM_UDEV_DISABLE_OTHER_RULES_FLAG based on this
flag. However, since we have the 13-dm-disk.rules which manages the
blkid call for DM devices (and which is ours - owned by DM), we need to
signal these rules to avoid calling blkid (as it could see
uninitiliazed/stale data). In this case, we import any previous scan
results from udev db. It's not like "completely ignore and skip rules
for this event". Other DM subsystems may get into exactly the same
situation with initialization as LVM, so that's why it ended up as
generic "DM_NOSCAN" so any 11-dm-<subsystem>.rules can use it to signal
13-dm-disk.rules to avoid the blkid scan this way (the "SCAN" here
actually means "blkid scan" so the better name would be
"DM_NO_BLKID_SCAN" probably). The "DM_NOSCAN" is not meant to be
consumed by "others" at all.

The other way round, we also don't want (ideally) to check for
DM_UDEV_DISABLE_OTHER_RULES flag in DM and DM subysystem rules. This
flag is meant for "others" to check. So we have a clear separation of
what is signalled withing "DM world" and "the other world".

The DM_SUSPENDED flag - well, this was supposed to be just internal to
DM and DM subystem rules. All the "others" have the
DM_UDEV_DISABLE_OTHER_RULES_FLAG - they simply don't need to bother for
what exact reason the device is not usable, whether it is a suspended
case or whatever else...

The DM udev rules are designed in a way that all the DM_UDEV_DISABLE_*
can still be changed in DM/DM-subsystem rules based on further findings
and processing of the state. So the original flags from the DM_COOKIE is
just a starting point here.

-- 
Peter

