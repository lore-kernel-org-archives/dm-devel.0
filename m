Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7713F183CC3
	for <dm-devel@lists.linux.dev>; Fri, 23 May 2025 11:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747998067; cv=none; b=uFk7W7Iuxkxqm9rxSO0B11Eh/QuVfisgu/E2wTD+s/yW4PWvIunbz9ht2drVyuu5PDTJtktK6mnqralgxgGIvaOAJIvq+cZ0eWhqNwxHTOPWMXMvBJGCQulyaY7EgFohJPG9K5ph7/lwZCQ3iuDxF2ttPK8+8XlN8AC2v8CQnU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747998067; c=relaxed/simple;
	bh=/F1uHsB1Vdcxi17CiekyaHNfrDxrg32Fke8gVkqgigg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tkxD5hKjuylEZyBrLe6KqWKSosArBJND6ZFZIz8MxxpKvuvK9fTeRcqq44R8QUrDvOvzyc0A4h+4nMg72F70a9vd70ozyUH66SO/7pVjWaFgiN5sBUX1Nn0vfaov/xXk07U7ghE5LKHp9kle57wLYzX0ZehIxjV5U3wfI6cyoNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N3As70T0; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N3As70T0"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so99853775e9.3
        for <dm-devel@lists.linux.dev>; Fri, 23 May 2025 04:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1747998063; x=1748602863; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DVtNXT25NDn6K1Cd/CwXFnSoezc08Sp0hCuWAKyWUjc=;
        b=N3As70T0EWhkPcDSKd5MtT5fnr5IpQxMEAleEq7MIOy42ODNwhNsC9uhBvFCGt+fAh
         zCMHNdnXRray2cE7pKPDW18zMmn68F+Y4gLxy5PzwmF/g31Oo9NgTj06zlKS0f85HTyC
         Df/rrvbi+QD0jVpli2ENhvis/pMu9087kStpYHmzP3ejkU09afvsYmNyQ2R27KXRDgnL
         zsrZSqr2/aNOwTqR8RlmpYwkAGjka3DmdEq0Pngrua7QLa8NK2Y4imWA1FAdngBug+wg
         GlzEvzHIHs46+Qp0F/CIL3WxRG/gQZ8j99xtxSAWmhAeFQfVeBhFHJaY9KVJ7H0O5bxM
         Hc4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747998063; x=1748602863;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DVtNXT25NDn6K1Cd/CwXFnSoezc08Sp0hCuWAKyWUjc=;
        b=vAWwwiyeAewMHKDE0Qa0niiFdnayyjjDRRArxnJJx7nMzGV8WHUgJIYPoCZjO6Waej
         capIBN+25mtDHqm8lpry02KWjiXXUyBeFf73NH5J1W+zxt5tg+C2695kfTimkl5R0WMR
         5laIGXClAM/p2MDHvYXReleIdsippvH878TUML6oRNaXtpi4e2dc/1ywiMtq4TrQSL1f
         4MQ4Bc+I9XBTv1A3lFWbEzUwZb8hO+u9e8caehFSPIy/on4CybUpdSygmxG9iHmHaSCA
         L0t8B0fSyyv11xWIpc9QEC5iDuAQq/pTGPkE2EsVU7hGuDVNijIKmqvQtCSpcl6mD/0R
         Xf4Q==
X-Gm-Message-State: AOJu0YzmoHwJ/BHUaw/bcKL0WqcNJfmAtCFIZwSZPn/wHiAxxDi6IZ+l
	GJwjKYscU7WqCxkjEk5WWj4PX6MhPhohEocJbAO6hBPd+QZqPH6jnLDyr6p8zmR5c2o=
X-Gm-Gg: ASbGncsfrS00zgU4kWDkbuE2atTI0vBmknu20VPjWpmF45SS9kkrZv6BT85POfrwffn
	RjS0fQK4hrafQ4p4tXK8qqMvvogI5KkkxLoXS4wqH9bAheVU3iJB9F5sBb13ZFLBsdth/Oh9Vza
	IYUfoYZlDwvojooKbkLAJ11p38g241gHjYagmhWp3puGaV2X7RoaHV1WM6EiaOnxodkva0rweMb
	E8Imlg2zpohSDVGPfLYjtnuQ6fmTtqEVRfc+mcajAEYjvv7KwL4BD1nQAZsSySDVZJ2mgYVz6mW
	7X9iqtx2PtRsW+WXHAVH6mksGYR2CEGv1sh56htIfQ/NkEZVltMK7ZmruS1w2Kn63ftCbvor3l1
	7V0WIcgVVnnzgnLOXLLc=
X-Google-Smtp-Source: AGHT+IEsECCZKMJcHZa4I7Nix6F4q/c75uHGdOeLRcgS+dUW7kXnYqAQuF8I8L4wDi0f1+3j4foqMA==
X-Received: by 2002:a5d:584f:0:b0:3a3:7ba5:a221 with SMTP id ffacd0b85a97d-3a37ba5a2c3mr14096672f8f.37.1747998062244;
        Fri, 23 May 2025 04:01:02 -0700 (PDT)
Received: from [172.18.125.123] (ip-185-104-138-49.ptr.icomera.net. [185.104.138.49])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4bafba976sm5561023f8f.28.2025.05.23.04.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 04:01:01 -0700 (PDT)
Message-ID: <baa4713be2b579189fd40d3a6e4b8aca897baef9.camel@suse.com>
Subject: Re: [PATCH] multipathd: always reset checker interval for failed
 paths
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 23 May 2025 13:00:59 +0200
In-Reply-To: <20250522002623.611830-1-bmarzins@redhat.com>
References: <20250522002623.611830-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2025-05-21 at 20:26 -0400, Benjamin Marzinski wrote:
> The are multiple places in the code that can set pp->state to
> PATH_DOWN without resetting pp->checkint, most obviously when
> a path is failed by update_multipath(). When this happens the
> path will continue to be checked at its previous interval,
> instead of switching back to conf->checkint. Fix these cases
> by always resetting the pp->checkint to conf->checkint when
> updating the state of a failed path.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =C2=A0multipathd/main.c | 1 +
> =C2=A01 file changed, 1 insertion(+)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d4928d80..2d5c146d 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2711,6 +2711,7 @@ update_path_state (struct vectors * vecs,
> struct path * pp)
> =C2=A0			else
> =C2=A0				LOG_MSG(2, pp);
> =C2=A0		}
> +		pp->checkint =3D checkint;
> =C2=A0	}
> =C2=A0	if (pp->mpp->prio_update =3D=3D PRIO_UPDATE_NONE &&
> =C2=A0	=C2=A0=C2=A0=C2=A0 (newstate =3D=3D PATH_UP || newstate =3D=3D PAT=
H_GHOST))
