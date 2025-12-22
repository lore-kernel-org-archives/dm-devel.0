Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB901252917
	for <dm-devel@lists.linux.dev>; Mon, 22 Dec 2025 14:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766414382; cv=none; b=HpMTBOmdi1KnbzTwq7dBGqODAP/Rs5oo4YWU5mDVIsU/uuc+9NthvmTf842jRoy76Gp8jNca2323JAcDnO6mOQXoNqmnFAuBdw06VA3wnMfK142E5IohioTuIbchxqHAgklMxxnIl8BAnqia7EYEbEUcbt8JYR2lT5tgwFVphhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766414382; c=relaxed/simple;
	bh=Ppj1+4whrimRRI4mguN50hIcR3wf85GY7TAZPma/VvY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BkSincGvucB7Wm2HAxNeR5sY/RVPVBpHlDJkDw2xlYYCxH+vzuBOQ+RggmjuDHpDa5q8IvOqCK38koTLLjGMOSR0yOL7P5diqhBpJ9SgkEGMKfLS4tntt17Rt3z2IAT84nZSh70iOBiGQNDgknXyLfqMwyYKmjw5tj9frByeDGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fr24.com; spf=pass smtp.mailfrom=fr24.com; dkim=pass (2048-bit key) header.d=fr24.com header.i=@fr24.com header.b=DLzDtn+G; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fr24.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fr24.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fr24.com header.i=@fr24.com header.b="DLzDtn+G"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64b4f730a02so6430244a12.0
        for <dm-devel@lists.linux.dev>; Mon, 22 Dec 2025 06:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fr24.com; s=google; t=1766414378; x=1767019178; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ppj1+4whrimRRI4mguN50hIcR3wf85GY7TAZPma/VvY=;
        b=DLzDtn+GS1hpgOUJDaoK13dSlhrarpuxajowhoLH7cvEagQCndXoEh8viEqGvz+zV2
         8swI3sOn0HngspSJh25RIRgYtwtbOj/NmF4gBYF6q4Sy5UYMkgz3BDokrmkjMXH/AcoT
         3xYiSQgdxgRUiO3PtGY9dx8g3XoYkuXC0KpdhOiJYjA2WQDnO5727faYZ1yVDRxNLHqz
         RjYTS2FmHK0DXZHUnUQHZXCagOfEJeUfdoOC4ooYeIgLfXVHvDETWFuxJAO0b6AMrK5+
         0HzgTXwuGtwUCtjSMhbIloVNMkLLp7uTdfsGlqFQ181HU07IKJm0XN8e3r0Og9dEfFjF
         WMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766414378; x=1767019178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ppj1+4whrimRRI4mguN50hIcR3wf85GY7TAZPma/VvY=;
        b=ijkbv1CtYJhB/BHhRyk3GGgMQ8n1vPLFXHturdL4Tz+fqx8Ynux4M6B+GwG8SgPuRC
         2sh5t6zZaDV7SrTKaBYTbmuFFRHyr+xEw7JHxl6d1HE8cDS/t8MuaIxxKi9GJzgpDCov
         ORTGKWRz1VCad9Yv8kF8EIOHhnccqI+fucilxgBcSR6c4VRTkIzWHrrl7jjaHRIcjWjc
         OpHtbNQsa3Bz+KssVMLmoc56VZhjvGcCLSP9nr8PqOcC0zr5i1ojDLu+CBeS0ubj8nOF
         CDWUerygFRRxSOT6S15zMRXxuFa4XhKWBZolEC02wf2dxqq6oy8emAyzjgZ0+g7K6I3k
         U+lQ==
X-Gm-Message-State: AOJu0Yzjp1eqbIEFGSKrb2xNyMmBAwUqh6BcE++oOSIs/ES2EeS9h+VJ
	A18u89p85S69RdxWqUSqHf+jMN68e03lzvbNmi1curFlJqscI2T2BgPibohxyGK1WWKTmoOYhos
	s5OkSZ3FRPa02sKH7/CPeb2IwUmoyMmMI8yOIcOl6VQ==
X-Gm-Gg: AY/fxX4LMkpIzsxX4gpSwUueHcc1jsHO62J57KFlk6/dj8wC/lIfRaBCJBEt2V1HMBF
	BdzG8yqJ/IoHPmJku+eETn3yu1w/pKH37B/huHmtIKwR3vdMhF5b4VZv7RihaM7D3IBoKA1Zy4F
	5rgkWh4tdSq9J9O6KHLPWquw1SVZmp8Pwt/BfkRk9QmJdSFSVAPaDj8kL2jWmKid67llWuj/ykP
	1U1z8eiestAoOxBK45Ty5nwuCGSerd3sckxb/kGxoQWJ9rZhnpILrA4CecRgxsWY0GehvylviUJ
	zJRpGhE4wvfBmru3IhDmRWC34163
X-Google-Smtp-Source: AGHT+IFqj0XilHYQwfvR9Uq+9WUOiijZTTZwbB+ubL54KUQ9uWTelPwAnCPfImo7xJCmPJdx24iFiOCcOg5j3r9IUdA=
X-Received: by 2002:a05:6402:5112:b0:64b:ea6b:a884 with SMTP id
 4fb4d7f45d1cf-64bea6baac4mr9981133a12.17.1766414378198; Mon, 22 Dec 2025
 06:39:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CA+mKM5kAB0_CWDU41v8=8mLp3cd6qwhuSFenjw-17wcjvshHbQ@mail.gmail.com>
 <9027c5d6-3eb6-456a-a939-24639a3e5278@gmail.com>
In-Reply-To: <9027c5d6-3eb6-456a-a939-24639a3e5278@gmail.com>
From: =?UTF-8?Q?Nuno_Gon=C3=A7alves?= <nunog@fr24.com>
Date: Mon, 22 Dec 2025 14:39:26 +0000
X-Gm-Features: AQt7F2qySS4qMB2swWutvyWzjdV4U8UpeYvIh-5h5EcxWewgkISpFlqUTUMIRzI
Message-ID: <CA+mKM5kC_rPcfOnKrvdJoDPKW3j3ATdouwrJV+Jx8kXa5u-gxg@mail.gmail.com>
Subject: Re: dm-verity issue on 6.19
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@lists.linux.dev, mpatocka@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I opened a issue with RAUC after your answer suggests there was no
regression in user land API.

Thanks for your prompt answer.

On Mon, Dec 22, 2025 at 2:30=E2=80=AFPM Milan Broz <gmazyland@gmail.com> wr=
ote:
>
> On 12/22/25 12:57 PM, Nuno Gon=C3=83=C2=A7alves wrote:
> > I know nothing about DM, but the issue happens when doing a ioctl
> > DM_TABLE_STATUS with params:
>
> What do you mean by params? Status should not need any special params on =
input.
>
> Anyway, dm-verity in 6.19 now reports also number of error-corrected bloc=
ks in status line.
> If FEC is not used, it contains "-", for example
>
> # dmsetup status test
> 0 417792 verity V -
>
> > 1 /dev/loop0 /dev/loop0 4096 4096 9 9 sha256
> > 48048ef2c63d1c69a817508db0d3ff387ce33b10ec8fd0972bd29268836014a0
> > 46c92f189b2036f93ec5805fb956adc134f8c17513bb51502f5cf92cf64fefe7
> >
> > And after calling it params was expected to be empty (\0), and now it i=
s "V -".
>
> Could you please be more specific what command/ioctl you call here
> and post exact steps to reproduce different behavior here?
>
> The string above is table (dmsetup table), not status (dmsetup status).
>
> Isn't you code just confused by a new parameter in status line?
>
> Milan
>
