From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/78] Do not print empty device strings during
	discovery
Date: Mon, 16 Mar 2015 13:36:00 +0100
Message-ID: <1426509425-15978-14-git-send-email-hare@suse.de>
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

If the path provides no information we should not print out
empty strings, but rather an instructive message telling us so.

References: bnc#872712

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/structs_vec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index a15e3c0..a1f2212 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -226,6 +226,12 @@ extract_hwe_from_path(struct multipath * mpp)
 	}
 
 	if (pp) {
+		if (!strlen(pp->vendor_id) ||
+		    !strlen(pp->product_id) ||
+		    !strlen(pp->rev)) {
+			condlog(3, "%s: no device details available", pp->dev);
+			return NULL;
+		}
 		condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
 		condlog(3, "%s: product = %s", pp->dev, pp->product_id);
 		condlog(3, "%s: rev = %s", pp->dev, pp->rev);
-- 
1.8.4.5
