From: mwilck@suse.com
Subject: [PATCH 36/39] libmultipath: add macro DEV_LOSS_TMO_UNSET
Date: Thu,  9 Jul 2020 12:19:49 +0200
Message-ID: <20200709101952.7285-2-mwilck@suse.com>
References: <20200709101952.7285-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101952.7285-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

The special value 0 means "unset" for dev_loss. Make this more
explicit by using a macro.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/defaults.h  |  1 +
 libmultipath/dict.c      |  4 ++--
 libmultipath/discovery.c | 12 +++++++-----
 libmultipath/propsel.c   |  2 +-
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 0574e8f..39a5e41 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -58,6 +58,7 @@
 #define CHECKINT_UNDEF		UINT_MAX
 #define DEFAULT_CHECKINT	5
 
+#define DEV_LOSS_TMO_UNSET	0U
 #define MAX_DEV_LOSS_TMO	UINT_MAX
 #define DEFAULT_PIDFILE		"/" RUN_DIR "/multipathd.pid"
 #define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 0e9ea38..be3029c 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -873,7 +873,7 @@ set_dev_loss(vector strvec, void *ptr)
 	if (!strcmp(buff, "infinity"))
 		*uint_ptr = MAX_DEV_LOSS_TMO;
 	else if (sscanf(buff, "%u", uint_ptr) != 1)
-		*uint_ptr = 0;
+		*uint_ptr = DEV_LOSS_TMO_UNSET;
 
 	FREE(buff);
 	return 0;
@@ -882,7 +882,7 @@ set_dev_loss(vector strvec, void *ptr)
 int
 print_dev_loss(char * buff, int len, unsigned long v)
 {
-	if (!v)
+	if (v == DEV_LOSS_TMO_UNSET)
 		return 0;
 	if (v >= MAX_DEV_LOSS_TMO)
 		return snprintf(buff, len, "\"infinity\"");
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 81a3fad..f7d6672 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -671,7 +671,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 					rport_id, value, -ret);
 		}
 	}
-	if (mpp->dev_loss > 0) {
+	if (mpp->dev_loss != DEV_LOSS_TMO_UNSET) {
 		snprintf(value, 16, "%u", mpp->dev_loss);
 		ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
 					   value, strlen(value));
@@ -705,7 +705,7 @@ sysfs_set_session_tmo(struct multipath *mpp, struct path *pp)
 	condlog(4, "target%d:%d:%d -> %s", pp->sg_id.host_no,
 		pp->sg_id.channel, pp->sg_id.scsi_id, session_id);
 
-	if (mpp->dev_loss) {
+	if (mpp->dev_loss != DEV_LOSS_TMO_UNSET) {
 		condlog(3, "%s: ignoring dev_loss_tmo on iSCSI", pp->dev);
 	}
 	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
@@ -747,7 +747,7 @@ sysfs_set_nexus_loss_tmo(struct multipath *mpp, struct path *pp)
 	condlog(4, "target%d:%d:%d -> %s", pp->sg_id.host_no,
 		pp->sg_id.channel, pp->sg_id.scsi_id, end_dev_id);
 
-	if (mpp->dev_loss) {
+	if (mpp->dev_loss != DEV_LOSS_TMO_UNSET) {
 		snprintf(value, 11, "%u", mpp->dev_loss);
 		if (sysfs_attr_set_value(sas_dev, "I_T_nexus_loss_timeout",
 					 value, strlen(value)) <= 0)
@@ -782,13 +782,15 @@ sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint)
 			mpp->alias, dev_loss_tmo);
 	}
 	mpp->dev_loss = dev_loss_tmo;
-	if (mpp->dev_loss && mpp->fast_io_fail > 0 &&
+	if (mpp->dev_loss != DEV_LOSS_TMO_UNSET &&
+	    mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET &&
 	    (unsigned int)mpp->fast_io_fail >= mpp->dev_loss) {
 		condlog(3, "%s: turning off fast_io_fail (%d is not smaller than dev_loss_tmo)",
 			mpp->alias, mpp->fast_io_fail);
 		mpp->fast_io_fail = MP_FAST_IO_FAIL_OFF;
 	}
-	if (!mpp->dev_loss && mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
+	if (mpp->dev_loss == DEV_LOSS_TMO_UNSET &&
+	    mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
 		return 0;
 
 	vector_foreach_slot(mpp->paths, pp, i) {
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 2233527..555bd96 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -766,7 +766,7 @@ int select_dev_loss(struct config *conf, struct multipath *mp)
 	mp_set_ovr(dev_loss);
 	mp_set_hwe(dev_loss);
 	mp_set_conf(dev_loss);
-	mp->dev_loss = 0;
+	mp->dev_loss = DEV_LOSS_TMO_UNSET;
 	return 0;
 out:
 	print_dev_loss(buff, 12, mp->dev_loss);
-- 
2.26.2
