From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/26] libmultipath: use 'checkint' as argument
	for sysfs_set_scsi_tmo()
Date: Mon, 20 Jun 2016 10:09:02 +0200
Message-ID: <1466410153-23896-16-git-send-email-hare@suse.de>
References: <1466410153-23896-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466410153-23896-1-git-send-email-hare@suse.de>
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
 libmultipath/configure.c | 2 +-
 libmultipath/discovery.c | 4 ++--
 libmultipath/discovery.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 9be74fa..a0ea2fe 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -294,7 +294,7 @@ setup_map (struct multipath * mpp, char * params, int params_size)
 	select_delay_watch_checks(mpp);
 	select_delay_wait_checks(mpp);
 
-	sysfs_set_scsi_tmo(mpp);
+	sysfs_set_scsi_tmo(mpp, conf->checkint);
 	/*
 	 * assign paths to path groups -- start with no groups and all paths
 	 * in mpp->paths
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d850aba..0bf1bc2 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -661,14 +661,14 @@ sysfs_set_nexus_loss_tmo(struct multipath *mpp, struct path *pp)
 }
 
 int
-sysfs_set_scsi_tmo (struct multipath *mpp)
+sysfs_set_scsi_tmo (struct multipath *mpp, int checkint)
 {
 	struct path *pp;
 	int i;
 	int dev_loss_tmo = mpp->dev_loss;
 
 	if (mpp->no_path_retry > 0) {
-		uint64_t no_path_retry_tmo = mpp->no_path_retry * conf->checkint;
+		uint64_t no_path_retry_tmo = mpp->no_path_retry * checkint;
 
 		if (no_path_retry_tmo > MAX_DEV_LOSS_TMO)
 			no_path_retry_tmo = MAX_DEV_LOSS_TMO;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 5931bc6..45c8a4a 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -41,7 +41,7 @@ int alloc_path_with_pathinfo (vector hwtable, struct udev_device *udevice,
 int store_pathinfo (vector pathvec, vector hwtable,
 		    struct udev_device *udevice, int flag,
 		    struct path **pp_ptr);
-int sysfs_set_scsi_tmo (struct multipath *mpp);
+int sysfs_set_scsi_tmo (struct multipath *mpp, int checkint);
 int sysfs_get_timeout(struct path *pp, unsigned int *timeout);
 int sysfs_get_host_pci_name(struct path *pp, char *pci_name);
 int sysfs_get_iscsi_ip_address(struct path *pp, char *ip_address);
-- 
2.6.6
