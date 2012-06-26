From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM RAID: Remove duplicate code.
Date: Tue, 26 Jun 2012 03:55:41 -0500
Message-ID: <1340700941.19015.25.camel@f16>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

dm-raid: Remove duplicate code.

Code must have gotten pasted in twice somehow.  Remove redundant chunk.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -526,11 +526,6 @@ static int parse_raid_params(struct raid
 	else
 		rs->ti->split_io = region_size;
 
-	if (rs->md.chunk_sectors)
-		rs->ti->split_io = rs->md.chunk_sectors;
-	else
-		rs->ti->split_io = region_size;
-
 	/* Assume there are no metadata devices until the drives are parsed */
 	rs->md.persistent = 0;
 	rs->md.external = 1;
