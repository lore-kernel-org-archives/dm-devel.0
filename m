Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E49666B51
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 09:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706605997; cv=none; b=Wz9ktWNqqsCZg5eTYM8VdheLJhaUZjix7Eq2CnXrlGly9e1lpGfmTGQYoNQmL6lcPZrb4U45LGXUDp6Yfe3Puip3u4yXvRoFFeqy4tYEgPI6lP9WJ+xH8iNbOmpowGoRpdcp/5hxXtnHtesjy/tCjP8ltiUSTwzetW5JKBHC74M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706605997; c=relaxed/simple;
	bh=SZMS+fgtkFfSzguhmeH2OmNAK1/PWSF2Bv2J0fmCKdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRn0Zu0xT8E/8xix9a160BJKVWUYExcGO33azdOm3OSvKAeoLX1p2z/+wMlm4heWjyJXYS4EFqXPy0pIf2EqwgRTpGr7Qk7054XVt6Wx//97UMKqP/D9GPV5Juh51RvPDMEnY+is6GVUGkBTOXMFntC1JaXYg9l/huEFdN7383E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KvCs9Pp0; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KvCs9Pp0"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d8e7df6abcso10367355ad.1
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 01:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706605995; x=1707210795; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EEGg3+Udn4gaw+4rcyLZgU170AVrEZ3wtyY0WMo5DU8=;
        b=KvCs9Pp01lR7SOBJfoegP6PHZWoQKbPSjFRG0WWIe/mARnFKRveOP/IirfJcmknF2f
         3hny/qR/RNU9IjImoBku2fV1iJ1IEAYTyyTnxlBpY1jEiHIL3LzVEbXPNOaqWaCxyv5f
         FtTEEDfOspwusuP0fWwFHj8kIPOYZvRqXTuB7G+edo1XQfIp7M+AXvIlB5VkpcGn4qgZ
         lBwKMOEDlHJ9BiqxqIKOj/e+aMaFY6XP1Rqq54JvTadV2OzgEt4HhZb5v8teufa4yUNn
         l65bzbLJFTpOxeR4gnNb7X6n/bjx2oz1YD6/Pwy8+jPFVcGVksUSvBEs1JxUwJRsmeR0
         VA7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706605995; x=1707210795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EEGg3+Udn4gaw+4rcyLZgU170AVrEZ3wtyY0WMo5DU8=;
        b=Tul7PVY37orFjqwG3gEW+bEuWDzajF9iWkZeapDlAjcGARVnxVfuxQGs2lJ8WOK/rB
         6ASqlvYhkMqb4XQUXch8pMBMzt2+M7e1VctcFMUCCbzWzBJomQFG9+CMphZtrdqNOswd
         0TMCZMSGOqexeFKHtnk1FYbKbbvTCiDXfrfIKeGc4OSFzJusmRU3FC4N4avFyeeh0Nhs
         0GEu3KG1LKqS6st8t2B4AxpiPlMp99smGrUc796uJ9XC2EpMIvxmuSCJOOiK9DvBXfCW
         PYZP3BSy0FS9VIveJEEjPRwFb+a5NCpQG/Mm+AYJUp+wWWgHdBN6/q0wC1dtExha5fj5
         BgdA==
X-Gm-Message-State: AOJu0Yzyo2vWVZMO3u1hpmK/d2ZTNq6v/Nz3AiCDdJuf6EzUTMzgINCM
	EuxAElpmj09TLOoXtrA8dr2SngFz6Z5dyaaju6KRBuCtMKu0C34h
X-Google-Smtp-Source: AGHT+IEhz145k+wYMd2pt24Zls59HTCphqzKgGsC+jAC2Krgc2hYPa5ZJi9Znr/YRZnvFiEQHxAFow==
X-Received: by 2002:a17:902:9a0a:b0:1d8:b798:dfe3 with SMTP id v10-20020a1709029a0a00b001d8b798dfe3mr3573244plp.43.1706605995565;
        Tue, 30 Jan 2024 01:13:15 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id ki3-20020a170903068300b001d8e7db131fsm2895967plb.11.2024.01.30.01.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 01:13:15 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org,
	mpatocka@redhat.com
