Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A424AE11E
	for <dm-devel@lists.linux.dev>; Wed, 16 Sep 2026 12:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789561162; cv=none; b=T21pN2rGGAk965XIL1m1SiP+TXKety3kUZEngZY8UhZVpUoP7clfgJAHpQtd3pxAoWzEnCD4QFPEY0mPHD7vJSXQDjHBqHx8IZfPQ8G3FVMexQQilcqwe3kQDjcqMFe5Ixm+U8ZTnqOR4zZSeGiKGlGSF7nMiY74FsHkdReTalM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789561162; c=relaxed/simple;
	bh=jmx7/yWhal1Ww0spXVCH3wKe4jQDQSBTK9V0nYDAg1Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AIANyrkl+gkbTsG1cxwa1hbiO24CYQsh3cVIhnwHQ68kz5CLKOC2Oe7kG0p62/cSLJKAmn2Wh0D43m73zRDnI+HDJBaoadd1ZuMhMdGjUw8Hyc3r1Fy4KUsghO03z3hWNO3/dzaQVBYJf/cLZ6luHOOakBImTuVkn1LThgDrN0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=hGWKbDUd; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="hGWKbDUd"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=WucdU+U+fDtH/dtaM74XSmEX2/Z1Bt+S4MDbGB5y5Vs=;
	b=hGWKbDUd4/4znpJBctaK+2GsDhJTzEF2OF0TIlwfkftz8hk9m1u4qZtahBDqVnbf1nQQ/TJQB
	OdQHI1b+PBMgXce4fVJMdMX6AYuAoIrcrfsza9D1wE0DvWtm0JbT8f7kjgod0fgXd0u6teRpgVW
	8JqN2S8nsXxk7KC82IFm0xc=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hlHhm5bq6z1cyPY;
	Wed, 16 Sep 2026 20:08:08 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id D1A65402AB;
	Wed, 16 Sep 2026 20:19:06 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200011.china.huawei.com
 (7.152.185.179) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 16 Sep
 2026 20:19:05 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<bmarzins@redhat.com>, <song@kernel.org>, <yukuai@fygo.io>,
	<eadavis@sina.com>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <chengzhihao1@huawei.com>,
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH] md: Fix the null-ptr-deref of 'mddev->private' while submitting IO
Date: Wed, 16 Sep 2026 20:11:20 +0800
Message-ID: <20260916121120.1242281-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemo200011.china.huawei.com (7.152.185.179)

Concurrent processes md_stop and IO submitting could trigger a
null-ptr-deref of 'mddev->private':

 BUG: kernel NULL pointer dereference, address: 0000000000000070
 RIP: 0010:_wait_barrier+0x2f/0x250
 Call Trace:
  raid1_make_request+0x150/0xf50
  md_handle_request+0x104/0x530
  md_submit_bio+0x76/0x130
  submit_bio+0xdd/0x250
  submit_bio_wait+0x1f/0x40
  __blkdev_direct_IO_simple+0x1f6/0x370
  blkdev_write_iter+0x3b2/0x520
  ksys_write+0x7d/0x190

              P1
  fd = open(/dev/md0, O_RDWR)
	                      P2 (forked from P1, fd' <= fd)
  write(fd)
   submit_bio
    md_handle_request
     raid1_make_request
      raid1_write_request
                                  ioctl(fd, STOP_ARRAY)
		                   mddev_set_closing_and_sync_blockdev
				   // check passed, mddev->openers = 1,
				   // because md_open() is only called
				   // once in P1->open
				   do_md_stop
				    __md_stop
				     mddev->private = NULL

       conf = mddev->private // NULL
        wait_barrier(conf, sector) // null-ptr-deref !

It is a common problem for raid0/1/10/5, and __md_stop could be
triggered by several paths(eg. ioctl, sysfs, ->dtr). Fix it by
replacing mddev_lock() with mddev_suspend_and_lock() for all
__md_stop() callers.

Fetch a reproducer in https://bugzilla.kernel.org/show_bug.cgi?id=222020

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3fe892ea5fc292e1353f
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 drivers/md/dm-raid.c |  7 +++++--
 drivers/md/md.c      | 18 +++++++++++++++---
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8f5a5e1342a9..3dda494fe172 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3326,12 +3326,15 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 static void raid_dtr(struct dm_target *ti)
 {
+	unsigned int noio_flags = 0;
 	struct raid_set *rs = ti->private;
 
-	mddev_lock_nointr(&rs->md);
+	mddev_suspend_and_lock_nointr(&rs->md);
+	noio_flags = memalloc_noio_save();
 	md_stop(&rs->md);
 	rs->md.dm_gendisk = NULL;
-	mddev_unlock(&rs->md);
+	memalloc_noio_restore(noio_flags);
+	mddev_unlock_and_resume(&rs->md);
 
 	if (work_pending(&rs->md.event_work))
 		flush_work(&rs->md.event_work);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..e292acd54bb0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4657,6 +4657,8 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int err = 0;
 	enum array_state st = match_word(buf, array_states);
+	unsigned int noio_flags = 0;
+	bool suspend = false;
 
 	/* No lock dependent actions */
 	switch (st) {
@@ -4666,9 +4668,11 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	case broken:		/* cannot be set */
 	case bad_word:
 		return -EINVAL;
+	case inactive:
 	case clear:
+		suspend = true;
+		fallthrough;
 	case readonly:
-	case inactive:
 	case read_auto:
 		if (!mddev->pers || !md_is_rdwr(mddev))
 			break;
@@ -4702,9 +4706,11 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		spin_unlock(&mddev->lock);
 		return err ?: len;
 	}
-	err = mddev_lock(mddev);
+	err = suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
 	if (err)
 		return err;
+	if (suspend)
+		noio_flags = memalloc_noio_save();
 
 	switch (st) {
 	case inactive:
@@ -4775,7 +4781,12 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 			mddev->hold_active = 0;
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	}
-	mddev_unlock(mddev);
+	if (suspend) {
+		memalloc_noio_restore(noio_flags);
+		mddev_unlock_and_resume(mddev);
+	} else {
+		mddev_unlock(mddev);
+	}
 
 	if (st == readonly || st == read_auto || st == inactive ||
 	    (err && st == clear))
@@ -8299,6 +8310,7 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
 	case HOT_REMOVE_DISK:
 	case SET_BITMAP_FILE:
 	case SET_ARRAY_INFO:
+	case STOP_ARRAY:
 		return true;
 	default:
 		return false;
-- 
2.52.0

