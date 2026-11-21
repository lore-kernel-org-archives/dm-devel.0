Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795281446;
	b=lVTuQ1BX36qeSQo+JuIkA+cnr3sRACh0kbBYbaS0Za7FCTxf9Q2JlLqV9zRXrByoQqMM
	 lzOZMOenOIKNLAg8cPPfV4YMjFrUNL2MdpXBU0lU3FwkTSUZGvh/m46ioBxRmYvh1SNKW
	 63zonXt1/PX0Y1dzFhFU3ZnFt9Ql+p1qQ+iwODZqaolufBEbZNFRO7YlKMSFTZYQa9SWw
	 055LyBKRnnG4jaSm/bx9eb9OhAq5UDIJyxJi098185/dy9E1tbZ5At7yqcsEd0q8f6zQP
	 0LX9smDl83KwxKyFcRZAvM1rw8KMigx+2H4xr8L+/HmB44QBOYs//Np8eXzw3MLvqGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795281446;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9tYHepOAyrgNGgS+8J1BXj/ck8yyAEwKko+ute+7xHw=;
	b=Jmevdfd/XX/juwoSYR7w68zJWQTvJlOS4s81p9V+ewsuMcpjw17CaNMnmwK+IrX4bog7
	 FIdBpMFKKfSm7PlrrcqvlsBxJZSxUwf58NjxjFYbRccTCwsfLH7DXxM1lJVjpOJlLMCuX
	 /cddsXcQSbeeGkzMuxVBRhvTfs/tBfofWl+yI7t3eU68apIAxvx3METu509sYHh9nmA/A
	 m0uCSwoxoDIz0myEhuRhNylqtqdA5+gpZ0/ax46RdjSnT1ZTcwAgyGZxUGQxS+EmtZvdE
	 iejR4QAwXLtdNk2mW4j1XNM+esb/j+LBYSiWOnbz7TSKVBNh8Un5uO24JPWSwVumvcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ii58gLQM;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D426B606A320
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 17:17:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D426B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ii58gLQM
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2f07a960666so887085ad.1
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 09:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795281445; x=1795886245; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9tYHepOAyrgNGgS+8J1BXj/ck8yyAEwKko+ute+7xHw=;
        b=Ii58gLQMacxPydOGFqEFp3TUKOXDicbfd1Jnt1J5szgfOauAI0cCk9tOSG3fAfqX3A
         gECqVM6usUjP8bX2OsP+uhxKv0ndjl4k7ib/lce2kWciuXtFHglPZaJ7eXT+giNf7/v1
         fJ33t0W5i7mWYJslgFx2xoB7aQ+dOgT7P0aDaY5NXmFJVdyOtEpJd+tfQhvyvOimryJh
         +/jQP/PePCxLBhhN8Elyr1w6BsoqAOHj5lTJ8FDC51eJVlH8cO94hnODlalUBKXuV6AQ
         mgXmYvL/rtd1LkP3GzYnc+oLb03vcVVSz3Uq0iR7f/Y5PsyW+74MkAk7rqP1DtaFxfWz
         YHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795281445; x=1795886245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9tYHepOAyrgNGgS+8J1BXj/ck8yyAEwKko+ute+7xHw=;
        b=NHiRQ3zNXg5RSjRCVBdssVn8fRmOlOSF0fLECvg/8YK7vVq7+g7h5a8G8+cX5Z4Ml2
         WHuVw2p/BrLmSTO6dg7fHslOEf2OfIlcy3TMWYUYGGpCx0IQ/L4rNm4gfWxj8CpA1eYb
         zUJhyVpHE3WEmsprscdCurZf1rz1bARPTlmSVZ+tZYJ4YNL05oCRXrJgl3LEpyCPa6Jb
         3xam4CpasxJAcp3JRMEK6ppanJp8OdgpBOU5Bi3avcuI3EPwf1rRW7zFVK/7g4Zx646O
         LP9vJhvrh5jNXJLEItkshFn+Q5s5lh700i/3QwFr/dg85+E+9awBd4EVSUE+gc7qb5D7
         1yDw==
X-Forwarded-Encrypted: i=1; AL+hErFC1XEcSX5moUPUtwHGw3OrD6Ovw/BLudNa+UQ4DkbBB13Dr/WJAJtHlT9OPWY5irZZVzh/YCQ28Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z+sbpYvb1/aswCCR/TUMLDZOgIthL7Awrzj/V2WE6R7NJUQLVvH
	OPIJvvruKjr80w9b4X8Nb7KMJpHS6n7EAcEhtLEW9/R3MfbDyzoQXq6t
