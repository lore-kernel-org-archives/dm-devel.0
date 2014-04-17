From: Vasily Tarasov <tarasov@vasily.name>
Subject: [PATCH RFC 08/10] dm-dedup: Kconfig changes
Date: Thu, 17 Apr 2014 16:36:41 -0400
Message-ID: <535ed0de.4515e00a.677a.3a78@mx.google.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

Changes to Kconfig.

Signed-off-by: Vasily Tarasov <tarasov@vasily.name>
---
 drivers/md/Kconfig |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 95ad936..b43f163 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -421,4 +421,12 @@ config DM_SWITCH
 
 	  If unsure, say N.
 
+config DM_DEDUP
+	tristate "Deduplication target (EXPERIMENTAL)"
+	depends on BLK_DEV_DM
+	select DM_PERSISTENT_DATA
+	select CRYPTO
+	---help---
+	  This device-maper target performs data deduplication.
+
 endif # MD
-- 
1.7.1
