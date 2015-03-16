From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 50/78] Allow zero-sized devices during
	configuration
Date: Mon, 16 Mar 2015 13:36:37 +0100
Message-ID: <1426509425-15978-51-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

A size of '0' doesn't indicate an invalid device; other paths might
end up with a correct size.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 2c10c22..ddbd3ed 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -768,8 +768,8 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 			continue;
 
 		/* 3. if path has disappeared */
-		if (!pp1->size) {
-			orphan_path(pp1, "invalid size");
+		if (pp1->state == PATH_REMOVED) {
+			orphan_path(pp1, "path removed");
 			continue;
 		}
 
@@ -806,10 +806,11 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 			if (strcmp(pp1->wwid, pp2->wwid))
 				continue;
 
-			if (!pp2->size)
-				continue;
+			if (!mpp->size && pp2->size)
+				mpp->size = pp2->size;
 
-			if (pp2->size != mpp->size) {
+			if (mpp->size && pp2->size &&
+			    pp2->size != mpp->size) {
 				/*
 				 * ouch, avoid feeding that to the DM
 				 */
-- 
1.8.4.5
