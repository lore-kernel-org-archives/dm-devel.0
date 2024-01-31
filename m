Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7DC3A8FD
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 22:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706739831; cv=none; b=QY4zL1cManoBsm2VewxqtOml345LQSo8zNVNhFE5jExN9dJMLSr7ROi6juyNQbGIyfYIzd8abz7CCGP993Wn9Qk5kSEDgpho0cG5TCy5Ui9HTeq45XPXd2MvS/SsjfZIoGZMgA19hyD4JJxcx5djZBRu/0BFYFBLuhcjOsWq+8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706739831; c=relaxed/simple;
	bh=wlk4tMkm/t9v2iLPAl/okhAdKSDMrlQM3KOLchvuG/g=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=DbPWwj1/jTd93WQpRgo99x3FchW8bSqSyfHkz0FK5YBtIgWjgyx39WMwPH4k5ybNDkA4V4ENjLnr2R2UHO2M/b4yaOzCkJk6PHhLMqKen/LpNey4socbiaAyRMTWcMG+Nt+41ntlO4Mjj0/LDZUzclkhim4EOGWPds/CnXp2a/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=FduRfii+; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="FduRfii+"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5dbcfa0eb5dso275018a12.3
        for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 14:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1706739829; x=1707344629; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9P09YXiyS5vordml/wYX11BZjdO4vKJB4Zsqr+JKCJU=;
        b=FduRfii+p+0jbUtGWP4/tXBom784JZyZuE979R5KDa4ITAoZKfOSYUN2zcpipL6Eij
         wXmdxTnVN2gbr6S5IGN9/V62XNlc0uBTWS21oF2FaNNtcnyJgmaeB53oYp/Mt6P8pm5B
         ubnfb2nyLgeldvKS6bmsStTBn0zZU90gECkzyqafvl3NQSepPl/fanYqz9QcNbMjhs8Q
         8zYc/KJ/k+ueIwatT4YWYc46NbqoqAlVg54qhpsg/H/Xvp8V5kS7sJn7HiXjlcpCRGTZ
         mk8mXmuWCzVzTi1xsYZRvZ0Gc7WnbQoPNFlbCdMUh6p6wTHu0rh/9o+QrWI46VzYDCVL
         yEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706739829; x=1707344629;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9P09YXiyS5vordml/wYX11BZjdO4vKJB4Zsqr+JKCJU=;
        b=MksAynJEZflT/ixsQLSE2bpnGXpzcFCDKiGBP1UZa76Ro+ZDyRdCB/w2W/PODBXR+r
         6xXpshZ6fTP+H36s5yta5VsHSiMDEll7A2Lf4U1qypHeKzLnK11LPugPb0FlpKKOZu4K
         nLlwwSjDUZaVU2k2NfSrGd51ge2xxxdk+A6r2g7P2edW8I4qyXYhGqycNY/ykGwt2xZ9
         2aEmgF3V/eDHkFnziflSgVzXCFB6PdmsvSg9QZRCgg0i3Q7VZolcBdPL0esXEREUr0Sz
         FKSI13nfICXfc5ip3WBIc9UKyiz6CTpyeLIlj5j0bOYuwDPQDJEG2M1XHyeeK6s2eN1x
         JR1w==
X-Gm-Message-State: AOJu0Yx6UAPCQsjfEZazy4ZMjD+xJ/BmI+edesIZiE09FQc8/teAplk3
	en/PFQgZdxAWF7sKEvte4Sas4dQ4G9z32MrYYhMoqMMJhQ+gaspuU0mmqu925o4=
X-Google-Smtp-Source: AGHT+IG9JTSRjAasSVCzU4YxNzM1ScmUmMgK/ZPM0nyofDfgWcGn62eDroizkxDY9tp08sv2Qb1Y8Q==
X-Received: by 2002:a05:6a20:2d06:b0:19e:365f:bd2b with SMTP id g6-20020a056a202d0600b0019e365fbd2bmr2984885pzl.25.1706739828730;
        Wed, 31 Jan 2024 14:23:48 -0800 (PST)
Received: from smtpclient.apple ([136.226.79.24])
        by smtp.gmail.com with ESMTPSA id r25-20020aa78b99000000b006dbda9a4e6bsm10400105pfd.44.2024.01.31.14.23.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 14:23:48 -0800 (PST)
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
In-Reply-To: <cae20ba154c77d7ba99f8eab0b47b93d76a9c953.camel@suse.com>
Date: Wed, 31 Jan 2024 14:23:36 -0800
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 dm-devel@lists.linux.dev,
 Seamus Connor <sconnor@purestorage.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8FC66028-0596-4C6F-B73D-4645767CD1C9@purestorage.com>
