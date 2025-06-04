Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7893F21FF35
	for <dm-devel@lists.linux.dev>; Wed,  4 Jun 2025 09:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749028007; cv=none; b=o//MAZxHBmdCuDtPDmaL3GnKDrJ9y+WyRQqMIn0moBoi18yACO3sz6/lii7bR5L8nBahndg/LiebRM3BTuYzA7MlokIznKTPwIGx7E0YHKgQEK+AMxwCYqh1nsjT2A+/lAUziM6Br54XXXIH0M6xNTeub8+Xwu18giY4+pjCTQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749028007; c=relaxed/simple;
	bh=ZUz92YJcBaZoG4e0IX8CEpK+lU6Crf4YT2t7V0y8SBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OMuDY4/ifL54aXdc3DovUKUJXF/5/QtOEK5QBj1zc/hHffqsxG2Y7nUxulQBTBMZpAZ70fVQK9EesfpgobJLfKfKLJQQCYQeG7x4i5UXrDimg0Pg3nf9if54rU5Ba7gXaL6hM4ojmdPwRcmaSc+sOhdmwAN4KOu2WtAyBs+B4sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aJ+cbjOe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJ+cbjOe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749028003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kxiKFOwpTvjgJGpWUdcPWbUSPnBt7Yzas1mm+Gg9KLk=;
	b=aJ+cbjOeL+Df1bQu8eS0m8vMUQI8bsBW+sBAYpUMJC3BXSAjTnV3xXnS+fCkWOT+1t+92x
	t/AqJDKZRbc/cKSD0HABwG1c8xYxec66qMB3elj61Wdd4KnI3m3W702+XBHvMNxaJpVdlo
	SnsrWPONlGteJq9DIx433dFDw1tNh/4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-uYbxZ1HkMcqG_sWsBtp4DA-1; Wed, 04 Jun 2025 05:06:41 -0400
X-MC-Unique: uYbxZ1HkMcqG_sWsBtp4DA-1
X-Mimecast-MFC-AGG-ID: uYbxZ1HkMcqG_sWsBtp4DA_1749028001
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4f85f31d9so2051743f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 04 Jun 2025 02:06:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749028001; x=1749632801;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kxiKFOwpTvjgJGpWUdcPWbUSPnBt7Yzas1mm+Gg9KLk=;
        b=MUqMPK8ZXJEt4M1geg40ArVIR8ZXEJKGD/Fdv3MZ4W4t+9hZ/korCzXsLIB5c3wSr8
         XqM1teeXLp01xWL7LuSmZXUSN9FsiDPcixWEmLld/mS2R/4w7SA2E3Ej3APlABerysUU
         PN5IZgoVjIwKKQ04KetvMw2w4Lpd8/pJkWbTy4p/+6YuUV55T6vatJaZVxiz2HOEY0N4
         zxRYuq6YKI+euaGQ5wO9mfGBPnnFmKL8QzX9EKkhQyTE/7ht9ISA8ynbIkomb2tC/tH9
         pfSkBJQ3NBndm23wjcxEH4P6d1tb1JQge73MGSBbKLf2igpuvtVR3D5ULVMncUXYtrCs
         frGg==
X-Gm-Message-State: AOJu0YwlWDAulwsv9jgbYUb2NSiBJQupWbvDQRLr5s1tGGiRVm2oNvRk
	TQP0pueczLMKsNnNi+km2uUOiql3Z5Nz9BPg+A9eM3rzgNjbTGv3++2JYTDMhwl8rtLW0NLn3rY
	D6N1RbTT58H2qXznAh61ac3ejHNQuoLCWO3xszEJcRVqhOe5OIjzwkOJUTOMZ
X-Gm-Gg: ASbGncsU90az4g+OmYsUGu8jqa3EnKUwytu0Dxwjy1hmcMSWugG1LkhJ+8cgi684b3f
	4GfJxmc7AsEAK6qSeM1QjmYk3p1tGu03+uDYHGBrJMvUHjNEfVz8lojwSQk3fq4TZbzqxg3ITIw
	y9wMT1/gRuSZPGWMbrL14UGP6MEONoMOSuLBL+ugxfueik6lyHuIa3r3fhOHZ8P/ME6siyzhB4c
	DyfPeWRQ4TlzNQFP5WQe1qGN92yj3OBsEiXff7QLFaGcVKWOdpRBLGa0jqjspb/NWUrT2QFXUPj
	b83hJaFygF8=
X-Received: by 2002:a05:6000:2486:b0:3a4:f8fa:9116 with SMTP id ffacd0b85a97d-3a51d8f71b0mr1274007f8f.8.1749028000670;
        Wed, 04 Jun 2025 02:06:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtp2WNK0Z2hRLwL7VCIPD8d6l3gEAqQRadPM2xHE3KdfhDtETcpOLZetigs7OOHYsxSMiGag==
X-Received: by 2002:a05:6000:2486:b0:3a4:f8fa:9116 with SMTP id ffacd0b85a97d-3a51d8f71b0mr1273967f8f.8.1749028000105;
        Wed, 04 Jun 2025 02:06:40 -0700 (PDT)
