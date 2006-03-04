From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] Add metadata writing and hot spare processing to
 hostraid driver in dmraid
Date: Fri, 03 Mar 2006 16:57:20 -0800
Message-ID: <4408E5F0.50208@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030404030305080506070002"
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
To: ataraid-list@redhat.com, dm-devel@redhat.com, Chris McDermott <lcm@us.ibm.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------030404030305080506070002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

Now that dmraid supports Adaptec HostRAID, I've turned my attention to 
enabling support for writing metadata back to the disks, and 
implementing rudimentary spare handling in RAID1 configurations.

The attached patch (which is admittedly very rough) does two key things. 
  First, it implements asr_write in a more meaningful manner than what's 
in rc10 right now; with that part of the patch, dmraid gains the ability 
to reconfigure an array while the system is running and save the changes 
out to disk.  To do this, I had to change a struct to a pointer to a 
struct in asr_reservedblock to to get write_metadata to work properly. 
Also, it turns out that a few more things in asr_write had to happen 
(and in the correct order) for writes to succeed.  If we fail to write 
the metadata correctly, the HostRAID BIOS wipes the entire sector during 
the next reboot.

The second part of the patch stores spare devices in a dummy .asr_spares 
array.  When an I/O error is noticed (via event_io), a suitable spare 
drive is pulled from the spare pool and inserted into the failing array.
I haven't had a chance to test this code rigorously yet, because the 
dmeventd portions of dmraid aren't implemented yet.

So, there are two things that I'd like to see added: online 
reconfiguration support in dmraid (which I can now test via asr_write) 
and online spare handling.  Heinz, are you working on either of these 
features, or should I start writing them?

--D

--------------030404030305080506070002
Content-Type: text/x-patch;
 name="dmraid-asr_7.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmraid-asr_7.patch"

diff -Naurp v7.orig/lib/format/ataraid/asr.c v7/lib/format/ataraid/asr.c
--- v7.orig/lib/format/ataraid/asr.c	2006-02-17 09:26:44.000000000 -0800
+++ v7/lib/format/ataraid/asr.c	2006-03-03 16:28:34.000000000 -0800
@@ -22,6 +22,10 @@
 
 static const char *handler = HANDLER;
 
