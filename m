From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 30/39] kpartx: use fstat() when reading sysfs
	attributes
Date: Thu, 16 Jun 2016 11:47:36 +0200
Message-ID: <1466070465-1021-31-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Coverity pointed out that we shouldn't be using stat()/open(),
as the file might have vanished or changed in between those
two calls. So modify it to open()/fstat() instead.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 kpartx/lopart.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 5495e27..d4a2ab4 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -117,14 +117,16 @@ find_loop_by_file (const char * filename)
 			continue;
 		sprintf(dev, "/dev/%s", dent->d_name);
 
-		if (stat (dev, &statbuf) != 0 ||
-		    !S_ISBLK(statbuf.st_mode))
-			continue;
-
 		fd = open (dev, O_RDONLY);
 		if (fd < 0)
 			break;
 
+		if (fstat (fd, &statbuf) != 0 ||
+		    !S_ISBLK(statbuf.st_mode)) {
+			close (fd);
+			continue;
+		}
+
 		if (ioctl (fd, LOOP_GET_STATUS, &loopinfo) != 0) {
 			close (fd);
 			continue;
-- 
2.6.6
