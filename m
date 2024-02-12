Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0443C68C
	for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 14:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707747395; cv=none; b=l7uVz6f2SF9f/62n9IZPI5TeyxZvNd+tLM3Qz1RswwT5NliNmLaBkpFQzP6KgLvNlQPQNZ2nesR/XxfbzH8suHCAiGJnXT4WX1iHqKZeNO5g81TpgZeaboDk4q7mPESFGeJJJJhA6fzMF1AsRttQLPHHT3mKqnquJ8CytZxg7LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707747395; c=relaxed/simple;
	bh=NvUABHxVOnZt0NAaHcJDHMiHWJdeDzVpmhD9j98Sg08=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YFB3vjbmgaw01HS2C3qq2Q1Yq4v3Ir3n5xijAOV4TC60EeXfYov9k64Rr6VZG3mTmeFFelbDZI8pl4Yxr9/SzAbrkG5x6iKcQBp/x7MIpKRKwf3aXVNaTooLi/TVAhQQMvA5/UUicnakOCJ05IYXrvkHLpyfeAV6zPRwB11tPOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZeMSh9e7; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZeMSh9e7"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-33b28aadb28so2059344f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 06:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707747391; x=1708352191; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NvUABHxVOnZt0NAaHcJDHMiHWJdeDzVpmhD9j98Sg08=;
        b=ZeMSh9e79E3xfuKseEOy5xjR7ycxY8rLRPwywjo9Q68tpOmCvLHA9TC2JC9lmF4DO5
         lCTfyw8gDjN3k0aPsMq5awt8Myu15d3brcDSLFBpZ9rHNJbGD+xYDff7xE7KXB9tJfHa
         YrTucOCof4CEHNETfyfghvElnClaaBj4dcT5qtVNSvFdTMQm/vjTEdYGj+6d5YTs5hHw
         HzZfDsgvjWJtVnNtmxr0Vy2zBcA3j6yvShdXXY4KELKesQRr5rIZqvP/R3w+Wo0jdCe/
         uoasypbmdsZANh3HvErfig843cYQtFNSf50nnItybdx2HXHW8ttUfoeBqxDAjZ0vMlCD
         cw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707747391; x=1708352191;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NvUABHxVOnZt0NAaHcJDHMiHWJdeDzVpmhD9j98Sg08=;
        b=shgTHxhgNTW0Qh5t7kQ/rB6GemcrYPu1H9Z8fpU9ZFhbEdelaFm7Gc/vJvJthsxVzX
         syFe/Qb0XDbytdTxcf5ZeBYgoSri8lOX9MJTgz4yWBQ2EIOKE6FFj7PP3IEaDvbAtDIV
         slvFzNWlUR+phM9LQZ3hU/NQ0/CY66crMvuebgBX8wPoYnFeU4uga+r3x9uYuhaAksHa
         SL15FGIDvKg4SxHC2KA41Wq4pgAMWtfeyCHZL4Z7o3pU+p4/m2ONM6K+epY4hTQotN7r
         3fvGNH/B4NJ/LjD7Mas7LIqRuz9SPycXlpG0Di/Dp18/yUSzJqaVxcktwLsgFywu/ExH
         1Lfw==
X-Forwarded-Encrypted: i=1; AJvYcCW5mgTVnses/I2Ge0JwVASVq7lGrQf5aZE53+Cic2LOWWY9+O9oaDEuqKgg8m40OAdAIS94M+PTOSrpE+b6OMMYuj2j0NVjnt4=
X-Gm-Message-State: AOJu0Yz+LrqHy+xiGysGsBIq04ojjR+MGK/3V6QXv7b7KI0UyrVHdt9T
	Z3Y+7rmhaFRG7QQlen62mhaYkrAG03Votn0w971Q3axBUQS2tcUSAG+QBYeLBrH7blBEXGXX9hm
	G
