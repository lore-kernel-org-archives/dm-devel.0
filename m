Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D0E1E487
	for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 12:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707741158; cv=none; b=mF0Cvhte2Gj0/WTPnJhqC9OdShmwyfTKXLO2qBzJ/zAGuc4X59fN2kZ5YsBtXRvipQNAISjxAMpm9TPVdUNLX/y4Ymthk04+rfXNc7BWWF2OXxOTjFZ+q4q+JLa8VE63GSDXEaugAJbyVvVGp2v72zau4Hfguiz8K5c5WreN7AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707741158; c=relaxed/simple;
	bh=SNec/Unv2/mSuNuUsHqWnqIKQ6oOpcQaR7tbyp+CNEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bIBX2L/TIQVWYb9BBzBptLooqsC9yI2CXwsJaF8SmkJneAjK5/FjyCt+o0qJwoRksdtG6Ara4AbXX65GPvEFMJImBSXLiz0QkZa9HhLFrV/aDtKf4R+nagdBaNHkC8JqLMSwx1yfXt3j31G2DW76u7Li/akIu/wkgu9gQJAB+Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jG2Zn1At; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jG2Zn1At"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707741155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dj9qcGn6Ze9IRASHES+crty/tGMIefCY/lGlqQhqS5w=;
	b=jG2Zn1At7BOQSLxEefTjMgMBJ7yPQuyGwY1Bn/EHClEAC+yFEPAkYQdpv6izRY0HyC8A8Q
	3Bjxta7d3+4dkS/qUh0v5ep0uMGKDq8AAC1WnWHrYvyJ6GMzGBzDsHd279f2VUBzUbNRTE
	B3oielF2UIoipm/lszkqtc1bNv0cmTs=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-FyBCt6DePRCM-JNgNi3xsA-1; Mon, 12 Feb 2024 07:32:33 -0500
X-MC-Unique: FyBCt6DePRCM-JNgNi3xsA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-511494630d8so2975561e87.0
        for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 04:32:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707741152; x=1708345952;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dj9qcGn6Ze9IRASHES+crty/tGMIefCY/lGlqQhqS5w=;
        b=pNv1ynYKncCPzVZ4QvuSAJrSSpjwY+5d2/Mduw3V3a16Sa9xlBgnOsfe4dVvvYmYkl
         nsKUOds67gTy/dtzh1eLMYgV/X3/eFlt1bwPnWmIe8XwpRb8k/ouimFOzcgzhnBW9vVE
         OiWk2gyNgaeaMFD8MYukzRTCRhQDGzcj+w/TOUBEYAdGHBJYKBqogeHtx3q+oUYP12iI
         flkjTmWaukeFTQPUcLvnBhlXVrqQTra52aGR6pLo9mphP1oPfXFBLwtlc9i1UM0jY4Db
         C9chPJxkMkTu3gWBLG6o2JbhgvbR1P78dbvgb2uazKAzqjzZhQZ8kpIJH0e+YvLnwTEE
         72yg==
X-Forwarded-Encrypted: i=1; AJvYcCUBmOJhaLPuPLlLNA25Wnm1Cb+/KDMqGAd8eqt/SZlKTZEi+s0SQStRK2VgrSxp7KBc5kEZbh3wW/cZMjkXbKU0ZjQj2vrJS0c=
X-Gm-Message-State: AOJu0YyR3p/UOjFr5HiWtCSvOYdkcQgIBJTcIt+j33PCus7lYax7ifLE
	sSA4YPKfGlQp41W3LgjaRP4iy/DUEpkr5BLhmWQh7IgZQH4xTQ2xuNlOl1zfyUOvIn/bohSYU3e
	A4+bhwlwTFVwG/lZOr5lJRoZH/M95GndL7EuNnMEOyk0qPwyxFHxsQt/8
X-Received: by 2002:a05:6512:3117:b0:511:729b:4a7b with SMTP id n23-20020a056512311700b00511729b4a7bmr4445318lfb.23.1707741152324;
        Mon, 12 Feb 2024 04:32:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGB9smW/pGojlyP2h3Qr8o8hAtufWPhnjPk+Ia71D6EdJOvdz0wK/nh7eKh9K5z0pzi+ql+3A==
