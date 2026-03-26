Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EC338736E
	for <dm-devel@lists.linux.dev>; Thu, 26 Mar 2026 10:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774520283; cv=none; b=jrrCBDKVIQjEVFE+oinhCYdIs19hi8ZsjElBuGXYWDWvjVxRMYZ4CW9npxnG3js1DAd2HG7BT13Wh0aPvEDEuA/HmI9nhTnhuUTf3ztJwEcX6V2ZmY1Cuo1aqYtyspJfdfkX0NTtz3QzWGoAZrde1llcgZZwn2JQaGd3SbAAEyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774520283; c=relaxed/simple;
	bh=ODLSbBq3jG2GiZ6WeG7pvi+Ik3MjBd10Zn78pA6ONec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qyRi7+OMWCTHfwKn/ENsQfp4Q9jChfpk0GWFxJq4wvvTpbca4LDDcYDKcOoVM0W1VALFQoB8BnZ0CEVzj6ZaWkaRfadz29AsDXB2dN+SCeobUsyJDmsYlQdsLpA6c9kSVgou7WdLa404MP8MLiyvur/YxtIWz+ok/43btF7tNlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f4ybXWvm; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f4ybXWvm"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48702d51cd0so9394565e9.2
        for <dm-devel@lists.linux.dev>; Thu, 26 Mar 2026 03:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774520280; x=1775125080; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VAYW3jWafk2UzHDDSsl8jJCoKnsgoRuB9g+KcQ0+qII=;
        b=f4ybXWvm1WqdctA/P2jv4kU1ZjiZSXoPvQrOz/t+//S06/Vb587fNDCLV2OHSdTAXM
         LNU1LXwtdTTurhd6pvln7D1PiTcXKlTM2lWkWwAnqwoJytZEXbMtK5Aqlko2VWcSBFmK
         im2ht5OMyXrTHevLgaL+rf91kditGn22TwHGWvMLAqx0gaRGGXGLLdLRVt6Jc6GCsb7y
         CSq3R6Ex4yXCrWciwiOzv9sPBQttJoVRZ4z5xX7uguZAftMRLRxV4aNWZ59QWyXyaaIZ
         68xho74Wwpm4d2tyS2JCdzZqWW6jJBD2XQlTV3orCOfD43IItZcrwVJRQk0Erik7lmda
         6MFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774520280; x=1775125080;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VAYW3jWafk2UzHDDSsl8jJCoKnsgoRuB9g+KcQ0+qII=;
        b=Pdf0K5DO07ognLDXe1u/LJxUL7lVB4lll2AT9Skv9cohtOGAm7SlF1fDWrx+zdV1y4
         F16noa9D/3eBxgc6ATQHvmYhKP9lezJPuroK8NQRBWNSx2TMU41K1Q5Jv5k8bEnwLec+
         DB0TvuQFuLDHov2KaHxYS54ZtlVnwh6CzxG3aGiwAfV8KgMsTUL6FKTMqG/UFbHV7Y+Q
         qdSkk0g7gHuKwMZRvbpolg/Muv81e+tBjPP1rOqA1SjJ5A+f/8QfULwxL+Gn+98WFOPy
         6MPoBJmmOEK99PUu5cpRnRPV/KCQgB1UjUbXXuCLMXGshYKLQ4QgvAlUOZkSMew0kisd
         J4WA==
X-Forwarded-Encrypted: i=1; AJvYcCVWygS4cs8cikEWOGJ8oe9A/IaMGHxP/ZZ+KQbKsPz34R/AKs86d8ICZCPNrmdPAFSPNir0v30bMQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyTEcMkRL+lyOW34SqmDDCTJa+GbU77XqkfQZPIGMQ9vvvyLdaw
	O4B3xF2iyzIfr6nYUZmIDq5TuLh+sP+ka0csaXuYQ4rBBJNcDo0oSN5MGqxO1O3SP3M=
X-Gm-Gg: ATEYQzyJUQUGpK32d5f/a8v3++L3klU571q5uR4gb3B1SnM3cgrx84ikic6N+hww1TE
	w7a+fExsba4Z9gC7J8KMg6QxpDuuVWic0i6OfoeNiTMq517ukdTLEEJgmheIjjMO7+oC8Iof3mj
	BxG7UWn5/at5eNSqI3z8q2GbHVqREz3CCBMIgHf2ZZZPhU4qIFizP+viipN4KOjfiQBS4he8nIk
	FmecOs65zGs2/aGYWK1FvqBk0kYG9lX/waL1WDrjgrWbrUN5WB/ZzrEkLYPHli2+vGu7PRPwjYT
	Pt5nJB4kAHFsYst0W9Zf5qkEjy0yooBjtUstYsJFCDEEjlrrXZQ1cGQaDvtO+0mgN3mp4MEaOQe
	qWbGlyDc7SgcZoVMOi0xWJsHQ2xeAtlb2KkGvTsUs+phsqYfKOjk3GNO1KyCQUeCHp3oBB8TO5E
	gZ5vZ+RW7iX2R5OCE4aWdmJmp9YtYjIj0uZEmflG7T57COI3lX+tRNcg1o
