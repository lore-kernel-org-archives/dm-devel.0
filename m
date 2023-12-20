Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205F320DD0
	for <dm-devel@lists.linux.dev>; Wed, 20 Dec 2023 10:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g9YE3slH"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d3ac28ae81so29808965ad.0
        for <dm-devel@lists.linux.dev>; Wed, 20 Dec 2023 02:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703066658; x=1703671458; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9HEt/Agnjbcv9DZ/M0GOa62SZcHFmpwSvE3fYxb9KVA=;
        b=g9YE3slH9HHNn72HZgQ54wNo5RmWZM2kNBuNMrg7fUOi1IP3/mMxnMV4x3J4akuWle
         q6Y2HhaYDYLsTKfh0GLBK04UqrnRskpmlcODj3TrzywCAgpk/9wXQTVfML1KYoCjhLhx
         uETFshrkDaFpL4SfatrgmmxpO86DOxd7iipd8C4SQU75/y0RFtwWFtMjrp58Cs/s2Lpl
         vKqq5lFInDf0QmWVhNXPOW3EZDS/YaHU+g+cl+79KShqnmhfyQy0j1CUGBoNcDNqkZ4x
         4tjLrj4C+tYqgOvnRyVkDgKTOm9ivLpYPpI+Yo6A5uMKd2fVTxwIIniINu+SeGBR3q6L
         hLPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703066658; x=1703671458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9HEt/Agnjbcv9DZ/M0GOa62SZcHFmpwSvE3fYxb9KVA=;
        b=P+AtUOwDY6vHuZ6cmZ5wQiDOd8UxgX8P5FYLAtTOwEpdntFsB2bEe2Ydc10Q1i47MH
         UkS8H2thmGHEULfEzQQMCHE2AliBfLItVQ9fQ5G+aKEU7oLmdHrTlpDPv9QTbH8vY7/H
         TvOBInOzPDN5R+e7lWAiKD04xUNCE0/abX2WIY3jKHQEbIrIgL0Oc9PRwujlYr1u9eZY
         6wvnHUB40ZMEz8vXjQZhBAdHhjoE4JWNpMwaIj1oAQPmx4Sc7sstGujaK3ZxLJHZ+6Pn
         zTXwV5ep9NAJrGOjUwzbEhzcOTrEQNrWBAgTeLMFpyYc/RIb0S2zWirq5ifHsYYnClha
         diNA==
X-Gm-Message-State: AOJu0YxJ52Re5sUUsRri0QNF5rPg92AhmkhW1enS0PlaO8LUeh9YhBmm
	S9VCN3y3ysUexB76WB+ZS8A=
X-Google-Smtp-Source: AGHT+IEbaFfYHbR6pC1D8QsJ2uRB5r/HvmJFeTQAJTPxOJxDG1Vafjsid5EASELuV3KYMogm+e4Yyw==
X-Received: by 2002:a17:902:d4ca:b0:1d3:45c8:bc12 with SMTP id o10-20020a170902d4ca00b001d345c8bc12mr16994882plg.38.1703066658460;
        Wed, 20 Dec 2023 02:04:18 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902fe8300b001d3b7c5776asm5721619plm.160.2023.12.20.02.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Dec 2023 02:04:18 -0800 (PST)
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
Subject: [PATCH v6 5/5] dm-crypt: Fix lost ioprio when queuing write bios
Date: Wed, 20 Dec 2023 18:03:33 +0800
Message-Id: <20231220100333.107049-6-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220100333.107049-1-hongyu.jin.cn@gmail.com>
References: <20231213104216.27845-6-hongyu.jin.cn@gmail.com>
 <20231220100333.107049-1-hongyu.jin.cn@gmail.com>
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

