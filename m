Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A8415AAD5
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 15:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714662901; cv=none; b=iXAgEijwNTizMkPM1xo8iwA83Daph0jX4wx3xKfa5lNUvquIQekuMoY4vOUnVpDHIKGhMoluIx6ItiMc8/xFf0mdUX9oI+hXRztHI5Ze83aENw04avMqTG2GtoLFCAxOK952N2Xqznmx7YvREJvMlKcw71P+zydPNTb2vDcu22w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714662901; c=relaxed/simple;
	bh=c3+yHlyHx9AH2/GwPu9oRsHjAIcQgqesFPxrbK4qlH4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pOO0kyjYc+wgC4Fgkj4Nk6DbT00bdjl21rrR4sNaDgl4EXkxrToVXbwD5JMQsVD0O9YcV59rlhWTw2dBNfcKak7obqVTuJACct/mOf4IeY9PEzSr/lgcd1tlOSay6vYdNQJ1gb134H+4y8DGjk0KaGaIpShAfnOeuh4Z//SVXIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PIetStnt; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PIetStnt"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a587831809eso992264266b.1
        for <dm-devel@lists.linux.dev>; Thu, 02 May 2024 08:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714662898; x=1715267698; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=c3+yHlyHx9AH2/GwPu9oRsHjAIcQgqesFPxrbK4qlH4=;
        b=PIetStntBtnoMVLWOy+cMf4p95qHzjYvXfi1qk3gMMDimZCIGGqOU4hMyH2KcM+ehk
         0c+EVJasu0Twfu/x0zKudXvHMg/PauuE9JqiaevOWtj5/lcXa6bXk6jKYOYWcRT6CbVs
         MVX25f6tjVCLgAXtwxuYwnARsqf0ZRkgEehmo2xzugVTG4a0hjtfSEgJs4eUHXSh0Uan
         cdbwa/tJ+AnfrWsY4XjwHZmbufwRv+mFlRa6dZWR/3y+rAKpqqX6oCXluOT4kcTUlFaL
         1wrgTy5svW+0gwjPUPBaQ4Z/rooqnWVSEEjQX9rqkuS41jXLxoMbpp74PhqNZFXdJvZe
         hOtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714662898; x=1715267698;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c3+yHlyHx9AH2/GwPu9oRsHjAIcQgqesFPxrbK4qlH4=;
        b=aAULwfpO3n87+5CmyFLhAPXyX8UiCwyKZ/f/K+YeU/kE0lJqiKJpd/oaMvmcmlryn9
         HZA8LWAAK5NvBDAVR9FD3sokFY4RYgcX+g/EAoQOEAGaP5RDk7oUCkYjq5b1xnvkijdb
         CPqlKgDu1bP/0LcqdwF2eTOkw5ggPbai0wbyAPyWbqAt3tAbXQmYdkcmyZQskDXtVs9D
         Gc0aiyD9W6TYzRC97rpKQxQXCjGbz/PYKC5tNPYUdCz3MrSnbnyEFBfLBGzdhQm6yJ6+
         jFkec5F+BJLim7NIp7MhUUDO9AY6FVSojZmVHtSXCEYYRDZ87wy1rSglVuoyMeh7s7IB
         JWGQ==
X-Gm-Message-State: AOJu0YyPIQmf+/qKOHax5VWg60udnf4qKKqun8ERpcKM9rM9Z8M7hnQQ
	aVmL0ebwBhyYq1SV3Fb1YVrJEEidyzI6bznYvD1bL8yAr6spXIVNshzop6odXf8=
X-Google-Smtp-Source: AGHT+IGQGgD7bmi1IYhPGKmqiGs1hDBaoM4HY1xmD/2hYNOSAhhyHKYnhR0Ikfw0us3D2yZ4NIaKfw==
X-Received: by 2002:a17:907:948a:b0:a59:719d:2735 with SMTP id dm10-20020a170907948a00b00a59719d2735mr1259500ejc.64.1714662898055;
        Thu, 02 May 2024 08:14:58 -0700 (PDT)
Received: from ?IPv6:2003:de:373e:dc00:b298:a6be:282c:8242? (p200300de373edc00b298a6be282c8242.dip0.t-ipconnect.de. [2003:de:373e:dc00:b298:a6be:282c:8242])
        by smtp.gmail.com with ESMTPSA id v4-20020a1709063bc400b00a5931bde511sm659446ejf.5.2024.05.02.08.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 08:14:57 -0700 (PDT)
Message-ID: <9ee49b7c07938b38e39161a5a9143a472b01bff6.camel@suse.com>
Subject: Re: [PATCH v2 4/5] libmultipath: pad dev_loss_tmo to avoid race
 with no_path_retry
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 02 May 2024 17:14:56 +0200
In-Reply-To: <20240425233517.2125142-5-bmarzins@redhat.com>
References: <20240425233517.2125142-1-bmarzins@redhat.com>
	 <20240425233517.2125142-5-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-04-25 at 19:35 -0400, Benjamin Marzinski wrote:
> Currently multipath makes sure that dev_loss_tmo is at least as long
> as
> the configured no path queueing time. The goal is to make sure that
> path
> devices aren't removed while the multipath device is still queueing
> in
> hopes that they will become usable again.
>=20
> This is racy. Multipathd may take longer to check the paths than
> configured. If strict_timing isn't set, it will definitely take
> longer.
> To account for this, pad the minimum dev_loss_tmo value by five
> seconds
> (one default checker interval) plus one second per minute of no path
> queueing time.

What's the rationale for the "one second per minute" part?
It feels kind of arbitrary to me, and I don't find it obvious that we
need larger padding for larger timeouts.

Regards
Martin

