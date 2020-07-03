From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 1/4] libmultipath: fix sysfs dev_loss_tmo
	parsing
Date: Thu,  2 Jul 2020 19:38:24 -0500
Message-ID: <1593736707-14216-2-git-send-email-bmarzins@redhat.com>
References: <1593736707-14216-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593736707-14216-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

dev_loss_tmo is a u32 value. However the kernel sysfs code prints it as
a signed integer. This means that if dev_loss_tmo is above INT_MAX, the
sysfs value will be a negative number. Parsing this was causing
sysfs_set_rport_tmo() to fail.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index ffec5162..83a41a4a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -583,7 +583,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	struct udev_device *rport_dev = NULL;
 	char value[16], *eptr;
 	char rport_id[32];
-	unsigned long long tmo = 0;
+	unsigned int tmo;
 	int ret;
 
 	sprintf(rport_id, "rport-%d:%d-%d",
@@ -607,8 +607,8 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 			"error %d", rport_id, -ret);
 		goto out;
 	}
-	tmo = strtoull(value, &eptr, 0);
-	if (value == eptr || tmo == ULLONG_MAX) {
+	tmo = strtoul(value, &eptr, 0);
+	if (value == eptr) {
 		condlog(0, "%s: Cannot parse dev_loss_tmo "
 			"attribute '%s'", rport_id, value);
 		goto out;
-- 
2.17.2
