From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/4] kpartx: recognize DASD on loop devices again
Date: Tue, 9 Jul 2019 07:40:02 +0000
Message-ID: <20190709073909.32112-3-martin.wilck@suse.com>
References: <20190709073909.32112-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190709073909.32112-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Since 4d57b868, DASD partition tables are only recognized on
DASD hardware. This turns out to break certain software that works
e.g. with DASD partition tables on loop devices. The problem that
4d57b868 attempted to fix was that "unlabeled disk" format has
no signature at all and is detected on any volume, including
empty ones.

With this patch, DASD partition table formats other than "unlabeled
disk" are detected on non-DASD devices again.

Fixes: 4d57b868 "kpartx: only recognize dasd part table on DASD"
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/dasd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index d95d8ca0..4e7e4743 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -133,9 +133,6 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 			/* Couldn't open the device */
 			return -1;
 		}
-	} else if ((unsigned int)major(sbuf.st_rdev) != 94) {
-			/* Not a DASD */
-			return -1;
 	} else {
 		fd_dasd = dup(fd);
 		if (fd_dasd < 0)
@@ -279,6 +276,10 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 			size = disksize;
 			if (fmt_size < size)
 				size = fmt_size;
+		} else if ((unsigned int)major(sbuf.st_rdev) != 94) {
+			/* Not a DASD */
+			retval = -1;
+			goto out;
 		} else
 			size = disksize;
 
-- 
2.22.0
