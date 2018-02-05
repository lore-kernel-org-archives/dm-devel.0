From: Julian Andres Klode <julian.klode@canonical.com>
Subject: [PATCH] kpartx: print "loop deleted" to stdout,
	not stderr
Date: Mon,  5 Feb 2018 11:36:45 +0100
Message-ID: <20180205103645.19121-1-julian.klode@canonical.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Device-mapper development mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

Commit fa643f5d2590028a59c671b81ab41383806fd258 moved some
code around and changed the print for loop deleted from stdout
to stderr - but this is not an error message, and also printed
to stdout in another place, so let's just use printf() again
here.

Signed-off-by: Julian Andres Klode <julian.klode@canonical.com>
---
 kpartx/kpartx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index c1af1c5e..2e882721 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -399,7 +399,7 @@ main(int argc, char **argv){
 					       loopdev);
 				r = 1;
 			} else
-				fprintf(stderr, "loop deleted : %s\n", loopdev);
+				printf("loop deleted : %s\n", loopdev);
 		}
 		goto end;
 	}
-- 
2.15.1
