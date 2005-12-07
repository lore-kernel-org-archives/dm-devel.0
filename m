From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] S/390 DASD support for multipath-tools
Date: Wed, 07 Dec 2005 14:52:52 +0100
Message-ID: <4396E934.2020306@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030603050006080001020707"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------030603050006080001020707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

this patch adds S/390 DASD support for multipath-tools.
As the DASD do have their own type of multipathing (called PAV there)
I don't see why multipath-tools shouldn't support it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------030603050006080001020707
Content-Type: text/x-patch;
 name="multipath-tools-dasd-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-dasd-support.patch"

Add support for S/390 DASD

On newer zSeries hardware the default disks (called DASDs) have a
multipath feature built-in (aka PAV for Parallel Access Volumes).
This patch enables support for these disks.

Signed-off-by: Hannes Reinecke

---

 libmultipath/discovery.c |   64 +++++++++++++++++++++++++++++++++++++++++++++-
 libmultipath/hwtable.c   |    4 +++
 libmultipath/structs.h   |    3 +-
 3 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -181,6 +181,8 @@ sysfs_get_##fname (char * sysfs_path, ch
 	return 0; \
 }
 
+declare_sysfs_get_str(devtype, "%s/block/%s/device/devtype");
+declare_sysfs_get_str(cutype, "%s/block/%s/device/cutype");
 declare_sysfs_get_str(vendor, "%s/block/%s/device/vendor");
 declare_sysfs_get_str(model, "%s/block/%s/device/model");
 declare_sysfs_get_str(rev, "%s/block/%s/device/rev");
@@ -392,6 +394,8 @@ sysfs_get_bus (char * sysfs_path, struct
 		curpath->bus = SYSFS_BUS_SCSI;
 	else if (!strncmp(sdev->bus, "ide", 3))
 		curpath->bus = SYSFS_BUS_IDE;
+	else if (!strncmp(sdev->bus, "ccw", 3))
+		curpath->bus = SYSFS_BUS_CCW;
 	else
 		return 1;
 
@@ -469,6 +473,59 @@ scsi_sysfs_pathinfo (struct path * curpa
 }
 
 static int
+ccw_sysfs_pathinfo (struct path * curpath)
+{
+	char attr_path[FILE_NAME_SIZE];
+	char attr_buff[FILE_NAME_SIZE];
+
+	sprintf(curpath->vendor_id, "IBM");
+
+	condlog(3, "vendor = %s", curpath->vendor_id);
+
+	if (sysfs_get_devtype(sysfs_path, curpath->dev,
+			      attr_buff, FILE_NAME_SIZE))
+		return 1;
+
+	if (!strncmp(attr_buff, "3370", 4)) {
+		sprintf(curpath->product_id,"S/390 DASD FBA");
+	} else if (!strncmp(attr_buff, "9336", 4)) {
+		sprintf(curpath->product_id,"S/390 DASD FBA");
+	} else {
+		sprintf(curpath->product_id,"S/390 DASD ECKD");
+	}
+
+	condlog(3, "product = %s", curpath->product_id);
+
+	/*
+	 * host / bus / target / lun
+	 */
+	if(safe_sprintf(attr_path, "%s/block/%s/device",
+			sysfs_path, curpath->dev)) {
+		condlog(0, "attr_path too small");
+		return 1;
+	}
+	if (0 > sysfs_get_link(attr_path, attr_buff, sizeof(attr_buff)))
+		return 1;
+	
+	basename(attr_buff, attr_path);
+
+	condlog(3, "device path %s", attr_path);
+
+	curpath->sg_id.lun = 0;
+	sscanf(attr_path, "%i.%i.%x",
+			&curpath->sg_id.host_no,
+			&curpath->sg_id.channel,
+			&curpath->sg_id.scsi_id);
+	condlog(3, "h:b:t:l = %i:%i:%i:%i",
+			curpath->sg_id.host_no,
+			curpath->sg_id.channel,
+			curpath->sg_id.scsi_id,
+			curpath->sg_id.lun);
+
+	return 0;
+}
+
+static int
 common_sysfs_pathinfo (struct path * curpath)
 {
 	if (sysfs_get_bus(sysfs_path, curpath))
@@ -498,10 +555,13 @@ sysfs_pathinfo(struct path * curpath)
 
 	if (curpath->bus == SYSFS_BUS_UNDEF)
 		return 0;
-	else if (curpath->bus == SYSFS_BUS_SCSI)
+	else if (curpath->bus == SYSFS_BUS_SCSI) {
 		if (scsi_sysfs_pathinfo(curpath))
 			return 1;
-
+	} else if (curpath->bus == SYSFS_BUS_CCW) {
+		if (ccw_sysfs_pathinfo(curpath))
+			return 1;
+	}
 	return 0;
 }
 
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -53,6 +53,10 @@ setup_default_hwtable (vector hw)
 	/* IBM SAN Volume Controller */
 	r += store_hwe_ext(hw, "IBM", "2145", MULTIBUS, DEFAULT_GETUID,
 		   NULL, "0", "1 queue_if_no_path", "tur", FAILBACK_UNDEF);
+	/* IBM S/390 ECKD DASD */
+	r += store_hwe_ext(hw, "IBM", "S/390 DASD ECKD", MULTIBUS,
+		   "/sbin/dasdview -j /dev/%n", NULL, "0", "0",
+		   "directio", FAILBACK_UNDEF);
 	r += store_hwe_ext(hw, "NETAPP", "LUN", GROUP_BY_PRIO, DEFAULT_GETUID,
 		  "/sbin/mpath_prio_netapp /dev/%n", NULL,
 		  "1 queue_if_no_path", "readsector0", FAILBACK_UNDEF);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -38,7 +38,8 @@ enum failback_mode {
 enum sysfs_buses {
 	SYSFS_BUS_UNDEF,
 	SYSFS_BUS_SCSI,
-	SYSFS_BUS_IDE
+	SYSFS_BUS_IDE,
+	SYSFS_BUS_CCW
 };
 
 enum pathstates {

--------------030603050006080001020707
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030603050006080001020707--
