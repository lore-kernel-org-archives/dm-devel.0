From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH 7/7] dm/md dependency tree in sysfs: convert bd_sem to bd_mutex
Date: Mon, 13 Mar 2006 17:17:43 -0500
Message-ID: <4415EF87.8060006@ce.jp.nec.com>
References: <4415EC4B.4010003@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030202050004070800080201"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932506AbWCMWQV@vger.kernel.org>
In-Reply-To: <4415EC4B.4010003@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Alasdair Kergon <agk@redhat.com>, Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>
Cc: Lars Marowsky-Bree <lmb@suse.de>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------030202050004070800080201
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

This patch is part of dm/md dependency tree in sysfs.

This patch follows the change introduced by
sem2mutex-blockdev-2.patch in 2.6.16-rc6-mm1.

Thanks,
-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

--------------030202050004070800080201
Content-Type: text/x-patch;
 name="07-sem2mutex-bd_sem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="07-sem2mutex-bd_sem.patch"

Convert bd_sem to bd_mutex

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

 block_dev.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.16-rc6-mm1.orig/fs/block_dev.c.orig-mm1	2006-03-13 14:04:32.000000000 -0500
+++ linux-2.6.16-rc6-mm1/fs/block_dev.c	2006-03-13 12:29:35.000000000 -0500
@@ -674,11 +674,11 @@ int bd_claim_by_kobject(struct block_dev
 	if (!bo)
 		return -ENOMEM;
 
-	down(&bdev->bd_sem);
+	mutex_lock(&bdev->bd_mutex);
 	res = bd_claim(bdev, holder);
 	if (res || !add_bd_holder(bdev, bo))
 		free_bd_holder(bo);
-	up(&bdev->bd_sem);
+	mutex_unlock(&bdev->bd_mutex);
 
 	return res;
 }
@@ -692,11 +692,11 @@ void bd_release_from_kobject(struct bloc
 	if (!kobj)
 		return;
 
-	down(&bdev->bd_sem);
+	mutex_lock(&bdev->bd_mutex);
 	bd_release(bdev);
 	if ((bo = del_bd_holder(bdev, kobj)))
 		free_bd_holder(bo);
-	up(&bdev->bd_sem);
+	mutex_unlock(&bdev->bd_mutex);
 }
 
 EXPORT_SYMBOL(bd_release_from_kobject);

--------------030202050004070800080201--
