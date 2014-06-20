From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: [PATCH]multipath: Wrong sysfs attribute used for iSCSI
	settings.
Date: Fri, 20 Jun 2014 22:33:39 +0000
Message-ID: <47bff49ac3c742fc86a11b013a76e985@hioexcmbx01-prd.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Wrong sysfs parameter used to configure iSCSI settings.

/sys/class/iscsi_session/session<n>/tgtname
It's always
/sys/class/iscsi_session/session<n>/targetname

This is the reason recovery_tmo was not getting set to 
fast_io_fail_tmo value for iscsi sessions.

Signed-off-by: Shiva Krishna Merla<shivakrishna.merla@netapp.com>
---
 libmultipath/discovery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 786e1de..7bb0a33 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -289,7 +289,7 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
 		if (tgtdev) {
 			const char *value;
 
-			value = udev_device_get_sysattr_value(tgtdev, "tgtname");
+			value = udev_device_get_sysattr_value(tgtdev, "targetname");
 			if (value) {
 				pp->sg_id.proto_id = SCSI_PROTOCOL_ISCSI;
 				pp->sg_id.transport_id = tgtid;
--
