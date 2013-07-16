From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 30/30] libmultipath: read path state directly
	from sysfs
Date: Tue, 16 Jul 2013 09:13:21 +0200
Message-ID: <1373958801-103613-31-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The 'state' attribute of a SCSI device might change without
generating any udev events, so we need to read it directly
from sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e2b4f56..7035a43 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -168,7 +168,6 @@ declare_sysfs_get_str(cutype);
 declare_sysfs_get_str(vendor);
 declare_sysfs_get_str(model);
 declare_sysfs_get_str(rev);
-declare_sysfs_get_str(state);
 declare_sysfs_get_str(dev);
 
 int
@@ -854,7 +853,8 @@ path_offline (struct path * pp)
 		return PATH_DOWN;
 	}
 
-	if (sysfs_get_state(parent, buff, SCSI_STATE_SIZE))
+	memset(buff, 0x0, SCSI_STATE_SIZE);
+	if (sysfs_attr_get_value(parent, "state", buff, SCSI_STATE_SIZE) <= 0)
 		return PATH_DOWN;
 
 	condlog(3, "%s: path state = %s", pp->dev, buff);
-- 
1.7.12.4
