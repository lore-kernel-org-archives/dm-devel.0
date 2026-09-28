Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89904E66A5
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 20:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626379; cv=none; b=uP6ricI/GPNWUcY/NN53J2Gago6YNdiKkA37fB1Ze8mJMqErZAMklImHCWQ09XVuEoW0h58V8XTYPlm1avuGrgjWwRjGsA390mdWVGayR//5GB2zbHn5y7D+/PhsQ6zGBEVZphVzL/HTt8yl8lkfiVCgFSGitO8GGe3ZHcsgvG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626379; c=relaxed/simple;
	bh=hkFas3mZaox8RRokWKn/qKR6LDkDCnnmsggr842lS18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/+PfyjAkXL65dveCGmE7eFWRgCkojbY5eoLZag2qAigwGIiwc2Al8Y6cAbQBSRuyMUF+RRiJuZVZTJdT95IzG+EpWKUe4/PFXdmRJGeT+4It0qrzWSUlyMzgnIzkt7xk3PXA69g1KnaW/viqMPf3UGoxFQJ5TqPx4/7QeLjf50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UE/eOJfp; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UE/eOJfp"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e8185e037so19262815e9.3
        for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 13:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790626373; x=1791231173; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FHrR5kgcHvLjH9hD8wdXc7t8x0CJmGRPaHyyxceDiaM=;
        b=UE/eOJfpAbWbqOHymmEHNejIYXTE8LpNaA7fWtJTXjhAKWOlBKszfZz93s/oQrhljJ
         MErYCfISdxFeSnr5kwgQR1hDbTn58fFyexMl4RCTnXVBqOR9nPo7xIGS5mwXYXZ11ZxT
         XC1kPg51eHgN+7z2zfauGeI85/6owktxkj9oBStSh6jPKUGXsGuVUXBiA74ShVZS8OgE
         BFEq/8v9q7ndKOy1o/aO5TVqTXWxNlZgMvODg4Cc7RLHGxA+qsOVW+u7pIAVUy5INRrB
         VJ/jIcNJnkhG28Iig0oOVG8/x6/lX2Fdc+pWGHQSVQBOAHJLJbFd+zf0izDfxc3ODJy/
         YIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790626373; x=1791231173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FHrR5kgcHvLjH9hD8wdXc7t8x0CJmGRPaHyyxceDiaM=;
        b=mVqaoP8lBjhUeAhlZezwVRCX2yu/tEYAX0mG1V0IOFiCqucn6tfYANA9nIvRnhkO7O
         NcMQFKUERA6Y2By4EeLoAqYoyOYqotSlhVOZSlTQ0OzrnDHjA1zPhv+qy9ti2adtdXpO
         EV03jfqw9oI25EZcaF9x1vikS2SufjxqEet1ykZEo2qiFU8BXPl9842nD6bzu/lb/1Rd
         jBA7R14KxPnnGyCGRt6/Gyg9jljyU5fCzl1BSBXBh780RMgrKDlER1eHgvJIZuC4S9qZ
         TsNHHlK4iQZVN1OQdFm+mRotmNq7BReklUdA3XiX22/9ZvRucPlL710QhjBZFyESV/HU
         8CIw==
X-Forwarded-Encrypted: i=1; AKwUvBzW9I4Uui2TC+JX2spZ2ZrZorSmn6XH8hI+SRpOtGSOgLkZiXI33zk6tqpG+M3hxN7yShBrsV+Rhw==@lists.linux.dev
X-Gm-Message-State: AFuF++nPSvN7k2Sl1jI+fcybt1YO3JG+A7A0SBmf+2SicFNqsiFcOHn/
	EZqzD2A8SPu6fjBBTluSodgP2pSAeBrcb5VbUCj1h7SHZYRZ5/o1/HAe