References: <20240124020007.25259-1-brian@purestorage.com>
 <ZbkmuqWetsaOPMkC@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
 <4dd466445f477e1991267edf30b16364af021f53.camel@suse.com>
 <22BFA8ED-7AA4-41C4-9253-3B2846301BFF@purestorage.com>
 <2f0e15e5672f3d9f665491b40cfdada4cd9c36c2.camel@suse.com>
 <9F411A14-251E-42B3-BF1B-7EAFE860B6CF@purestorage.com>
 <cae20ba154c77d7ba99f8eab0b47b93d76a9c953.camel@suse.com>
To: Martin Wilck <mwilck@suse.com>
X-Mailer: Apple Mail (2.3774.400.31)


> On Jan 31, 2024, at 12:12=E2=80=AFPM, Martin Wilck <mwilck@suse.com> =
wrote:
>=20
> Hi Brian,
>=20
> On Wed, 2024-01-31 at 09:45 -0800, Brian Bunker wrote:
>>=20
>>=20
>>> On Jan 31, 2024, at 2:19=E2=80=AFAM, Martin Wilck <mwilck@suse.com> =
wrote:
>>>=20
>>> Hi Brian,
>>>=20
>>> On Tue, 2024-01-30 at 10:43 -0800, Brian Bunker wrote:
>>>>>=20
>>>>> A full rescan shouldn't be necessary. All that's needed is that
>>>>> the
>>>>> kernel issue another RTPG. AFAICS that should happen as soon as
>>>>> the
>>>>> target responds to any command with a sense key of UNIT
>>>>> ATTENTION
>>>>> with
>>>>> ASC=3D0x2a and ascq=3D6 or 7 (ALUA state change, ALUA state
>>>>> transition
>>>>> failed).
>>>>>=20
>>>>> @Brian, does your storage unit not do this? If so, I suggest we
>>>>> disable
>>>>> the sysfs prioritizer for pure storage.
>>>>>=20
>>>>> Otherwise, as far as multipathd is concerned, when a path is
>>>>> reinstated, it should be sufficient to send any IO command to
>>>>> trigger
>>>>> an RTPG. Or am I missing something here?
>>>>>=20
>>>>> Martin
>>>>=20
>>>> Martin,
>>>>=20
>>>> What I am gaining with the rescan is exactly that. You are
>>>> correct
>>>> the ALUA device handler the kernel has to send an RTPG to the
>>>> target.
>>>>=20
>>>> We do set a unit attention to have the initiator paths go into
>>>> the
>>>> ANO state before we reboot leading to the path loss, but we do
>>>> not
>>>> set a unit attention when the paths come back up.
>>>>=20
>>>> We have relied on the initiator=E2=80=99s polling to pick up the =
ALUA
>>>> state
>>>> change which they always have in the past and the =E2=80=98alua=E2=80=
=99
>>>> prioritizer
>>>> still will. For us to add a unit attention would work, but there
>>>> are
>>>> couple of issues with that.
>>>>=20
>>>> 1. Unit attentions may not get back to the initiator. It is not
>>>> guaranteed.
>>>=20
>>> That's news for me. If that happens, wouldn't it mean that the
>>> initiator sees a timeout (no response) to some command, IOW that
>>> there's still something very wrong with this I_T nexus?
>> Probably. My point is just that any individual response could be lost
>> wherever and there is no burden on the target to ensure the initiator
>> got the unit attention.
>=20
> Right. In the specific case of the ALUA-related UAs that we've been
> discussing, the storage *might* implement a logic to repeat responding
> with UA until an RTPG is received. But that may have  unwanted side
> effects; I haven't thought it through.
>=20
>>>=20
>>>> 2. Paths could take a very long time to come back. We might not
>>>> get
>>>> these paths back for a very long time. Sometimes it is just a
>>>> reboot.
>>>> Other times it is a hardware replacement. It is possible for us
>>>> to
>>>> keep this state forever and post when when that I_T nexus returns
>>>> but
>>>> we haven=E2=80=99t had to.
>>>=20
>>> No offense, that sounds somewhat lazy ;-) Note that it's also kind
>>> of
>>> dangerous. You are hiding the state change from the initiator. If
>>> the
>>> Linux kernel decided to use the access_state device attribute for
>>> anything else but feeding the sysfs attribute, things might go
>>> badly
>>> wrong.
>> That is fair. We definitely could do better here. In general, that
>> unit
>> attention coming out of the preferred state didn=E2=80=99t buy us any =
speed.
>> Those non-preferred paths weren=E2=80=99t serving I/O so the first =
I/O that
>> would pick up the unit attention on those paths would be the path
>> checker. The same run of the path checker picked up the new ALUA
>> state. When going into the preferred state, there is read and write
>> I/O which means those unit attentions are picked up very quickly and
>> the ALUA state change is picked up in the kernel before the checker
>> runs again.
>>=20
>> Have you ever considered a checker of RTPG as opposed to TUR?
>> That would seeming solve a lot of this too since you would be getting
>> path state and priority in the same trip.
>=20
> Interesting idea. AFAICT, noone has thought about it so far. In the
> past I've invested some thought in tieing  checker and prioritizer =
more
> closely together. Unfortunately, the current multipathd architecture
> treats them as entirely separate, which makes it complicated to =
achieve
> This.
Yeah. It would be a re-do of the separation between checkers and
prioritizers and might leave you with a mess if you had to keep =
everything
functioning the same way wasn=E2=80=99t ALUA. I think it might make =
check_path
much cleaner though.
>>>=20
>>>> If we did post the unit attention, everything works as expected.
>>>> I
>>>> have verified this, but I would also hope that the polling of the
>>>> checkers would also unstick my stale ALUA state and we won=E2=80=99t =
have
>>>> to.
>>>>=20
>>>> I put this rescan_path inline to show the problem and the fix. I
>>>> wasn=E2=80=99t sure the =E2=80=98right=E2=80=99 place to put it. I =
get that it would be
>>>> better not to block on this. It should be possible to put this in
>>>> a
>>>> thread so that it does not. The other caller of rescan_path I
>>>> guess
>>>> is also doing the same thing when it is handling the wwid change.
>>>=20
>>> That's true and not optimal, but wwid changes are rare events and
>>> an
>>> error condition in its own right. Patches converting moving
>>> rescan_path() into a thread would receive sympathetic reviews :-)
>>> The big benefit of the sysfs prioritizer is that it never blocks,
>>> without needing pthreads complexity.
>>>=20
>>> Btw, I think you'd need to wait for the RTPG to finish after
>>> triggering
>>> the rescan, if you want to obtain the right priority (alua_rescan()
>>> ->
>>> alua_initialize() -> alua_check_vpd() will only queue an RTPG and
>>> not
>>> wait for the result).
>> For our purposes we didn=E2=80=99t really need to wait for the =
rescan. As
>> long as
>> it happened. The next time the checker ran it would pick it up. These
>> paths
>> returning for us are redundant paths. We want them back as soon as
>> possible
>> but we have other paths that can serve I/O while waiting for the HA
>> paths.
>>=20
>> I can create a patch in the sysfs prioritizer to do the rescan_path
>> in a thread
>> that the checker and priority run doesn=E2=80=99t wait on. Would that =
be well
>> received
>> or I am better served by either posting a unit attention or just
>> using detect_prio
>> set to no and leaving the =E2=80=99sysfs=E2=80=99 prioritizer alone?
>=20
> I am not sure. Like I said, the beauty of the sysfs prioritizer is =
that
> it doesn't do any IO. rescanning a device from this prioritizer
> basically voids this benefit. You might as well just use alua.
> As I said, we do it for RDAC as well.
>=20
> But if you want to invest more effort, feel free to submit patches ;-)
> You can do this any time on top of the hwtable change.
OK I will submit the hwtable change first since there is no controversy
there at all.

