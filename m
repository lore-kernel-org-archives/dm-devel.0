From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 7/7] Removed remaining 'struct
	dm_exception_store' FIXMEs.
Date: Fri,  2 Apr 2010 01:17:58 -0400
Message-ID: <1270185478-8870-8-git-send-email-snitzer@redhat.com>
References: <1270185478-8870-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1270185478-8870-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Remaining FIXMEs are not particularly important at this point.
---
 drivers/md/dm-multisnap-mikulas.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-multisnap-mikulas.h b/drivers/md/dm-multisnap-mikulas.h
index fb5bf03..6091fdc 100644
--- a/drivers/md/dm-multisnap-mikulas.h
+++ b/drivers/md/dm-multisnap-mikulas.h
@@ -61,7 +61,6 @@ struct path_element {
 
 struct dm_exception_store {
 	struct dm_multisnap *s;
-	/* FIXME rename: bufio_client? */
 	struct dm_bufio_client *bufio;
 
 	chunk_t dev_size;
@@ -72,7 +71,6 @@ struct dm_exception_store {
 	__u8 bt_depth;
 	__u8 flags;
 	__u32 snapshot_num;
-	/* FIXME rename: commit_block_stride? */
 	unsigned cb_stride;
 
 	chunk_t bitmap_root;
-- 
1.6.6.1
