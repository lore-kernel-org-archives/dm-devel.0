From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] multipath: add fast_io_fail and dev_loss_tmo
 config	parameters
Date: Fri, 30 Jul 2010 18:13:14 +0900
Message-ID: <4C5297AA.4070708@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040909030704080301020605"
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
To: device-mapper development <dm-devel@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Michael Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------040909030704080301020605
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

(03/23/10 11:44), Benjamin Marzinski wrote:
> This patch adds two new configuration parameters to multipath.conf,
> fast_io_fail_tmo and dev_loss_tmo which set
> 
> /sys/class/fc_remote_ports/rport-<host>:<channel>-<rport_id>/fast_io_fail_tmo and
> /sys/class/fc_remote_ports/rport-<host>:<channel>-<rport_id>/dev_loss_tmo
...

This is nice feature but the code uses scsi_id instead of rport_id:

> +sysfs_set_scsi_tmo (struct multipath *mpp)
...
> +	vector_foreach_slot(mpp->paths, pp, i) {
> +		if (safe_snprintf(attr_path, SYSFS_PATH_SIZE,
> +	        	          "/class/fc_remote_ports/rport-%d:%d-%d",
> +				  pp->sg_id.host_no, pp->sg_id.channel,
> +				  pp->sg_id.scsi_id)) {
> +			condlog(0, "attr_path '/class/fc_remote_ports/rport-%d:%d-%d' too large", pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.scsi_id);
> +			return 1;
> +		}

So it sets fast_io_fail_tmo/dev_loss_tmo for wrong rport.

For example, I have a storage with node_id 0x2000003013842bcb
connected via switch, whose node_id is 0x100000051e09ee30.
When I set 'fast_io_fail_tmo = 8' in multipath.conf,
multipath command sets the timeout like this:
  # for f in /sys/class/fc_remote_ports/rport-*/fast_io_fail_tmo; do d=$(dirname $f); echo $(basename $d):$(cat $d/node_name):$(cat $f); done
  rport-0:0-0:0x100000051e09ee30:8
  rport-0:0-1:0x100000051e09ee30:8
  rport-0:0-2:0x2000003013842bcb:off
  rport-0:0-3:0x2000003013842bcb:off
  rport-1:0-0:0x100000051e09ee30:8
  rport-1:0-1:0x100000051e09ee30:8
  rport-1:0-2:0x2000003013842bcb:off
  rport-1:0-3:0x2000003013842bcb:off
As a result, when a link is down for the storage and fast_io_fail_tmo
has passed, I/O will be still blocked.


Attached is a quick patch for this problem.

With this patch, fast_io_fail_tmo is set like this:
  rport-0:0-0:0x100000051e09ee30:8
  rport-0:0-1:0x100000051e09ee30:8
  rport-0:0-2:0x2000003013842bcb:off
  rport-0:0-3:0x2000003013842bcb:off
  rport-1:0-0:0x100000051e09ee30:8
  rport-1:0-1:0x100000051e09ee30:8
  rport-1:0-2:0x2000003013842bcb:off
  rport-1:0-3:0x2000003013842bcb:off

Others might have better idea about resolving rport_id from target.
Mike, Hannes, any comments?

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation

--------------040909030704080301020605
Content-Type: text/x-patch;
 name="multipath-find-rport.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="multipath-find-rport.patch"

rport_id != scsi_id

multipath should find rport_id from the target_id.

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 122eb8f..c371b47 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -10,6 +10,7 @@
 #include <sys/stat.h>
 #include <dirent.h>
 #include <errno.h>
+#include <libgen.h>
 
 #include "checkers.h"
 #include "vector.h"
@@ -204,6 +205,41 @@ sysfs_get_fc_nodename (struct sysfs_device * dev, char * node,
 	return 1;
 }
 
+static int
+find_rport_id(struct path *pp)
+{
+	char attr_path[SYSFS_PATH_SIZE];
+	char *dir, *base;
+	int host, channel, rport_id = -1;
+
+	if (safe_sprintf(attr_path,
+			 "/class/fc_transport/target%i:%i:%i",
+			 pp->sg_id.host_no, pp->sg_id.channel,
+			 pp->sg_id.scsi_id)) {
+		condlog(0, "attr_path too small for target");
+		return 1;
+	}
+
+	if (sysfs_resolve_link(attr_path, SYSFS_PATH_SIZE))
+		return -1;
+
+	condlog(4, "target%d:%d:%d -> path %s", pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.scsi_id, attr_path);
+	dir = attr_path;
+	do {
+		base = basename(dir);
+		dir = dirname(dir);
+
+		if (sscanf((const char *)base, "rport-%d:%d-%d", &host, &channel, &rport_id) == 3)
+			break;
+	} while (strcmp((const char *)dir, "/"));
+
+	if (rport_id < 0)
+		return -1;
+
+	condlog(4, "target%d:%d:%d -> rport_id %d", pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.scsi_id, rport_id);
+	return rport_id;
+}
+
 int
 sysfs_set_scsi_tmo (struct multipath *mpp)
 {
@@ -211,15 +247,22 @@ sysfs_set_scsi_tmo (struct multipath *mpp)
 	struct path *pp;
 	int i;
 	char value[11];
+	int rport_id;
 
 	if (!mpp->dev_loss && !mpp->fast_io_fail)
 		return 0;
 	vector_foreach_slot(mpp->paths, pp, i) {
+		rport_id = find_rport_id(pp);
+		if (rport_id < 0) {
+			condlog(0, "failed to find rport_id for target%d:%d:%d", pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.scsi_id);
+			return 1;
+		}
+
 		if (safe_snprintf(attr_path, SYSFS_PATH_SIZE,
 				  "/class/fc_remote_ports/rport-%d:%d-%d",
 				  pp->sg_id.host_no, pp->sg_id.channel,
-				  pp->sg_id.scsi_id)) {
-			condlog(0, "attr_path '/class/fc_remote_ports/rport-%d:%d-%d' too large", pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.scsi_id);
+				  rport_id)) {
+			condlog(0, "attr_path '/class/fc_remote_ports/rport-%d:%d-%d' too large", pp->sg_id.host_no, pp->sg_id.channel, rport_id);
 			return 1;
 		}
 		if (mpp->dev_loss){

--------------040909030704080301020605
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------040909030704080301020605--
