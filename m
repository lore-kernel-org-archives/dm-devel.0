Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BAC194C9D
	for <dm-devel@lists.linux.dev>; Thu,  5 Sep 2024 07:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523046; cv=none; b=K4ZSWdhQBgcwqBAOuuMLgePAB59w2T/Mmn3T51y/PYyly4GZqstRt2rriPeJdBncJIU/4oNLFsAH3FJxkFzCuD8canat7tpoyPj8kYj291oKA2KUOmRiU+dsVHoVC6Ri7i8Ek8riY73wRAdWlh0BgU7WmKdPqpu7v6XXAO1wb2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523046; c=relaxed/simple;
	bh=KTIeAkOH4PsFsAqVYtpOhQtNe4Pf9fpFMo6K+GWfN30=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U3B/Pg1zUgIOmw9S4Tn4us+Upbq2lrF3Oc0csaY2wXHKsNohN4Jyae9Uk/szk49FhQPm4euc1ZsuKe92ffvmcR+lBQ6w7pUfc+VlMrgBnCaZuaSUewcgH3zIOkiZL9WV7Q8EcPmb0dQWxL/rrC/IF0QcoqWhizhNrSxi3wVK1Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AGn2a5jk; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AGn2a5jk"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5c3cdba33b0so484744a12.1
        for <dm-devel@lists.linux.dev>; Thu, 05 Sep 2024 00:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725523042; x=1726127842; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KTIeAkOH4PsFsAqVYtpOhQtNe4Pf9fpFMo6K+GWfN30=;
        b=AGn2a5jkMFSMPu12jDUfArfpKsjD5IKbFbiflwoqzDqChAibtq2XrPf+SW43dU4/h8
         1TDYeH0wGhb63+jgqkjbaUzd7Ax0QqwHIL7ya06vbfoscMHKcnSJdFMN5PLmc24iUWdJ
         mGCEiXiqRYAFh+0Qxw07RihEV0R4nS0CL0ogDQY5U7gNh8wG63/AdULzt+GVCo15BKrh
         a9JD3yuqRMoBffaZn9q1IlzbwwHAFSDDxOrv7ftk8JEax3E+FHCBnifpygVJ8A6jvLXq
         /iQ4Z+tA8x2jlApOf0RN+zoeqt3/Ip/5WXi5Ezv1Uk7TQbXbByFoQ277guEmBEudj8tb
         d0+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725523042; x=1726127842;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KTIeAkOH4PsFsAqVYtpOhQtNe4Pf9fpFMo6K+GWfN30=;
        b=Da4pBImhRKuLqnJX5omYoMQMv9M3+MoxgpwGw6w15wtV2tLSbv2SVCJtELkX5k5u31
         nWCRn9Ytq1JK+To3OyAtOcHGcI6dJDI/Zzq8y5eZKvYxT+MUnNukKgi7YvnzW4ehDawW
         jQdHS4dT5G3yff73sH5+d1EzBDtrDcxv3tMlXedib74N5YV9WG/P/L7ovkCbMDH4936P
         0oCoFnvgjQKFFgkuKMvgGhjkGZwg/FKciHuqh+NZvSm5TnMwYxmxuErPXaGVt+I5Qg7g
         f4jI/mAUfvf/WUZgErg2OKWSJx17tCOUxFT988EYC026Ns5aHGIHfLpak01OhnTtaVyI
         AvRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVohPwlRqRhIMv1K5WP2TwTlQPqZHluoVAbMuI4wkrf01EpmbqtbDEj9sbWtov6ctQsCXN7cJU8dQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwvJE20yqixiA3gXP6AW9Sq+jJEk6vx7Cjb/8ZprD6csOIIsTrp
	Qi5yf1PMEVRdIMxiYidReDcgELFH0GpGlPwUyA4Ece+S5unHAIpEHujAXsza0t8=
X-Google-Smtp-Source: AGHT+IGX4R866djrtLeDlEI9muR3DMADk2mjMc8BajbNzaSA2GhAM5s1fQlT766wx+BoIxmFJaMz+Q==
X-Received: by 2002:a05:6402:2344:b0:5c2:5141:8488 with SMTP id 4fb4d7f45d1cf-5c2757ce7b0mr4344992a12.5.1725523042059;
        Thu, 05 Sep 2024 00:57:22 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3cc551397sm880602a12.38.2024.09.05.00.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 00:57:21 -0700 (PDT)
Message-ID: <245ab862515f9e1c58d92712aa8498ce3979ac49.camel@suse.com>
Subject: Re: [PATCH 05/15] multipath-tools tests: fix up directio tests
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Thu, 05 Sep 2024 09:57:20 +0200
In-Reply-To: <Ztjk8I_6_6f8roHP@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-6-bmarzins@redhat.com>
	 <534d539850c59ac55911bdd584737934cb24d060.camel@suse.com>
	 <ZtinIZY2jMe0ZDNX@redhat.com>
	 <d0f8e48a5ac7e42d1643c07dd6b08a601aef8f07.camel@suse.com>
	 <7a08873cbc34964f97fce214c4906568c1b86c77.camel@suse.com>
	 <Ztjk8I_6_6f8roHP@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-09-04 at 18:53 -0400, Benjamin Marzinski wrote:
> On Wed, Sep 04, 2024 at 09:43:59PM +0200, Martin Wilck wrote:
> >=20
> > But some issues remain, e.g.
> >=20
> > https://github.com/openSUSE/multipath-tools/actions/runs/10708349169/jo=
b/29690448105
>=20
> I'm pretty sure that due to valgrind and virtual machine induced
> delays,
> we end up waiting more than 1ms in test_check_state_async() between
> starting the checker at
>=20
> do_check_state(&c[256], 0, PATH_PENDING);
>=20
> and calling libcheck_pending at
>=20
> do_libcheck_pending(&c[256], PATH_UP);
>=20
> This means that we will only call get_events() once, and we won't get
> the IO for the c[256] which the test returns on the second call to
> get_events(). This would cause the error from the github CI runs (I
> haven't been able to reproduce this myself locally, but I haven't
> tried
> on an Ubuntu VM):
>=20
> [ RUN=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ] test_check_state_async
> [=C2=A0 ERROR=C2=A0=C2=A0 ] --- 0x6 !=3D 0x3
> [=C2=A0=C2=A0 LINE=C2=A0=C2=A0 ] --- directio.c:237: error: Failure!
> [=C2=A0 FAILED=C2=A0 ] test_check_state_async
>=20
> Since the time it takes the test program to run is out of our hands
> and
> the checker wait time isn't configurable, I'm not sure that we can
> guarantee that this test will always run correctly while testing this
> code path without being a little hacky and manually bumping up
> ct->endtime so that we're sure it hasn't already passed when we call
> libcheck_pending().

Thanks for having a look. What you write makes sense.

Whatever we do, we will either need to disable the test, or find a way
to fine-tune the timeout such that the CI succeeds (most of the time,
at least). Constantly failing CI is no CI at all.

> Obviously if we took your route and did the waiting outside of
> libcheck_pending(), then this code path wouldn't exist and the
> problem
> would go away. I'll think on this a bit.

Thanks!

Martin

