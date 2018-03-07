From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/8] libmultipath,
	alloc_path_with_pathinfo(): Ensure that pp->wwid is '\0'-terminated
Date: Thu,  8 Mar 2018 00:15:46 +0100
Message-ID: <20180307231551.15162-4-mwilck@suse.com>
References: <20180307231551.15162-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307231551.15162-1-mwilck@suse.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Chongyun Wu <wu.chongyun@h3c.com>
List-Id: dm-devel.ids

From: Bart Van Assche <bart.vanassche@wdc.com>

Discovered by Coverity (CID 173257).

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 9efcaac81dc1..71c75872c937 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -53,8 +53,8 @@ alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 	if (!pp)
 		return PATHINFO_FAILED;
 
-	if(wwid)
-		strncpy(pp->wwid, wwid, sizeof(pp->wwid));
+	if (wwid)
+		strlcpy(pp->wwid, wwid, sizeof(pp->wwid));
 
 	if (safe_sprintf(pp->dev, "%s", devname)) {
 		condlog(0, "pp->dev too small");
-- 
2.16.1
