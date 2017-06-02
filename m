From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 4/5] mpath: skip device configs without
	vendor/product
Date: Thu,  1 Jun 2017 22:09:11 -0500
Message-ID: <1496372952-27110-5-git-send-email-bmarzins@redhat.com>
References: <1496372952-27110-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1496372952-27110-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Right now if multipath.conf includes a device configuration without a
vendor or product string, it will automatically be applied to all
devices, skipping all other configs entirely.  This is clearly wrong.
This patch makes sure that user added configs include vendor and
product strings

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index bb6619b..6b23601 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -451,6 +451,13 @@ restart:
 			break;
 		j = n;
 		vector_foreach_slot_after(hw, hwe2, j) {
+			/* drop invalid device configs */
+			if (!hwe2->vendor || !hwe2->product) {
+				condlog(0, "device config missing vendor or product parameter");
+				vector_del_slot(hw, j--);
+				free_hwe(hwe2);
+				continue;
+			}
 			if (hwe_regmatch(hwe1, hwe2))
 				continue;
 			/* dup */
-- 
2.7.4