X-Received: by 2002:a05:6512:3117:b0:511:729b:4a7b with SMTP id n23-20020a056512311700b00511729b4a7bmr4445299lfb.23.1707741151866;
        Mon, 12 Feb 2024 04:32:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUqzcCDfdioaFmddNqyVVUBRB+SkuUtFjPcWZiMDLZRgwK4bwVNFpW5k0Z7AoQLjSJkKY3aUzAjwEzg1rGqEbC5XiAMtJx4rDXjHhDZubx93oMNtkJjm+sBM4fdz1FjqEGGtzmwp/fhi3tkYXEaIuBbXc3uJyxDoSD/W+9JpWthKa8t38QwUYLTuOCSOnynwE01O9XNNVnqqyYKdnm2
Received: from [10.43.17.17] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t18-20020a05600c199200b0040fc26183e8sm8618500wmq.8.2024.02.12.04.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 04:32:31 -0800 (PST)
Message-ID: <f3e3db2b-8077-48b6-b507-4a9c4793affb@redhat.com>
Date: Mon, 12 Feb 2024 13:32:30 +0100
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
 <4a9e62ec-f93a-4739-a406-2c6d2138258a@redhat.com>
 <9b1475e2fa5982dd508d58975b8e6eb58cad95e2.camel@suse.com>
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
In-Reply-To: <9b1475e2fa5982dd508d58975b8e6eb58cad95e2.camel@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/12/24 12:09, Martin Wilck wrote:
> On Mon, 2024-02-12 at 10:51 +0100, Peter Rajnoha wrote:
>> On 2/9/24 22:58, Martin Wilck wrote:
>>> Hi Zdenek, Peter, David, Ben,
>>>
>>> I have been pondering the device-mapper udev rules a lot lately,
>>> and I
>>> believe I have found glitches in the logic of the device mapper
>>> udev
>>> flags that I'd like to bring to your attention.
>>>
>>> TL;DR: change I propose:
>>>
>>> * use DM_DISABLE_OTHER_RULES_FLAG consistently as a flag meaning
>>>   "upper layers should leave this device alone until told
>>> otherwise",
>>> saved between uevents in the udev db
>>> * use DM_SUSPENDED consistently as a flag meaning "upper layers
>>>   should keep their hands off this device temporarily", not saved
>>>   in the udev db.
>>> * don't use any other flags in upper layers, including 13-dm-
>>> disk.rules.
>>>
>>> This implies:
>>>
>>> * stop setting DM_DISABLE_OTHER_RULES_FLAG from DM_SUSPENDED
>>>   in 10-dm.rules
>>> * check DM_DISABLE_OTHER_RULES_FLAG instead of DM_NOSCAN in
>>>   13-dm-disk.rules
>>> * check DM_SUSPENDED in 69-dm-lvm.rules, 80-udisks2.rules
>>> * stop using DM_NOSCAN in 11-dm-mpath.rules and 66-kpartx.rules
>>
>> Hi Martin!
>>
>> It is surely possible we could do some improvements and optimizations
>> here - all the rules are a result of long evolution where we were
>> fixing
>> various issues on the way. So if we could shoot down some
>> complexities,
>> that would be great...
>>
>> On the other hand, we need to be really careful, because even a tiny
>> change here can cause troubles if we omit some case.
>>
>> I'll surely go through your suggestions, thanks for diving deep into
>> that! Just please give me some time so I'll remap all the paths
>> through
>> the rules in my head :)
>>
>> Note that we're working with 3 levels of logical rule separation
>> here:
>>
>>   1) DM base (10-dm.rules, 13-dm-disk.rules, 95-dm-notify.rules)
>>   2) DM subsystem (11-dm-lvm.rules, the mpath rules, ...)
>>   3) all the "other"
>>
>> As for the very original intentions of the
>> DM_UDEV_DISABLE_OTHER_RULES_FLAG - this one was supposed to be the
>> *only
>> one* to check for in "other" rules so they don't need to bother about
>> checking other states/variables ("other" here means other than DM and
>> any DM subsystem). One simple variable to check for others - an ideal
>> -
>> otherwise, we would be having a hard time to persuade others why they
>> need to add complex checks in their rules/applications.
> 
> Yes, I understand that, and it makes a lot of sense. 
> 
> The problem arises by saving and restoring to/from the udev db. We've
> got different possible *reasons* (inputs) for a device becoming
> unusable. The value we communicate to upper layers should arguably be a
> "logical or" of all these. But then we can't use a single variable to
> save and restore the state; we must determine the value of all "reason"
> flags (either directly or by restoring from the db, as appropriate for
> the flag in question) and "or"-them into a single "dontuse" flag.
> 
> Example: Currently, we set DM_UDEV_DISABLE_OTHER_RULES_FLAG if
> DM_SUSPENDED is set. If the next spurious uevent arrives, we see
> DM_UDEV_DISABLE_OTHER_RULES_FLAG set, but we don't know if the origin
> was DM_SUSPENDED or a genuine udevflag. In the former case, the device
> would now be usable, while in the latter case it most probably
> wouldn't. For now, I've posted a patch to fix this for the multipath
> rules [1], but I'd like to see it fixed in the general DM rules.
> 

