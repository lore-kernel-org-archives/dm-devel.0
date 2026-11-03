Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793743921;
	b=ujBSmabirVImyuxlPEzDusgggzcu8kpnLB1B+O+OcTiEa8Tbqomu27jQSAo8cqq+827J
	 USgkj5xg6FSWkajYa1zbs+aprmw8iqmE3G5ckkqqLzgN/8XBd/h8ZP1gjGbEq1tirLzm7
	 Hxrbor59U8+4o6O7EIMqdjXWsxfYyBV7ilAPcuVTkzYdiNivchlIjZF8146xQSlMprIrd
	 0iH0Ut0YILnaP1zGl8SSgMtFuTwMIlWd/YuvUfQk62cB3+L++S2Zy/bZhk0CUGrl1FO5B
	 GPsvVMyBroI82Qv9KMBZGg6jiVj2YAqi8knTIdPkZDrPwiCbpMOHm5I2H6lP+P1QEgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793743921;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=29SzXOHsr+yvR7p3AWFo+7biT6KhIVmMTdjA19p8Fz4=;
	b=WU4ydttYnnHnL7McKmfbyDcExrkJnUWIorXvK9YQRT3yTGK25Gpbng+Se/zsEQ9zdZsE
	 Xa8DXQL7ydTDPne8q7fbhgfp7tNbxm36SYhWe6i4WMi+79aTz38g+NUmXGQNB6lO4ttP9
	 vgPEyRDzGbPyinadBgPEl/FuMbs595KLXtkUTuFxvfZ1r5quCcCI5UqyCxi41l1YqCug2
	 u8dhdYLDZfuoiryvqtJwNd0Rj9Fpn5EMW+bQIg4JkDBYc6R2hlxb1ImM/NLmR4I6tve68
	 ZK4xQrHdP2BTKppsoNxYtHXf6yxwHq/NnJBzYtyRwLYBWJUqjSGYyjMJMvODDg29cYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kzQJuFPi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300AE606A31B;
	Tue,  3 Nov 2026 22:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kzQJuFPi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA351F000C1;
	Tue,  3 Nov 2026 22:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793743920;
	bh=29SzXOHsr+yvR7p3AWFo+7biT6KhIVmMTdjA19p8Fz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kzQJuFPi2ZJT+26e6jgDduZYCorll2vScQD+mdAuBdj9y6e9MfyRDBC4eohlLROYV
	 uJ1pDmM5/hMz94gqlFnPeJNWT6dtqIB6bBgshwXluprgYlP29hyok0dgDE2KYFvA7F
	 gdeCNQokAeceCyCvJ1XOBhgHIuIPD2ZHXdsZwIHoIo2suILrWSMMCpaVRIFqAj5abi
	 qVAICJXbdY1zicQPeyNlzku34xgL6kg1aRWyDZICDNeb36c7u9THu2kwPzs3fUPdwr
	 DNuNp1uteVsJy2p0rUqW9Rl43dT5aq3FK7WqhnOW7x3YU8d6Ly4kVVRYH3EHMD0Aoo
	 rx5jszxyWM5yA==
Date: Tue, 3 Nov 2026 14:11:58 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Chris Wiseman <chriswiseman@google.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Christoph Hellwig <hch@lst.de>, LongPing Wei <weilongping@oppo.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-verity: use bdev_rw_virt() in verity_recheck()
Message-ID: <20261103221158.GB2281@quark>
References: <18e49db5e159b72d.3137322e32332e3235332e313736.1d9cee.0000sendgmr@google.com>
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
In-Reply-To: <18e49db5e159b72d.3137322e32332e3235332e313736.1d9cee.0000sendgmr@google.com>

On Tue, Nov 03, 2026 at 06:50:28PM +0000, Chris Wiseman wrote:
> verity_ctr() creates a dedicated dm_io_client (v->io) for every
> dm-verity target, but its only caller is verity_recheck(), which reads
> a single data block into a page from v->recheck_pool after a hash
> mismatch.  Because dm_io_client_create() preallocates a mempool of 16
> bios and 16 biovec-max (4 KiB) vectors per target, each dm-verity
> target permanently pins ~70 KiB of unreclaimable slab that a single-page
> read never uses (~2.4 MiB across 35 targets on Android, or ~4.1 MiB
> across 59 targets).
> 
> Replace dm_io() in verity_recheck() with bdev_rw_virt() and remove
> v->io.  bdev_rw_virt() puts the bio and single bio_vec on the stack and
> waits for completion, while keeping v->recheck_pool per-target.
> 
> Fixes: 9177f3c0dea6 ("dm-verity: recheck the hash after a failure")
> Link: https://lore.kernel.org/dm-devel/20250423115013.4004577-1-weilongping@oppo.com/
> Signed-off-by: Chris Wiseman <chriswiseman@google.com>

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
