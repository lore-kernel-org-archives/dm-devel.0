Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66AF3A3817
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 10:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774434490; cv=none; b=qI/68kbRGnRhRW9OmUydDT1HWjk2m5sADbHRDl67UPnCOWbhOTcbMftkcencBFC6bI37SiLrb+GGHkM7cWXtp4hdts75m9lpQyPZQug18gX5/zjcr84jeULbBlRr1Em2zaTrJZucFZuP8zSHdPFWoifU1HZO4pF1SeGLFCUfPkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774434490; c=relaxed/simple;
	bh=tom43KEKyh2fvaci/YD62RwzIfn9WllCNjMC0bb/dl8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Jkb+kYfc38IXiNkuPpLwd1fn067whawR5yHLWepja6QDA/HMGX/WN8LwQ/N5v9Pt8TM/q+CXeSPISyzFvSspBK117mPIXMNoSDRTR56OtgelrFyPl0VCLbkwHgboKpBNZEQhyqz5sVn0EPMvaM2hhTTN/KMQOu45GyUYlh47/6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=FbtLe0R/; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="FbtLe0R/"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-506a747448dso41484411cf.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 03:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1774434487; x=1775039287; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eW9ecECq1NUBzDLIkheZ6doi9a4ejV/IV7e6eOyQgdw=;
        b=FbtLe0R/wd14ZDVuWCnTNVD5/dvwYNMp7unDEWHBp5eAqua5+uW8+3OO8VEuqaabv/
         vJAgSJrmJMKDeYKA3n26Dh4uzfJgGhwfFS7PxUneI7gAlQQ893/ZpxbHs7gdszZP4jbL
         Cij+5RurxihT6d7yT8WkgPJ1Bnrj8YnOgxpHKLDLibwqbWk9gOx9IHQdzWX66wdeucmr
         KYowxPSu1Sa0JgaAvsrdWizo6YcPo1i2nX4BaWfLk6EQuCk2MnYdiAtOzIr8LuxXXq71
         RSQREURX2+T3L34rztIPvlsvG1G8RzsX0ebLBHOt43fvlKoDcXv2c2QhgzmUtfiSWJdl
         WYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774434487; x=1775039287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eW9ecECq1NUBzDLIkheZ6doi9a4ejV/IV7e6eOyQgdw=;
        b=CdjTnyd1Z9pPHQGqPJ2cVNCHj8vOUj7fQfa4h/ttNzo6Pc69Kd1l9Gt9ghPyNC9lUM
         ufkNsJYF7dwLnGK/TsVD/b/0G4aCr8oLJMJXaZPR4m+Zz8W6ru75OlNGXnoipfONkP3/
         HXMLSImXwEea8ZrmLApuY7yzXVCcs2y9+rSxZrpkCFHFsQ0Mdwd4aD1GfpbtwV5dPYEF
         AFw2OLkk/w/B6IkBiakf8H8hTcPdjC1jbzEvhhoB52CvnF1NtjdrxNJVBa8M81ZHDwWJ
         uQRq9xAgaVPnXDluexcpFp6Q0/AyxZJ0IfyI5H/HLti1/cm37YevN1AQ+1uYAYb2Ippz
         p2DA==
X-Gm-Message-State: AOJu0YypQMVV6N5q/KTyD+bJHuYiSLRrOv7WwBTsUQvzT+lUlwPea7cp
	o/XvtXZwV+xpDlSD+CY9fomvY7vnk3a83KOJzHVZtClHOqfofeP9KZkJrayqZv0VaG4=
X-Gm-Gg: ATEYQzziOiiqb6qC1NLyMfA+nAvp7Kuf/Rf+3H5ZAKavjB8qCFVtmHTKJag0tcSj1GH
	fQ+eEdXabq4CIdWVAUBOguW+f0Ue+S2pqKFnbulQbBJKZLHnlMbe47e2hLDGiUybWO1Hq3k926I
	SNRBVbEbHNV60Aoq3UBaz2tDgcyzsZTa/WJC7DkWrBHU4V20owHsyZIfGFUgeT0gVuIgycd+JUl
	g5eGuAPk7sbfKQStIDx0NFoD5ZTojcHEVOZnddR3D2SHFCyoUR52UsNZSxzemLK+QvQbkJ16rcN
	PIEv5a4JoRuesmTOXTyqM2YVhjDepYroi2311N+OZ5nUwwoGtUE9lnxUaQTbELRlAtK+4S8ZXsE
	Sk9Yyn0dDJ7r4YzubIIg3o+k3sQlq7PeWI3ZmNFX/SgzczJFnp+yuM53mfTibpr6sjShd8+xyU3
	Xr7nXm0gjIW8RZiFC5yqZjWW1MUjspglietgI1WEydym9pYQsjohz0rt16iFcZ6teN24ogQjhh
