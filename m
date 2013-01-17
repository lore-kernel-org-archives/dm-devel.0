From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/11] Break out loop in factorize_hwtable()
Date: Thu, 17 Jan 2013 15:59:28 +0100
Message-ID: <1358434773-2002-7-git-send-email-hare@suse.de>
References: <1358434773-2002-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358434773-2002-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

We need to break out of the loop in factorize_hwtable() as
soon as we have removed a duplicate. Otherwise we might run
onto an deleted element in the outer loop.
Also we should declare factorize_hwtable() as 'void'
as it doesn't return anything.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 2d88226..25d3e3d 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -418,12 +418,13 @@ out:
 	return 1;
 }
 
-static int
+static void
 factorize_hwtable (vector hw, int n)
 {
 	struct hwentry *hwe1, *hwe2;
 	int i, j;
 
+restart:
 	vector_foreach_slot(hw, hwe1, i) {
 		if (i == n)
 			break;
@@ -435,14 +436,17 @@ factorize_hwtable (vector hw, int n)
 			merge_hwe(hwe2, hwe1);
 			if (hwe_strmatch(hwe2, hwe1) == 0) {
 				vector_del_slot(hw, i);
-				free_hwe(hwe1);
-				n -= 1;
-				i -= 1;
-				break;
+				/*
+				 * Play safe here; we have modified
+				 * the original vector so the outer
+				 * vector_foreach_slot() might
+				 * become confused.
+				 */
+				goto restart;
 			}
 		}
 	}
-	return 0;
+	return;
 }
 
 struct config *
-- 
1.7.10.4
