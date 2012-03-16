From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 03/14] dm_thin: dm_sm_root_size() was being
	called for the wrong space-map
Date: Fri, 16 Mar 2012 15:22:26 +0000
Message-ID: <1331911358-8848-3-git-send-email-ejt@redhat.com>
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

Fix a harmless typo.

The root is a chunk of data that gets written to the superblock.  This
data is used to recreate the space map when opening a metadata area.
We have two space maps; one tracking space on the metadata device and
one of the data device.  Both of these use the same format for their
root, so this typo was harmless.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 237571a..a680c76 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -614,7 +614,7 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
 	if (r < 0)
 		goto out;
 
-	r = dm_sm_root_size(pmd->metadata_sm, &data_len);
+	r = dm_sm_root_size(pmd->data_sm, &data_len);
 	if (r < 0)
 		goto out;
 
-- 
1.7.9.1
