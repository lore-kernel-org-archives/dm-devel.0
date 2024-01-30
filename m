Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A3469974
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 18:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706640216; cv=none; b=cXtnu9z4Hg00p3SCm32WYKvBhJya7M9Qux30mbugtFfj1lBDm3R1wncqLq1KQ+UQoG2Vvl3USbWbymB4NOraQ1N3DS+bWPIfzRN9uPMRv1bXvFx964cqhPnwlIaApqMmLi3zBjjadjusy+knvtSYSsKO0FclnB3FX5XSsK1wack=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706640216; c=relaxed/simple;
	bh=mPMVm82hfxrP/Mw/5dDuXl4h0vDBeMIE5+mViVdnHeE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=SD7MmvcOh/iDq+V7ct6vo0asA1CPvdHwXh7H5rHOFTY1s6zXC0L6+nTXvJZil29qSxr162NW9o/qqH/MtG7cjHTtJ5/yoBRytm5rUuLRo8FSUazBzGz+tXkbuPKThNO0A8ks68T+Z0j1YCUgv2AfkATWa2jb76E52LtjR7z2xfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=T1AmcNHc; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="T1AmcNHc"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d73066880eso34145245ad.3
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 10:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1706640214; x=1707245014; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rymqZGEkjEoQdQRQ8bWXSgg9Qch8upBmuj3QTJxQTYs=;
        b=T1AmcNHcgtDaLd5Ofg45NHOL2GdOafXpHff1x8PQ5LFyh8cN4Fic2hPBesgwE+01kg
         +XvyCQhY9H1Okl3y5dZ/JT79h2VMK1ERdPebDcAUh4235fKnk8k+bUxVoFvT4gLryG9O
         gK5R1sfapszXGTYkJIHhDtEDw9FLSpJ6hT8AAXunk0cz5Ox6YuAhiZ8Zq40IqYpJ1B5T
         EOhZYajrXp2DA8amMIMF5OoRfovTIRl+5SZpEj4+fuDqHtRqKmfyFOdCoG8wErstGUy8
         DVtk/bc+uNsYNdyENWmK8UhjRxkh+Bsb7nFA8uKnlxuuHIxcDh2eOrcdAzYqIoQl+zdz
         eGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706640214; x=1707245014;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rymqZGEkjEoQdQRQ8bWXSgg9Qch8upBmuj3QTJxQTYs=;
        b=DO6Sr2ekgA1kL7h1/IXGNtqtza2HMMrsRIdeMMJaC05ncdRwBMMb5l/baa1vqO5aDp
         VVcRAPxdwFi73y0p2rVRGclxOAbrJTinmM4N7pbX73oZgb2quyQVgKK2V9Xx0iPeuVBQ
         +ocm5wYD58VLUmmreRsyqorcJ7W4i62YB7g448E7uIku8twcjnXiDi9ELLs4vW/78lxe
         em61DlFS+jf8A/BuRY7EtUtpPBLqHniBbIGdx/SKBhJyifj+UrhdnxfsKfZFh4R/BVgn
         uLpgEXj3ht031nRValQFrfVTycJE0az6R+KXCi93YUoRPjwgH2bIKGnC3FyC7RZIMFA0
         6+kA==
X-Gm-Message-State: AOJu0YykejJhP7Z4RfTdy/pB1wXKAzcLoKrz6Sv3SG6Y0ttZsugp/ZAM
	5dA6e3kXJvMKkx3G6pZ3ynjLwQRn0IcZ1sA72WPlf0OVFOxvx1ikJO7+e59EIok=
X-Google-Smtp-Source: AGHT+IGArHYVVke9sIgn10dyZS+F5v98DMr1fEOAmEVmkpt2Y22JZ9MUyC1DR7aGj2eQGvtwvsRyVw==
X-Received: by 2002:a17:903:120c:b0:1d4:1f71:8fcf with SMTP id l12-20020a170903120c00b001d41f718fcfmr9445647plh.59.1706640213826;
        Tue, 30 Jan 2024 10:43:33 -0800 (PST)
Received: from smtpclient.apple ([136.226.79.24])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902eb0600b001d8dbb867b1sm4318524plb.179.2024.01.30.10.43.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 10:43:33 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.400.31\))
Subject: Re: [PATCH] multipathd: the sysfs prioritizer can return stale data
From: Brian Bunker <brian@purestorage.com>
In-Reply-To: <4dd466445f477e1991267edf30b16364af021f53.camel@suse.com>
Date: Tue, 30 Jan 2024 10:43:21 -0800
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 dm-devel@lists.linux.dev,
 Seamus Connor <sconnor@purestorage.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <22BFA8ED-7AA4-41C4-9253-3B2846301BFF@purestorage.com>
References: <20240124020007.25259-1-brian@purestorage.com>
 <ZbkmuqWetsaOPMkC@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
 <4dd466445f477e1991267edf30b16364af021f53.camel@suse.com>
To: Martin Wilck <mwilck@suse.com>
X-Mailer: Apple Mail (2.3774.400.31)

