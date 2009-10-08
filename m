From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 5 of 10] LVM:  remove unused parameter
Date: Thu, 8 Oct 2009 16:19:07 -0500
Message-ID: <200910082119.n98LJ74P014506@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: lvm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: lvm-remove-unused-parameter.patch

Here we get rid of completely unused parameters.  No-one
uses them and they are confusing.  (They imply a certain
level of processing is down by the time these functions
are called, which is not the case.)  If they were just
extra params, I wouldn't bother, but they add to confusion.

RFC: Jonathan Brassow <jbrassow@redhat.com>

Index: LVM2/lib/metadata/lv_manip.c
===================================================================
--- LVM2.orig/lib/metadata/lv_manip.c
+++ LVM2/lib/metadata/lv_manip.c
@@ -645,8 +645,7 @@ static int _setup_alloced_segment(struct
 				  uint32_t stripe_size,
 				  const struct segment_type *segtype,
 				  struct alloced_area *aa,
-				  uint32_t region_size,
-				  struct logical_volume *log_lv __attribute((unused)))
+				  uint32_t region_size)
 {
 	uint32_t s, extents, area_multiple;
 	struct lv_segment *seg;
@@ -686,15 +685,14 @@ static int _setup_alloced_segments(struc
 				   uint32_t status,
 				   uint32_t stripe_size,
 				   const struct segment_type *segtype,
-				   uint32_t region_size,
-				   struct logical_volume *log_lv)
+				   uint32_t region_size)
 {
 	struct alloced_area *aa;
 
 	dm_list_iterate_items(aa, &alloced_areas[0]) {
 		if (!_setup_alloced_segment(lv, status, area_count,
 					    stripe_size, segtype, aa,
-					    region_size, log_lv))
+					    region_size))
 			return_0;
 	}
 
@@ -1401,7 +1399,7 @@ int lv_add_segment(struct alloc_handle *
 	if (!_setup_alloced_segments(lv, &ah->alloced_areas[first_area],
 				     num_areas, status,
 				     stripe_size, segtype,
-				     region_size, log_lv))
+				     region_size))
 		return_0;
 
 	if ((segtype->flags & SEG_CAN_SPLIT) && !lv_merge_segments(lv)) {
