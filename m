From: Yingtai Xie <xieyingtai@huawei.com>
Subject: [PATCH] libmultipath: Fix memory leak problem in
	print_multipath_topology
Date: Mon, 29 Dec 2014 14:44:42 +0800
Message-ID: <54A0F85A.5020301@huawei.com>
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
To: christophe.varoqui@opensvc.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Joseph Qi <joseph.qi@huawei.com>
List-Id: dm-devel.ids

/sys/block/ directory has been opened in snprint_devices, the handler
should be released when returned abnormally. Similar memory leak problem
happens in print_multipath_topology when carried out multipath -ll command.

Signed-off-by: Yingtai Xie <xieyingtai@huawei.com>
---
 libmultipath/print.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 383eae4..916906f 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -890,6 +890,7 @@ print_multipath_topology (struct multipath * mpp, int verbosity)
 		}
 	} while (resize);
 	printf("%s", buff);
+	FREE(buff);
 }

 extern int
@@ -1427,8 +1428,10 @@ snprint_devices (char * buff, int len, struct vectors *vecs)
 	if (!(blkdir = opendir("/sys/block")))
 		return 1;

-	if ((len - fwd - threshold) <= 0)
+	if ((len - fwd - threshold) <= 0) {
+		closedir(blkdir);
 		return len;
+	}
 	fwd += snprintf(buff + fwd, len - fwd, "available block devices:\n");

 	strcpy(devpath,"/sys/block/");
@@ -1446,8 +1449,10 @@ snprint_devices (char * buff, int len, struct vectors *vecs)
 		if (S_ISDIR(statbuf.st_mode) == 0)
 			continue;

-		if ((len - fwd - threshold)  <= 0)
+		if ((len - fwd - threshold)  <= 0) {
+			closedir(blkdir);
 			return len;
+		}

 		fwd += snprintf(buff + fwd, len - fwd, "    %s", devptr);
 		pp = find_path_by_dev(vecs->pathvec, devptr);
-- 
1.7.12.4
