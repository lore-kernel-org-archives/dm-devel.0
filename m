From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/6] libmultipath: Implement
	sysfs_set_fc_rport_state()
Date: Thu, 14 Mar 2013 15:08:47 +0100
Message-ID: <1363270128-20900-6-git-send-email-hare@suse.de>
References: <1363270128-20900-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1363270128-20900-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

In a faulty fabric FC HBAs might not be able to update the status
of the remote ports, resulting in I/O to be stuck as the normal
'fast_io_fail' mechanism it never invoked.

To handle these cases I've implemented a function
sysfs_set_fc_rport_state() which allows multipath to
forcibly set the rport state to 'blocked', causing the
fast_io_fail mechanism to be invoked, which eventually
will abort all stuck I/O.

This patch relies on the patch
scsi_transport_fc: Make 'port_state' writeable
posted to linux-scsi.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/discovery.h |    1 +
 2 files changed, 61 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 58ce533..3b60125 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -476,6 +476,66 @@ sysfs_set_scsi_tmo (struct multipath *mpp)
 }
 
 int
+sysfs_set_fc_rport_state (struct path *pp, int blocked)
+{
+	struct udev_device *rport_dev = NULL;
+	char rport_id[32];
+	char value[NAME_SIZE];
+	int retval = 0;
+
+	if (pp->bus != SYSFS_BUS_SCSI) {
+		condlog(4, "%s: no FC settings on non-SCSI device", pp->dev);
+		return 0;
+	}
+
+	sprintf(rport_id, "rport-%d:%d-%d",
+		pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
+	rport_dev = udev_device_new_from_subsystem_sysname(conf->udev,
+				"fc_remote_ports", rport_id);
+	if (!rport_dev) {
+		condlog(1, "%s: No fc_remote_port device for '%s'", pp->dev,
+			rport_id);
+		return 0;
+	}
+
+	if (sysfs_attr_get_value(rport_dev, "port_state",
+				 value, 16) <= 0) {
+		condlog(1, "%s: failed to read rport state from '%s'",
+			pp->dev, rport_id);
+		retval = EBADF;
+		goto out;
+	}
+	condlog(3, "%s: rport state '%s'", pp->dev, value);
+	if (blocked) {
+		/* Can only transition Online -> Blocked */
+		if (strncmp(value, "Online", 6)) {
+			retval = EAGAIN;
+			goto out;
+		}
+		sprintf(value, "Blocked");
+	} else {
+		/* Can only transition Blocked -> Online */
+		if (strncmp(value, "Blocked", 7)) {
+			retval = EAGAIN;
+			goto out;
+		}
+
+		sprintf(value, "Online");
+	}
+
+	if (sysfs_attr_set_value(rport_dev, "port_state",
+				 value, strlen(value)) <= 0) {
+		condlog(1, "%s: failed to set rport to '%s', error %d",
+			pp->dev, value, errno);
+		retval = ENXIO;
+	}
+out:
+	udev_device_unref(rport_dev);
+
+	return retval;
+}
+
+int
 do_inq(int sg_fd, int cmddt, int evpd, unsigned int pg_op,
        void *resp, int mx_resp_len)
 {
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 1a614ee..38b61dc 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -38,6 +38,7 @@ int store_pathinfo (vector pathvec, vector hwtable,
 		    struct path **pp_ptr);
 int sysfs_set_scsi_tmo (struct multipath *mpp);
 int sysfs_get_timeout(struct path *pp, unsigned int *timeout);
+int sysfs_set_fc_rport_state(struct path *pp, int blocked);
 
 /*
  * discovery bitmask
-- 
1.7.10.4