X-Gm-Gg: AYBFou3rSNLejlFdu6LexrGRveZZ6vVuu6/wyVw2nd9NM++flVsVLN+xsK/K8vK2CT9
	NfaK6U/eYfDyZvPQBYqMmoOhSTmlIPMpXG009qemyHN9kvwBf72ciGSOToTsLL9Pj0us1XIik+P
	SV9C5KrYhjcswty42h7F0aveAXbK0u/NPsv6AgRn3WsTrjE4q41HdHdgWkshiZKjb79AEX+4br4
	ZxTzFc3jhOgwA5+NtOx4xrdK2a7Eiwax32u+qkxhPL2ZYGUX/nlxNkFZ+V2tlMnH93S3xQxSBD4
	yC7wY0fxc20HWhdJEHwpuWy6yODc8wjjPwMjbi9s9hyUq9FZh3bkOaYZkTpqjlofLkYj78d2gIF
	HTzLTTjyDXf1MhuL0ev8XIFKk5g9/JmDuUX6xrdjlRqpea8qLhpgxLCTW1/62COmStSN79yfyAM
	URN/OwVwL0XZb9QStuavzTg8qX1ZPTQByicsLjP+VXKEUnckQJdYxQk9iTACAdD3ZBsmyjEvH8G
	frFKbZUmYxj8PeDZ0Jd83spAaWwOlcWsV4M+dfJqoB1xkzpZ5qOtczXnQ==
X-Received: by 2002:a05:600c:3550:b0:49f:fd40:80fa with SMTP id 5b1f17b1804b1-49ffd408357mr111818575e9.34.1790626373146;
        Mon, 28 Sep 2026 13:12:53 -0700 (PDT)
Received: from env.. (dynamic-176-003-100-011.176.3.pool.telefonica.de. [176.3.100.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00c11a9d2sm30457755e9.3.2026.09.28.13.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 13:12:52 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	chengzhihao1@huawei.com,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	arnd@arndb.de,
	gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 1/2] md: make mddev lookup and ioctl helpers non-static
Date: Mon, 28 Sep 2026 20:12:23 +0000
Message-ID: <20260928201224.3602262-2-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
References: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A following patch adds an md misc control device, so that arrays can
be managed without opening the md block device. Its code lives in a
separate file and needs to look up arrays and reuse existing ioctl
helpers.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md.c | 10 +++++-----
 drivers/md/md.h |  5 +++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..b5027d65c6d8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -364,8 +364,8 @@ EXPORT_SYMBOL_GPL(md_new_event);
  * Enables to iterate over all existing md arrays
  * all_mddevs_lock protects this list.
  */
-static LIST_HEAD(all_mddevs);
-static DEFINE_SPINLOCK(all_mddevs_lock);
+LIST_HEAD(all_mddevs);
+DEFINE_SPINLOCK(all_mddevs_lock);
 
 static bool is_md_suspended(struct mddev *mddev)
 {
@@ -623,7 +623,7 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_flush_request);
 
-static inline struct mddev *mddev_get(struct mddev *mddev)
+struct mddev *mddev_get(struct mddev *mddev)
 {
 	lockdep_assert_held(&all_mddevs_lock);
 
@@ -8101,7 +8101,7 @@ static void put_cluster_ops(struct mddev *mddev)
  * Any differences that cannot be handled will cause an error.
  * Normally, only one change can be managed at a time.
  */
-static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
+int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 {
 	int rv = 0;
 	int cnt = 0;
@@ -8227,7 +8227,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 	return rv;
 }
 
-static int set_disk_faulty(struct mddev *mddev, dev_t dev)
+int set_disk_faulty(struct mddev *mddev, dev_t dev)
 {
 	struct md_rdev *rdev;
 	int err = 0;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b6d2e8929a0f..cb8760521764 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -953,6 +953,7 @@ extern int mddev_init(struct mddev *mddev);
 extern void mddev_destroy(struct mddev *mddev);
 void md_init_stacking_limits(struct queue_limits *lim);
 struct mddev *md_alloc(dev_t dev, char *name);
+extern struct mddev *mddev_get(struct mddev *mddev);
 void mddev_put(struct mddev *mddev);
 extern int md_run(struct mddev *mddev);
 extern int md_start(struct mddev *mddev);
@@ -974,6 +975,10 @@ extern void mddev_destroy_serial_pool(struct mddev *mddev,
 				      struct md_rdev *rdev);
 struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
 struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
+int update_array_info(struct mddev *mddev, mdu_array_info_t *info);
+
+extern struct list_head all_mddevs;
+extern spinlock_t all_mddevs_lock;
 
 static inline bool is_rdev_broken(struct md_rdev *rdev)
 {
-- 
2.43.0

