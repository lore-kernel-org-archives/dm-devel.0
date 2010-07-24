From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 11/12] dm mpath: enable discard support
Date: Sat, 24 Jul 2010 12:09:27 -0400
Message-ID: <1279987768-13275-12-git-send-email-snitzer@redhat.com>
References: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: dm-devel.ids

Enable discard support in the DM multipath target.

This discard support depends on a few discard-specific fixes to the
block layer's request stacking driver methods.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
---
 drivers/md/dm-mpath.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-block/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm-mpath.c
+++ linux-2.6-block/drivers/md/dm-mpath.c
@@ -893,6 +893,7 @@ static int multipath_ctr(struct dm_targe
 	}
 
 	ti->num_flush_requests = 1;
+	ti->num_discard_requests = 1;
 
 	return 0;
 
