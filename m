From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] libmultipath,
	rbd: Fix spelling in a source code comment
Date: Tue, 16 Aug 2016 13:02:52 -0700
Message-ID: <0d6eda99-c8ef-1614-7a10-960b163e761b@sandisk.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index 6f1b53a..7f540ad 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -355,7 +355,7 @@ static int sysfs_write_rbd_bus(const char *which, const char *buf,
 	int fd;
 	int r;
 
-	/* we require newer kernels so single_major should alwayws be there */
+	/* we require newer kernels so single_major should always be there */
 	snprintf(sysfs_path, sizeof(sysfs_path),
 		 "/sys/bus/rbd/%s_single_major", which);
 	fd = open(sysfs_path, O_WRONLY);
-- 
2.9.2
