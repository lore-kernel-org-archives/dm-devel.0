From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 64/78] Assign local priority for NAA VPD
	descriptor
Date: Mon, 16 Mar 2015 13:36:51 +0100
Message-ID: <1426509425-15978-65-git-send-email-hare@suse.de>
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

Some devices assign several NAA VPD descriptors. So implement
an internal priority to select the 'best' NAA descriptor.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 681ee25..b1cd6a0 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -829,7 +829,7 @@ get_vpd (struct udev_device *parent, int pg, char * str, int maxlen)
 	} else if (pg == 0x83) {
 		unsigned char *d;
 		unsigned char *vpd = NULL;
-		int vpd_type, vpd_len, prio = -1, i;
+		int vpd_type, vpd_len, prio = -1, i, naa_prio;
 
 		d = (unsigned char *)buff + 4;
 		while (d < (unsigned char *)buff + buff_len) {
@@ -841,8 +841,30 @@ get_vpd (struct udev_device *parent, int pg, char * str, int maxlen)
 			switch (d[1] & 0xf) {
 			case 0x3:
 				/* NAA: Prio 5 */
-				if (prio < 5) {
-					prio = 5;
+				switch (d[4] >> 4) {
+				case 6:
+					/* IEEE Registered Extended: Prio 8 */
+					naa_prio = 8;
+					break;
+				case 5:
+					/* IEEE Registered: Prio 7 */
+					naa_prio = 7;
+					break;
+				case 2:
+					/* IEEE Extended: Prio 6 */
+					naa_prio = 6;
+					break;
+				case 3:
+					/* IEEE Locally assigned: Prio 1 */
+					naa_prio = 1;
+					break;
+				default:
+					/* Default: no priority */
+					naa_prio = -1;
+					break;
+				}
+				if (prio < naa_prio) {
+					prio = naa_prio;
 					vpd = d;
 				}
 				break;
-- 
1.8.4.5
