From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/6] libmultipath,
	alloc_path_with_pathinfo(): Ensure that pp->wwid is '\0'-terminated
Date: Thu,  1 Mar 2018 11:29:31 -0800
Message-ID: <20180301192935.14643-3-bart.vanassche@wdc.com>
References: <20180301192935.14643-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180301192935.14643-1-bart.vanassche@wdc.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Discovered by Coverity (CID 173257).

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 libmultipath/discovery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 4b31ddef23f0..fe50ce5062ea 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -52,8 +52,8 @@ alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 	if (!pp)
 		return PATHINFO_FAILED;
 
-	if(wwid)
-		strncpy(pp->wwid, wwid, sizeof(pp->wwid));
+	if (wwid)
+		strlcpy(pp->wwid, wwid, sizeof(pp->wwid));
 
 	if (safe_sprintf(pp->dev, "%s", devname)) {
 		condlog(0, "pp->dev too small");
-- 
2.16.2
