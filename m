Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671D01DE896
	for <dm-devel@lists.linux.dev>; Thu,  7 Nov 2024 12:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982015; cv=none; b=CNAgfOFyNH9ebUiwU8ic/z+lGnQbQuCijhg5sREUeO6O4C2A5JRTtFsfsOsvxBZqv376kEQMzTOT8Mn1TbBuy4RQqwZQHhA+8dV/yrXUQo3Yw4B7+2XvgBTtCHfh5kMlTg8weUoFLf6mDdZW0Q5B8UqmOx1cEYvFQSSelqgyHAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982015; c=relaxed/simple;
	bh=TpZ49yt3H1suvKBAm4WjJ34GC/OsRCM/UjtuLKxVTxo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nQ1fu3ReW0VFIpJbbmCoVS4EkphBRcQhXNwjBV/H/ysFJOaZCpvH2LqQrYbWkyZIajMYk4YAsSnwtE9WqFkmEoHJ2e0aE/hp5YB9mFMYH1BaMb4Xuk/Gw3zqlvA7yxrZYEIbQWzPc70+soqh2IusshSFza7npNDcfxSH9zyy6rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=c09ZCLev; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="c09ZCLev"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5cedea84d77so1361992a12.1
        for <dm-devel@lists.linux.dev>; Thu, 07 Nov 2024 04:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730982012; x=1731586812; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TpZ49yt3H1suvKBAm4WjJ34GC/OsRCM/UjtuLKxVTxo=;
        b=c09ZCLev7l6jAuaohnX3PtAK7uO8OwCqLezaZ3/yLbk2oXd6igw+iiJndKsIB97GOF
         Y7FwSJiFQzxp5RrcCvRNu4QMk/9rZjVQMZx4AF267NbVRkuJ6+/2TL6oe3Eun+zpINzF
         +rgtFChrJxfNpzj2vkjEXds1WYifaflAls9QVG30SIBGVAtbmJ9gWURiFceTO1zEA///
         zxffzh6cXcqOeAbzzVfZnC0o3W+28W7qiT9OOszX6m+MohLD6ily/pLpwmuJgjjrmdx9
         /MjkMtQ94o+SyZkOgCQ+JThekIuNKXC0k3GAtExzz85XYsDeaj6cOi/QLmPq2FL3KphA
         FXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730982012; x=1731586812;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TpZ49yt3H1suvKBAm4WjJ34GC/OsRCM/UjtuLKxVTxo=;
        b=a+IzXBw8tttvn22uBvFlW1KacLp39jyiTlpgvfvkDBBT3K8UAb2fJoAMMjgzxpVfC7
         FqJO0Y+HQjbOW7E8Un5k9k1WPIDxw8noaT+ticei1ecv3441awHg96H70+Qsv08fKqDV
         HdnoAcqyIMeLjXbONFppzjRnN86nuNdvzvUZ4vnKXfEYu5jXStcxP1nTkg+7GVNhfCRz
         h1SIP53lzUj+8KjDWx2HIdcKlYYN7K8FccAgZNc8shcOEyvvAKodS+c2TpAD2z5oZDS0
         vhFFEXuqLg2jcXMDdipOGcIKeTorMf3acVJW4YmpxgBgfX4ofJdQDNqwa4dqA3GERTkE
         6m0w==
X-Gm-Message-State: AOJu0YxFs2vk1mPeE5euh6oDToQjoVeN2LGpXmghkipcJR2j6sMhkFu2
	jiNg9f7q9sGjIgR2p5hHm0PMKVgDIKprAZo+mYjZIoDrijThHolYAqNi982OQIw=
X-Google-Smtp-Source: AGHT+IHHSmb3FRi9xSw7uKrr6xXL3+6i6hDWIsXOLFOna2N9qlDWqxjsFootQnvS3SmwQjxhExQWfg==
X-Received: by 2002:a17:907:5cb:b0:a99:f3fb:f88e with SMTP id a640c23a62f3a-a9ee7547d58mr72273566b.41.1730982011377;
        Thu, 07 Nov 2024 04:20:11 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0dc4c55sm84895866b.130.2024.11.07.04.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 04:20:10 -0800 (PST)
Message-ID: <bc44c44523af9f1014c6e96842371bce422f18a7.camel@suse.com>
Subject: Re: [PATCH 0/8] multipath fixes to tableless device handling
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 07 Nov 2024 13:20:09 +0100
In-Reply-To: <268bc68ab339ff6d6546f836329ee673fe734458.camel@suse.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
	 <268bc68ab339ff6d6546f836329ee673fe734458.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-11-06 at 17:52 +0100, Martin Wilck wrote:
> On Thu, 2024-10-31 at 14:32 -0400, Benjamin Marzinski wrote:
> > This patchset include a couple of miscellaneous cleanups, but is
> > mostly
> > in response to issues brought up in
> > https://github.com/opensvc/multipath-tools/issues/100
> > It adds auto restarting to the multipathd.service unit file. I'm
> > fairly
> > conflicted about the correct limits to be placed on these restarts,
> > so
> > if anyone has strong opinions and a good argument, I'm more than
> > willing
> > to change them.
> >=20
> > The bulk of the changes deal with how multipath handles devices
> > without
> > any table. Multipath was supposed to delete these if they were left
> > behind after a failed device creation, but that code was broken.
> > However devices aren't typically left behind after failed creates,
> > so
> > it
> > didn't matter.=C2=A0=20
> >=20
> > A bigger issue is that multipathd and multipath could fail if
> > tableless
> > devices were present. With this patchset, they will simply ignore
> > tableless devices that don't have a multipath prefixed DM UUID. The
> > last
> > patch is a RFC patch that changes the behavior for tableless
> > devices
> > that do have a multipath prefixed DM UUID. It makes multipath
> > remove
> > these devices on the grounds that they are likely failed creates.
> > However, looking at the libdevmapper code, I'm not sure that we
> > actually
> > want to do this.=C2=A0 When a DM_DEVICE_CREATE task is run, it will
> > first
> > create a tableless device, and then immediately load the table and
> > resume the device. So it's possible any that tableless devices
> > which
> > multipath sees are actually in the process of getting created. I
> > left
> > the patch as part of the set, but I'm not sure that removing the
> > devices
> > is the right answer here. I haven't ever seen any tableless
> > multipath
> > devices lying around (and I couldn't force any to get created when
> > I
> > tried). Unless other people have seen these, then I don't think the
> > final patch of this set should go in.
> >=20
>=20
> Does it do any harm if we just keep these devices around?=C2=A0If there
> are
> path devices around with matching UUIDs, the right thing to do for
> multipathd would be to reload the map's table with an appropriate
> multipath target. Otherwise, the map will just float around empty and
> do no harm. This is how multipathd 0.9.9 and earlier behave, and
> I see no issue with that.

Thinking about it, I believe we should actually accept devices that
have an mpath UUID and an empty table, and add them to our mpvec. We
should treat them like devices that have a multipath target but no path
devices. If any matching paths become available, the map will be
reloaded and the issue will be fixed. IMO, this is less prone to race
conditions than trying to delete and re-add the devices.

Martin

