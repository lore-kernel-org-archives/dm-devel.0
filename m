Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0419219ED
	for <dm-devel@lists.linux.dev>; Wed, 20 Nov 2024 08:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732092683; cv=none; b=jUdqqYe0uMIF8qlfoi+nz1/6hpTanAHT4qYu3KHjwb94A5YuMtYSqG6dfvY61H3G+NVwQuQkeY5MBQfhexN/71XZ+wb+xregL/YTQCvrQIKAoyYg3AgzcBO5hPtZWcRPnWSV3f95dSIxj5p3Ip8cu3GDFQ/PGitPs9kLuu1s70w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732092683; c=relaxed/simple;
	bh=gsjqxlDBPjgkOxPu2NRl4UR1JjRgL14coHx21EzqML8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MGkZGBgBRolLQS5YPMjcYwT/fxJSmpZNOtnMnbjKyy9H7Lq0h3NDQUjxbR1F10fhOZbccLubhgm4XOU1sTSjfG7fo6r9drP1o1HwJY4O1wqrV2yYIE1uPaU79DK6xbyvHHp9EU34oSt4lgHixrqL47gKOONkV86hk/E999P2kzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UW5KT2xk; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UW5KT2xk"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43167ff0f91so46783475e9.1
        for <dm-devel@lists.linux.dev>; Wed, 20 Nov 2024 00:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732092678; x=1732697478; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gsjqxlDBPjgkOxPu2NRl4UR1JjRgL14coHx21EzqML8=;
        b=UW5KT2xksjRBHZo/dS5C8a0U9mBWfsXnjNRr1EWsiJKAbBNZopxhx7+wY1H4BZTeIa
         QuFAnGSj7linkN8V/h5jcP312w0A5th96kkfPHwZFwAogZqMDV9HVJPKzSt2dPSqxCGr
         qnUdlNb9mBNBokQC+jSLNii32wvpdxlIYX0wLgQ15UehCH2pp+6adDHuEi7P4kgzY8wK
         At7hesMYnmWH4ey3urW5cLklD+OPlOyWGc6E/eVcGpKvZRrvamumMCUOTr7Y97Wv/lp7
         IbvhQaMv8qSI0x/0daYg1MFZfl0WmxQWfxesSBwfUx/aK4rG4tjxYhL/xnk2yj8FQxTL
         dauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732092678; x=1732697478;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gsjqxlDBPjgkOxPu2NRl4UR1JjRgL14coHx21EzqML8=;
        b=TMq9h5t09TScfkbg3+luq0S2PcHaR5G3v9tpeAA6WXWL1oDbdEEcLUByrIWC5JtxG5
         gmpjm+5PZl0CMs+JuBcs0PVEYZGNK602fG8pr/6dVRGBrwYLMumRVd1TtYpMkvAGMeqT
         FKMdNcPsffhUkCtEDhP+mePQEDjXo1khaLK4mT6UzgcNEHZdHBD1d5/PaH710SWeez0N
         ltpa6cK3mtzzL/BNVKf1+GFJI7qt5sYrLvpbXszm2BMMBVXkJduIEU2ohK7ymU686/JS
         Cs0yzrFmRF7UaFuqA9fgeynqiUollzy/zHC4KhmaJQ/ZHUJTvC1plWNNVCO6GHMfSoZ/
         g9vA==
X-Forwarded-Encrypted: i=1; AJvYcCXxGPJAcH6utoAo9LbBzAePsyp7Bdrb29VkR1ZB3TVgH+7ru15BIGURFq5sJ5xB2dB/FTzqVk5Mew==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/VwIY9IGRWhcV8JfU6JpjLzwldAP8iuNIbGHZOQyUmUYrBJQ1
	bu9ceSZurUdA6SrU7+KSF6hXRFl3nQ3l5CObfJFghkQtglUn2Y1YXsF9YWyCoI+6A7VbDYxL1gt
	J
X-Google-Smtp-Source: AGHT+IFGrj4G9weywtFLf2guO1uFKdQcts+UvbQjQrId25ZBDDxpn0OHuQar/ceieBfHZlMylV8qkw==
X-Received: by 2002:a05:600c:524d:b0:431:4f5e:1f61 with SMTP id 5b1f17b1804b1-433489b599cmr17539975e9.14.1732092677605;
        Wed, 20 Nov 2024 00:51:17 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-433b45d1d09sm11635725e9.4.2024.11.20.00.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 00:51:17 -0800 (PST)
