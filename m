From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 3/6] libmultipath: Add additional path wildcards
Date: Fri, 12 Sep 2014 12:44:49 -0500
Message-ID: <1410543892-29826-4-git-send-email-bmarzins@redhat.com>
References: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Customers have been asking if multipath can make it easier to see how various
paths in your multipath device are connected.  To help with this I've added
5 new path wildcards

%N  host WWNN
%n  target WWNN
%R  host WWPN
%r  target WWPN
%a  host adapter

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 94 insertions(+), 1 deletion(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 3c526c2..383eae4 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -10,6 +10,7 @@
 #include <unistd.h>
 #include <string.h>
 #include <errno.h>
+#include <libudev.h>
 
 #include "checkers.h"
 #include "vector.h"
@@ -44,7 +45,7 @@
  * information printing helpers
  */
 static int
-snprint_str (char * buff, size_t len, char * str)
+snprint_str (char * buff, size_t len, const char * str)
 {
 	return snprintf(buff, len, "%s", str);
 }
@@ -436,6 +437,93 @@ snprint_path_mpp (char * buff, size_t len, struct path * pp)
 }
 
 static int
+snprint_host_attr (char * buff, size_t len, struct path * pp, char *attr)
+{
+	struct udev_device *host_dev = NULL;
+	char host_id[32];
+	const char *value = NULL;
+	int ret;
+
+	if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP)
+		return snprintf(buff, len, "[undef]");
+	sprintf(host_id, "host%d", pp->sg_id.host_no);
+	host_dev = udev_device_new_from_subsystem_sysname(conf->udev, "fc_host",
+							  host_id);
+	if (!host_dev) {
+		condlog(1, "%s: No fc_host device for '%s'", pp->dev, host_id);
+		goto out;
+	}
+	value = udev_device_get_sysattr_value(host_dev, attr);
+	if (value)
+		ret = snprint_str(buff, len, value);
+	udev_device_unref(host_dev);
+out:
+	if (!value)
+		ret = snprintf(buff, len, "[unknown]");
+	return ret;
+}
+
+static int
+snprint_host_wwnn (char * buff, size_t len, struct path * pp)
+{
+	return snprint_host_attr(buff, len, pp, "node_name");
+}
+
+static int
+snprint_host_wwpn (char * buff, size_t len, struct path * pp)
+{
+	return snprint_host_attr(buff, len, pp, "port_name");
+}
+
+static int
+snprint_tgt_wwpn (char * buff, size_t len, struct path * pp)
+{
+	struct udev_device *rport_dev = NULL;
+	char rport_id[32];
+	const char *value = NULL;
+	int ret;
+
+	if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP)
+		return snprintf(buff, len, "[undef]");
+	sprintf(rport_id, "rport-%d:%d-%d",
+		pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
+	rport_dev = udev_device_new_from_subsystem_sysname(conf->udev,
+				"fc_remote_ports", rport_id);
+	if (!rport_dev) {
+		condlog(1, "%s: No fc_remote_port device for '%s'", pp->dev,
+			rport_id);
+		goto out;
+	}
+	value = udev_device_get_sysattr_value(rport_dev, "port_name");
+	if (value)
+		ret = snprint_str(buff, len, value);
+	udev_device_unref(rport_dev);
+out:
+	if (!value)
+		ret = snprintf(buff, len, "[unknown]");
+	return ret;
+}
+
+
+static int
+snprint_tgt_wwnn (char * buff, size_t len, struct path * pp)
+{
+	if (pp->tgt_node_name[0] == '\0')
+		return snprintf(buff, len, "[undef]");
+	return snprint_str(buff, len, pp->tgt_node_name);
+}
+
+static int
+snprint_host_adapter (char * buff, size_t len, struct path * pp)
+{
+	char adapter[SLOT_NAME_SIZE];
+
+	if (sysfs_get_host_adapter_name(pp, adapter))
+		return snprintf(buff, len, "[undef]");
+	return snprint_str(buff, len, adapter);
+}
+
+static int
 snprint_path_checker (char * buff, size_t len, struct path * pp)
 {
 	struct checker * c = &pp->checker;
@@ -479,6 +567,11 @@ struct path_data pd[] = {
 	{'S', "size",          0, snprint_path_size},
 	{'z', "serial",        0, snprint_path_serial},
 	{'m', "multipath",     0, snprint_path_mpp},
+	{'N', "host WWNN",     0, snprint_host_wwnn},
+	{'n', "target WWNN",   0, snprint_tgt_wwnn},
+	{'R', "host WWPN",     0, snprint_host_wwpn},
+	{'r', "target WWPN",   0, snprint_tgt_wwpn},
+	{'a', "host adapter",  0, snprint_host_adapter},
 	{0, NULL, 0 , NULL}
 };
 
-- 
1.8.3.1
