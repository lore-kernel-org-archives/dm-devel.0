From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 5/5] rbd: use lock_on_read if set
Date: Tue, 11 Oct 2016 16:36:55 -0500
Message-ID: <1476221815-17900-6-git-send-email-mchristi@redhat.com>
References: <1476221815-17900-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476221815-17900-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

If lock_on_read is set initially, pass it as a map option
when remapping the image.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 libmultipath/checkers/rbd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index e516166..c920cbb 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -46,6 +46,7 @@ struct rbd_checker_context {
 	char *username;
 	int remapped;
 	int blacklisted;
+	int lock_on_read:1;
 
 	rados_t cluster;
 
@@ -142,6 +143,9 @@ int libcheck_init(struct checker * c)
 		goto free_addr;
 	}
 
+	if (strstr(config_info, "lock_on_read"))
+		ct->lock_on_read = 1;
+
 	ct->config_info = strdup(config_info);
 	if (!ct->config_info)
 		goto free_addr;
@@ -398,7 +402,10 @@ static int rbd_remap(struct rbd_checker_context *ct)
 	case 0:
 		argv[i++] = "rbd";
 		argv[i++] = "map";
-		argv[i++] = "-o noshare";
+		if (ct->lock_on_read)
+			argv[i++] = "-o noshare,lock_on_read";
+		else
+			argv[i++] = "-o noshare";
 		if (ct->username) {
 			argv[i++] = "--id";
 			argv[i++] = ct->username;
-- 
2.7.2
