Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2082FB969
	for <dm-devel@lists.linux.dev>; Tue,  7 Jul 2026 11:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783424814; cv=none; b=MzFjnFjkor8Ug6S6PI9np9OwLy1A8zlnhJerCH4Tk8K/lmgFjZ53uwBJ9N4xfKFlhiqm8iEmK1GX0FgvEFScFXG8oCBVPowV7xDDzGzVtRRlFoAUvY75t47dsrwBaZbWZxeSsZl4IPloEUm6kDLFiBc3KLyAEUtGpwFWKbxCYPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783424814; c=relaxed/simple;
	bh=LJxljUAzF7/z1VIqjJP3usSzeEz1a+MTP4YEINP5l3g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MJQ0BkE4NEJFh876S1E5JzSBAG6ByxB4TlxOM/MR0gfsiu5H/Ap9y91Q16J6xsye+X9mANfZnYWTpTD3H9X+S2yiqNjPXmG2pE209nE5dpXTukJUA7b3s2sTc3IAUV0dxAq/zj2M4R499dGKba//U8RDLouq4lLL+x0y0rYX90w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O9XuW56J; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O9XuW56J"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493b1710405so25877165e9.2
        for <dm-devel@lists.linux.dev>; Tue, 07 Jul 2026 04:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783424812; x=1784029612; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LJxljUAzF7/z1VIqjJP3usSzeEz1a+MTP4YEINP5l3g=;
        b=O9XuW56JyazWqhuY2Tb53o5SOqwrTv2sRLK0Qr3t4tpsQAIN/hnN+YaM4qBeyTtje9
         Zmm1X81fgSAHPgK/349HafoOiB+9c7LZVQiMTIvVGSk6XbxbI1Y9DsbujYTGCVozOdU2
         1DNP4tCPtj21wDZQ6ClIWfEpGYPUD1hHUYnkjML54/hCkdtvv9WGjIgeIf46Dq09dZCf
         pNLgyebLrLGuQ6iG9LzWwnYdLA06uICfL8/jLAAgCRiU08Zqvg1OjHBTh5T1I9cs0lnU
         m1sQcOvuvvNv2K7lEUgnlEoZq0gmRDnueQ7I0PKeNv+h818RUJXh0TU7OmoCg3IwGTXz
         yOXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783424812; x=1784029612;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LJxljUAzF7/z1VIqjJP3usSzeEz1a+MTP4YEINP5l3g=;
        b=sWXxaEyq3TQyWWjg9WpOmSSr7XLERFWHAcon9Aa7YQqzZiLezcUTAnBynWrABQWOxS
         DI/3GOjKW0gcTCseZTMoURHkaGDSnESojU7CmmsgEeQOJnIdIfoXhBBoB1Svq42mRljH
         Tnu4utk6JQRxeIJbaH4AJqiWOwti7Z8jJ7iQLgeY3B2z2lOgI2nzk5CbnGaJA9SnygtN
         285HGS2KIq6czdMDGpf1h1VySlr8RpBdhYNIp/JGnyKLoZpYA+vIEkpvw+XebjTkTjZn
         FhVp2KKmQrozqorAmMmGY8HTz1M56wKqH6x/mmb/YpP6WIB4f336cMaQ2ZpdbHb/1mm1
         NppQ==
X-Gm-Message-State: AOJu0YxY4cr+aFcLwl60rwlElc9yZRjy3b/IcM3oHDQ8xfL/FOsJf3sY
	oE/fVbB6EiNGVoSq6c3RMbMdzzJoWXkp6h40CDhrsapAldPTD9k+8LXNzVSRVFjte2k=
X-Gm-Gg: AfdE7ckBvkl2Lenp+f52vlaA4uWKsKHg3hM90scLoVyJqG8aJwpcbqasWtFlN6yzzJk
	GdZdpa+HVttmrJCmSQ9P/SJV04IuoqLLbWDC8/fB6NPtmvdu3/SMncuVfbBE+6z+2dJ94qn1QNs
	lhkxbU4oyw819rWQX0U45Bfsh/QVs4KFo0Wg2dym89SxrN6tAUr9ZSqB7GLljoyB+ioA8L7w39Q
	kvpDpgXxl4weAhn2/OLeMdCsTTw6w0plg9VWmOB3Wt8QyP/jHmogujs8vo6tRADpgHSWgSXDWos
	HDg2frFmndB8YBYqM48ZQnmW/n/minH/jtGPtW6UBfeQObETwa0zFizImO4XkWN/daTmCjuAQma
	0m8JLSgdwbnU+nxkQm1guubZjI/L2kzuIFlwh8lcymXxPgnisVeq6c19igl2ZCYZp56Fozz1B/i
	RGJ0J3sjUoOwVy6vxJKjDT2mNhJYQJNNVImpddl8/HfdDeLPAVGgMuzZl6Dlm1KB332oq5FELaK
	Vy0Pj9g4D07a23qh7DEgG7y7/hrnCJ9sWk0aJGtRm5WniEugTP0GERdjT35gQ==
X-Received: by 2002:a05:600c:34d0:b0:492:40df:d49c with SMTP id 5b1f17b1804b1-493e2a69526mr19568955e9.23.1783424811506;
        Tue, 07 Jul 2026 04:46:51 -0700 (PDT)
Received: from ?IPv6:2003:de:3746:1100:f390:c52e:1c24:9082? (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039af67sm38875762f8f.17.2026.07.07.04.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 04:46:51 -0700 (PDT)
Message-ID: <70cc82feb7bc45076f566d507a4da764c7bdf819.camel@suse.com>
Subject: Re: [PATCH 1/2] libmultipath: make sure sscanf sets a max field
 width for strings
From: Martin Wilck <martin.wilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 07 Jul 2026 13:46:50 +0200
In-Reply-To: <edd01616-ab8f-4cec-bae9-5f4e84e1cf59@gmail.com>
References: <20260707004817.1958264-1-bmarzins@redhat.com>
	 <edd01616-ab8f-4cec-bae9-5f4e84e1cf59@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2026-07-07 at 07:52 +0200, Xose Vazquez Perez wrote:
> On 7/7/26 2:48 AM, Benjamin Marzinski wrote:
>=20
> > Note:
> > This patch applies on top of Martin's ("libmultipath: iet
> > prioritizer:
> > obtain PATH_ID from udev") commit, from the "tip" branch.
> Martin, this should be removed from iet.c:
> "// Uses /dev/disk/by-path to find the IP of the device."

I'm working on a fix. See my "tip" branch.

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)
