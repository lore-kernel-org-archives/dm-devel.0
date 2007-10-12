From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 01/25] dm mpath: rdac fix init race
Date: Fri, 12 Oct 2007 18:04:34 +0100
Message-ID: <20071012170434.GL24157@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760940AbXJLREu@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Bryn M. Reeves" <breeves@redhat.com>
List-Id: dm-devel.ids

From: Bryn M. Reeves <breeves@redhat.com>

Re-order the initialisation of dm-rdac to avoid registering the hw
handler before the workqueue has been initialised. Closes a race
that would potentially give an oops.

Signed-off-by: Bryn M. Reeves <breeves@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-mpath-rdac.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6.23/drivers/md/dm-mpath-rdac.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-mpath-rdac.c	2007-10-12 13:15:23.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-mpath-rdac.c	2007-10-12 13:15:24.000000000 +0100
@@ -664,20 +664,21 @@ static struct hw_handler_type rdac_handl
 
 static int __init rdac_init(void)
 {
-	int r = dm_register_hw_handler(&rdac_handler);
-
-	if (r < 0) {
-		DMERR("%s: register failed %d", RDAC_DM_HWH_NAME, r);
-		return r;
-	}
+	int r;
 
 	rdac_wkqd = create_singlethread_workqueue("rdac_wkqd");
 	if (!rdac_wkqd) {
 		DMERR("Failed to create workqueue rdac_wkqd.");
-		dm_unregister_hw_handler(&rdac_handler);
 		return -ENOMEM;
 	}
 
+	r = dm_register_hw_handler(&rdac_handler);
+	if (r < 0) {
+		DMERR("%s: register failed %d", RDAC_DM_HWH_NAME, r);
+		destroy_workqueue(rdac_wkqd);
+		return r;
+	}
+
 	DMINFO("%s: version %s loaded", RDAC_DM_HWH_NAME, RDAC_DM_HWH_VER);
 	return 0;
 }
