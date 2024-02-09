Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD1F74E1E
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 15:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707492939; cv=none; b=NRt4ZF6dI1vZBpW6t1VD3SrJi17QjDcbSTCUK/mp/lX8wgDoB9YHuQrQ8R/riQ9VOWJI+IitZScDsAYJIlZHoWRNlibvas6r4Ovs+yVbfhc4JEat8zT4ZrB569IfvTVtQJq6CohY9OMpq5aSf6ew1pZXBVx8z1poNtPiOY0NGik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707492939; c=relaxed/simple;
	bh=+dhzkfYxoGLiDJ+j15QYu4QK9EAbOKgPMdRKYtElUas=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X+pQG8Ju2+ppxlL6X4HxM5mwjaRKn1ILclvfvSU8kldrfSURLjTc/0JeJezQFxr4MJRZh01zORugbvMphpc3Wth0P5ZHgblH/jqjEZWUlj+e0EMP+K9ZgAEKvBZAZWv7JvXCwX1k7qb5YeTPAlvI46bPfsfLVmMEOrTQKuipV4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A49dJFmf; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A49dJFmf"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4106cf2e9e2so6053715e9.3
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 07:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707492935; x=1708097735; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=stMDfLxBJHH9WScturl4RyuIQ0xzi0p6mMLY/8a4zPU=;
        b=A49dJFmf/7IxBj8OPDh0cEcVpebFrZmrc3TrcIYcV4s1AKecqqAkZPAiJh+HFIGsRQ
         fTWTZnplz9HZR7jvKAnWg9z/3ZXUduQdMeETP9O5OVJa5Gfa5aNxX3WLFJb6UsaRHwMw
         u5Ul0BTi4xjblvqcV1oVubQYqVaRYdJ92s4xGtwhfnjFGBOex4E+J8fZnoDLvdryfc94
         ZeWslh0h32ma/8qmTzcHMBqknX3Q1mh4ugLvLh4l83yUh1SnZLVhya6reXkxQ1jp8gyV
         MRES4EOeIZJc3zcSu2ylsZAsOA0HIqtODW5mkKwraxp5spR4fCNB/Y42UZlrq755eFC0
         K63g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707492935; x=1708097735;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=stMDfLxBJHH9WScturl4RyuIQ0xzi0p6mMLY/8a4zPU=;
        b=lpVNmKOxZ7fZ2beoMCxbieT1R+erS3sf0flGGVlcLYU+jFgzXEgCkagpfKbEcDubeV
         Z5bMOx+QSkFih1047wMbywZ9qhFt3ht6U4qrRDhSgg71ePbUQblLPRsEizeunydseuDj
         0BtiXw9hyN7ctgwiesI1Eeq2b3ztwXZ66gRdB2mUvMb9R5HSKBNHmr9dbwwRN4cyOtUz
         WIHMf2iKzT7kK2VwzoMygvlbCjknstDF46lJJHHLE7rvEXQvCJwil8UGXyScGWMLHVOx
         fEorGT7qYYjpS3IfubUf9WaXF0ptNG4JiddZ3/mFV/hqsvGc9lkpLBEhjgm4psjUG5Bt
         CRVQ==
X-Gm-Message-State: AOJu0Ywtxx5ULD0M5NurlrJbS7x1T+MZjPPqEmwk1MiprpQ+5j1O77o+
	UHvfq+rK5ZXJKs5ekd4rBg3Pbmr4fCnkYyWAgvWCDof4qWnq+YmUqlqFm/+l3HI=
X-Google-Smtp-Source: AGHT+IFeJ19H84SFcA/hvl9xVZm788DRKyldwX6j9mU1IEh6dh8wNRWbclhHGapUXRM9gvNNlHdX0w==
X-Received: by 2002:adf:fe87:0:b0:33b:1814:1aa8 with SMTP id l7-20020adffe87000000b0033b18141aa8mr1569493wrr.15.1707492934990;
        Fri, 09 Feb 2024 07:35:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVmjAxDtUcvCIn0WWBinwGZkpzZwQPt6SRy7fRBzDsuwVIkKb0mL/9Arhu7tE/Sbq8LM2+HukBkA0hYOGgGMv6vI7UgsoyFDz9G/LTJl6jsBwPZ+MxR3uybOhgE46iPcFQolBfuBCCU0GhA1FtHsTFjh7Ch65fkO9F8Xng4r4Hi9U1XoF/kRvDcE+ZsCfmjvgJzaCrLmtWWjg==
