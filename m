From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 68/78] libmultipath: unset 'uid_attribute' on
	failure
Date: Mon, 16 Mar 2015 13:36:55 +0100
Message-ID: <1426509425-15978-69-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

Due to a race condition within udev the 'uid_attribute'
might not always be set. So we should be zeroing the
'uid_attribute' when retrieving the uid by other means,
otherwise the discovery process will blacklist the device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d5dda2c..8e6b228 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1497,13 +1497,17 @@ get_uid (struct path * pp)
 		}
 		if (len <= 0) {
 			len = get_vpd_uid(pp);
-			if (len > 0)
+			if (len > 0) {
 				origin = "sysfs";
+				pp->uid_attribute = NULL;
+			}
 		}
 		if (len <= 0) {
 			len = get_udev_uid(pp, DEFAULT_UID_ATTRIBUTE);
-			if (len > 0)
-				origin = "udev";
+			if (len > 0) {
+				origin = "default";
+				pp->uid_attribute = DEFAULT_UID_ATTRIBUTE;
+			}
 		}
 	}
 	if ( len < 0 ) {
-- 
1.8.4.5
