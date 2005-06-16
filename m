From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] 2.6.12-rc6: fix rh_dec()/rh_inc() race in
	dm-raid1.c
Date: Thu, 16 Jun 2005 18:51:41 -0400
Message-ID: <42B2027D.7040807@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070605000504010802010704"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------070605000504010802010704
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hello,

Attached patch fixes the another bug in dm-raid1.c that
the dirty region may stay in or be moved to clean list
and freed while in use.

It happens as follows:

   CPU0                                   CPU1
   ------------------------------------------------------------------------------
   rh_dec()
     if (atomic_dec_and_test(pending))
        <the region is still marked dirty>
                                          rh_inc()
                                            if the region is clean
                                               mark the region dirty
                                               and remove from clean list
        mark the region clean
        and move to clean list
                                                  atomic_inc(pending)

At this stage, the region is in clean list and
will be mistakenly reclaimed by rh_update_states() later.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>


--------------070605000504010802010704
Content-Type: text/x-patch;
 name="dm-raid1-race2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-raid1-race2.patch"

--- kernel/drivers/md/dm-raid1.c.orig	2005-06-16 07:13:50.610325768 -0400
+++ kernel/drivers/md/dm-raid1.c	2005-06-16 10:34:12.510719112 -0400
@@ -375,16 +380,18 @@ static void rh_inc(struct region_hash *r
 
 	read_lock(&rh->hash_lock);
 	reg = __rh_find(rh, region);
+
+	atomic_inc(&reg->pending);
+
+	spin_lock_irq(&rh->region_lock);
 	if (reg->state == RH_CLEAN) {
 		rh->log->type->mark_region(rh->log, reg->key);
 
-		spin_lock_irq(&rh->region_lock);
 		reg->state = RH_DIRTY;
 		list_del_init(&reg->list);	/* take off the clean list */
-		spin_unlock_irq(&rh->region_lock);
 	}
+	spin_unlock_irq(&rh->region_lock);
 
-	atomic_inc(&reg->pending);
 	read_unlock(&rh->hash_lock);
 }
 
@@ -408,6 +414,10 @@ static void rh_dec(struct region_hash *r
 
 	if (atomic_dec_and_test(&reg->pending)) {
 		spin_lock_irqsave(&rh->region_lock, flags);
+		if (atomic_read(&reg->pending)) { /* check race */
+			spin_unlock_irqrestore(&rh->region_lock, flags);
+			return;
+		}
 		if (reg->state == RH_RECOVERING) {
 			list_add_tail(&reg->list, &rh->quiesced_regions);
 		} else {

--------------070605000504010802010704
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070605000504010802010704--
