Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FFC1CD0C;
	Tue, 27 May 2025 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748372130; cv=none; b=MVVzd7nklDTl+EE/GUyAJ9Fc+oBb24kF8Htvefue04NShsubpfrHsOffJiFD2/BTGTljqR8Gyvxez28mYDT7dFP1SsYbKs4j0ELylbkQWJuKrBJEgyrxsmW0u3C9CaOfB90cT8854VXL3721mEJSljlnYhLxnT3yfWDMeo2ZpP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748372130; c=relaxed/simple;
	bh=HDXaCTsUxEdeY81YLhMA8pdmocB2sFdW0FN8Boejtr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aea6C1HJ3W5ONA4ds/hc/Thya1JTeHbaB+H2r2cmqdBNVWnFPmFJ8UF67H7hjQ3G9rwVlfddJBM52T2tO4W9o8u0C4URcEsbcSzbVPFuJIhyihMnjBzZcVQO/WEv0rtlqYtTceTCnqhv2zcbNRe4qrQ7nWsQ1MnYN5O+Avb7N7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLqN274I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLqN274I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF64EC4CEE9;
	Tue, 27 May 2025 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748372130;
	bh=HDXaCTsUxEdeY81YLhMA8pdmocB2sFdW0FN8Boejtr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OLqN274IqOQEL6R+W3wIgKDhhrztXA7SN+u5J3uyZ3Er3XRnvdAhTcbq73OTp2+kE
	 +9H+RR/ftd5da6wd6nPZP1iRFT9MwsSXJj152DmolnR5v5PsYfqq5AFs/VRmVia/Q0
	 zdt9jrgL9SKAZg5ew6artpcDLlyGjw5pmwm4A8kbNLQlKcq1+jmEtsqOiVpfWSeOK2
	 rZNrTFtTJrsP5J8i/zp/pPqssAzvLmotHU5aWdVuquDWNQ941T2VnX8m2hDwaUis5q
	 cI/8m8IUZogR+LIyO54IvHz/q52mBsUcNmYfe6Aa/6ND0lr0cSB7RqowXXuXaQPDiH
	 T5R03iVy5pXKw==
Date: Tue, 27 May 2025 08:55:28 -1000
From: Tejun Heo <tj@kernel.org>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	bob.liu@oracle.com, houtao1@huawei.com, peterz@infradead.org,
	mingo@kernel.org, netdev@vger.kernel.org, allen.lkml@gmail.com,
	kernel-team@meta.com, Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 6/8] net: tcp: tsq: Convert from tasklet to BH workqueue
Message-ID: <aDYKoA8lpX_Zxrhh@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-7-tj@kernel.org>
 <CAL+tcoCKqs1m4bAWTWv9aoQKs7ZpC5PXtMS2ooi6xEB6CbxN1w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL+tcoCKqs1m4bAWTWv9aoQKs7ZpC5PXtMS2ooi6xEB6CbxN1w@mail.gmail.com>

Hello,

On Sun, May 25, 2025 at 11:51:55AM +0800, Jason Xing wrote:
> Sorry to revive the old thread! I noticed this change because I've
> been doing an investigation around TSQ recently. I'm very cautious
> about the change in the core/sensitive part of the networking area
> because it might affect some corner cases beyond our limited test,
> even though I've tested many rounds and no regression results
> (including the latency between tcp_wfree and tcp_tsq_handler) show up.
> My main concern is what the exact benefit/improvement it could bring
> with the change applied since your BH workqueue commit[1] says the
> tasklet mechanism has some flaws. I'd like to see if I can
> reproduce/verify it.

There won't be any behavioral benefits. It's mostly that it'd be great to
get rid of tasklets with something which is more generic, so if BH workqueue
doesn't regress, we want to keep moving users to BH workqueue until all
tasklet users are gone and then remove tasklet.

Thanks.

-- 
tejun