X-Gm-Gg: AZFdTZeAlz5dOsxAOVU445FrGI5I/topLYWUHzVO5SKprsAFM73T4CaBy9D8C5Y5s9+
	RVVdn4RLPH7Pg60mX1TmMwqxHy2P5D6UycRunh2PRFMIdXd87T4wrx1IBITrYStYCz5VJS+mxBn
	kA1aGOmswgjFDNIdd4aaZElBAxrHpo9KKyF0XAfJDR7ZvKHnXAQ7Lfxnk+EUPCP37UMQYCUSYm6
	DfamX7HZsLBfLPz8MD78nKLkKt/971ywH7x5EQUQwNV8sP96G0xk6Z8TNGA0N29/qIAwXpp5wHP
	dRVGj0IzdeW6xhIOUrFKe7pkNGEARWSmUjRXiV0/K1ZPr2Xx9g9RlJwsbLRsCsLzP874BfuP114
	ddijpzKoezoaTXwqU1p3XMXx/9OlCXnHbRfei/OIno2xSoTaWkwTNdTNJM+EMuCahMWMFi6doOy
	nSPkSGPYllTlraR7yj5HzqUnMmejnP+X3KosR5BAzyravJEC0dmMpeFf8Jg63BFEF4WSuWikeaT
	GhZkM4zqNkoV1m/yiGl5cHzvIgmvgqbGt0qvR+pggeHS85p/4b90V8kh5E3qiSUgv8gBdnSoVir
	X1/6XvNIsY6M9EQs2kYBr0LpZV7UFrBZPTKBYIe781ekehk+RDlftcxre43f2La2LvgaXwKHqF2
	ns/gUfTpVY/WGi6dDXSb14x8LV5NXiQ==
X-Received: by 2002:a17:90b:384d:b0:3ae:a4fe:7ad4 with SMTP id 98e67ed59e1d1-3b41c8528b4mr7065619a91.2.1795281445043;
        Sat, 21 Nov 2026 09:17:25 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad48786sm9375923a91.9.2026.11.21.09.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 09:17:23 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: sashiko-bot@kernel.org
Cc: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	zkabelac@redhat.com,
	okozina@redhat.com,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH v4 4/4] dm-verity: add messages to prefetch and drop the hash cache
Date: Sun, 22 Nov 2026 01:17:17 +0800
Message-ID: <20261121171717.3844287-1-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-226847@kernel.org>
References: <sashiko-outbox-226847@kernel.org>
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

On Sat, Nov 22, 2026, sashiko-bot@kernel.org wrote:
> Can verity_prefetch_hash() still race with verity_postsuspend() when an
> active, unsuspended device is removed?
>
> Unlike __dm_suspend(), __dm_destroy() sets DMF_SUSPENDED and immediately
> calls dm_table_postsuspend_targets() without an intervening
> synchronize_srcu(&md->io_barrier) and before waiting for md->holders to
> drain.

Confirmed, and this time it reproduces.  A debug sleep holding the
prefetch buffer (widening the hold_count == 1 window to 10ms per
block) while dmsetup remove runs on the active device gives the
WARN_ONs in warn_leak() and drop_buffers() and the "leaked buffer"
message -- the destroy path really has no drain between passing
dm_suspended() and the reset.

v5 adds a new patch 1 that mirrors the suspend path in __dm_destroy():
set DMF_SUSPENDED, drop the SRCU read lock, synchronize_srcu(), then
run postsuspend.  With it, the remove blocks until the message
finishes and the same test is clean.  It is a core asymmetry rather
than a verity bug -- every target with messages currently masks it
with a private lock (multipath's work_mutex) -- so the fix belongs in
dm core; verity keeps only the -EBUSY check.

> Because target_message() only takes a holder reference (via find_device())
> and does not increment md->open_count, removing an unmounted device via
> dev_remove() while prefetch_hash is running allows verity_postsuspend()
> to run concurrently with dm_bufio_prefetch().

Yes, that is the reachable path.  For completeness I also checked the
other __dm_destroy() callers: dev_remove and remove_all call
dm_sync_table() and dm_table_destroy() for the inactive table before
dm_destroy(), but the live table is still bound there, so the
postsuspend in __dm_destroy() runs for it; the error paths cannot have
concurrent messages.  The fix covers all of them.

Thanks for the review,
Yongpeng
