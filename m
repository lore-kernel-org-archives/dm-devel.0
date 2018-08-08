From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 09/17] libmultipath: remove unused code
Date: Wed,  8 Aug 2018 17:21:27 -0500
Message-ID: <1533766895-28605-10-git-send-email-bmarzins@redhat.com>
References: <1533766895-28605-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533766895-28605-1-git-send-email-bmarzins@redhat.com>
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

since vector_foreach_slot() already checks if the entry is NULL, there's
no point in checking it in the loop, since it can't be NULL there. Found
by coverity.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 9da6a77..7b610b9 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -275,8 +275,6 @@ snprint_multipath_vpr (char * buff, size_t len, const struct multipath * mpp)
 	int i, j;
 
 	vector_foreach_slot(mpp->pg, pgp, i) {
-		if (!pgp)
-			continue;
 		vector_foreach_slot(pgp->paths, pp, j) {
 			if (strlen(pp->vendor_id) && strlen(pp->product_id))
 				return snprintf(buff, len, "%s,%s",
@@ -295,8 +293,6 @@ snprint_multipath_vend (char * buff, size_t len, const struct multipath * mpp)
 	int i, j;
 
 	vector_foreach_slot(mpp->pg, pgp, i) {
-		if (!pgp)
-			continue;
 		vector_foreach_slot(pgp->paths, pp, j) {
 			if (strlen(pp->vendor_id))
 				return snprintf(buff, len, "%s", pp->vendor_id);
@@ -313,8 +309,6 @@ snprint_multipath_prod (char * buff, size_t len, const struct multipath * mpp)
 	int i, j;
 
 	vector_foreach_slot(mpp->pg, pgp, i) {
-		if (!pgp)
-			continue;
 		vector_foreach_slot(pgp->paths, pp, j) {
 			if (strlen(pp->product_id))
 				return snprintf(buff, len, "%s", pp->product_id);
@@ -331,8 +325,6 @@ snprint_multipath_rev (char * buff, size_t len, const struct multipath * mpp)
 	int i, j;
 
 	vector_foreach_slot(mpp->pg, pgp, i) {
-		if (!pgp)
-			continue;
 		vector_foreach_slot(pgp->paths, pp, j) {
 			if (strlen(pp->rev))
 				return snprintf(buff, len, "%s", pp->rev);
-- 
2.7.4
