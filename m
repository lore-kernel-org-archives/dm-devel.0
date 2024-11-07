Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D996518C33B
	for <dm-devel@lists.linux.dev>; Thu,  7 Nov 2024 18:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731002612; cv=none; b=FHVih6pltLfTd0QubMEqotmargkNf698VdYCrLsy81NtTSOV/KSS3xD/CCrpbHQCpeg7J8wzUccDYZ6B/hIuotcR8gWo47AvLgVKcbPdbysU8tN/QepPKERU19XjfMrqIrP+75bzt+WVklbDPV9rUHVA96Ywwhl4NYQ0D3+p4bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731002612; c=relaxed/simple;
	bh=VYm5AxNwaw0wRIcaAs33xK3SJn+IolgL4IN0fkxJnkg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A4CwRHDBWndDnRvldTVniIYmDv282yOYN25WpV6Iwroz8M5VjSZDtv4BalEWUzq6vEEGqTdsLtd1R9Mcti81tgPdIvFl77z09ThyDj2hVWfgL/dhtdmMRjqVTGFQKpLhoZdtGRw3c/So2d96r/14SgzM4i93ewjAUHw/vpdqVlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UJnR5Dke; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UJnR5Dke"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-37d4ac91d97so1110549f8f.2
        for <dm-devel@lists.linux.dev>; Thu, 07 Nov 2024 10:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731002608; x=1731607408; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VYm5AxNwaw0wRIcaAs33xK3SJn+IolgL4IN0fkxJnkg=;
        b=UJnR5DkewEONlDTDQ0I2MvSg0QEkJ/iU3TCtTUUKmsUCNetyFIdFo4gH6QdSB45qzs
         8v3T0LmEPQ+zdYJn4OszJdxSqAYKUxGGDNh4VpmI1zS8KR2/lw7myVExxj++RYiKKzQr
         4TG9VdC5N0EoDQKJ9vPvHHkpZVDIAEV3Tr3JPYf5+YBnOLhTaKDYgdUNMQInyxC3hIwD
         ZH06CbWHPdZNNH2j6BqyJ1NZ443dIsmzFN7oumbnePO5dsH+oKLoru5rHXupr/V4aUJC
         T2luR+/CZ0rgaoCa/1w8QDPlpmDmsd/SXm4L/sbrWxd4nGZJrGWbfIdf61xKHzD255rt
         MwSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731002608; x=1731607408;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VYm5AxNwaw0wRIcaAs33xK3SJn+IolgL4IN0fkxJnkg=;
        b=kNgG3IDj4tB/dt2+G8My6DrAeQWMJnjobEkFLgdMp97MR2pGefI5eqsEaDo1Dkp3dS
         u0NIyz7wrV/sBLVbXnUd8EBbLQnovePjW5wig7fpxO7mahl1doWXpROK/FCr1KC+nnbY
         7ycqosOsjzGSXg0HaAbpD/KrMFwkloMPHbfzXS3TcKNGSQofu4hg8kyVsmQto6dAiF3O
         VNZLNxMstzAPwQvMHQHffFSChaSuPmXYOaSvqmRaJsK/pE9bR3Keqy2c4ko9Zxb1JpoN
         f2XyN+VOjo7qTkWZIcUBkh0jOgWeDVqRCTuF/HbJB1qB9uuNNyf2AG9oS+Ur+9pPB/yd
         z3QA==
X-Forwarded-Encrypted: i=1; AJvYcCUPpUUOJJihTGDHY8QGlHKBadFbSLOedNUJOTdACMHHEU+w/EMIykzOtvGzxuYNw2SxCybMf6ez1w==@lists.linux.dev
X-Gm-Message-State: AOJu0YyEJwqYMymTSFwLCsgNuh1N/Hn6AP/HN2gcPSMFx3GPnhC1MqsB
	VRlpA7p20QXbbScJdPRd7m4dxu0f6iIcfF9FYk0eIwG4MkQFqB4wx5qSd1ivISg=
X-Google-Smtp-Source: AGHT+IHXkgS/yiSAHvJXR/4OyuvhTQ1MKGF871uPGY0xs4zuxiLFfUFan7U8AkXnqroR2RH9iq0y2g==
X-Received: by 2002:a05:6000:460f:b0:37d:542a:7995 with SMTP id ffacd0b85a97d-381f1872cc6mr42732f8f.34.1731002607692;
        Thu, 07 Nov 2024 10:03:27 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0e2d979sm128183666b.181.2024.11.07.10.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 10:03:27 -0800 (PST)
Message-ID: <23ab01b7506de5d32d21796dd08ed91678fab55b.camel@suse.com>
Subject: Re: [PATCH 0/8] multipath fixes to tableless device handling
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Thu, 07 Nov 2024 19:03:26 +0100
In-Reply-To: <Zyz9Xm-AAIBwSjqf@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
	 <151dbbdc7bfcd4dd0668bf5d9289f725cf92da28.camel@suse.com>
	 <ebbf8fe4ef7500d2ab1e6f73a041b8b0ba75e4a4.camel@suse.com>
	 <Zyz9Xm-AAIBwSjqf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-11-07 at 12:48 -0500, Benjamin Marzinski wrote:
> On Wed, Nov 06, 2024 at 11:39:38PM +0100, Martin Wilck wrote:
> > On Wed, 2024-11-06 at 17:52 +0100, Martin Wilck wrote:
> > >=20
> > > For patch 1-6 of this series:=20
> > > Reviewed-by: Martin Wilck <mwilck@suse.com>
> >=20
> > The series breaks some unit tests. I can fix that.
>=20
> Oops. I'm going to do some more work on this patchset, so I can fix
> it
> myself.

Have a look at my "tip" branch, fixes are already applied there.

Martin

