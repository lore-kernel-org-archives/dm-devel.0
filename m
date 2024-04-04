Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF51674C09
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 15:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712243854; cv=none; b=G2NAI9zzBVQSWyMUuQoCD/Ge6mUleLmCyUncAKsBl/As2AEV0H3RPvg6Ohil5tgHYXohxUBJoUkgTBec4GUx4o0uPaunIX23xnMKtvLF2P1XHm6JiZcRCyzLUjInKzQe06YNao5ADP8Jjs/qfSAAlP/eN78z59zq+4X/HLuIsrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712243854; c=relaxed/simple;
	bh=3JVk0jnzLoKpplcfrzeth44bFaz64jYtATlkGG7rAis=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tsNkTItsp1pzfbWE8EF/nLFWO4ndmj0fL9RGxsNEArIfQEpinrfx+ArdarZf2pONb0eBP/n8K6OcVb+HxM+eh+bo8aLpXFnv+se3ZOh6RodE6VhRbCw0Q9gf9AqgTuzlIWCbZD1NpGstRmCGtu1jDXP7z+tOQOdBtc/HT6ishVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RKD37aBZ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RKD37aBZ"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4155819f710so8222095e9.2
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 08:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712243850; x=1712848650; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TXbOIrisnyO5CKapEmXT0zVsosmfp3Gsk5kU1aR8Wzo=;
        b=RKD37aBZEL656ahbZBGnjGuhAqOoQ6oasO2wccWLFjsWxI4ZWfVibGBDKC1oRZ5on5
         rzW5NU398f7SjWZ92pQmqjzN0HttP7R1fdNcQJiqeNU44wymZhGFyzCSJxg4puSPiIgP
         ICiZvAJwmmetFXdOABbqqdocBzE5RQhnzTMVTLpNQFWB/f/lSFXkcA0ONJJOj0WIAgfZ
         X6cTWm7prn2AmvPlnvbnMjAZlSSNOQS6t9LsO0xQqzK6no6f6e217P7C9Yyb5XEz7ELB
         2OpxLtzuJtJ8KBfJ8dJ2EHSDE0lqlNpL3N0A3BDtPRibOlarh/pkY93YnB6UkO6dRvCG
         odIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712243850; x=1712848650;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TXbOIrisnyO5CKapEmXT0zVsosmfp3Gsk5kU1aR8Wzo=;
        b=UfcS+OaXhTNHIYFw4+2yOvTyxoNjag6OpF+Nk9znsDLnqwfkdydyATTNN9nSqNnByy
         na2/77CnYkQegpII8+AfurM6pvv7SR2+acHWr8soM34mBVyxjhXepGslY4t6vnEygijz
         AhITGckapX0X2kZjj8RXyBECNBOteIcE4v+cFHALkeg03HX2iL2w5Olew9yCfNUgcSYE
         bJi5Qjhd+9vbr/VBk8Lp2jFXbt2zoxQWA2HBG7MQNxsmhuW+1gc+RS5IifS4CYBBTkJe
         dZiXa4IHe/mFqeDi4oS2IMN8tM6x1KrU61lcKpsEjkl+gJEtbQdf879Ie6HldThwMS+c
         lP1A==
X-Forwarded-Encrypted: i=1; AJvYcCVhaTdGsQHEYN6wAEWUtMOtxZKFQmNRk6B7mcoaDfSVW+f5JCvULMz4N6JE5tKBX5Y5XdJqkTl6NuqBv7ir1h9f5FInde+pDJo=
X-Gm-Message-State: AOJu0YxaSIKFLtQRE4ujAD5S5GHgbVuCuMG8ADg5jRpPwSA4SXzQOZzK
	G6ksZi5cepQCe6lbSDEzZSbDy1piT9162g8YKN3n9JiLnCmXjIz2Kt3etSFZqIU=
X-Google-Smtp-Source: AGHT+IFE+WdoyNBf7KMh98tdQMWVQWK1A+zDL6jME89RK8gNZNDA49thCp0JVh4rDWqfiwUcV9YGeg==
X-Received: by 2002:a05:600c:54c2:b0:414:63da:a2a2 with SMTP id iw2-20020a05600c54c200b0041463daa2a2mr60534wmb.29.1712243850291;
        Thu, 04 Apr 2024 08:17:30 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with ESMTPSA id bg2-20020a05600c3c8200b004149530aa97sm3093474wmb.10.2024.04.04.08.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 08:17:30 -0700 (PDT)
Message-ID: <6c35748b10daff12205b778c0d8f55565410aa7c.camel@suse.com>
Subject: Re: [PATCH 07/11] 11-dm-mpath.rules: replace DM_SUSPENDED by
 .DM_SUSPENDED
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>
Date: Thu, 04 Apr 2024 17:17:29 +0200
In-Reply-To: <ZgNcEA-pxlpvqqr6@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
	 <20240324211301.7200-8-mwilck@suse.com>
	 <ZgNcEA-pxlpvqqr6@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-03-26 at 19:36 -0400, Benjamin Marzinski wrote:
