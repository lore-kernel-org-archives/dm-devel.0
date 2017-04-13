From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/1] libmultipath/propsel: Do not select sysfs
	prioritizer for RDAC arrays
Date: Thu, 13 Apr 2017 17:39:48 +0200
Message-ID: <20170413153948.26557-2-mwilck@suse.com>
References: <CABr-GncgE=O+XAFENX8fkg9ofa2crk27UuKVTTHKhfwku4k_ow@mail.gmail.com>
	<20170413153948.26557-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170413153948.26557-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>

Recent RDAC (NetApp E-Series) firmware implemented an internal load
balancer and switched to implicit ALUA.
Unfortunately the load balancer relies on periodic REPORT TARGET PORT
GROUPS from the host, so we cannot use the sysfs prioritizer here.

References: bsc#1004858

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c |  2 +-
 libmultipath/discovery.h |  1 +
 libmultipath/propsel.c   | 24 ++++++++++++++++++++++--
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 8c512545..663c8eaa 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1092,7 +1092,7 @@ get_vpd_sysfs (struct udev_device *parent, int pg, char * str, int maxlen)
 	return len;
 }
 
-static int
+int
 get_vpd_sgio (int fd, int pg, char * str, int maxlen)
 {
 	int len, buff_len;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 0563bfd9..51c23d6f 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -35,6 +35,7 @@ int path_discovery (vector pathvec, int flag);
 int do_tur (char *);
 int path_offline (struct path *);
 int get_state (struct path * pp, struct config * conf, int daemon);
+int get_vpd_sgio (int fd, int pg, char * str, int maxlen);
 int pathinfo (struct path * pp, struct config * conf, int mask);
 int alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 			      char *wwid, int flag, struct path **pp_ptr);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index dd10ceba..6dd8cb96 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -370,6 +370,24 @@ out:
 	return 0;
 }
 
+/*
+ * Current RDAC (NetApp E-Series) firmware relies
+ * on periodic REPORT TARGET PORT GROUPS for
+ * internal load balancing.
+ * Using the sysfs priority checker defeats this purpose.
+ */
+static int
+check_rdac(struct path * pp)
+{
+	int len;
+	char buff[44];
+
+	len = get_vpd_sgio(pp->fd, 0xC9, buff, 44);
+	if (len <= 0)
+		return 0;
+	return !(memcmp(buff + 4, "vac1", 4));
+}
+
 void
 detect_prio(struct config *conf, struct path * pp)
 {
@@ -379,8 +397,10 @@ detect_prio(struct config *conf, struct path * pp)
 
 	if (pp->tpgs <= 0)
 		return;
-	if (sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
-		default_prio = PRIO_SYSFS;
+	if (pp->tpgs == 2 && !check_rdac(pp)) {
+		if (sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
+			default_prio = PRIO_SYSFS;
+	}
 	prio_get(conf->multipath_dir, p, default_prio, DEFAULT_PRIO_ARGS);
 }
 
-- 
2.12.2