My change only affects the reinstate path so it is isn=E2=80=99t like
=E2=80=98alua=E2=80=99 where priority is evaluated with RTPG at each =
checker instance.
The rescan should be rare since I_T nexus loss shouldn=E2=80=99t be too =
common.
>=20
>>> Unfortunately, the kernel has no API for manually triggering an
>>> update
>>> of the access_state. I believe that would be useful elsewhere, too.
>>> We
>>> can consider adding it, but it won't help with current kernels.
>>>=20
>>> IMO the best option for your storage arrays would is to force using
>>> the
>>> alua prioritizer rather than the sysfs one. You are not alone,
>>> we're
>>> doing this for RDAC already (see check_rdac() call in
>>> detect_prio()).
>>> This can be configured in multipath.conf right now by setting
>>> "detect_prio no" and "prio alua", and we can make it the default
>>> for
>>> your storage with a trivial patch for hwtable.c.
>> This is what we are doing now in our recommended configuration. I
>> will
>> probably add a patch for our hw table entry soon. It is a bit strange
>> to
>> me still that detect_prio would mean replace the one that I am
>> explicitly
>> stating in the device section. To me detect_prio would be if I =
didn=E2=80=99t
>> provide one and wanted multipath to choose for me.
>=20
> True. The design of the "detect_prio" option is awkward and confusing.
> It happens all the time that people set "prio" and wonder why the
> setting isn't applied. Or worse, they think it is applied but it's =
not.
> I think the original idea was to use ALUA whenever supported, even if
> historically the hwtable contained something else for a given storage.
> It has been this way for a long time, I don't think we can change the
> semantics easily.
I saw Ben=E2=80=99s later comment explaining the history of how it =
became the
way it became.=20
>=20
> Regards
> Martin
Thanks,
Brian
>=20
>>>=20
>>> Regards
>>> Martin
>>>=20
>> Thanks,
>> Brian


