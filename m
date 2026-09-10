Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6386A422531
	for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 08:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027884; cv=none; b=HltkXIVeYs/JHgSxcV1iP/rqyqJOfg/9tWlmDllXPS+MtqoAsDDYfh95l2xkXkjwFSR1ZDCTDNtyy/reoIoiAMV0PiOfX4gr6uBSU1SWdnoxfUrAqJ0uY4XBsTlHnNkawhWQ6HALa+ypymNJKGggzLMpAzmF7JkasoJX40yif7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027884; c=relaxed/simple;
	bh=K9IfShwLc/c5Al3z8c+Rt6NM850R3QuamoNvpA0sKPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrshCmnG9DWX+L9E9MeaPTCeLkRkm1gLSVT1mKCFW1OY86v9eAgibzOnsadTkA0aoectWdEiEEuHtBvltQYXfooLW5Mat0a2k4j0dSNn1h+AkU3Jax3/tHz4Iue7Eey6tNEnpspOFrKSA17k4T9pOhaWrRMFRDfjn+XKt8XQNJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=gNKRrYJE; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="gNKRrYJE"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-499db1740e4so3233295e9.0
        for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 01:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1789027880; x=1789632680; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cgHwrkYbfZz0Oniv9vK94zADT2EQaqVt5Nm8OKIDVDc=;
        b=gNKRrYJEpyS6zn0eCb/GnaRrVb/E4am98YzSlfQraHuQqupJi0Nyft5MR0jMIt0kCv
         8h5fqotAa53qhjPDWxvymneHqEs9yqqn8dcqFxMRnou33VSrLqgRwiEv+EBWec9r/Mpu
         KMkZAiXhTWQhKXMhj2eCEFtMGdXuKB+uSaZkXTT9T1zxsVtpQCzWE2DGHs2B/0TyKvhs
         6xvpMIW1ogBsjCXnEpKqglIeoRxqpkHvw5TGwZJCgJ22XvwJPEWGh/EbZxg6k5mczjFB
         Hg4UPUiekPl+NGvSoBSr3FafvcDNrhDUxhAKxT3vG7p63nSXFxFg7HlH7/CT9eztipnM
         iEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027880; x=1789632680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cgHwrkYbfZz0Oniv9vK94zADT2EQaqVt5Nm8OKIDVDc=;
        b=c5BWlSp6Xky6f5uN2VSXZIu6MB6lTYEym7U/CwvS7kb16gTpsIrjJz96KqfWZNQC7O
         ecWDuBgjzKhSW+WkeYp4Q1+DCz+K4trSFOZLEsdJs7N66SCAKJwBZtbS1EfWL4Z6SWU0
         dm9u3Te+Z5Vk/NKVLeCON4TQZb0zW2FNVWqLOr/K0hlMjBrXZwF1ednAFxnSm78GXj5J
         urvHaplxIDz6a0E+S0jNVQkuB9AFrGz8rG/dOPbMpb49cmhhw36dXamQYK9PtyIGnb8S
         wuqicTlRSOkhBfUlPXcg+wSi9uhBeQEVQf6IQFE0Ec3yqjxYCUaFrlNCOo6ExEE+shcf
         Pijw==
X-Forwarded-Encrypted: i=1; AKwUvByKj9urZQlTWWLxNypS0m5HOd0AXN2Cw0+05ovY5rvJbm3kdJpW0J1fG/K/vKJQ9tx4bYENbgZwYA==@lists.linux.dev
X-Gm-Message-State: AFuF++mqso3+T/SYho6zfQR6eNLaE1MjWo2voLMEjkwmooUeQahRkLtm
	B3oVoZP4QuMj8IxfJw9p8SWzHtskJrNwHUyHBJA04YyyFKm6KwCqfTL1BvRPc7+gNIw=
X-Gm-Gg: AYBFou18Bt7p4X9hLK0dzEw01oEhzdOCmcnT75axCn6KmdCW0lcdX4fb5ErqHQTsFC1
	tnBxGJyAnckD50V5OcOIHgtx8pERpc/Dw1VZ17HiaGg53ZNYLO5rVRI0yN9FF9cGauECWkeIrOF
	Ab//RGOGqyDolhF5mz8FYASX+Vp49QmnRltpHb62lOlEs8OlAh50h7snxstvh8GWMNRO0DnMW9N
	+9wSp2Mz28GXxjM9a+UGXoR99Rcj7Li/bUJL9kTovIKhUUDPbIlA99afYCJ0XkgjCrwkuCuoM5L
	wJy6jwer3WAKdH2RE7yzorTOTqlciY5691L+MkngiEB+1aealCJvIGQXaHLLna7rrcwvk6Qg7og
	R+YIqBOVVpYuk47tEkjmFm6wtGhUp7FutHgo4RSoGoW7DPPwFiHoMU3s8dg4y3s4m3q9dJtss8W
	srJ0HQFviQW4hYifnMejutrVsXI5X6r9GBRyu/V6L7i6v2fvAlA7izILGsHEfpruL7WLnxUCXfy
	u/fOOKQ9q9ZXYyes6yvd7cMWuHLCR6s5vlln481KT1ztuqgi2hoW8g=
X-Received: by 2002:a05:600c:474a:b0:49c:ff81:e062 with SMTP id 5b1f17b1804b1-49d276628c8mr26060515e9.2.1789027880278;
        Thu, 10 Sep 2026 01:11:20 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d20fc1be3sm55261135e9.4.2026.09.10.01.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:11:19 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <tom.leiming@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 3/8] md: pass a queue_limits through the rdev sysfs stores
