Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F79712DDAC
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 17:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706723122; cv=none; b=m20b8UP6iHeM9SCgf6W8rTncfsES7cgcuOe02mJwd8BGrBhbiseq0QEK4K+fPK/G33pBNX0PzDNGzhrYSCZhryDzUS57BtOrJisfVofjR7yxanTvoZEeDokImiBW0dHO67eobNR4fQx0HDxubhbC3eF6BWGIKuZWQRRghUapk9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706723122; c=relaxed/simple;
	bh=hsolWUk+FKajeJHlmG84xkEYTM3oTU4tthw0v2SWEOk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=MTzwDmZyZjWOC4STu1XKYIrA2qmELLThZhrQv6xoq3u8fJOV2i0wc/K6jAdmpQr7Os1MSC29w7FlxIOGdgOSXS789BaiN9SaCZ7QbVYV9YMxOiXS2aLgQa4rzRtRA9jEPhO0Or3B1nhFJ1R2r7NLygl/bGZPLkgxrscUqIIA93o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=CHegY9CF; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="CHegY9CF"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6e141ee9c14so952507a34.3
        for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 09:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1706723119; x=1707327919; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hsolWUk+FKajeJHlmG84xkEYTM3oTU4tthw0v2SWEOk=;
        b=CHegY9CFvlqBZ1iJjktbBnCIUUDDhcT99CbtpCrxFfQxzCR4Shjykf4X9P2cum0Oct
         JOqskA/DXbzF//7IZhGPl9AXgWZH4baOM0Ys2pg6qP27J1rbqhFhQJkQZB9MpZE6muLz
         1zxvWtJV6n9GexN+TZzc+mIgwrh5WyRXz9+ab3LvnoFqkTzODpwR8tfe6S8fGexgajde
         SD6AMhD9SH2z/P/xsckP7wlXMRjLfiLhAfHGCh2TRRkuRzAbHniyec/vVHTTP3eaqxUz
         P68MCMVvvI4clZxu0rf6Xh2ZVCQU2NOyN5IsMi3gDToTJOajar6wiPF97ZSNu/7XgDXy
         F/xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706723119; x=1707327919;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsolWUk+FKajeJHlmG84xkEYTM3oTU4tthw0v2SWEOk=;
        b=RZipEZNhbxuv+AbG3Jzzk65kW9tiAe5b1VkbXjw4JhAc7ezcFG1NhCGolVIuKH+hRh
         Mcx6UtP5x76Tq7iSvtmRlcAFxd4D6DV76R0j8wW5a2TyhR/I5pjjOvo12OPtyQt5OAjw
         A7mCd050+gWJKnx/IDeLoZOBcVZ6zZ7CS/FWMvQf3P/scGrltEE3EFm9mW4f+oBecX/W
         qCht/wRZ+9nd5JDPzh4r1LL5ucTLB9zH1mA5yCwMyn+FTIN2U/uA5NiE7rozxQ+MtjmN
         2ehO763ylsvtPGJoh6dLIZYD1uH8UJu3OXHnWMOmRs86cgtVvLTCwIwNmRg5fBKcXBhV
         TnoA==
X-Gm-Message-State: AOJu0YzJtKbc0KSHcrWhxByHY+2zhuA+5rzLbQRgsVieSNmuZdN+JDVn
	RcqU8Jsl/SEuuafldEu5KYYuB2lzHO/qThbaY7FwURbho8VYn+IzhG+VjX91Xsc=
X-Google-Smtp-Source: AGHT+IF9xCjNPqB0Z7pJUbP6ska8GQ8juj4ah1sOTNA/khPrB05z8jXf2OhSnw/YGTxPgMPnD2KOyg==
X-Received: by 2002:a05:6830:1516:b0:6e1:115b:fdb5 with SMTP id k22-20020a056830151600b006e1115bfdb5mr1873085otp.19.1706723118995;
        Wed, 31 Jan 2024 09:45:18 -0800 (PST)
Received: from smtpclient.apple ([136.226.79.24])
        by smtp.gmail.com with ESMTPSA id g6-20020a6544c6000000b005cda7a1d72dsm8139710pgs.74.2024.01.31.09.45.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 09:45:18 -0800 (PST)
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
In-Reply-To: <2f0e15e5672f3d9f665491b40cfdada4cd9c36c2.camel@suse.com>
Date: Wed, 31 Jan 2024 09:45:06 -0800
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 dm-devel@lists.linux.dev,
 Seamus Connor <sconnor@purestorage.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9F411A14-251E-42B3-BF1B-7EAFE860B6CF@purestorage.com>
References: <20240124020007.25259-1-brian@purestorage.com>
 <ZbkmuqWetsaOPMkC@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
 <4dd466445f477e1991267edf30b16364af021f53.camel@suse.com>
 <22BFA8ED-7AA4-41C4-9253-3B2846301BFF@purestorage.com>
 <2f0e15e5672f3d9f665491b40cfdada4cd9c36c2.camel@suse.com>
To: Martin Wilck <mwilck@suse.com>
X-Mailer: Apple Mail (2.3774.400.31)



