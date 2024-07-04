Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCBCFBF6
	for <dm-devel@lists.linux.dev>; Thu,  4 Jul 2024 07:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720077580; cv=none; b=ggReQnbm9enQf57Cc4fYWLAOSIExXuiiJnH2nmXVMJBd/BTxvgdHUzQ/+GxzG98grzOHjsCY4US5chUbJt1PSmjbS4E6FPxn47PujmwXV+QcttlNqljN+cybJmQHD2LG5N2MPlvd6lsCjfOi2U5SWPEAo14KKeKKLoJeMX1bx7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720077580; c=relaxed/simple;
	bh=juw4CCSr3n5qHO18kowjN2rat+S5r0qJ924CNkFcVt0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TxRE4pubz4CEY9tLCmkp1xgdC3MDS8ipnXKMKNDbrzLuXJTNx6O0A3OtkWgrxa1vXbst3A7CjJy0XPFENMQebzUWxtNzP/yxNzbumWiEq8RfgtBvAlznE/LKc2AXjJrdwMy9ZQfOs48hueAl2McXdjbZsUtmoYdSLjxaKbF6x7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WXtQ8Ln1; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WXtQ8Ln1"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-35f06861ae6so193634f8f.2
        for <dm-devel@lists.linux.dev>; Thu, 04 Jul 2024 00:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720077576; x=1720682376; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=juw4CCSr3n5qHO18kowjN2rat+S5r0qJ924CNkFcVt0=;
        b=WXtQ8Ln16Bn958sDBB0ZYHikVS6k574DvzsyIn1/TKg59IOzOTAgrmp76xCLmIAD0/
         m3v8BjeRySupXDUyFkMowSXBiz0xCWzwoLpD4wsD/RJ/V0MnO2PF216GWJYdnA4kgDOh
         4c3b7SqXr5GGzIra5PH02y7OmjXt2LC2i3xhaYHDMdxMaTYbY7KFCsitIi/M9ql5Ft3z
         d9MZ+g09yg2vGDCViR//jl+WiobaUgwMP2mKqc2KwTtx2iThZOPmJBrKSVnhBj2wYReV
         2F2eflBZwL8AqBV73HnWEgTXlL5bvN67HOGXY+GYqg5nHynMFcsd4tAc6+5sYG6yBiPu
         0RcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720077576; x=1720682376;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=juw4CCSr3n5qHO18kowjN2rat+S5r0qJ924CNkFcVt0=;
        b=c4BOS3EPRncbxTWSJQOdznQ25xWo0nCgzf0FQMYj+SrwatJErTM5GzZKvHvOuod9JJ
         05yk2WRnz0iuI9w2HMFsHlrLe/GO3Q/+BkPphAgvmQZ2nuJti1DZY/6+di1ztepYzQys
         lrDZ3ogpm7blLq34vU0Ph4juxsJTKsVDiJA5IQZ8MHBM/WrrchJKVy4MmzXdMvSgzx4y
         CWbEiBqjm59U2mivrK/it+nv31pT3XYOyajSJ21UaTje9IBaRaXVTxP91fcdvlFnCTvx
         ev4yN0wdT1xnOFNVOoMWSoxas6K0FSy3vKikDptOYChLB6mEdeLGFAL1k0y/tIN0KVzL
         SDhw==
X-Forwarded-Encrypted: i=1; AJvYcCV0gJDDw21K1XN8TsyEIm0fKnniTDeIWVnELou8etRO7zJjYaYji2Dz4gXpS8+d+xhfAzTrbyAt0UDf9IIPyZ5HZH5EBdaUasY=
X-Gm-Message-State: AOJu0Yz+iYNXQf2p/gRtBmP99xiBZv3oqH1F51s/s9BVSpNm1h5DGgs0
	/enBM+Yd3so5XbKh3yHpCuw4A9jfkAihKcrAiUi6b5GnWEux6dRXyfjEElUrRTg=
X-Google-Smtp-Source: AGHT+IGZEwe/U7S8UzpyzCjQGX17RMpFRaUdCr/VXVt8hMpNSbp+MSP6HzmSQhtVDZFx7u5Hzm3YpQ==
X-Received: by 2002:adf:ebc8:0:b0:367:84fe:cd7f with SMTP id ffacd0b85a97d-3679dd66cdcmr472641f8f.56.1720077575517;
        Thu, 04 Jul 2024 00:19:35 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3679aa0edccsm1244916f8f.60.2024.07.04.00.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 00:19:35 -0700 (PDT)
Message-ID: <95cf6b156bbe20c7ff250458037b24d0f990cfcd.camel@suse.com>
Subject: Re: [PATCH 3/7] multipathd: refresh multipath before calling
 set_no_path_retry()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Thu, 04 Jul 2024 09:19:33 +0200