Date: Thu, 10 Sep 2026 10:11:08 +0200
Message-ID: <20260910081114.1605746-4-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910081114.1605746-1-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

state_store() and slot_store() can add a leg back to the array, which
stacks its limits, and q->limits_lock has to be taken before the array
is locked and suspended.

Give the rdev sysfs store callback a struct queue_limits argument.
rdev_attr_store() passes NULL, so there is no functional change; the
user follows.

Assisted-by: LLM
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md.c | 45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e60dc2c7eb90..3067ea05ba27 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3033,7 +3033,13 @@ static int cmd_match(const char *cmd, const char *str)
 struct rdev_sysfs_entry {
 	struct attribute attr;
 	ssize_t (*show)(struct md_rdev *, char *);
-	ssize_t (*store)(struct md_rdev *, const char *, size_t);
+	/*
+	 * @lim: a queue limits update the caller owns, or NULL.  Stores that
+	 * can add a leg to the array must stack into it rather than take
+	 * q->limits_lock themselves, see md_start_sync().
+	 */
+	ssize_t (*store)(struct md_rdev *rdev, const char *page, size_t len,
+			 struct queue_limits *lim);
 };
 
 static ssize_t
@@ -3079,7 +3085,8 @@ state_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t
-state_store(struct md_rdev *rdev, const char *buf, size_t len)
+state_store(struct md_rdev *rdev, const char *buf, size_t len,
+	    struct queue_limits *lim)
 {
 	/* can write
 	 *  faulty  - simulates an error
@@ -3257,7 +3264,8 @@ errors_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t
-errors_store(struct md_rdev *rdev, const char *buf, size_t len)
+errors_store(struct md_rdev *rdev, const char *buf, size_t len,
+	     struct queue_limits *lim)
 {
 	unsigned int n;
 	int rv;
@@ -3283,7 +3291,8 @@ slot_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t
-slot_store(struct md_rdev *rdev, const char *buf, size_t len)
+slot_store(struct md_rdev *rdev, const char *buf, size_t len,
+	   struct queue_limits *lim)
 {
 	int slot;
 	int err;
@@ -3378,7 +3387,8 @@ offset_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t
-offset_store(struct md_rdev *rdev, const char *buf, size_t len)
+offset_store(struct md_rdev *rdev, const char *buf, size_t len,
+	     struct queue_limits *lim)
 {
 	unsigned long long offset;
 	if (kstrtoull(buf, 10, &offset) < 0)
@@ -3404,7 +3414,8 @@ static ssize_t new_offset_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t new_offset_store(struct md_rdev *rdev,
-				const char *buf, size_t len)
+				const char *buf, size_t len,
+				struct queue_limits *lim)
 {
 	unsigned long long new_offset;
 	struct mddev *mddev = rdev->mddev;
@@ -3511,7 +3522,8 @@ static int strict_blocks_to_sectors(const char *buf, sector_t *sectors)
 }
 
 static ssize_t
-rdev_size_store(struct md_rdev *rdev, const char *buf, size_t len)
+rdev_size_store(struct md_rdev *rdev, const char *buf, size_t len,
+		struct queue_limits *lim)
 {
 	struct mddev *my_mddev = rdev->mddev;
 	sector_t oldsectors = rdev->sectors;
@@ -3573,7 +3585,8 @@ static ssize_t recovery_start_show(struct md_rdev *rdev, char *page)
 	return sprintf(page, "%llu\n", recovery_start);
 }
 
-static ssize_t recovery_start_store(struct md_rdev *rdev, const char *buf, size_t len)
+static ssize_t recovery_start_store(struct md_rdev *rdev, const char *buf, size_t len,
+				    struct queue_limits *lim)
 {
 	unsigned long long recovery_start;
 
@@ -3612,7 +3625,9 @@ static ssize_t bb_show(struct md_rdev *rdev, char *page)
 {
 	return badblocks_show(&rdev->badblocks, page, 0);
 }
-static ssize_t bb_store(struct md_rdev *rdev, const char *page, size_t len)
+
+static ssize_t bb_store(struct md_rdev *rdev, const char *page, size_t len,
+			struct queue_limits *lim)
 {
 	int rv = badblocks_store(&rdev->badblocks, page, len, 0);
 	/* Maybe that ack was all we needed */
@@ -3627,7 +3642,9 @@ static ssize_t ubb_show(struct md_rdev *rdev, char *page)
 {
 	return badblocks_show(&rdev->badblocks, page, 1);
 }
-static ssize_t ubb_store(struct md_rdev *rdev, const char *page, size_t len)
+
+static ssize_t ubb_store(struct md_rdev *rdev, const char *page, size_t len,
+			 struct queue_limits *lim)
 {
 	return badblocks_store(&rdev->badblocks, page, len, 1);
 }
@@ -3641,7 +3658,8 @@ ppl_sector_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t
-ppl_sector_store(struct md_rdev *rdev, const char *buf, size_t len)
+ppl_sector_store(struct md_rdev *rdev, const char *buf, size_t len,
+		 struct queue_limits *lim)
 {
 	unsigned long long sector;
 
@@ -3680,7 +3698,8 @@ ppl_size_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t
-ppl_size_store(struct md_rdev *rdev, const char *buf, size_t len)
+ppl_size_store(struct md_rdev *rdev, const char *buf, size_t len,
+	       struct queue_limits *lim)
 {
 	unsigned int size;
 
@@ -3766,7 +3785,7 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 		if (rdev->mddev == NULL)
 			rv = -ENODEV;
 		else
-			rv = entry->store(rdev, page, length);
+			rv = entry->store(rdev, page, length, NULL);
 		suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
 	}
 
-- 
2.43.0

