From: Nicholas Krause <xerofoify@gmail.com>
Subject: [PATCH] drivers:md: Remove unneeded fix me comments in
	dm-bio-prison.h
Date: Sat, 27 Dec 2014 23:12:03 -0500
Message-ID: <1419739923-28799-1-git-send-email-xerofoify@gmail.com>
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

Removes two unneeded fix me comments for removing the header files,
persistent-data/dm-block-manager.h and dm-thin-metadata.h. These
headers are needed in order to build this file successfully and
for it to run,thus the comments should be removed as they are no
longer needed.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/md/dm-bio-prison.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-bio-prison.h b/drivers/md/dm-bio-prison.h
index 74cf011..15c31cf 100644
--- a/drivers/md/dm-bio-prison.h
+++ b/drivers/md/dm-bio-prison.h
@@ -7,8 +7,8 @@
 #ifndef DM_BIO_PRISON_H
 #define DM_BIO_PRISON_H
 
-#include "persistent-data/dm-block-manager.h" /* FIXME: for dm_block_t */
-#include "dm-thin-metadata.h" /* FIXME: for dm_thin_id */
+#include "persistent-data/dm-block-manager.h"
+#include "dm-thin-metadata.h"
 
 #include <linux/bio.h>
 #include <linux/rbtree.h>
-- 
2.1.0
