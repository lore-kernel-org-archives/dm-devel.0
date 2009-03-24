From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Fix race-condition when reading sysfs attributes.
Date: Tue, 24 Mar 2009 11:24:59 -0400
Message-ID: <1237908301-2339-2-git-send-email-konrad@virtualiron.com>
References: <1237908301-2339-1-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1237908301-2339-1-git-send-email-konrad@virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This fix re-introduces a wait loop when reading sysfs attributes.
The reason a wait is necessary is due to the way the kernel
sends the event. When a SCSI device is added the SCSI subsystem
pursues this path:

_sysfs_add_sdev:
    calls device_add ...
    [ '/devices/platform/host16/session6/target16:0:0/16:0:0:17'] uevent
        bus_attach_device
            bus_for_each_drv
                driver_probe_device
                    sd_probe
                    ['/class/scsi_disk/16:0:0:17' ] uevent
                        add_disk
                        ['/block/sdai'] [ Here multipath starts its job ]

    calls class_device_add ...
        [ '/class/scsi_device/16:0:0:17' ] uevent
        sg_add:
            [ '/class/scsi_generic/sg35' ] uevent

    done with device_add, and now the kernel adds the  attributes:
    scsi_sysfs_sdev_attrs[i].vendor, model, rev

There are four uevents sent from the kernel in the creation of
a SysFS representation of the device. After the last event, the
SysFs entries for vendor,model, rev are populated. The window
time between the uevent with /block/sdX sent and the sysfs
attributes being populated is small. But it is possible (with
a slow serial link, slow SCSI target), to get us in a race
condition where multipath investigates the new block device and
finds it can't read the vendor, and the block device ends up
being discarded and never added to the device mapper multipath map.
---
 libmultipath/discovery.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 9ae2b8f..1d2c396 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -124,11 +124,49 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 	return r;
 }
 
+
+#define WAIT_MAX_SECONDS 5
+#define WAIT_LOOP_PER_SECOND 5
+
+static int
+wait_for_file (char * filename)
+{
+	int loop;
+	struct stat stats;
+	/*
+ 	* the daemon can race udev upon path add,
+ 	* not multipath(8), if ran by udev
+ 	*/
+
+	if (!conf->daemon)
+		return 0;
+
+	loop = WAIT_MAX_SECONDS * WAIT_LOOP_PER_SECOND;
+
+	while (--loop) {
+		if (stat(filename, &stats) == 0)
+			return 0;
+
+		if (errno != ENOENT)
+			return 1;
+
+		usleep(1000 * 1000 / WAIT_LOOP_PER_SECOND);
+	}
+	return 1;
+}
+
 #define declare_sysfs_get_str(fname) \
 extern int \
 sysfs_get_##fname (struct sysfs_device * dev, char * buff, size_t len) \
 { \
 	char *attr; \
+	char attr_path[SYSFS_PATH_SIZE]; \
+\
+	if (safe_sprintf(attr_path, "%s/%s/%s", sysfs_path, dev->devpath, #fname)) \
+		return 1; \
+\
+	if (wait_for_file(attr_path)) \
+		return 1; \
 \
 	attr = sysfs_attr_get_value(dev->devpath, #fname); \
 	if (!attr) \
-- 
1.5.4.1