Received: from [10.43.17.62] ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fc281csm199555775e9.40.2025.06.04.02.06.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 02:06:39 -0700 (PDT)
Message-ID: <aae34fa0-9b39-43a9-a784-352aa29ed02f@redhat.com>
Date: Wed, 4 Jun 2025 11:06:38 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [systemd-devel] [Discussion][device-mapper] Enabling Block Device
 Access Locking in systemd
To: Chengen Du <chengen.du@canonical.com>,
 Lennart Poettering <lennart@poettering.net>
Cc: dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
 christophe.varoqui@opensvc.com, systemd-devel@lists.freedesktop.org
References: <CAPza5qfw-ExyCFnWa5JoUE7eUsk_es8yx=H0YDFcY-=J8OtHpQ@mail.gmail.com>
 <aCNYxyaGNBuKTqX3@gardel-login>
 <CAPza5qdAogcH8T9aFPCXs+=gSVAY48Z4TUGxz1Pm0ZENRZjVcA@mail.gmail.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: RedHat
In-Reply-To: <CAPza5qdAogcH8T9aFPCXs+=gSVAY48Z4TUGxz1Pm0ZENRZjVcA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Acb_hydDFS14UzCzYTHtU75JqWbCo4q8vpMNrEqy7lI_1749028001
X-Mimecast-Originator: redhat.com
Content-Language: en-US, cs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 04. 06. 25 v 5:33 Chengen Du napsal(a):
> Hi DM developers,
> 
> On Tue, May 13, 2025 at 10:35 PM Lennart Poettering
> <lennart@poettering.net> wrote:
>>
>> On Di, 13.05.25 16:08, Chengen Du (chengen.du@canonical.com) wrote:
>>
>>> Hi,
>>>
>>> Apologies for including everyone in this message, but I’d like to bring
>>> your attention to a fix [1], which may require your input.
>>
>> As mentioned in my comments there: we can certainly enable the locking
>> stuff again for DM block devices too, but only if DM maintainers sign
>> off that this is OK. Hence ping the DM people about this, otherwise we
>> won't move on this.
>>
>>> To mitigate such issues, systemd-udevd normally acquires a LOCK_SH|LOCK_NB
>>> using flock on the main block device before processing.
>>> However, commit #e918a1b5a94f (udev: exclude device-mapper from block
>>> device ownership event locking) disabled this behavior for device-mapper
>>> devices, which appears to be the root cause of the boot hang with encrypted
>>> swap.
>>
>> iirc dm for some reason is allergic to us taking a bsd lock, because
>> they don't want us to hold an fd open while the udev rules run
>> (because bsd locking implies holding an fd open as long as the lock is
>> kept).
>>
>> But only the DM people can shed some light on this. if they are fine
>> these days if we relax this then we can certainly cover their stuff
>> via the locking, too.
> 
> Apologies for reaching out again, but may I kindly ask for your input
> on this issue?
> Your assistance would be greatly appreciated to help move things forward.


Hi

We have overlooked the issue which seems to have origins most likely in the 
lost uevents due to switch from initramfs to rootfs and should be possibly 
addressed by a new socket flag.

But anyway let's looks at the current locking mechanism.

So for lvm2 to be able to 'deactivate' DM device - such device must NOT be 
opened - so taking a lock on an open descriptor to deactivate DM device is 
likely not going to work.

lvm2 however could be possibly enhanced to at least grab these bsd locks maybe 
when processing PV - that does not looks like a problematic part.

But adding bsd locks when processing DM  (active LVs) looks like not so 
trivial task - there are DM devices which are  'private' to DM stack itself 
(i.e.   cached raid LV  - for a single  public  DM device - there might be 
tens of 'private' DM devices associated in a device tree - and for none of 
these devices lvm2 expects anyone using them - so any 'device stack tree' 
manipulation basically aborts when an unexpected user is there  (public 
availability of these 'private' devices is however useful thing for various 
'recovery/debugging' reasons - so there is very good reason all devices are 
present in users's /dev/ directory - but administrator should not blindly open 
them)

For protection against udev access to these private devices - were have 
originally used some uevent flags - those however were not 'permanent' as if 
udev was restarted with the clear database - all this info was lost  (like one 
of the reason we asked in the past for this DM exception).  Later on we added 
UUID -suffix solution - but this is not yet 'decorating' all device types - 
and although we now try to add them - it's not a simple task - so likely some 
nearby future version of lvm2 could be better - and in such a case - if this 
newer  version of lvm2 would be in the system - and there would be no access 
to any device with UUID '-suffix' from udev tools chain - we can possibly 
reconsider this DM exception and see whether we can make it work somehow.

Yet - for locking itself - I'd probably see some usage of separate locking dir 
in /run  as more usable approach - as the case where device needs to be 
'removed/instantiated/....' cannot be 'lock protected' if the device itself 
must be held open.

But as a short term solution - we would rather need to see the actual exact 
problem which seems to be missing this locking - as is could be possibly 
something unrelated to this locking...


Regards

Zdenek