Right, underneath within DM/DM-subystem, we should be able to keep and
restore those reasons for why it has been flagged with
DM_UDEV_DISABLE_OTHER_RULES_FLAG till now and when the state is good
enough that we can drop it, we would do it transparently for higher
(non-dm and non-dm-subsystem) layers. So if there's a case that is not
currently handled by 10-dm.rules or 11-dm-<subsystem>.rules, we can fix
that there. If it's a generic rule that applies to all DM, not just
subystem, then yes, we can move that to 10-dm.rules (will have a look at
your patch [1]).

>> Yes, there's the unlucky exception in the 99-systemd.rules which
>> needs
>> to check the DM_SUSPENDED to import the "SYSTEMD_READY" from udev db,
>> otherwise we had been running into an issue with stopping systemd
>> device
>> units prematurely (actually, this was an issue spotted much much
>> later
>> on after years of using the rules without this rule). 
>> And we haven't
>> found a better way to check for this condition. This is mainly
>> because
>> systemd is also a "device" manager/tracker in some way through its
>> "device" units, besides udev itself. I simply gave up there and
>> admitted
>> the check for DM_SUSPENDED case.
> 
> Well, IIUC the main reason that systemd couldn't use
> DM_UDEV_DISABLE_OTHER_RULES_FLAG was at least in part due to the fact
> that the multipath rules used it in a special way that was inconsistent
> with the rest of DM ;-)


Aha! Well, honestly, I don't remember the exact details and context of
that fix, but I know we haven't found a better way...

> 
> I think there are 3 variants of "unusable":
> 
> a) temporarily unusable (just for this event), ignore this uevent and
> restore previous properties from db.
> b) unusable, avoid IO, don't scan, don't activate (this is how we use
> DM_UDEV_DISABLE_OTHER_RULES_FLAG). Upper layers will usually load saved
> properties from udev db in this case, too.
> c) like b), but also try to unmount / unconfigure if already used. This
> is SYSTEMD_READY=0. I don't think DM has a flag with these semantics at
> this time. I can imagine such a flag being set if a device was reloaded
> with an incompatible table, but that's rather a corner case.
> 
> It's an honorable goal to condense everything into a single variable
> for consumer rules, but I think it doesn't work if we want the upper
> layers to be able to distinguish these. We can merge a) and b) I think,
> because their meaning for upper layers is practically the same, if we
> get the saving and restoring right.
> 

The c) case - well, it's questionable what should be done in that case,
because that means we have literally cut off the underlying device while
it was still in use. Any further IO from higher layers will return IO
errors, will queue IOs or, in the worse case, issue IOs to a device that
we don't want to anymore.

