From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] dm-raid1.c: Conditionally ignore kcopyd errors
	depending on whether mirror handles them
Date: Fri, 25 Jul 2008 10:18:28 -0500
Message-ID: <1216999108.16636.2.camel@hydrogen>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

	brassow

dm-raid1 is setting the flag to ignore errors in kcopyd.  Now that
mirroring is capable of handling errors, it should.  So, we make
the setting of the 'ignore errors' flag conditional on whether
mirror is handling errors or not.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6.26-rc8/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.26-rc8.orig/drivers/md/dm-raid1.c
+++ linux-2.6.26-rc8/drivers/md/dm-raid1.c
@@ -842,7 +842,9 @@ static int recover(struct mirror_set *ms
 	}
 
 	/* hand to kcopyd */
-	set_bit(DM_KCOPYD_IGNORE_ERROR, &flags);
+	if (!errors_handled(ms))
+		set_bit(DM_KCOPYD_IGNORE_ERROR, &flags);
+
 	r = dm_kcopyd_copy(ms->kcopyd_client, &from, ms->nr_mirrors - 1, to,
 			   flags, recovery_complete, reg);
 
