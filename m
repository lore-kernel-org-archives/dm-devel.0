Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022314;
	b=310m+L726OH1AL91xFCANj5knYfNVsUPCznuWZmFbZb0d9zPSdLCSjekNDnGCJDuIGKm
	 jMEDhOhBqwyBKoSZQLIJd+/X/UcXWhrFILHaHO5I2LDg2YVej1cZBP/c+S+QpgE7lfZdL
	 GpNaC3poj7KEWD09pBwQIpYtwJA23H2MlklGLyJ1pxm4U3lW1PYHP+XA2GiBCqAbbtwIR
	 z/xBFDKIYUkvbwUpVnLnKZLhQ9rlaGDFawj3h/j6aH3AOUrx9jPtIbVIC5wl/ljQODdVy
	 LVMyqaq2yhWXEdYD6ufHWWY3EUjwnwD251pDWRDubhwjJyIFUpjqhJbTToxbw8pVABA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022314;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=za3dkggIw96v7RoR5xIfWhgSUxGgmU1G/4NEXaH2UFM=;
	b=sVVf1ajeTzSHbzqK2MuVndanAfPoBV5eRKX3Om4V3RKHWqYH7/x8QL6zrqIAt4hXawp1
	 H3NNMtTb0cn75L5WgRUXZmGKCuZ0dQPQjyYHXCO/SFgAeSEE6Wvy51DrRDLwLP0hAnhxL
	 NKbsRS+phJ/RzZojirHxndpM7FMxPSdPsuWD5yqhrstK0uAQ8gGMwGFhwH/BYBeKy7SPP
	 pSpXTHx/wDu6+89utJrzNlOWZ1lVb0uzQfJWp9/qKz2OpA2QTrFuprhoqht2bQ1VobNZM
	 GhG4JmPoOy1NtErPGqg1Qi8Xr/eb9fQcG9LFJNPMtoM7wiVfKfEginqQvJCguVuhdvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dUa2yg1Y;
	arc=none smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A67606A320
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 17:18:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94A67606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dUa2yg1Y
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8b5c3288e6cso757915b3a.3
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 09:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795022314; x=1795627114; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=za3dkggIw96v7RoR5xIfWhgSUxGgmU1G/4NEXaH2UFM=;
        b=dUa2yg1YFNBIv3piPhPm8JK4lJMRJue6va5ORgeZgr0gW0XhnA3mMeoGhEL9yUBUOX
         ndgD6eo91XaWPTpsRqCiwDS+o/KKivY/rs3hRUCQDmaw4coYF8Pr275/e55uOsY4flXk
         WMH1ZQ4rxEhlgomf/iBsoVSALrUKlWyU1LDNsx8envTu7TD/UI1HdZMdPEI0OGFbyeKJ
         FqNhezb+H6awyY4AG7sQHH5W84WGcf2vKmEcpFRzg5iULQjpJBtWM/7brKWnxDuQnNIK
         a9K11ptHR1PF5RZsQiRBrmJLLEXhud6ri7vVYxhxyGm1jph6pHfS7lKXtPg6r2wgM0UL
         L77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795022314; x=1795627114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=za3dkggIw96v7RoR5xIfWhgSUxGgmU1G/4NEXaH2UFM=;
        b=gYf4QzNdT/ryUoOclUlaPvQtUvJ2VUZucicU/iMUQvkDwVivltzDEsUrgD0KEXVa8G
         odGinX1Trke54aUuc0W5hNTODGQos0JGbvg6mBupHBlTrWVo6QSiXmUmaQtel5wrNkRT
         5GbbE8WJKvaEqNFgCe+pvpvTvaTO83SrgGi4avjYp79qTzR5HQWb9bMcQVOf7gSwPAkE
         zFugntno7+erBfeH6IxE85wOtpbBOUFVT8obUE2A5I9LhDoGq4gus3YhS9wpbHqx7jtw
         PuDevbXNgRl+5DxSuK+xq1xnsBSRj9zqKuWCFY4CeWDhkGTOLR/4l7rAL9RI4kzXUugm
         db6w==
