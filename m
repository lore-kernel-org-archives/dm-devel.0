From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/26] discovery: Pass in 'hwtable' for
	get_state() and scsi_sysfs_discovery()
Date: Mon,  4 Jul 2016 09:08:36 +0200
Message-ID: <1467616126-10036-17-git-send-email-hare@suse.de>
References: <1467616126-10036-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467616126-10036-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c | 28 ++++++++++++++--------------
 libmultipath/discovery.h |  2 +-
 multipathd/main.c        |  2 +-
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 0bf1bc2..e598337 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1067,7 +1067,7 @@ get_vpd_sgio (int fd, int pg, char * str, int maxlen)
 }
 
 static int
-scsi_sysfs_pathinfo (struct path * pp)
+scsi_sysfs_pathinfo (struct path * pp, vector hwtable)
 {
 	struct udev_device *parent;
 	const char *attr_path = NULL;
@@ -1109,7 +1109,7 @@ scsi_sysfs_pathinfo (struct path * pp)
 	/*
 	 * set the hwe configlet pointer
 	 */
-	pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id, pp->rev);
+	pp->hwe = find_hwe(hwtable, pp->vendor_id, pp->product_id, pp->rev);
 
 	/*
 	 * host / bus / target / lun
@@ -1134,7 +1134,7 @@ scsi_sysfs_pathinfo (struct path * pp)
 }
 
 static int
-ccw_sysfs_pathinfo (struct path * pp)
+ccw_sysfs_pathinfo (struct path * pp, vector hwtable)
 {
 	struct udev_device *parent;
 	char attr_buff[NAME_SIZE];
@@ -1170,7 +1170,7 @@ ccw_sysfs_pathinfo (struct path * pp)
 	/*
 	 * set the hwe configlet pointer
 	 */
-	pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id, NULL);
+	pp->hwe = find_hwe(hwtable, pp->vendor_id, pp->product_id, NULL);
 
 	/*
 	 * host / bus / target / lun
@@ -1193,7 +1193,7 @@ ccw_sysfs_pathinfo (struct path * pp)
 }
 
 static int
-cciss_sysfs_pathinfo (struct path * pp)
+cciss_sysfs_pathinfo (struct path * pp, vector hwtable)
 {
 	const char * attr_path = NULL;
 	struct udev_device *parent;
@@ -1233,7 +1233,7 @@ cciss_sysfs_pathinfo (struct path * pp)
 	/*
 	 * set the hwe configlet pointer
 	 */
-	pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id, pp->rev);
+	pp->hwe = find_hwe(hwtable, pp->vendor_id, pp->product_id, pp->rev);
 
 	/*
 	 * host / bus / target / lun
@@ -1323,7 +1323,7 @@ path_offline (struct path * pp)
 }
 
 int
-sysfs_pathinfo(struct path * pp)
+sysfs_pathinfo(struct path * pp, vector hwtable)
 {
 	if (common_sysfs_pathinfo(pp))
 		return 1;
@@ -1339,13 +1339,13 @@ sysfs_pathinfo(struct path * pp)
 	if (pp->bus == SYSFS_BUS_UNDEF)
 		return 0;
 	else if (pp->bus == SYSFS_BUS_SCSI) {
-		if (scsi_sysfs_pathinfo(pp))
+		if (scsi_sysfs_pathinfo(pp, hwtable))
 			return 1;
 	} else if (pp->bus == SYSFS_BUS_CCW) {
-		if (ccw_sysfs_pathinfo(pp))
+		if (ccw_sysfs_pathinfo(pp, hwtable))
 			return 1;
 	} else if (pp->bus == SYSFS_BUS_CCISS) {
-		if (cciss_sysfs_pathinfo(pp))
+		if (cciss_sysfs_pathinfo(pp, hwtable))
 			return 1;
 	}
 	return 0;
@@ -1397,7 +1397,7 @@ cciss_ioctl_pathinfo (struct path * pp, int mask)
 }
 
 int
-get_state (struct path * pp, int daemon)
+get_state (struct path * pp, vector hwtable, int daemon)
 {
 	struct checker * c = &pp->checker;
 	int state;
@@ -1406,7 +1406,7 @@ get_state (struct path * pp, int daemon)
 
 	if (!checker_selected(c)) {
 		if (daemon) {
-			if (pathinfo(pp, conf->hwtable, DI_SYSFS) != PATHINFO_OK) {
+			if (pathinfo(pp, hwtable, DI_SYSFS) != PATHINFO_OK) {
 				condlog(3, "%s: couldn't get sysfs pathinfo",
 					pp->dev);
 				return PATH_UNCHECKED;
@@ -1610,7 +1610,7 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	/*
 	 * fetch info available in sysfs
 	 */
-	if (mask & DI_SYSFS && sysfs_pathinfo(pp))
+	if (mask & DI_SYSFS && sysfs_pathinfo(pp, hwtable))
 		return PATHINFO_FAILED;
 
 	if (mask & DI_BLACKLIST && mask & DI_SYSFS) {
@@ -1649,7 +1649,7 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 
 	if (mask & DI_CHECKER) {
 		if (path_state == PATH_UP) {
-			pp->chkrstate = pp->state = get_state(pp, 0);
+			pp->chkrstate = pp->state = get_state(pp, hwtable, 0);
 			if (pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD)
 				goto blank;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 45c8a4a..2619015 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -34,7 +34,7 @@ int path_discovery (vector pathvec, struct config * conf, int flag);
 
 int do_tur (char *);
 int path_offline (struct path *);
-int get_state (struct path * pp, int daemon);
+int get_state (struct path * pp, vector hwtable, int daemon);
 int pathinfo (struct path *, vector hwtable, int mask);
 int alloc_path_with_pathinfo (vector hwtable, struct udev_device *udevice,
 			      int flag, struct path **pp_ptr);
diff --git a/multipathd/main.c b/multipathd/main.c
index 9a44390..fe80d1a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1421,7 +1421,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		newstate = PATH_DOWN;
 
 	if (newstate == PATH_UP)
-		newstate = get_state(pp, 1);
+		newstate = get_state(pp, conf->hwtable, 1);
 	else
 		checker_clear_message(&pp->checker);
 
-- 
2.6.6
