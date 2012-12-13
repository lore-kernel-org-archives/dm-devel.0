From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 3/8] [persistent-data] tweak an error message
Date: Thu, 13 Dec 2012 20:19:11 +0000
Message-ID: <1355429956-22785-4-git-send-email-ejt@redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1355429956-22785-1-git-send-email-ejt@redhat.com>
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
 drivers/md/persistent-data/dm-space-map-metadata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index e89ae5e..906cf3d 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -337,7 +337,7 @@ static int sm_metadata_new_block(struct dm_space_map *sm, dm_block_t *b)
 {
 	int r = sm_metadata_new_block_(sm, b);
 	if (r)
-		DMERR("out of metadata space");
+		DMERR("unable to allocate new metadata block");
 	return r;
 }
 
-- 
1.7.10.4
