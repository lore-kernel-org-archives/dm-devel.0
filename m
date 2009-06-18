From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 1] dm exception store: exstore type lookup
	should be case insensitive
Date: Thu, 18 Jun 2009 09:14:39 -0500
Message-ID: <1245334479.20278.9.camel@hydrogen.msp.redhat.com>
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

This two line patch will fix the regressions some users are experiencing
with device-mapper snapshots.

 brassow

When snapshots are created using 'p' instead of 'P' as the
exception store type, the device-mapper table loading would
fail.

This patch allows the code to be case insensitive.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.c
+++ linux-2.6/drivers/md/dm-exception-store.c
@@ -215,6 +215,7 @@ int dm_exception_store_create(struct dm_
 		ti->error = "Persistent flag is not P or N";
 		return -EINVAL;
 	}
+	*argv[1] = persistent;
 
 	type = get_type(argv[1]);
 	if (!type) {
