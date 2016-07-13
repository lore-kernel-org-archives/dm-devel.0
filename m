From: Christian Kastner <ckk@debian.org>
Subject: [PATCH] kpartx: Fix check whether to detach loop device
Date: Wed, 13 Jul 2016 19:23:02 +0200
Message-ID: <1468430582-4260-1-git-send-email-ckk@debian.org>
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
To: dm-devel@redhat.com
Cc: Christian Kastner <ckk@kvr.at>
List-Id: dm-devel.ids

From: Christian Kastner <ckk@kvr.at>

When invoking kpartx -d $FOO with $FOO being a regular file, the intention is
to also detach the loop device backing $FOO using del_loop(), but this
currently doesn't happen, as can be seen by calling losetup -a afterwards.

This is because the check for the type of $FOO, prior to the del_loop() call, is
broken. S_ISREG() is called on a buffer that initially did contain the status of
$FOO, but was later overwritten with the status of the backing loop device.

This replaces the S_ISREG() test with a check for whether the loop device path
is not NULL. If it isn't, then we know that it contains the correct path, and
del_loop() can be called safely on that.

Reported as Debian bug #829496; that bug also has more information.

Signed-off-by: Christian Kastner <ckk@kvr.at>
---
 kpartx/kpartx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 4de13fa..b7b4047 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -482,14 +482,14 @@ main(int argc, char **argv){
 					printf("del devmap : %s\n", partname);
 			}
 
-			if (S_ISREG (buf.st_mode)) {
-				if (del_loop(device)) {
+			if (loopdev) {
+				if (del_loop(loopdev)) {
 					if (verbose)
 						printf("can't del loop : %s\n",
-							device);
+							loopdev);
 					exit(1);
 				}
-				printf("loop deleted : %s\n", device);
+				printf("loop deleted : %s\n", loopdev);
 			}
 			break;
 
-- 
2.8.1
