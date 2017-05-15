From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 10/12] kpartx: use absolute path for regular
	files
Date: Mon, 15 May 2017 17:37:20 +0200
Message-ID: <20170515153722.11508-11-mwilck@suse.com>
References: <20170515153722.11508-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170515153722.11508-1-mwilck@suse.com>
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

kpartx supports being called for a regular file, in which
case it assumes that it should set up a loop device or use
an existing one. Because the loopinfo.lo_name field contains
an absolute path, matching with existing loop devices fails
for relative paths. Matching by basename only would be unreliable.

Therefore, convert relative to absolute path for regular files.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 587c3dfe..c76b5b46 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -355,7 +355,13 @@ main(int argc, char **argv){
 
 	if (S_ISREG (buf.st_mode)) {
 		/* already looped file ? */
-		loopdev = find_loop_by_file(device);
+		char rpath[PATH_MAX];
+		if (realpath(device, rpath) == NULL) {
+			fprintf(stderr, "Error: %s: %s\n", device,
+				strerror(errno));
+			exit (1);
+		}
+		loopdev = find_loop_by_file(rpath);
 
 		if (!loopdev && what == DELETE)
 			exit (0);
-- 
2.12.2
