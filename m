Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795680664;
	b=RGF6hLJgYnIrhnuANjHle5/HzA+quLCpnye/PFkILuVxrixaif05voeX2cfqGJ0qbCom
	 9k1mJYHGWF4okOqzhdC1MR17cXeD8mqOKTGETjgL/rno00QLDKkUFg5S38QBXyZbTU98z
	 j9X6YkXjhZ4gvEV0o70vdQwiorLZTsXoUyIKCYRQgbc1HVsT5OsDDTGG7FnPg0XirlYdB
	 VSbBwRMC+HnhDZQt7r3lRQ+QRbLd701eDug0lcovUtC3HSl5pxIRW40L5zT2g5wHIckS9
	 +JbJktTUZsREnH6JKB1nWPTnXtVrZ+kh4LvkfGN+KY7MZJNl+SHZfAaV6slfw+s8DBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795680664;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=zEQwtcUWwjAq78GdjPwtjH5gDHtM20DukqhFmEz6c/g=;
	b=ww9rehmuDuZz8gYa5ZV+FdeadTKpe4gMeXRLv4HLhhLZxPXSGiIDh9BPRwBT3DyWV0nQ
	 fkDqUTiCGfUW2oKHPHw/arCIIYgSbnBLNoqzyLTDcUbuKdWAKUmga0Dbm393VgVqISrZB
	 wLGtYfZffj+YouB1k/K4EsqTN2M8IXyAmoq+IqZQRLFos30H4h815W7/PutHXBeWSz4vk
	 oiygmrCkAFt1qeosuXn8QWa0TNtwtY9pb3JZvxULLJ8Xc2iLFe8HzRo9IWReae4x4JyfA
	 qouJpOgOBymqHIFterEYWavOxPM6ZVOZZ18lytGImNaHAjUvJ2n9WJCuyPacAFwZjVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Ei22lknx;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D09C606A31E
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 08:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D09C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Ei22lknx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=zE
	QwtcUWwjAq78GdjPwtjH5gDHtM20DukqhFmEz6c/g=; b=Ei22lknx7JSeUpb/2v
	Ekt8HgRfA1xvDgERXeZrgs8zM1sX70K3ooREsFL0+m6gbHAo+HBNruGcr+q5RJPw
	+e71A0/pojFw3UnPt9bberiG1rJVvZmzcFdLwukB5wWB8t+8RZ4nugZXuF0q6VGA
	xXSEPVZ2fYofvyaz4CwuDBHG0=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgAnxpp36Qdr_XPjIA--.32026S2;
	Thu, 26 Nov 2026 16:10:32 +0800 (CST)
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
Subject: [PATCH v6 2/2] md: fix sync_work vs array teardown races
Date: Thu, 26 Nov 2026 16:10:30 +0800
Message-Id: <20261126081030.150032-1-dayou5941@163.com>
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
X-CM-TRANSID:QCgvCgAnxpp36Qdr_XPjIA--.32026S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZF15AF4xZry3Kw45tr1DKFg_yoWruryxp3
	yrJFn8Jr4Ut3yrZFyDKFyDua4Yvw1ag3yDtryxua4rAw1ftr4a9Fy093WjvFWDJas3tayU
	Z3yrJFZxZFyvgF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjCJQUUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+hg142sH6XjahAAA3X

From: Li Youhong <liyouhong@kylinos.cn>

dm-raid tears down arrays via md_stop(), which cleared mddev->pers
without waiting for previously queued sync_work. That work could
then call remove_spares() with pers == NULL, or keep using mddev
after raid_dtr() frees it.

do_md_stop()/md_stop_writes() already call stop_sync_thread() before
teardown. Do the same in md_stop().

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
index 1974943bf746..2d87b3297da4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5199,7 +5199,14 @@ static void stop_sync_thread(struct mddev *mddev, bool locked)
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
@@ -5207,12 +5214,14 @@ static void stop_sync_thread(struct mddev *mddev, bool locked)
 
 	mddev_unlock(mddev);
 
-	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-	/*
-	 * Thread might be blocked waiting for metadata update which will now
-	 * never happen
-	 */
-	md_wakeup_thread_directly(&mddev->sync_thread);
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+		/*
+		 * Thread might be blocked waiting for metadata update which
+		 * will now never happen
+		 */
+		md_wakeup_thread_directly(&mddev->sync_thread);
+	}
 	if (work_busy(&mddev->sync_work))
 		flush_work(&mddev->sync_work);
 
@@ -7130,6 +7139,14 @@ void md_stop(struct mddev *mddev)
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
@@ -10520,9 +10537,11 @@ void md_check_recovery(struct mddev *mddev)
 
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

