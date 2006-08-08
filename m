From: egoggin@emc.com
Subject: disabling lock_fs call on DM_DEVICE_RESUME libdevmapper
	ioctl
Date: Tue, 8 Aug 2006 10:16:17 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1350@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: dm-devel@redhat.com
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

Christophe,

This patch to dm_simplecmd of multipath-tools/libmultipath/devmapper.c will
disable the use of lock_fs during I/O suspension while changing dm-multipath
device mapper maps via the DM_DEVICE_RESUME ioctl of libdevmapper.

Disabling lock_fs will result in not flushing I/O to the dm-multipath block
device before changing the maps for the mapped device.  Flushing I/O at this
time appears not only unnecessary for dm-multipath devices but causes some
troublesome delays due to SCSI HBA driver target-side timeouts when these
maps are changed as a result of paths coming and going while upgrading
software (a non-disruptive ucode upgrade) on a storage system.

As is the case for any change which is dependent on similar changes in
libdevmapper and the kernel, this patch will introduce a dependency on
libdevmapper and kernel.  Not sure which versions first had this support but
at least libdevmapper 1.02.02 and linux kernel version 2.6.18-rc2 have the
required support.

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index c0765ae..67c7740 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -105,6 +105,7 @@ dm_simplecmd (int task, const char *name
 		goto out;
 
 	dm_task_no_open_count(dmt);
+	dm_task_skip_lockfs(dmt);	/* for DM_DEVICE_RESUME */
 
 	r = dm_task_run (dmt);
 
@@ -183,6 +184,41 @@ out:
 }

Thanks,

Ed 