X-Received: by 2002:a05:622a:1f8e:b0:50b:4d27:bebb with SMTP id d75a77b69052e-50b80ccc75fmr44824111cf.14.1774434486645;
        Wed, 25 Mar 2026 03:28:06 -0700 (PDT)
Received: from vm-libchen-fa.tier4-kif-devvm.svc.slc-eng-prd2 ([208.88.159.129])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-89c85361ac2sm132870796d6.41.2026.03.25.03.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 03:28:06 -0700 (PDT)
From: Libo Chen <libchen@purestorage.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yuanyuan Zhong <yzhong@purestorage.com>,
	libochen@chenlibo.work
Subject: [PATCH] dm: fix race between dm_mq_queue_rq and __dm_destroy
Date: Wed, 25 Mar 2026 04:27:41 -0600
Message-Id: <20260325102741.293982-1-libchen@purestorage.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing dm_get() calls BUG_ON if DMF_FREEING is already set. This
can be triggered when a request is dispatched via blk_mq_requeue_work()
racing with __dm_destroy():

  CPU0                           CPU1
  ----                           ----
  __dm_destroy()
    set_bit(DMF_FREEING)
                                 blk_mq_requeue_work()
                                   dm_mq_queue_rq()
                                     dm_start_request()
                                       dm_get(md)
                                         BUG_ON(DMF_FREEING) <-- crash

Introduce dm_try_get() which increments holders first, then checks
DMF_FREEING. If set, it decrements holders and returns false. The
smp_mb__after_atomic() ensures the increment is visible before reading
the flag, providing correct synchronization with __dm_destroy().

dm_hold() was not used because it acquires the global _minor_lock,
which would cause contention in the hot I/O path.

Move dm_try_get() before blk_mq_start_request() in dm_start_request().
This ensures we don't start the block layer timer or mark the request
MQ_RQ_IN_FLIGHT for a request that will immediately fail due to device
destruction. If dm_try_get() fails, we return early without calling
blk_mq_start_request(), providing cleaner error semantics.

Signed-off-by: Libo Chen <libchen@purestorage.com>
---
 drivers/md/dm-rq.c            | 26 ++++++++++++++++----------
 drivers/md/dm.c               | 12 ++++++++++++
 include/linux/device-mapper.h |  1 +
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index a6ca92049c10..dc6ba46cad92 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -430,8 +430,20 @@ ssize_t dm_attr_rq_based_seq_io_merge_deadline_store(struct mapped_device *md,
 	return count;
 }
 
-static void dm_start_request(struct mapped_device *md, struct request *orig)
+static bool dm_start_request(struct mapped_device *md, struct request *orig)
 {
+	/*
+	 * Hold the md reference here for the in-flight I/O.
+	 * We can't rely on the reference count by device opener,
+	 * because the device may be closed during the request completion
+	 * when all bios are completed.
+	 * See the comment in rq_completed() too.
+	 *
+	 * Fail if DMF_FREEING is set to avoid racing with __dm_destroy().
+	 */
+	if (!dm_try_get(md))
+		return false;
+
 	blk_mq_start_request(orig);
 
 	if (unlikely(dm_stats_used(&md->stats))) {
@@ -444,14 +456,7 @@ static void dm_start_request(struct mapped_device *md, struct request *orig)
 				    &tio->stats_aux);
 	}
 
-	/*
-	 * Hold the md reference here for the in-flight I/O.
-	 * We can't rely on the reference count by device opener,
-	 * because the device may be closed during the request completion
-	 * when all bios are completed.
-	 * See the comment in rq_completed() too.
-	 */
-	dm_get(md);
+	return true;
 }
 
 static int dm_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
@@ -508,7 +513,8 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ti->type->busy && ti->type->busy(ti))
 		return BLK_STS_RESOURCE;
 
-	dm_start_request(md, rq);
+	if (!dm_start_request(md, rq))
+		return BLK_STS_IOERR;
 
 	/* Init tio using md established in .init_request */
 	init_tio(tio, rq, md);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6c83ab940af7..bd75b34de333 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2673,6 +2673,18 @@ void dm_get(struct mapped_device *md)
 	BUG_ON(test_bit(DMF_FREEING, &md->flags));
 }
 
+bool dm_try_get(struct mapped_device *md)
+{
+	atomic_inc(&md->holders);
+	smp_mb__after_atomic();
+
+	if (unlikely(test_bit(DMF_FREEING, &md->flags))) {
+		atomic_dec(&md->holders);
+		return false;
+	}
+	return true;
+}
+
 int dm_hold(struct mapped_device *md)
 {
 	spin_lock(&_minor_lock);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 84fdc3a6a19a..8df81c180f2f 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -500,6 +500,7 @@ int dm_create(int minor, struct mapped_device **md);
  */
 struct mapped_device *dm_get_md(dev_t dev);
 void dm_get(struct mapped_device *md);
+bool dm_try_get(struct mapped_device *md);
 int dm_hold(struct mapped_device *md);
 void dm_put(struct mapped_device *md);
 
-- 
2.34.1