X-Google-Smtp-Source: AGHT+IHnx+DW8GyCK2ak1boZA2yE8QMdWS+olIrDUVbo8QJq1fjqkXIALAi/DWaDE9hm1sfWU/fwag==
X-Received: by 2002:a5d:668e:0:b0:33b:86b2:4753 with SMTP id l14-20020a5d668e000000b0033b86b24753mr1269250wru.60.1707747390991;
        Mon, 12 Feb 2024 06:16:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX5w85vRncwgaOSvJcwpMaxUrIWafDpWQg2jIrx+wpkH31jXy429r+EB38u2P4lka1X9dQ6UMfBoF65TkpnH8f0ScdntREMh0VGPvMsh0UaCnwwcD+DckhRN+tCIWReIllTbNKDDvcDO6ZmT/9PP0vwh+eCFbmFPZeeBANSQxJstUo/iNoFJPd2GYcyqiTsXtSvS9cUqh0lnzZbfsrL
Received: from apollon.wilcks.net (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with ESMTPSA id bu3-20020a056000078300b0033b46b1b6adsm7019206wrb.21.2024.02.12.06.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 06:16:29 -0800 (PST)
Message-ID: <8e7a574fffaded39825a01bf33482cea94507289.camel@suse.com>
Subject: Re: About DM_UDEV_DISABLE_OTHER_RULES_FLAG and DM_NOSCAN
From: Martin Wilck <martin.wilck@suse.com>
To: Peter Rajnoha <prajnoha@redhat.com>, Zdenek Kabelac
 <zkabelac@redhat.com>,  David Teigland <teigland@redhat.com>, Benjamin
 Marzinski <bmarzins@redhat.com>
Cc: linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev, Heming Zhao
	 <heming.zhao@suse.com>
Date: Mon, 12 Feb 2024 15:16:27 +0100
In-Reply-To: <f3e3db2b-8077-48b6-b507-4a9c4793affb@redhat.com>
References: <61638dc821c08cd97f6ac53150c5b0120f732deb.camel@suse.com>
	 <4a9e62ec-f93a-4739-a406-2c6d2138258a@redhat.com>
	 <9b1475e2fa5982dd508d58975b8e6eb58cad95e2.camel@suse.com>
	 <f3e3db2b-8077-48b6-b507-4a9c4793affb@redhat.com>
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

On Mon, 2024-02-12 at 13:32 +0100, Peter Rajnoha wrote:
> On 2/12/24 12:09, Martin Wilck wrote:
>=20
>=20
> Right, underneath within DM/DM-subystem, we should be able to keep
> and
> restore those reasons for why it has been flagged with
> DM_UDEV_DISABLE_OTHER_RULES_FLAG till now and when the state is good
> enough that we can drop it, we would do it transparently for higher
> (non-dm and non-dm-subsystem) layers. So if there's a case that is
> not
> currently handled by 10-dm.rules or 11-dm-<subsystem>.rules, we can
> fix
> that there. If it's a generic rule that applies to all DM, not just
> subystem, then yes, we can move that to 10-dm.rules (will have a look
> at
> your patch [1]).

I don't think that patch can be used as-is for DM. For multipath, I'm
not aware of any situation where DM_UDEV_DISABLE_OTHER_RULES_FLAG would
be set in the udev cookie, therefore DM_UDEV_DISABLE_OTHER_RULES_FLAG
is essentially an alias for DM_SUSPENDED before 11-dm-mpath.rules
changes it. That's not the case for other targets, in particular LVM.

> >=20
> > Well, IIUC the main reason that systemd couldn't use
> > DM_UDEV_DISABLE_OTHER_RULES_FLAG was at least in part due to the
> > fact
> > that the multipath rules used it in a special way that was
> > inconsistent
> > with the rest of DM ;-)
>=20
>=20
> Aha! Well, honestly, I don't remember the exact details and context
> of
> that fix, but I know we haven't found a better way...
>=20
> >=20
> > I think there are 3 variants of "unusable":
> >=20
> > a) temporarily unusable (just for this event), ignore this uevent
> > and
> > restore previous properties from db.
> > b) unusable, avoid IO, don't scan, don't activate (this is how we
> > use
> > DM_UDEV_DISABLE_OTHER_RULES_FLAG). Upper layers will usually load
> > saved
> > properties from udev db in this case, too.
> > c) like b), but also try to unmount / unconfigure if already used.
> > This
> > is SYSTEMD_READY=3D0. I don't think DM has a flag with these
> > semantics at
> > this time. I can imagine such a flag being set if a device was
> > reloaded
> > with an incompatible table, but that's rather a corner case.
> >=20
> > It's an honorable goal to condense everything into a single
> > variable
> > for consumer rules, but I think it doesn't work if we want the
> > upper
> > layers to be able to distinguish these. We can merge a) and b) I
> > think,
> > because their meaning for upper layers is practically the same, if
> > we
> > get the saving and restoring right.
> >=20
>=20
> The c) case - well, it's questionable what should be done in that
> case,
> because that means we have literally cut off the underlying device
> while
> it was still in use. Any further IO from higher layers will return IO
> errors, will queue IOs or, in the worse case, issue IOs to a device
> that
> we don't want to anymore.
>=20
> Anyway, if I understand correctly, we simply need to signal higher
> layers either:
>=20
> =C2=A0 A) device is unusable, forget it and clear all your current extra
> records you have about this device (including removing any custom
> symlinks for udev). That would also map to SYSTEMD_READY=3D0.
>=20
> =C2=A0 B) device is unusable temporarily, restore any records you need,
> wait
> for the DM_UDEV_DISABLE_OTHER_RULES_FLAG=3D1 to drop to 0 (or being
> unset).
>=20
> What do you think about keeping a single
> DM_UDEV_DISABLE_OTHER_RULES_FLAG for this, just having a different
> value, say "2" to denote the B case? Otherwise, we need 2 distinct
> variables (which is harder for others to accept I bet).

