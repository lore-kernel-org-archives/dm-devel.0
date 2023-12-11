Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D736B1EB46
	for <dm-devel@lists.linux.dev>; Mon, 11 Dec 2023 09:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4g2sH8J"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-35d72b72ff7so17183605ab.0
        for <dm-devel@lists.linux.dev>; Mon, 11 Dec 2023 01:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702285248; x=1702890048; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=czq/4nF48yftDC4HVsuA9AE8CVBtJqYm6rZADq2HVZo=;
        b=J4g2sH8Jlm04M5Xc+98mqAoOQbRObJaFYVux9Uq59huMSu4jhQ75aHEn6K34g2Ha2o
         OIrFOZxIaiu2GQYoa1aJx/DnPJ/UcCMSQY1ZenoFry8UUKhW3lr1qDPq23JNL3gHd2Xz
         wsiCzmk57BZQHn1Bz4jsPVuNo4aD9V4IizOm7wDolAgL+AxPFDlTpocC3xSrAXyu8njV
         Gwint+DjD76BA7fS6klekSJE1aMe2O631YLuWTG5bZC8EejTbfDOT2PjyGmIAXWwu1lj
         MOxpCqTl9b9KJx9KTd33O0sndMsX+6JkLSH6OBfkKVL5hh/vKMYVFDwnsalg4V0d5z9h
         jpPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702285248; x=1702890048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=czq/4nF48yftDC4HVsuA9AE8CVBtJqYm6rZADq2HVZo=;
        b=tZ8N7rmHmBzgzgEHc9hX5+53AbkaB5a48+7zHSfeexz2l4DUOcDaPO26c+QsnHFukf
         E/PUp5VS6NwZJPHYHdBMW/SdNLs4R2m0f/EmSwAt+RgnFoYLwjqX8LexxxYP2VQtoB5Q
         fmFwq+7/DO1zBUuBQ6LmV1gJQrGXvvnjSx+sh+UGYU+AWrrMmgXg22uCb9dJMQAEzJV5
         VSlHcpYIkkjL+Mv1rGqBl6Y/4NfXy8CnF8sCdXWywSFCVlV4FCI+lEFUf3PT1mnfrBAT
         iVzBV6lcACoegTv0QpmwskcgsUfDjHaSBiQVPNFmdYsFARCM7/92I//asl7SEbUf5G22
         c8wA==
X-Gm-Message-State: AOJu0YzY/Iky79EAHnvxjb2BYtion0qZDhatZjtYfeGqoIKUtNZgDa91
	c1QRrtPQp9DQM8I+E+feWx4=
X-Google-Smtp-Source: AGHT+IEwn0/n8T+SvHlYhFYyRFqYBOgn7wrNpFzhJLamLhEf4Eabi+8VursYqb2tcOSwbmwGTCML4A==
X-Received: by 2002:a05:6e02:1587:b0:35d:59a2:6464 with SMTP id m7-20020a056e02158700b0035d59a26464mr6212743ilu.55.1702285247890;
        Mon, 11 Dec 2023 01:00:47 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id f14-20020a056e020b4e00b0035b0b05189bsm2211216ilu.38.2023.12.11.01.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 01:00:47 -0800 (PST)
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
Subject: [PATCH v3 1/5] block: Optimize bio io priority setting
Date: Mon, 11 Dec 2023 16:59:56 +0800
Message-Id: <20231211090000.9578-2-hongyu.jin.cn@gmail.com>
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

Current call bio_set_ioprio() for each cloned bio and splited bio,
and the io priority can't be passed to module that implement
struct gendisk::fops::submit_bio, such as device-mapper.

Move bio_set_ioprio() into submit_bio(), only call bio_set_ioprio()
once set the priority of origin bio, cloned and splited bio
auto inherit the priority of origin bio in clone process.

Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
---
 block/blk-core.c | 10 ++++++++++
 block/blk-mq.c   | 11 -----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fdf25b8d6e78..68158c327aea 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -49,6 +49,7 @@
 #include "blk-pm.h"
 #include "blk-cgroup.h"
 #include "blk-throttle.h"
+#include "blk-ioprio.h"
 
 struct dentry *blk_debugfs_root;
 
@@ -809,6 +810,14 @@ void submit_bio_noacct(struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio_noacct);
 
+static void bio_set_ioprio(struct bio *bio)
+{
+	/* Nobody set ioprio so far? Initialize it based on task's nice value */
+	if (IOPRIO_PRIO_CLASS(bio->bi_ioprio) == IOPRIO_CLASS_NONE)
+		bio->bi_ioprio = get_current_ioprio();
+	blkcg_set_ioprio(bio);
+}
+
 /**
  * submit_bio - submit a bio to the block device layer for I/O
  * @bio: The &struct bio which describes the I/O
@@ -831,6 +840,7 @@ void submit_bio(struct bio *bio)
 		count_vm_events(PGPGOUT, bio_sectors(bio));
 	}
 
+	bio_set_ioprio(bio);
 	submit_bio_noacct(bio);
 }
 EXPORT_SYMBOL(submit_bio);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index e2d11183f62e..a6e2609df9c9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -40,7 +40,6 @@
 #include "blk-stat.h"
 #include "blk-mq-sched.h"
 #include "blk-rq-qos.h"
-#include "blk-ioprio.h"
 
 static DEFINE_PER_CPU(struct llist_head, blk_cpu_done);
 static DEFINE_PER_CPU(call_single_data_t, blk_cpu_csd);
@@ -2922,14 +2921,6 @@ static inline struct request *blk_mq_get_cached_request(struct request_queue *q,
 	return rq;
 }
 
-static void bio_set_ioprio(struct bio *bio)
-{
-	/* Nobody set ioprio so far? Initialize it based on task's nice value */
-	if (IOPRIO_PRIO_CLASS(bio->bi_ioprio) == IOPRIO_CLASS_NONE)
-		bio->bi_ioprio = get_current_ioprio();
-	blkcg_set_ioprio(bio);
-}
-
 /**
  * blk_mq_submit_bio - Create and send a request to block device.
  * @bio: Bio pointer.
@@ -2963,8 +2954,6 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (!bio_integrity_prep(bio))
 		return;
 
-	bio_set_ioprio(bio);
-
 	rq = blk_mq_get_cached_request(q, plug, &bio, nr_segs);
 	if (!rq) {
 		if (!bio)
-- 
2.34.1

