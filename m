From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 12/32] kpartx: minor fixes to make coverity happy
Date: Wed,  1 Aug 2018 15:56:58 -0500
Message-ID: <1533157038-3924-13-git-send-email-bmarzins@redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

an open() failure for fd_dasd will return -1, not 0. Also, cast blocksize
to a uint64_t to keep coverity from complaining about sign extension issues.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/dasd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index e418d5a..94ae81b 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -129,7 +129,7 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 			 */
 			unlink(pathname);
 		}
-		if (!fd_dasd) {
+		if (fd_dasd < 0) {
 			/* Couldn't open the device */
 			return -1;
 		}
@@ -157,7 +157,8 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 
 		geo.heads = 15;
 		geo.sectors = recs_per_track(blocksize);
-		cyl = disksize / (blocksize * geo.heads * geo.sectors);
+		cyl = disksize / ((uint64_t)blocksize * geo.heads *
+				  geo.sectors);
 		if (cyl < LV_COMPAT_CYL)
 			geo.cylinders = cyl;
 		else
-- 
2.7.4
