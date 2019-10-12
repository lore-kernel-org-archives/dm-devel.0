From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 23/72] libmultipath: scsi_ioctl_pathinfo():
 remove unused argument
Date: Sat, 12 Oct 2019 21:28:06 +0000
Message-ID: <20191012212703.12989-24-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d217ca92..4d93c91b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1571,7 +1571,7 @@ sysfs_pathinfo(struct path * pp, vector hwtable)
 }
 
 static void
-scsi_ioctl_pathinfo (struct path * pp, struct config *conf, int mask)
+scsi_ioctl_pathinfo (struct path * pp, int mask)
 {
 	struct udev_device *parent;
 	const char *attr_path = NULL;
@@ -2050,7 +2050,7 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 		get_geometry(pp);
 
 	if (path_state == PATH_UP && pp->bus == SYSFS_BUS_SCSI)
-		scsi_ioctl_pathinfo(pp, conf, mask);
+		scsi_ioctl_pathinfo(pp, mask);
 
 	if (pp->bus == SYSFS_BUS_CCISS && mask & DI_SERIAL)
 		cciss_ioctl_pathinfo(pp);
-- 
2.23.0
