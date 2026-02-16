Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB19731194C
	for <dm-devel@lists.linux.dev>; Mon, 16 Feb 2026 14:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771252084; cv=none; b=aJlNqKbyGeXIOtSTXQMhsh88yOxdI2TvtBQA1ouenoOhNCdNVFB51lmgjJWr7J/uPT9ODfYOoUjgkpXBAY9EN8aaLE54u9zTGjCIeHjUWZJRQaQYgw+Yr3cXA9hABUjuiTNSOTUXq4sEMsXR4T/Wmf53xGbX/qxm99bmDkpBekY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771252084; c=relaxed/simple;
	bh=J9a6dttbPvuh9UP7gboRwUMpon3EluO7gnlgfIOwZJc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b7GzmtXND21qUUc6tV0LZyjjJ/gdIi4/FzwERsWTqk9te2bnRXxwSiB65jG1Egfo6jcPBCF15r+Wnbg6Db+amd2Wn9WI6pja/GdW54c5LzDEpSmmRx2gmL4WXXQsxt0LJq6JCfwO/CBAPUPYHgw/IqOUaCfNc6ajhYKq3LBtneM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HKnb82o8; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HKnb82o8"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48069a48629so30943185e9.0
        for <dm-devel@lists.linux.dev>; Mon, 16 Feb 2026 06:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771252081; x=1771856881; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J9a6dttbPvuh9UP7gboRwUMpon3EluO7gnlgfIOwZJc=;
        b=HKnb82o8FMcND20pWwAAWQaSuHjesH90XYHLk5PM+5QjBTm2abuLx4AjYQbxHCzah7
         vp6TjwkHNoGJJkmn+R/V1SmWh7MZLnxQHTo4lz7ZuUZTypmZXQcBQwQzH30obLYxFl5K
         hxKy0m+ybKxkxyFTWkiBSs6gGfwOXaZNSzhb28DrcnzhDp8y+vYaEl8xSdk1M6ZBA6Xr
         jjorFEbpLjVjaOamBQ8PcGRdj3Qk42yz9dPGCx9Y6FFrmy+xua8pmQZ6lM2QN4KRTn4P
         bQwt4y2/yHaqRY5R/rkUghRd8hcJpqvbFc1QRdauuGYEHU2LTfCTHwV5FW8AfELmtYB7
         qz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771252081; x=1771856881;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J9a6dttbPvuh9UP7gboRwUMpon3EluO7gnlgfIOwZJc=;
        b=ofvIaFRQFyXTDv+GWqVrVkN21pAbVWGniZ/gnHOK7rQ3Qs2e6n6EVBdBBbSY/7hJ+K
         eQjhQv/lqN6ybdywTLs+FNiKXlr9aopnvnTNz+9JIltK18hKJBQyyrLSk8y9SLYa17dr
         z/jzx5UdXXcinY6/wFefnTECqIYoX/TXgtQibmrqXRs/c8fGddewU9k+ZnJafichhLBr
         0AGoAVXOUMK6ve2G+4TfvFxwfUEjWkjqrVetYN0R3glInc2mT26us0w8C+o5X+8q8b5j
         Z5/3C3nKGRI1DVH9IBJurJQNA2V+oVilDOmIMeT9NsZdJviZHgr5hazJwTxF6OMRsnUh
         ULVg==
X-Gm-Message-State: AOJu0YwGAehHUD+3lLGY757NQyOu86Uxrfdx7LcvqeX6ejx3QziNAAQK
	1nlSRhKawwN8cZiyYyr7cYoLBRZw4ciH/liXuyvUrIQMA5xvVzx1mLUE4TIAcdN+Znc=