+#define SPARE_ARRAY	".asr_spares"
+
+static int asr_write(struct lib_context *lc,  struct raid_dev *rd, int erase);
+
 /* Map ASR disk status to dmraid status */
 static enum status disk_status(struct asr_raid_configline *disk) {
 	if (disk == NULL)
@@ -54,9 +58,9 @@ static struct asr_raid_configline *get_c
 {
 	unsigned int i;
 	
-	for (i = 0; i < asr->rt.elmcnt; i++) {
-		if (asr->rt.ent[i].raidmagic == magic)
-			return asr->rt.ent + i;
+	for (i = 0; i < asr->rt->elmcnt; i++) {
+		if (asr->rt->ent[i].raidmagic == magic)
+			return asr->rt->ent + i;
 	}
 
 	return NULL;
@@ -152,8 +156,9 @@ static void to_cpu(void *meta, unsigned 
 {
 	int i;
 	struct asr *asr = meta;
-	int elmcnt = asr->rt.elmcnt;
-	int use_old_elmcnt = (asr->rt.ridcode == RVALID2);
+	int elmcnt = asr->rt->elmcnt;
+
+	int use_old_elmcnt = (asr->rt->ridcode == RVALID2);
 
 	if (cvt & ASR_BLOCK) {
 		CVT32(asr->rb.b0idcode);
@@ -169,30 +174,30 @@ static void to_cpu(void *meta, unsigned 
 	}
 
 	if (cvt & ASR_TABLE) {
-		CVT32(asr->rt.ridcode);
-		CVT32(asr->rt.rversion);
-		CVT16(asr->rt.maxelm);
-		CVT16(asr->rt.elmcnt);
+		CVT32(asr->rt->ridcode);
+		CVT32(asr->rt->rversion);
+		CVT16(asr->rt->maxelm);
+		CVT16(asr->rt->elmcnt);
 		if (!use_old_elmcnt)
-			elmcnt = asr->rt.elmcnt;
-		CVT16(asr->rt.elmsize);
-		CVT32(asr->rt.raidFlags);
-		CVT32(asr->rt.timestamp);
-		CVT16(asr->rt.rchksum);
-		CVT32(asr->rt.sparedrivemagic);
-		CVT32(asr->rt.raidmagic);
-		CVT32(asr->rt.verifyDate);
-		CVT32(asr->rt.recreateDate);
+			elmcnt = asr->rt->elmcnt;
+		CVT16(asr->rt->elmsize);
+		CVT32(asr->rt->raidFlags);
+		CVT32(asr->rt->timestamp);
+		CVT16(asr->rt->rchksum);
+		CVT32(asr->rt->sparedrivemagic);
+		CVT32(asr->rt->raidmagic);
+		CVT32(asr->rt->verifyDate);
+		CVT32(asr->rt->recreateDate);
 
 		/* Convert the first seven config lines */
 		for (i = 0; i < (elmcnt < 7 ? elmcnt : 7); i++) 
-			cvt_configline(asr->rt.ent + i);
+			cvt_configline(asr->rt->ent + i);
 		
 	}
 
 	if (cvt & ASR_EXTTABLE) {
 		for (i = 7; i < elmcnt; i++) {
-			cvt_configline(asr->rt.ent + i);
+			cvt_configline(asr->rt->ent + i);
 		}
 	}
 }
@@ -201,17 +206,32 @@ static void to_cpu(void *meta, unsigned 
 # define to_cpu(x, y)
 #endif
 
+/* Compute the checksum of RAID metadata */
+static unsigned int compute_checksum(struct asr *asr)
+{
+	uint8_t *ptr;
+	unsigned int i, checksum;
+
+	/* Compute checksum. */
+	ptr = (uint8_t*) asr->rt->ent;
+	checksum = 0;
+	for (i = 0; i < sizeof(*asr->rt->ent) * asr->rt->elmcnt; i++)
+		checksum += ptr[i];
+
+	return checksum & 0xFFFF;
+}
+
+/* Read extended metadata areas */
 static int read_extended(struct lib_context *lc, struct dev_info *di,
 			 struct asr *asr)
 {
-	unsigned int remaining, i, checksum;
+	unsigned int remaining, i, chk;
 	int j;
-	uint8_t *ptr;
 
 	log_info(lc, "%s: reading extended data", di->path);
 	
 	/* Read the RAID table. */
-	if (!read_file(lc, handler, di->path, &asr->rt, ASR_DISK_BLOCK_SIZE,
+	if (!read_file(lc, handler, di->path, asr->rt, ASR_DISK_BLOCK_SIZE,
 		       (uint64_t) asr->rb.raidtbl * ASR_DISK_BLOCK_SIZE))
 		LOG_ERR(lc, 0, "%s: Could not read metadata.", handler);
 
@@ -219,24 +239,25 @@ static int read_extended(struct lib_cont
 	to_cpu(asr, ASR_TABLE);
 	
 	/* Is this ok? */
-	if (asr->rt.ridcode != RVALID2)
-		LOG_ERR(lc, 0, "%s: Invalid magic number in RAID table.",
-			handler);
+	if (asr->rt->ridcode != RVALID2)
+		LOG_ERR(lc, 0, "%s: Invalid magic number in RAID table; "
+			"saw 0x%X, expected 0x%X.", handler, asr->rt->ridcode,
+			RVALID2);
 
 	/* Have we a valid element count? */
-	if (asr->rt.elmcnt >= asr->rt.maxelm)
+	if (asr->rt->elmcnt >= asr->rt->maxelm)
 		LOG_ERR(lc, 0, "%s: Invalid RAID config table count.\n",
 			handler);
 
 	/* Is each element the right size? */
-	if (asr->rt.elmsize != sizeof(struct asr_raid_configline))
+	if (asr->rt->elmsize != sizeof(struct asr_raid_configline))
 		LOG_ERR(lc, 0, "%s: RAID config line is the wrong size.\n",
 			handler);
 
 	/* Figure out how much else we need to read. */
-	if (asr->rt.elmcnt > 7) {
-		remaining = asr->rt.elmsize * (asr->rt.elmcnt - 7);
-		if (!read_file(lc, handler, di->path, asr->rt.ent + 7,
+	if (asr->rt->elmcnt > 7) {
+		remaining = asr->rt->elmsize * (asr->rt->elmcnt - 7);
+		if (!read_file(lc, handler, di->path, asr->rt->ent + 7,
 			       remaining, (uint64_t)(asr->rb.raidtbl + 1) *
 			       ASR_DISK_BLOCK_SIZE))
 			return 0;
@@ -244,21 +265,14 @@ static int read_extended(struct lib_cont
 		to_cpu(asr, ASR_EXTTABLE);
 	}
 
-	/* Compute checksum. */
-	ptr = (uint8_t*) asr->rt.ent;
-	checksum = 0;
-	for (i = 0; i < sizeof(*asr->rt.ent) * asr->rt.elmcnt; i++)
-		checksum += ptr[i];
-
-	checksum &= 0xFFFF;
-
-	if (checksum != asr->rt.rchksum)
+	chk = compute_checksum(asr);
+	if (chk != asr->rt->rchksum)
 		LOG_ERR(lc, 0,"%s: Invalid RAID config table checksum "
 			       "(0x%X vs. 0x%X).",
-			handler, checksum, asr->rt.rchksum);
+			handler, chk, asr->rt->rchksum);
 	
 	/* Process the name of each line of the config line. */
-	for (i = 0; i < asr->rt.elmcnt; i++) {
+	for (i = 0; i < asr->rt->elmcnt; i++) {
 		/* 
 		 * Weird quirks of the name field of the config line:
 		 *
@@ -281,14 +295,15 @@ static int read_extended(struct lib_cont
 		 *
 		 * This is nuts.
 		 */
-		if (!asr->rt.ent[i].name)
-			memcpy(asr->rt.ent[i].name, asr->rt.ent[0].name, 16);
+		if (!asr->rt->ent[i].name)
+			memcpy(asr->rt->ent[i].name, asr->rt->ent[0].name, 16);
 
 		/* Now truncate trailing whitespace in the name. */
 		for (j = 15; j >= 0; j--) {
-			if (asr->rt.ent[i].name[j] == ' ')
-				asr->rt.ent[i].name[j] = 0;
+			if (asr->rt->ent[i].name[j] != ' ')
+				break;
 		}
+		asr->rt->ent[i].name[j + 1] = 0;
 	}
 
 	return 1;
@@ -344,10 +359,13 @@ static void *read_metadata_areas(struct 
 	 * RAID table.  Everything else appears to be unused in v8.
 	 */
 	if (!(asr = alloc_private(lc, handler, sizeof(struct asr))))
-		goto out;
+		goto bad0;
+	
+	if (!(asr->rt = alloc_private(lc, handler, sizeof(struct asr_raidtable))))
+		goto bad1;
 
 	if (!read_file(lc, handler, di->path, &asr->rb, size, asr_sboffset))
-		goto bad;
+		goto bad2;
 
 	/*
 	 * Convert metadata and read in 
@@ -357,19 +375,23 @@ static void *read_metadata_areas(struct 
 	/* Check Signature and read optional extended metadata. */
 	if (!is_asr(lc, di, asr) ||
 	    !read_extended(lc, di, asr))
-		goto bad;
+		goto bad2;
 
 	/*
 	 * Now that we made sure that we have all the metadata, we exit.
 	 */
 	cl = this_disk(asr);
 	if (cl->raidstate == LSU_COMPONENT_STATE_FAILED)
-		goto bad;
+		goto bad2;
 
 	goto out;
 
-   bad:
+   bad2:
+	dbg_free(asr->rt);
+   bad1:
+	asr->rt = NULL;
 	dbg_free(asr);
+   bad0:
 	asr = NULL;
 
    out:
@@ -387,27 +409,17 @@ static void file_metadata_areas(struct l
 	
 	/*
 	 * NOTE: We could probably just register the last 17 sectors
-	 * of the drive in one big operation...
+	 * of the drive in one operation...
 	 */
-
 	/* Register the reserved block. */
 	file_metadata(lc, handler, di->path, &asr->rb, ASR_DISK_BLOCK_SIZE,
 		      ASR_CONFIGOFFSET);
 
 	/* Register the raid table. */
-	file_metadata(lc, handler, di->path, &asr->rt, ASR_DISK_BLOCK_SIZE,
+	file_metadata(lc, handler, di->path, asr->rt,
+		      ASR_DISK_BLOCK_SIZE * 16,
 		      (uint64_t)asr->rb.raidtbl * ASR_DISK_BLOCK_SIZE);
 
-	/*
-	 * Register the rest of the config table.  We need to register
-	 * all the space (i.e. maxelm), not just what we're using now.
-	 */
-	file_metadata(lc, handler, di->path, &asr->rt.ent[7],
-		      (asr->rt.maxelm-7) *
-		      sizeof(struct asr_raid_configline),
-		      (uint64_t)(asr->rb.raidtbl+1) *
-		      ASR_DISK_BLOCK_SIZE);
-
 	/* Record the device size if -D was specified. */
 	file_dev_size(lc, handler, di);
 }
@@ -459,12 +471,12 @@ static int find_toplevel(struct lib_cont
 {
 	int i, toplevel = -1;
 
-	for (i = 0; i < asr->rt.elmcnt; i++) {
-		if (asr->rt.ent[i].raidlevel == FWL)
+	for (i = 0; i < asr->rt->elmcnt; i++) {
+		if (asr->rt->ent[i].raidlevel == FWL)
 		{
 			toplevel = i;
 		}
-		else if (asr->rt.ent[i].raidlevel == FWL_2)
+		else if (asr->rt->ent[i].raidlevel == FWL_2)
 		{
 			toplevel = i;
 			break;
@@ -483,13 +495,13 @@ static struct asr_raid_configline *find_
 	int i, j;
 
 	/* This MUST be done backwards! */
-	for (i = asr->rt.elmcnt - 1; i > -1; i--) {
-		if (asr->rt.ent[i].raidmagic == asr->rb.drivemagic)
+	for (i = asr->rt->elmcnt - 1; i > -1; i--) {
+		if (asr->rt->ent[i].raidmagic == asr->rb.drivemagic)
 		{
 			for (j = i - 1; j > -1; j--) {
-				if (asr->rt.ent[j].raidlevel == FWL)
+				if (asr->rt->ent[j].raidlevel == FWL)
 				{
-					return &asr->rt.ent[j];
+					return &asr->rt->ent[j];
 				}
 			}
 		}
@@ -505,37 +517,214 @@ static char *js_name(struct lib_context 
 	return name(lc, META(rd, asr));
 }
 
+/* Find a replacement drive from the spare pool. */
+static struct raid_dev *find_spare(struct lib_context *lc,
+		                   struct raid_dev *dev)
+{
+	struct raid_set *spares;
+	struct raid_dev *spare;
+	struct asr *sasr;
+	struct asr_raid_configline *scl;
+	struct asr *asr = META(dev, asr);
+	struct asr_raid_configline *cl = this_disk(asr);
+
+	/* Find the spares */
+	spares = find_set(lc, LC_RS(lc), SPARE_ARRAY, FIND_TOP);
+	if (!spares)
+		LOG_ERR(lc, NULL, "No spares found.");
+
+	/*
+	 * FIXME: Instead of finding the first suitable spare,
+	 * look for the smallest drive that we can use as a
+	 * replacement.
+	 */
+	list_for_each_entry(spare, &spares->devs, devs) {
+		/* Is this spare big enough? */
+		sasr = META(spare, asr);
+		scl = this_disk(sasr);
+
+		if (scl->lcapcty >= cl->lcapcty)
+			return spare;
+	}
+
+	LOG_ERR(lc, NULL, "No suitably large spares found.");
+}
+
+/*
+ * Find the first operational drive in the raid set.
+ */
+static struct raid_dev *find_first_ok_drive(struct raid_set *rs)
+{
+	struct raid_dev *rd;
+	
+	list_for_each_entry(rd, &rs->devs, devs) {
+		if (S_OK(rd->status))
+			return rd;
+	}
+
+	return NULL;
+}
+
+/*
+ * Add an empty drive to this set and resync.
+ */
+static int add_empty_disk_to_set(struct lib_context *lc,
+				  struct raid_dev *empty,
+				  struct raid_set *rs)
+{
+	struct raid_dev *rd;
+	struct raid_dev *ok_drive;
+	struct asr *asr, *empty_asr;
+	struct asr_raid_configline *cl, *empty_cl;
+	uint16_t newseq;
+	int ret = 1;
+	unsigned int i;
+
+	/* Find an OK drive to copy */
+	ok_drive = find_first_ok_drive(rs);
+	if (!ok_drive)
+		LOG_ERR(lc, 0, "Refusing to add %s to non-OK array %s.",
+			  empty->di->path, rs->name);
+	
+	/* Check that there's enough space. */
+	asr = META(ok_drive, asr);
+	if (asr->rt->elmcnt >= asr->rt->maxelm)
+		LOG_ERR(lc, 0, "RAID config table of %s is too large to "
+			"add drive %s.\n", rs->name, ok_drive->di->path);
+
+	/* Update the empty disk's configline */
+	cl = this_disk(asr);
+	newseq = cl->raidseq + 1;
+	empty_asr = META(empty, asr);
+	empty_cl = this_disk(empty_asr);
+	
+	memcpy(empty_cl->name, cl->name, 16);
+	empty_cl->raidseq   = newseq;
+	empty_cl->raidlevel = cl->raidlevel;
+	empty_cl->raidtype  = cl->raidtype;
+	empty_cl->lcapcty   = cl->lcapcty;
+	empty_cl->strpsize  = cl->strpsize;
+	empty_cl->raidstate = LSU_COMPONENT_SUBSTATE_REBUILDING;
+	
+	/* Update each drive's config table with our data. */
+	list_for_each_entry(rd, &rs->devs, devs) {
+		asr = META(rd, asr);
+
+		/* Increment sequence number count for all other lines */
+		for (i = 0; i < asr->rt->elmcnt; i++) {
+			cl = asr->rt->ent + i;
+			cl->raidseq = newseq;
+		}
+
+		/* Add config line */
+		cl = asr->rt->ent + asr->rt->elmcnt;
+		memcpy(cl, empty_cl, sizeof(*cl));	
+		asr->rt->elmcnt++;
+		
+		/* Write metadata */
+		ret &= asr_write(lc, rd, 0);
+	}
+
+	/* Copy config lines from ok drive to empty. */
+	memcpy(empty_asr->rt->ent, asr->rt->ent, sizeof(*cl) * asr->rt->elmcnt);
+	empty_asr->rt->elmcnt = asr->rt->elmcnt;
+	
+	/* Set empty drive to resync */
+	empty->status = s_inconsistent;
+
+	/* Write metadata */
+	ret &= asr_write(lc, empty, 0);
+	
+	/* Add to set */
+	list_add_sorted(lc, &rs->devs, &empty->devs, dev_sort);
+
+	/* FIXME: Tell dmraid that we hot-added a spare. */
+
+	return ret;
+}
+
 /*
  * IO error event handler.
  */
 static int event_io(struct lib_context *lc, struct event_io *e_io)
 {
 	struct raid_dev *rd = e_io->rd;
+	struct raid_set *rs = e_io->rs;
 	struct asr *asr = META(rd, asr);
 	struct asr_raid_configline *cl = this_disk(asr);
 	struct asr_raid_configline *fwl = find_logical(asr);
+	struct raid_dev *spare;
+
+#ifdef DEBUG_WRITE
+	/* XXX: This is a hack to test asr_write! */
+	if (e_io->sector == 0xFEED) {
+		asr_write(lc, rd, 0);
+		return 0;
+	}
+#endif
 
 	/* Ignore if we've already marked this disk broken(?) */
 	if (rd->status & s_broken)
 		return 0;
 	
-	log_err(lc, "I/O error on device %s at sector %lu.\n",
+	log_err(lc, "I/O error on device %s at sector %lu.",
 		e_io->rd->di->path, e_io->sector);
 
 	/* Mark the array as degraded and the disk as failed. */
 	rd->status = s_broken;
 	cl->raidstate = LSU_COMPONENT_STATE_FAILED;
 	fwl->raidstate = LSU_COMPONENT_STATE_DEGRADED;
-	/* FIXME: Do we have to mark a parent too? */
+	/* FIXME: Do we have to mark a FWL2 parent too? */
+
+	/*
+	 * If this set isn't RAID1, we can't recover.  If we ever support
+	 * RAID5, we'll have to augment this.
+	 */
+	if (rs->type != t_raid1)
+		LOG_ERR(lc, 1, "Can't replace failed disk %s.",
+			rd->di->path);
+
+	/* Find ourselves a spare disk. */
+	spare = find_spare(lc, rd);
+	if (!spare)
+		return 1;
+
+	/* Remove the spare from the spare array. */
+	list_del(&spare->devs);
+	
+	/* Now add the disk to the array... somehow. */
+	log_err(lc, "Replacing failed device %s with %s.\n",
+		rd->di->path, spare->di->path);
+	add_empty_disk_to_set(lc, spare, rs);
 
 	/* Indicate that this is indeed a failure. */
 	return 1;
 }
 
+/*
+ * Add an ASR device to a RAID set, and resync the drives as required.
+ */
+static int add_drive_to_set(struct lib_context *lc, struct raid_dev *rd,
+			    struct raid_set *rs)
+{
+	struct raid_dev *ok_device;
+
+	/* If we can't find an OK drive, add ourself as-is. */
+	if ((ok_device = find_first_ok_drive(rs)) == NULL)
+		goto out;
+
+out:
+	list_add_sorted(lc, &rs->devs, &rd->devs, dev_sort);
+
+	return 1;
+}
+
 /* 
- * Add an ASR device to a RAID set.  This involves finding the raid set to
- * which this disk belongs, and then attaching it.  Note that there are other
- * complications, such as two-layer arrays (RAID10).
+ * Attach a device to a RAID set, and build whatever set hierarchy is needed.
+ * This involves finding the raid set to which this disk belongs, and then
+ * attaching it.  The actual attachment and resync work is outsourced to a
+ * helper function.  Note that there are other complications, such as
+ * two-layer arrays (RAID10) that make this less than trivial.
  */
 #define BUFSIZE 128
 static struct raid_set *asr_group(struct lib_context *lc, struct raid_dev *rd)
@@ -547,6 +736,37 @@ static struct raid_set *asr_group(struct
 	struct raid_set *set, *sset;
 	char buf[BUFSIZE];
 
+	if (T_SPARE(rd)) {
+		/*
+		 * If this drive really _is_ attached to a specific
+		 * RAID set, then just attach it.  Really old HostRAID cards
+		 * do this... but I don't have any hardware to test this.
+		 */
+		/*
+		 * FIXME: dmraid ignores spares attached to RAID arrays.
+		 * For now, we'll let it get sucked into the ASR spare pool. 
+		 * If we need it, we'll reconfigure it; if not, nobody touches
+		 * it.
+		 *
+		set = find_set(lc, name(lc, asr), FIND_TOP, rd, LC_RS(lc),
+			       NO_CREATE, NO_CREATE_ARG);
+		 */
+
+		/* Otherwise, make a global spare pool. */
+		set = find_or_alloc_raid_set(lc, (char*)SPARE_ARRAY,
+			FIND_TOP, rd, LC_RS(lc), NO_CREATE, NO_CREATE_ARG);
+
+		/*
+		 * Setting the type to t_spare guarantees that dmraid won't
+		 * try to set up a real device-mapper mapping.
+		 */
+		set->type = t_spare;
+
+		/* Add the disk to the set. */
+		list_add_sorted(lc, &set->devs, &rd->devs, dev_sort);
+		return set;
+	}
+
 	/* Find the top level FWL/FWL2 for this device. */
 	top_idx = find_toplevel(lc, asr);
 	if (top_idx < 0) {
@@ -556,7 +776,7 @@ static struct raid_set *asr_group(struct
 	}
 
 	/* This is a simple RAID0/1 array.  Find the set. */
-	if (asr->rt.ent[top_idx].raidlevel == FWL)
+	if (asr->rt->ent[top_idx].raidlevel == FWL)
 	{
 		set = find_or_alloc_raid_set(lc, name(lc, asr),
 			FIND_TOP, rd, LC_RS(lc), NO_CREATE, NO_CREATE_ARG);
@@ -565,6 +785,32 @@ static struct raid_set *asr_group(struct
 		set->status = s_ok;
 		set->type = type(find_logical(asr));
 
+/* Trigger a metadata write */
+#ifdef DEBUG_WRITE
+if (1) //strcmp("/dev/sde", rd->di->path) == 0)
+{
+	struct event_io eio;
+	eio.rs = set;
+	eio.rd = rd;
+	eio.sector = 0xFEED;
+
+	event_io(lc, &eio);
+}
+#endif
+
+/* Trigger a fake I/O error */
+#if 0
+if (strcmp("/dev/sde", rd->di->path) == 0)
+{
+	struct event_io eio;
+	eio.rs = set;
+	eio.rd = rd;
+	eio.sector = 50;
+
+	event_io(lc, &eio);
+}
+#endif
+	
 		/* Add the disk to the set. */
 		list_add_sorted(lc, &set->devs, &rd->devs, dev_sort);
 		
@@ -576,7 +822,7 @@ static struct raid_set *asr_group(struct
 	 * parent set; create it if necessary.  Then, find the top-level set
 	 * and use join_superset to attach the parent set to the top set.
 	 */
-	if (asr->rt.ent[top_idx].raidlevel == FWL_2)
+	if (asr->rt->ent[top_idx].raidlevel == FWL_2)
 	{
 		/* First compute the name of the disk's direct parent. */
 		fwl = find_logical(asr);
@@ -606,7 +852,7 @@ static struct raid_set *asr_group(struct
 
 		sset->stride = stride(cl);
 		sset->status = s_ok;
-		sset->type = type(&asr->rt.ent[top_idx]);
+		sset->type = type(&asr->rt->ent[top_idx]);
 
 		return sset;
 	}
@@ -618,12 +864,43 @@ static struct raid_set *asr_group(struct
 /* Write metadata. */
 static int asr_write(struct lib_context *lc,  struct raid_dev *rd, int erase)
 {
-	int ret;
+	int ret, i, j;
         struct asr *asr = META(rd, asr);
+	int elmcnt = asr->rt->elmcnt;
+
+#ifdef DEBUG_WRITE
+	log_info(lc, "Writing ASR metadata to %s.\n", rd->di->path);
+#endif
 
+	/* Untruncate trailing whitespace in the name. */
+	for (i = 0; i < elmcnt; i++) {
+		for (j = 15; j >= 0; j--) {
+			if (asr->rt->ent[i].name[j] == 0)
+				break;
+		}
+		asr->rt->ent[i].name[j] = ' ';
+	}
+
+	/* Compute checksum */
+	asr->rt->rchksum = compute_checksum(asr);
+
+	/* Convert back to disk format */
         to_disk(asr, ASR_BLOCK | ASR_TABLE | ASR_EXTTABLE);
+
+	/* Write data */
         ret = write_metadata(lc, handler, rd, -1, erase);
+	
+	/* Go back to CPU format */
         to_cpu(asr, ASR_BLOCK | ASR_TABLE | ASR_EXTTABLE);
+ 
+	/* Truncate trailing whitespace in the name. */
+	for (i = 0; i < elmcnt; i++) {
+		for (j = 15; j >= 0; j--) {
+			if (asr->rt->ent[i].name[j] != ' ')
+				break;
+		}
+		asr->rt->ent[i].name[j + 1] = 0;
+	}
 
         return ret;
 }
@@ -742,7 +1019,7 @@ static void asr_log(struct lib_context *
 
 	log_print(lc, "%s (%s):", rd->di->path, handler);
 	dump_rb(lc, &asr->rb);
-	dump_rt(lc, &asr->rt);
+	dump_rt(lc, asr->rt);
 }
 #endif
 
@@ -781,11 +1058,11 @@ static int setup_rd(struct lib_context *
 		LOG_ERR(lc, 0, "%s: Could not find current disk!\n",
 			handler);		
 
-	/* We need three metadata areas */
-	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 3)))
+	/* We need two metadata areas */
+	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 2)))
 		return 0;
 
-	/* First area: reserved block. */
+	/* First area: raid reserved block. */
 	ma = rd->meta_areas;
 	ma->offset = ASR_CONFIGOFFSET >> 9;
 	ma->size = ASR_DISK_BLOCK_SIZE;
@@ -794,14 +1071,8 @@ static int setup_rd(struct lib_context *
 	/* Second area: raid table. */
 	ma++;
 	ma->offset = asr->rb.raidtbl;
-	ma->size = ASR_DISK_BLOCK_SIZE;
-	ma->area = (void*) asr;
-
-	/* Third area: raid config table. */
-	ma++;
-	ma->offset = asr->rb.raidtbl + 1;
-	ma->size = 15 * ASR_DISK_BLOCK_SIZE;
-	ma->area = (void*) asr;
+	ma->size = ASR_DISK_BLOCK_SIZE * 16;
+	ma->area = (void*) asr->rt;
 
 	/* Now set up the rest of the metadata info */
         rd->di = di;
diff -Naurp v7.orig/lib/format/ataraid/asr.h v7/lib/format/ataraid/asr.h
--- v7.orig/lib/format/ataraid/asr.h	2006-01-19 02:08:10.000000000 -0800
+++ v7/lib/format/ataraid/asr.h	2006-03-03 14:56:48.000000000 -0800
@@ -378,7 +378,7 @@ struct asr_reservedblock
 
 struct asr {
 	struct asr_reservedblock rb;
-	struct asr_raidtable rt;
+	struct asr_raidtable *rt;
 };
 
 #endif /* FORMAT_HANDLER */

--------------030404030305080506070002
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030404030305080506070002--
