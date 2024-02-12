Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314B338FA9
	for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 11:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707736151; cv=none; b=rlp8K7F9P6KKkEk+OFA25w//ydaRgI8o3W/rlWf4bUVfGzLvhH7XJmb4MuIK/rwOCV5SUwP8chldZqMIKbIUeO+VVclkMyZBQ49A4krC1tV+gR9NTAq5v/93437Bdxf7lmZN8lciLHZVaplWq+2GxPf0ye1NnXdZJz03Hyc7pv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707736151; c=relaxed/simple;
	bh=vn+gYqUYhhzG459XWpYd8VwP7tkW4ucYzZj89Ka2y9s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TJk8mZ7rZ84LKAVIlcs1egy+kus8DF5Dwjicx6hPTYtPej/f/gO5zEOBTUqNJrFY8Ghzo2RqU1CeLDdkYarQUnWGB0ZuOYohUrUxln58GZ69MO0ZxawAs5XqJ6iwltFkhCpdckn2r9YLh4Dxssxl/rM8XsCFTOX0yv95vm0kGXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=e7yWVFoi; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="e7yWVFoi"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-51182ece518so1559731e87.3
        for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 03:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707736147; x=1708340947; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rgFXwJj7aSpR6xY2H7GnOcQulI/TXUVikXD4cxUA8Ho=;
        b=e7yWVFoi/tO2A1MZPYRtHNbzwJcDTchMdKJ7h9X/eXNza+Tu97KWmuUDqMc3UPZlU8
         Ns92gfQ9QDE/HdsvDfuJy6BRUorPowJ1c2+5TC1V/vXnM+BwpNGHfjKWN1SxlGAWeqQJ
         hohjJkBhtKeLSvcSMGfFp/QoQ+usLQXo5eo8SS6VbVESv/+PZKzL5/bmSwHbLeizyzId
         ULTnEAD0oRldFvWCIGxsdruLnFJNXsxglkuWjoPwPP4GCOL+OTIoAu+UMaF5urd7GZ4P
         QTGbbJLvFb1DCfI3W0hqcnQv+Jr8Fsvu5PxNHyCjAhxPnpC9pqa5LVb1miC8mU4x+aGb
         bDsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707736147; x=1708340947;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rgFXwJj7aSpR6xY2H7GnOcQulI/TXUVikXD4cxUA8Ho=;
        b=ZovMnPYOe1iq2pSM+zBPS01VMYWygsEEqkjd5oZFb9e0RPKZuw66HT6Frr28SGmDWh
         C5IxknZqWAKUeUh3rVaHzsWGK9ed5C57CPqACIgbVpsmvFDOCddmSkVfz0ZAYbFudhe4
         4l/nH3s8DXOlovuqHS1XUfGYrJV2aDWH+CiS8pyRE1dhaeWRi1FWyNsGeYdem6me/Qa8
         G4csOJLZKTfFoz+cqowMNHiVWiuigbqkpg1B7sTTDXVPyiGuBkAOrYsqjfyerjABi1ur
         8THXhzaMH0G3h2vKhvkgJ8mBrEDkNAt8d2pSZEywvBQf4pJ0rKdprH02bDQRa6LziEcv
         caVw==
X-Forwarded-Encrypted: i=1; AJvYcCWY7VhtGE4IylqfClQEs46MGnOLTJmG8H4HvluR65Y9FcLqfISx2dkqyWT1MW3vqVdkzdWNmxK/w9/SfVlq0Z6jga/OffjyWTY=
X-Gm-Message-State: AOJu0YzNGCQCJTqHTx+Pte1ASOOYEtwDbJZjU2Af6NzfEXXj+m6FlNE1
	BZGYzpQn3r9itRrxgDbp7e9Qw5CvY8v3S3e5iixqbTQKr4BkHBLfWzpeE0RC9/k=
X-Google-Smtp-Source: AGHT+IE0tfuy44NSUofIpARWoINNXpb45QTTUmpHVs4Ae4Jqxd57qX+HZVrMi+bcCV8+BEF4AGlCvw==
X-Received: by 2002:ac2:4c86:0:b0:511:8d37:4b60 with SMTP id d6-20020ac24c86000000b005118d374b60mr1775933lfl.6.1707736147170;
        Mon, 12 Feb 2024 03:09:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVWYMQ9fSt2lUFkdC0+hz7YUDD1uDUhUJpIEA3zrCNO1QdMQzMcSfgS+s3CwMJcOMPdNsLSkjTfJtLVUQNPag8aO5ew3BOTYzBOm+8AhzpKPpW7ZxF/CaBRJMhuZl8AQvjJxynZ4rEfh0ZsFdiKnwsX0RUOujQ3Jq7qKoOS4WfGecs1vVfmBMOwX1R4bUTFX0Q9ixlREx4s7uaETq7V
