Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E031D230983
	for <dm-devel@lists.linux.dev>; Thu, 21 Nov 2024 08:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732179454; cv=none; b=VvWjybMwY6xIw7EYdA/ZFRMN4UVVJj5KSWRjUTsQ6aReSZoiTTcmT16B24qfs9GmbAAuLkjD5lRYqkZ0cerfrpTLkY6yxIQzdsfyL3cdHKIJoGTFVP99/bOuuRi/OXtTiSv1SdmjOVNlYtgLjueQzcKimeZ94sMoyvmyo3ahoPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732179454; c=relaxed/simple;
	bh=QLko7DnhSDzLjkCKKIcHXMzjWN3RSxz8LS7mmDNRKAw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QwH7ie0f4X+vQfSIN4wbMEBeP4lC1OlQURQZpZa5fovSLcJz1EOi4VZgZmXknNTCF6m3DVJffTqI4LqPahGu8uV+4LKl/3A5gcdmoLd3pOwthYvEXEc/D3jbzGfHl23kV5/+cg+1OkanSC7rUz9r0JDu2ioLk70SK+N84J8ELwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fv1sh3UA; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fv1sh3UA"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-432d9bb168cso9964115e9.1
        for <dm-devel@lists.linux.dev>; Thu, 21 Nov 2024 00:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732179450; x=1732784250; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QLko7DnhSDzLjkCKKIcHXMzjWN3RSxz8LS7mmDNRKAw=;
        b=fv1sh3UAREoSSgXn3RXtd72oURSaTNhMId2F8a4X0iVrNy4ga6mnjRKXW80OuOr3mI
         koe6E6gwKevVCKp2wgoE7BYd/FecU4b0y4bAKbOKB3wK1E4bJUWF7OzaPVde0q3uTeQu
         HDTSQnmFU0ACGjmRnVJOZVHC+1rhJQCJtzlZ5rUpNZq0QzU3D0dwTl/9g0PyxxCd5nH7
         XYnB2/TYJFQyD/jEg3Iw8Q/dxK/kzn+ZuRwATBybLCqLjHdyCwWtMc0ch33rRzCbhFEa
         bnZaMoeSq6oI3Da28VB+m6MzSHfstjua+ZynafcjXFql6CXGpSNYvlH8hY/jI7pmMFB2
         FKIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732179450; x=1732784250;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QLko7DnhSDzLjkCKKIcHXMzjWN3RSxz8LS7mmDNRKAw=;
        b=NrsMaOcJuKGosBF9LurqXEwKg3fXz/6KgXmwenfBBnVXigYsdFItiFSeNPBwISS+vb
         JB1pjVWJFDUIcsqzTz0NIMdePn0ralvYC1v8r5b8ag8lQwlSrkIPyQxHA4gZzV2JPQso
         4L8ShBnanYhFqoP33eeve8+c3HyJrdsjJKeMKuNHb2T8Zqr6LexHTPT6SKlq4RV2ZEWz
         MKwquwdnhM4zdKi7ozxMAaO0+KvCtJ0E6KqpKakOSv2PdlPqtlVv5wptJ6Ihdt2668no
         zPjA6wudXdPq9StxNypImDYPGw8tKo/9tZ/Un7txwGv0icIwT//lVLmQWmplxhjcAiL9
         HwVg==
X-Forwarded-Encrypted: i=1; AJvYcCVmkRtEDqWMjm7SVqtAFaSViWJbOOjNxtHxcn8p78plX8LhD1Zf0CZ9XX4D78PBr5CvJLVHyShSCQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwXdLYAYVL67w2HcKlRN+o36Tm3fKCGg/lfFw1zkdcIpOoura8O
	a2PksATtVbBfPZtXVPzbMZ5j1DMCFBE3E9qg8INsCFE8C8rJH5cBbaRB/pVSNLk=
X-Google-Smtp-Source: AGHT+IFlAXhuAn5AbyZPmXCD2pHZPiRP/ENMEqF/sjxW0OxHZwkwdoQGynuGf72tlcnC+FsDQoJvng==
X-Received: by 2002:a05:600c:4ec8:b0:431:4fbd:f571 with SMTP id 5b1f17b1804b1-433c5cca4e4mr20094225e9.13.1732179449938;
        Thu, 21 Nov 2024 00:57:29 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-433b45f9d99sm48606545e9.13.2024.11.21.00.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 00:57:29 -0800 (PST)