Anyway, if I understand correctly, we simply need to signal higher
layers either:

  A) device is unusable, forget it and clear all your current extra
records you have about this device (including removing any custom
symlinks for udev). That would also map to SYSTEMD_READY=0.

  B) device is unusable temporarily, restore any records you need, wait
for the DM_UDEV_DISABLE_OTHER_RULES_FLAG=1 to drop to 0 (or being unset).

What do you think about keeping a single
DM_UDEV_DISABLE_OTHER_RULES_FLAG for this, just having a different
value, say "2" to denote the B case? Otherwise, we need 2 distinct
variables (which is harder for others to accept I bet).

>> The DM_NOSCAN was actually just a helper and a more human readable
>> name
>> for "DM_SUSBYSTEM_UDEV_FLAG0" within LVM subsystem *only* at first.
>> It is used during LV initialization - the wiping/zeroing of the LV
>> before it is pronounced as usable - that's why, when it is set, we
>> signal to "others" the DM_UDEV_DISABLE_OTHER_RULES_FLAG based on this
>> flag. However, since we have the 13-dm-disk.rules which manages the
>> blkid call for DM devices (and which is ours - owned by DM), we need
>> to
>> signal these rules to avoid calling blkid (as it could see
>> uninitiliazed/stale data). In this case, we import any previous scan
>> results from udev db. It's not like "completely ignore and skip rules
>> for this event".
> 
> I'm not sure if I understand what you mean with "completely ignore and
> skip". Upper-level rules usually can't "completely ignore" an uevent if
> they need to preserve any udev properties across the current event. If
> the device is unusable in the weaker "don't try IO" sense, the upper
> rules must import existing properties from the db, just like 13-dm-
> disk.rules, lest the properties be forgotten by udev. IMO this weaker
> semantics (corresponding to b) above) is what matters most for upper
> level rules.

I didn't consider that there might be extra records to keep around for
anything else than blkid (13-dm-disk.rules) and DM/DM subsys (10-dm and
11-dm-subsystem.rules). But you're probably right here - differentiating
the A) and B) from above could be beneficial for some layers above. If
nothing else, then at least the systemd's SYSTEMD_READY case in
99-systemd.rules.

If we could still keep the single DM_UDEV_DISABLE_OTHER_RULES_FLAG for
others to check, I'd really like to have only that one, not adding more.

> 
>>  Other DM subsystems may get into exactly the same
>> situation with initialization as LVM, so that's why it ended up as
>> generic "DM_NOSCAN" so any 11-dm-<subsystem>.rules can use it to
>> signal
>> 13-dm-disk.rules to avoid the blkid scan this way (the "SCAN" here
>> actually means "blkid scan" so the better name would be
>> "DM_NO_BLKID_SCAN" probably). The "DM_NOSCAN" is not meant to be
>> consumed by "others" at all.
> 
> If blkid is likely to fail or retrieve stale data, other tools that
> read content from the device are likely to fail, too, and that's why
> they currently consume this variable. I agree that they shouldn't, but
> that works only if DM_UDEV_DISABLE_OTHER_RULES_FLAG has "don't do IO"
> semantics, as opposed to "completely ignore and skip".
> 
>> The other way round, we also don't want (ideally) to check for
>> DM_UDEV_DISABLE_OTHER_RULES flag in DM and DM subysystem rules. This
>> flag is meant for "others" to check. So we have a clear separation of
>> what is signalled withing "DM world" and "the other world".
>>
>> The DM_SUSPENDED flag - well, this was supposed to be just internal
>> to
>> DM and DM subystem rules. All the "others" have the
>> DM_UDEV_DISABLE_OTHER_RULES_FLAG - they simply don't need to bother
>> for
>> what exact reason the device is not usable, whether it is a suspended
>> case or whatever else...
> 
> I understand. I agree that non-dm rules shouldn't use DM_SUSPENDED and
> DM_NOSCAN. But this requires clean handling of save/restore, and that's
> what we currently don't do right, IMO.
> 
> Thanks,
> Martin
> 

-- 
Peter

