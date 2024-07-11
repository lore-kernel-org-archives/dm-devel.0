Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F66E16E893
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 18:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720724353; cv=none; b=O7eM2s8SiNcrd4taBp8wKGv/VmleBbxaS0wXDmpCIl344a4rLoYgF7skp2nAH928gMbqglzNunJniVoCU8O/gujaLK76pYbqzUV+cBel7K6g4JlrMxLq1/jpQfJy+fFIaTDeggETcr5m7y464tLDVe+W0wCcOe4awNeew6xovzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720724353; c=relaxed/simple;
	bh=QjOEpAMknHS0oBseL/zud5bti+dfEJJq9nbFObYlpXM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ENAShlx1OhF3mO7ErVKTRCY6lp4pNIR8ged/nNCauCgRmlMmC3R7pinRHvRVOy/67nde33EFJ4g30UVUBqyHmAnKiPS15Bwf9gZ8Epb5Sz1eiWndMUG+GafI9yF9DPyeKk0fsjIgmlms+2nK55LNHDzYPyofBPhTsrC4zdN/UXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L2dWIThd; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L2dWIThd"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-426636ef8c9so7818305e9.2
        for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 11:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720724349; x=1721329149; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QjOEpAMknHS0oBseL/zud5bti+dfEJJq9nbFObYlpXM=;
        b=L2dWIThd9cC8Jy79QKAEBxOZw4kV6cOTBNqLRPbYTQLcpVNAwAURVDhQKbV/G3DJwe
         mcxjfT9plKj2COQKa9cm5MMdeRPUGYHEiiAydOCq+0H6N2XR0NVqEw3jlIcuDBlywQ14
         0dZlWKlKP+rdmgYivuWu5IKYf4nipdQQpnVb/77HZJViGCZJ1KAoaglM7/lloAKOYBzo
         5MWqBHzLsmEwdPK2cenC7TPFeN/7q6tF9CJRG1+jqDAaYe11lKAROAQ3V8JKK0FhRWN3
         B8x68MTt/WlAMc2OZ8rY2pKBogLcsHpRLQ8OrnVPNgietxnuRWqT/pi2ytTcOLBcBXr5
         Maew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720724349; x=1721329149;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QjOEpAMknHS0oBseL/zud5bti+dfEJJq9nbFObYlpXM=;
        b=c3Vf2VW8vTnE0dKjrrQvhOdVxTB5wCIHsnvhgWd0g21DrsHuYcN84dyUXqMN0tk/pR
         ntBMdmHqHtmpIkirtO+AYA437jUBjRfMvKhJi14xViXOpaUY8DgKqzleu8XNLgayvM+/
         uwHVUBudywNC5k081pPKV3EOe2Dhx302nb8/1XzbzeAfNIPeOpnr4oDe2eGSCm8GI8rd
         yVzZ+38Tk1cKJ8DoANh2+ZaoeOkN3dG+AQEhADo0VlhKI3JMqRgQZcvU9GvGZWxFMc3v
         lIk50eMOOLyScOTBmXP6A5at65DBF0mM2RSEcwO2toawEG04bAsU0YrDcRu7KkqKZwEX
         jeMw==
X-Forwarded-Encrypted: i=1; AJvYcCWg0se9A9HnAKWMpg9lyL2qzTcxmopES+Nmxis7HxH1aUQTMXMzg6VzJuwmkfrmKK0jS6GdE8kAhJ5lmoaGnlU3TiRuTjj7aww=
X-Gm-Message-State: AOJu0Yz73qpOyCfJGdo2CzHFCRfUDgLieffRjLO2YSSUnKGKgUBCCti9
	Rpo6E6L+uo9mWsFQaLRhUrpelWkFmWI3ueqGdsVZcYsbwd4bT7aKT87gsm019wA=
X-Google-Smtp-Source: AGHT+IEa5+e0drvEIT3rNO9UwpzHOXRdOUmnb0MzFJhiOckqYSaPyD0zWInLdBn6jovrCz4rCX1R1Q==
X-Received: by 2002:a05:600c:24c:b0:426:697d:af49 with SMTP id 5b1f17b1804b1-426708fa999mr67378525e9.39.1720724348602;
        Thu, 11 Jul 2024 11:59:08 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4266f6e09fcsm128283645e9.4.2024.07.11.11.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 11:59:08 -0700 (PDT)
Message-ID: <9cb85ce606afd5ab8a443a9d7c458e34e4c62bad.camel@suse.com>
Subject: Re: [PATCH 31/44] libmultipath: add is_mpath_uuid() helper
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Thu, 11 Jul 2024 20:59:07 +0200
In-Reply-To: <ZpAm3ZXvPx21XHHO@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
	 <20240709213935.177028-32-mwilck@suse.com> <Zo9TsqnZ3Zs6XD1w@redhat.com>
	 <ed5136498c6ac428a5ee25d0c3af712ba57445d2.camel@suse.com>
	 <ZpAm3ZXvPx21XHHO@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-07-11 at 14:39 -0400, Benjamin Marzinski wrote:
> On Thu, Jul 11, 2024 at 02:56:05PM +0200, Martin Wilck wrote:
> > On Wed, 2024-07-10 at 23:38 -0400, Benjamin Marzinski wrote:
> > > On Tue, Jul 09, 2024 at 11:39:22PM +0200, Martin Wilck wrote:
> > > > Export it, as it will be used by multipathd and
> > > > libmpathpersist.
> > > >=20
> > >=20
> > > This is fine. But I was thinking that if you wanted to actually
> > > add
> > > some optional flags to the flags argument of libmp_mapinfo(),
> > > this
> > > would
> > > be a good use. You could have a flag like DM_MAP_MPATH_WWID,
> > > which
> > > would
> > > verify that the device had a multipath UUID_PREFIX (and possibly
> > > force a
> > > check for a multipath target type) and then return the wwid
> > > without
> > > the
> > > multipath uuid prefix.
> > >=20
> > > Just a thought.
> >=20
> > Interesting idea. My thinking was that libmp_mapinfo() should only
> > be
> > an interface to libdevmapper, and should not interpret the data it
> > returns in any way.
> >=20
> > The only exception is the target type. In theory, the function
> > could
> > just have returned the target type, and left the interpretation to
> > the
> > caller. But then, it would have to perform several strdup()s for
> > the
> > results, and the caller would have to free() the data it wasn't
> > interested in, which would lead to clumsy and inefficent code in
> > the
> > frequent case that we're just interested=C2=A0in "multipath" or "linear=
"
> > targets. That's why I decided to pass the tgt_type field in, and
> > return
> > DMP_NO_MATCH if it didn't match, even though it's arguably odd in
> > the
> > mapinfo_t structure, which is otherwise only used for output
> > fields.
>=20
> I did wonder if it would make more sense to just pass a struct to
> libmp_mapinfo() that contained all the input data, with the flags and
> the identifiers (tgt_type just being an additional optional identier)
> grouped together.=C2=A0 But I'm fine with the exiting interface so it
> didn't
> seem worth commenting on.
> =C2=A0
> > Your flag idea would work, too (an earlier version of this patch
> > set
> > used flags to indicate which output fields should be filled in; I
> > discarded that because it was duplicated information, and more
> > elegant
> > to simply check it the respective output field was non-NULL).
> >=20
> > Instead of tgt_type, we could also pass a "filter" callback
> > function
> > with which the caller could determine whether or not it was
> > interested
> > in a given map. But I wonder if that'd be over-engineered.
> >=20
> > Whatever we eventually do, I think the is_mpath_uuid() helper will
> > be
> > useful. I am not sure whether we can unexport it even if we
> > implement
> > more sophisticated "filtering" in libmp_mapinfo().
> >=20
> > In general, I wonder what multipath-tools should do if it
> > encounters a
> > map that has "multipath" target type, but the WWID of which doesn't
> > conform to the mpath-XYZ convention, or vice versa. This can only
> > happen if another tool like dmsetup had been used to create the
> > map.
> > IMO, if multipathd encounters such a situation, it should warn
> > about it
> > and keep its fingers off the map in question. But we might also
> > play it
> > simple and just assume that multipath maps always adhere to our
> > convention. I don't think we currently behave consistently in this
> > respect.
>=20
> There was a time when there were users of the kernel multipath target
> outside of the multipath-tools. To deal with them, the idea was that
> multipathd would only manage devices that had a uuid with
> UUID_PREFIX.
> That was a while ago, and we likely have been violating that
> condition,
> but I haven't heard of any complaints. It might be worth auditing the
> code to see if/where we aren't verifying new devices.
>=20
> Obviously if we find a dm device that isn't a multipath target, we
> shouldn't do anything with it, regardless of its UUID.
> =C2=A0
> > AFAIU, both the WWID and the target type are immutable and can't be
> > altered without destroying the map completely (because "multipath"
> > is
> > an "immutable target" in DM). Thus it should be sufficient to check
> > the
> > WWID when a map is first encountered.
>=20
> Probably. Obviously, a multipath device could get removed outside of
> multipathd and another device added with the same identifier that
> we're
> using. There would be a window before we got the remove event where
> we
> would be looking at the wrong device. But I can't really come up with
> a way for this to happen that doesn't involve very creative stupidity
> on
> the user's part, and since you need to be root to do this, I don't
> see
> any security issues here.
>=20
> This isn't exactly what you're asking about but the results are
> worse,
> and I don't think there is a way to guarantee the following can't
> happen:
>=20
> 1. multipathd decides in needs to reload a multipath device that is
> not in
> use and grabs the vecs lock so no events will get processed
> 2. user removes that device outside of multipathd (and likely outside
> of
> multipath which should delegate the remove).
> 3. user creates a new multipath device outside of mulitpathd that has
> the
> same name as the removed device. For this to happen by running
> multipath,
> they either needed to be using user_friendly_names and haved removed
> the old
> mapping from the bindings file, or they need to have editted
> multipath.conf
> to set the alias of the new device to the alias of the old one.
> 4. multipathd reloads the table of the new device to point to old
> paths
> 5. user writes data to these old paths
> 6. multipathd gets the event and removes the device.
>=20
> This results in data corruption, and there's no guarantee that
> rechecking anything will always catch this. At some point we need to
> just say "Sorry. You shot yourself in the foot."

Right.

One thing we might consider is to use the DM UUID as primary identifier
for maps, rather than the name/alias. That wouldn't completely prevent
a scenario like the above, but the user would have to mess with
uid_attribute to make it happen. Instead of the WWID, we could actually
have a dm_uuid field in struct multipath.

Martin