Received: from apollon.fritz.box (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with ESMTPSA id q18-20020a7bce92000000b00410c04e5455sm3740440wmj.20.2024.02.12.03.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 03:09:06 -0800 (PST)
Message-ID: <9b1475e2fa5982dd508d58975b8e6eb58cad95e2.camel@suse.com>
Subject: Re: About DM_UDEV_DISABLE_OTHER_RULES_FLAG and DM_NOSCAN
From: Martin Wilck <martin.wilck@suse.com>
To: Peter Rajnoha <prajnoha@redhat.com>, Zdenek Kabelac
 <zkabelac@redhat.com>,  David Teigland <teigland@redhat.com>, Benjamin
 Marzinski <bmarzins@redhat.com>
Cc: linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev, Heming Zhao
	 <heming.zhao@suse.com>
Date: Mon, 12 Feb 2024 12:09:05 +0100
In-Reply-To: <4a9e62ec-f93a-4739-a406-2c6d2138258a@redhat.com>
References: <61638dc821c08cd97f6ac53150c5b0120f732deb.camel@suse.com>
	 <4a9e62ec-f93a-4739-a406-2c6d2138258a@redhat.com>
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

On Mon, 2024-02-12 at 10:51 +0100, Peter Rajnoha wrote:
> On 2/9/24 22:58, Martin Wilck wrote:
> > Hi Zdenek, Peter, David, Ben,
> >=20
> > I have been pondering the device-mapper udev rules a lot lately,
> > and I
> > believe I have found glitches in the logic of the device mapper
> > udev
> > flags that I'd like to bring to your attention.
> >=20
> > TL;DR: change I propose:
> >=20
> > * use DM_DISABLE_OTHER_RULES_FLAG consistently as a flag meaning
> > =C2=A0 "upper layers should leave this device alone until told
> > otherwise",
> > saved between uevents in the udev db
> > * use DM_SUSPENDED consistently as a flag meaning "upper layers
> > =C2=A0 should keep their hands off this device temporarily", not saved
> > =C2=A0 in the udev db.
> > * don't use any other flags in upper layers, including 13-dm-
> > disk.rules.
> >=20
> > This implies:
> >=20
> > * stop setting DM_DISABLE_OTHER_RULES_FLAG from DM_SUSPENDED
> > =C2=A0 in 10-dm.rules
> > * check DM_DISABLE_OTHER_RULES_FLAG instead of DM_NOSCAN in
> > =C2=A0 13-dm-disk.rules
> > * check DM_SUSPENDED in 69-dm-lvm.rules, 80-udisks2.rules
> > * stop using=C2=A0DM_NOSCAN in 11-dm-mpath.rules and 66-kpartx.rules
>=20
> Hi Martin!
>=20
> It is surely possible we could do some improvements and optimizations
> here - all the rules are a result of long evolution where we were
> fixing
> various issues on the way. So if we could shoot down some
> complexities,
> that would be great...
>=20
> On the other hand, we need to be really careful, because even a tiny
> change here can cause troubles if we omit some case.
>=20
> I'll surely go through your suggestions, thanks for diving deep into
> that! Just please give me some time so I'll remap all the paths
> through
> the rules in my head :)
>=20
> Note that we're working with 3 levels of logical rule separation
> here:
>=20
> =C2=A0 1) DM base (10-dm.rules, 13-dm-disk.rules, 95-dm-notify.rules)
> =C2=A0 2) DM subsystem (11-dm-lvm.rules, the mpath rules, ...)
> =C2=A0 3) all the "other"
>=20
> As for the very original intentions of the
> DM_UDEV_DISABLE_OTHER_RULES_FLAG - this one was supposed to be the
> *only
> one* to check for in "other" rules so they don't need to bother about
> checking other states/variables ("other" here means other than DM and
> any DM subsystem). One simple variable to check for others - an ideal
> -
> otherwise, we would be having a hard time to persuade others why they
> need to add complex checks in their rules/applications.

Yes, I understand that, and it makes a lot of sense.=20

The problem arises by saving and restoring to/from the udev db. We've
got different possible *reasons* (inputs) for a device becoming
unusable. The value we communicate to upper layers should arguably be a
"logical or" of all these. But then we can't use a single variable to
save and restore the state; we must determine the value of all "reason"
flags (either directly or by restoring from the db, as appropriate for
the flag in question) and "or"-them into a single "dontuse" flag.

