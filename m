Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9B94C64EC7
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319279;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TELQs0IRCFtq+1b9bPIk0LzU0PkGh6iGPN0FYSXQr1A=;
	b=eSZST/4TXCNNidzJCPuelyTwGKZr3WDkWVE1iPP2c4L5gtXyngxzDVreE+VZ/SREGK9GzH
	Cab0rKBhYcnoeXDEMhU8AMhkKCYw27bGqIcnbU6kGJetONcQMAbRghGqquYukXOXYyMS0m
	r8tvdFm8TnvAPt4iLCQFJ1Q8nO9iTCQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-3Y7WxXDxPmapYkWqi3aINw-1; Mon, 13 Feb 2023 15:14:36 -0500
X-MC-Unique: 3Y7WxXDxPmapYkWqi3aINw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA6053815F70;
	Mon, 13 Feb 2023 20:14:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 98AE5492B04;
	Mon, 13 Feb 2023 20:14:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7BAFC1946588;
	Mon, 13 Feb 2023 20:14:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8B0A61946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7EA61492B05; Mon, 13 Feb 2023 20:14:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 775F3492B04
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CBC429DD98C
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:33 +0000 (UTC)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com
 [209.85.160.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-82-sxJRcAZSNK-OAVJkoASzBQ-1; Mon, 13 Feb 2023 15:14:32 -0500
X-MC-Unique: sxJRcAZSNK-OAVJkoASzBQ-1
Received: by mail-qt1-f180.google.com with SMTP id w3so15178993qts.7
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=8qsueLjT++U5+QrKmutMiGf3QnMytnRMdFFqEoGObLA=;
 b=ca63jqXgGP8jRF5xrYUWY8txSltViDJNo8Li/NqhsAIU6hUPcgfgPyOU/H+FP4Ud2g
 DUo++VGSV3LFiBBlJFk6g155hl/Sq/afsjUUxaIFy0VE46zM7QaqUWCsdB4jH8STQHDD
 IsCM++zMBPQ4779hvcXAcHl9EQ8q0Hym9uIAwZmK9d3UNtI928mL3tzaGON95Iij8cT/
 VVVdS+tBOC6Qq0qiK7Eh6AUFqVgAZ+u8MOVr9JHAZOmTbfy131Imic6oSLBdoLk4Hb2E
 LOvTQcgBas08lfMtKgDTe2YSsBJqVzuIWAiQGAWsmAYK5ABpEjdsQfe2dlTc1VPBc49t
 p1fQ==
X-Gm-Message-State: AO0yUKUgvH9nW/Pp6M1xwd2UDfKm4MM3fU//uBdV3wd1HdYgwt6lvuzL
 9xjyi+luV2RUfd6SLkdy/gHmpIFD7nvRzMCf1ocnTQTjbpcMXeZUJ6tjgO6ZKdfMMd+4/I8tLsd
 ZVLi4HQmVnRUTwNjW9icM+XvBrOKA5w45ziJdJmh6diL/eIGht6e9lGu/LoStrrY3GlYouA==
X-Google-Smtp-Source: AK7set9Mpz9QteoABwgDzD/+0xWMtAf2QMfMq0eWGVHHZsontqPe7Qr2R7SkzxwS5HQ+I27yE4uxZw==
X-Received: by 2002:ac8:5350:0:b0:3b9:bd8d:bb22 with SMTP id
 d16-20020ac85350000000b003b9bd8dbb22mr24768254qto.14.1676319271014; 
 Mon, 13 Feb 2023 12:14:31 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 p11-20020a05622a00cb00b003b86d3ee49asm10219038qtw.74.2023.02.13.12.14.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:30 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:25 -0500
Message-Id: <20230213201401.45973-4-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 03/39] dm: use fsleep() instead of msleep() for
 deterministic sleep duration
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-init.c   | 2 +-
 drivers/md/dm-kcopyd.c | 4 ++--
 drivers/md/dm-snap.c   | 6 +++---
 drivers/md/dm.c        | 8 ++++----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index de8d8d0049e0..52362453ab58 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -295,7 +295,7 @@ static int __init dm_init_init(void)
 		if (waitfor[i]) {
 			DMINFO("waiting for device %s ...", waitfor[i]);
 			while (!dm_get_dev_t(waitfor[i]))
-				msleep(5);
+				fsleep(5000);
 		}
 	}
 
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 837f2a6dd00e..132b50d06121 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -110,7 +110,7 @@ static DEFINE_SPINLOCK(throttle_spinlock);
  * The reason for this is unknown but possibly due to jiffies rounding errors
  * or read/write cache inside the disk.
  */
-#define SLEEP_MSEC			100
+#define SLEEP_USEC			100000
 
 /*
  * Maximum number of sleep events. There is a theoretical livelock if more
@@ -158,7 +158,7 @@ static void io_job_start(struct dm_kcopyd_throttle *t)
 	if (unlikely(skew > 0) && slept < MAX_SLEEPS) {
 		slept++;
 		spin_unlock_irq(&throttle_spinlock);
-		msleep(SLEEP_MSEC);
+		fsleep(SLEEP_USEC);
 		goto try_again;
 	}
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 99d5cf1130f0..c50368512bee 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -298,12 +298,12 @@ static int __chunk_is_tracked(struct dm_snapshot *s, chunk_t chunk)
 
 /*
  * This conflicting I/O is extremely improbable in the caller,
- * so msleep(1) is sufficient and there is no need for a wait queue.
+ * so fsleep(1000) is sufficient and there is no need for a wait queue.
  */
 static void __check_for_conflicting_io(struct dm_snapshot *s, chunk_t chunk)
 {
 	while (__chunk_is_tracked(s, chunk))
-		msleep(1);
+		fsleep(1000);
 }
 
 /*
@@ -1494,7 +1494,7 @@ static void snapshot_dtr(struct dm_target *ti)
 	unregister_snapshot(s);
 
 	while (atomic_read(&s->pending_exceptions_count))
-		msleep(1);
+		fsleep(1000);
 	/*
 	 * Ensure instructions in mempool_exit aren't reordered
 	 * before atomic_read.
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c4a99bdb956c..2e4193ae064c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -436,7 +436,7 @@ static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
 	r = ti->type->prepare_ioctl(ti, bdev);
 	if (r == -ENOTCONN && !fatal_signal_pending(current)) {
 		dm_put_live_table(md, *srcu_idx);
-		msleep(10);
+		fsleep(10000);
 		goto retry;
 	}
 
@@ -2442,7 +2442,7 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 		set_bit(DMF_POST_SUSPENDING, &md->flags);
 		dm_table_postsuspend_targets(map);
 	}
-	/* dm_put_live_table must be before msleep, otherwise deadlock is possible */
+	/* dm_put_live_table must be before fsleep, otherwise deadlock is possible */
 	dm_put_live_table(md, srcu_idx);
 	mutex_unlock(&md->suspend_lock);
 
@@ -2454,7 +2454,7 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	 */
 	if (wait)
 		while (atomic_read(&md->holders))
-			msleep(1);
+			fsleep(1000);
 	else if (atomic_read(&md->holders))
 		DMWARN("%s: Forcibly removing mapped_device still in use! (%d users)",
 		       dm_device_name(md), atomic_read(&md->holders));
@@ -2531,7 +2531,7 @@ static int dm_wait_for_completion(struct mapped_device *md, unsigned int task_st
 			break;
 		}
 
-		msleep(5);
+		fsleep(5000);
 	}
 
 	return r;
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

