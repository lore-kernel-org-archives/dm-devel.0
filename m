Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794868389;
	b=fsBnQ4sHEZCD+lKuDsqVonvSmRk8o6LFUNwgei4fmeVWhjkDr9g5Jklzxn698dl2Ouqm
	 3kuoO0P2gD/hEtBScwRXmspZoGqTf8XGHk7P0Xeqx3JPE12l/yNoONC1rotk4baOy0QXs
	 0G/kq7Dcp42WYsjvlPUwjmGYQfXWtq94dntBfQzSnoUkI8l+yo3DNQ/BfjLy0/nkJ5Vpr
	 nuYuXN5SGRLwb2WdUJGNXJvexR5JY8L6SorsOgIip3TTsgTkHP0Ohx3MQkuFR6atMRspD
	 j6gn2x5TknV6Yr+s4pEyJ1gZxlJTi8Or7t1jKRU2IQ421vhH2mN6w00GXB5itOJtYhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794868389;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=LAjrtpG3yMBtaw72gpwmwsyACrUESbNEG0x3WEcUFPM=;
	b=KtqRwqXzItfzksb9+PaOYWyYzD8mm6u7y3zR8VYH0yaLRZncBCmzhrSJ+VX7Uvw+8yaC
	 HS2kVLrTJrA0wIlv2E1Qr3oGmOwloSSDA9tjNaxsu7apfUiaGi3DJiE4yI6Y9BWur2fU2
	 Io3hSNQ/li6Vkpfr2plFtVP2tiGrKzoqZFwXBJtQTZ0WLhx3+CIP648q0tnViZln9U8Ib
	 cUS613OGM1bR3kDGmC/feZF9H1IvSHuL/VYURQM8xZgQPjBgA/z8/v8m9+HQ15fGapEc2
	 Ct0IHW2DiMzt8EZdIkERoEIXjNeCq+tQ04A4X/4JX6s7F6LCTTgUsjR8hfSYXQB9MvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="A/xBOiIb";
	arc=none smtp.remote-ip=74.125.82.198
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F5D606A88F
	for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 22:33:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16F5D606A88F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=A/xBOiIb
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-38131260a5dso633908eec.0
        for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 14:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794868386; x=1795473186; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LAjrtpG3yMBtaw72gpwmwsyACrUESbNEG0x3WEcUFPM=;
        b=A/xBOiIbvdkaoX7rck6kyf54yyJAELaWE8BuJjMubXXiGCPQiSwkt1cL5Fc7TjDFC7
         y686hhxQuimJ3cxyHiKPPxWIewgf63UST5r2KaHC4E0MjIiQRw263Y8zDRUyiyOvDc4U
         lI3obPZzYfaph/rS1F+HkP0+iYFM6CYxoOOMm1xXyu3d3OU0kVCnijfz2dfWfvhbNX+F
         PLtOFjUE/mBYCElT/43xRZHb+YKCVFjDdPjW6WwoVACDFu0mWMsv7gLKOrxAkXF5JUl1
         AhHWb1Fc8osvWNDdhOjnzSSPEZxNb7VRtN53zouStlleZcdFcr0gOdnZx+8MGs9OuPPD
         AWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794868386; x=1795473186;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LAjrtpG3yMBtaw72gpwmwsyACrUESbNEG0x3WEcUFPM=;
        b=Zn9Xo4nnQgef2Z7Sxx+K/Ij8owe4Re9mgz4TfWHurvKT1XXLPtFpXIk583S5aZ056H
         IvBWHBZttvZLeuAkNTRgYIZg6XO4GYPRezev8ODg6X4/8bXsoFG7n5joJiYGFIajE44m
         Slporn6PIFWJDgZYW7U6wG3TX4JJCsuSEigP2PsHjl3Rd7ZzIFchibV21ID7m4p37NG9
         LytUCSrPYQuWwHUWX0PiSgSqW9BxIRUrIyRrj6aZQHGXT4o0wdGv7cfjEZ/nDJTwNH2Y
         SjrBfH14mu2qgCqulfkUUBPO5BdpS3BXoDW1KMVox/IqT/M14HtJwV6NZRSaXyPOsAs1
         5XDg==
X-Forwarded-Encrypted: i=1; AL+hErF98fUla5Z/54bR/hXknnyc7ZzirsbKJavOtOAHn7YNdYNqCntXaThbCQGx/X2g4IJ9JYULY2aLIA==@lists.linux.dev
X-Gm-Message-State: APuU4Z9o1IBHDJr3mw16/v/o+I/IjQ7KgT6Q0SYjFOCweA8bmXu7FgCe
	kZGNG7hpnAbcah5ZRF5RwV0joQozct8h1XS5sbramr2okAvPeMscTZ72zMVOvOEJmv7QzLwe/xS
	nMxDx1/SQx6vzur0bv+1rIT8KPATyj92mu+NXXg==