Received: from apollon.wilcks.net (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with ESMTPSA id v10-20020a5d4b0a000000b0033b4d603e13sm2085273wrq.51.2024.02.09.07.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 07:35:34 -0800 (PST)
Message-ID: <5446dfa693013dd7d82334e99f18895df86c204b.camel@suse.com>
Subject: Re: [PATCH 1/6] 11-dm-mpath.rules: don't import properties that are
 already set
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, Peter Rajnoha
 <prajnoha@redhat.com>,  Christophe Varoqui
 <christophe.varoqui@opensvc.com>, dm-devel@lists.linux.dev,
 linux-lvm@lists.linux.dev
Date: Fri, 09 Feb 2024 16:35:33 +0100
In-Reply-To: <ZcVyNWizAbRC0OAd@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240205124638.17877-1-mwilck@suse.com>
	 <20240205124638.17877-2-mwilck@suse.com>
	 <ZcFIwjEhKAVijIQb@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
	 <db27d762e517489df2828f1c530f3125f4b7f1aa.camel@suse.com>
	 <ZcVyNWizAbRC0OAd@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
Autocrypt: addr=martin.wilck@suse.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-02-08 at 19:30 -0500, Benjamin Marzinski wrote:
> On Tue, Feb 06, 2024 at 11:50:46AM +0100, Martin Wilck wrote:
> >=20
> > Unfortunately, testing of my patch series has shown that it's an
> > improvement, but it isn't sufficient for completely avoiding races
> > between multipathd and udev. DM_SUSPENDED=3D1 can be avoided, but
> > it's
> > still possible that the device gets suspended after the udev rules
> > test
> > for supended state and before they run kpartx, blkid, pvscan, or
> > other
> > similar commands.
> >=20
> > I am quite clueless about this right now, and would be grateful for
> > ideas. Re-implementing LOCK_EX locking would be a possibility for
> > systemd >=3D 250, as noted in the cover letter of the series. But for
> > systemd <=3D 249, I don't see good options. We can't use LOCK_EX,
> > because
> > when we release the lock, we have no means to know whether or not a
> > race with udev occurred (iow, whether udev tried to access the
> > device
> > while we held the lock, failed, and dropped the event). Thus we'd
> > need
> > to assume that this was the case, and force a reload after each
> > reload,
> > which is obvious nonsense. We also have no means to know whether
> > the
> > full set of rules has ever been run by udev for the device at hand,
> > because we don't know the set of rules that follow after 11-dm-
> > mpath.rules.
>=20
> multipathd already refuses to reload newly created devices before it
> sees the creation uevents to try to avoid this.

Right, thanks for reminding me about that.

> =C2=A0 I assume that the
> problem you are seeing is on the coldplug after the pivot root, where
> the devices already exist, or am I confused here.=C2=A0=C2=A0

No, that's exactly the situation in which the problem is observed.

> I wonder if we can do
> something similar where we would ideally delay all device reloads
> until
> after the coldplug.=C2=A0 The problem is figuring out when it's finished.

The current state of affairs is that patch 4 in my series has avoided
the issue on coldplug events, greatly reducing the frequency of errors
on the test sysstem. There's a variant that needs an additional fix:

 1 map set up in initrd
 2 creation uevent event is observed by multipathd
 3 switch root
 4 path addition, map reload
 5 change event
 6 path addition, another map reload (5-6 can repeat)
 7 DM_SUSPENDED is observed by udev while handling the change event,
   and saved as DM_UDEV_DISABLE_OTHER_RULES_FLAG
 8 Coldplug event, DM_UDEV_DISABLE_OTHER_RULES_FLAG is restored from
   udev db =3D> pvscan is skipped

I've created another patch to fix this situation, and am now waiting
for for test feedback. I'll post about this in more detail later.
In short, I believe 10-dm.rules should differentiate
DM_UDEV_DISABLE_OTHER_RULES_FLAG originating from lvm itself and
DM_SUSPENDED.

Regards,
Martin

