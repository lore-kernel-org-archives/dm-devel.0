Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047E8269B0D
	for <dm-devel@lists.linux.dev>; Mon, 28 Apr 2025 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745848597; cv=none; b=FUmwWAAf5TfVNTCnG0MrldleSzRsNY9fJ9wzyYV4RMs/TodJJb+jFb+/P5Wj2HSWcyV72zSK5zjOVGWdxv21NbUzuSTL/Heb1FB2uGVNHg0DkYewbBBxxEGSCErEhwQfnGOTJLTYX10k/5QSCQET5ZCK+mQSz7jfU8ux5yCT4kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745848597; c=relaxed/simple;
	bh=oJxjse2ZG6+4GVHEB4xWReeVb9qkIOIEpaMbuv08WtM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Csl5cOZTItpT7wwVY+ystg/JQwkN70YJh9VwlZ5zXsXxJJ2pR+hAjUumuYIgJ27VKdX4CymtdfCcyqVKFL6ppFsbLlalPPAhuu96CaP1U30gZx4Po6cWt3xujOS4wC5nZD3GmY/1CMs47CxjfQA3X+B5V70btXzBv+geUzmbOdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=S9je30Lp; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="S9je30Lp"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-39129fc51f8so3239908f8f.0
        for <dm-devel@lists.linux.dev>; Mon, 28 Apr 2025 06:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745848592; x=1746453392; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oJxjse2ZG6+4GVHEB4xWReeVb9qkIOIEpaMbuv08WtM=;
        b=S9je30Lp4QYwtAGb9SN7l8eP/fy0Yslv1L8Em1xG3zpp/hYqtaIU3V87Dg+6duYpaX
         8ngNixNUxtq8a6Odz+diO8aPBzEcY3PPHI74EnXt9WWb0tniprWuwESBAPaCSfGQfKcJ
         ZKGy7Qrr+hdNm/8amiIiK/4ueS9t27c0zsI7hTijfgfrdoRJ1UWQ9V1UQ6o8ncdJr402
         TirfRCZbQ20khmwpBx9034DCGuHiZud0Z2vm8l9NNi3RMOTVj170ntmgI0VhL/NtT81l
         i9XY3hRrDmbYKUp9N1z8XPWbwZsgarOFpyD6O6AgnlKPiMbOVU/m9csEPnYswkSKC5ZY
         uHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745848592; x=1746453392;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oJxjse2ZG6+4GVHEB4xWReeVb9qkIOIEpaMbuv08WtM=;
        b=TYN0eQ4yynNPFpI/UhJnawsd9ornqsgKPRTzloKbNY1Eyy+WiIigA6OPaYQO8Irkmk
         uKHUbPotjjYuuifDvOJoRY3cX9t4/IjTgJOmFNSFrn1gxwiB18aD1WJv5h1UdA9Tg0pa
         1X3887rILoWheW8MvExnJ8mqz1ysoqJsMznqUyv6nl5s9cKH3nmJUVTQ3aiKfXCZBjll
         1sHnXWpy8nD29Fhz6ZW28MVmeKellDZe5DyqLtLpm0AZ0lI7LC3bnIcHpD307FFngvUQ
         nlfQJaAZx+fzQ6L9NfohhQWCYUQrAiUfx8HwWHUROkFptgFJ9B7+gp6abgLd6SORuRTj
         AfHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWT1qekiN+GyqcnrSYXrdnVEloe+7xXlTQICAHi+ji0FBZOcl4+wDfaW1HmO0PGWBDCb0Cl5Z7K1A==@lists.linux.dev
X-Gm-Message-State: AOJu0YxhuPsD44CJBo4XzZLUui4q+TUWGGKTageqZjLHxO99cT5Ntzx6
	9RobsStTCYOPdgCTjsQnRGnyD/ObAhO+4y4DQ3eaAc620acyV1JVEWJ9eLdd52g=
X-Gm-Gg: ASbGnctcTsIT5ru8+HK9WOAV6pwWyMidfUU3p226bACn8FLuIRFijMi1Zw/R9to+IGM
	r42RpX8UphHnONpbWLLSI+fGnKVCAqvDuvMCqHiToGKIyzwGT2rDbC3KvYZpF5JDC7Vx+qArhK0
	svE9XVm/IX5n9bq/tFkE8WkeL0FrKBGa/cE0Aqqdns5i9gxNK9J6x5E0rGsUBozw5SvH8pHeKfn
	hIAEp63MDCleRHDttlUxDN8m9KtdmLXK6J5InLDreusyjnDlb/A7m7qRSU1rT249p+sAlljGn7u
	oDcTFUJY88bryw8K2Tj2CNN3I1KmwGWJ8GVsSlFTPGQ0pfcgT2Ut2i/Pfsl+dXa/l8CJPaDUYDb
	TLCpJhGFJipBn3Ae8wvOiAuazW9bCrMrPse8VWRivZ1sSmmVZansHzv4ZRxO+3K8kk62DglfT1I
	H+u7acSmdrTQ==
X-Google-Smtp-Source: AGHT+IEnoMNN5XBr7NNgBmrwXuwmgwHasLo3qHbrulxXnf+h4jO5Yg+Z7Ejl5Fi9Oejfq4o1tDtN6Q==
X-Received: by 2002:a5d:64a3:0:b0:3a0:831d:267c with SMTP id ffacd0b85a97d-3a0831d2718mr3597015f8f.18.1745848591978;
        Mon, 28 Apr 2025 06:56:31 -0700 (PDT)
Received: from ?IPv6:2003:de:3740:fd00:677a:2a06:a366:3993? (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2e00e3sm159974865e9.34.2025.04.28.06.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 06:56:31 -0700 (PDT)
Message-ID: <8eee19603086bfa303af1a3d5446693aadf64d8b.camel@suse.com>
Subject: Re: Announcement: "stable" branches for multipath-tools
From: Martin Wilck <martin.wilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke
	 <hare@suse.com>, Chris Hofstaedtler <zeha@debian.org>, Christian Hesse
	 <mail@eworm.de>, Mitchell Dzurick <mitchell.dzurick@canonical.com>, Steve
 Langasek <steve.langasek@ubuntu.com>
Date: Mon, 28 Apr 2025 15:56:30 +0200
In-Reply-To: <fe56f3f9-3db1-4627-ade6-6499c6553696@gmail.com>
References: <df3d023177dca2006b5aab4b2c4ef78fe1acf8c5.camel@suse.com>
	 <fe56f3f9-3db1-4627-ade6-6499c6553696@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2025-04-26 at 14:08 +0200, Xose Vazquez Perez wrote:
> On 2/10/25 10:25 PM, Martin Wilck wrote:
>=20
> > the multipath-tools maintainers have decided to start providing
> > stable
> > branches that accumulate bug fix patches only. We currently provide
> > two
> > branches, stable-0.10.y [1] and stable-0.11.y [2].
> >=20
> > The stable branches are meant as a guideline for distribution
> > maintainers to pick bug fixes without major regression risk. Only
> > small
> > patches that fix actual problems are eligible for inclusion in the
> > stable trees.
>=20
> hwtable patches (
> https://github.com/opensvc/multipath-tools/commits/master/libmultipath/hw=
table.c
> =C2=A0)
> could be backported, as they are low risk.

Yes, but they aren't actual, bug fixes, either, and they change default
behavior, which I'd prefer to avoid in the stable branches.

Ben, what's your take?

Martin
