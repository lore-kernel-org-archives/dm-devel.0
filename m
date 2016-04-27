From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/57] Allow for empty SCSI revision
Date: Wed, 27 Apr 2016 13:10:09 +0200
Message-ID: <1461755458-29225-9-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Some (broken) SCSI devices return an empty SCSI revision, but
this doesn't indicate a broken device. So allow for an empty
revision string when discover devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index bd65354..446c91e 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1095,7 +1095,7 @@ scsi_sysfs_pathinfo (struct path * pp)
 
 	condlog(3, "%s: product = %s", pp->dev, pp->product_id);
 
-	if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE) <= 0)
+	if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE) < 0)
 		return 1;
 
 	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
-- 
2.6.6