>=20
> On Jan 30, 2024, at 9:57=E2=80=AFAM, Martin Wilck <mwilck@suse.com> =
wrote:
>=20
> On Tue, 2024-01-30 at 11:41 -0500, Benjamin Marzinski wrote:
>> On Tue, Jan 23, 2024 at 06:00:07PM -0800, Brian Bunker wrote:
>>> When a path is lost and then reinstated later, the ALUA
>>> device handler will not pick up this change and continue
>>> to possibly provide incorrect (stale) information about
>>> its ALUA state to the 'sysfs' prioritizer if the path's
>>> priorities were changed prior to the loss of those paths.
>>>=20
>>> On the loss of an I_T nexus, the path state should not
>>> continue to use its last known state. Many things and a lot
>>> of time could have passed between the path loss and its
>>> eventual reinstatemnt.
>>>=20
>>> The ALUA device handler didn't have this issue since it
>>> always got the ALUA state from the target by sending an RTPG
>>> request on the path and updated the priority. However with
>>> the detect priority set to true by default, the 'sysfs'
>>> prioritzier will be used on targets that support ALUA rather
>>> than the 'alua' prioritizer.
>>>=20
>>> Without re-evaluating the ALUA state when a path returns
>>> multipath is left with path states which do not reflect
>>> the actual ALUA states the target is providing.
>>>=20
>>> 3624a9370f0f545fc7c3e46a100011010 dm-2 PURE,FlashArray
>>> size=3D3.0T features=3D'0' hwhandler=3D'1 alua' wp=3Drw
>>>> -+- policy=3D'service-time 0' prio=3D50 status=3Dactive
>>>>> - 13:0:0:1 sdg 8:96  active ready running
>>>>> - 12:0:0:1 sdf 8:80  active ready running
>>>>> - 9:0:0:1  sdc 8:32  active ready running
>>>> `- 1:0:0:1  sdb 8:16  active ready running
>>> `-+- policy=3D'service-time 0' prio=3D10 status=3Denabled
>>>   |- 14:0:0:1 sdh 8:112 active ready running
>>>   |- 15:0:0:1 sdi 8:128 active ready running
>>>   |- 10:0:0:1 sdd 8:48  active ready running
>>>   `- 11:0:0:1 sde 8:64  active ready running
>>>=20
>>>  # sg_rtpg /dev/sdh (Active/Optimized)
>>> target port group asymmetric access state : 0x00
>>>=20
>>> Signed-off-by: Brian Bunker <brian@purestorage.com>
>>> Signed-off-by: Seamus Connor <sconnor@purestorage.com>
>>> ---
>>>  multipathd/main.c | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>=20
>>> diff --git a/multipathd/main.c b/multipathd/main.c
>>> index 230c9d10..dd48be74 100644
>>> --- a/multipathd/main.c
>>> +++ b/multipathd/main.c
>>> @@ -1937,6 +1937,11 @@ reinstate_path (struct path * pp)
>>>   else {
>>>   condlog(2, "%s: reinstated", pp->dev_t);
>>>   update_queue_mode_add_path(pp->mpp);
>>> + if (strcmp(pp->prio.name, PRIO_SYSFS) =3D=3D 0) {
>>> + condlog(2, "%s: rescan target to update
>>> priorities",
>>> + pp->dev_t);
>>> + rescan_path(pp->udev);
>>=20
>> I can see why this is necessary with the sysfs target, but AFAICT
>> rescanning the scsi device will end up calling scsi_execute_cmd to
>> update the vpd pages, and this can block.  Obviously, we are doing
>> this
>> after the checker has verified that the path is up, but even still,
>> we're trying to cut down on the amount of code that can block
>> multipathd
>> on an inaccessible device, instead of increase it.
>>=20
>> Perhaps it would be better to make the prioritizer itself smarter, so
>> that it could know when it needs to run the rescan(), and it could do
>> that in a separate thread.
>>=20
>> Thoughts?
>=20
> A full rescan shouldn't be necessary. All that's needed is that the
> kernel issue another RTPG. AFAICS that should happen as soon as the
> target responds to any command with a sense key of UNIT ATTENTION with
> ASC=3D0x2a and ascq=3D6 or 7 (ALUA state change, ALUA state transition
> failed).
>=20
> @Brian, does your storage unit not do this? If so, I suggest we =
disable
> the sysfs prioritizer for pure storage.
>=20
> Otherwise, as far as multipathd is concerned, when a path is
> reinstated, it should be sufficient to send any IO command to trigger
> an RTPG. Or am I missing something here?
>=20
> Martin

Martin,

What I am gaining with the rescan is exactly that. You are correct the =
ALUA device handler the kernel has to send an RTPG to the target.=20

We do set a unit attention to have the initiator paths go into the ANO =
state before we reboot leading to the path loss, but we do not set a =
unit attention when the paths come back up. We have relied on the =
initiator=E2=80=99s polling to pick up the ALUA state change which they =
always have in the past and the =E2=80=98alua=E2=80=99 prioritizer still =
will. For us to add a unit attention would work, but there are couple of =
issues with that.

1. Unit attentions may not get back to the initiator. It is not =
guaranteed.
2. Paths could take a very long time to come back. We might not get =
these paths back for a very long time. Sometimes it is just a reboot. =
Other times it is a hardware replacement. It is possible for us to keep =
this state forever and post when when that I_T nexus returns but we =
haven=E2=80=99t had to.

If we did post the unit attention, everything works as expected. I have =
verified this, but I would also hope that the polling of the checkers =
would also unstick my stale ALUA state and we won=E2=80=99t have to.

I put this rescan_path inline to show the problem and the fix. I =
wasn=E2=80=99t sure the =E2=80=98right=E2=80=99 place to put it. I get =
that it would be better not to block on this. It should be possible to =
put this in a thread so that it does not. The other caller of =
rescan_path I guess is also doing the same thing when it is handling the =
wwid change.

Thanks,
Brian

