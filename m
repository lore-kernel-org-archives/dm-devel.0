Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED6C301008
	for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 16:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756139784; cv=none; b=Ph3xoR7OnewilJxV+mwf0KZIcuiVKJsofUxbNl+8yM2gSktz9bVjVuznI6yGqvEXOJFiIYOGIMfpHhbC+wlbSxB2k3yE27+STqFUpk4diFUbyC5CrkRjhnKWYKimYckNNQpZmE/lwhtgXFOWsy0f0trJflEYXHCYbguNXZ5auNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756139784; c=relaxed/simple;
	bh=asy8Ny21nCaDISLoma50hQQju+x95W+7EGW54oL5DXk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QM0l5OD5t+ln3ZxvItFLQCMQqdhCejgVfdsnoiGHfhbjXqnoqoCfLdlgM/GCoM91vKReeNKhhzo2fCW28MrfY8sk2dpLAwqX5Jj9hx9w4/Qrf/NYWXG8N+XTVW0BlsWKp6SDLwMO9PXJbZMjeSNMlGu81c5p5vAJRzMe+omtRmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EDr5QyHp; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EDr5QyHp"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-afcb7322da8so739139766b.0
        for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 09:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756139780; x=1756744580; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=asy8Ny21nCaDISLoma50hQQju+x95W+7EGW54oL5DXk=;
        b=EDr5QyHpCB1iw08m5i9clY8Hig2iOOgtc0UOk2iu8YAMyzgyer/UX/Tcwsn+z0TeUK
         1MXbCIiFi/88VvcUx9i8OP0ojNLa9KQyh4HT+psouTD8ldgfezT4k5+BRz+YuPS45aU1
         2LTPQTeJJv2NXDQQJOzzRuzippOqm3kSdtGua/4Sfc5SZ6h12DmYdEAAK5hTNcXUjNVw
         p4kZ+J2HnZulQJgV8LZ4DTWaJACJ78pQFCjJ0rWrr4FHYo9Psxftbtq7IORpAe1Jm1cJ
         CpsalgX0sqB1w7qA8+Und0HaAntIlnA/vljXue7/0wDonjTtCbqSZVXqJb5CjibrBHAO
         XLxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756139780; x=1756744580;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=asy8Ny21nCaDISLoma50hQQju+x95W+7EGW54oL5DXk=;
        b=mKM4Bnb03/sHUO8Mzd8x16dksQCUKLPS3cVnRBjtGGmG1Do10reZTAXvgvCPGrzaEZ
         1A6LeE3tHHx5bm84Mmzj2vuqZEkN8K6ZNnxGUCLdZXlr7GJkKe+gZqFFcNCLRhR1dI+1
         zv7WM2XE/lYPZt05CqqEL2TjczMZlJ0rQ0bG60kkPtBfLJS1MZ3g7umCRJm28bWzJHjX
         rWhhPyWXnR899dm+bVAG20I20kchFbinql40N9ijM1FcL/TgNJKjGAhYu2hWVzyZCFRb
         On5lPouQp4stkKXSJm3K1p1/Z7mws0qOMz8VVPzz3Kv5onoUmUX0KpaXHrEWa/LsL3r9
         dRpw==
X-Gm-Message-State: AOJu0YyRMzrC415tM6x17M4ZWxn9/U6C3yW7snIKiKXv930GveJa7GgL
	L79CXw0lQ7Ix8pUMoIvtKMb+8fWH34kXfvDNM/vdOCjlnn6WqYv0YqB4lxef/fFlR+0IhbuY+hi
	k4KwX8Xc=
X-Gm-Gg: ASbGncsZchb6N7bLi6BkSKtmRisMMSmO5HZalz7srYDDtxmB0vjC2osouV9u1xeLgIa
	5OuqvTKH7LB/3BJzaPg3wdtJYXFafXB9XbjcuUYJvJ3UL/nBBaPxB0gsR14LZggDetxb/6XtjVl
	1EX6aUbeWS5hDaGK/WA578Q5VFTKP0AeYvzE2fRIiMrKQaQ9jRy5EAhmMlGIpWl1IF5ZX8NlgQZ
	dP0gotjibfx8kBAt7Hbzat7J7ZcNvMs5zgObzYDzX0s50TWTJHmEY/hCbAxxHfkEZwab/JmTBE3
	OkuiO5WhaSJSaqVHjvmskJF6MoEG+YrWMIWs/PjKjifXj/RUcjlvpme4uRvZQ7363cJDMi5SqSB
	uTzqsjA9CFVeP+HpcvP0Pvsx/WH6H51mHCkzXsfIQaLDgRNkxGHKVFXBGgJxtEnh72TvJEPMAcz
	p5O5ujcz6X33j3/3AXXY4dxSAH5JIwtWVskHEECrh2QqEPd7rA6lYtinE=
X-Google-Smtp-Source: AGHT+IHG+XJuDUGU1/YdXwYI04UXM+d/lMtB+a541x6u0shLgzcmN1wCADr2q3hAtkpNXGxdTUCNkg==
X-Received: by 2002:a17:906:f2d0:b0:afe:6b42:27a with SMTP id a640c23a62f3a-afe6b420d24mr433791566b.34.1756139779904;
        Mon, 25 Aug 2025 09:36:19 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe90c8f85fsm101765166b.8.2025.08.25.09.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 09:36:19 -0700 (PDT)
Message-ID: <aad385f3a960df921765001f35f1a6f3cf39edb7.camel@suse.com>
Subject: Re: [PATCH 12/14] libmpatpersist: update reservation key before
 checking paths
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 25 Aug 2025 18:36:18 +0200
In-Reply-To: <20250726035855.363290-13-bmarzins@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
	 <20250726035855.363290-13-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2025-07-25 at 23:58 -0400, Benjamin Marzinski wrote:
> There is a race condition when changing reservation keys where a
> failed
> path could come back online after libmpathpersist checks the paths,
> but
> before it updates the reservation key. In this case, the path would
> come
> up and get reregistered with the old key by multipathd, and
> libmpathpersist would not update its key, because the path was down
> when it checked.
>=20
> To fix this, check the paths after updating the key, so any path that
> comes up after getting checked will use the updated key.

In do_mpath_persistent_reserve_out(), you call update_prkey_flags()
before checking for MPATH_PR_SYNTAX_ERROR. Perhaps you should check the
key parameters first?

Martin
