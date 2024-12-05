Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9B714A8B
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 16:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733416353; cv=none; b=tbJ+v2vh4d/aJaWm/wAcGLz8YTMuVW2B/0J+GD+nTfkMK2hPSPoBm2FlZKtaVUGqeZNqWI+HqCrn3GOvthNCqMBXgQo0EdN4W9LGjhOZJCUBCrELgjGTb82PACw/Sw2ZHmLPYWcrjNFt7u+ySbW5hKxRJGTs71TocpYX0Nnh8GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733416353; c=relaxed/simple;
	bh=woE6BLbNIFruVf29D3McqoOYj36StGE3E9odpo1R4pQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XDpZXUkzw2Xktd4gNWz7YHAvb5TxTZpjt0Sn35Ifz2Fgvyvw5VDERcYA/t4We8slmbjoE51ldrG0kfHwTwjfSSYhdrgDze6fevmEckfTvPsW/Kd8J+VeSDEhgwF/TJL+BYs1OFSPY3guOmV2Voi574WBmLk1LkDQnRov2TFSKVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YvfTEevJ; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YvfTEevJ"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d3ab136821so406713a12.0
        for <dm-devel@lists.linux.dev>; Thu, 05 Dec 2024 08:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733416349; x=1734021149; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=woE6BLbNIFruVf29D3McqoOYj36StGE3E9odpo1R4pQ=;
        b=YvfTEevJsFLvkunb1nz+Ko9oIB8W6CpEbEdTm6EOsiTPxmspdROigL8K0z5WklN9+m
         XIXRJJbza7ro0i7C8VbbWsQMSCnC1vKDV9q1PPbRHe0Alk9EwwlkXJnzwh2Lj+U3Ts9r
         2dmPrdSnfsaCTmn7B4zCyK+jG3/iBwTGPM2THaSyPyLHSfPU+IcVtY4O3ao9WWwkQZgk
         e4laZylaihe2tc3MXNLCwmN51yGhRbRpg+DeDGcSECUIR0FcgRMm5ckmvx0HXUyl+rzm
         tYOZ07J1BYnf97K/BPEzdgh1HlzEr8AFZjxqSmO6V2Ro2YRaZPBMIwbL5CJnl8HknB5N
         4/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733416349; x=1734021149;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=woE6BLbNIFruVf29D3McqoOYj36StGE3E9odpo1R4pQ=;
        b=ZPvBWsuWOmq00tzERADge1SlKuGf454xuaCsOUxSnfjMEmdMfgM91EXAFRs0hCV4bV
         9g6vhMCiQ2pyAhpV2RB2T3LMyDrvZ6b/vfU80wWflTKnDK+ONdjlCjwRODqTtsfnXFGK
         7IBbbt3/q2t24EYAYwIxm+ztVKLFSIHlFLVKVihYm1rVFXMst7BgCou1b20wL9074u1U
         NQEdhFHN7NHxADlgKrJ9ycW37bqtu8bj7hbPxXMa3um8ess7O5e1mnoxxTrxVrgzOyvg
         ULAi9CUZFJfPSuCrYi4mNd4Vi6fGo0Rc8IlgqIrk88SCeZM0PEpoL3hYIaeOlJ8E5NGg
         yaFw==
X-Gm-Message-State: AOJu0Yx+gAqo8X6363afgQrWKAEO/eJaBdEMklpY1EPpK+exOwVSoPGx
	Tr7ZmQaPT4wpQB/VIeERdSz96rLhflC7z4/VUkzY1RZ5AeA4XPQ5Mqfw2GoFadr4avPuCciAyAe
	t
X-Gm-Gg: ASbGncuYXFfL8he2ZzBfPW6BhRoeHIO8gSyaqNaUFpG3uuC1O/98LWRj/mWTq/jWNpS
	W3ogcaPgtuPkgADspZ4TLPgNVVAwRywkCdBEti4DR8nfpg1TBTIoIi4xeQRQLpPLJyEYFrRfuzh
	iqCFIGGxwzj/N5oD0xbqAOrD9WoQe6vsncZsQ4Pqlk1sPG5Jv6cx3Bp8lvsI4cctpbj/K0zftPB
	QAzwp46vDZ9aeizR2IuXlQrW0QXKTIkVdXR+Mx+2ltFSKbCX4gy9xdW9u3PNuHqs1IeClBBFdRb
	o1U6wDcRKeYewVz/ocumf35dOM5M5ZglknQ4N7ZZaBsBlj4lI7kHlMTZUZanjgAznLUcnJX2YOC
	AloqulA==
X-Google-Smtp-Source: AGHT+IFPEF3AZACd3oTjq/4pFC7UYJJeH6ShnK+Udm+DyUkcaa5JNraNpEVrAa1XkZN8MhosbfLTaw==
X-Received: by 2002:a05:6402:2687:b0:5d3:bab1:513f with SMTP id 4fb4d7f45d1cf-5d3bab1562cmr635502a12.18.1733416348779;
        Thu, 05 Dec 2024 08:32:28 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa62608d32bsm113082866b.147.2024.12.05.08.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 08:32:28 -0800 (PST)
Message-ID: <ee904358fdad062577f00eb10695277a4b13ad8a.camel@suse.com>
Subject: Re: [PATCH 3/3] multipathd: Don't call select_action in reload_map
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 05 Dec 2024 17:32:27 +0100
In-Reply-To: <20241205035638.1218953-4-bmarzins@redhat.com>
References: <20241205035638.1218953-1-bmarzins@redhat.com>
	 <20241205035638.1218953-4-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-12-04 at 22:56 -0500, Benjamin Marzinski wrote:
> reload_map() was calling select_action() with force_reload set. Since
> mpp will always be a member of vecs->mpvec when reload_map() is
> called,
> when cmpp and cmpp_by_name are looked up in select_action(), they
> will
> just point to mpp. This means that none of the early checks related
> to
> cmpp in select_action() will do anything, and the action will always
> end up being ACT_RELOAD. So we can just set ACT_RELOAD in
> reload_map()
> and skip the work.
>=20
> Additionally, calling select_action() with force_reload set will set
> force_udev_reload. This isn't necessary for any of the reload_map()
> callers, and will just cause udev to do extra work. I did set
> force_udev_reload in cli_reload(), so that it works like calling
> "multipath -r", which does force udev to rescan the device.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