> On Jan 31, 2024, at 2:19=E2=80=AFAM, Martin Wilck <mwilck@suse.com> =
wrote:
>=20
> Hi Brian,
>=20
> On Tue, 2024-01-30 at 10:43 -0800, Brian Bunker wrote:
>>>=20
>>> A full rescan shouldn't be necessary. All that's needed is that the
>>> kernel issue another RTPG. AFAICS that should happen as soon as the
>>> target responds to any command with a sense key of UNIT ATTENTION
>>> with
>>> ASC=3D0x2a and ascq=3D6 or 7 (ALUA state change, ALUA state =
transition
>>> failed).
>>>=20
>>> @Brian, does your storage unit not do this? If so, I suggest we
>>> disable
>>> the sysfs prioritizer for pure storage.
>>>=20
>>> Otherwise, as far as multipathd is concerned, when a path is
>>> reinstated, it should be sufficient to send any IO command to
>>> trigger
>>> an RTPG. Or am I missing something here?
>>>=20
>>> Martin
>>=20
>> Martin,
>>=20
>> What I am gaining with the rescan is exactly that. You are correct
>> the ALUA device handler the kernel has to send an RTPG to the target.
>>=20
>> We do set a unit attention to have the initiator paths go into the
>> ANO state before we reboot leading to the path loss, but we do not
>> set a unit attention when the paths come back up.
>>=20
>> We have relied on the initiator=E2=80=99s polling to pick up the ALUA =
state
>> change which they always have in the past and the =E2=80=98alua=E2=80=99=
 prioritizer
>> still will. For us to add a unit attention would work, but there are
>> couple of issues with that.
>>=20
>> 1. Unit attentions may not get back to the initiator. It is not
>> guaranteed.
>=20
> That's news for me. If that happens, wouldn't it mean that the
> initiator sees a timeout (no response) to some command, IOW that
> there's still something very wrong with this I_T nexus?
Probably. My point is just that any individual response could be lost
wherever and there is no burden on the target to ensure the initiator
got the unit attention.
>=20
>> 2. Paths could take a very long time to come back. We might not get
>> these paths back for a very long time. Sometimes it is just a reboot.
>> Other times it is a hardware replacement. It is possible for us to
>> keep this state forever and post when when that I_T nexus returns but
>> we haven=E2=80=99t had to.
>=20
> No offense, that sounds somewhat lazy ;-) Note that it's also kind of
> dangerous. You are hiding the state change from the initiator. If the
> Linux kernel decided to use the access_state device attribute for
> anything else but feeding the sysfs attribute, things might go badly
> wrong.
That is fair. We definitely could do better here. In general, that unit
attention coming out of the preferred state didn=E2=80=99t buy us any =
speed.
Those non-preferred paths weren=E2=80=99t serving I/O so the first I/O =
that
would pick up the unit attention on those paths would be the path
checker. The same run of the path checker picked up the new ALUA
state. When going into the preferred state, there is read and write
I/O which means those unit attentions are picked up very quickly and
the ALUA state change is picked up in the kernel before the checker
runs again.

Have you ever considered a checker of RTPG as opposed to TUR?
That would seeming solve a lot of this too since you would be getting
path state and priority in the same trip.
>=20
>> If we did post the unit attention, everything works as expected. I
>> have verified this, but I would also hope that the polling of the
>> checkers would also unstick my stale ALUA state and we won=E2=80=99t =
have to.
>>=20
>> I put this rescan_path inline to show the problem and the fix. I
>> wasn=E2=80=99t sure the =E2=80=98right=E2=80=99 place to put it. I =
get that it would be
>> better not to block on this. It should be possible to put this in a
>> thread so that it does not. The other caller of rescan_path I guess
>> is also doing the same thing when it is handling the wwid change.
>=20
> That's true and not optimal, but wwid changes are rare events and an
> error condition in its own right. Patches converting moving
> rescan_path() into a thread would receive sympathetic reviews :-)
> The big benefit of the sysfs prioritizer is that it never blocks,
> without needing pthreads complexity.
>=20
> Btw, I think you'd need to wait for the RTPG to finish after =
triggering
> the rescan, if you want to obtain the right priority (alua_rescan() ->
> alua_initialize() -> alua_check_vpd() will only queue an RTPG and not
> wait for the result).
For our purposes we didn=E2=80=99t really need to wait for the rescan. =
As long as
it happened. The next time the checker ran it would pick it up. These =
paths
returning for us are redundant paths. We want them back as soon as =
possible
but we have other paths that can serve I/O while waiting for the HA =
paths.

I can create a patch in the sysfs prioritizer to do the rescan_path in a =
thread
that the checker and priority run doesn=E2=80=99t wait on. Would that be =
well received
or I am better served by either posting a unit attention or just using =
detect_prio
set to no and leaving the =E2=80=99sysfs=E2=80=99 prioritizer alone?
>=20
> Unfortunately, the kernel has no API for manually triggering an update
> of the access_state. I believe that would be useful elsewhere, too. We
> can consider adding it, but it won't help with current kernels.
>=20
> IMO the best option for your storage arrays would is to force using =
the
> alua prioritizer rather than the sysfs one. You are not alone, we're
> doing this for RDAC already (see check_rdac() call in detect_prio()).
> This can be configured in multipath.conf right now by setting
> "detect_prio no" and "prio alua", and we can make it the default for
> your storage with a trivial patch for hwtable.c.
This is what we are doing now in our recommended configuration. I will
probably add a patch for our hw table entry soon. It is a bit strange to
me still that detect_prio would mean replace the one that I am =
explicitly
stating in the device section. To me detect_prio would be if I didn=E2=80=99=
t
provide one and wanted multipath to choose for me.
>=20
> Regards
> Martin
>=20
Thanks,
Brian

