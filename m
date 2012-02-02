From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 04/11] [PATCH 15/19] [dm-thin]
	dm_thin_remove_block() wasn't decrementing the mapped_blocks
	counter.
Date: Thu,  2 Feb 2012 16:39:07 +0000
Message-ID: <1328200754-13642-5-git-send-email-ejt@redhat.com>
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
 drivers/md/dm-thin-metadata.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 6741732..1aeef4e 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1212,6 +1212,8 @@ static int __remove(struct dm_thin_device *td, dm_block_t block)
 	if (r)
 		return r;
 
+	td->mapped_blocks--;
+	td->changed = 1;
 	pmd->need_commit = 1;
 
 	return 0;
-- 
1.7.5.4