In-Reply-To: <ZoRCrVoNbIntNH__@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
	 <20240605232254.623290-4-bmarzins@redhat.com>
	 <7551690cc28e39dc733c57ae1a9e657c469aafb3.camel@suse.com>
	 <Zn2wW55XxNn4ju2e@redhat.com> <Zn2xzs0uxpWmIMyh@redhat.com>
	 <cd066f0b8d24626b0370e4a97dbf1471351dbab9.camel@suse.com>
	 <ZoL4TX2evkCyK4pT@redhat.com>
	 <d9c5652f9f0a17db466354d4b5d10ca04a959215.camel@suse.com>
	 <ZoRCrVoNbIntNH__@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-07-02 at 14:10 -0400, Benjamin Marzinski wrote:
> On Tue, Jul 02, 2024 at 09:34:17AM +0200, Martin Wilck wrote:
> > On Mon, 2024-07-01 at 14:41 -0400, Benjamin Marzinski wrote:
> > >=20
> > >=20
> > >=20
> > > My purpose in writing 0f850db wasn't to cut down on ioctls. It
> > > was to
> > > keep set_no_path_retry() from incorrectly handling queueing in
> > > cases
> > > where no_path_retry was set to a number, and the device had no
> > > usable
> > > paths.=C2=A0 My purpose in this patch is also to make sure
> > > set_no_path_retry() does the right thing. Obviously, this one is
> > > more
> > > of
> > > a corner case, and if instead we were occasionally resyncing with
> > > the
> > > kernel even when a multipath device had no paths, that would
> > > solve
> > > this
> > > issue, and I'd be fine with dropping this patch.
> >=20
> > That sounds good.
> >=20
> > > So unless it conflicts with work you're already doing, I'll send
> > > a
> > > new
> > > patchset that changes checkerloop() to pull the multipath device
> > > updating work out of check_path(). I'm not sure that it makes a
> > > lot
> > > of
> > > sense to change how we loop through the paths, since check_path()
> > > does
> > > work on some paths that aren't assigned to a multipath device.=C2=A0
> > > Plus
> > > different paths in a multipath device will need checking at
> > > different
> > > times depending on their states anyway, so you can't just go
> > > through
> > > all
> > > the paths at once.
> >=20
> > While I agree that syncing the map state just once per checkerloop
> > and
> > map is the right thing, I believe we should do it as soon as we
> > have
> > checked all paths that need to be checked for the given map. And
> > that's
> > most easily done by looping over the mpath vector, like this:
> >=20
> > for each mpp
> > =C2=A0=C2=A0=C2=A0 for each path in mpp
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if path needs to be checked:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 chec=
k path
> > =C2=A0=C2=A0=C2=A0 sync mpp
>=20
> Huh? Are you suggesting syncing the mpp state every second? That
> would
> be an increase in the number of ioctls we're doing in many cases.

That was not my intention.

My pseudo-code was oversimplified. We could of carry a boolean in the
inner loop that would check whether any of the path checks suggest
doing a map sync, iow, if any of the check_path() invocations=C2=A0
had proceeded down to the call to update_multipath_strings(). That way
we'd necessarily do less ioctls. No?

From there, we could improve the logic / timing of the syncs further.

> I'm not against your idea, but the way to code is now, even doing
> your
> mpp loop doesn't really guarantee that. Just because all the paths
> get
> checked every 20 seconds, doesn't mean that they will be ready to be
> checked on the same second. For paths that get added after the
> multipath
> device is created, this is often not the case. And even if the paths
> start in sync, there are multiple reasons why they can drop out of
> sync.

True. I am not claiming my idea was perfectly thought through. But I
think the issues you mention could be overcome. For example, we might
check all "healthy" paths of a map at the same time. If a path goes
down and back up again, it might get out of sync with this "rhythm" the
way we handle it now, but we might as well just treat it like the other
healthy paths again.

>=20
> But it we wanted to, we probably could fix that and space the
> checkers
> out better at the same time. I don't think it would be that hard to
> make
> the paths change their next check tick by a second every so often so
> that
> all the paths in the same state from a given multipath device run
> their
> checkers at the same time. We could even make the different multipath
> devices spread out when they are checked, so that they aren't trying
> to
> all run their checkers at once.

Interesting idea, even though I think that once we do truly
asynchronous path checking, that won't be much of an issue any more.

>=20
> I'll take a stab at this in my updated patchset.

Ok, looking forward to it.

Martin


>=20
> -Ben
>=20
> > In the long run, I think what we should do is use asynchronous
> > checkers
> > exclusively. And instead of waiting a millisecond for them to
> > complete
> > synchronously, we should trigger the path check on all paths (that
> > need
> > to be checked) in one go, then wait for all checkers to complete
> > (this
> > is the difficult part, I know), and then go over all the results,
> > again
> > without waiting for anything.
> >=20
> > Another project I've been wanting to do for a long time :-/
> >=20
> > Regards
> > Martin
> >=20
>=20