X-Forwarded-Encrypted: i=1; AL+hErH+eMYjFU9h2DRehXeJX5d5j6Upkvr4OKVqMOinNsXVaHBvqY83Ivguzm7cml3vjcWYXVERM86AMg==@lists.linux.dev
X-Gm-Message-State: APuU4Z9b5CheUVvdx3PdIS9hnpFJlpjLgxIMnLDlU+Vd1fHXdmpAFrXK
	7uqU7Ofbr0sPzTqGMGdloXPp4vmClSyEyhMqrBrfI9kNicHFCg+bpvd2
X-Gm-Gg: AYBFou2+jJ/rgKIQ9IcwOC6ygYqMI6MJ6ozwCqc32nab9v2u09CSetzXENMkTQ4fxRq
	kuvTStKaWCPElBLJGKXGWM81z8cciOtlQD4XicBzMzPfeB/2mZ+KUCBO0J1YaC839UYB41lNpaA
	5swdK7gmzyQCvyXThemfvctWBGzzob/ITfG3XhsffZGIMDplBc4lG3LOdUv9THEcHtn+JtGj0dp
	4KmeBln66mrhccr1ieF8NtjeIUAm8uxi/xsrPTC10Fut+t6RkiMU0ejfZjUJTCUz1VBCB6/GFBV
	1CLHyzyFr3BIs4d1vl2dURjYKsVQq54hIqUX89LoTGbu3u1MYefgvICCEHXmCctffS0+RcgGqzs
	nCecTw8ggcIqrFfAjEXarXJp9j90qsblGhMf666TuhBOA0JHL1+mELxvlRFKM5LbJ5vhh3NULWY
	l6114zn5t90FZp/1VKEXWLT/ap5vKDpJRU+AWcv7pfcRVNgk7EH1omwYUvTK+UXEOlfKd9eTOpz
	u330NsEdDiROiJapk+loj8hlb5slH8hAy4dc+231qvKx8hh2NgEYMpgbaVqhnE95s2GlSFYBi3M
	v9jzbVAuImMcbhLNNyGh5dTWq6GxdOxljkqU7PIFHQZiQCbSkQud8wkkSEph9zzJENn8WITIyr2
	UYIyCPTsA
X-Received: by 2002:a05:6a20:4321:b0:3e2:827c:2fe2 with SMTP id adf61e73a8af0-3fe86ecf53emr3906732637.1.1795022313699;
        Wed, 18 Nov 2026 09:18:33 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde5349fbe5sm312902a12.17.2026.11.18.09.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:18:32 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: bmarzins@redhat.com
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH 1/4] dm-bufio: make the retain target per client
Date: Thu, 19 Nov 2026 01:18:26 +0800
Message-ID: <20261118171826.685451-1-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <avz0MuIaC8k9V9T8@redhat.com>
References: <avz0MuIaC8k9V9T8@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Nov 17, 2026 at 07:41:22PM -0500, Benjamin Marzinski wrote:
> On Tue, Nov 17, 2026 at 09:19:17PM +0800, Yongpeng Yang wrote:
> > +void dm_bufio_set_retain_bytes(struct dm_bufio_client *c, unsigned long bytes)
> > +{
> > +	if (!bytes) {
> > +		WRITE_ONCE(c->retain_bytes, READ_ONCE(dm_bufio_retain_bytes));
> > +		return;
> > +	}
> > +
> > +	bytes -= bytes % c->block_size;
> > +	if (!bytes)
> > +		bytes = c->block_size;
>
> Instead of rounding down, except when that would round to 0, why not
> always round up, so dm_bufio retains at least as many bytes as
> requested?

Makes sense, I'll fix it in v2.

Thanks for the review,
Yongpeng
