From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 01/11] Unlock the superblock on an error path for
	new metadata dev creation.
Date: Thu,  2 Feb 2012 16:39:04 +0000
Message-ID: <1328200754-13642-2-git-send-email-ejt@redhat.com>
References: <1328200754-13642-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1328200754-13642-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

---
 drivers/md/dm-thin-metadata.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 59c4f04..6741732 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -385,6 +385,7 @@ static int init_pmd(struct dm_pool_metadata *pmd,
 		data_sm = dm_sm_disk_create(tm, nr_blocks);
 		if (IS_ERR(data_sm)) {
 			DMERR("sm_disk_create failed");
+			dm_tm_unlock(tm, sblock);
 			r = PTR_ERR(data_sm);
 			goto bad;
 		}
-- 
1.7.5.4
