From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 03/13] dm headers: adjust for
	dm_kcopyd_client structure name
Date: Wed,  5 Mar 2008 19:55:54 +0100
Message-ID: <1204743364-3248-4-git-send-email-hjm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids


Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
---
 drivers/md/dm-snap.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git linux-2.6.25-rc4.orig/drivers/md/dm-snap.h linux-2.6.25-rc4/drivers/md/dm-snap.h
index 93bce5d..37d7eaf 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-snap.h
+++ linux-2.6.25-rc4/drivers/md/dm-snap.h
@@ -1,7 +1,6 @@
 /*
- * dm-snapshot.c
- *
- * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
+ * Copyright (C) 2001-2003 Sistina Software (UK) Limited.
+ * Copyright (C) 2004-2008 Red Hat GmbH
  *
  * This file is released under the GPL.
  */
@@ -169,7 +168,7 @@ struct dm_snapshot {
 	/* The on disk metadata handler */
 	struct exception_store store;
 
-	struct kcopyd_client *kcopyd_client;
+	struct dm_kcopyd_client *dm_kcopyd_client;
 
 	/* Queue of snapshot writes for ksnapd to flush */
 	struct bio_list queued_bios;
-- 
1.5.4.1