Yes, that could work, if the save / restore is implemented cleanly.


>=20
> > > The DM_NOSCAN was actually just a helper and a more human
> > > readable
> > > name
> > > for "DM_SUSBYSTEM_UDEV_FLAG0" within LVM subsystem *only* at
> > > first.
> > > It is used during LV initialization - the wiping/zeroing of the
> > > LV
> > > before it is pronounced as usable - that's why, when it is set,
> > > we
> > > signal to "others" the DM_UDEV_DISABLE_OTHER_RULES_FLAG based on
> > > this
> > > flag. However, since we have the 13-dm-disk.rules which manages
> > > the
> > > blkid call for DM devices (and which is ours - owned by DM), we
> > > need
> > > to
> > > signal these rules to avoid calling blkid (as it could see
> > > uninitiliazed/stale data). In this case, we import any previous
> > > scan
> > > results from udev db. It's not like "completely ignore and skip
> > > rules
> > > for this event".
> >=20
> > I'm not sure if I understand what you mean with "completely ignore
> > and
> > skip". Upper-level rules usually can't "completely ignore" an
> > uevent if
> > they need to preserve any udev properties across the current event.
> > If
> > the device is unusable in the weaker "don't try IO" sense, the
> > upper
> > rules must import existing properties from the db, just like 13-dm-
> > disk.rules, lest the properties be forgotten by udev. IMO this
> > weaker
> > semantics (corresponding to b) above) is what matters most for
> > upper
> > level rules.
>=20
> I didn't consider that there might be extra records to keep around
> for
> anything else than blkid (13-dm-disk.rules) and DM/DM subsys (10-dm
> and
> 11-dm-subsystem.rules). But you're probably right here -
> differentiating
> the A) and B) from above could be beneficial for some layers above.
> If
> nothing else, then at least the systemd's SYSTEMD_READY case in
> 99-systemd.rules.
>=20
> If we could still keep the single DM_UDEV_DISABLE_OTHER_RULES_FLAG
> for
> others to check, I'd really like to have only that one, not adding
> more.

I'm fine with that, but changes to higher-level rules will be necessary
either way, be it only that they refrain from accessing those variables
that we don't want them to access.

I the longer term, I suggest that properties that we don't want higher
layers to access be marked as such [*]. For example, DM_NOSCAN could be
replaced by __DM_NOSCAN, following the widely respected convention that
symbols starting with underscores should be left alone. DM_SUSPENDED
could actually be replaced by .DM_SUSPENDED, which would correctly
reflect the fact that it's never restored from the udev db (as
properties starting with "." aren't saved to the db).

Thanks,
Martin

[*] I think the suggestive names of DM_NOSCAN and DM_SUSPENDED have
have contibuted to their adoption by 3rd parties. Sometimes it's better
to use non-intuitive variable names like DM_UDEV_SUBSYSTEM_FLAG0 :-)

