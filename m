Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6012F6195
	for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 14:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760108023; cv=none; b=crVE2CbvMh529PNIJj6tfEocB/m1MWBYzyAIlQNNCPoMeX8JXz7snrOftk08gQ5lnVUJlephHEcN4xNxabmMjLOFgviioCylIjo62vUDBVYrirYjgr3P+JyR/YG6TOI9jove8SBa4MiD5VOfyDkqu8o4Msxoq6oHX/cOI30AwGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760108023; c=relaxed/simple;
	bh=HbTAYokKKwjkcAxBaylPFt6pGu/UnGudRCn7qdlkwzY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vq5WD2PomeznST0T9cTtpEJ9dr8K+sidfk1r3t+u0O3kqcnsW4/Qj0QrfFTW1DN+6lTc0cK4ST8LUsiHwDY3EOTXg7xUSjmqURxpxUzTH+PHajzy8WrmXXKjrkml5aeAfIiH8NWBtYipIkA/nsHkvhQrVvCAjuOr9aDXdT+aU4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N0pnOMmJ; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N0pnOMmJ"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6399328ff1fso3668396a12.0
        for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 07:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760108019; x=1760712819; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HbTAYokKKwjkcAxBaylPFt6pGu/UnGudRCn7qdlkwzY=;
        b=N0pnOMmJK+2FsSn48Q8WcKnHmKTrji2rYY4vukXgl68E3Aw+UIDJhQu5PAAfA2A5Z0
         OvXCAFuy7roA4AN76rpdZazcNgjl0AUt5rASsu1jH8SwNsAZhdnWUBC+3+AlPCjJflIk
         xQLTHzDWrmLVCE8omLrSfj7jOdMf8VnHFr+dksNfE48+ow1v03zMdL7bEsHbYgMkKP+A
         vmu/nNpLjwPk1Uscq0KUfMMG6w/z42OCOM8t1Ed33XqraEd7L/XNghoCaNkUwbLaET5e
         pxZUQe9OF9NPubse9QEFYN6+vhrug+fhPBkHUIyaQIwYswiWwg8K/1tltqsuRyY7fr5p
         kBkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760108019; x=1760712819;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HbTAYokKKwjkcAxBaylPFt6pGu/UnGudRCn7qdlkwzY=;
        b=f1JtV3DBgSZEJqIWQAvQmPn2xnoSFhlDU4uA0DD93PNYIvC7Ot29V+V+Yk5cvZAM9f
         6HJKO/QIAgFXT2XBz3rt8KZJxTGfrakHAitOdG0xQmgpQgXOby+M1yX8bXI1q8icN0Lm
         xNGPRVNARX4OQofOYcDh+Z3CFZohTPWzQxPwymDdCgcACYjNFPDclKUSnoWbQZcnm98g
         hX3J3NRo861R8u1gbym+r3wYwlD3eGXTgPWauk+GuxVp31tdl2BBAwPgK0488ip0uiV4
         +A85jYCqTyLwq6CacVOvPt0eVgPNCsiVWeFO11vu/ocdhUeX5ypnnt15Js95vOY7kVUP
         RIRA==
X-Gm-Message-State: AOJu0YwQkmbyanOS2GCAkgwy8eiTUX4VeIHKVHvAL9yDO8V0XA6XEdr4
	9KAD3dKPhYNt4vovhk+7Iuf/ztsgF1v0r1kN+5uV3KDbEY9z0PFxOay5CLnFuAmIDVw=
X-Gm-Gg: ASbGncsisEveeDVaParn9jZUF8zj0LrPR89gkuMdi7AG3+v+0fUjTaubL9e2WFvXzrO
	WS+Qj3nLlAZZiZyOpWo691edeazCs6xWD+h2YORs6vDyIgQwGoJ/s8XcYUL9tr7BZGBcapgGM9P
	YgfQx27Dpzc/1MzcoiGddLXwkSFZpLFCPa2EikvT+6uLCzNMxhy5m7F29Wc3+qCWyYLh/O3CXIj
	rnXeA+91dDf+CiX2dqGM9XMJibSp3dfRcDAS4I86vIKn663dN5xiiM0tkYp1lQfItWKNTXTQinA
	oIpxtQk/MH520tS4jlxOp7MceIwoZjMKtnPy3S1st+b6OSNGRmFA7Iq9HjCR7eFsaiVd9RoEzIG
	oDEyywfPsG68g22pTmPVh3Zq+K2cca4voHUsvrt2xJ3n485w2PTxXklpE0sskdZt6yFnXdR4Mw4
	fpJUNT3D+3Kp+TAtIcMKdoKKg4lwbMy5TW9T4ac7VvWHKH+98+h+VXmTO/MIf/WJ3JEDuxPNmfZ
	A==
X-Google-Smtp-Source: AGHT+IGwbA7u6IrmspVDj6MvDsKd40EkkDtPOcos4BCDE4HuQIT4Pd2NHrzopzfc93x0iBI9KKEfYg==
X-Received: by 2002:a05:6402:4305:b0:639:dfba:ca4b with SMTP id 4fb4d7f45d1cf-639dfbb0ee3mr9934581a12.8.1760108018857;
        Fri, 10 Oct 2025 07:53:38 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f04:900:e894:a50a:fc99:6ee7? (p200300f97f040900e894a50afc996ee7.dip0.t-ipconnect.de. [2003:f9:7f04:900:e894:a50a:fc99:6ee7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63a5c133f58sm2521794a12.30.2025.10.10.07.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 07:53:38 -0700 (PDT)
Message-ID: <62b73a2f6d29a2010d1b3c71109a1513a3e86be0.camel@suse.com>
Subject: Re: [PATCH] libmpathpersist: Fix race between restoring a path and
 preemption
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 10 Oct 2025 16:53:37 +0200
In-Reply-To: <20250930235356.1752836-1-bmarzins@redhat.com>
References: <20250930235356.1752836-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2025-09-30 at 19:53 -0400, Benjamin Marzinski wrote:
> If a multipath device gets preempted while a path is being restored,
> the
> path could end up getting the old key registered on it anyways.=C2=A0 Thi=
s
> happens by:
> 1. multipathd calling update_map_pr() in mpath_pr_event_handle() and
> =C2=A0=C2=A0 seeing that there are matching keys.
> 2. Those matching keys get preempted.
> 3. multipathd registering the preempted key on the path.
>=20
> Since there is no way to guarantee that the key won't get preempted
> after multipathd checks for it, mpath_pr_event_handle() now calls
> update_map_pr() to check the registered keys again after registering
> the
> key. There must be at least as many keys registered after registering
> the key on the restored path (which may already have a key registered
> on
> it, so it's possible that the number of registered keys doesn't
> change).
>=20
> pr_register_active_paths() calls mpath_pr_event_handle() for all
> working
> paths on a device. In order to avoid calling update_map_pr() twice
> for
> every path, mpath_pr_event_handle() now takes the number of keys to
> expect, and skips the initial call to update_map_pr() if it already
> knows how many keys are registered before trying to register the new
> path.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

