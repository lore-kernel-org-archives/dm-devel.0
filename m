From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH] libmultipath: Fix information not shown when
	first path is down.
Date: Mon,  5 Oct 2015 17:19:17 -0300
Message-ID: <1444076357-18452-1-git-send-email-krisman@linux.vnet.ibm.com>
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
To: dm-devel@redhat.com
Cc: mauricfo@linux.vnet.ibm.com, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
List-Id: dm-devel.ids

vendor_id and product_id information are not shown when displaying
multipath topology if the first path is down.

0QEMU_QEMU_HARDDISK_HELLOWORLD dm-0 ,      <--- Missing vendor and product
size=10G features='0' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=0 status=active
| `- #:#:#:# -   #:#  active undef running
`-+- policy='service-time 0' prio=0 status=enabled
  `- 2:0:1:0 sdd 8:48 active undef running

This happens because we only look at the first_path when printing the
topology.  This patch looks at every slot in the path vector until we
find one with the correct value.

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 libmultipath/print.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 6594fee..fb2551e 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -248,11 +248,20 @@ snprint_multipath_uuid (char * buff, size_t len, struct multipath * mpp)
 static int
 snprint_multipath_vpr (char * buff, size_t len, struct multipath * mpp)
 {
-	struct path * pp = first_path(mpp);
-	if (!pp)
-		return 0;
-	return snprintf(buff, len, "%s,%s",
-			pp->vendor_id, pp->product_id);
+	struct pathgroup * pgp;
+	struct path * pp;
+	int i, j;
+
+	vector_foreach_slot(mpp->pg, pgp, i) {
+		if (!pgp)
+			continue;
+		vector_foreach_slot(pgp->paths, pp, j) {
+			if (strlen(pp->vendor_id) && strlen(pp->product_id))
+				return snprintf(buff, len, "%s,%s",
+						pp->vendor_id, pp->product_id);
+		}
+	}
+	return snprintf(buff, len, "##,##");
 }
 
 static int
-- 
2.1.0
