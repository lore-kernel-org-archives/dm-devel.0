From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: fix multipath locking
Date: Thu, 4 Nov 2010 23:59:46 -0500
Message-ID: <20101105045946.GJ13763@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
List-Id: dm-devel.ids

In lock_multipath(), if multipathd fails halfway though locking the the path
devices, it doesn't unlock the ones that it already has locked.  This
patch fixes that.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

Index: multipath-tools/libmultipath/configure.c
===================================================================
--- multipath-tools.orig/libmultipath/configure.c
+++ multipath-tools/libmultipath/configure.c
@@ -284,6 +284,7 @@ lock_multipath (struct multipath * mpp, 
 	struct pathgroup * pgp;
 	struct path * pp;
 	int i, j;
+	int x, y;
 
 	if (!mpp || !mpp->pg)
 		return 0;
@@ -294,12 +295,25 @@ lock_multipath (struct multipath * mpp, 
 		vector_foreach_slot(pgp->paths, pp, j) {
 			if (lock && flock(pp->fd, LOCK_EX | LOCK_NB) &&
 			    errno == EWOULDBLOCK)
-				return 1;
+				goto fail;
 			else if (!lock)
 				flock(pp->fd, LOCK_UN);
 		}
 	}
 	return 0;
+fail:
+	vector_foreach_slot (mpp->pg, pgp, x) {
+		if (x > i)
+			return 1;
+		if (!pgp->paths)
+			continue;
+		vector_foreach_slot(pgp->paths, pp, y) {
+			if (x == i && y > j)
+				return 1;
+			flock(pp->fd, LOCK_UN);
+		}
+	}
+	return 1;
 }
 
 /*
