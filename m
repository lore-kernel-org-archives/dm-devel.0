Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7674741737A
	for <dm-devel@lists.linux.dev>; Tue,  7 Jul 2026 13:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783431681; cv=none; b=clCxT0BETVURbVc9oQE6I9EC3aChVt2LNW5id1weBRz5wv6Gt69A6plvYkW3497AFZa5QL6sfF6pRd7Ca5p+CbRtHQUunlbzHc0UcRPIMnRenz576lRUal/S7CDLt48maaKtpamvnPkUlpCg8o22lzEz6yoCf36gB4iqTbLxBE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783431681; c=relaxed/simple;
	bh=J4wzaI3lBHz1rqO0O1AKa+qbw2s/c50pKICr1hVTsiU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j2YSWZvBi/Jy26YJxX/vxDQoELyP1fS72hQ84/rHlPoTxcNOqcYW7CIGF/75ip2Uk7GDevZszKYrkTYd4/gSbv9N3KrOQOjmOXtDxw0dPSs3fawp7ealHmFLS3M2dKfrwJPoKOnjuoUoJkGejOno86NDynXq2jwx4OA0+YON51A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aKjratrV; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aKjratrV"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493c55d5c7aso40014625e9.1
        for <dm-devel@lists.linux.dev>; Tue, 07 Jul 2026 06:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783431679; x=1784036479; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J4wzaI3lBHz1rqO0O1AKa+qbw2s/c50pKICr1hVTsiU=;
        b=aKjratrVFtkxM7dgBTZk0vzC6UWfkgKEfJmoZjj6Pw1JijooRMWYRtDDU5qoohBQ88
         Ows54s+HQ+toVHW0ozCsS5M8CCxfX8F/o9Fz4ugwpVo82ASaMuE5So+vsev7fx4e7Lea
         /eM/uD4ENizImBjQ4wL7H4JLq5L5qMHm/c7vGHlCyHrgm9AEqPItuQjk1OkzycpTAAqQ
         dt6APpVWANbP/oZatw02eGkKVRgZhtcPxUbFPxPCHzM0UhRnDP6Eebl7ig5xFaQLH9x/
         4/ms3ryADVEesZ4d4mLZtzxQ0BNOkl6abCqa0/X/Ncq+mUetprsRPnmc4jHUG8ehXo22
         FOkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783431679; x=1784036479;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J4wzaI3lBHz1rqO0O1AKa+qbw2s/c50pKICr1hVTsiU=;
        b=e9hIdqkWNyREfWaIRiJjoK9u4FpokrdPzGa2MDTaOt8uK9n1qZl8d76fX4cNniPccH
         JpBkzCh86mHE2PX5QxVgbLpzMgDA8HyDRtQtwF6+Cn8e3LrTcDm7dGzsp5fYwwE/bcbB
         VcvfHspkxiXpOSKyRgdDf0W9JCWJ5SINQoAVC95/N797CBeDa64Zyh01+QRwdQxDetxU
         AvxZv6eD/KIo9CV12fbFI3lawhkSVhiqkj82pU4Ap4zGnqS9UuyFh7jFdGRGwdgnaq7F
         JQVsXP+toyehh/gfUZgh18uqo4ZhCm1m4dmmMHs/L5cOUeul7SCcTP+BslKrVV3vsnwl
         3jrQ==
X-Gm-Message-State: AOJu0Yy2PG6UG6+izcybTyeXJtkX8Wz4NWu+OsqE+wb21Y+/8LRMdAba
	SDSdqdkzSES2BmXYM90vkNxjUaly4kGzLn7fCKYk7I87+dQwuDvgvKFxpN7iHvJdNyM=
X-Gm-Gg: AfdE7cn66kpFOLXd8HAcjvJcIpuxnbt97u3FMcAuZ8FCGkThEl7UQHIOfYahDoShtf1
	dne5uxstIGqZW6IHAEPiUT9ZksRywfBWIA2faNQpqaUTXV5j2VczJxnQ8FOwqy2zBPiPqfSTyLg
	srJd0ijZOrftYGlMwAZ8wgmgH94hiYDvgZatTHzHmdpHrTfEbKxFsccv7V24PtMBml8bZLzdyMo
	NpCB4EzJRaakYwsXQJxBhaF9kslMA/UWYOjPhCZ5+vwCRdtHnxMccOGDW55kjU3NG9O4h1lJxY4
	mfKiMRVGnkcV5bV/E2IPUk+081ZVryNEMc5/m3ngSmMSBd+YNDldbNTahleMUFbUFAbVIcC9yjE
	XEvCBNVFBQNgzf1k6L7tKo/I1Pzm90ZYSyzdcxMvuiSeWVVn+8Ecz+Ntmr6bGphikC8FNbKvokX
	WQF9EQgQ0ZbXAQSPErw6pG9VfRIrHVRHoGb8rdPrq2EQWdhtVL9ZNdFUM6fk5kSDmEjoSZvZP9N
	9clw8sVg5NTjr2PmtYG0ltBeXFWFZm5HxRsWeJ+HAgnkmQ6dulAgJjPe2zCYA==
X-Received: by 2002:a05:600c:4687:b0:493:e404:3727 with SMTP id 5b1f17b1804b1-493e4043740mr14388525e9.23.1783431678460;
        Tue, 07 Jul 2026 06:41:18 -0700 (PDT)
Received: from ?IPv6:2003:de:3746:1100:f390:c52e:1c24:9082? (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0f32660sm57375655e9.2.2026.07.07.06.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 06:41:18 -0700 (PDT)
Message-ID: <3feb61ef535103d7a0d7e52a4738a7035e1bad11.camel@suse.com>
Subject: Re: [PATCH 2/2] Remove unsed DEFAULT_DISABLE_CHANGED_WWIDS define
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>
Date: Tue, 07 Jul 2026 15:41:17 +0200
In-Reply-To: <20260707004817.1958264-2-bmarzins@redhat.com>
References: <20260707004817.1958264-1-bmarzins@redhat.com>
	 <20260707004817.1958264-2-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2026-07-06 at 20:48 -0400, Benjamin Marzinski wrote:
> disable_changed_wwids is deprecated and unused.
>=20
> Suggested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
