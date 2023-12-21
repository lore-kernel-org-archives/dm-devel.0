Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242F96ABA9
	for <dm-devel@lists.linux.dev>; Thu, 21 Dec 2023 10:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mRDpNmeD"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6d93d15db24so603043b3a.0
        for <dm-devel@lists.linux.dev>; Thu, 21 Dec 2023 02:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703154732; x=1703759532; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9HEt/Agnjbcv9DZ/M0GOa62SZcHFmpwSvE3fYxb9KVA=;
        b=mRDpNmeDP2mf4LFpmrX7D3YhXPotYMDqBpHWuDzMHg3aCtxUX0I1LnQ0x6oWy+2W6C
         7UVp/RxJQOKTURp7BoO0+w8CFIyEcaEoIObA8moGphzjZ2jnAztYUSF8QU4YVSGQUKpX
         D3pXXMd50OuQHOzzCn6Tntcyx4PAyFcBGsFRVQSj9rvAWs8p6REepxj8Mg1ckVqejXOn
         KVPz6UByqjm80qVrb/9473G1kGwbEYhvsUPnbe5WFmDc++li3TprWWyGHzWpCkwTfllZ
         +QZshl0Vjs38/tqtWrGXe/ZxQuvCqVKbzu9soqvneslVN/aMRviZyJRVG81lA5GK/Vp3
         iZRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703154732; x=1703759532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9HEt/Agnjbcv9DZ/M0GOa62SZcHFmpwSvE3fYxb9KVA=;
        b=fI2pqheBpaYYuHEHHTyzvFhYEv0QZ3VlHzlHajuUUehDmV7iGdtNTm1WpnsNQEbH1y
         d3qKnjBzHLLCPxMuft6OkdzDb/bIqleLpS9h4H+hSldJ3bvSL7a9if/G7I6aGe8VDJQT
         nt7sjLKpvW3DV5uE9ZK1KZCTqWzZ3Ye7utxt5M+UPtXLvwTd95Mx10eyDH9NHh+5s7Uo
         u0YQ8l0T2mU1KFf6+5Uql9HVqTdCnRXIVbQooH4JVDZ0GACjrymgP418wFNRPdlgOQJn
         Ax80YAWvmwftMFwihX0eV4QKibpD+lOAXkFqgHIhboU30zcp152FQWlSbwLeCdQ+fz24
         jfFQ==
X-Gm-Message-State: AOJu0YwKxQfaBKXRObaIduu3/bFdds5tyTWG5SeVgTACr41hJ5BCfySN
	ynxso8wqzblDHe70XsvWQqM=
X-Google-Smtp-Source: AGHT+IH5t7uT/SldRyiqK6cSmkG5jDgNvZum1nVCrHGQGX9hUk4auA9koTf/m4gNz1e+uGzeX9pI8A==
X-Received: by 2002:aa7:9d1b:0:b0:6d9:6712:f9ed with SMTP id k27-20020aa79d1b000000b006d96712f9edmr1727220pfp.7.1703154732417;
        Thu, 21 Dec 2023 02:32:12 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id a25-20020a634d19000000b005c6617b52e6sm1274539pgb.5.2023.12.21.02.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:32:12 -0800 (PST)
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
Subject: [PATCH v7 5/5] dm-crypt: Fix lost ioprio when queuing write bios
Date: Thu, 21 Dec 2023 18:31:39 +0800
Message-Id: <20231221103139.15699-6-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231221103139.15699-1-hongyu.jin.cn@gmail.com>
References: <20231220100333.107049-6-hongyu.jin.cn@gmail.com>
 <20231221103139.15699-1-hongyu.jin.cn@gmail.com>
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
index 2ae8560b6a14..ba6e794f7871 100644
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

