Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7754B2E2DC1
	for <dm-devel@lists.linux.dev>; Mon, 22 Sep 2025 18:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758565627; cv=none; b=cQApFUHCig609Ynt6S2cj9Abu5WAE8J0mG8j06soe3yOUsakVETWgNMpcoOYETQFdRxnDJxjztAt4JS1+Xks371RR8VikMGGB050nLR3PxadPy1YjMw5iyZVhVkqOFjXWrHR0VSLbd8op1ybQFRLuqPB4ZebVzEsim11LcSsYxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758565627; c=relaxed/simple;
	bh=LSU+dRLVJnsvEGo8gd8mJUOa3KCyWa+HP6P0sWz5lR0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OkhO+04ToZuItWW0YNue+z4PFm340PjWeI7uZdjwS40b3b65niauOB6M4RbgKBw/d6Ad7RNRDc5fF1ccqSPTSB68lwp297DNCG7IeOS87SE3Fi4fhba87XmlcgqB5FCrVfdnmwgeN9CEaq2Z0PVmzxMpSQ+FVaN9hXFuHYezlB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NVqMs8b5; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NVqMs8b5"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-62ec5f750f7so7996046a12.3
        for <dm-devel@lists.linux.dev>; Mon, 22 Sep 2025 11:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758565624; x=1759170424; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LSU+dRLVJnsvEGo8gd8mJUOa3KCyWa+HP6P0sWz5lR0=;
        b=NVqMs8b5tos3u4+34bwTN2ltKZUT1+9wwiXcILxJ31Sm04hHdgldTIY1/p9nqngO7c
         bmoV3abNAa27chwyjwKxZZOmt3wMZnpc7utW2ydXB22chhR+5u5RqRGaVHRW+t7FEyLA
         SgJKCfq6OojSXynovpcTNV1UKSs8J8ALuwvC6qePz+1Nj/M7JpY87Qql1S7EEoeE7MV2
         +fAsNjAs+a/XqM7lIjD701TOxCJtfF70tHIxzdvp6XSdhFTg/UO7EwrFjAn+A4rAd734
         ialhu0eGz7TCg1qay7fIGZVyU93XZChReUOVEk20oxDNHZLRaEx+fp1T83lklbFb8jRW
         jyjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758565624; x=1759170424;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LSU+dRLVJnsvEGo8gd8mJUOa3KCyWa+HP6P0sWz5lR0=;
        b=b3NCWouHxyT3U6pgqAIC9ozVeF8v95SIZpKgj+eaMaVgrVCjqKrq2qy+MbJfRyGfIn
         lHHB4QHjWZ3IcQQGuq93K5LudPKzJAqItDGy2eUZ5nju4q76OL99MQSmZ5ZlTurXSRJE
         1x66ImWqWqWdRHQwj3hHPS2tW5HShrdfjIn6N87y811iKLj0vpAy12ue8WTrl+fxnsU2
         N/FXjpsY5enGz/zv6t9qCHlS8bC/xbx1v0F8egaGzwUyPo6O7c1yiOXvFFSbgiXTa93E
         TvuGzj/jtX5qU0oKQFR7VPjFrN5mmaL16sdyz8x6kDm/G+01rwlwmTq2GaS2UnAbQX2c
         0+wA==
X-Gm-Message-State: AOJu0Yz58dX6s6KW0TN+hBzJyJQVQKjhYeipGPTqYS2kgAOjOvngpV6c
	XD8sF3Wt6OTf5Tm00h4NE3GTmhywbkF/LL/bvbVE0nttg7eeqBN8joXmBpJr1UcIxbHVc9doWor
	BcK45tf0=
X-Gm-Gg: ASbGncslz2ylvyxPsdD+DmK8TUjpyyktb0RVoR6sKI0WUC7KNn/IhszaLyb3K63dEVd
	iI8XKRdaXgDSx8VefrTcaHG4dZuFRtRT1hlAWFkyzcFssATJ0vAP4lxJHMXS7/07O7ae/ooiX27
	w38lFxXyG7G2RHqiWQ+8jKf2qSAqjCJh+DtRaJ4Vlo98JJ4V9kbv4n6ZakFEswqHvS8HMsEJg4J
	cacx63i+epLE+/ZSNRv3ur7gDhTd8wK9t2X6eQzXIWwRz3dpz2OGgvqEuezyBvIFwZePtcp1KU4
	vgFB/qrPDm+ZMc/TMO2WGc4N+U0ADR1umKXVu7H3SuVWAimemhQ3qSDf5Q73whEW1mmCkZK7m+C
	CAGErdme/LIyEdQKNMgD4aKOTsVRiAxuvOjjWO+Q4ZZ+yshdRU//r1bX27VE9mQAjGpm0PP7Zlc
	7M93bDQ3nZrK5M3LBvo1n9jPY1h23HhRi3hmiXYdCtJhDPAiIKKufPoqEd37/13YDu2JYN
X-Google-Smtp-Source: AGHT+IFevLUjuu7ioVB8rF7utXvFfkb10KzDe2SMqvXarKucFTdFP8/rRg7QNz7fPEikaNGe5xTW0g==
X-Received: by 2002:a05:6402:13cc:b0:632:a8c1:f78f with SMTP id 4fb4d7f45d1cf-632a8c1fbe6mr5252645a12.18.1758565623668;
        Mon, 22 Sep 2025 11:27:03 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6? (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62fa5f41594sm9362918a12.48.2025.09.22.11.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 11:27:03 -0700 (PDT)
Message-ID: <45d7bc1fa6f94f924fa9d1abc33e520f0e1b97ad.camel@suse.com>
Subject: Re: [PATCH 0/2] libmpathpersist: two final fixes
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 22 Sep 2025 20:27:02 +0200
In-Reply-To: <20250910225812.829847-1-bmarzins@redhat.com>
References: <20250910225812.829847-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2025-09-10 at 18:58 -0400, Benjamin Marzinski wrote:
> These patches take care of a corner case where changing a registered
> key
> can race with a path getting restored and a make peempting work
> correctly with All Registrants type reservations.
>=20
> Benjamin Marzinski (2):
> =C2=A0 libmpathpersist: handle updating key race condition
> =C2=A0 libmpathpersist: handle preempting all registrants reservations
>=20
> =C2=A0libmpathpersist/mpath_persist_int.c | 31 +++++++++++++++++++++++++-=
-
> --
> =C2=A0libmultipath/prkey.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 16 +++++++++++++--
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 12 +++++++++=
+-
> =C2=A04 files changed, 53 insertions(+), 7 deletions(-)

For the series:
Reviewed-by: Martin Wilck <mwilck@suse.com>