Example: Currently, we set DM_UDEV_DISABLE_OTHER_RULES_FLAG if
DM_SUSPENDED is set. If the next spurious uevent arrives, we see
DM_UDEV_DISABLE_OTHER_RULES_FLAG set, but we don't know if the origin
was DM_SUSPENDED or a genuine udevflag. In the former case, the device
would now be usable, while in the latter case it most probably
wouldn't. For now, I've posted a patch to fix this for the multipath
rules [1], but I'd like to see it fixed in the general DM rules.

> Yes, there's the unlucky exception in the 99-systemd.rules which
> needs
> to check the DM_SUSPENDED to import the "SYSTEMD_READY" from udev db,
> otherwise we had been running into an issue with stopping systemd
> device
> units prematurely (actually, this was an issue spotted much much
> later
> on after years of using the rules without this rule).=C2=A0
> And we haven't
> found a better way to check for this condition. This is mainly
> because
> systemd is also a "device" manager/tracker in some way through its
> "device" units, besides udev itself. I simply gave up there and
> admitted
> the check for DM_SUSPENDED case.

Well, IIUC the main reason that systemd couldn't use
DM_UDEV_DISABLE_OTHER_RULES_FLAG was at least in part due to the fact
that the multipath rules used it in a special way that was inconsistent
with the rest of DM ;-)

I think there are 3 variants of "unusable":

a) temporarily unusable (just for this event), ignore this uevent and
restore previous properties from db.
b) unusable, avoid IO, don't scan, don't activate (this is how we use
DM_UDEV_DISABLE_OTHER_RULES_FLAG). Upper layers will usually load saved
properties from udev db in this case, too.
c) like b), but also try to unmount / unconfigure if already used. This
is SYSTEMD_READY=3D0. I don't think DM has a flag with these semantics at
this time. I can imagine such a flag being set if a device was reloaded
with an incompatible table, but that's rather a corner case.

It's an honorable goal to condense everything into a single variable
for consumer rules, but I think it doesn't work if we want the upper
layers to be able to distinguish these. We can merge a) and b) I think,
because their meaning for upper layers is practically the same, if we
get the saving and restoring right.

> The DM_NOSCAN was actually just a helper and a more human readable
> name
> for "DM_SUSBYSTEM_UDEV_FLAG0" within LVM subsystem *only* at first.
> It is used during LV initialization - the wiping/zeroing of the LV
> before it is pronounced as usable - that's why, when it is set, we
> signal to "others" the DM_UDEV_DISABLE_OTHER_RULES_FLAG based on this
> flag. However, since we have the 13-dm-disk.rules which manages the
> blkid call for DM devices (and which is ours - owned by DM), we need
> to
> signal these rules to avoid calling blkid (as it could see
> uninitiliazed/stale data). In this case, we import any previous scan
> results from udev db. It's not like "completely ignore and skip rules
> for this event".

I'm not sure if I understand what you mean with "completely ignore and
skip". Upper-level rules usually can't "completely ignore" an uevent if
they need to preserve any udev properties across the current event. If
the device is unusable in the weaker "don't try IO" sense, the upper
rules must import existing properties from the db, just like 13-dm-
disk.rules, lest the properties be forgotten by udev. IMO this weaker
semantics (corresponding to b) above) is what matters most for upper
level rules.

>  Other DM subsystems may get into exactly the same
> situation with initialization as LVM, so that's why it ended up as
> generic "DM_NOSCAN" so any 11-dm-<subsystem>.rules can use it to
> signal
> 13-dm-disk.rules to avoid the blkid scan this way (the "SCAN" here
> actually means "blkid scan" so the better name would be
> "DM_NO_BLKID_SCAN" probably). The "DM_NOSCAN" is not meant to be
> consumed by "others" at all.

If blkid is likely to fail or retrieve stale data, other tools that
read content from the device are likely to fail, too, and that's why
they currently consume this variable. I agree that they shouldn't, but
that works only if DM_UDEV_DISABLE_OTHER_RULES_FLAG has "don't do IO"
semantics, as opposed to "completely ignore and skip".

> The other way round, we also don't want (ideally) to check for
> DM_UDEV_DISABLE_OTHER_RULES flag in DM and DM subysystem rules. This
> flag is meant for "others" to check. So we have a clear separation of
> what is signalled withing "DM world" and "the other world".
>=20
> The DM_SUSPENDED flag - well, this was supposed to be just internal
> to
> DM and DM subystem rules. All the "others" have the
> DM_UDEV_DISABLE_OTHER_RULES_FLAG - they simply don't need to bother
> for
> what exact reason the device is not usable, whether it is a suspended
> case or whatever else...

I understand. I agree that non-dm rules shouldn't use DM_SUSPENDED and
DM_NOSCAN. But this requires clean handling of save/restore, and that's
what we currently don't do right, IMO.

Thanks,
Martin

