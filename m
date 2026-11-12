Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794447359;
	b=kCqaRYvsXUcoLc8fJ1CIUXjFKtqGX5o+AWFGnR/HTIh8LgrFZ+j0oUVIi9BRU62rf2Bh
	 r+9frS69ywfk9E3trKyz0aZb5NPZrvncxckpsV/+UsQvim75OLevJjjIwVZwc0A6cdznp
	 9Ens/86W2/HyPiqfeTY7ZZHUorUSZo9aW4g/V/MqOpBS/XtXt5CZOFkV6xTG1WgPVDshm
	 poVEWVZwUIPLxXNCdDODbW8xfOLDKFCFY+ggCI7TmgF00w3tpAOryddluUFphwujCFD/b
	 56EHwRQcy4soUcdamJzREoy/G7+YYYMhAGjcXfh1pVSHaF1KxXAZWPR41ePr5/YVZjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794447359;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=ELLqdcOAA9rFtchadf0YpKl1TUOHi1tEx6RNAEsB1Ng=;
	b=yj6hFBfG26Lx8PxI8xEszxRkmutkV95HWiJuchVH55iE5zImRkUYi6gWFhRcMOHOMyj4
	 yqqvzhg/8XYWlX4SbqpCOJ9N6EtIibczpACQqAMTe7kVIWAQmfx57Cd7xdDTVut8tqPS+
	 ANhP3SgzxqdRVgMyECuCzLpUjfDDl/1Ihr+cYGuQ08qD4VjYdVJyWkZTwf50rSgAAMdqF
	 HlHd9lrUzcjE2QIEiXa6MSZD6W9GEtsB2jZTfudSa6s2B6xNxuN4qs+2iFznSU5iqwclO
	 voYKuCzr48O4kkQUVDbiE7drVKnqgWitdZokCnAWfeakYjyDiwefGuf491nVJxvzp1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=jnpUM+nz;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77AE606A335
	for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 01:35:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B77AE606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=jnpUM+nz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=EL
	LqdcOAA9rFtchadf0YpKl1TUOHi1tEx6RNAEsB1Ng=; b=jnpUM+nz1+F/CW7Tu3
	DAHsc0kE5QXayzPzFu9XS8WRwY+e0Wcbqf9ceGXoQehX7uADa6N6yfMe137Kcwae
	RUbhVuHNJg9otWS/iVd4slqDLUr2C8CuGhIO73dFv4FTAYV443bFWZLf6NX++I4x
	Ct5SxfU9FN32OBmYE5VvqP3QQ=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wCnA2zdF_VqvPswHA--.52798S2;
	Thu, 12 Nov 2026 09:35:27 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: song@kernel.org,
	yukuai@fygo.io,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>,
	syzbot+a53c2918175b36cfd601@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v5] md: fix sync_work vs array teardown races
Date: Thu, 12 Nov 2026 09:35:23 +0800
Message-Id: <20261112013523.120428-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCnA2zdF_VqvPswHA--.52798S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Ary7Gr1DCw4fKryfAw1DJrb_yoWxWr18pr
	WrJFn8Gr4Dt3yxZFZrK3WDua4Yvw1Sq3yDJryxWa4fAw1SyF47uFy09F1jvFWDJas3tayU
	Zw4rJFZxuFyq9FJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jj_M-UUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3QAWxGr1F+CIuAAA3X

From: Li Youhong <liyouhong@kylinos.cn>

dm-raid tears down arrays via md_stop(), which cleared mddev->pers
without waiting for previously queued sync_work. That work could
then call remove_spares() with pers == NULL, or keep using mddev
after raid_dtr() frees it.

do_md_stop()/md_stop_writes() already call stop_sync_thread() before
teardown. Do the same in md_stop(). Because md_start_sync() may still
use mddev after unlocking / clearing MD_RECOVERY_RUNNING, flush
sync_work whenever it is busy rather than only when work_pending().

Calling stop_sync_thread() from md_stop() can drop reconfig_mutex,
which introduces two follow-on issues:

- When nothing is in flight, keep reconfig_mutex if the caller held
  it (gate the idle early-return with work_busy()). Otherwise clear
  of an inactive array can race with do_md_run().

- While the mutex is dropped, mddev->thread may run
  md_reap_sync_thread() and queue event_work. Flush event_work on
  the raid_ctr() error path before raid_set_free().

Separately, the read-only path in md_check_recovery() queued
sync_work without honouring MD_RECOVERY_FROZEN, unlike the
read-write path. Check FROZEN there so freeze/stop cannot race
with a new queue.

