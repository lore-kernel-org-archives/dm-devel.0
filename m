Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD3018B46E
	for <dm-devel@lists.linux.dev>; Mon, 28 Oct 2024 05:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730091896; cv=none; b=oPbpDOOLbQ/ZyqoMLc9KFLi9rROkMbOdWftwp5kk1W+Zk7yKjEiXK4q8nuTDyUfjDA0fWhVh5KbpOU4q1CLixTaePzLRWcrlUaRdi2m2JwirDAUx/cS9pwMxyvfrC976PaQWq/7h2ACEkjOuG9VfVTrch6fVEEaqOryDCu2yaVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730091896; c=relaxed/simple;
	bh=KuSSNhqQmzngUtpZ6jNSAOFuo/FQ56fjZ1xFMr/wqYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rvZUov9ghAXFLkoZMz4FVeTL6kns0ySv5viwZ0YxR50KXTr16352Mjg3S13T78rInTAVIaFn5l4sjXmEVkzlW9JV7x6G/f2Bu3yF3Xgl466TLgAZVIJ4SoKN33qtQpBpRO9PIvxjpLMI9owNnm0WtEgQL6C6HKFN5QzqI2L1OEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K2DSjRLx; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2DSjRLx"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20c805a0753so36452775ad.0
        for <dm-devel@lists.linux.dev>; Sun, 27 Oct 2024 22:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730091894; x=1730696694; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KuSSNhqQmzngUtpZ6jNSAOFuo/FQ56fjZ1xFMr/wqYI=;
        b=K2DSjRLxzllEhLE9AF2tOskX1HLrZpIN06BrtOlssyxxTn0HD64NhlsZOo+cVrt4fw
         3Zo6kL+aRiFhkGJ/BcSFzkMxozVtg5UIpLG85LGaooo3yvhhDvUJXXu+p0JcZ665a/ZX
         OnPev3xq3Fy6WutQti4iecrLJDhwsHipe/oPBHyNlosCJpLIXAlRacRF8vUW+9gn6GEL
         BmyXH7lWDCvUh/W4vJPuFbgjJPegmor9H+tLZduDDjaumRZVKuW3sCleA+FYL9T87BqJ
         ForVPtw8752P0t9/FpalG0dnpRBRNpAcyDdKMTDLFr9+WfJw899/yuyNyBD7E9PLH65c
         NG8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730091894; x=1730696694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KuSSNhqQmzngUtpZ6jNSAOFuo/FQ56fjZ1xFMr/wqYI=;
        b=Y1qNg2TBHAEcl42+lRtNiKmr5bUooS9KuhCK5ZKGVOkvp4XwGH/7Qv50ANtcPpMm/9
         XOYEVj34ZWI2vyAk2/1QZgpRGHRYV4MtgT/AlxzY0TVcoIM6VpRcO0W/7U6QvOURBUfe
         6KdborSVvxHhq/IBhWMlZB1Jh9SBJvM0z0uFqJ0zT4GYJAz9+1FDfJwyMFeji5l65OW0
         Cj/f3iNZ5neT/jCzEMinE3k4NqPWYQFjcscMxuJBViMLXm7V65YZUcLDaC6dG4At2O89
         GWJ321/Or9TNCiMXia/zMdWixacqy0N8o3ckzTElcINYG7zvMpqLp7t6yDr7ZhKjY5rP
         WY6w==
X-Forwarded-Encrypted: i=1; AJvYcCU4sR4TgKDoaYKJeiFlEd0/WSJjxqBm7qaG2nFbtON80jXhv64Ltt5Ndcna3AmfuR1WyM8xCfmmVg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzx31j0fyfSdS2yc/1FksWXguXr+hHFRObBYiymPLQeYulMZg9k
	0oEZJXdZxLk9tBi28cxsRb9RX2KokRKQqqLUzIxoisdbINYB41iw
X-Google-Smtp-Source: AGHT+IFjK2HF1Z+Lhqb8mZhwem9i4EjiyHfk2esq+mfa/s946c5Oe9L6ORNV02D3IRkDrGQj3ss3Jg==
X-Received: by 2002:a17:903:2286:b0:20c:f648:e3a3 with SMTP id d9443c01a7336-210c6ccf557mr87225585ad.60.1730091893804;
        Sun, 27 Oct 2024 22:04:53 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bc012fd7sm42876435ad.180.2024.10.27.22.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2024 22:04:52 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 6BFB54433471; Mon, 28 Oct 2024 12:04:50 +0700 (WIB)
Date: Mon, 28 Oct 2024 12:04:50 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	corbet@lwn.net, peterz@infradead.org, mingo@redhat.com,
	acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, willy@infradead.org,
	jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Enhance min heap API with non-inline functions
 and optimizations
Message-ID: <Zx8bcny4yPuLTxD7@archie.me>
References: <20241020040200.939973-1-visitorckw@gmail.com>
 <ZxYf8VvQIZv9_Y1j@archie.me>
 <ZxZbgWc2IsztAOOx@visitorckw-System-Product-Name>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Zbhjczx96AMnlB/2"
Content-Disposition: inline
In-Reply-To: <ZxZbgWc2IsztAOOx@visitorckw-System-Product-Name>


--Zbhjczx96AMnlB/2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024 at 09:47:45PM +0800, Kuan-Wei Chiu wrote:
> On Mon, Oct 21, 2024 at 04:33:37PM +0700, Bagas Sanjaya wrote:
> > On Sun, Oct 20, 2024 at 12:01:50PM +0800, Kuan-Wei Chiu wrote:
> > > Add non-inline versions of the min heap API functions in lib/min_heap=
=2Ec
> > > and updates all users outside of kernel/events/core.c to use these
> > > non-inline versions. To mitigate the performance impact of indirect
> > > function calls caused by the non-inline versions of the swap and
> > > compare functions, a builtin swap has been introduced that swaps
> > > elements based on their size. Additionally, it micro-optimizes the
> > > efficiency of the min heap by pre-scaling the counter, following the
> > > same approach as in lib/sort.c. Documentation for the min heap API has
> > > also been added to the core-api section.
> >=20
> > What tree (and commit) this series is based on?
> >=20
> > Confused...
> >=20
> This patchset is based on Linus' tree, commit 715ca9dd687f ("Merge tag
> 'io_uring-6.12-20241019' of git://git.kernel.dk/linux"). Since it
> touches multiple subsystems, I'm not entirely sure which tree I should
> base it on. Should it be linux-next, perhaps?

Nope.

Anyway, series applied for docs review. Thanks!

--=20
An old man doll... just what I always wanted! - Clara

--Zbhjczx96AMnlB/2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZx8bbgAKCRD2uYlJVVFO
o6sgAQDOkl5ght0n7cwDsycgwxL9nCtWIpsch3Hr4knwbp1t6gEAy9bIkKuWrBqb
t32VfpdXUndKdvmFzkg/I0/Jqw1yvAc=
=BNr4
-----END PGP SIGNATURE-----

--Zbhjczx96AMnlB/2--
