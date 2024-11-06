Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E442036EB
	for <dm-devel@lists.linux.dev>; Wed,  6 Nov 2024 16:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730911937; cv=none; b=nWArw9t3+5giJV+BN203ANxtXjL4D84Ts2JBckpSevYlIVb6moOhO855ft7jX3ZHpCZjVlkgpVXPw+GYimmODtpkKeuLh8fwG1YD1jeMq0mVwb9+7XRaPoVPKuP38PDvz3gZ+4Bxznn9F+HuH3C9xMn44KD3YVp+SilGUssAx50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730911937; c=relaxed/simple;
	bh=ykAQKaRM8j3sUXyyHBgTSllaN3qEH+2n/oKiPAPViyI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gJFDVbsHurmt8lZf8BmiVJED6QO3RWU8WVE5edIb1xk6iyM4e4fmVVJY8Tfie7K5+Udohj9fdssq2vbSOrdxc9+nz7ZuT/ySFJhY2elgHJK9+g+3fFbfjGQ+4ZyAF0oDjFJlC7g2oqBO8gyez4Lap/U4jiVmKr1ObGhtd8YBZsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bII7S26D; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bII7S26D"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a99f646ff1bso958085466b.2
        for <dm-devel@lists.linux.dev>; Wed, 06 Nov 2024 08:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730911932; x=1731516732; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ykAQKaRM8j3sUXyyHBgTSllaN3qEH+2n/oKiPAPViyI=;
        b=bII7S26DMWOe+4EPu1kWxpeewCCIt4eeCTa34LPuKaJzxOqf8Em72WRUH4k4c3tuOQ
         iss0TVT6U+dV9c/97RGyfqKYHDOl0cvdg9Id/mkW00vU5MqymAFhFKeHSIhEXsiqK6Xj
         eGcl2aJhe5AaLOFNAAF1lmawShfZlkDfkZlFZUosDnImby4FwMqZjpSgDc6s8pqevf7a
         XdmqfrtGsZHc1IvDauyau1EmWSxWlJRl7qPW/XIfbBtVJ4JMk5xrWrDSLPr6LMoDTkuN
         aj5SQSma7vbx8VLUQYALqzoHvnhIJpcMW06cl1yPVJWTvwrMEB0gSDZ1Mak4JhFeyrsm
         xqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730911932; x=1731516732;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ykAQKaRM8j3sUXyyHBgTSllaN3qEH+2n/oKiPAPViyI=;
        b=MnYSG5ivYwUbtaqYfPhGE5Go7Ddk9Nmx3h0+9DlLKGT3Ok6lvH6dw8s/g4vTgSHCCk
         OEFEyprQtcgSo2C2JeIWzac25uGYhx6aYcssy+KkjKExZp8WxPYiDQmudmBSS0c7RH7t
         +FFC/OeQIqCaxUfYPxQSiVR6zzNuVMIKCM3TVSqrktwVss24HyUWgbn1rJub2F9uaV0Q
         TlS10+vwmaOtl4mijm6qSPVEsgWY3GbGIxAA4tEh3RhtlD/DunxWGBL100wTLsROzCW0
         GmMEN2dMjMU31EqGl+7KYyYl7G5+nIXOlnGRAxhoyNxz8DlGNzl5t3fUCcgJVHn385PI
         QGwA==
X-Gm-Message-State: AOJu0Yz4qiuhNCPlFFHMfeBKFhnHZh7fIqYCIDnd56R972P4XOwEV6Pe
	nrfwtgL+sysenTArejQOU1MEDG+a49gOePDFEU0RBsI/V6vlLtjATRhUvJFV+CE=
X-Google-Smtp-Source: AGHT+IHsmEGgGCEoAh3LEy+3DC0H1/iBGwPNMCzAoIhxJq7vtxpp3C7sEJOj2F3FIStHbvgVTQFMXg==
X-Received: by 2002:a17:907:2d26:b0:a9e:b610:409c with SMTP id a640c23a62f3a-a9eb61043f7mr710528666b.48.1730911932273;
        Wed, 06 Nov 2024 08:52:12 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb16d6620sm304982666b.54.2024.11.06.08.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 08:52:11 -0800 (PST)
Message-ID: <268bc68ab339ff6d6546f836329ee673fe734458.camel@suse.com>
Subject: Re: [PATCH 0/8] multipath fixes to tableless device handling
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 06 Nov 2024 17:52:10 +0100
In-Reply-To: <20241031183301.391416-1-bmarzins@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-10-31 at 14:32 -0400, Benjamin Marzinski wrote:
> This patchset include a couple of miscellaneous cleanups, but is
> mostly
> in response to issues brought up in
> https://github.com/opensvc/multipath-tools/issues/100
> It adds auto restarting to the multipathd.service unit file. I'm
> fairly
> conflicted about the correct limits to be placed on these restarts,
> so
> if anyone has strong opinions and a good argument, I'm more than
> willing
> to change them.
>=20
> The bulk of the changes deal with how multipath handles devices
> without
> any table. Multipath was supposed to delete these if they were left
> behind after a failed device creation, but that code was broken.
> However devices aren't typically left behind after failed creates, so
> it
> didn't matter.=C2=A0=20
>=20
> A bigger issue is that multipathd and multipath could fail if
> tableless
> devices were present. With this patchset, they will simply ignore
> tableless devices that don't have a multipath prefixed DM UUID. The
> last
> patch is a RFC patch that changes the behavior for tableless devices
> that do have a multipath prefixed DM UUID. It makes multipath remove
> these devices on the grounds that they are likely failed creates.
> However, looking at the libdevmapper code, I'm not sure that we
> actually
> want to do this.=C2=A0 When a DM_DEVICE_CREATE task is run, it will first
> create a tableless device, and then immediately load the table and
> resume the device. So it's possible any that tableless devices which
> multipath sees are actually in the process of getting created. I left
> the patch as part of the set, but I'm not sure that removing the
> devices
> is the right answer here. I haven't ever seen any tableless multipath
> devices lying around (and I couldn't force any to get created when I
> tried). Unless other people have seen these, then I don't think the
> final patch of this set should go in.
>=20

Does it do any harm if we just keep these devices around?=C2=A0If there are
path devices around with matching UUIDs, the right thing to do for
multipathd would be to reload the map's table with an appropriate
multipath target. Otherwise, the map will just float around empty and
do no harm. This is how multipathd 0.9.9 and earlier behave, and
I see no issue with that.

It'd be much worse if someone created a table with an mpath-style UUID
and name but an incompatible immutable target type. But in that case,
again, we should probably just keep our hands off that map.

Martin

