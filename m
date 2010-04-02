From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 6/7] move individual dm_multisnap 'flags' values
Date: Fri,  2 Apr 2010 01:17:57 -0400
Message-ID: <1270185478-8870-7-git-send-email-snitzer@redhat.com>
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

Moved the definitions of DM_MULTISNAP_SYNC_SNAPSHOTS and
DM_MULTISNAP_PRESERVE_ON_ERROR outside of 'struct dm_multisnap'
---
 drivers/md/dm-multisnap-private.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-multisnap-private.h b/drivers/md/dm-multisnap-private.h
index 935ddc1..f27e42a 100644
--- a/drivers/md/dm-multisnap-private.h
+++ b/drivers/md/dm-multisnap-private.h
@@ -39,6 +39,10 @@ struct dm_multisnap_bio_queue {
 
 #define DM_MULTISNAP_N_QUEUES	2
 
+/* multisnap flags which get set by multisnap_origin_ctr() */
+#define DM_MULTISNAP_SYNC_SNAPSHOTS		1
+#define DM_MULTISNAP_PRESERVE_ON_ERROR		2
+
 struct dm_multisnap {
 	struct dm_multisnap_exception_store *store;
 	struct dm_exception_store *ps;
@@ -52,9 +56,6 @@ struct dm_multisnap {
 	unsigned char chunk_shift;
 
 	unsigned char flags;
-	/* FIXME these flags should be defined outside the struct, like agk fixed for merge */
-#define DM_MULTISNAP_SYNC_SNAPSHOTS		1
-#define DM_MULTISNAP_PRESERVE_ON_ERROR		2
 
 	sector_t origin_sectors;
 
-- 
1.6.6.1
