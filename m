Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F13267714
	for <dm-devel@lists.linux.dev>; Sat, 25 Oct 2025 05:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761370008; cv=none; b=JxUt55EWeY3uIQta0ez6Xj5ui3Srqg4GGeJkOHozn1I4QUPHilMi6oO318ZVUoBP4eRWIPm45PBwpepYEcHYIslYDcZdTRsAa0iwz8ez8rnWoIIqTgGdiZrj4xL/MNYVOa/tEk+tuqZj+y1admS4EnCNVaxn5JOrCqxfBXuZIzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761370008; c=relaxed/simple;
	bh=/zQwfhMEJhTOa5/FV1euV1Dku1nFTDlTsbnBQjlqjDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtO/NLMGHzvXqAruYTjMXfrJP/xzT2AXafzYAT4u/pVfXsiTWqIiTvt6VZJ7uebGuIiBU1ixR4ft5LCWpUIUD4upGAkaBU1Psq4i5h/UGWzCq/lfncz3Yuzmxf1k97DBtW0fQQPihuN6rTY1MzPuUVXktwjHGMD4MUuDqc4t5SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JP9LRKrF; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JP9LRKrF"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63c31c20b64so4945460a12.1
        for <dm-devel@lists.linux.dev>; Fri, 24 Oct 2025 22:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761370005; x=1761974805; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mV8buuSZQP0rHOq5S4b8K+cOmbjRvDVQwA71gPDHBAE=;
        b=JP9LRKrFUu+tsGy0esuaoYE2yDegJdOOwqNi1CDdQQ+sC3zBYEe+PUXzP3Vq7o9lX4
         L/8wQ5+hbiYrm/UdbSQKOu8NHvjAcZbBEs3JqR5YABN/yLjgacjxFaAnowTrabzgY3IX
         0jd2o0va91UKiExAE36Ffl/9UDuJfCbF7LxubR9tR9eKsuCGByLTk45U9VGQ/o0BjLE2
         y0K9BYqkt20w1inCU/raYVo+66zIjlhX8lP/lJt+pN6X6uRxA5orgk3ROhh4oQSUZfyJ
         WjsoxCxlKUMwAjD1uxv95K4/L8VW5OLM0peMgETqXOFgGqzj/AVAgth6Pz7Vy4RK5w4b
         PX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761370005; x=1761974805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mV8buuSZQP0rHOq5S4b8K+cOmbjRvDVQwA71gPDHBAE=;
        b=AHpx//uIFclRkcdS/Tq0o1NuJSn+NKwer7YF5s2vt+Y9kFcIjKLshhz7l/uhalwvwW
         decgeDUtQvbPXdYbB7QG9gqenUyBYuiOC0vQrocBxIri3aGp4icwOJ3pjKntltbPoosz
         2SUiPz5VYu0Y/rDTK1qpE4tehQfA1HexuaEH0jKOhckzBX76lWJAyL8h7S+AaCThWSCX
         WlkMx4BTCUR8C6zqDiXoXL2i3nplBjHzYJ/XRXG8jY0aOCKpi70UvlHMdYc/fhf2athU
         6PYKNyzf2ui1Ue0xt1C5MAbFrWd780wD53hlEHMgKWkUT4SFeHPW6u3h2Om36Y/LGnlB
         yYXg==
X-Forwarded-Encrypted: i=1; AJvYcCWSoUOKsXt5FvxkRjaDV9oE/rK9/GZ/DMqiwspIn87GdXLvNjcF7Gpcak+zYbljIUAV4JeU9uvEUw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyDYhvgETvyZNf47qn44hxjxKlyVR5I+bXmNh8LpG2LOjPew7OK
	46Eeh8PyXeDNEBiql+38hlcpY6EO4ykHvMkxNL5iZFNtPH7JDCBkJCUM
X-Gm-Gg: ASbGncvQeuhPb4+9UBs8/9sr6EjkJkx5f4Qu4RHdUSDFvAzyiyJmgiCXVGxG5p9y0TE
	xRIJsn17+bxj1+o6gjY1WtP+kq4WozxLIbL88w2uK+51/oC6MlrArn/1/5g0PF6TClRQysoASvE
	xZt9ePc8xo51IajXlFLum8RC7GAYlqll6X6wGV/y7RlvYpIjCR3Tr0jBQ6qBIAwupiSl/e3b9R4
	WMFX/Yn5JJbOfO3eaoIYJKhRd0Y221bDE6W0QCoWVrc9RnwLNIk7N7Md0kacfMyDCKDy0t03vis
	TQrYnrSl9NjXpEGeGjuenLtvav657aVfTQ8VcmCl9ILjjyxIAsG8tJK6C1/WDvlz022U1Xg+CXS
	tGP6olpp8xANJtO6zyg3I9+tY/oHwzjT2gPUsYOZOX1QM4XEbcrLccMCQUXna0qjnPoI0FhXmHX
	41B5l6UMWdOT8=
X-Google-Smtp-Source: AGHT+IHk4JGeekekahtUg2k/EhAC9kyrxVTGjCsIExfHrDtgIcN62P8FCtHZWZXypDamfyJkpyvf/Q==
X-Received: by 2002:a05:6402:40d5:b0:628:5b8c:64b7 with SMTP id 4fb4d7f45d1cf-63c1f64ec00mr33191598a12.6.1761370005212;
        Fri, 24 Oct 2025 22:26:45 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-63e7ef96105sm880960a12.19.2025.10.24.22.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 22:26:44 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: safinaskar@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	gmazyland@gmail.com,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: dm bug: hibernate to swap located on dm-integrity doesn't work (how to get data redundancy for swap?)
Date: Sat, 25 Oct 2025 08:26:37 +0300
Message-ID: <20251025052637.422902-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024163142.376903-1-safinaskar@gmail.com>
References: <20251024163142.376903-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Askar Safin <safinaskar@gmail.com>:
> Here is output of this script on master:
> https://zerobin.net/?68ef6601ab203a11#7zBZ44AaVKmvRq161MJaOXIXY/5Hiv+hRUxWoqyZ7uE=
[...]
> Also, you will find backtrace in logs above. Disregard it. I think this
> is just some master bug, which is unrelated to our dm-integrity bug.

That WARNING in logs is unrelated bug, which happens always when I hibernate.
I reported it here: https://lore.kernel.org/regressions/20251025050812.421905-1-safinaskar@gmail.com/

-- 
Askar Safin
