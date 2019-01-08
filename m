From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 11/12] libmultipath/foreign(coverity): retval
	check in snprint_nvme_path
Date: Tue,  8 Jan 2019 23:54:08 +0100
Message-ID: <20190108225409.15977-12-mwilck@suse.com>
References: <20190108225409.15977-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190108225409.15977-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign/nvme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index f0e8293..7e654ec 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -249,8 +249,10 @@ static int snprint_nvme_path(const struct gen_path *gp,
 		devt = udev_device_get_devnum(np->udev);
 		return snprintf(buff, len, "%u:%u", major(devt), minor(devt));
 	case 'o':
-		sysfs_attr_get_value(np->ctl, "state", fld, sizeof(fld));
-		return snprintf(buff, len, "%s", fld);
+		if (sysfs_attr_get_value(np->ctl, "state",
+					 fld, sizeof(fld)) > 0)
+			return snprintf(buff, len, "%s", fld);
+		break;
 	case 'T':
 		if (sysfs_attr_get_value(np->udev, "ana_state", fld,
 					 sizeof(fld)) > 0)
-- 
2.19.2
