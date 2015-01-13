From: Nicholas Krause <xerofoify@gmail.com>
Subject: [PATCH] md:Remove no longer needed fix me comment in
	dm-region-hash.c for removing the structure pointer,
	*rh from the definiton of dm_region
Date: Mon, 12 Jan 2015 22:30:23 -0500
Message-ID: <1421119823-5864-1-git-send-email-xerofoify@gmail.com>
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
To: agk@redhat.com
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

Removes the no longer needed fix me comment questioning if we need to remove
the structure pointer,rh as defined as a structure of type dsm_region_hash
from the definition of the structure, dm_region. Furthermore this  pointer is
needed in order for various functions to run and build successfully in the file,
dm-region-hash.c.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/md/dm-region-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index b929fd5..823d56f 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -99,7 +99,7 @@ struct dm_region_hash {
 };
 
 struct dm_region {
-	struct dm_region_hash *rh;	/* FIXME: can we get rid of this ? */
+	struct dm_region_hash *rh;
 	region_t key;
 	int state;
 
-- 
2.1.0
