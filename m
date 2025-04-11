Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971BCA92E
	for <dm-devel@lists.linux.dev>; Fri, 11 Apr 2025 00:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744329920; cv=none; b=Yje+o3+nSd+cpDKRN5XWUdcC68ivxXmvtgAO0mRr9fQkbzJoSd1SjxcecpN+1h0fc0WN6RG3WBAytpbooKuL2KY24kFSWgpunosF5eJQ210VTaVlCNLbrvZg7GA2GARqLvy6zMP6UQHDJVTG3Lwb5c4JaovkgiBpBHr7rQgowcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744329920; c=relaxed/simple;
	bh=UoJgZJoRr+JIcAAnTz6cyBS8bwmdECLM5Jmk2k5NzYo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pbex8dsksuNhJfwIvVvA89DfPDz5TBExS15LBcv45b+BY8SeUaHdYnp3oWpdkqy7KNk56p6x70Sjoy+6iQrnYWa/XhBVT45p2jeO0s9+x1KXtvkMeJ1PKA2vN+XFrR0r2RNwMxjtTWCo03Y8hsnRRcGgOX/PbevXsW4q8xHXr/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecrMCVCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecrMCVCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EF3C4CEDD;
	Fri, 11 Apr 2025 00:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744329918;
	bh=UoJgZJoRr+JIcAAnTz6cyBS8bwmdECLM5Jmk2k5NzYo=;
	h=From:To:Cc:Subject:Date:From;
	b=ecrMCVCnzX8Z2dcMzVR0hIb8NhephKKLvwxf+DYkaTkysXBDIkrClJFks9eW4LQGr
	 gUIFdlT8QIctiXQiY3AOcnmzRERNoxGLgURtRi3T8VKt8XtXMsUysKy+9rVXlkHsBt
	 QEBcprFEksmsKp3wqERPJR60cnpZOYQt3ghs5N+fTw8Ns5jmI/1FhpmEWtHIoRCKOS
	 Bqt0XZPAWNqGiSo0Er3rzrIuPEv3ChDL11bRBVKI7Xk8vt2rbRO5fsZPHR2udzZWjr
	 BOXJXwXdyn/V5XtbKOJNCQnezNucZsjDPTqzSfP+jQNgzL/Zq3MkRqqWLRtZBNbPvM
	 ACDP4s+j7riCQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2] dm-delay: Prevent zoned write reordering on suspend
Date: Fri, 11 Apr 2025 09:04:35 +0900
Message-ID: <20250411000435.1007720-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a dm-delay device is being suspended, the .presuspend() operation
is first executed (delay_presuspend()) to immediately issue all the BIOs
present in the delayed list of the device and also sets the device
may_delay boolean to false. At the same time, if any new BIO is issued
to the device will not be delayed and immediately issued with
delay_bio() returning DM_MAPIO_REMAPPED. This creates a situation where
potentially 2 different contexts may be issuing write BIOs to the same
zone of a zone device without respecting the issuing order from the
user, that is, a newly issued write BIO may be issued before other write
BIOs for the same target zone that are in the device delayed list. If
such situation occurs, write BIOs may be failed by the underlying zoned
device due to an unaligned write error.

Prevent this situation from happening by always handling newly issued
write BIOs using the delayed list of BIOs, even when the device is being
suspended. This is done by forcing the use of the worker kthread for
zoned devices, and by modifying flush_worker_fn() to always flush all
delayed BIOs if the device may_delay boolean is false.

Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
Fixes: d43929ef65a6 ("dm-delay: support zoned devices")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
Changes from v1:
 - Fixed typo in commit message
 - Added reported-by tag

 drivers/md/dm-delay.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index d4cf0ac2a7aa..c665b2ab1115 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -128,7 +128,7 @@ static int flush_worker_fn(void *data)
 	struct delay_c *dc = data;
 
 	while (!kthread_should_stop()) {
-		flush_delayed_bios(dc, false);
+		flush_delayed_bios(dc, !dc->may_delay);
 		spin_lock(&dc->delayed_bios_lock);
 		if (unlikely(list_empty(&dc->delayed_bios))) {
 			set_current_state(TASK_INTERRUPTIBLE);
@@ -213,6 +213,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	struct delay_c *dc;
 	int ret;
 	unsigned int max_delay;
+	bool is_zoned = false;
 
 	if (argc != 3 && argc != 6 && argc != 9) {
 		ti->error = "Requires exactly 3, 6 or 9 arguments";
@@ -236,6 +237,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (ret)
 		goto bad;
 	max_delay = dc->read.delay;
+	is_zoned = bdev_is_zoned(dc->read.dev->bdev);
 
 	if (argc == 3) {
 		ret = delay_class_ctr(ti, &dc->write, argv);
@@ -251,6 +253,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (ret)
 		goto bad;
 	max_delay = max(max_delay, dc->write.delay);
+	is_zoned = is_zoned || bdev_is_zoned(dc->write.dev->bdev);
 
 	if (argc == 6) {
 		ret = delay_class_ctr(ti, &dc->flush, argv + 3);
@@ -263,13 +266,16 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (ret)
 		goto bad;
 	max_delay = max(max_delay, dc->flush.delay);
+	is_zoned = is_zoned || bdev_is_zoned(dc->flush.dev->bdev);
 
 out:
-	if (max_delay < 50) {
-		/*
-		 * In case of small requested delays, use kthread instead of
-		 * timers and workqueue to achieve better latency.
-		 */
+	/*
+	 * In case of small requested delays, use kthread instead of timers and
+	 * workqueue to achieve better latency. Also use a kthread for a zoned
+	 * device so that we can preserve the order of write operations during
+	 * suspend.
+	 */
+	if (max_delay < 50 || is_zoned) {
 		dc->worker = kthread_run(&flush_worker_fn, dc, "dm-delay-flush-worker");
 		if (IS_ERR(dc->worker)) {
 			ret = PTR_ERR(dc->worker);
@@ -313,8 +319,15 @@ static int delay_bio(struct delay_c *dc, struct delay_class *c, struct bio *bio)
 
 	spin_lock(&dc->delayed_bios_lock);
 	if (unlikely(!dc->may_delay)) {
-		spin_unlock(&dc->delayed_bios_lock);
-		return DM_MAPIO_REMAPPED;
+		/*
+		 * Issue the BIO immediately if the device is not zoned. FOr a
+		 * zoned device, preserver the ordering of write operations by
+		 * using the delay list.
+		 */
+		if (!bdev_is_zoned(c->dev->bdev) || c != &dc->write) {
+			spin_unlock(&dc->delayed_bios_lock);
+			return DM_MAPIO_REMAPPED;
+		}
 	}
 	c->ops++;
 	list_add_tail(&delayed->list, &dc->delayed_bios);
-- 
2.49.0

