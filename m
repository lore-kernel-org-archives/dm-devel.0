Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A107E210F1
	for <dm-devel@lists.linux.dev>; Mon, 11 Dec 2023 09:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R1Jf4oy/"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7b71e389fb2so111897039f.3
        for <dm-devel@lists.linux.dev>; Mon, 11 Dec 2023 01:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702285264; x=1702890064; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=imqsqSeoCG7iiefqcy/059zT5ygF+aA0rzXCKWGVYeM=;
        b=R1Jf4oy/KbK4hXZAGkTMoLNesJY57I5BiHo8EHEhxcb99gSjbFtA8Na2l5ons6V8zQ
         r1GxT93Uvll8x2AcCvUOKc24Lf05jKPY+tbuS46yO96YajWe/YxJvVcEy98dorQ5KPMQ
         vZ2SkSrTDz9tQmrvn9Pa8ND/y7Hr3PGckeaL67fapGPPa9vvLiGtRwOaoSuPrLQpU8OJ
         CDmeCN2gwtwRO8kWI5yzfJPgGbqKRWhHrnDDMOEk+rwGbqLqFhCilMzOxZ5Alvtraom+
         3e6r/avU9ESTgjcRQOv7DDsPJ1GL6ByokhdaH4YGcroQoEvnhEedIq6zIN5BI6L9EtTf
         MY1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702285264; x=1702890064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=imqsqSeoCG7iiefqcy/059zT5ygF+aA0rzXCKWGVYeM=;
        b=Uhh54znAR8fwUw4jLTc6PnFEQaU41BZFaVAgFxE3RxvMN4IlQaMRW6aI6WaIMjC5wz
         EUGq3qnCQjxje1WZIRiY683ebtHjQID4JYQLLeTp75TOXzOEuaAhkf7Pi7+dzqXUO4PU
         iWUiNxF6lLtkpA543hoDbSXBh416iiT8rD+SGIlFD+PrdwSYyk5ASmUQs4PL90x/VRxF
         FHqcMS61yYrfzsN0jqgDy4Ba+mvfjrHlINbmQhGejCVN6pNFdEZgMh3UC+KTwQ9OvQ97
         OXCJ9SkFv/gU3oJecEhZLU24UzwQxVJDljjsbde1zZYkrDS1A8fdG3jtMSmJSrJkV2NC
         tWPw==
X-Gm-Message-State: AOJu0YwXmi0iWYUtd0bxHQ4PLdffPSvQV48utNp+DYSIEKDM87IIk7Ih
	R6zY9RSXvgOs7K4oa4kf230=
X-Google-Smtp-Source: AGHT+IGLCG8im5lLD3WEgqK1syGR1Nyf2Q+dj/rBbukrCX6r/qUF7cEgvaRF1uPm4mONhDN/QIwBbw==
X-Received: by 2002:a92:ca48:0:b0:35d:59a2:3329 with SMTP id q8-20020a92ca48000000b0035d59a23329mr7723508ilo.45.1702285263896;
        Mon, 11 Dec 2023 01:01:03 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id f14-20020a056e020b4e00b0035b0b05189bsm2211216ilu.38.2023.12.11.01.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 01:01:03 -0800 (PST)
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
Subject: [PATCH v3 5/5] dm-crypt: Fix lost ioprio when queuing write bios
Date: Mon, 11 Dec 2023 17:00:00 +0800
Message-Id: <20231211090000.9578-6-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231211090000.9578-1-hongyu.jin.cn@gmail.com>
References: <df68c38e-3e38-eaf1-5c32-66e43d68cae3@ewheeler.net>
 <20231211090000.9578-1-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

The original submitting bio->bi_ioprio setting can be retained by
struct dm_crypt_io::base_bio, we set the original bio's ioprio to
the cloned bio for write.

Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
---
 drivers/md/dm-crypt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 6de107aff331..b67fec865f00 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1683,6 +1683,7 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
 				 GFP_NOIO, &cc->bs);
 	clone->bi_private = io;
 	clone->bi_end_io = crypt_endio;
+	clone->bi_ioprio = bio_prio(io->base_bio);
 
 	remaining_size = size;
 
-- 
2.34.1

