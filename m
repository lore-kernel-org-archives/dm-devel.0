Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CB018CC18
	for <dm-devel@lists.linux.dev>; Mon, 28 Oct 2024 06:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730095830; cv=none; b=K8s8vbthE1TjlzmGlb9wUq8Z+Y+oLK1G7T5NRvAk9xSinriRxp8D/OKX4k8oYTbqvyus1wp1NW/H9eAiVTlvXRziulUbN+NMotEuC5vc2eCfSWU4ejlLION12covvdnu4kSgS0aKdxV/ftHGOZ410ixUfh4fnJEhl7OF7ZfIEPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730095830; c=relaxed/simple;
	bh=KZQQWIa0NmTXTrvgtfvfI9/FAmsddMyzm4sTOgHcISU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XpgTxoNqrnw0OJLFVePpGEZBX8Jum08lwmgQUHSRlfXguH5DwQT4HfBW2DSGyiX2EpouhKEhJ08Mpgf4jolE13BiwvhLLfyojmMyAOlbkttMoQKJvRitJSAIK+1NudAPFGUsfKzsLCaY3XGbuTNQp+4+owITU+/ONF7W6VAD/6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=av83U/dn; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="av83U/dn"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2e2eba31d3aso2665809a91.2
        for <dm-devel@lists.linux.dev>; Sun, 27 Oct 2024 23:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730095828; x=1730700628; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KZQQWIa0NmTXTrvgtfvfI9/FAmsddMyzm4sTOgHcISU=;
        b=av83U/dnb2DWenRNSUIyC34W8xRpMFkLj/M3hi1zCxnMrZeQsTPQFCoTnUZ2jq1x8O
         1xiCLx87RkhDCm7Ij7aTDw0hMQJu3QSKAGsJRAYFL7ccv8q9zxJ6uasFgRiJ9dwJfYC9
         SFMD6g/AWg2y9pgls5fjpU6K5NKsfT5orPUyPFu0+NetfVqNq5RfTONS1A/8sNaXCogo
         lpSqn/I/9rAPjo9moHMl/Wb7d1TaZlTxWA4F6gLiXyOOKXMjuDTupn+n+J7e7a2SkjTB
         0V5L2rBCOISSMCVhbjol/v+ELcMX760LZKE+YbjD5Hg0YPBPUZcv+BcwFStafXjuLFWu
         3P2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730095828; x=1730700628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZQQWIa0NmTXTrvgtfvfI9/FAmsddMyzm4sTOgHcISU=;
        b=wQxpA3vixSwuB6Xl72COzK9APEAXE/hN+P1CSX4jokgFgMsFP+iB1kPABydLBRy4qw
         aal6k+bremCHkYQ3U9Dh2zunFv3f83457BRv6L1UjHYkfXQBD4OYq2Y/BNLsyVDTPaoX
         R3ofeAx5ZV1DBmdB8RR1V7h0yNN4OyC+7IaM0PedX7AUWdtSQT7556PBcdNMDNqFGNI6
         Yn3V1cD7PbQBaVkp+CMTeYOykEog7NK38ss4MwQr4qg2RSgRSkLNMQnuhgcp14xmcRlX
         YOAT3+bNKqhKW+cO697ixEHctIDSt6uALrLZda1Ls3CgswQzpJO4ZZwDN0ajOut7BCkD
         KvYg==
X-Forwarded-Encrypted: i=1; AJvYcCWmRLdKdd6tmhfrBKE+SJqJfCLqsttBkXHy+O1zlnw1h+TWmInQQ577+mbE5qr3qaerZIHAkIS3RA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+1jNtvbv6jRnqkSMZpm06iQLGYe3RNOsgz0tZjhHOKkCfnEWG
	xGp6ayFK1CtjvqPEpCIhz7We+Fp5Il9g2Kx7JNw12gvqDpyLKwCC
X-Google-Smtp-Source: AGHT+IGY/C3RpGygdeotrpMgURVeqHdXpqhUm2OR3yBXK+vE2HSGrXjWe+261uWQUYpiIK17xtVVKw==
X-Received: by 2002:a17:90a:9a8c:b0:2c9:9658:d704 with SMTP id 98e67ed59e1d1-2e8f11dcf62mr7128993a91.40.1730095828058;
        Sun, 27 Oct 2024 23:10:28 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e8e3572d4esm6331419a91.15.2024.10.27.23.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2024 23:10:26 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 50A114229D6A; Mon, 28 Oct 2024 13:10:24 +0700 (WIB)
Date: Mon, 28 Oct 2024 13:10:24 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>, colyli@suse.de,
	kent.overstreet@linux.dev, msakai@redhat.com, corbet@lwn.net,
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, akpm@linux-foundation.org
Cc: mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, willy@infradead.org,
	jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 10/10] Documentation/core-api: Add min heap API
 introduction
Message-ID: <Zx8q0C6NhVPwqLgG@archie.me>
References: <20241020040200.939973-1-visitorckw@gmail.com>
 <20241020040200.939973-11-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9FVjYyjZ5YvF0M+J"
Content-Disposition: inline
In-Reply-To: <20241020040200.939973-11-visitorckw@gmail.com>


--9FVjYyjZ5YvF0M+J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 20, 2024 at 12:02:00PM +0800, Kuan-Wei Chiu wrote:
> Introduce an overview of the min heap API, detailing its usage and
> functionality. The documentation aims to provide developers with a
> clear understanding of how to implement and utilize min heaps within
> the Linux kernel, enhancing the overall accessibility of this data
> structure.
>=20

The doc LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--9FVjYyjZ5YvF0M+J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZx8qywAKCRD2uYlJVVFO
oxK8AQCkweSLHKQum/kN2ZlFuOSI7PY2IFPhUHf7EgVFWMUZ1QD/fIPIofBxwULy
ZiQmQ7b0Lko4m4TJTzn6NFKQGFQ8tAY=
=8Dk+
-----END PGP SIGNATURE-----

--9FVjYyjZ5YvF0M+J--
