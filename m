Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6501EB24
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 10:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707216652; cv=none; b=CQZj3AziLHdoIq9norRckz/VJ3ag+A46Davc63ktKodRQ9+J472oyMipVocQ06i4uErEZFOCoVM+SZ42Mf2vOidWz39x0MQOFxas1Mh7qe08yEEnRT0ZpNuEQkVAuRWstqKv/+VFwnfDgZwLLsg9qNDHzPdqDqHh20c9MFYKkC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707216652; c=relaxed/simple;
	bh=o8WMrDfGtXyyORYdthFueEt5pFuRiaNXFI0AVAMTUr4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MPHq2DeetkebWuzb5ZhE9mvHIfX/WzbLhWtrLi4Bwx0gLqJUK2S0GLFFA3F2hKGyqzx7o46l9EcBfJYFhG52BJuuVA0i1CmchQyq+B0QkYELL5Sg2J0evR89kbDlwUi/5f3RjXK0oRctcqfwq9MZhBNh50o82S3qXiOYm3NSrfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BKVlY3TC; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BKVlY3TC"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-40ef64d8955so5940075e9.3
        for <dm-devel@lists.linux.dev>; Tue, 06 Feb 2024 02:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707216648; x=1707821448; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d683kFNyAzw+T1YKwQHwkIydzgXND9md/0A8CCqpTIk=;
        b=BKVlY3TCbzDKuDZAwQuuQXT+dZib7I8si+whggeobGeCsykrujLyklE0PQd/uDjPy3
         uT5sqWzQTEiPyPJ9mCKo1CuO/AoN0SoN7FgFXetNRQx4/R7LpA9ldnNtQckQxgnqRiY1
         PlZaPeccx/uRpUx4Qy5r9CkxOO5zOq/VogHVyNNl5sWxwAF/wH/w//XN48GH6Xqi/Fw5
         KLs10Mkf7tT/q/AUMTJ4Jj/F2zKv8E7zGQMeCcT/RDL3Tjry9cJB0watQv9wR6f7FWHK
         KdypW3dPLZqtQYBDm+TUx707eXfK9ZGi4SPZ3a8fYcbqw3k/C1/IxX5E3p5Sum8u7Bt9
         98fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707216648; x=1707821448;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d683kFNyAzw+T1YKwQHwkIydzgXND9md/0A8CCqpTIk=;
        b=MtT5c5OND6DOduPnQLmdj+lYEYNZ4xX5nnrMQoqUw8zR/0ppZvJ6haFyyzyhYNHVFy
         hBn3E+bjqerCw5Kh7DU+8pZI8CVpWYoHpjWTJOXjtuxiy1FpZNYld9HoeQ1EugZB7f/j
         fCvpSK9ZbePIL6sN7hNhCUMnJbit9hkU5E/iwtgp14/7Tc4/I/pcy6Y5YyyEKewTU7tR
         duo8Ojl6SQRNxmJr6NpxPCCpIPYvg4bSy1xq4ZCnP3baMPqQePeLm/H+xH51xPOL5YRS
         cH+UeoxP8hiVESn+4dZuSAXoMh5RutyFPmy+U0GyHof0mrNCVZ/5xO7TTspcnIj0jgtE
         DXrg==
X-Gm-Message-State: AOJu0YzpWiXmZF5VOXm4mP9PkxROqD1ol01vmtirKOVS3fr9v28Ww8ta
	MKyrLImbB6uWwq/hcT+K3KsNgOANwe3JKaChlvvZkT6Op/eeXkLUpYWme36LCNg=
