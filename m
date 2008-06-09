From: Richard Kennedy <richard@rsk.demon.co.uk>
Subject: [patch] dm: reorder dm_io to remove padding on 64 bit builds
Date: Mon, 09 Jun 2008 12:41:15 +0100
Message-ID: <1213011675.2967.5.camel@castor.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760776AbYFILlb@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: lkml <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

shrinks size from 40 -> 32 allowing more objects/slab
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---

This change looks safe AFAICT, but I have not tested it other than
compiling it.
Compiled on 2.6.26-rc5 AMD64.
HTH
Richard


diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 372369b..efe9690 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -37,8 +37,8 @@ static DEFINE_SPINLOCK(_minor_lock);
 struct dm_io {
 	struct mapped_device *md;
 	int error;
-	struct bio *bio;
 	atomic_t io_count;
+	struct bio *bio;
 	unsigned long start_time;
 };
 
