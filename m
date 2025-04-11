Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCFB28F93B
	for <dm-devel@lists.linux.dev>; Fri, 11 Apr 2025 20:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744405027; cv=none; b=mF8R+QR62lgjWhYmPfiAkOa2i3/hmA0cNNeddqcTV5pURH1mQfuzIfYr7MBVA4Ta8yPDRZbC1tEh9GMIl8CfIgAl4+/EhJtbTqioePbaZ0gxy21quCvVHj+HmScZyr77a8EssxjohPnOrLco7YfMYI7IYVON69ZKHkfMxjTUaik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744405027; c=relaxed/simple;
	bh=aXwgF9Nyu9Pxe2bBo62WXHeHxcsBzE/lU3xgwLnakwY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=cK2IZKSEd4bUQK8iNsOKey8954M1SUCUXaEieJKO8dm3pNFbnodHkWaExAYhJYG1RmBm+gx1IWRlcQvuUizdQpTPZc7YztHSIN8a6XQ1ihz9SU8nHYTKJdE33bdjH1X2ZK8yW08Bc67ZmE+XUqBkaqv8VWbRrIh/Xw+w7TjIjvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G+hMU1uU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G+hMU1uU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744405024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7QXJ2FXc/6086WC+LsPlLNsb8cmESLMe9s6cUy90yzU=;
	b=G+hMU1uUOuJZFk1blHUhNUmxcKA0J9l7RadO5+z99O7dxNrk73fQY/3OSvpHZZhMomYOun
	iNJhRIppF/WjLbjQ4a2zQHbX/6OBfGonDWew4kRcw1w+w4f2RqU6gFJMTEFD6WHvUgR3JW
	ILtKiaexzaH6HKIQBtgkCxMMpm4CoJY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-auM1IeEaNrSBH5B5gAgUTw-1; Fri,
 11 Apr 2025 16:57:00 -0400
X-MC-Unique: auM1IeEaNrSBH5B5gAgUTw-1
X-Mimecast-MFC-AGG-ID: auM1IeEaNrSBH5B5gAgUTw_1744405020
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A35C719560B6;
	Fri, 11 Apr 2025 20:56:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9CDE180B492;
	Fri, 11 Apr 2025 20:56:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53BKuv6c060718
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 16:56:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53BKuuCa060717;
	Fri, 11 Apr 2025 16:56:56 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>,
        Christian Loehle <christian.loehle@arm.com>
Subject: [PATCH] dm-delay: don't busy-wait in kthread
Date: Fri, 11 Apr 2025 16:56:56 -0400
Message-ID: <20250411205656.60709-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: c_2jBNpLwZ5EUj9mPAPFphBEdtM1AAzRz5FJYoHIfnE_1744405020
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When using a kthread to delay the IOs, dm-delay would continuously loop,
checking if IOs were ready to submit. It had a cond_resched() call in
the loop, but might still loop hundreds of millions of times waiting for
an IO that was scheduled to be submitted 10s of ms in the future. With
the change to make dm-delay over zoned devices always use kthreads
regardless of the length of the delay, this wasted work only gets worse.

To solve this and still keep roughly the same precision for very short
delays, dm-delay now calls fsleep() for 1/8th of the smallest non-zero
delay it will place on IOs, or 1 ms, whichever is smaller. The reason
that dm-delay doesn't just use the actual expiration time of the next
delayed IO to calculated the sleep time is that delay_dtr() must wait
for the kthread to finish before deleting the table. If a zoned device
with a long delay queued an IO shortly before being suspended and
removed, the IO would be flushed in delay_presuspend(), but the removing
the device would still have to wait for the remainder of the long delay.
This time is now capped at 1 ms.

Fixes: 70bbeb29fab09 ("dm delay: for short delays, use kthread instead of timers and wq")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
This patch is meant to apply on top of Damien Le Moal's "dm-delay:
Prevent zoned write reordering on suspend" patch. If people think it's
important to avoid either this much smaller amount of looping or the
possible 1 ms delay on deleting a table, I can send a patch that uses
usleep_range_state() and msleep_interruptible() to do an interruptible
sleep with a duration based on the expiration time of the next delayed
IO.

 drivers/md/dm-delay.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index c665b2ab1115..23027aa3fdca 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -14,11 +14,14 @@
 #include <linux/bio.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
+#include <linux/delay.h>
 
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "delay"
 
+#define SLEEP_SHIFT 3
+
 struct delay_class {
 	struct dm_dev *dev;
 	sector_t start;
@@ -34,6 +37,7 @@ struct delay_c {
 	struct work_struct flush_expired_bios;
 	struct list_head delayed_bios;
 	struct task_struct *worker;
+	unsigned int worker_sleep_ns;
 	bool may_delay;
 
 	struct delay_class read;
@@ -136,7 +140,8 @@ static int flush_worker_fn(void *data)
 			schedule();
 		} else {
 			spin_unlock(&dc->delayed_bios_lock);
-			cond_resched();
+			if (dc->may_delay)
+				fsleep(dc->worker_sleep_ns);
 		}
 	}
 
@@ -212,7 +217,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct delay_c *dc;
 	int ret;
-	unsigned int max_delay;
+	unsigned int max_delay, min_delay;
 	bool is_zoned = false;
 
 	if (argc != 3 && argc != 6 && argc != 9) {
@@ -236,7 +241,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ret = delay_class_ctr(ti, &dc->read, argv);
 	if (ret)
 		goto bad;
-	max_delay = dc->read.delay;
+	min_delay = max_delay = dc->read.delay;
 	is_zoned = bdev_is_zoned(dc->read.dev->bdev);
 
 	if (argc == 3) {
@@ -253,6 +258,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (ret)
 		goto bad;
 	max_delay = max(max_delay, dc->write.delay);
+	min_delay = min_not_zero(min_delay, dc->write.delay);
 	is_zoned = is_zoned || bdev_is_zoned(dc->write.dev->bdev);
 
 	if (argc == 6) {
@@ -266,6 +272,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (ret)
 		goto bad;
 	max_delay = max(max_delay, dc->flush.delay);
+	min_delay = min_not_zero(min_delay, dc->flush.delay);
 	is_zoned = is_zoned || bdev_is_zoned(dc->flush.dev->bdev);
 
 out:
@@ -276,6 +283,10 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 * suspend.
 	 */
 	if (max_delay < 50 || is_zoned) {
+		if (min_delay >> SLEEP_SHIFT)
+			dc->worker_sleep_ns = 1000;
+		else
+			dc->worker_sleep_ns = (min_delay * 1000) >> SLEEP_SHIFT;
 		dc->worker = kthread_run(&flush_worker_fn, dc, "dm-delay-flush-worker");
 		if (IS_ERR(dc->worker)) {
 			ret = PTR_ERR(dc->worker);
-- 
2.48.1

