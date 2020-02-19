From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 2/5] libmultipath: turn pp->vpd_data into a
	pointer
Date: Wed, 19 Feb 2020 14:21:42 -0600
Message-ID: <1582143705-20886-3-git-send-email-bmarzins@redhat.com>
References: <1582143705-20886-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582143705-20886-1-git-send-email-bmarzins@redhat.com>
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

Instead of always allocating space in the path structure for vpd_data,
only allocte it when necessary.

Also, fix comments on vpd tests

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 17 +++++++++++++++--
 libmultipath/print.c     |  4 ++--
 libmultipath/structs.c   |  3 +++
 libmultipath/structs.h   |  2 +-
 tests/vpd.c              |  3 ++-
 5 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 23a7889c..ee3290cd 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1649,8 +1649,21 @@ scsi_ioctl_pathinfo (struct path * pp, int mask)
 	select_vpd_vendor_id(pp);
 	vpd_id = pp->vpd_vendor_id;
 
-	if (vpd_id != VPD_VP_UNDEF && get_vpd_sgio(pp->fd, vpd_vendor_pages[vpd_id].pg, vpd_id, pp->vpd_data, sizeof(pp->vpd_data)) < 0)
-		condlog(3, "%s: failed to get extra vpd data", pp->dev);
+	if (vpd_id != VPD_VP_UNDEF) {
+		char vpd_data[VPD_DATA_SIZE] = {0};
+
+		if (get_vpd_sgio(pp->fd, vpd_vendor_pages[vpd_id].pg, vpd_id,
+		    vpd_data, sizeof(vpd_data)) < 0)
+			condlog(3, "%s: failed to get extra vpd data", pp->dev);
+		else {
+			vpd_data[VPD_DATA_SIZE - 1] = '\0';
+			if (pp->vpd_data)
+				free(pp->vpd_data);
+			pp->vpd_data = strdup(vpd_data);
+			if (!pp->vpd_data)
+				condlog(0, "%s: failed to allocate space for vpd data", pp->dev);
+		}
+	}
 
 	parent = pp->udev;
 	while (parent) {
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 56f86b2f..b944ef32 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -371,7 +371,7 @@ snprint_multipath_vpd_data(char * buff, size_t len,
 
 	vector_foreach_slot(mpp->pg, pgp, i)
 		vector_foreach_slot(pgp->paths, pp, j)
-			if (strlen(pp->vpd_data))
+			if (pp->vpd_data)
 				return snprintf(buff, len, "%s", pp->vpd_data);
 	return snprintf(buff, len, "[undef]");
 }
@@ -710,7 +710,7 @@ snprint_path_marginal(char * buff, size_t len, const struct path * pp)
 static int
 snprint_path_vpd_data(char * buff, size_t len, const struct path * pp)
 {
-	if (strlen(pp->vpd_data) > 0)
+	if (pp->vpd_data)
 		return snprintf(buff, len, "%s", pp->vpd_data);
 	return snprintf(buff, len, "[undef]");
 }
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index cc931e4e..2dd378c4 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -131,6 +131,9 @@ free_path (struct path * pp)
 		udev_device_unref(pp->udev);
 		pp->udev = NULL;
 	}
+	if (pp->vpd_data)
+		free(pp->vpd_data);
+
 	vector_free(pp->hwe);
 
 	FREE(pp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index b7a01220..9bd39eb1 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -269,7 +269,7 @@ struct path {
 	char rev[PATH_REV_SIZE];
 	char serial[SERIAL_SIZE];
 	char tgt_node_name[NODE_NAME_SIZE];
-	char vpd_data[VPD_DATA_SIZE];
+	char *vpd_data;
 	unsigned long long size;
 	unsigned int checkint;
 	unsigned int tick;
diff --git a/tests/vpd.c b/tests/vpd.c
index 0331c487..3cbad811 100644
--- a/tests/vpd.c
+++ b/tests/vpd.c
@@ -520,8 +520,9 @@ static void test_vpd_eui_ ## len ## _ ## wlen ## _ ## sml(void **state)	\
 	n = create_vpd83(vt->vpdbuf, sizeof(vt->vpdbuf), test_id,	\
 			 2, 0, len);					\
 	if (sml) {							\
-		/* overwrite the page side to DEFAULT_SGIO_LEN + 1 */	\
+		/* overwrite the page size to DEFAULT_SGIO_LEN + 1 */	\
 		put_unaligned_be16(255, vt->vpdbuf + 2);		\
+		/* this causes get_vpd_sgio to do a second ioctl */	\
 		will_return(__wrap_ioctl, n);				\
 		will_return(__wrap_ioctl, vt->vpdbuf);			\
 	}								\
-- 
2.17.2