Message-ID: <f0bc411082a622f2cad3368be1cdc210db1fdc7a.camel@suse.com>
Subject: Re: [PATCH 1/6] libmultipath: signal device with no table in
 libmp_mapinfo
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Thu, 21 Nov 2024 09:57:28 +0100
In-Reply-To: <Zz5bxCZfCDsgMtOm@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
	 <20241115232256.627933-2-bmarzins@redhat.com>
	 <8f74ed950515b775def323b2d04fb5092ad615de.camel@suse.com>
	 <Zzz2E-UC1m8rezOH@redhat.com>
	 <b74031fd331a5825b45d4c44a5567cc7d5d96bbf.camel@suse.com>
	 <Zz5bxCZfCDsgMtOm@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-11-20 at 16:59 -0500, Benjamin Marzinski wrote:
> On Wed, Nov 20, 2024 at 09:49:17AM +0100, Martin Wilck wrote:
> > On Tue, 2024-11-19 at 15:33 -0500, Benjamin Marzinski wrote:
> > > On Tue, Nov 19, 2024 at 05:39:26PM +0100, Martin Wilck wrote:
> > > > On Fri, 2024-11-15 at 18:22 -0500, Benjamin Marzinski wrote:
> > > > > if libmp_mapinfo() is run on a device that has no active
> > > > > table,
> > > > > it will now return with a new exit code, DMP_EMPTY, to signal
> > > > > this.
> > > > > Currently all code paths treat this identically to
> > > > > DMP_NOT_FOUND.
> > > > >=20
> > > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > >=20
> > > > I just looked through the code again. I think with this change,
> > > > we
> > > > need
> > > > to modify dm_flush_map__() and do_foreach_partmaps(). They
> > > > should
> > > > remove / act on empty maps. What do you think?
> > >=20
> > > I'm not sure that we need to add extra code to handle the
> > > possiblity
> > > that an empty device could appear at any time, since like I said,
> > > this is a corner case that I've never actually seen in the wild.
> > > So
> > > if
> > > a device was previously a valid multipath device, I don't think
> > > we
> > > need
> > > to worry about the possibility that it suddenly became empty.=20
> > >=20
> > > But I can see the value in running something like
> > >=20
> > > # multipath -F
> > >=20
> > > and having it clean up any empty multipath devices. As for
> > > do_foreach_partmaps(), are you thinking about cleaning up empty
> > > partition devices or non-empty partition devices on top of empty
> > > multipath devices?
> > >=20
> > > Non-empty partition devices on top of empty multipath devices
> > > would
> > > imply that a multipath device was valid at one point, and then
> > > became
> > > empty, which I don't see an easy way of happening.
> > >=20
> > > The problem with empty partition devices is that partition
> > > devices
> > > are
> > > created by kpartx completely asynchronously to us. That empty
> > > partition
> > > device could be in the process of being created.
> >=20
> > Right, but multipathd is in the process of deleting the map. If
> > there's
> > actually a race and kpartx finishes creating the partition map,
> > multipathd will fail to remove the multipath map. The likely
> > outcome
> > will be a multipath map with just one partition device. If
> > multipathd
> > comes first, kpartx will fail, but there's a good chance that
> > multipathd will succeed in flushing the multipath map, so we'll end
> > up
> > with a consistent state.
> >=20
> > If kpartx had run a little earlier and had finished setting up the
> > map,
> > multipathd would have removed it, and if kpartx had run a little
> > later,
> > it would have failed because of a missing target.
> >=20
>=20
> If we make do_foreach_partmaps() remove empty partition maps, it has
> keep the is_mpath_part_uuid() call. Otherwise we would remove any
> empty
> partition device, including ones that aren't for this multipath
> device,
> which breaks your argument above.

Yes, my bad. There's of course a difference between "is this a
partition mapping" and "is this a partition mapped to the current mpath
device". Thanks for pointing it out.

> > > So I'm not against checking for DMP_EMPTY in dm_flush_map__() and
> > > removing the empty device if its opencount is 0. But I'd rather
> > > not
> > > try messing with partmaps. Do you have a specific case you are
> > > worried
> > > about?
> >=20
> > > From the argument above, I'd say that flushing empty partition
> > > maps is
> > the right thing to do, for consistency reasons.
> >=20
> > But now I may be overlooking something.
>=20
> How would you feel about adding a parameter to do_foreach_partmaps()
> to
> say whether or not it should remove empty partmaps (or possibly just
> checking if the partmap_func is remove_partmaps).=C2=A0 Your argument
> makes
> sense when you are removing a device. But what about functions like
> dm_cancel_remove_partmaps() and dm_rename_partmaps()? I'm not sure
> that
> these should automatically empty (a possibly being created) partition
> devices.

We're moving far into corner case land here :-)=C2=A0

I think we should keep it as simple as possible. For me, that means
that an empty partition map (with UUID matching the current mpath map)
should be treated like any other partition map with matching UUID, no
matter what the current operation is.

There will be some situations where the outcome will be suboptimal. By
keeping it simple, we'll at least be able to understand the outcome.

Martin

