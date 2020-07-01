From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 1/4] libmultipath: fix sysfs dev_loss_tmo parsing
Date: Wed,  1 Jul 2020 17:39:33 -0500
Message-ID: <1593643176-6206-2-git-send-email-bmarzins@redhat.com>
References: <1593643176-6206-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593643176-6206-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

dev_loss_tmo is a u32 value. However the kernel sysfs code prints it as
a signed integer. This means that if dev_loss_tmo is above INT_MAX, the
sysfs value will be a negative number. Parsing this was causing
sysfs_set_rport_tmo() to fail.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index ffec5162..6a45979a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -583,7 +583,8 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	struct udev_device *rport_dev = NULL;
 	char value[16], *eptr;
 	char rport_id[32];
-	unsigned long long tmo = 0;
+	long long ll_tmo;
+	unsigned int tmo = 0;
 	int ret;
 
 	sprintf(rport_id, "rport-%d:%d-%d",
@@ -607,13 +608,13 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 			"error %d", rport_id, -ret);
 		goto out;
 	}
-	tmo = strtoull(value, &eptr, 0);
-	if (value == eptr || tmo == ULLONG_MAX) {
+	ll_tmo = strtoll(value, &eptr, 0);
+	if (value == eptr || ll_tmo > UINT_MAX || ll_tmo < INT_MIN) {
 		condlog(0, "%s: Cannot parse dev_loss_tmo "
 			"attribute '%s'", rport_id, value);
 		goto out;
 	}
-
+	tmo = (unsigned int)ll_tmo;
 	/*
 	 * This is tricky.
 	 * dev_loss_tmo will be limited to 600 if fast_io_fail
-- 
2.17.2
