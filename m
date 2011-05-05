From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Return PATH_UP for non-SCSI devices in
	path_offline()
Date: Thu, 05 May 2011 09:29:31 +0200
Message-ID: <201105050729.p457TV6N029923@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


path_offline() only makes sense for SCSI devices, as non
of the other types can detect the path state.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index aa25cc4..a93f08c 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -706,6 +706,10 @@ path_offline (struct path * pp)
 	struct sysfs_device * parent;
 	char buff[SCSI_STATE_SIZE];
 
+	if (pp->bus != SYSFS_BUS_SCSI)
+		/* No information for non-SCSI devices, return UP */
+		return PATH_UP;
+
 	pp->sysdev = sysfs_device_from_path(pp);
 	if (!pp->sysdev) {
 		condlog(1, "%s: failed to get sysfs information", pp->dev);
