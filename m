From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 02/10] kpartx: avoid ioctl error for loop devices
Date: Sat,  6 May 2017 00:05:51 +0200
Message-ID: <20170505220559.7248-3-mwilck@suse.com>
References: <20170505220559.7248-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170505220559.7248-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Commit 3d709241 causes kpartx to attempt a dm ioctl on a loop
device. This causes an error message
"device-mapper: table ioctl on loop4 failed: No such device or address".

Fixes: 3d709241 "kpartx: sanitize delete partitions"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 58e60ffe..e9b09492 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -362,7 +362,7 @@ main(int argc, char **argv){
 
 	if (!mapname)
 		mapname = device + off;
-	if (!force_devmap &&
+	else if (!force_devmap &&
 		 dm_no_partitions(mapname)) {
 		/* Feature 'no_partitions' is set, return */
 		return 0;
-- 
2.12.2