X-Gm-Gg: AZuq6aJDZupYYl8/JaZQJka3Gkap7FdUaBPeaOzDmxzb1opjl6m/x6rZbHZ1hD4NIfg
	INAJAgn34F6Vk0T3IzUfdhOnlGp5KfnjB8+dJyWdeQentHX/GHJOJcnrXhtORxB8SLf2/cAAcw8
	vBtmyg+Mf6RF9uY/IFpzCSO23JWeKcCFv7KmaFplMPwVq8DRO21uA7PFPDPn4xTlfmyV11OgR02
	YI5OJ+3svjiysHfVLU3R11/GkL2GRIcu80nNlUg752ZbXrX4fN1CzafNhZwiDpOP2AlNdTL2Y1x
	IjUYqMNHJM1tgczQ3KArsoRiQgmreqeCYLNpsKt1jgZpLUO4vaxukVmsOsXNp3MaXg/neYbYg6c
	TN/7mfmArx7RaUgIv/7/GTteoI49UeSS9HH0ynva+uvVeGhnp+JOrcpJvz3vZ5I9rc2cU6N0cgM
	pJScr/d4PuHvBn8km/w7bZ8q7WSP0b42d6zDLWs9pEvfp2KKEsP0LR/Aj8XUqh345mhfWOWgDwg
	/R33n6wVpVb6rZXI6hOKpQNGU83wRhauO0LZC97ec5OpoLW4mcvh/wX4MPOC+/kuktZog==
X-Received: by 2002:a05:600c:4e56:b0:480:20f1:7abd with SMTP id 5b1f17b1804b1-48373a58997mr195888615e9.31.1771252080677;
        Mon, 16 Feb 2026 06:28:00 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ac8209sm29167200f8f.30.2026.02.16.06.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 06:28:00 -0800 (PST)
Message-ID: <9973ba7435c726437e6e1a83f36a29df74377130.camel@suse.com>
Subject: Re: [PATCH] dm-mpath: don't stop probing paths at presuspend
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Mikulas Patocka
	 <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Kevin Wolf <kwolf@redhat.com>, Hanna Czenczek
	 <hreitz@redhat.com>
Date: Mon, 16 Feb 2026 15:27:59 +0100
In-Reply-To: <20260212180541.1154475-1-bmarzins@redhat.com>
References: <20260212180541.1154475-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2026-02-12 at 13:05 -0500, Benjamin Marzinski wrote:
> Commit 5c977f102315 ("dm-mpath: Don't grab work_mutex while probing
> paths"), added code to make multipath quit probing paths early, if it
> was trying to suspend. This isn't necessary. It was just an
> optimization
> to try to keep path probing from delaying a suspend. However it
> causes
> problems with the intended user of this code, qemu. The path probing
> code was added because failed ioctls to multipath devices don't cause
> paths to fail in cases where a regular IO failure would.
>=20
> If an ioctl to a path failed because the path was down, and the
> multipath device had passed presuspend, the M_MPATH_PROBE_PATHS ioctl
> would exit early, without probing the path. The caller would then
> retry
> the original ioctl, hoping to use a different path. But if there was
> only one path in the pathgroup, it would pick the same non-working
> path
> again, even if there were working paths in other pathgroups.
>=20
> ioctls to a suspended dm device will return -EAGAIN, notifying the
> caller that the device is suspended, but ioctls to a device that is
> just
> preparing to suspend won't (and in general, shouldn't). This means
> that
> the caller (qemu in this case) would get into a tight loop where it
> would issue an ioctl that failed, skip probing the paths because the
> device had already passed presuspend, and start over issuing the
> ioctl
> again. This would continue until the multipath device finally fully
> suspended, or the caller gave up and failed the ioctl.
>=20
> multipath's path probing code could return -EAGAIN in this case, and
> the
> caller could delay a bit before retrying, but the whole purpose of
> skipping the probe after presuspend was to speed things up, and that
> would just slow them down. Instead, remove the is_suspending flag,
> and
> check dm_suspended() instead to decide whether to exit the probing
> code
> early. This means that when the probing code exits early, future
> ioctls
> will also be delayed, because the device is fully suspended.
>=20
> Fixes: 5c977f102315 ("dm-mpath: Don't grab work_mutex while probing
> paths")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

