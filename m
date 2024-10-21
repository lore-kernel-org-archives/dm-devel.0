Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027B51E0DD6
	for <dm-devel@lists.linux.dev>; Mon, 21 Oct 2024 09:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729503224; cv=none; b=dcjit+Rzkaoc6mnNKQLW70c9mTB41BlO32g6scOrCTKNldJv3IAPNXbSjQyxgs9SWvPH2UPweYTApN6myCqRCpAzcceEFaG5PdV6SM5GIF1geprHkch3Ve/BZpFs7L96KsjnxuBtgSmR7fLRNhXU8C29mo/bQRrXqKtq1KoQjuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729503224; c=relaxed/simple;
	bh=+hvwglD+xMIZQSpeY8TNOenvPPVT8cBwFOr0rdwiYac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cj7M5FgJq2+243EztZS27PL0xfzgWiFugBmFJwS4CMx15oxAufJ4pr13ISMpKN+uVBniAxmVVUFHC2mQqATKVXy04x6g1axm6vQ6H5WXyGYX/94B3WlugNzPP/b/onYF+sZmT7Q2MI5OhKWtbmb9vQdqCqju1IyPExCoVx4E9gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WMHaqs0f; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WMHaqs0f"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3e5f9712991so2010354b6e.2
        for <dm-devel@lists.linux.dev>; Mon, 21 Oct 2024 02:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729503222; x=1730108022; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+hvwglD+xMIZQSpeY8TNOenvPPVT8cBwFOr0rdwiYac=;
        b=WMHaqs0f8NmBd6CmNGLBBoh2z53RAXuuf6xq94cY74sH95lsddantuIGcH4qpc3lRI
         w2DpINOceYVYbgkFB5Z+kR5b893Xq1pEIiRg3DrNwz5hV8Fi4Q5Ea4uZIuVAud+rlD/E
         QFTPwT2WdsIl83GAiP7LkBXYyb5kbrrCA+dvA6Q+KUG7cxa6UqVH7DIQQW0mMfZPd9Xm
         K1bKyMRJUzi2o0RtWyitnilmgQiWNLmBCgDj/uOaYvRfA5rpy2nU+ib7lX9N051UH5aX
         isYwdhCOyKY9fhG9wAE4PuRb8bY9wZxw7mnGsZCzl/QIeLteWis5xjtNYp5S7Rsrp18v
         /P/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729503222; x=1730108022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+hvwglD+xMIZQSpeY8TNOenvPPVT8cBwFOr0rdwiYac=;
        b=dkClHkTN9qMZfTXac05if6cLIIVyZwWC9bF3XC31pIxl90tuvNkLx1nahzg6EvNrQl
         FAmdx1W4Gq6Ec2aRX8yUJAlJvPrEKjAmJrYuV6MvY4B6pT38kJHpZ6jmtSkM+G9gL/Id
         4XxmfrG6amF8V7CTUknoxsIZQw2WlMFlaF1lX29XQcjzLSP0AFm/1z4uigskZmva1eLR
         kh4MC4LoeOb/6aHTPZRO1xpnc9QPP1nAYRUnWsGfYomWRjFQoqSlHPa7hjcfYjgaKzwK
         nEncwuWeeJZ9+D2DxZCTm8thkAw9aUYah/WhRUzZOjTceklfeCdGq51jIagUYeGQi5Kh
         QgzA==
X-Forwarded-Encrypted: i=1; AJvYcCXBamolg+AcrgqJxvjwaDGz0oZB/lV+KWrl505LqzVVVHE//bArZhJLXQTbn29K05fCJfh+L6TaeQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwLs4yQvrObZSnlWTIMN98OYD6DuCzlDBWr9VHlKKhzkin8wHDE
	H1guWFQtPTipxJ+NZ7KP0UACUFIXF4Zg6nhlFq2a1IJ1we8lAP/K
X-Google-Smtp-Source: AGHT+IHEqtcKiYTdbqqfRyoy/XfAUa5oXZdBUPYTVW5peAzxo1UMbv5yHBrUak4k0TnoMhvzjBSbUQ==
X-Received: by 2002:a05:6808:13c4:b0:3e3:a99a:433f with SMTP id 5614622812f47-3e602c87dc9mr8847801b6e.13.1729503221785;
        Mon, 21 Oct 2024 02:33:41 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeaafd36esm2637774a12.6.2024.10.21.02.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 02:33:40 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 87E574396293; Mon, 21 Oct 2024 16:33:37 +0700 (WIB)
Date: Mon, 21 Oct 2024 16:33:37 +0700
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
Subject: Re: [PATCH v2 00/10] Enhance min heap API with non-inline functions
 and optimizations
Message-ID: <ZxYf8VvQIZv9_Y1j@archie.me>
References: <20241020040200.939973-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AZgPemEmi7boKc4w"
Content-Disposition: inline
In-Reply-To: <20241020040200.939973-1-visitorckw@gmail.com>


--AZgPemEmi7boKc4w
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 20, 2024 at 12:01:50PM +0800, Kuan-Wei Chiu wrote:
> Add non-inline versions of the min heap API functions in lib/min_heap.c
> and updates all users outside of kernel/events/core.c to use these
> non-inline versions. To mitigate the performance impact of indirect
> function calls caused by the non-inline versions of the swap and
> compare functions, a builtin swap has been introduced that swaps
> elements based on their size. Additionally, it micro-optimizes the
> efficiency of the min heap by pre-scaling the counter, following the
> same approach as in lib/sort.c. Documentation for the min heap API has
> also been added to the core-api section.

What tree (and commit) this series is based on?

Confused...

--=20
An old man doll... just what I always wanted! - Clara

--AZgPemEmi7boKc4w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZxYf7AAKCRD2uYlJVVFO
oxXdAP9wQqt51VFB/Z0o1sG9jAlrumF8GTPSGUKzrPnp/NQr1wD/SJT0xCbRALqQ
/PjGaG28z15cfomZT4A3WrBSIvSSmgo=
=BKhT
-----END PGP SIGNATURE-----

--AZgPemEmi7boKc4w--