X-Received: from dyad21.prod.google.com ([2002:a05:693c:8355:b0:359:a8c8:38e2])
 (user=sarthakkukreti job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:424a:20b0:168:3243:c911 with SMTP id a92af1059eb24-1b503137b4fmr13707934c88.37.1794868385967;
 Mon, 16 Nov 2026 14:33:05 -0800 (PST)
Date: Mon, 16 Nov 2026 14:33:01 -0800
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
Message-ID: <20261116223301.1706170-1-sarthakkukreti@google.com>
Subject: [PATCH] dm-verity: export verify_wq to sysfs
From: Sarthak Kukreti <sarthakkukreti@google.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Brian Geffon <bgeffon@google.com>, 
	David Stevens <stevensd@chromium.org>, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sarthak Kukreti <sarthakkukreti@google.com>
Content-Type: text/plain; charset="UTF-8"

Under heavy concurrent read bursts, dm-verity workers blocking on
dm-bufio reads or locks can cause workqueue concurrency management to
spawn hundreds of per-CPU kverityd threads across the system.

Export verify_wq to sysfs via WQ_SYSFS so userspace can inspect and
configure workqueue attributes (such as max_active) per dm-verity
device under /sys/bus/workqueue/devices/kverityd-<dev>-<id>/.

Co-developed-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Brian Geffon <bgeffon@google.com>
Co-developed-by: David Stevens <stevensd@chromium.org>
Signed-off-by: David Stevens <stevensd@chromium.org>
Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
---
 drivers/md/dm-verity-target.c | 22 ++++++++++++++++++----
 drivers/md/dm-verity.h        |  1 +
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 306ed1f6c118..730adf931494 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -18,6 +18,7 @@
 #include "dm-verity-verify-sig.h"
 #include "dm-audit.h"
 #include <linux/hex.h>
+#include <linux/idr.h>
 #include <linux/module.h>
 #include <linux/reboot.h>
 #include <linux/string.h>
@@ -26,6 +27,8 @@
 
 #define DM_MSG_PREFIX			"verity"
 
+static DEFINE_IDA(workqueue_ida);
+
 #define DM_VERITY_ENV_LENGTH		46
 #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
 
@@ -1065,6 +1068,8 @@ static void verity_dtr(struct dm_target *ti)
 
 	if (v->verify_wq)
 		destroy_workqueue(v->verify_wq);
+	if (v->workqueue_id)
+		ida_free(&workqueue_ida, v->workqueue_id);
 
 	mempool_exit(&v->recheck_pool);
 	if (v->io)
@@ -1421,7 +1426,7 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	struct dm_arg_set as;
 	unsigned int num;
 	unsigned long long num_ll;
-	int r;
+	int r, wq_id;
 	int i;
 	sector_t hash_position;
 	char dummy;
@@ -1637,6 +1642,14 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
+	wq_id = ida_alloc_min(&workqueue_ida, 1, GFP_KERNEL);
+	if (wq_id < 0) {
+		ti->error = "Cannot allocate workqueue id";
+		r = wq_id;
+		goto bad;
+	}
+	v->workqueue_id = wq_id;
+
 	/*
 	 * Using WQ_HIGHPRI improves throughput and completion latency by
 	 * reducing wait times when reading from a dm-verity device.
@@ -1646,9 +1659,10 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 * will fall-back to using it for error handling (or if the bufio cache
 	 * doesn't have required hashes).
 	 */
-	v->verify_wq = alloc_workqueue("kverityd",
-				       WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_PERCPU,
-				       0);
+	v->verify_wq = alloc_workqueue("kverityd-%s-%d",
+				       WQ_MEM_RECLAIM | WQ_HIGHPRI |
+				       WQ_PERCPU | WQ_SYSFS, 0,
+				       dm_table_device_name(ti->table), wq_id);
 	if (!v->verify_wq) {
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index e104a651c657..53f894f259d3 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -71,6 +71,7 @@ struct dm_verity {
 	atomic_t corrupted_errs;/* Number of errors for corrupted blocks */
 
 	struct workqueue_struct *verify_wq;
+	int workqueue_id;
 
 	/* starting blocks for each tree level. 0 is the lowest level. */
 	sector_t hash_level_block[DM_VERITY_MAX_LEVELS];
-- 
2.56.0.679.gc527c65306-goog