Fixes: db5e653d7c9f ("md: delay choosing sync action to md_start_sync()")
Fixes: 81e2ce1b3d5a ("md: delay remove_and_add_spares() for read only array to md_start_sync()")
Reported-by: syzbot+a53c2918175b36cfd601@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a53c2918175b36cfd601
Cc: stable@vger.kernel.org
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
---
v5:
- Restore idle early-return in stop_sync_thread() gated by work_busy(),
  so locked callers keep reconfig_mutex and do not race with do_md_run().
- Flush event_work before raid_set_free() on the raid_ctr error path
  (md_stop() may drop the mutex and let md_reap queue it).
- v4: https://lore.kernel.org/linux-raid/20261111015027.4029184-1-dayou5941@163.com

v4:
- Always flush_work(&sync_work) in stop_sync_thread(); do not delay
  clearing MD_RECOVERY_RUNNING (that can drop MD_RECOVERY_NEEDED via
  md_check_recovery, and does not cover the successful sync_thread
  registration path).
- v3: https://lore.kernel.org/linux-raid/20261110063045.912703-1-dayou5941@163.com

v3:
- Honour MD_RECOVERY_FROZEN before queueing sync_work on the
  read-only md_check_recovery() path.
- (superseded) delayed MD_RECOVERY_RUNNING clear on not_running.
- v2: https://lore.kernel.org/linux-raid/20261109023055.2164333-1-dayou5941@163.com

v2:
- Drop the pers NULL check in md_start_sync().
- Call stop_sync_thread() from md_stop() before clearing pers,
  matching do_md_stop()/md_stop_writes().
- v1: https://lore.kernel.org/linux-raid/20261106083543.249267-1-dayou5941@163.com

 drivers/md/dm-raid.c |  7 +++++++
 drivers/md/md.c      | 41 ++++++++++++++++++++++++++++++++---------
 2 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index ac019a0f5a92..f82c09d858de 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3319,6 +3319,13 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	md_stop(&rs->md);
 	mddev_unlock(&rs->md);
 bad:
+	/*
+	 * md_stop() may drop reconfig_mutex so mddev->thread can run
+	 * md_reap_sync_thread() and queue event_work; wait for it before
+	 * freeing raid_set. Skip if INIT_WORK has not run yet.
+	 */
+	if (rs->md.event_work.func)
+		flush_work(&rs->md.event_work);
 	raid_set_free(rs);
 
 	return r;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..79c564320f18 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5184,7 +5184,14 @@ static void stop_sync_thread(struct mddev *mddev, bool locked)
 {
 	int sync_seq = atomic_read(&mddev->sync_seq);
 
-	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
+	/*
+	 * If nothing is in flight, keep reconfig_mutex when locked so
+	 * callers such as do_md_stop() cannot race with do_md_run().
+	 * work_busy() is required: md_start_sync() may clear RUNNING and
+	 * still use mddev after unlocking.
+	 */
+	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
+	    !work_busy(&mddev->sync_work)) {
 		if (!locked)
 			mddev_unlock(mddev);
 		return;
@@ -5192,14 +5199,20 @@ static void stop_sync_thread(struct mddev *mddev, bool locked)
 
 	mddev_unlock(mddev);
 
-	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+		/*
+		 * Thread might be blocked waiting for metadata update which
+		 * will now never happen
+		 */
+		md_wakeup_thread_directly(&mddev->sync_thread);
+	}
 	/*
-	 * Thread might be blocked waiting for metadata update which will now
-	 * never happen
+	 * md_start_sync() may still use mddev after unlocking. Always
+	 * flush so teardown waits for that work to return; checking
+	 * work_pending() is not enough once the work is running.
 	 */
-	md_wakeup_thread_directly(&mddev->sync_thread);
-	if (work_pending(&mddev->sync_work))
-		flush_work(&mddev->sync_work);
+	flush_work(&mddev->sync_work);
 
 	wait_event(resync_wait,
 		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
@@ -7101,6 +7114,14 @@ void md_stop(struct mddev *mddev)
 {
 	lockdep_assert_held(&mddev->reconfig_mutex);
 
+	/*
+	 * md_check_recovery() may have queued sync_work; that work accesses
+	 * pers. Wait for it here before __md_stop() clears pers, as
+	 * do_md_stop()/md_stop_writes() do.
+	 */
+	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	stop_sync_thread(mddev, true);
+
 	/* stop the array and free an attached data structures.
 	 * This is called from dm-raid
 	 */
@@ -10494,9 +10515,11 @@ void md_check_recovery(struct mddev *mddev)
 
 			/*
 			 * Let md_start_sync() to remove and add rdevs to the
-			 * array.
+			 * array. Honour MD_RECOVERY_FROZEN like the read-write
+			 * path so freeze/stop does not race with a new queue.
 			 */
-			if (md_spares_need_change(mddev)) {
+			if (md_spares_need_change(mddev) &&
+			    !test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
 				set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 				queue_work(md_misc_wq, &mddev->sync_work);
 			}
-- 
2.25.1

