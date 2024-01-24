Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A011754F
	for <dm-devel@lists.linux.dev>; Wed, 24 Jan 2024 05:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706074586; cv=none; b=tSOvjiRmSt1PqalDXSTBZHb6R42GiLoY/n+DDBOBt3dHWIvUVIslnHeDO/5IPc+ISc+xYM+5AJOYW5eSZHC++qttgc2LKWzAY2uk4II/SvTLCZB5nIQNhEOA6mlp135l+pq4aSTHHl1YBrtWpkP+JG4xFbd5bBgzJgkZLUJpAew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706074586; c=relaxed/simple;
	bh=FTonyJYMrGMeqQkJelHx/h0+QUGv7Ul6tpIhRdwERfk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pW0DRbnX7KJXu1EE9c/s0juMfZB/jVodJ8UzGmT1lM71V8DJcVG1NldPNlq0Bt7gk4zPWixYbbcd5stOdbGp/Kp3RMGyFjz24rjEB13AOygJWJeDj0xOuah17Hy7/z4mjDMdu5127TyVpIxlRPyGeaRp2zHley0MKw7J5IDDBVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BVleDxlg; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BVleDxlg"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d7859efea5so363365ad.0
        for <dm-devel@lists.linux.dev>; Tue, 23 Jan 2024 21:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706074584; x=1706679384; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cpy9sRZAItz627ZVJHW5k+R1D4QC+yLepEX4TtJReRw=;
        b=BVleDxlg+FqLX3ZERZxq56+YZOrWzI/kiURuGM3CmiN+wAcFT70xKLTgcoNayY1wP/
         XKfW5J7GmtDtJmCI5ijNFOuhMi11BA96/oQVhO/j7vga/18MpzdWwxuZ7QB6pu7m9qGJ
         K1GJ0r4BUNVcCUZBJ6GgHHpDrjkBMVkcnbsyfr4x+P/kmNpVWwnox2fCCElHYhKZj5n+
         cuRiukz2ItT9bVXkcAJ90hX2Ond8towhu42WZI3DrC5MLXxt3FQvgsWmqmf8lTlkorcO
         yyBtatP2JEOi9+KDCRCzniUR0a3zEfSxtk2vrKuXA5fA5PjPp+ToiGHeH0f1BJdMOU7l
         /0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706074584; x=1706679384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cpy9sRZAItz627ZVJHW5k+R1D4QC+yLepEX4TtJReRw=;
        b=wFj4HhY5I6aSs4fIVoCG9EZTaZ6K5UpeGzMquZl8X57vLJMmatxeMj50zYS72Gc8al
         k5512FaMKQvTlCETdgciGbU118pfABtd6JZypihkdv1zBjSBKS0iKqqsBcbeTplI8Wyi
         Ina5xIAjJFuHV/R5m2soCKEVAugueeW6gpC1PDIGnJZkzB90pLTdQk2PoIh1gAqDz3ia
         xNGj61NeyxeL+9eXtBt04oxGzt8ICyEeJbov0fjXup0IkPO+C7TqMOc0aylkkiG6xNWG
         v3R89+pETyXRewKP91cCJCgBdZAWvj7IpN8DdJJvU5rIGsjSouHrUaTIrH31xbPmHupx
         HDGA==
X-Gm-Message-State: AOJu0YwkRAQOxq2KZ4Y5biWVctI9l7a5KzTv75SOTNiBX5RObrYx26bY
	K9bPSk1XQL5Y6CVARvvQFKUaIdKNGB3K4FnwwBwHsWrKtMxhRStJ
X-Google-Smtp-Source: AGHT+IEIOYQLu0dIgIPZVyXxKuK3uq5zhGh24Xtj2CiTZiBfSNhz+tQUUn79+VEaRwxYntSMRlyOXA==
X-Received: by 2002:a17:903:2447:b0:1d4:7687:833a with SMTP id l7-20020a170903244700b001d47687833amr215421pls.17.1706074584135;
        Tue, 23 Jan 2024 21:36:24 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id kt6-20020a170903088600b001d755acec64sm4015663plb.189.2024.01.23.21.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 21:36:23 -0800 (PST)
From: Hongyu Jin <hongyu.jin.cn@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	axboe@kernel.dk,
	ebiggers@kernel.org
Cc: zhiguo.niu@unisoc.com,
	ke.wang@unisoc.com,
	yibin.ding@unisoc.com,
	hongyu.jin@unisoc.com,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH v8 5/5] dm-crypt: Fix lost ioprio when queuing write bios
Date: Wed, 24 Jan 2024 13:35:56 +0800
Message-Id: <20240124053556.126468-6-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240124053556.126468-1-hongyu.jin.cn@gmail.com>
References: <20231221103139.15699-6-hongyu.jin.cn@gmail.com>
 <20240124053556.126468-1-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

Since dm-crypt queues writes to a different kernel thread (workqueue),
the bios will dispatch from tasks with different io_context->ioprio
settings and blkcg than the submitting task, thus giving incorrect
ioprio to the io scheduler.

Get the original io priority setting via struct dm_crypt_io::base_bio
and set this priority to the bio for write.

Link: https://lore.kernel.org/dm-devel/alpine.LRH.2.11.1612141049250.13402@mail.ewheeler.net

Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
---
 drivers/md/dm-crypt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 855b482cbff1..e0804a86946f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1683,6 +1683,7 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
 				 GFP_NOIO, &cc->bs);
 	clone->bi_private = io;
 	clone->bi_end_io = crypt_endio;
+	clone->bi_ioprio = io->base_bio->bi_ioprio;
 
 	remaining_size = size;
 
-- 
2.34.1

