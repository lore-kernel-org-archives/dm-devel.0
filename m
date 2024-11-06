Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E419E1917F3
	for <dm-devel@lists.linux.dev>; Wed,  6 Nov 2024 22:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730932816; cv=none; b=IfqPVX/gPAzvfJvBBtOxoavWUMxRd7B9s6CJZsmrC/Oy4bV6GlsLA7PujCanhzOgClvruZEmcmp94jblkEhp+HoJpMafbqVKWJsERuos4IiZtkyzboyuLqusvZvr7BG+6nIwJ7MOxXitAL/dj58pp4wCkaxGMFUtZ18b5QsAtAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730932816; c=relaxed/simple;
	bh=euOAgbtcfxDAeRnVNe9EitnLBH9vxraGh4uMqUZj9MU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ERjzlh6ff14iAsjm4SAveuvg7lrGaH50yzlNvGXs9Q140aCUibQAOn3fdW9r+/yhi6vrzUm7fb3uDjB13cA2MsjHLUD95BZbrwhgvQvvrvxJeldn2PNaknixi/K2WemuO76YhfAw2xW4hBffOWyUtBldbUzKMiZYKs/5eMVJWx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R3KELpHW; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R3KELpHW"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5cedea84d77so321557a12.1
        for <dm-devel@lists.linux.dev>; Wed, 06 Nov 2024 14:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730932812; x=1731537612; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=euOAgbtcfxDAeRnVNe9EitnLBH9vxraGh4uMqUZj9MU=;
        b=R3KELpHWLZmuSX7CycD4pvmsQ8rentrS6OEROiF/bQ+q7lPAel40Qhw77IKH67VhaL
         snyxDrSN8WoPPtOYZZT4CE1oeoMdAKgMSN/b+xrywmgGZu3ojqitYXENHlvDIpfYTBm5
         HvtzCLLmgSAL7fv7xslPU045IMNNoi/5rMi/t6iEoq8xZOEKLJoOtl1rTZwl7Nv9kkbE
         gPrdQiRzaKHg7g8eSC9Klt0XHQFpTHk5O+UpvQGRho1XGrWem1rAGIt0SvI3IrOhPtTA
         JPnoyr/pResqcPgjB/PTUJQNc73oQPEuTuAgX3O1mS87tCL69HDvwyR/i99oQrjAPue3
         r0Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730932812; x=1731537612;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=euOAgbtcfxDAeRnVNe9EitnLBH9vxraGh4uMqUZj9MU=;
        b=ezyZPTYysn8Y3dj8wjXsoJEeu4OourImZEcPwJS/y72E9OFR6dpU9DGHLoqHs5O8T6
         EsppOkpS1WMh8xITUp4WOyR/p+l5U18+vIZDeLeaAO7w/NLRP8UO/kQsmmKxke8B8ZNE
         I3/RUF6LaXI3bJhWcLQUiWiZpUzyOTvYfp8gOuElIWzhpCXM6asYbq4mbMksqFbJ7A04
         R6XlmCQ6X8o0BhVuC1pnC7lEbpg0/HmW8E1ypb3Fn01uhlstm6QyssFdTmCC6zTCEdby
         hv/mAVJ+32d7+rhoTmtcVOY/KSc7EfV3oBa/R0I+y6L3mzItuAO86wr/wBsdAVqbvnsX
         xwzQ==
X-Gm-Message-State: AOJu0YzWFZcn3CS5sMz5LLL7I/WspAgK3ACrLTCT+wOZ0YFYGX6kgDDI
	vkoBBHSjsYHfZ40zRZubj32L+NV4XElk+ZtKQXTR2paFCVU+k64+tI6ZscjgGfo=
X-Google-Smtp-Source: AGHT+IF7X2IIxjghwv+jWWIWfv/IggMaQzlGayRM3UfADSuiPLVbiQJY6KDhtGxiVFApgw7tkF19Qw==
X-Received: by 2002:a17:906:f58a:b0:a99:6036:90a with SMTP id a640c23a62f3a-a9e508cf502mr2253268266b.14.1730932811992;
        Wed, 06 Nov 2024 14:40:11 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0a4a9a3sm410166b.69.2024.11.06.14.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 14:40:11 -0800 (PST)
Message-ID: <bc45e240ebd63f6c016b9e27f53ae4529cb6ef41.camel@suse.com>
Subject: Re: [PATCH v2] multipathd: use timestamps to tell when the directio
 checker timed out
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 06 Nov 2024 23:40:10 +0100
In-Reply-To: <2155d4f779ec35ff9c9915ab8fc6408e59402ee3.camel@suse.com>
References: <20241105025739.450449-1-bmarzins@redhat.com>
	 <2155d4f779ec35ff9c9915ab8fc6408e59402ee3.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-11-06 at 16:40 +0100, Martin Wilck wrote:
> On Mon, 2024-11-04 at 21:57 -0500, Benjamin Marzinski wrote:
> > Instead of counting the number of times the path checker has been
> > called and treating that as the number of seconds that have passed,
> > calculate the actual timestamp when the checker will time out, and
> > check that instead.
> >=20
> > Suggested-by: Martin Wilck <mwilck@suse.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>
>=20

This breaks the directio test. I can fix it.

Martin