Cc: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	msnitzer@redhat.com,
	ignat@cloudflare.com,
	damien.lemoal@wdc.com,
	bob.liu@oracle.com,
	houtao1@huawei.com,
	peterz@infradead.org,
	mingo@kernel.org,
	netdev@vger.kernel.org,
	allen.lkml@gmail.com,
	kernel-team@meta.com,
	Tejun Heo <tj@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 7/8] dm-crypt: Convert from tasklet to BH workqueue
Date: Mon, 29 Jan 2024 23:11:54 -1000
Message-ID: <20240130091300.2968534-8-tj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240130091300.2968534-1-tj@kernel.org>
References: <20240130091300.2968534-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only generic interface to execute asynchronously in the BH context is
tasklet; however, it's marked deprecated and has some design flaws. To
replace tasklets, BH workqueue support was recently added. A BH workqueue
behaves similarly to regular workqueues except that the queued work items
are executed in the BH context.

This patch converts dm-crypt from tasklet to BH workqueue.

Like a regular workqueue, a BH workqueue allows freeing the currently
executing work item. Converting from tasklet to BH workqueue removes the
need for deferring bio_endio() again to a work item, which was buggy anyway.

I tested this lightly with "--perf-no_read_workqueue
--perf-no_write_workqueue" + some code modifications, but would really
-appreciate if someone who knows the code base better could take a look.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/82b964f0-c2c8-a2c6-5b1f-f3145dc2c8e5@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
---
 drivers/md/dm-crypt.c | 36 ++----------------------------------
 1 file changed, 2 insertions(+), 34 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 855b482cbff1..619c762d4072 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -73,11 +73,8 @@ struct dm_crypt_io {
 	struct bio *base_bio;
 	u8 *integrity_metadata;
 	bool integrity_metadata_from_pool:1;
-	bool in_tasklet:1;
 
 	struct work_struct work;
-	struct tasklet_struct tasklet;
-
 	struct convert_context ctx;
 
 	atomic_t io_pending;
@@ -1762,7 +1759,6 @@ static void crypt_io_init(struct dm_crypt_io *io, struct crypt_config *cc,
 	io->ctx.r.req = NULL;
 	io->integrity_metadata = NULL;
 	io->integrity_metadata_from_pool = false;
-	io->in_tasklet = false;
 	atomic_set(&io->io_pending, 0);
 }
 
@@ -1771,13 +1767,6 @@ static void crypt_inc_pending(struct dm_crypt_io *io)
 	atomic_inc(&io->io_pending);
 }
 
-static void kcryptd_io_bio_endio(struct work_struct *work)
-{
-	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
-
-	bio_endio(io->base_bio);
-}
-
 /*
  * One of the bios was finished. Check for completion of
  * the whole request and correctly clean up the buffer.
@@ -1800,21 +1789,6 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 		kfree(io->integrity_metadata);
 
 	base_bio->bi_status = error;
-
-	/*
-	 * If we are running this function from our tasklet,
-	 * we can't call bio_endio() here, because it will call
-	 * clone_endio() from dm.c, which in turn will
-	 * free the current struct dm_crypt_io structure with
-	 * our tasklet. In this case we need to delay bio_endio()
-	 * execution to after the tasklet is done and dequeued.
-	 */
-	if (io->in_tasklet) {
-		INIT_WORK(&io->work, kcryptd_io_bio_endio);
-		queue_work(cc->io_queue, &io->work);
-		return;
-	}
-
 	bio_endio(base_bio);
 }
 
@@ -2246,11 +2220,6 @@ static void kcryptd_crypt(struct work_struct *work)
 		kcryptd_crypt_write_convert(io);
 }
 
-static void kcryptd_crypt_tasklet(unsigned long work)
-{
-	kcryptd_crypt((struct work_struct *)work);
-}
-
 static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
@@ -2263,9 +2232,8 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 		 * it is being executed with irqs disabled.
 		 */
 		if (in_hardirq() || irqs_disabled()) {
-			io->in_tasklet = true;
-			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
-			tasklet_schedule(&io->tasklet);
+			INIT_WORK(&io->work, kcryptd_crypt);
+			queue_work(system_bh_wq, &io->work);
 			return;
 		}
 
-- 
2.43.0

