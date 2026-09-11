Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E609B4A99B3
	for <dm-devel@lists.linux.dev>; Fri, 11 Sep 2026 18:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789151578; cv=none; b=ouoNXc0obiZg+7+ZUHn0wYSL5nzqmVQavV3jKlwe4tsxktYSnR3kaTOiREEsp+1yMobWXyXAKk9W6re2Dj7TXQv1wyvNqFEBz/5tPZ2vcCmFijqGfUuWpqWXBd5l9wLNUNlHag6Y4unCQmUROs1tyv7NWvwA1317zvn8fb0mF1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789151578; c=relaxed/simple;
	bh=KwDZq6pIauSI/3H7u4BpMrdcFbfwVe2Yv5F5yFbCZXQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BWOPUtVOiMGW7YxLdKsuS74iGZeAH+EOl0c+zhTqHbA/G4j5EOuES62u4zjsq+zc7ZSY+dkDK8GxJliPkV5OwKPUssmBOJX0kpkFJhfLZnrZrjXmAwfJar1XoSiAQdEL0T2GPIZfCFKktFABagVFKMZGj2sRveasMMuJqziFaP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=a6KSc0GI; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="a6KSc0GI"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-4b1ba286f6bso1418856b6e.1
        for <dm-devel@lists.linux.dev>; Fri, 11 Sep 2026 11:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789151575; x=1789756375; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pnPMjQ+gFGAW1M9N+pmmkamJvg9aNQ4EZprY09We9J8=;
        b=a6KSc0GIzqbP1GG3LpR1eRmRdfJeUHteVC650v1bkZh4XbqgpSa5tNDu6Lt8G1vVO6
         CeUYaD3PxMix+FfihR7jnAPmDMeXif7FH38Wk67IGe8X4jov+gLAJBBxNNgJ0nNePY/Y
         W+2oKLpdSB3f5POODXOhrev9eTYn7QIerFA8tcQ7qYA218CdncZYAz4tvEcLamX7tRSV
         /RylQA0oR3JEmys8WSb+GqgR7moyqtbyvhUuthui/+bnH7HRbp6fWCfCpO8E7ycXpaLs
         uc4rMT/vEPoQ6pxK/S5jULcICzEF4TZSZOx1DAV8zsyKQdLyPCWVucr7Oofh3iFpBNrn
         6lWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789151575; x=1789756375;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pnPMjQ+gFGAW1M9N+pmmkamJvg9aNQ4EZprY09We9J8=;
        b=PRTYheIv9ZNCnldQxPZgP/5yli2u50Wn7qkJS+Bq2B3iWuEdvYRNI83iSogFOG7tNA
         dUwwnnWEkOuhEpMsIVrBJjRiLJEeTM2XpxKF0nq7pNO57GVoPsTxTRdWxoY/tBxZewol
         Bg2Kw/vckUt8tbvA1ci8vb3i2JWNf8kHDriYaUwaKpPPJL7v6w6AO7ll0rRhWNv/dZbY
         5gjDU/knPbe7mP/n6MKLk2EIuzoIzRd6D5xdu7jlDvoj6W868j4CoG4Bvm3YEwfXwNyV
         u6ThPDgqozEtwpz9VT7mryRNYyCk5lvdofIANKcXG4hqDzuyOdHoF5PG64+eJNjofI3I
         DWZA==
X-Forwarded-Encrypted: i=1; AKwUvBwWx9gHqUE6+/3s/KsCEhRA30pYxYh2YMQp9mV7OzCP0gbFdEhLd2rnH73YvtOSYCzuFsu+L0TIdA==@lists.linux.dev
X-Gm-Message-State: AFuF++m4+3ktf145vDOSlL3F5TU+sevopSH+FhPeJ8veQidF1qpYa8xQ
	w0m33La3/v/Corm1xzuvO/b1aURnD3YvD0snC4/xgzyRG+C/kY8SfWrsNd6oWf9RAAU=
X-Gm-Gg: AYBFou3mlePN/jRu2exu5FWcsxkO4XjoHBlI967b6Fde/skctTLIKdWWUtAn+3beGcO
	6YI1VoIre82zSiwAR0dkfAfFLKbCKxmXuPspKxJIOTFpmCIN1ZcZ7jVS1T0XzpK24w1UVyskkz1
	LnVcRP8FrSKpnSmYkamZu5gYLJCLhMN6THkjnfMbC6mbS0O8XYaO6G+ykiPsQ2FL6aghe6fZ4Kt
	kq3ErPNYTmjiQCDxeCI2FLkxSAXDAX1SzDNyuIS1MaPY6Cr5SibJqjSTEnuyoCeeEc0udeFh9bp
	Z6lbAlw318y0Jez6KipyGHbfO1YxXRL4I5R5YNA0VLJTD2xXRmrQ2SNPEZ0wMlcCeCgYjQ8V2N5
	fUBR1jRRwFaBxHHgvvc8cBy0fIdtQcz8JNcHCg2aeroPdVhKXynyBlhRB8H00gDMYLVW9qxAmuZ
	9DbokHn0iaKsqYDrbnhdk+aOzA/nhtt2/gq/Q3l8+CystO+9Kog8WBFgmKVQWbhBQ9jzKsBFcNH
	iOtzZfALyIKj4nZDT6QYlo4pdl38iwe0XTNh0tpiE+p1fCVx1F4gK4oAgfI5Q==
X-Received: by 2002:a05:6808:3a15:b0:4b8:4703:db8b with SMTP id 5614622812f47-4c1a7cd8760mr5660726b6e.20.1789151574674;
        Fri, 11 Sep 2026 11:32:54 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-47df86a1db4sm2475709fac.4.2026.09.11.11.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 11:32:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Hao Zhang <hao_zhang_kdev@163.com>
Cc: tj@kernel.org, josef@toxicpanda.com, yukuai@fygo.io, 
 ming.lei@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dm-devel@lists.linux.dev
In-Reply-To: <aqQmqb1k57PXj8Ef@192.168.1.215>
References: <aqQmqb1k57PXj8Ef@192.168.1.215>
Subject: Re: [PATCH] blk-cgroup: save IRQ state in blkg_tryget_closest()
Message-Id: <178915157351.667488.15493767508949300974.b4-ty@b4>
Date: Fri, 11 Sep 2026 12:32:53 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Sat, 12 Sep 2026 00:04:57 +0800, Hao Zhang wrote:
> bio_set_dev() associates the bio with a blkg through bio_associate_blkg().
> If the blkg lookup misses, blkg_tryget_closest() takes q->queue_lock with
> spin_lock_irq() and releases it with spin_unlock_irq(), which
> unconditionally enables local interrupts.
> 
> Callers may call bio_set_dev() with interrupts already disabled, e.g.
> dm-thin's pool_map() does so while holding pool->lock taken with
> spin_lock_irq().  The nested spin_unlock_irq() then enables interrupts
> while pool->lock is still held, so an I/O completion softirq can run on
> the same CPU, re-acquire pool->lock (thin_endio(), or overwrite_endio()
> -> complete_mapping_preparation()) and deadlock.  lockdep reports this
> as inconsistent SOFTIRQ-ON-W to IN-SOFTIRQ-W usage.
> 
> [...]

Applied, thanks!

[1/1] blk-cgroup: save IRQ state in blkg_tryget_closest()
      commit: 327c428ba79b13e4cc5253333a9d5c0aa5579bdf

Best regards,
-- 
Jens Axboe



