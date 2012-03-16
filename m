From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 04/14] dm_thin: tweak a comment
Date: Fri, 16 Mar 2012 15:22:27 +0000
Message-ID: <1331911358-8848-4-git-send-email-ejt@redhat.com>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1331911358-8848-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

An extraneous 's'.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 5abcc9b..2620a13 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -72,7 +72,7 @@
  * missed out if the io covers the block. (schedule_copy).
  *
  * iv) insert the new mapping into the origin's btree
- * (process_prepared_mappings).  This act of inserting breaks some
+ * (process_prepared_mapping).  This act of inserting breaks some
  * sharing of btree nodes between the two devices.  Breaking sharing only
  * effects the btree of that specific device.  Btrees for the other
  * devices that share the block never change.  The btree for the origin
-- 
1.7.9.1
