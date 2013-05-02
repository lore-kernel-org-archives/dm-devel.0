From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 01/16] Make kpartx advise modprobe instead of
	insmod
Date: Thu,  2 May 2013 16:46:22 -0500
Message-ID: <1367531197-8987-2-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Users usually want to use modprobe instead of insmod, since it
handles finding the correct version and dependencies.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/lopart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 9413ab1..79a7593 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -205,13 +205,13 @@ find_unused_loop_device (void)
 		fprintf(stderr,
 		    "mount: Could not find any loop device, and, according to %s,\n"
 		    "       this kernel does not know about the loop device.\n"
-		    "       (If so, then recompile or `insmod loop.o'.)",
+		    "       (If so, then recompile or `modprobe loop'.)",
 		      PROC_DEVICES);
 
 	    else
 		fprintf(stderr,
 		    "mount: Could not find any loop device. Maybe this kernel does not know\n"
-		    "       about the loop device (then recompile or `insmod loop.o'), or\n"
+		    "       about the loop device (then recompile or `modprobe loop'), or\n"
 		    "       maybe /dev/loop# has the wrong major number?");
 
 	} else
-- 
1.8.2