X-Google-Smtp-Source: AGHT+IGIQyNH0VleS5WNqDvPdENVXndkivaR6AyTf1eiVqnRa3NtpO4ZTnGHY1iSAilyEYtIdY6eiQ==
X-Received: by 2002:a05:600c:3581:b0:40f:de6a:2a27 with SMTP id p1-20020a05600c358100b0040fde6a2a27mr1806533wmq.40.1707216647833;
        Tue, 06 Feb 2024 02:50:47 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWaYNU0I0Y8m+1A0ulyUzu3FKb7jrgieM2uVw0miPc/zRtgvWqqToCNpsJJA3M+GfzIIaKIYQBDW21PbzdEA8khyKfc5LgLuuz24/IqxhqpY8TzyO3spKlTeRVi46U3j5Mr7geBNPYonDx7Fnv4UeC/QlYUrjKSUkh/da4Rad/0cEmZfFLfhB1s4P10I5M=
Received: from apollon.wilcks.net (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with ESMTPSA id s13-20020a05600c45cd00b0040e4733aecbsm1585316wmo.15.2024.02.06.02.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 02:50:47 -0800 (PST)
Message-ID: <db27d762e517489df2828f1c530f3125f4b7f1aa.camel@suse.com>
Subject: Re: [PATCH 1/6] 11-dm-mpath.rules: don't import properties that are
 already set
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Zdenek Kabelac
	 <zkabelac@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev, Zdenek Kabelac
	 <zkabelac@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>
Date: Tue, 06 Feb 2024 11:50:46 +0100
In-Reply-To: <ZcFIwjEhKAVijIQb@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240205124638.17877-1-mwilck@suse.com>
	 <20240205124638.17877-2-mwilck@suse.com>
	 <ZcFIwjEhKAVijIQb@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
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

On Mon, 2024-02-05 at 15:44 -0500, Benjamin Marzinski wrote:
> On Mon, Feb 05, 2024 at 01:46:33PM +0100, Martin Wilck wrote:
> > DM_UDEV_DISABLE_OTHER_RULES_FLAG and DM_NOSCAN may be already set
> > from previous rules, e.g. if the device is suspended. Make sure
> > we don't overwrite them.
> >=20
> > DM_DISABLE_OTHER_RULES_FLAG_OLD and MPATH_DEVICE_READY are only
> > used in this file, and not used in the scan_import code path.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0multipath/11-dm-mpath.rules | 15 +++++++++++----
> > =C2=A01 file changed, 11 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-
> > mpath.rules
> > index c339f52..2c4d006 100644
> > --- a/multipath/11-dm-mpath.rules
> > +++ b/multipath/11-dm-mpath.rules
> > @@ -2,12 +2,19 @@ ACTION!=3D"add|change", GOTO=3D"mpath_end"
> > =C2=A0ENV{DM_UDEV_RULES_VSN}!=3D"?*", GOTO=3D"mpath_end"
> > =C2=A0ENV{DM_UUID}!=3D"mpath-?*", GOTO=3D"mpath_end"
> > =C2=A0
> > -IMPORT{db}=3D"DM_DISABLE_OTHER_RULES_FLAG_OLD"
> > -IMPORT{db}=3D"MPATH_DEVICE_READY"
> > -
> > =C2=A0# If this uevent didn't come from dm, don't try to update the
> > =C2=A0# device state
> > -ENV{DM_COOKIE}!=3D"?*", ENV{DM_ACTION}!=3D"PATH_*",
> > IMPORT{db}=3D"DM_UDEV_DISABLE_OTHER_RULES_FLAG",
> > IMPORT{db}=3D"DM_NOSCAN", GOTO=3D"scan_import"
> > +ENV{DM_COOKIE}=3D=3D"?*", GOTO=3D"check_ready"
> > +ENV{DM_ACTION}=3D=3D"PATH_*", GOTO=3D"check_ready"
> > +
> > +ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!=3D"?*",
> > IMPORT{db}=3D"DM_UDEV_DISABLE_OTHER_RULES_FLAG"
> > +ENV{DM_NOSCAN}!=3D"?*", IMPORT{db}=3D"DM_NOSCAN"
> > +GOTO=3D"scan_import"
> > +
>=20
> If we do this, don't we forget the values for
> DM_DISABLE_OTHER_RULES_FLAG_OLD and MPATH_DEVICE_READY whenever we
> get a
> non-dm uevent? If we skip importing them for a uevent, they're
> dropped
> from the database, which means that on the next dm-originated uevent
> we
> won't be able to get the old values. right?

Right, I didn't consider that.=C2=A0It makes sense for MPATH_DEVICE_READY.

However, while at it, I wonder about our rationale for saving
DM_UDEV_DISABLE_OTHER_RULES_FLAG in DM_DISABLE_OTHER_RULES_FLAG_OLD.

In 10-dm.rules, DM_DISABLE_OTHER_RULES_FLAG changes its value only
 - in DM_UDEV_PRIMARY_SOURCE_FLAG=3D1 events, according to the value of
DM_SUSPENDED
 - for DISK_RO=3D1 events (switches the flag on)=20

(11-dm-lvm.rules has some additional logic that doesn't matter for
multipath).

For all other events, the flag is restored from the udev db in 10-
dm.rules. Ignoring DISK_RO, it always has the value that DM_SUSPENDED
had in the last DM_UDEV_PRIMARY_SOURCE_FLAG=3D1 (aka map reload) event.

The logic in 11-dm-mpath.rules adds a check for unusable arrays
on top, setting DM_DISABLE_OTHER_RULES_FLAG if MPATH_DEVICE_READY
switches from 1 to 0. In this case we save the previous value in
DM_DISABLE_OTHER_RULES_FLAG_OLD, and restore it from there in a later
event if MPATH_DEVICE_READY switches back from 0 to 1.

IMO the following can happen:

 1. an event arrives while DM_SUSPENDED=3D1, causing=20
DM_DISABLE_OTHER_RULES_FLAG=3D1 to be set
 2. 11-dm-mpath.rules sees no paths and saves
DM_DISABLE_OTHER_RULES_FLAG=3D1 to DM_DISABLE_OTHER_RULES_FLAG_OLD
 3. an event arrives after the device has resumed, DM_SUSPENDED and
DM_DISABLE_OTHER_RULES_FLAG are cleared in 10-dm.rules
 4. 11-dm-mpath.rules sees MPATH_DEVICE_READY=3D1 and restores
DM_DISABLE_OTHER_RULES_FLAG, setting it to 1

... and this would be wrong, no?

It seems to me that we should not save DM_DISABLE_OTHER_RULES_FLAG_OLD
between uevents. We must set DM_DISABLE_OTHER_RULES_FLAG=3D1 to avoid
upper layer probing if there are no paths, but I suppose we should
restore the previous value after udev rule execution, e.g. in 99-dm-
mpath.rules:

ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=3D=3D"?*", \
   ENV{DM_DISABLE_OTHER_RULES_FLAG}=3D$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}=
, \
   ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=3D""

Am I confusing stuff here?

Unfortunately, testing of my patch series has shown that it's an
improvement, but it isn't sufficient for completely avoiding races
between multipathd and udev. DM_SUSPENDED=3D1 can be avoided, but it's
still possible that the device gets suspended after the udev rules test
for supended state and before they run kpartx, blkid, pvscan, or other
similar commands.

I am quite clueless about this right now, and would be grateful for
ideas. Re-implementing LOCK_EX locking would be a possibility for
systemd >=3D 250, as noted in the cover letter of the series. But for
systemd <=3D 249, I don't see good options. We can't use LOCK_EX, because
when we release the lock, we have no means to know whether or not a
race with udev occurred (iow, whether udev tried to access the device
while we held the lock, failed, and dropped the event). Thus we'd need
to assume that this was the case, and force a reload after each reload,
which is obvious nonsense. We also have no means to know whether the
full set of rules has ever been run by udev for the device at hand,
because we don't know the set of rules that follow after 11-dm-
mpath.rules.

Thanks,
Martin