> On Sun, Mar 24, 2024 at 10:12:57PM +0100, Martin Wilck wrote:
> > With the late changes to the device mapper rules, DM_SUSPENDED
> > is not exported any more. Use .DM_SUSPENDED instead.
> >=20
> > Note that although 11-dm-mpath.rules is not a part of lvm2, it
> > can be considered as part of the device-mapper layer (everything
> > before 13-dm-disk.rules can), and is thus allowed to use
> > .DM_SUSPENDED. In practice .DM_SUSPENDED is equivalent to
> > DM_UDEV_DISABLE_OTHER_RULES_FLAG for multipath devices, but
> > using .DM_SUSPENDED here makes the intention more obvious.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0multipath/11-dm-mpath.rules.in | 13 ++++++++-----
> > =C2=A01 file changed, 8 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-
> > mpath.rules.in
> > index 8f22954..c4b5685 100644
> > --- a/multipath/11-dm-mpath.rules.in
> > +++ b/multipath/11-dm-mpath.rules.in
> > @@ -4,8 +4,11 @@ ENV{DM_UUID}!=3D"mpath-?*", GOTO=3D"mpath_end"
> > =C2=A0
> > =C2=A0IMPORT{db}=3D"MPATH_DEVICE_READY"
> > =C2=A0
> > +# device-mapper rules v2 compatibility
> > +ENV{.DM_SUSPENDED}!=3D"?*", ENV{.DM_SUSPENDED}=3D"$env{DM_SUSPENDED}"
> > +
> > =C2=A0# Coldplug event while device is suspended (e.g. during a reload)
> > -ACTION=3D=3D"add", ENV{DM_ACTIVATION}=3D=3D"1", ENV{DM_SUSPENDED}=3D=
=3D"1", \
> > +ACTION=3D=3D"add", ENV{DM_ACTIVATION}=3D=3D"1", ENV{.DM_SUSPENDED}=3D=
=3D"1", \
> > =C2=A0	PROGRAM=3D"/bin/logger -t 11-dm-mpath.rules -p
> > daemon.warning \"Coldplug event for suspended device\"", \
> > =C2=A0	ENV{DM_COLDPLUG_SUSPENDED}=3D"1", GOTO=3D"scan_import"
> > =C2=A0
> > @@ -17,7 +20,7 @@ ENV{DM_UDEV_RULES_VSN}=3D=3D"3",
> > ENV{.DM_SUSPENDED}!=3D"1", GOTO=3D"scan_import"
> > =C2=A0# from DB in 10-dm.rules. If the device is not suspended, clear
> > the flag.
> > =C2=A0# This is safe for multipath where
> > DM_UDEV_DISABLE_OTHER_RULES_FLAG is basically
> > =C2=A0# equivalent to DM_SUSPENDED=3D=3D1 || DISK_RO=3D=3D1
> > -ENV{DM_UDEV_RULES_VSN}!=3D"3", ENV{DM_SUSPENDED}!=3D"1",
> > ENV{DISK_RO}!=3D"1", \
> > +ENV{DM_UDEV_RULES_VSN}!=3D"3", ENV{.DM_SUSPENDED}!=3D"1",
> > ENV{DISK_RO}!=3D"1", \
> > =C2=A0	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=3D"",
> > GOTO=3D"scan_import"
> > =C2=A0LABEL=3D"mpath_coldplug_end"
> > =C2=A0
> > @@ -68,7 +71,7 @@ LABEL=3D"mpath_action"
> > =C2=A0# Activation might have been partially skipped. Activate the
> > device now,
> > =C2=A0# i.e. disable the MPATH_UNCHANGED logic and set DM_ACTIVATION=3D=
1.
> > =C2=A0IMPORT{db}=3D"DM_COLDPLUG_SUSPENDED"
> > -ENV{DM_COLDPLUG_SUSPENDED}=3D=3D"1", ENV{DM_SUSPENDED}!=3D"1", \
> > +ENV{DM_COLDPLUG_SUSPENDED}=3D=3D"1", ENV{.DM_SUSPENDED}!=3D"1", \
>=20
> When I reviewed patch 0001, I wondered if it was o.k. to not force
> DM_ACTIVATION to "1" if a device had previously been suspended when
> MPATH_DEVICE_READY switched to "1". I thought it might it might be
> o.k.
> because there would be another event when the device resumed, which
> would have DM_ACTIVATION set to "1". But if that's the case then we
> shouldn't need to worry about a device being suspended when a
> coldplug
> happens. We will get an event when the device resumes, and there's
> not
> much we can do until it gets resumed at any rate. So either patch
> 0001
> is wrong or we can remove this DM_COLDPLUG_SUSPENDED forced
> activation
> code or I'm missing some important difference between the two.

I tried to explain this in 02bbc17 ("11-dm-mpath.rules: handle reloads
during coldplug events").=C2=A0But I just needed to recall the logic again
myself, it's subtle.

We will indeed get another change event when the device is resumed.
But because of our MPATH_UNCHANGED logic, we may see that the
the properties of the device haven't changed, and unset DM_ACTIVATION.
Thus follow-up rules won't get executed, neither in coldplug event
itself (device suspended) nor in the follow-up change event (device
unchanged). I hope this makes sense.

The problem that you pointed out for 0001 for this series is similar,
but it handles a different case where the device switched from 0 to one
usable path while the device was suspended. Patch 0001 of this series
is really broken, and it breaks a patch that I'd just created a month
ago, which is truly embarrassing. udev rules are confusing :-/

Regards
Martin

