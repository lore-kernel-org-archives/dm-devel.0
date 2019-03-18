From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 03/10] libmultipath: alua: try to retrieve
	inquiry data from sysfs
Date: Mon, 18 Mar 2019 12:24:38 +0100
Message-ID: <20190318112445.6636-4-mwilck@suse.com>
References: <20190318112445.6636-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190318112445.6636-1-mwilck@suse.com>
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
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Steve.Schremmer@netapp.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

This can avoid IO while configuring the path prioritizer.
The alua prioritizer avoids reading from sysfs for a reason
(see commit 7e2f46d3), but this applies only to RTPG / STPG,
not to INQUIRY calls.

Cc: Steve.Schremmer@netapp.com
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prioritizers/alua_rtpg.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index d9215a88..271a019d 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -188,6 +188,23 @@ retry:
 int do_inquiry(const struct path *pp, int evpd, unsigned int codepage,
 	       void *resp, int resplen, unsigned int timeout)
 {
+	struct udev_device *ud;
+
+	ud = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi",
+							   "scsi_device");
+	if (ud != NULL) {
+		int rc;
+
+		if (!evpd)
+			rc = sysfs_get_inquiry(ud, resp, resplen);
+		else
+			rc = sysfs_get_vpd(ud, codepage, resp, resplen);
+
+		if (rc >= 0) {
+			PRINT_HEX((unsigned char *) resp, resplen);
+			return 0;
+		}
+	}
 	return do_inquiry_sg(pp->fd, evpd, codepage, resp, resplen, timeout);
 }
 
-- 
2.21.0