Message-ID: <82668d7b5aec590e92f89cf13933476eed9f9b01.camel@suse.com>
Subject: Re: [PATCH 0/6] multipath-tools: Handle tableless DM devices
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Wed, 20 Nov 2024 09:51:16 +0100
In-Reply-To: <ZzzjTcBHm2T5AXQu@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
	 <fbab2026d6850617f84da01c9c075f468295aa3b.camel@suse.com>
	 <ZzuuUTMJgFPWV16s@redhat.com>
	 <23860ac02355acab86798e2ce3d582ebed61a0d6.camel@suse.com>
	 <1a516ff0aaf34d88da065a1f504606450eb871bc.camel@suse.com>
	 <ZzzjTcBHm2T5AXQu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-11-19 at 14:13 -0500, Benjamin Marzinski wrote:
> On Tue, Nov 19, 2024 at 05:40:19PM +0100, Martin Wilck wrote:
> > On Tue, 2024-11-19 at 13:20 +0100, Martin Wilck wrote:
> > > On Mon, 2024-11-18 at 16:14 -0500, Benjamin Marzinski wrote:
> > > > On Mon, Nov 18, 2024 at 12:18:20PM +0100, Martin Wilck wrote:
> > > > > On Fri, 2024-11-15 at 18:22 -0500, Benjamin Marzinski wrote:
> > > > > >=20
> > > > > > I'm not completely happy with the MAPINFO_ID_IF_FOUND flag.
> > > > > > An
> > > > > > alternative would be to run a second libmp_mapinfo() call
> > > > > > without
> > > > > > MAPINFO_MPATH_ONLY to grab the name, if the first failed
> > > > > > with
> > > > > > DMP_EMPTY.
> > > > > > If people think that's a better way to solve this, I can
> > > > > > rework
> > > > > > those
> > > > > > patches.
> > > > >=20
> > > > > We could simply choose to always fill in this information if
> > > > > the
> > > > > the caller has requested it, without an additional input
> > > > > flag.
> > > > > It's
> > > > > not
> > > > > an expensive operation.=C2=A0Is there a reason not to do this?
> > > >=20
> > > > Your comments in the code said that libmp_mapinfo() will not
> > > > touch
> > > > any
> > > > of the output parameters if it doesn't succeed. I didn't audit
> > > > the
> > > > code,
> > > > but I can certainly imagine a situation where you passed in
> > > > pointers
> > > > to
> > > > some varaibles that already had values and you didn't want
> > > > those
> > > > values
> > > > overwritten unless libmp_mapinfo() returned DMP_OK.
> > > >=20
> > > > But I can go look and see if any callers would get messed up if
> > > > name
> > > > or
> > > > uuid got set, even when the found device didn't match.
> > >=20
> > > I am pretty sure that that shouldn't happen. The memory must be
> > > allocated anyway, and callers can't ignore the return value. But
> > > double-checking is a good idea, of course, and we should adapt
> > > the
> > > documentation.
> >=20
> > I just looked through the code. Except for the unit tests, I only
> > found
> > one call where this matters:
> >=20
> > dm_find_map_by_wwid() fills in the name if non-NULL. This is only
> > used
> > by cli_add_map(), where it doesn't cause an issue.
>=20
> Yep. In my patch that adds MAPINFO_ID_IF_FOUND to
> dm_find_map_by_wwid(),
> I even use the returned name to print out a better error message.
> Which,
> BTW I noticed that mpath_get_map() also does, even though we haven't
> been setting name on DMP_NO_MATCH returns, so this has been broken.=20
>=20
> I was also wondering if we could do the same thing with info.dmi,
> since
> that will also be set whenever we find a device, even if it doesn't
> match the type of device we're looking for. The only problem with
> that
> is that update_multipath_table() would then set mpp->dmi even on
> DMP_NO_MATCH or DMP_EMPTY. Now, if update_multipath_table() returns
> one of those values, something is already very wrong. But even still,
> I think we should not overwrite the existing dmi value. Of course
> it's
> simple to just create a tmp dmi variable, and only overwrite the
> mpp->dmi on DMP_OK.

Absolutely, yes. Do we have use for the dmi information in cases where
there's no match?

> I should note that just removing the MAPINFO_ID_IF_FOUND flag won't
> remove most of the complexity of ("libmultipath: Add flag to always
> return device ID when found"), since most of the code exists to make
> sure that the other output variables aren't updated if allocating
> space
> for the status and target outputs fail. This means that no outputs
> are
> ever touched when we return DMP_ERR.=20
>=20
> If we don't care about that, and just say that the uuid, name, and
> dmi
> output parameters may be overwritten regardless of the return status
> of libmp_mapinfo(), then we can set those values as soon as we know
> them, and most of that patch becomes very small. I'm not sure if it
> really matters one way or the other.
>=20

I like this idea.

Martin

