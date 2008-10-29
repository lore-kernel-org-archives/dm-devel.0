From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] Check region size during dirty log creation
Date: Wed, 29 Oct 2008 14:02:08 +0100
Message-ID: <1225285328.3974.5.camel@o>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

This patch adds checks to the dirty log creation for region size to be
larger than 2 sectors and to be a power of 2.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---

diff -up linux-2.6.27.4/drivers/md/dm-log.c.orig
linux-2.6.27.4/drivers/md/dm-log.c
--- linux-2.6.27.4/drivers/md/dm-log.c.log	2008-10-29 13:51:03.000000000
+0100
+++ linux-2.6.27.4/drivers/md/dm-log.c	2008-10-29 13:55:57.000000000
+0100
@@ -403,8 +403,10 @@ static int create_log_context(struct dm_
 		}
 	}
 
-	if (sscanf(argv[0], "%u", &region_size) != 1) {
-		DMWARN("invalid region size string");
+	if (sscanf(argv[0], "%u", &region_size) != 1 ||
+	    region_size < 2 ||
+	    (region_size & (region_size - 1))) {
+		DMWARN("invalid region size");
 		return -EINVAL;
 	}
 
