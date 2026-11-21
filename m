Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795250312;
	b=vfWSfLjDuB+n4F1R68JjUPUiCa031rj2/TRCcGPgVGGChBPK36ugOJpbTxcCb+eYOTZf
	 Mvu1Z0usI24mIPd3SDh5ScK0pfs+e2QYjkczKXRvItBAlPNV4cOrE92EaIwnC8DxbVRBv
	 GqeHusUgTaqLOFy0RWWQdSBzhUIoM2Altei3nfHgYIijzE5yDsACvUIIeq58zzDgUylXz
	 UaFU47JK/ezSQdGwOLqMuGBCau4u38DYUBm8OyfPT9+5Xw+fmWok0pMCM6vI2Zg2aCvVZ
	 mHmdFqvMDe8TgLJF1bOnVDiAZY1d80LFXNsgOb7VO++S/Fc4RSJSBISVWKdBVlqoZLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795250312;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gaFKc+7y4t+NCCc5Twnq516Ht7D4j3VKOIlAJGwG9tk=;
	b=ft8l4tssWMEYrdfJOq+7kzMtiCw/0FfQ4l8030lkG7P2SOYWRf7BBL1LGqOt11fDZBza
	 2Zyaljhep8TIjBKlwrpm3xK8+gi7LzrJq7RPrCyo8d1+UIFbdxM/s0hXMczdpmHIzmIsY
	 LoMF+A14CHneOJLpNvZPlyVxIx1FeVCnL/y/O1XfwgOipIU1SHTuC+zGjGkipzDvF1xzO
	 TEEpXeasIi9EpmMxUnQHSoO675qLwEudPNJO/fYVBU/g/A4HI8CEot+d4dnU6uQVBJAbD
	 EI744xbikcJRIygSmE8ZUDCavw8fas7kpVJoEfYiVDSqKKmFL950sPOp5IPftROkkjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MkTOBsKW;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA57F606A320
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 08:38:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA57F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MkTOBsKW
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b0bbdeae06so941207a91.1
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 00:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795250311; x=1795855111; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gaFKc+7y4t+NCCc5Twnq516Ht7D4j3VKOIlAJGwG9tk=;
        b=MkTOBsKWOfLV41CWfNwzSYXoeWtcIOpRjXEvTO5yDDKZzQhuWwyaTcGf3mHeHfvdJz
         VxJwdlORLb3YQKnRiuNQ1HKBXeEiPM/iRPkM/HyypDG99b1m62/S8LrAwId9IL+wOaFW
         86ykKm1+X4v/Q/+5pFHqEf8GA4TVNlJEllhG0zOsK4YLsWLPXkKTd46BbjgrRrZbd69S
         v/X3H2JlBySBHt3kAhiH4dBbotbDZL3gJ9r5geu/Z+7b5sOxsc7JLA9Tylt+v/Aq5o/Z
         u9bwsJkDk+ieH9JYc7Xmz63L4S6wIy3isXQhgkLKF3jbokjzqr2YPFUmpl7Mn7nkQfCI
         BZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795250311; x=1795855111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gaFKc+7y4t+NCCc5Twnq516Ht7D4j3VKOIlAJGwG9tk=;
        b=sND1I0Zqbdw02RS865AKsPnxz9XN7oT3bMNGzdGKR7BVV5Y3R3FksKr9/Md6ECIKHq
         lCtJ1s/Kwtk5HQnve1JWDXHI8Hbvqm2Ghyu0VGfJd8m2Er/HitU9j+8uWRMTxfM94NzT
         KRHRDDeMcQuQH0jmBwIAMNJa0tusruzHR/c+iTlJvmHbFtjgSyROQ6kjZRH1mEgwgYI6
         hFsdB1TUixlLgETd9R41FyMFS+6LYc3qGPTVFq7NQ5Udr4T/BCjfhrPMkBOmLWX1fcd1
         mmG2GiZTtj2jfbC/SIcwV1usXz1lP6gE1LzsssbI8G3ciJi84idTj3HwupOZAuREYHO8
         H/bQ==
X-Forwarded-Encrypted: i=1; AL+hErG/VMlsYBOJIiHlGJfenv2j0/nyEEm56PBrv+6LTU3I1GnYbtm6pI15EWhfzsh/PdhmDbA9YVZ8lA==@lists.linux.dev
X-Gm-Message-State: APuU4Z863XKgg40Csl5fIva7nFL+xNaR8Cm3q3uc/5HBOT3EY+fpA+po
	pB3zPRyqSh/a95WEMJzdmKpD5oGoYvIA26/qDal6YPHB7UinlWXZOAmd
