From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 05/18] Use outsz macro
Date: Mon,  2 Nov 2009 15:20:09 +0100
Message-ID: <1257171622-8380-6-git-send-email-zkabelac@redhat.com>
References: <1257171622-8380-1-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-2-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-3-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-4-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-5-git-send-email-zkabelac@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1257171622-8380-5-git-send-email-zkabelac@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Using outsz() macro instead of direct call of out_size() with check
for error status of this function.

Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
---
 lib/mirror/mirrored.c |    4 ++--
 lib/striped/striped.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/mirror/mirrored.c b/lib/mirror/mirrored.c
index e93ed0b..dfac91e 100644
--- a/lib/mirror/mirrored.c
+++ b/lib/mirror/mirrored.c
@@ -149,8 +149,8 @@ static int _mirrored_text_export(const struct lv_segment *seg, struct formatter
 {
 	outf(f, "mirror_count = %u", seg->area_count);
 	if (seg->status & PVMOVE)
-		out_size(f, (uint64_t) seg->extents_copied * seg->lv->vg->extent_size,
-			 "extents_moved = %" PRIu32, seg->extents_copied);
+		outsz(f, (uint64_t) seg->extents_copied * seg->lv->vg->extent_size,
+		      "extents_moved = %" PRIu32, seg->extents_copied);
 	if (seg->log_lv)
 		outf(f, "mirror_log = \"%s\"", seg->log_lv->name);
 	if (seg->region_size)
diff --git a/lib/striped/striped.c b/lib/striped/striped.c
index f187da5..220edd8 100644
--- a/lib/striped/striped.c
+++ b/lib/striped/striped.c
@@ -98,8 +98,8 @@ static int _striped_text_export(const struct lv_segment *seg, struct formatter *
 	     (seg->area_count == 1) ? "\t# linear" : "");
 
 	if (seg->area_count > 1)
-		out_size(f, (uint64_t) seg->stripe_size,
-			 "stripe_size = %u", seg->stripe_size);
+		outsz(f, (uint64_t) seg->stripe_size,
+		      "stripe_size = %u", seg->stripe_size);
 
 	return out_areas(f, seg, "stripe");
 }
-- 
1.6.5.1
