From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 10] LVM:  agk allocation changes
Date: Fri, 26 Feb 2010 17:35:49 -0600
Message-ID: <201002262335.o1QNZn1Q024056@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
List-Id: dm-devel.ids

Patch name: lvm-agk-allocation-changes.patch

agk's allocation changes...

Index: LVM2/lib/metadata/lv_alloc.h
===================================================================
--- LVM2.orig/lib/metadata/lv_alloc.h
+++ LVM2/lib/metadata/lv_alloc.h
@@ -58,8 +58,7 @@ int lv_add_segment(struct alloc_handle *
                    const struct segment_type *segtype,
                    uint32_t stripe_size,
                    uint64_t status,
-		   uint32_t region_size,
-                   struct logical_volume *log_lv);
+		   uint32_t region_size);
 
 int lv_add_mirror_areas(struct alloc_handle *ah,
 			struct logical_volume *lv, uint32_t le,
Index: LVM2/lib/metadata/lv_manip.c
===================================================================
--- LVM2.orig/lib/metadata/lv_manip.c
+++ LVM2/lib/metadata/lv_manip.c
@@ -507,16 +507,21 @@ struct alloc_handle {
 	struct dm_pool *mem;
 
 	alloc_policy_t alloc;		/* Overall policy */
+	uint32_t new_extents;		/* Number of new extents required */
 	uint32_t area_count;		/* Number of parallel areas */
 	uint32_t area_multiple;		/* seg->len = area_len * area_multiple */
-	uint32_t log_count;		/* Number of parallel 1-extent logs */
-	uint32_t log_region_size;	/* region size for log device */
+	uint32_t log_area_count;	/* Number of parallel logs */
+	uint32_t log_len;		/* Length of log */
+	uint32_t region_size;		/* Mirror region size */
 	uint32_t total_area_len;	/* Total number of parallel extents */
 
 	struct dm_list *parallel_areas;	/* PVs to avoid */
 
-	struct alloced_area log_area;	/* Extent used for log */
-	struct dm_list alloced_areas[0];	/* Lists of areas in each stripe */
+	/*
+	 * Contains area_count lists of areas allocated to data stripes
+	 * followed by log_area_count lists of areas allocated to log stripes.
+	 */
+	struct dm_list alloced_areas[0];
 };
 
 static uint32_t calc_area_multiple(const struct segment_type *segtype,
@@ -529,16 +534,40 @@ static uint32_t calc_area_multiple(const
 }
 
 /*
+ * Returns log device size in extents, algorithm from kernel code
+ */
+#define BYTE_SHIFT 3
+static uint32_t mirror_log_extents(uint32_t region_size, uint32_t pe_size, uint32_t area_len)
+{
+	size_t area_size, bitset_size, log_size, region_count;
+
+	area_size = area_len * pe_size;
+	region_count = dm_div_up(area_size, region_size);
+
+	/* Work out how many "unsigned long"s we need to hold the bitset. */
+	bitset_size = dm_round_up(region_count, sizeof(uint32_t) << BYTE_SHIFT);
+	bitset_size >>= BYTE_SHIFT;
+
+	/* Log device holds both header and bitset. */
+	log_size = dm_round_up((MIRROR_LOG_OFFSET << SECTOR_SHIFT) + bitset_size, 1 << SECTOR_SHIFT);
+	log_size >>= SECTOR_SHIFT;
+
+	return dm_div_up(log_size, pe_size);
+}
+
+/*
  * Preparation for a specific allocation attempt
  */
 static struct alloc_handle *_alloc_init(struct cmd_context *cmd,
 					struct dm_pool *mem,
 					const struct segment_type *segtype,
 					alloc_policy_t alloc,
+					uint32_t new_extents,
 					uint32_t mirrors,
 					uint32_t stripes,
-					uint32_t log_count,
-					uint32_t log_region_size,
+					uint32_t log_area_count,
+					uint32_t extent_size,
+					uint32_t region_size,
 					struct dm_list *parallel_areas)
 {
 	struct alloc_handle *ah;
@@ -549,7 +578,7 @@ static struct alloc_handle *_alloc_init(
 		return NULL;
 	}
 
-	if (log_count && stripes > 1) {
+	if (log_area_count && stripes > 1) {
 		log_error("Can't mix striping with a mirror log yet.");
 		return NULL;
 	}
@@ -561,7 +590,7 @@ static struct alloc_handle *_alloc_init(
 	else
 		area_count = stripes;
 
-	if (!(ah = dm_pool_zalloc(mem, sizeof(*ah) + sizeof(ah->alloced_areas[0]) * area_count))) {
+	if (!(ah = dm_pool_zalloc(mem, sizeof(*ah) + sizeof(ah->alloced_areas[0]) * (area_count + log_area_count)))) {
 		log_error("allocation handle allocation failed");
 		return NULL;
 	}
@@ -576,13 +605,16 @@ static struct alloc_handle *_alloc_init(
 		return NULL;
 	}
 
+	ah->new_extents = new_extents;
 	ah->area_count = area_count;
-	ah->log_count = log_count;
-	ah->log_region_size = log_region_size;
+	ah->log_area_count = log_area_count;
+	ah->region_size = region_size;
 	ah->alloc = alloc;
 	ah->area_multiple = calc_area_multiple(segtype, area_count);
 
-	for (s = 0; s < ah->area_count; s++)
+	ah->log_len = log_area_count ? mirror_log_extents(ah->region_size, extent_size, ah->new_extents / ah->area_multiple) : 0;
+
+	for (s = 0; s < ah->area_count + ah->log_area_count; s++)
 		dm_list_init(&ah->alloced_areas[s]);
 
 	ah->parallel_areas = parallel_areas;
@@ -644,15 +676,13 @@ static int _setup_alloced_segment(struct
 				  uint32_t stripe_size,
 				  const struct segment_type *segtype,
 				  struct alloced_area *aa,
-				  uint32_t region_size,
-				  struct logical_volume *log_lv __attribute((unused)))
+				  uint32_t region_size)
 {
 	uint32_t s, extents, area_multiple;
 	struct lv_segment *seg;
 
 	area_multiple = calc_area_multiple(segtype, area_count);
 
-	/* log_lv gets set up elsehere */
 	if (!(seg = alloc_lv_segment(lv->vg->cmd->mem, segtype, lv,
 				     lv->le_count,
 				     aa[0].len * area_multiple,
@@ -685,15 +715,14 @@ static int _setup_alloced_segments(struc
 				   uint64_t status,
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
 
@@ -701,42 +730,21 @@ static int _setup_alloced_segments(struc
 }
 
 /*
- * Returns log device size in extents, algorithm from kernel code
- */
-#define BYTE_SHIFT 3
-static uint32_t mirror_log_extents(uint32_t region_size, uint32_t pe_size, uint32_t area_len)
-{
-	size_t area_size, bitset_size, log_size, region_count;
-
-	area_size = area_len * pe_size;
-	region_count = dm_div_up(area_size, region_size);
-
-	/* Work out how many "unsigned long"s we need to hold the bitset. */
-	bitset_size = dm_round_up(region_count, sizeof(uint32_t) << BYTE_SHIFT);
-	bitset_size >>= BYTE_SHIFT;
-
-	/* Log device holds both header and bitset. */
-	log_size = dm_round_up((MIRROR_LOG_OFFSET << SECTOR_SHIFT) + bitset_size, 1 << SECTOR_SHIFT);
-	log_size >>= SECTOR_SHIFT;
-
-	return dm_div_up(log_size, pe_size);
-}
-
-/*
  * This function takes a list of pv_areas and adds them to allocated_areas.
  * If the complete area is not needed then it gets split.
  * The part used is removed from the pv_map so it can't be allocated twice.
  */
 static int _alloc_parallel_area(struct alloc_handle *ah, uint32_t needed,
-				struct pv_area **areas,
-				uint32_t *ix, struct pv_area *log_area,
-				uint32_t log_len)
+				struct pv_area **areas, uint32_t *allocated,
+				unsigned log_needs_allocating, uint32_t ix_log_offset)
 {
-	uint32_t area_len, remaining;
+	uint32_t area_len, len, remaining;
 	uint32_t s;
+	uint32_t ix_log_skip = 0; /* How many areas to skip in middle of array to reach log areas */
+	uint32_t total_area_count = ah->area_count + (log_needs_allocating ? ah->log_area_count : 0);
 	struct alloced_area *aa;
 
-	remaining = needed - *ix;
+	remaining = needed - *allocated;
 	area_len = remaining / ah->area_multiple;
 
 	/* Reduce area_len to the smallest of the areas */
@@ -744,32 +752,35 @@ static int _alloc_parallel_area(struct a
 		if (area_len > areas[s]->count)
 			area_len = areas[s]->count;
 
-	if (!(aa = dm_pool_alloc(ah->mem, sizeof(*aa) *
-			      (ah->area_count + (log_area ? 1 : 0))))) {
+	if (!(aa = dm_pool_alloc(ah->mem, sizeof(*aa) * total_area_count))) {
 		log_error("alloced_area allocation failed");
 		return 0;
 	}
 
-	for (s = 0; s < ah->area_count; s++) {
-		aa[s].pv = areas[s]->map->pv;
-		aa[s].pe = areas[s]->start;
-		aa[s].len = area_len;
-		dm_list_add(&ah->alloced_areas[s], &aa[s].list);
-	}
+	/*
+	 * Areas consists of area_count areas for data stripes, then
+	 * ix_log_skip areas to skip, then log_area_count areas to use for the
+	 * log, then some areas too small for the log.
+	 */
+	len = area_len;
+	for (s = 0; s < total_area_count; s++) {
+		if (s == ah->area_count) {
+			ix_log_skip = ix_log_offset - ah->area_count;
+			len = ah->log_len;
+		}
 
-	ah->total_area_len += area_len;
+		aa[s].pv = areas[s + ix_log_skip]->map->pv;
+		aa[s].pe = areas[s + ix_log_skip]->start;
+		aa[s].len = len;
 
-	for (s = 0; s < ah->area_count; s++)
-		consume_pv_area(areas[s], area_len);
+		consume_pv_area(areas[s + ix_log_skip], len);
 
-	if (log_area) {
-		ah->log_area.pv = log_area->map->pv;
-		ah->log_area.pe = log_area->start;
-		ah->log_area.len = log_len;
-		consume_pv_area(log_area, ah->log_area.len);
+		dm_list_add(&ah->alloced_areas[s], &aa[s].list);
 	}
 
-	*ix += area_len * ah->area_multiple;
+	ah->total_area_len += area_len;
+
+	*allocated += area_len * ah->area_multiple;
 
 	return 1;
 }
@@ -990,15 +1001,16 @@ static int _find_parallel_space(struct a
 	unsigned contiguous = 0, cling = 0, preferred_count = 0;
 	unsigned ix;
 	unsigned ix_offset = 0;	/* Offset for non-preferred allocations */
+	unsigned ix_log_offset; /* Offset to start of areas to use for log */
 	unsigned too_small_for_log_count; /* How many too small for log? */
 	uint32_t max_parallel;	/* Maximum extents to allocate */
 	uint32_t next_le;
 	struct seg_pvs *spvs;
 	struct dm_list *parallel_pvs;
 	uint32_t free_pes;
-	uint32_t log_len;
-	struct pv_area *log_area;
 	unsigned log_needs_allocating;
+	struct alloced_area *aa;
+	uint32_t s;
 
 	/* Is there enough total space? */
 	free_pes = pv_maps_size(pvms);
@@ -1062,9 +1074,11 @@ static int _find_parallel_space(struct a
 
 			if (alloc != ALLOC_ANYWHERE) {
 				/* Don't allocate onto the log pv */
-				if (ah->log_count &&
-				    pvm->pv == ah->log_area.pv)
-					continue;	/* Next PV */
+				if (ah->log_area_count)
+					dm_list_iterate_items(aa, &ah->alloced_areas[ah->area_count])
+						for (s = 0; s < ah->log_area_count; s++)
+							if (!aa[s].pv)
+								goto next_pv;
 
 				/* Avoid PVs used by existing parallel areas */
 				if (parallel_pvs)
@@ -1102,7 +1116,7 @@ static int _find_parallel_space(struct a
 				/* Is it big enough on its own? */
 				if (pva->count * ah->area_multiple <
 				    max_parallel - *allocated &&
-				    ((!can_split && !ah->log_count) ||
+				    ((!can_split && !ah->log_area_count) ||
 				     (already_found_one &&
 				      !(alloc == ALLOC_ANYWHERE))))
 					goto next_pv;
@@ -1123,11 +1137,11 @@ static int _find_parallel_space(struct a
 		if ((contiguous || cling) && (preferred_count < ix_offset))
 			break;
 
-		log_needs_allocating = (ah->log_count && !ah->log_area.len) ?
-				       1 : 0;
+		log_needs_allocating = (ah->log_area_count &&
+					dm_list_empty(&ah->alloced_areas[ah->area_count])) ?  1 : 0;
 
 		if (ix + ix_offset < ah->area_count +
-		   (log_needs_allocating ? ah->log_count : 0))
+		   (log_needs_allocating ? ah->log_area_count : 0))
 			break;
 
 		/* sort the areas so we allocate from the biggest */
@@ -1138,38 +1152,28 @@ static int _find_parallel_space(struct a
 		/*
 		 * First time around, if there's a log, allocate it on the
 		 * smallest device that has space for it.
-		 *
-		 * FIXME decide which PV to use at top of function instead
 		 */
-
 		too_small_for_log_count = 0;
+		ix_log_offset = 0;
 
-		if (!log_needs_allocating) {
-			log_len = 0;
-			log_area = NULL;
-		} else {
-			log_len = mirror_log_extents(ah->log_region_size,
-			    pv_pe_size((*areas)->map->pv),
-			    (max_parallel - *allocated) / ah->area_multiple);
-
+		/* FIXME This logic is due to its heritage and can be simplified! */
+		if (log_needs_allocating) {
 			/* How many areas are too small for the log? */
 			while (too_small_for_log_count < ix_offset + ix &&
 			       (*(areas + ix_offset + ix - 1 -
-				  too_small_for_log_count))->count < log_len)
+				  too_small_for_log_count))->count < ah->log_len)
 				too_small_for_log_count++;
-
-			log_area = *(areas + ix_offset + ix - 1 -
-				     too_small_for_log_count);
+			ix_log_offset = ix_offset + ix - too_small_for_log_count - ah->log_area_count;
 		}
 
 		if (ix + ix_offset < ah->area_count +
-		    (log_needs_allocating ? ah->log_count +
+		    (log_needs_allocating ? ah->log_area_count +
 					    too_small_for_log_count : 0))
 			/* FIXME With ALLOC_ANYWHERE, need to split areas */
 			break;
 
 		if (!_alloc_parallel_area(ah, max_parallel, areas, allocated,
-					  log_area, log_len))
+					  log_needs_allocating, ix_log_offset))
 			return_0;
 
 	} while (!contiguous && *allocated != needed && can_split);
@@ -1185,7 +1189,6 @@ static int _find_parallel_space(struct a
 static int _allocate(struct alloc_handle *ah,
 		     struct volume_group *vg,
 		     struct logical_volume *lv,
-		     uint32_t new_extents,
 		     unsigned can_split,
 		     struct dm_list *allocatable_pvs)
 {
@@ -1197,8 +1200,9 @@ static int _allocate(struct alloc_handle
 	struct dm_list *pvms;
 	uint32_t areas_size;
 	alloc_policy_t alloc;
+	struct alloced_area *aa;
 
-	if (allocated >= new_extents && !ah->log_count) {
+	if (allocated >= ah->new_extents && !ah->log_area_count) {
 		log_error("_allocate called with no work to do!");
 		return 1;
 	}
@@ -1219,14 +1223,14 @@ static int _allocate(struct alloc_handle
 		stack;
 
 	areas_size = dm_list_size(pvms);
-	if (areas_size && areas_size < (ah->area_count + ah->log_count)) {
+	if (areas_size && areas_size < (ah->area_count + ah->log_area_count)) {
 		if (ah->alloc != ALLOC_ANYWHERE) {
 			log_error("Not enough PVs with free space available "
 				  "for parallel allocation.");
 			log_error("Consider --alloc anywhere if desperate.");
 			return 0;
 		}
-		areas_size = ah->area_count + ah->log_count;
+		areas_size = ah->area_count + ah->log_area_count;
 	}
 
 	/* Upper bound if none of the PVs in prev_lvseg is in pvms */
@@ -1245,29 +1249,31 @@ static int _allocate(struct alloc_handle
 		old_allocated = allocated;
 		if (!_find_parallel_space(ah, alloc, pvms, areas,
 					  areas_size, can_split,
-					  prev_lvseg, &allocated, new_extents))
+					  prev_lvseg, &allocated, ah->new_extents))
 			goto_out;
-		if ((allocated == new_extents) || (ah->alloc == alloc) ||
+		if ((allocated == ah->new_extents) || (ah->alloc == alloc) ||
 		    (!can_split && (allocated != old_allocated)))
 			break;
 	}
 
-	if (allocated != new_extents) {
+	if (allocated != ah->new_extents) {
 		log_error("Insufficient suitable %sallocatable extents "
 			  "for logical volume %s: %u more required",
 			  can_split ? "" : "contiguous ",
 			  lv ? lv->name : "",
-			  (new_extents - allocated) * ah->area_count
+			  (ah->new_extents - allocated) * ah->area_count
 			  / ah->area_multiple);
 		goto out;
 	}
 
-	if (ah->log_count && !ah->log_area.len) {
-		log_error("Insufficient extents for log allocation "
-			  "for logical volume %s.",
-			  lv ? lv->name : "");
-		goto out;
-	}
+	if (ah->log_area_count)
+		dm_list_iterate_items(aa, &ah->alloced_areas[ah->area_count])
+			if (!aa[0].pv) {
+				log_error("Insufficient extents for log allocation "
+					  "for logical volume %s.",
+					  lv ? lv->name : "");
+				goto out;
+			}
 
 	r = 1;
 
@@ -1306,12 +1312,13 @@ struct alloc_handle *allocate_extents(st
 				      const struct segment_type *segtype,
 				      uint32_t stripes,
 				      uint32_t mirrors, uint32_t log_count,
-				      uint32_t log_region_size, uint32_t extents,
+				      uint32_t region_size, uint32_t extents,
 				      struct dm_list *allocatable_pvs,
 				      alloc_policy_t alloc,
 				      struct dm_list *parallel_areas)
 {
 	struct alloc_handle *ah;
+	uint32_t new_extents;
 
 	if (segtype_is_virtual(segtype)) {
 		log_error("allocate_extents does not handle virtual segments");
@@ -1331,13 +1338,15 @@ struct alloc_handle *allocate_extents(st
 	if (alloc == ALLOC_INHERIT)
 		alloc = vg->alloc;
 
-	if (!(ah = _alloc_init(vg->cmd, vg->cmd->mem, segtype, alloc, mirrors,
-			       stripes, log_count, log_region_size, parallel_areas)))
+	new_extents = (lv ? lv->le_count : 0) + extents;
+	if (!(ah = _alloc_init(vg->cmd, vg->cmd->mem, segtype, alloc,
+			       new_extents, mirrors, stripes, log_count,
+			       vg->extent_size, region_size,
+			       parallel_areas)))
 		return_NULL;
 
 	if (!segtype_is_virtual(segtype) &&
-	    !_allocate(ah, vg, lv, (lv ? lv->le_count : 0) + extents,
-		       1, allocatable_pvs)) {
+	    !_allocate(ah, vg, lv, 1, allocatable_pvs)) {
 		alloc_destroy(ah);
 		return_NULL;
 	}
@@ -1354,8 +1363,7 @@ int lv_add_segment(struct alloc_handle *
 		   const struct segment_type *segtype,
 		   uint32_t stripe_size,
 		   uint64_t status,
-		   uint32_t region_size,
-		   struct logical_volume *log_lv)
+		   uint32_t region_size)
 {
 	if (!segtype) {
 		log_error("Missing segtype in lv_add_segment().");
@@ -1367,10 +1375,15 @@ int lv_add_segment(struct alloc_handle *
 		return 0;
 	}
 
+	if ((status & MIRROR_LOG) && dm_list_size(&lv->segments)) {
+		log_error("Log segments can only be added to an empty LV");
+		return 0;
+	}
+
 	if (!_setup_alloced_segments(lv, &ah->alloced_areas[first_area],
 				     num_areas, status,
 				     stripe_size, segtype,
-				     region_size, log_lv))
+				     region_size))
 		return_0;
 
 	if ((segtype->flags & SEG_CAN_SPLIT) && !lv_merge_segments(lv)) {
@@ -1546,34 +1559,11 @@ int lv_add_mirror_lvs(struct logical_vol
  */
 int lv_add_log_segment(struct alloc_handle *ah, struct logical_volume *log_lv)
 {
-	struct lv_segment *seg;
+	const char *segtype_name = ah->log_area_count > 1 ? "mirror" : "striped";
 
-	if (dm_list_size(&log_lv->segments)) {
-		log_error("Log segments can only be added to an empty LV");
-		return 0;
-	}
-
-	if (!(seg = alloc_lv_segment(log_lv->vg->cmd->mem,
-				     get_segtype_from_string(log_lv->vg->cmd,
-							     "striped"),
-				     log_lv, 0, ah->log_area.len, MIRROR_LOG,
-				     0, NULL, 1, ah->log_area.len, 0, 0, 0))) {
-		log_error("Couldn't allocate new mirror log segment.");
-		return 0;
-	}
-
-	if (!set_lv_segment_area_pv(seg, 0, ah->log_area.pv, ah->log_area.pe))
-		return_0;
-
-	dm_list_add(&log_lv->segments, &seg->list);
-	log_lv->le_count += ah->log_area.len;
-	log_lv->size += (uint64_t) log_lv->le_count * log_lv->vg->extent_size;
-
-	if (log_lv->vg->fid->fmt->ops->lv_setup &&
-	    !log_lv->vg->fid->fmt->ops->lv_setup(log_lv->vg->fid, log_lv))
-		return_0;
-
-	return 1;
+	return lv_add_segment(ah, ah->area_count, ah->log_area_count, log_lv,
+			      get_segtype_from_string(log_lv->vg->cmd, segtype_name),
+			      0, MIRROR_LOG, 0);
 }
 
 static int _lv_extend_mirror(struct alloc_handle *ah,
@@ -1595,7 +1585,7 @@ static int _lv_extend_mirror(struct allo
 		if (!lv_add_segment(ah, m++, 1, seg_lv(seg, s),
 				    get_segtype_from_string(lv->vg->cmd,
 							    "striped"),
-				    0, 0, 0, NULL)) {
+				    0, 0, 0)) {
 			log_error("Aborting. Failed to extend %s.",
 				  seg_lv(seg, s)->name);
 			return 0;
@@ -1633,7 +1623,7 @@ int lv_extend(struct logical_volume *lv,
 
 	if (mirrors < 2)
 		r = lv_add_segment(ah, 0, ah->area_count, lv, segtype,
-				   stripe_size, status, 0, NULL);
+				   stripe_size, status, 0);
 	else
 		r = _lv_extend_mirror(ah, lv, extents, 0);
 
Index: LVM2/lib/metadata/mirror.c
===================================================================
--- LVM2.orig/lib/metadata/mirror.c
+++ LVM2/lib/metadata/mirror.c
@@ -1202,7 +1202,7 @@ static int _create_mimage_lvs(struct all
 		if (!lv_add_segment(ah, m, 1, img_lvs[m],
 				    get_segtype_from_string(lv->vg->cmd,
 							    "striped"),
-				    0, 0, 0, NULL)) {
+				    0, 0, 0)) {
 			log_error("Aborting. Failed to add mirror image segment "
 				  "to %s. Remove new LV and retry.",
 				  img_lvs[m]->name);