X-Received: by 2002:a05:600c:8011:b0:485:2ce2:4c8a with SMTP id 5b1f17b1804b1-48715fbf607mr96680495e9.1.1774520280028;
        Thu, 26 Mar 2026 03:18:00 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722d38a5fsm19972075e9.12.2026.03.26.03.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2026 03:17:59 -0700 (PDT)
Message-ID: <554f791d-17c2-48ab-8014-1ef62ba5b85d@suse.com>
Date: Thu, 26 Mar 2026 11:17:58 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
To: Benjamin Marzinski <bmarzins@redhat.com>,
 John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
 <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
 <acGYbD6X55eA-ynl@redhat.com>
 <43ca92bc-af38-4833-841c-421997ed90fe@oracle.com>
 <acKYbwGlfgWKDxnF@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <acKYbwGlfgWKDxnF@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/24/26 14:58, Benjamin Marzinski wrote:
> On Tue, Mar 24, 2026 at 10:57:20AM +0000, John Garry wrote:
>> On 23/03/2026 19:45, Benjamin Marzinski wrote:
>>>>> I don't
>>>>> think the Native SCSI multipath code would need to actively interface
>>>>> with the device handler code to support IMPLICIT ALUA. IIUC, looking at
>>>>> sdev->access_state should be enough to pick the correct path.
>>>> We also have the functionality from alua_check_sense() to consider.
>>> But the multipath code won't call that directly. Right now, the scsi
>>> device handler will, at least for every scsi device except ones using
>>> the Native Multipath code. My point is that this would just work, except
>>> that the Native Multipath code goes out of its way to break it, by
>>> disabling device handlers, and I don't really see the point of disabling
>>> something that every other scsi device, multipathed or not, has enabled.
>>> It's not like leaving it enabled makes it any harder to move the
>>> implicit ALUA support from the device handler to the generic scsi code,
>>> if that's the goal, since the Native Multipath code doesn't care who is
>>> issuing those rtpgs and updating the state.
>>>
>>> I guess this is more of a question for Hannes. Is the goal to turn off
>>> automatic device handler attachment in general, and go back to making
>>> dm-multipath attach device handlers to the scsi devices it is using?
>>
>> I'm not answering for Hannes, but I don't think that is the goal.
>>
>>> If
>>> not, then I don't see any reason to have the Native Multipath code
>>> disable it.
>>
>> It was just disabled it as we now had another method in the scsi core code
>> to get ALUA info.
>>
>> My plan would be - based on this series - to not attach DH just when using
>> native SCSI multipath for a device.
>>
>>> If it allowed device handlers to get attached, these two
>>> developement efforts (native scsi multipath and refactoring the alua
>>> support) could go on in parallel.
>>>
>>> Or am I missing something here?
>>
>> It just seems to be about this DH stuff is that there is bad history there
>> and no more users are wanted.
> 
> Just to be clear, if the idea was that the Native Multipath code
> shouldn't use include/scsi/scsi_dh.h, I completely agree with that. But
> I don't see why it can't make use of the results of the existing
> implicit ALUA support, since IIUC it doesn't need the scsi_dh interface
> to do that. That shouldn't interfere with any refactoring that people
> want to do of how the scsi layer actually handles ALUA support. Again,
> this is more for Hannes than you, John.
> 
Oh, it's not that it technically cannot use it.
It's just a design thingie: my idea for the native SCSI multipathing
is that it should be _simple_. There really is not point (and, in fact,
was one of the main motivators of this idea) to re-implement every nook
and crannie from dm-multipathing.
SCSI multipathing should only handle implicit ALUA, and leave every
other functionality to dm-multipathing.

And on the other side, I always found it completely irritating that
one had to enable multipathing in order to get ALUA support (ie
being able to figure out the ALUA state). The ALUA state is a property
of the LUN, and the system has to react on that one. It really doesn't
matter whether the system has multipathing enabled; if the LUN is in
ALUA Standby state we cannot send I/O, full stop.

And that's what we're trying to achieve here; move implicit alua support
from SCSI DH into the SCSI core, and leave SCSI DH to handle explicit
ALUA support.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
