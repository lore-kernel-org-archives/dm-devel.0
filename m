Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA5447DD46
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 09:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768986028; cv=none; b=jI6zScz9C5C/0AHlDF5Qt/DbpUrx/5+PMf+CVGhP06tiUoXj17Tl18dyK4i75AEJ+P/GU7PucopSvjn7/oCj7wYArB0YwGL/+crevBCZ4SXsexXWCZ5VnRhPOogsjuG5nPisBWLL0EYD67uGbwYispA20j3MBkfyEGB0hm2+CAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768986028; c=relaxed/simple;
	bh=1L4jAaHZZoQpE9R/Q78fJeYD+syjFidiJAqRJ2zj3vY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F6Kv7EZQtDOryh+Kg7u/JqvN+Ii3YF3gZpa7LsRpPRFObXS4FSUcmH3K8CBrdxcSh0ml9GzbZiar4ulr/WvYJRrj2npNECN01+ZQhuoPIGIXNoXOMlA40CUm2p31uXeJZN1dDCQOWv09V1o9jOold7uxwVEMPKAykD5zx2F/fvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WDOyXJmS; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WDOyXJmS"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47f3b7ef761so37273765e9.0
        for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 01:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768986024; x=1769590824; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N5Q4AHUkLWSSqPPtzY9j6qCYCbOMnl7yoxLfW+0IIIg=;
        b=WDOyXJmSRHSWv33WI5y9fY8Bal4kljQFHYSl2xAlCWxIl68j/kgcdPpWVDCpKG22Qm
         Sb5eaihQjAtuY03BxfTNgpo5t+AM0IMgl47YasGzVUVZuEjtLGJXc9lLO+B9NX8nuIhw
         5y5l22F8Kv8HxPNWx0WNxq86dMHJLc0+TfZC0X5Zv0uwMFrEyEHM5CpKe0lXiHcLFK3F
         +J1WT1zwFXcePHFamGVkRrNixTg7aIiXVKLA0o4iS7hFn3OLSM2s6BjiIHQSKNVGvDPs
         ftaRaWnmVLLjlrQQtLp2YEZrC0nYzuOOTn5WNVoRbpLiqPn4cGB/YsvMw+5B55knUVg8
         uKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768986024; x=1769590824;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N5Q4AHUkLWSSqPPtzY9j6qCYCbOMnl7yoxLfW+0IIIg=;
        b=g+Rs9tEha93FcNNsKuSvBwV6shp8+hi62PaaLBQCnZniCYyogOJVZddEtecR/cq2vX
         hogpgc5xYtm6lelK/7rtx2CsLL9OIF9m1AJrQrkz7+WwvGkToWuoSga3f0r1smCjpkdO
         YmL6/XK6BTXrQ5vXILcYr3zW3Fn9GIK2KOXBQAvVHDdHex2ZoY/Dj/D3UkgjCP9zxa3C
         /InfZIrncwjrqUt3NRBek10Z0UwmMWhc796cjBfvoPL0LvE4Qg9o3H6Ed6Rd0n59B0F+
         /bYugBzpGZ+eivRscvH6kaCHOvVuPK7CeaNWMLwwPRBcX71knDRFVg1NMNSB7EQsqzcX
         c94w==
X-Gm-Message-State: AOJu0Yw+INhP3bJPoThI/RVn5LWtdCa0qtNt1+aybyjZFA5mVq+3rB9z
	7AtRW/tzQTIeIBhsezX1Rt7KnnKGG83iJxs8IvhwE+D/Bahfmlo8hMJtl3yto1ArMbUHCZTRj3+
	FS4PN
X-Gm-Gg: AZuq6aLkD7u5mDaALEOtI13srHLIEyVLQHKh7ImJz3ywFxzR5BtnHlWjGvl8UQvrKtT
	8NqCVPWV5OKbsnNzn08HRGnE2mSXr2XvtAgLTr8SYoHS8k7KjadfHYXvnr0p9iXN0U5CXXe5ebh
	GUsI+sphg5KTS/qbFK7lHGgH3W9kQytmfJ2/pn7/XuQim3haQRwE5TzD0wLB9qq6sW+WZXPiPZw
	7saSb884wCG6WfJ4/r4tFZq/sXzPAZpGUhUSZ3eKnvocs9/cFi7O4Nni84R9tsM0y4aHGtmWZAG
	Z40lkrU4hXevh5h/zaB3MwNJ9YSqz8pqwJHDea8j0hHv1gyi5XZfc/RkIepkX4qhkAZhlIATZku
	DZG38ksaQJRWEafthZXGF4D562VxtS5A+VZ6mctNnAcjdoBfsFvv4uz70zSfcW4xT6HP3peXj66
	IYtE0rwhVdRzM2Grw1YeQIlFZTF+q52NzDSQpsIWbhu/HJfrPjwUwMksrPB4HaSCo3KWAgFwfhn
	Nt8/CaLNxdx8IdDaB4AWtxXK6OhSqXMdwHefVnZ6s0om94=
X-Received: by 2002:a05:600c:45d1:b0:477:73e9:dc17 with SMTP id 5b1f17b1804b1-4803e80438amr59354015e9.35.1768986022727;
        Wed, 21 Jan 2026 01:00:22 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43595e0a705sm7178160f8f.14.2026.01.21.01.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 01:00:22 -0800 (PST)
Message-ID: <cb0311f9641a398981a543a3698a5395edb27165.camel@suse.com>
Subject: Re: [PATCH 4/4] multipathd: print path offline message even without
 a checker
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 21 Jan 2026 10:00:21 +0100
In-Reply-To: <20260121042315.3914707-5-bmarzins@redhat.com>
References: <20260121042315.3914707-1-bmarzins@redhat.com>
	 <20260121042315.3914707-5-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2026-01-20 at 23:23 -0500, Benjamin Marzinski wrote:
> If a path has a checker selected and is offline, multipathd will
> print a
> "path offline" message. However if the checker isn't selected, for
> instance because multipathd was started or reconfigured while the
> path
> was offline, multipathd was not printing the "path offline" message.
> Fix that.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0multipathd/main.c | 5 ++---
> =C2=A01 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 2140e432..69e4808f 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -96,12 +96,11 @@ mpath_pr_event_handle(struct path *pp, unsigned
> int nr_keys_needed,
> =C2=A0
> =C2=A0#define LOG_MSG(lvl, pp)					\
> =C2=A0do {								\
> -	if (pp->mpp && checker_selected(&pp->checker) &&	\
> -	=C2=A0=C2=A0=C2=A0 lvl <=3D libmp_verbosity)
> {					\
> +	if (pp->mpp && lvl <=3D libmp_verbosity) {		\
> =C2=A0		if (pp->sysfs_state =3D=3D PATH_DOWN)		\

While at it, we should probably change this to "p->sysfs_state !=3D
PATH_UP", because start_path_check will only call the checker for the
PATH_UP case, and in other cases, the checker state will be stale.

Regards,
Martin
