Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795069547;
	b=h+bF6MsgJpqSoPLGZ6W7avqrX99IxwHPRw1ausNivXFxiYpWsi/DJA+agEEXAorsNetC
	 VeJryMB2SzZ8TbWv97TGYKi2eZ0osFlYbakZ5jbFWeI3kcWMmNTL2U8qf4Juir9Vj8NIQ
	 u7hTUpStNp78fv8FiKX4ZMulpV7wmWO5MYdq2jnhUSJ9oz6SwYqR08qOdrJs3OI/Y00zu
	 V/kNSvy+qBmqBqmEwfahKAq9HQDtzNAkzoK0BLKweM2Pdp7CAiuANjiN6TVHmosKs2DD7
	 h0Mi8xpt4YBAz+Wvpk3gj/Snl2X2FnCZrRJAgZNJamOQyyAcTuvaTwZQrBd1090OvkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795069547;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=B13IPkujBKrzvAEG/EO28Xz4oMqOP3ahOkyfpShC1r0=;
	b=CjYUnpRzNSQq2kcZYrlp1r5+9R/K/WzieSB+fByeDswZi546Wvh35xtTmU8IQz55e4fN
	 Gi01DDcRjwdcd2ki2MgeswJW+LFmojW1baDbzsiikPp3ZaSgNJC7iDpMTbI2A10GY4BFM
	 OAidN74UobD/BlRuEDGTcUKuLsXEQi8NpHfU6owOtG6brwzTsfHdtao3vIEbIVgrRs+OZ
	 YTveff5wK4WY8xUtiOG0k7FEmaqISqZmLVnkaMpCBU3spQ78bOhMY+JTMwRt1IMXHi/eq
	 ap+DfvEKiSn+5Vmf3SMaz1+y2ud9TLjTODtHw5IU1IIHqknvkoLrioCeUHNSb18TvFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="BjRY9p8/";
	arc=none smtp.remote-ip=91.218.175.81
Received: from mta0.migadu.com (out-81.mta0.migadu.com [91.218.175.81])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B355B606A320
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 06:25:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B355B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BjRY9p8/
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=aPv5vtAhvmvZ1Ntq8qJPLJcnAl07+2ec2bP64Rkkmn0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795069544; v=1; x=1795674344;
 b=BjRY9p8/VXgS4tq4SWHcUJDIOOkop0lJdw2XIdjAEwITLrHFVa4fsvmx4WOXr7v0LQYTGGWD
 1f5T22cKnX/bqr5WNuQNKMzGaILYGKgXzn1dRJGpbBfBJvl/0KWHlc/MRpgfr1lGDBbKSJ3O1In
 PuGm9P9u6uJ/JlpR3yDRvPc0=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a813b69a0796f372;
	Thu, 19 Nov 2026 06:25:31 +0000
X-Mizu-Trace-ID: a813b69a0796f372
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Qiliang Yuan <qiliang.yuan@linux.dev>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 0/3] dm thin: stop waiting for grace periods when activating and removing thins
Date: Thu, 19 Nov 2026 01:25:25 -0500
Message-ID: <20261119062525.1488091-1-qiliang.yuan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119-bug-dm-thin-rcu-gp-v2-0-055d627763c3@linux.dev>
References: <20261119-bug-dm-thin-rcu-gp-v2-0-055d627763c3@linux.dev>
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

On Thu, Nov 19, 2026 at 12:24:21AM -0500, Benjamin Marzinski wrote:
> I posted an alternate version of your [PATCH 2/2] that fixes the issue
> I mentioned. Can you verify that it works for you?
>
> I squashed it with your patch, since it your original patch did most of
> the work of fixing the issue, and it seemed easier to just have one
> patch to backport to fix it. I could refactor it into two patches: one
> the fixes the bug, and a second that just swaps the synchronize_rcu()
> for kfree_rcu(), if people would rather not mix the bug fix and feature.

Ben, this v2 crossed with your patch [1], and its 2/3 carries the wrong
Fixes tag. I'll send a v3 built on your version, still as three patches,
so that the fix can go to stable without the kfree_rcu() change:

- 1/3 "dm thin: drop the grace period from thin_ctr()": unchanged, and
  it keeps your Reviewed-by.
- 2/3: the fix, taken from your patch. thin_dtr() marks the thin dying,
  the walkers take references with refcount_inc_not_zero() and skip
  dying thins, requeue_bios() and error_retry_list_with_code() skip
  them too, and the thin leaves active_thins only after its refcount
  drops to zero, followed by synchronize_rcu() before it is freed.
  Fixes: 17181fb7a0c3, Cc: stable, with your Co-developed-by and
  Signed-off-by.
- 3/3: replace that synchronize_rcu() with kfree_rcu().

Before sending it I'll rerun the KASAN reproducer on 2/3 alone and
remeasure each patch.

[1] https://lore.kernel.org/r/20261119051620.507189-1-bmarzins@redhat.com

Thanks,
Qiliang
