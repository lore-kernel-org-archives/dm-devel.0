Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7911183CC3
	for <dm-devel@lists.linux.dev>; Fri, 23 May 2025 11:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747998262; cv=none; b=n2gcmlsgbV6VOCRR2XY/wxkyaMLG1IIqO4XoVcydf7ZnLXBLZA1ezVNHXLCLCql5gVn5wlUbppqzYMn+U073+yPMxyC73CSsCokXRgic23X2PEobGELjH3poGnfshRrjIs+QvESgMF6C6hg3houGxo0i7RpaBFAkVveTfrWCneg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747998262; c=relaxed/simple;
	bh=5FYXBRnkV12y91zTfM5DB/fnzfbSst8UE13awLrbTQk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cesng43yWV0ODvSbvHIB5iMG7kyAvAk/2hDFmh+ibcxEJbg5VhoMs0VcmoCdebI2WqqeDbWDQIX5FLzggPvIRk5r7ghoyXOjBJ0Kc9OlbGxY/XnO7DK8DKBri7ekPUaPuPiXggNwASHjvg/oW6PVcw36ga/Vk+1fqVSQczJoedc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IDW+5L2K; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IDW+5L2K"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43cfebc343dso69882555e9.2
        for <dm-devel@lists.linux.dev>; Fri, 23 May 2025 04:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1747998258; x=1748603058; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5FYXBRnkV12y91zTfM5DB/fnzfbSst8UE13awLrbTQk=;
        b=IDW+5L2KJQZyaX0R3TKAopFOYAvTgmLzspCyXqX+TuyAA5yPcQcGuRiFwcVUKpPYDo
         g5zxW7WNj4QdqlUZ7AmXTrD8WOdgmblZDv2hn23zIwgt8/N3lgHBkBAmO6+XR+7OH5xC
         3tjzywPWn16Kcw4k9XODC33MENKcuUbKZ7hxEirhApitPYDKNmIJxo9l1aXmw4jaxMSl
         vaGg0NAaVorPAdukDkgrwXo6SWXDN7UJmhKsRFT1WezDSROyLct75mRPmJjV4TjRb31O
         Lpz3ctBQEfdcOHoek+1XCfEDCvmPtu0vP455rJnjRLFgjRK/Wjr7ottUGD0c6n3HkFGr
         Wppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747998258; x=1748603058;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5FYXBRnkV12y91zTfM5DB/fnzfbSst8UE13awLrbTQk=;
        b=FOSUSS5rfS16LwrGaJxPVvhEYzrAc2F8ui9MZw0EsOlPFx3hU/NO0FC3/ZXevvdwpi
         GYwl4wZUlTFcI3HI7IMFG/MJYnmurtu3yWi0sWu/lVcNWFIIzCmq2bdgpNLeGc5lxYgC
         bIYzstCGt4HMH979XVeTSmQwfjNF7nJqyTkR8H/fplB3Ct8RPUNtZkKvXIucbZfKeQhr
         BrSaxeWS8UoQa0BbYc8XJ/tIThm7AdTAtRHJ8GsKbqZeOGYPvfYxvlV1I298OnF0L2Zz
         LYzgisRCrUOzDLveo3Nhw1G0PwORFouGPNEhvxr/Tar1jW01s8EcSRTUTnNoXWLDxQcE
         Pn/g==
X-Gm-Message-State: AOJu0Yy2+GpKhQOdjSqb8VVbz72nCNnA4/huR8leQrmrrmLRssWg19jj
	IZK4yrRxZxxscTl7LGcIwxx0kM7pjiLk+VSUYt7Jl+paDlzQICKlAdYWUwjzmo9ZtLY=
X-Gm-Gg: ASbGnctl4uRMTWlDcS+fifiksOxFhOdzBZl+R2Oticg1j8g8xj6rubhA8s1Ddn5qCw0
	aQoGShaW+F0yKG+v/tf5zhmRgks49ptmTehpqLE7+9W6pi6xgSnS+LQXNgZ8NUwJNfZpdYMfVsY
	8J8ypNhCxiuFMJ4Amv/DB2Ik2JLekV6+WNUS2572fQ5ltIWvO3Jkkl3eRZ64JTStGPdls46lihJ
	+yg4hMrzXfaWv9gzZTmpILw92tIKq0ys9W7Z0nFWUQT1ktbUR8/5ZbSGUnVI+VssQSIlZ89H1tg
	tX6AOy+rFD+Ob7GvQ0hfJjHp5blB2FSZkGKnRFqy7Sa4fdtGb418dIBUwbbTo0WdkTE59ORDnTP
	wmghDS73C1Jhw4zTNDLg=
X-Google-Smtp-Source: AGHT+IGC6bX8MTmyvsnV6D/ISIJRJjQc4pjxNP3P+7KwHpK3r8I6qXJvVS9VhRMH0gFpYvvfxKMJ7A==
X-Received: by 2002:a05:600c:3e0a:b0:43c:e478:889 with SMTP id 5b1f17b1804b1-442fd5a2c09mr324970275e9.0.1747998257740;
        Fri, 23 May 2025 04:04:17 -0700 (PDT)
Received: from [172.18.125.123] (ip-185-104-138-49.ptr.icomera.net. [185.104.138.49])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f7d975cfsm141146035e9.38.2025.05.23.04.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 04:04:17 -0700 (PDT)
Message-ID: <4b4107e368e68588dd21d3d386b7f84babc5ed1f.camel@suse.com>
Subject: Re: [PATCH] multipathd: always reset checker interval for failed
 paths
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 23 May 2025 13:04:15 +0200
In-Reply-To: <baa4713be2b579189fd40d3a6e4b8aca897baef9.camel@suse.com>
References: <20250522002623.611830-1-bmarzins@redhat.com>
	 <baa4713be2b579189fd40d3a6e4b8aca897baef9.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2025-05-23 at 13:00 +0200, Martin Wilck wrote:
> On Wed, 2025-05-21 at 20:26 -0400, Benjamin Marzinski wrote:
> > The are multiple places in the code that can set pp->state to
> > PATH_DOWN without resetting pp->checkint, most obviously when
> > a path is failed by update_multipath(). When this happens the
> > path will continue to be checked at its previous interval,
> > instead of switching back to conf->checkint. Fix these cases
> > by always resetting the pp->checkint to conf->checkint when
> > updating the state of a failed path.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> Reviewed-by: Martin Wilck <mwilck@suse.com>

Although this patch has no fixes: tag, I'll consider it for the stable
branches. Objections?

Martin
