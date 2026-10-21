Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792604385;
	b=LLHZzD/t+d3cAQzh54sTX2kUecDjcDeaUky+2jkmV4hkqFi3qNBf14FdrlErgqDNuIUR
	 ewhJGYFNhe40CikZ91nfVt5rWedCsvjrqwyG4lgAZvOWSXtw8hCwTK8NgWMmZxKERTeiL
	 wBh7mvZI/ee9Vo50mKntkUbe+KeXHb9gNCF2bkECIgO8bdv6Natv9T3u3+hP0wl1LvUCp
	 0AF0wtAHeBuw3oMUFB5otIT1+o1Rx8Ks16plqShCHddM6Q+O0cOhfNKbyz/689he6h4ka
	 uzkggTCKxrpDbgb+QP4vtPU7okxrVw1jMxwHUpDKjQYSB7qm8slB6aXcMrBh7ADTKPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792604385;
	h=Received:DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition;
	bh=A3X0U7wQycqlIF4Vt2kJRKMjmR2g9crN0JqzOIZUb0A=;
	b=oJK+AM6MjUKLV9HCpxUVaZpcXkxRh6DBFIg6hzWualtn4RlPes1GpFu/AR4pAQyIzhiZ
	 jLBq0O2QCxHE5ym360AjNcn15DfoXuJxznM4ZzMgd4E5NZ5CVzhsWo+sBDTKrUoarD0Wr
	 wyKW0NpWmjb+RDsU8EuLRFhM1XbNFEsCnsECqca7m0fMADVLnQhH3jzMRN+mI5UDWEvTC
	 Spwr7Hu+jq/rMp23vlNKbtRCFcgKfok+cdUUamLJIb/Cgf4Rnos1X3Nq4fFFVqxK285sB
	 VIGWUVJJZzrF9gaq384IvOIHoO7xAn2Hjl9MjC+VsdQ1xC8zoXrFi/qg6J8V4XrWvow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRS12HQL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D313606A31D
	for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 17:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRS12HQL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79821F000C1;
	Wed, 21 Oct 2026 17:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792604385;
	bh=A3X0U7wQycqlIF4Vt2kJRKMjmR2g9crN0JqzOIZUb0A=;
	h=Date:From:To:Subject;
	b=QRS12HQLDETno7mR0AODSEPMfwkctf43e/xavFhbrHJ69dkqbB5ZuQhfQJeKeaVK3
	 oj5hHCF8CI/Qg6ALbCszH1zC8qpdYdDZWPVkn/CRtvtsakDsrUj668qBPQoanjSYVz
	 hqjmFeAWFdhV8uxVCXXy/6UCOB07952Eit383H0sfZaXrlDPhv+V+IHhsZzPbozZn5
	 I0UtKMMacUm5Sxe3Som8lnSI2WXhtS5gzDMWPjzmCLpFWlC0zgjWb8oNfNkE7MnN9V
	 2zGGeOn3bBc3XxWFntKtFniovm9gK6hpdCV1x9FspvOLQlOIyKG4IX41mwmW84ALeD
	 Tq4gGd3muEn0A==
Date: Wed, 21 Oct 2026 10:39:43 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Enabling Sashiko for dm-devel?
Message-ID: <20261021173943.GF1879@quark>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Currently, Sashiko doesn't monitor dm-devel or send email replies to it
(https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml).

Sometimes Sashiko reviews for device-mapper patches can be found on
https://sashiko.dev anyway, due to the patches also being Cc'ed to
linux-kernel which is monitored.  However, get_maintainer.pl is being
updated to no longer suggest Cc'ing linux-kernel.

Would there be any objection to enabling monitoring and email replies
for dm-devel, like this which various other lists already use?:

    ["dm-devel@lists.linux.dev"]
    reply_to = ["author", "list", "recipients"]

If the dm maintainers prefer monitoring-only (no emails), that could be
done instead.  But I think the email replies are really helpful.

- Eric