X-Gm-Gg: AZFdTZd+a+xnNCIXcTWS1sK1j/gFRDYGDE54QqpBEq/6I2N/AvlcqYfj1dJ9KpzG1KL
	M8cXrm5JEkegkMQmKU7GqP+TtsJXaYqrBTK8Qo3wZw4QqM7Ty8p9IKmaSVtmzDIDTx2fHXdiweQ
	lOIHo2Aj7hFwJfCKWPnjumIACPs/AhYJkGqLuuanjnp5g1K5dLxuND9YE5MMqAymn0KqyHXMjGP
	ORJ9mG1fQsQncLph6nAvp28rEeHu02nji4YrmBRszcJG63l63HTdiX3aGMDoiuzRmV2mfqVeFqs
	iPmA10Trrm9o7P3NDoFIq4G9Laoqkwd2VU85ptXPqfTu8ZOaNulZq6LJ5k61qjpJNPDVCtsAfCn
	b88D9ceokkpGR6dJ/nTHHiqVzHjZgcXRuOyzpA8qU7f+GK2PFYr77iKx2j0PIJX5vzhk6tLNGZ+
	h8WMVxRWWcyMGnZR7tiwWYR+JEALri+B45E48pXjt7euloyZbIB2qTZNySzytrT0Iw2q5U9tZa/
	Wwajmjm4Y+GJ/ORPHWbG/5V3YsJh5lL9a2dD4ysSjifTXxGkbB5MoQrofjj1ieBDpFGqcilJC9O
	2VZCq4v4uq3GbgF8Q6SUA8b0k00wIySZdiAjcZpZF2qD960IppPmgLj9nzYolEGfoYuews6vRXg
	rt/aEPfLE
X-Received: by 2002:a17:90b:2c84:b0:3a5:c08:4c41 with SMTP id 98e67ed59e1d1-3b41c98a138mr4794417a91.50.1795250310996;
        Sat, 21 Nov 2026 00:38:30 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a33fsm7741827a91.6.2026.11.21.00.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 00:38:30 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: sashiko-bot@kernel.org
Cc: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	zkabelac@redhat.com,
	okozina@redhat.com,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH 4/4] dm-verity: add messages to prefetch and drop the hash cache
Date: Sat, 21 Nov 2026 16:38:26 +0800
Message-ID: <20261121083826.3415721-1-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-223579@kernel.org>
References: <sashiko-outbox-223579@kernel.org>
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

On Fri, Nov 20, 2026, sashiko-bot@kernel.org wrote:
> While __dm_bufio_prefetch() drops dm_bufio_lock(c) across submit_io()
> and dm_bufio_release(), b remains in c->cache with hold_count == 1.  A
> concurrent dm_bufio_client_reset() skips b in __get_unclaimed_buffer(),
> triggers the leak WARN_ONs in warn_leak() and drop_buffers(), and under
> CONFIG_DM_DEBUG_BLOCK_STACK_TRACING zeroes b->hold_count and frees b
> while CPU0 still holds it.

Confirmed -- dm_bufio_lock is indeed released before submit_io() and
dm_bufio_release(), so the hold_count == 1 window is real.  My earlier
analysis that the release happened under the lock was wrong.

> Also, contrary to the documentation note in verity.rst, v->bufio is
> bound to v->hash_dev->bdev rather than the top-level DM device, so
> calling prefetch_hash while suspended submits read bios directly to
> the underlying hash device instead of queueing them until resume.

Also correct; the documentation claim was wrong.

v4 rejects prefetch_hash and drop_hash with -EBUSY while the device is
suspended.  No further serialization is needed: __dm_suspend() sets
the suspended flag before the final synchronize_srcu() that precedes
->postsuspend, and the message handler runs inside the SRCU read
section, so a message that passed the check is drained before the
reset (including the hold_count == 1 window), and one that arrives
after the barrier sees the flag.

I could not reproduce the WARN on a VM even with a debug delay
widening the window to 100us per block: synchronize_srcu() drains
in-flight messages before postsuspend, leaving only a microsecond-scale
gap that I could not hit.  The scenario is correct on paper; the
-EBUSY check removes it regardless.

Thanks for the review,
Yongpeng
