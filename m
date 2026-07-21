Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779CE433BA9
	for <dm-devel@lists.linux.dev>; Tue, 21 Jul 2026 07:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784619323; cv=none; b=jvNosybcsnvtMXdUGQx47h5/2H/DMV12kmnMgIySv27eQYfYNiiM9eepXyNrHl2IsVHVy+I3UY3y3v0EnA4MP2vL6s1vMvptKf5hw/+RYQc389AwyH3GiKdGo9+0VgQyz8gV4J1/Xud7oMmRGGPsmplx9tiXLoo4O88kmFg0xCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784619323; c=relaxed/simple;
	bh=LXNkGeQeyX7TXOEMJN2Z6s5PJAB6KFXUAZCQ9TdzHUM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LmzUEcc5R88qWswrJIcMc5nYPWbs2JWlUqd16PuoaOWziwirBl4Rw9QHt2SYVKdpaWQBdZEXXBv3s7i7DiwAVo8X1tUdO3u5XSMazQp/qnOpO0h3auKoHR5exj+slFkyNH8iIbgsxrCNRWadYtQkOaCU4xvgRGLIJVJwYUvdFqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=chK3TEzV; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="chK3TEzV"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4954df200ddso21399535e9.0
        for <dm-devel@lists.linux.dev>; Tue, 21 Jul 2026 00:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784619321; x=1785224121; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LXNkGeQeyX7TXOEMJN2Z6s5PJAB6KFXUAZCQ9TdzHUM=;
        b=chK3TEzV8WszXOCrLYfIsUpLUO+i98WfB/eVOh+prGYXrx6SdKhFqg9Zc5Bi721BRg
         cxarXk/3VxVUkKmKUBMviXcevEfAN+aDa74vWKcrSgqfU1FvIsk1rIkW+SLgG3XEvKNs
         Va/sn0nvOUHNpHHOaOknKLZvD7XGEp/pj3JQfmSbwtNAvwOJm0Q8foxVSpWNveBRif19
         bg+T7LcXXwoaYYEUa318TSldBfySlAU0QUNiHdIVx4freVAtG5/MRv+apLtmYJlwmpD0
         GSSQtPm7oxn+v7Hr8jT2GhbMCdPkIXq44ALV5VVLKJ/4ZVKG/QWrL+yv/AmRakTjG3OB
         JdCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784619321; x=1785224121;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LXNkGeQeyX7TXOEMJN2Z6s5PJAB6KFXUAZCQ9TdzHUM=;
        b=ssb69gb7CurJvibVb9xRZyuuaWHMkTrpE+OUnFoH0o45MEQ1FRyid9tx55wWi/ofXo
         us+ppqyrjYzyTEVjsl7iJoHNCVCmldblsfOVrOSHrdDILJYbJGKcQfOxIt/KE/GUOXnF
         nnctY4+HCrwKmHbwRfZuYSKbgpmyhNkxjkm2kN/EtnQ3FHMGxO9J2ptV9PP2+1UXt6ru
         vqJZP9yTHMFFHdrcIAFOdLbUSbjpOIurTtArJ1kj9QE4nmWKfsxCHBSPeTyqeUvOsHXv
         zVfweqQhWYtwz3rf3rTqOF/SZ0ee7u0LZ0SvcoS3er83HI61lqw/aDfWjJ+irHZ6wKoS
         cWNg==
X-Gm-Message-State: AOJu0YzF5SYMSJUhrLlU9nLvzrPAMZHJ7IVwVjXYruhAEq/A8QR4J8PY
	YjQOoIy6nqjIpplsP+vK3XSfkgRiDOxa9Pb9wwEDyrbmtzKk/XHJ1/+htaCtF855ZOA=
X-Gm-Gg: AfdE7cn9tWCo6vE366JfEn5ezELfMIb3T+D/HP/HM+JznEFvZBu23RSxSP8oGve2oGs
	Y1YU4CNNeg/7RjekSHprfyS8n9X/TIPPR5U0+w7MT8zyeheK0ias4Y+y/vdbdNaK0PeLgdfnD0n
	RpR0spdbL7GWhxHqZfS1ICrU/UQp4ERNHIHhigtQN5QX2N3MX+Njq1MriUQq2Mf//vkAXO9uUMV
	7c3qp+mHhBW3E3XylGsSZWRCg4jhH4CbdK60XJULHoCEY5MSiWu+bRRTTXOSM+HIt84ZzN64tzt
	kCDG0AjZpL0A1Uooix594LZVD6LuGSC5I+ZYTYQrNdYysyuE1wNUAkfzHSOIYgqYXnooKfVB2e2
	PLQ08FoyOdAqWC9jT4vKZRVrCSbmOCTQp81u6YntTdVMds02a7ReY78aYTUKolCrwN8GlbQliks
	jKjdztXSR4Ax7MukbBBYkcAX1qKI+eSrpFFGZdR9S/8TOa6AtATvPsN7ObnPfJ6UmEt5F/5sFv+
	gNGDd0gJrFWlUCI40WsACLFFEQY94OtjfoJK43y
X-Received: by 2002:a05:600c:5351:b0:493:c8a6:b517 with SMTP id 5b1f17b1804b1-4954a51bb65mr137564035e9.38.1784619320584;
        Tue, 21 Jul 2026 00:35:20 -0700 (PDT)
Received: from ?IPv6:2003:de:3746:1100:f390:c52e:1c24:9082? (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49564011868sm63596125e9.3.2026.07.21.00.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 00:35:20 -0700 (PDT)
Message-ID: <b33d873a0ef0ebe32342b777403f498fe9e25dd6.camel@suse.com>
Subject: Re: [PATCH] kpartx: check slice size before looking for partition
 to remove
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Kou Wenqi
	 <kouwenqi@kylinos.cn>
Date: Tue, 21 Jul 2026 09:35:19 +0200
In-Reply-To: <20260721062724.2478394-1-bmarzins@redhat.com>
References: <20260721062724.2478394-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2026-07-21 at 02:27 -0400, Benjamin Marzinski wrote:
> After commit 03071031 ("kpartx: fix crash and truncated device
> creation
> with long -p delimiter"), when attempting to remove deleted
> partitions
> on kpartx -u, kpartx started calling dm_find_part() to check if the
> partition existed before checking if the slice size was 0 (and thus
> should get removed). The problem is that if dm_find_part() returns
> DFP_DEVICE_RELOAD because the partition device exists, part_uuid gets
> allocated, and if the slices[j].size is non-zero and the partition
> device shouldn't be removed, part_uuid wasn't getting freed. Fix this
> by
> reverting to checking the slice size first.
>=20
> Fixes: 03071031 ("kpartx: fix crash and truncated device creation
> with long -p delimiter")
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Good catch, thanks!

Reviewed-by: Martin Wilck <mwilck@suse.com>
