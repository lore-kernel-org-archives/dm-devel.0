From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] multipath-tools: delete trailing spaces and
	tabs
Date: Tue, 14 Jun 2016 22:59:34 +0200
Message-ID: <1465937975-13055-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

diff --git a/Makefile.inc b/Makefile.inc
index ecc20ef..d7fc444 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -39,7 +39,7 @@ ifndef SYSTEMDPATH
 	SYSTEMDPATH=usr/lib
 endif
 
-prefix      = 
+prefix      =
 exec_prefix = $(prefix)
 bindir      = $(exec_prefix)/sbin
 libudevdir  = $(prefix)/$(SYSTEMDPATH)/udev
diff --git a/kpartx/crc32.c b/kpartx/crc32.c
index 42d803d..cfbe8a5 100644
--- a/kpartx/crc32.c
+++ b/kpartx/crc32.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * crc32.c
  * This code is in the public domain; copyright abandoned.
  * Liability for non-performance of this code is limited to the amount
@@ -48,7 +48,7 @@
  *        other uses, or the previous crc32 value if computing incrementally.
  * @p   - pointer to buffer over which CRC is run
  * @len - length of buffer @p
- * 
+ *
  */
 uint32_t attribute((pure)) crc32_le(uint32_t crc, unsigned char const *p, size_t len)
 {
@@ -106,7 +106,7 @@ crc32cleanup_le(void)
  *        other uses, or the previous crc32 value if computing incrementally.
  * @p   - pointer to buffer over which CRC is run
  * @len - length of buffer @p
- * 
+ *
  */
 uint32_t attribute((pure)) crc32_le(uint32_t crc, unsigned char const *p, size_t len)
 {
@@ -151,7 +151,7 @@ uint32_t attribute((pure)) crc32_le(uint32_t crc, unsigned char const *p, size_t
  *        other uses, or the previous crc32 value if computing incrementally.
  * @p   - pointer to buffer over which CRC is run
  * @len - length of buffer @p
- * 
+ *
  */
 uint32_t attribute((pure)) crc32_be(uint32_t crc, unsigned char const *p, size_t len)
 {
@@ -209,7 +209,7 @@ crc32cleanup_be(void)
  *        other uses, or the previous crc32 value if computing incrementally.
  * @p   - pointer to buffer over which CRC is run
  * @len - length of buffer @p
- * 
+ *
  */
 uint32_t attribute((pure)) crc32_be(uint32_t crc, unsigned char const *p, size_t len)
 {
@@ -340,7 +340,7 @@ uint32_t attribute((pure)) crc32_be(uint32_t crc, unsigned char const *p, size_t
  * in the correct multiple to subtract, we can shift a byte at a time.
  * This produces a 40-bit (rather than a 33-bit) intermediate remainder,
  * but again the multiple of the polynomial to subtract depends only on
- * the high bits, the high 8 bits in this case.  
+ * the high bits, the high 8 bits in this case.
  *
  * The multile we need in that case is the low 32 bits of a 40-bit
  * value whose high 8 bits are given, and which is a multiple of the
@@ -362,7 +362,7 @@ uint32_t attribute((pure)) crc32_be(uint32_t crc, unsigned char const *p, size_t
 
 /**
  * init_crc32(): generates CRC32 tables
- * 
+ *
  * On successful initialization, use count is increased.
  * This guarantees that the library functions will stay resident
  * in memory, and prevents someone from 'rmmod crc32' while
diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index 14c35b1..ef13709 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -65,7 +65,7 @@ typedef unsigned int __attribute__((__may_alias__)) label_ints_t;
 
 /*
  */
-int 
+int
 read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 {
 	int retval = -1;
diff --git a/kpartx/dasd.h b/kpartx/dasd.h
index 6fa64e6..1f6c99f 100644
--- a/kpartx/dasd.h
+++ b/kpartx/dasd.h
@@ -27,33 +27,33 @@
 #ifndef _DASD_H
 #define _DASD_H
 
-typedef struct ttr 
+typedef struct ttr
 {
         uint16_t tt;
         uint8_t  r;
 } __attribute__ ((packed)) ttr_t;
 
-typedef struct cchhb 
+typedef struct cchhb
 {
         uint16_t cc;
         uint16_t hh;
         uint8_t b;
 } __attribute__ ((packed)) cchhb_t;
 
-typedef struct cchh 
+typedef struct cchh
 {
         uint16_t cc;
         uint16_t hh;
 } __attribute__ ((packed)) cchh_t;
 
-typedef struct labeldate 
+typedef struct labeldate
 {
         uint8_t  year;
         uint16_t day;
 } __attribute__ ((packed)) labeldate_t;
 
 
-typedef struct volume_label 
+typedef struct volume_label
 {
         char volkey[4];         /* volume key = volume label                 */
 	char vollbl[4];	        /* volume label                              */
@@ -73,7 +73,7 @@ typedef struct volume_label
 } __attribute__ ((packed)) volume_label_t;
 
 
-typedef struct extent 
+typedef struct extent
 {
         uint8_t  typeind;          /* extent type indicator                     */
         uint8_t  seqno;            /* extent sequence number                    */
@@ -82,7 +82,7 @@ typedef struct extent
 } __attribute__ ((packed)) extent_t;
 
 
-typedef struct dev_const 
+typedef struct dev_const
 {
         uint16_t DS4DSCYL;           /* number of logical cyls                  */
         uint16_t DS4DSTRK;           /* number of tracks in a logical cylinder  */
@@ -97,7 +97,7 @@ typedef struct dev_const
 } __attribute__ ((packed)) dev_const_t;
 
 
-typedef struct format1_label 
+typedef struct format1_label
 {
 	char  DS1DSNAM[44];       /* data set name                           */
 	uint8_t  DS1FMTID;           /* format identifier                       */
@@ -243,12 +243,12 @@ static unsigned char EBCtoASC[256] =
 	0x38, 0x39, 0x07, 0x07, 0x9A, 0x07, 0x07, 0x07
 };
 
-static inline void 
+static inline void
 vtoc_ebcdic_dec (const char *source, char *target, int l)
 {
 	int i;
 
-	for (i = 0; i < l; i++) 
+	for (i = 0; i < l; i++)
 		target[i]=(char)EBCtoASC[(unsigned char)(source[i])];
 }
 
diff --git a/kpartx/dos.c b/kpartx/dos.c
index f252d0a..64b27b6 100644
--- a/kpartx/dos.c
+++ b/kpartx/dos.c
@@ -1,7 +1,7 @@
 /*
  * Source: copy of util-linux' partx dos.c
  *
- * Copyrights of the original file apply 
+ * Copyrights of the original file apply
  * Copyright (c) 2005 Bastian Blank
  */
 #include "kpartx.h"
diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index 5a54970..ef4092b 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -1,7 +1,7 @@
 /*
     gpt.[ch]
 
-    Copyright (C) 2000-2001 Dell Computer Corporation <Matt_Domsch@dell.com> 
+    Copyright (C) 2000-2001 Dell Computer Corporation <Matt_Domsch@dell.com>
 
     EFI GUID Partition Table handling
     Per Intel EFI Specification v1.02
@@ -77,7 +77,7 @@ struct blkdev_ioctl_param {
  * @len - length of buf
  *
  * Description: Returns EFI-style CRC32 value for @buf
- * 
+ *
  * This function uses the little endian Ethernet polynomial
  * but seeds the function with ~0, and xor's with ~0 at the end.
  * Note, the EFI Specification, v1.02, has a reference to
@@ -122,7 +122,7 @@ is_pmbr_valid(legacy_mbr *mbr)
  *  - filedes is an open file descriptor, suitable for reading
  * Modifies: nothing
  * Returns:
- *  Last LBA value on success 
+ *  Last LBA value on success
  *  0 on error
  *
  * Try getting BLKGETSIZE64 and BLKSSZGET first,
@@ -146,9 +146,9 @@ _get_num_sectors(int filedes)
 
 /************************************************************
  * last_lba(): return number of last logical block of device
- * 
+ *
  * @fd
- * 
+ *
  * Description: returns Last LBA value on success, 0 on error.
  * Notes: The value st_blocks gives the size of the file
  *        in 512-byte blocks, which is OK if
@@ -188,7 +188,7 @@ read_lastoddsector(int fd, uint64_t lba, void *buffer, size_t count)
         int rc;
         struct blkdev_ioctl_param ioctl_param;
 
-        if (!buffer) return 0; 
+        if (!buffer) return 0;
 
         ioctl_param.block = 0; /* read the last sector */
         ioctl_param.content_length = count;
@@ -229,7 +229,7 @@ read_lba(int fd, uint64_t lba, void *buffer, size_t bytes)
 /**
  * alloc_read_gpt_entries(): reads partition entries from disk
  * @fd  is an open file descriptor to the whole disk
- * @gpt is a buffer into which the GPT will be put  
+ * @gpt is a buffer into which the GPT will be put
  * Description: Returns ptes on success,  NULL on error.
  * Allocates space for PTEs based on information found in @gpt.
  * Notes: remember to free pte when you're done!
@@ -260,7 +260,7 @@ alloc_read_gpt_entries(int fd, gpt_header * gpt)
  * alloc_read_gpt_header(): Allocates GPT header, reads into it from disk
  * @fd  is an open file descriptor to the whole disk
  * @lba is the Logical Block Address of the partition table
- * 
+ *
  * Description: returns GPT header on success, NULL on error.   Allocates
  * and fills a GPT header starting at @ from @bdev.
  * Note: remember to free gpt when finished with it.
@@ -306,7 +306,7 @@ is_gpt_valid(int fd, uint64_t lba,
 
 	/* Check the GUID Partition Table signature */
 	if (__le64_to_cpu((*gpt)->signature) != GPT_HEADER_SIGNATURE) {
-		/* 
+		/*
 		   printf("GUID Partition Table Header signature is wrong: %" PRIx64" != %" PRIx64 "\n",
 		   __le64_to_cpu((*gpt)->signature), GUID_PT_HEADER_SIGNATURE);
 		 */
@@ -387,7 +387,7 @@ is_gpt_valid(int fd, uint64_t lba,
  * @lastlba is the last LBA number
  * Description: Returns nothing.  Sanity checks pgpt and agpt fields
  * and prints warnings on discrepancies.
- * 
+ *
  */
 static void
 compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
@@ -397,7 +397,7 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
 		return;
 	if (__le64_to_cpu(pgpt->my_lba) != __le64_to_cpu(agpt->alternate_lba)) {
 		error_found++;
-		fprintf(stderr, 
+		fprintf(stderr,
 		       "GPT:Primary header LBA != Alt. header alternate_lba\n");
 #ifdef DEBUG
 		fprintf(stderr,  "GPT:%" PRIx64 " != %" PRIx64 "\n",
@@ -407,7 +407,7 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
 	}
 	if (__le64_to_cpu(pgpt->alternate_lba) != __le64_to_cpu(agpt->my_lba)) {
 		error_found++;
-		fprintf(stderr, 
+		fprintf(stderr,
 		       "GPT:Primary header alternate_lba != Alt. header my_lba\n");
 #ifdef DEBUG
 		fprintf(stderr,  "GPT:%" PRIx64 " != %" PRIx64 "\n",
@@ -450,7 +450,7 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
 	if (__le32_to_cpu(pgpt->sizeof_partition_entry) !=
             __le32_to_cpu(agpt->sizeof_partition_entry)) {
 		error_found++;
-		fprintf(stderr, 
+		fprintf(stderr,
 		       "GPT:sizeof_partition_entry values don't match: "
 		       "0x%x != 0x%x\n",
                        __le32_to_cpu(pgpt->sizeof_partition_entry),
@@ -459,7 +459,7 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
 	if (__le32_to_cpu(pgpt->partition_entry_array_crc32) !=
             __le32_to_cpu(agpt->partition_entry_array_crc32)) {
 		error_found++;
-		fprintf(stderr, 
+		fprintf(stderr,
 		       "GPT:partition_entry_array_crc32 values don't match: "
 		       "0x%x != 0x%x\n",
                        __le32_to_cpu(pgpt->partition_entry_array_crc32),
@@ -467,7 +467,7 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
 	}
 	if (__le64_to_cpu(pgpt->alternate_lba) != lastlba) {
 		error_found++;
-		fprintf(stderr, 
+		fprintf(stderr,
 		       "GPT:Primary header thinks Alt. header is not at the end of the disk.\n");
 #ifdef DEBUG
 		fprintf(stderr,  "GPT:%" PRIx64 " != %" PRIx64 "\n",
@@ -477,7 +477,7 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
 
 	if (__le64_to_cpu(agpt->my_lba) != lastlba) {
 		error_found++;
-		fprintf(stderr, 
+		fprintf(stderr,
 		       "GPT:Alternate GPT header not at the end of the disk.\n");
 #ifdef DEBUG
 		fprintf(stderr,  "GPT:%" PRIx64 " != %" PRIx64 "\n",
@@ -486,7 +486,7 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
 	}
 
 	if (error_found)
-		fprintf(stderr, 
+		fprintf(stderr,
 		       "GPT: Use GNU Parted to correct GPT errors.\n");
 	return;
 }
@@ -560,7 +560,7 @@ find_valid_gpt(int fd, gpt_header ** gpt, gpt_entry ** ptes)
 
         /* Would fail due to bad PMBR, but force GPT anyhow */
         if ((good_pgpt || good_agpt) && !good_pmbr && force_gpt) {
-                fprintf(stderr, 
+                fprintf(stderr,
                        "  Warning: Disk has a valid GPT signature but "
                        "invalid PMBR.\n"
                        "  Use GNU Parted to correct disk.\n"
@@ -576,7 +576,7 @@ find_valid_gpt(int fd, gpt_header ** gpt, gpt_entry ** ptes)
                 if (agpt)  { free(agpt);   agpt = NULL; }
                 if (aptes) { free(aptes); aptes = NULL; }
                 if (!good_agpt) {
-                        fprintf(stderr, 
+                        fprintf(stderr,
 			       "Alternate GPT is invalid, "
                                "using primary GPT.\n");
                 }
@@ -587,7 +587,7 @@ find_valid_gpt(int fd, gpt_header ** gpt, gpt_entry ** ptes)
                 *ptes = aptes;
                 if (pgpt)  { free(pgpt);   pgpt = NULL; }
                 if (pptes) { free(pptes); pptes = NULL; }
-                fprintf(stderr, 
+                fprintf(stderr,
                        "Primary GPT is invalid, using alternate GPT.\n");
                 return 1;
         }
@@ -603,7 +603,7 @@ find_valid_gpt(int fd, gpt_header ** gpt, gpt_entry ** ptes)
 }
 
 /**
- * read_gpt_pt() 
+ * read_gpt_pt()
  * @fd
  * @all - slice with start/size of whole disk
  *
diff --git a/kpartx/gpt.h b/kpartx/gpt.h
index a073b42..1f35fa0 100644
--- a/kpartx/gpt.h
+++ b/kpartx/gpt.h
@@ -1,7 +1,7 @@
 /*
     gpt.[ch]
 
-    Copyright (C) 2000-2001 Dell Computer Corporation <Matt_Domsch@dell.com> 
+    Copyright (C) 2000-2001 Dell Computer Corporation <Matt_Domsch@dell.com>
 
     EFI GUID Partition Table handling
     Per Intel EFI Specification v1.02
@@ -76,15 +76,15 @@ typedef struct _gpt_entry {
 } __attribute__ ((packed)) gpt_entry;
 
 
-/* 
+/*
    These values are only defaults.  The actual on-disk structures
    may define different sizes, so use those unless creating a new GPT disk!
 */
 
 #define GPT_DEFAULT_RESERVED_PARTITION_ENTRY_ARRAY_SIZE 16384
-/* 
+/*
    Number of actual partition entries should be calculated
-   as: 
+   as:
 */
 #define GPT_DEFAULT_RESERVED_PARTITION_ENTRIES \
         (GPT_DEFAULT_RESERVED_PARTITION_ENTRY_ARRAY_SIZE / \
@@ -118,7 +118,7 @@ int read_gpt_pt (int fd, struct slice all, struct slice *sp, int ns);
  * of the file.
  * ---------------------------------------------------------------------------
  * Local variables:
- * c-indent-level: 4 
+ * c-indent-level: 4
  * c-brace-imaginary-offset: 0
  * c-brace-offset: -4
  * c-argdecl-indent: 4
diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index 021ddc0..7d1e71d 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -9,8 +9,8 @@ kpartx \- Create device maps from partition tables
 .RB wholedisk
 .SH DESCRIPTION
 This tool, derived from util-linux' partx, reads partition
-tables on specified device and create device maps over partitions 
-segments detected. It is called from hotplug upon device maps 
+tables on specified device and create device maps over partitions
+segments detected. It is called from hotplug upon device maps
 creation and deletion.
 .SH OPTIONS
 .TP
@@ -52,9 +52,9 @@ This will output lines such as:
 .IP
 loop3p1 : 0 20964762 /dev/loop3 63
 .PP
-The 
+The
 .I loop3p1
-is the name of a device file under 
+is the name of a device file under
 .I /dev/mapper
 which you can use to access the partition, for example to fsck it:
 .IP
diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 39add44..a160d29 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -285,7 +285,7 @@ set_loop (const char *device, const char *file, int offset, int *loopro)
 	return 0;
 }
 
-extern int 
+extern int
 del_loop (const char *device)
 {
 	int retries = 5;
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 59db73a..dd02158 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -10,21 +10,21 @@ DEVLIB = libmpathpersist.so
 LIBS = $(DEVLIB).$(SONAME)
 
 
-CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir) 
+CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
 LIBDEPS +=  -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath \
 	-L$(mpathcmddir) -lmpathcmd
 
-OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o 
+OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
 
 all: $(LIBS)
 
 
-$(LIBS): 
-	$(CC) -Wall -fPIC -c $(CFLAGS) *.c 
+$(LIBS):
+	$(CC) -Wall -fPIC -c $(CFLAGS) *.c
 	$(CC)  -shared $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
 	ln -s $(LIBS) $(DEVLIB)
-	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz	
-	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz	
+	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
+	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz
 
 install: $(LIBS)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
@@ -34,8 +34,8 @@ install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(incdir)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)/usr/share/doc/mpathpersist/
 	ln -sf $(DESTDIR)$(syslibdir)/$(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
-	install -m 644 mpath_persistent_reserve_in.3.gz $(DESTDIR)$(man3dir)	
-	install -m 644 mpath_persistent_reserve_out.3.gz $(DESTDIR)$(man3dir)	
+	install -m 644 mpath_persistent_reserve_in.3.gz $(DESTDIR)$(man3dir)
+	install -m 644 mpath_persistent_reserve_out.3.gz $(DESTDIR)$(man3dir)
 	install -m 644 mpath_persist.h $(DESTDIR)$(incdir)
 
 uninstall:
@@ -44,7 +44,7 @@ uninstall:
 	rm $(DESTDIR)$(man3dir)/mpath_persistent_reserve_out.3.gz
 
 clean:
-	rm -f core *.a *.o 
+	rm -f core *.a *.o
 	rm -f libmpathpersist.so.0
 	rm -f libmpathpersist.so
 	rm -f mpath_persistent_reserve_in.3.gz mpath_persistent_reserve_out.3.gz
diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index b23e116..819c3af 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -530,7 +530,7 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 				memcpy(&thread[i].param.paramp->key, &thread[i].param.paramp->sa_key, 8);
 				memset(&thread[i].param.paramp->sa_key, 0, 8);
 				thread[i].param.status = MPATH_PR_SUCCESS;
-				rc = pthread_create(&thread[i].id, &attr, mpath_prout_pthread_fn, 
+				rc = pthread_create(&thread[i].id, &attr, mpath_prout_pthread_fn,
 						(void *)(&thread[i].param));
 				if (rc){
 					condlog (0, "%s: failed to create thread for rollback. %d",  mpp->wwid, rc);
diff --git a/libmpathpersist/mpath_persistent_reserve_in.3 b/libmpathpersist/mpath_persistent_reserve_in.3
index c404e13..8601645 100644
--- a/libmpathpersist/mpath_persistent_reserve_in.3
+++ b/libmpathpersist/mpath_persistent_reserve_in.3
@@ -1,5 +1,5 @@
 .\"
-.TH MPATH_PERSISTENT_RESERVE_IN 3  2011-04-08 "Linux Manpage" 
+.TH MPATH_PERSISTENT_RESERVE_IN 3  2011-04-08 "Linux Manpage"
 .SH NAME
 mpath_persistent_reserve_in
 .SH SYNOPSIS
@@ -34,10 +34,10 @@ sends PRIN command to the DM device and gets the response.
 .I MPATH_PR_SUCCESS
 .B if PR command successful
 .br
-.I MPATH_PR_SYNTAX_ERROR        
+.I MPATH_PR_SYNTAX_ERROR
 .B if  syntax error or invalid parameter
 .br
-.I MPATH_PR_SENSE_NOT_READY     
+.I MPATH_PR_SENSE_NOT_READY
 .B  if command fails with [sk,asc,ascq: 0x2,*,*]
 .br
 .I MPATH_PR_SENSE_MEDIUM_ERROR
@@ -61,14 +61,14 @@ sends PRIN command to the DM device and gets the response.
 .I MPATH_PR_NO_SENSE
 .B  if command fails with [sk,asc,ascq: 0x0,*,*]
 .br
-.I MPATH_PR_SENSE_MALFORMED  
+.I MPATH_PR_SENSE_MALFORMED
 .B if command fails with SCSI command malformed
 .br
 .I MPATH_PR_FILE_ERROR
 .B if command fails while accessing file (device node) problems(e.g. not found)
 .br
 .I MPATH_PR_DMMP_ERROR
-.B if Device Mapper related error.(e.g Error in getting dm info) 
+.B if Device Mapper related error.(e.g Error in getting dm info)
 .br
 .I MPATH_PR_OTHER
 .B if other error/warning has occurred(e.g transport or driver error)
diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index f7f84ff..7e57d2b 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -1,5 +1,5 @@
 .\"
-.TH MPATH_PERSISTENT_RESERVE_OUT 3  2011-04-08 "Linux Manpage" 
+.TH MPATH_PERSISTENT_RESERVE_OUT 3  2011-04-08 "Linux Manpage"
 .SH NAME
 mpath_persistent_reserve_out
 .SH SYNOPSIS
@@ -14,7 +14,7 @@ sends PR OUT command to the DM device and gets the response.
 .br
 .BI Parameters:
 .br
-.I fd 
+.I fd
 .B The file descriptor of a multipath device. Input argument.
 .br
 .I rq_servact
@@ -43,10 +43,10 @@ sends PR OUT command to the DM device and gets the response.
 .I MPATH_PR_SUCCESS
 .B if PR command successful else returns any one of the status mentioned below
 .br
-.I MPATH_PR_SYNTAX_ERROR        
+.I MPATH_PR_SYNTAX_ERROR
 .B if  syntax error or invalid parameter
 .br
-.I MPATH_PR_SENSE_NOT_READY     
+.I MPATH_PR_SENSE_NOT_READY
 .B  if command fails with [sk,asc,ascq: 0x2,*,*]
 .br
 .I MPATH_PR_SENSE_MEDIUM_ERROR
@@ -70,7 +70,7 @@ sends PR OUT command to the DM device and gets the response.
 .I MPATH_PR_NO_SENSE
 .B  if command fails with [sk,asc,ascq: 0x0,*,*]
 .br
-.I MPATH_PR_SENSE_MALFORMED  
+.I MPATH_PR_SENSE_MALFORMED
 .B if command fails with SCSI command malformed
 .br
 .I MPATH_PR_RESERV_CONFLICT
@@ -80,7 +80,7 @@ sends PR OUT command to the DM device and gets the response.
 .B if command fails while accessing file (device node) problems(e.g. not found)
 .br
 .I MPATH_PR_DMMP_ERROR
-.B if Device Mapper related error.(e.g Error in getting dm info) 
+.B if Device Mapper related error.(e.g Error in getting dm info)
 .br
 .I MPATH_PR_OTHER
 .B if other error/warning has occurred(e.g transport or driver error)
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index c85fd10..5f80f66 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -64,7 +64,7 @@ int prout_do_scsi_ioctl(char * dev, int rq_servact, int rq_scope,
 	{
 		translen = format_transportids(paramp);
 		paramlen = 24 + translen;
-	}	
+	}
 	else
 		paramlen = 24;
 
@@ -75,7 +75,7 @@ int prout_do_scsi_ioctl(char * dev, int rq_servact, int rq_scope,
 	cdb[8] = (unsigned char)(paramlen & 0xff);
 
 retry :
-	condlog(3, "%s: rq_servact = %d", dev, rq_servact); 
+	condlog(3, "%s: rq_servact = %d", dev, rq_servact);
 	condlog(3, "%s: rq_scope = %d ", dev, rq_scope);
 	condlog(3, "%s: rq_type = %d ", dev, rq_type);
 	condlog(3, "%s: paramlen = %d", dev, paramlen);
@@ -119,7 +119,7 @@ retry :
 	if (status == MPATH_PR_SENSE_UNIT_ATTENTION && (retry > 0))
 	{
 		--retry;
-		condlog(2, "%s: retrying for Unit Attention. Remaining retries = %d", 
+		condlog(2, "%s: retrying for Unit Attention. Remaining retries = %d",
 			dev, retry);
 		goto retry;
 	}
@@ -134,13 +134,13 @@ retry :
 		goto retry;
 	}
 
-	close(fd);	
+	close(fd);
 	return status;
 }
 
 uint32_t  format_transportids(struct prout_param_descriptor *paramp)
 {
-	int i = 0, len;	
+	int i = 0, len;
 	uint32_t buff_offset = 4;
 	memset(paramp->private_buffer, 0, MPATH_MAX_PARAM_LEN);
 	for (i=0; i < paramp->num_transportid; i++ )
@@ -163,20 +163,20 @@ uint32_t  format_transportids(struct prout_param_descriptor *paramp)
 				break;
 			case MPATH_PROTOCOL_ID_ISCSI:
 				buff_offset += 1;
-				len = (paramp->trnptid_list[i]->iscsi_name[1] & 0xff)+2;	
+				len = (paramp->trnptid_list[i]->iscsi_name[1] & 0xff)+2;
 				memcpy(&paramp->private_buffer[buff_offset], &paramp->trnptid_list[i]->iscsi_name,len);
-				buff_offset += len ; 
+				buff_offset += len ;
 				break;
 		}
 
 	}
-	buff_offset -= 4; 
+	buff_offset -= 4;
 	paramp->private_buffer[0] = (unsigned char)((buff_offset >> 24) & 0xff);
 	paramp->private_buffer[1] = (unsigned char)((buff_offset >> 16) & 0xff);
 	paramp->private_buffer[2] = (unsigned char)((buff_offset >> 8) & 0xff);
 	paramp->private_buffer[3] = (unsigned char)(buff_offset & 0xff);
-	buff_offset += 4; 
-	return buff_offset;	
+	buff_offset += 4;
+	return buff_offset;
 }
 
 void mpath_format_readkeys( struct prin_resp *pr_buff, int len, int noisy)
@@ -400,7 +400,7 @@ out:
 
 int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr, SenseData_t Sensedata, int noisy)
 {
-	condlog(3, "%s: status driver:%02x host:%02x scsi:%02x", dev, 
+	condlog(3, "%s: status driver:%02x host:%02x scsi:%02x", dev,
 			io_hdr.driver_status, io_hdr.host_status ,io_hdr.status);
 	io_hdr.status &= 0x7e;
 	if ((0 == io_hdr.status) && (0 == io_hdr.host_status) &&
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 66b5123..1c0ad06 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -11,7 +11,7 @@
 /*
  * Tuning suggestions on these parameters should go to
  * dm-devel@redhat.com
- * 
+ *
  * You are welcome to claim maintainership over a controller
  * family. Please mail the currently enlisted maintainer and
  * the upstream package maintainer.
diff --git a/libmultipath/list.h b/libmultipath/list.h
index a0d8184..6d1e949 100644
--- a/libmultipath/list.h
+++ b/libmultipath/list.h
@@ -54,7 +54,7 @@ struct list_head {
 } while (0)
 
 /*
- * Insert a new entry between two known consecutive entries. 
+ * Insert a new entry between two known consecutive entries.
  *
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
@@ -128,7 +128,7 @@ static inline void list_del(struct list_head *entry)
 static inline void list_del_init(struct list_head *entry)
 {
 	__list_del(entry->prev, entry->next);
-	INIT_LIST_HEAD(entry); 
+	INIT_LIST_HEAD(entry);
 }
 
 /**
diff --git a/libmultipath/parser.h b/libmultipath/parser.h
index ba6859e..70697f4 100644
--- a/libmultipath/parser.h
+++ b/libmultipath/parser.h
@@ -1,10 +1,10 @@
-/* 
+/*
  * Soft:        Keepalived is a failover program for the LVS project
  *              <www.linuxvirtualserver.org>. It monitor & manipulate
  *              a loadbalanced server pool using multi-layer checks.
- * 
+ *
  * Part:        cfreader.c include file.
- *  
+ *
  * Version:     $Id: parser.h,v 1.0.3 2003/05/11 02:28:03 acassen Exp $
  *
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
diff --git a/libmultipath/pgpolicies.h b/libmultipath/pgpolicies.h
index 1f010a3..c0eaa7f 100644
--- a/libmultipath/pgpolicies.h
+++ b/libmultipath/pgpolicies.h
@@ -10,7 +10,7 @@
 #define POLICY_NAME_SIZE 32
 
 /* Storage controllers capabilities */
-enum iopolicies { 
+enum iopolicies {
 	IOPOLICY_UNDEF,
 	FAILOVER,
 	MULTIBUS,
diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index cd4aafc..90dfb71 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -9,7 +9,7 @@
  *
  * Author(s): Jan Kunigk
  *            S. Bader <shbader@de.ibm.com>
- * 
+ *
  * This file is released under the GPL.
  */
 #include <stdio.h>
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 636aae5..3293e4d 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -9,7 +9,7 @@
  *
  * Author(s): Jan Kunigk
  *            S. Bader <shbader@de.ibm.com>
- * 
+ *
  * This file is released under the GPL.
  */
 #include <stdio.h>
diff --git a/libmultipath/prioritizers/alua_rtpg.h b/libmultipath/prioritizers/alua_rtpg.h
index 91a15a4..b1b177a 100644
--- a/libmultipath/prioritizers/alua_rtpg.h
+++ b/libmultipath/prioritizers/alua_rtpg.h
@@ -9,7 +9,7 @@
  *
  * Author(s): Jan Kunigk
  *            S. Bader <shbader@de.ibm.com>
- * 
+ *
  * This file is released under the GPL.
  */
 #ifndef __RTPG_H__
diff --git a/libmultipath/prioritizers/alua_spc3.h b/libmultipath/prioritizers/alua_spc3.h
index e78b6c3..42d5ecf 100644
--- a/libmultipath/prioritizers/alua_spc3.h
+++ b/libmultipath/prioritizers/alua_spc3.h
@@ -9,7 +9,7 @@
  *
  * Author(s): Jan Kunigk
  *            S. Bader <shbader@de.ibm.com>
- * 
+ *
  * This file is released under the GPL.
  */
 #ifndef __SPC3_H__
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index 8043b5b..6346c71 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -6,15 +6,15 @@
  *
  * Prioritizer for Device Mapper Multipath and HDS Storage
  *
- * Hitachis Modular Storage contains two controllers for redundancy. The 
- * Storage internal LUN (LDEV) will normally allocated via two pathes to the 
- * server (one path per controller). For performance reasons should the server 
+ * Hitachis Modular Storage contains two controllers for redundancy. The
+ * Storage internal LUN (LDEV) will normally allocated via two pathes to the
+ * server (one path per controller). For performance reasons should the server
  * access to a LDEV only via one controller. The other path to the other
- * controller is stand-by. It is also possible to allocate more as one path 
- * for a LDEV per controller. Here is active/active access allowed. The other 
+ * controller is stand-by. It is also possible to allocate more as one path
+ * for a LDEV per controller. Here is active/active access allowed. The other
  * pathes via the other controller are stand-by.
  *
- * This prioritizer checks with inquiry command the represented LDEV and 
+ * This prioritizer checks with inquiry command the represented LDEV and
  * Controller number and gives back a priority followed by this scheme:
  *
  * CONTROLLER ODD  and LDEV  ODD: PRIORITY 1
@@ -22,19 +22,19 @@
  * CONTROLLER EVEN and LDEV  ODD: PRIORITY 0
  * CONTROLLER EVEN and LDEV EVEN: PRIORITY 1
  *
- * In the storage you can define for each LDEV a owner controller. If the 
- * server makes IOs via the other controller the storage will switch the 
- * ownership automatically. In this case you can see in the storage that the 
+ * In the storage you can define for each LDEV a owner controller. If the
+ * server makes IOs via the other controller the storage will switch the
+ * ownership automatically. In this case you can see in the storage that the
  * current controller is different from the default controller, but this is
  * absolutely no problem.
  *
- * With this prioritizer it is possible to establish a static load balancing. 
- * Half of the LUNs are accessed via one HBA/storage controller and the other 
+ * With this prioritizer it is possible to establish a static load balancing.
+ * Half of the LUNs are accessed via one HBA/storage controller and the other
  * half via the other HBA/storage controller.
  *
  * In cluster environmemnts (RAC) it also guarantees that all cluster nodes have
  * access to the LDEVs via the same controller.
- * 
+ *
  * You can run the prioritizer manually in verbose mode:
  * # pp_hds_modular -v 8:224
  * VENDOR:  HITACHI
@@ -50,7 +50,7 @@
  * Changes 2006-07-16:
  *         - Changed to forward declaration of functions
  *         - The switch-statement was changed to a logical expression
- *         - unlinking of the devpath now also occurs at the end of 
+ *         - unlinking of the devpath now also occurs at the end of
  *           hds_modular_prio to avoid old /tmp/.pp_balance.%u.%u.devnode
  *           entries in /tmp-Directory
  *         - The for-statements for passing variables where changed to
diff --git a/libmultipath/prioritizers/iet.c b/libmultipath/prioritizers/iet.c
index 0bcc48b..c8f161b 100644
--- a/libmultipath/prioritizers/iet.c
+++ b/libmultipath/prioritizers/iet.c
@@ -16,7 +16,7 @@
 // (It's a bit of a misnomer since supports the client side [eg. open-iscsi]
 //  instead of just "iet".)
 //
-// Usage: 
+// Usage:
 //   prio      "iet"
 //   prio_args "preferredip=10.11.12.13"
 //
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 8abe360..4111fa5 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -422,7 +422,7 @@ out:
 	 */
 	if (!strncmp(prio_name(p), PRIO_ALUA, PRIO_NAME_LEN)) {
 		int tpgs = 0;
-		if(!pp->tpgs && 
+		if(!pp->tpgs &&
 		   (tpgs = get_target_port_group_support(pp->fd)) >= 0)
 			pp->tpgs = tpgs;
 	}
diff --git a/libmultipath/vector.h b/libmultipath/vector.h
index 7612b4c..5cfd4d0 100644
--- a/libmultipath/vector.h
+++ b/libmultipath/vector.h
@@ -1,10 +1,10 @@
-/* 
+/*
  * Soft:        Keepalived is a failover program for the LVS project
  *              <www.linuxvirtualserver.org>. It monitor & manipulate
  *              a loadbalanced server pool using multi-layer checks.
- * 
+ *
  * Part:        vector.c include file.
- *  
+ *
  * Version:     $Id: vector.h,v 1.0.3 2003/05/11 02:28:03 acassen Exp $
  *
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index 6f7a5cf..42a0830 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -2,9 +2,9 @@
 #
 include ../Makefile.inc
 
-OBJS = main.o 
+OBJS = main.o
 
-CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) 
+CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
 LDFLAGS += -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist -L$(multipathdir) -L$(mpathcmddir) -lmpathcmd -lmultipath -ludev
 
 EXEC = mpathpersist
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index e3484b5..b80d3bc 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -29,12 +29,12 @@ static const char * pr_type_strs[] = {
 };
 
 int get_transportids_length(unsigned char * transportid_arr, int max_transportid, int num_transportids);
-void mpath_print_buf_readcap(struct prin_resp *pr_buff); 
+void mpath_print_buf_readcap(struct prin_resp *pr_buff);
 void mpath_print_buf_readfullstat(struct prin_resp *pr_buff);
 void mpath_print_buf_readresv(struct prin_resp *pr_buff);
 void mpath_print_buf_readkeys(struct prin_resp *pr_buff);
 void dumpHex(const char* str, int len, int no_ascii);
-void * mpath_alloc_prin_response(int prin_sa);	
+void * mpath_alloc_prin_response(int prin_sa);
 void mpath_print_transport_id(struct prin_fulldescr *fdesc);
 int construct_transportid(const char * inp, struct transportid transid[], int num_transportids);
 
@@ -236,7 +236,7 @@ int main (int argc, char * argv[])
                                 break;
 
 			default:
-				fprintf(stderr, "unrecognised switch " "code 0x%x ??\n", c);	
+				fprintf(stderr, "unrecognised switch " "code 0x%x ??\n", c);
 				usage ();
 				ret = MPATH_PR_SYNTAX_ERROR;
 				goto out;
@@ -379,29 +379,29 @@ int main (int argc, char * argv[])
 		if (ret != MPATH_PR_SUCCESS )
 		{
 			fprintf (stderr, "Persistent Reserve IN command failed\n");
-			goto out;	
+			goto out;
 		}
 
 		switch(prin_sa)
-		{			
-			case MPATH_PRIN_RKEY_SA: 
-				mpath_print_buf_readkeys(resp);		
+		{
+			case MPATH_PRIN_RKEY_SA:
+				mpath_print_buf_readkeys(resp);
 				break;
-			case MPATH_PRIN_RRES_SA: 
+			case MPATH_PRIN_RRES_SA:
 				mpath_print_buf_readresv(resp);
 				break;
 			case MPATH_PRIN_RCAP_SA:
-				mpath_print_buf_readcap(resp);		
+				mpath_print_buf_readcap(resp);
 				break;
 			case MPATH_PRIN_RFSTAT_SA:
-				mpath_print_buf_readfullstat(resp);		
+				mpath_print_buf_readfullstat(resp);
 				break;
 		}
 		free(resp);
 	}
 	else if (prout)
 	{
-		int j; 
+		int j;
 		struct prout_param_descriptor *paramp;
 
 		paramp= malloc(sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS )));
@@ -423,7 +423,7 @@ int main (int argc, char * argv[])
 		if (param_aptpl)
 			paramp->sa_flags |= 0x1;
 
-		if (num_transport) 
+		if (num_transport)
 		{
 			paramp->sa_flags |= MPATH_F_SPEC_I_PT_MASK;
 			paramp->num_transportid = num_transport;
@@ -538,7 +538,7 @@ void mpath_print_buf_readresv( struct prin_resp *pr_buff)
 {
 	int j, num, scope=0, type=0;
 	unsigned char *keyp;
-	uint64_t prkey;	
+	uint64_t prkey;
 
 	num = pr_buff->prin_descriptor.prin_readresv.additional_length / 8;
 	if (0 == num)
@@ -548,7 +548,7 @@ void mpath_print_buf_readresv( struct prin_resp *pr_buff)
 	}
 	else
 		printf("  PR generation=0x%x, Reservation follows:\n", pr_buff->prin_descriptor.prin_readresv.prgeneration);
-	keyp = (unsigned  char *)&pr_buff->prin_descriptor.prin_readkeys.key_list[0]; 
+	keyp = (unsigned  char *)&pr_buff->prin_descriptor.prin_readkeys.key_list[0];
 	prkey = 0;
 	for (j = 0; j < 8; ++j) {
 		if (j > 0)
@@ -561,7 +561,7 @@ void mpath_print_buf_readresv( struct prin_resp *pr_buff)
 	scope = (pr_buff->prin_descriptor.prin_readresv.scope_type >> 4) &  0x0f;
 	type = pr_buff->prin_descriptor.prin_readresv.scope_type & 0x0f;
 
-	if (scope == 0)	
+	if (scope == 0)
 		printf("  scope = LU_SCOPE, type = %s", pr_type_strs[type]);
 	else
 		printf("  scope = %d, type = %s", scope, pr_type_strs[type]);
@@ -610,7 +610,7 @@ void mpath_print_buf_readfullstat( struct prin_resp *pr_buff)
 	uint16_t  rel_pt_addr;
 	unsigned char * keyp;
 
-	num = pr_buff->prin_descriptor.prin_readfd.number_of_descriptor;	
+	num = pr_buff->prin_descriptor.prin_readfd.number_of_descriptor;
 	if (0 == num)
 	{
 		printf("  PR generation=0x%x \n", pr_buff->prin_descriptor.prin_readfd.prgeneration);
@@ -632,7 +632,7 @@ void mpath_print_buf_readfullstat( struct prin_resp *pr_buff)
 		}
 		printf("   Key = 0x%" PRIx64 "\n", prkey);
 
-		if (pr_buff->prin_descriptor.prin_readfd.descriptors[i]->flag & 0x02)	
+		if (pr_buff->prin_descriptor.prin_readfd.descriptors[i]->flag & 0x02)
 			printf("      All target ports bit set\n");
 		else {
 			printf("      All target ports bit clear\n");
@@ -705,7 +705,7 @@ mpath_print_transport_id(struct prin_fulldescr *fdesc)
 		case MPATH_PROTOCOL_ID_FC:
 			printf("   FCP-2 ");
 			if (0 != fdesc->trnptid.format_code)
-				printf(" [Unexpected format code: %d]\n", 
+				printf(" [Unexpected format code: %d]\n",
 						fdesc->trnptid.format_code);
 			dumpHex((const char *)fdesc->trnptid.n_port_name, 8, 0);
 			break;
diff --git a/mpathpersist/main.h b/mpathpersist/main.h
index 64686ec..84b10e0 100644
--- a/mpathpersist/main.h
+++ b/mpathpersist/main.h
@@ -18,7 +18,7 @@ static struct option long_options[] = {
 	{"register", 0, 0, 'G'},
 	{"register-ignore", 0, 0, 'I'},
 	{"release", 0, 0, 'L'},
-	{"report-capabilities", 0, 0, 'c'},		
+	{"report-capabilities", 0, 0, 'c'},
 	{"reserve", 0, 0, 'R'},
 	{"transport-id", 1, 0, 'X'},
 	{"alloc-length", 1, 0, 'l'},
diff --git a/multipath/01_udev b/multipath/01_udev
index 0f68996..c4e4c53 100755
--- a/multipath/01_udev
+++ b/multipath/01_udev
@@ -7,7 +7,7 @@ cp /bin/readlink $INITRDDIR/bin/
 
 PROGS="/sbin/udev /sbin/udevstart /bin/mountpoint /bin/readlink"
 LIBS=`ldd $PROGS | grep -v linux-gate.so | sort -u | \
-awk '{print $3}'` 
+awk '{print $3}'`
 for i in $LIBS
 do
 	mkdir -p `dirname $INITRDDIR/$i`
diff --git a/multipath/02_multipath b/multipath/02_multipath
index 467a7cb..adf9e64 100755
--- a/multipath/02_multipath
+++ b/multipath/02_multipath
@@ -16,7 +16,7 @@ cp /bin/mountpoint $INITRDDIR/bin
 
 PROGS="/lib/udev/scsi_id /bin/mountpoint"
 LIBS=`ldd $PROGS | grep -v linux-gate.so | sort -u | \
-awk '{print $3}'` 
+awk '{print $3}'`
 for i in $LIBS
 do
 	mkdir -p `dirname $INITRDDIR/$i`
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 2ff88c4..0c69b44 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -214,7 +214,7 @@ Generate the path priority for Hitachi HDS Modular storage arrays.
 Generate a random priority between 1 and 10.
 .TP 12
 .B weightedpath
-Generate the path priority based on the regular expression and the 
+Generate the path priority based on the regular expression and the
 priority provided as argument. requires prio_args keyword.
 .TP
 Default value is \fBnone\fR.
@@ -345,12 +345,12 @@ for never stop queueing. If unset no queueing is attempted.
 Default is unset.
 .TP
 .B user_friendly_names
-If set to 
+If set to
 .I yes
 , using the bindings file
 .I /etc/multipath/bindings
 to assign a persistent and unique alias to the multipath, in the form of mpath<n>.
-If set to 
+If set to
 .I no
 use the WWID as the alias. In either case this be will
 be overridden by any specific aliases in the \fImultipaths\fR section.
diff --git a/multipathd/main.c b/multipathd/main.c
index 0eadd70..11c518d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -292,7 +292,7 @@ sync_map_state(struct multipath *mpp)
 
 	vector_foreach_slot (mpp->pg, pgp, i){
 		vector_foreach_slot (pgp->paths, pp, j){
-			if (pp->state == PATH_UNCHECKED || 
+			if (pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD ||
 			    pp->state == PATH_DELAYED)
 				continue;
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 77f6e72..96a8fdb 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -7,14 +7,14 @@ multipathd \- multipath daemon
 .RB [\| options \|]
 
 .SH DESCRIPTION
-The 
-.B multipathd 
+The
+.B multipathd
 daemon is in charge of checking for failed paths. When this happens,
-it will reconfigure the multipath map the path belongs to, so that this map 
+it will reconfigure the multipath map the path belongs to, so that this map
 regains its maximum performance and redundancy.
 
-This daemon executes the external multipath config tool when events occur. 
-In turn, the multipath tool signals the multipathd daemon when it is done with 
+This daemon executes the external multipath config tool when events occur.
+In turn, the multipath tool signals the multipathd daemon when it is done with
 devmap reconfiguration, so that it can refresh its failed path list.
 
 .SH OPTIONS
@@ -26,14 +26,14 @@ Foreground Mode. Don't daemonize, and print all messages to stdout and stderr.
 Suppress timestamps. Do not prefix logging messages with a timestamp.
 .TP
 .B -v "level"
-Verbosity level. Print additional information while running multipathd. A  level of 0 means only print errors. A level of 3 or greater prints debugging information as well. 
+Verbosity level. Print additional information while running multipathd. A  level of 0 means only print errors. A level of 3 or greater prints debugging information as well.
 .TP
 .B -B
 Read-only bindings file. Multipathd will not write to the user_friendly_names
 bindings file. If a user_friendly_name doesn't already exist for a device, it
 will use its WWID as its alias.
 .TP
-.B -k 
+.B -k
 multipathd will enter interactive mode. From this mode, the available commands can be viewed by entering "help". When you are finished entering commands, press CTRL-D to quit.
 .TP
 .B -n
@@ -45,14 +45,14 @@ wwid for the device is already listed in the wwids file.
 The following commands can be used in interactive mode:
 .TP
 .B list|show paths
-Show the paths that multipathd is monitoring, and their state. 
+Show the paths that multipathd is monitoring, and their state.
 .TP
 .B list|show paths format $format
 Show the paths that multipathd is monitoring, using a format string with path
 format wildcards.
 .TP
 .B list|show maps|multipaths
-Show the multipath devices that the multipathd is monitoring. 
+Show the multipath devices that the multipathd is monitoring.
 .TP
 .B list|show maps|multipaths format $format
 Show the status of all multipath devices that the multipathd is monitoring,
@@ -94,19 +94,19 @@ Show the current state of the multipathd daemon
 .TP
 .B add path $path
 Add a path to the list of monitored paths. $path is as listed in /sys/block (e.g. sda).
-.TP 
+.TP
 .B remove|del path $path
 Stop monitoring a path. $path is as listed in /sys/block (e.g. sda).
 .TP
 .B add map|multipath $map
-Add a multipath device to the list of monitored devices. $map can either be a device-mapper device as listed in /sys/block (e.g. dm-0) or it can be the alias for the multipath device (e.g. mpath1) or the uid of the multipath device (e.g. 36005076303ffc56200000000000010aa). 
+Add a multipath device to the list of monitored devices. $map can either be a device-mapper device as listed in /sys/block (e.g. dm-0) or it can be the alias for the multipath device (e.g. mpath1) or the uid of the multipath device (e.g. 36005076303ffc56200000000000010aa).
 .TP
 .B remove|del map|multipath $map
 Stop monitoring a multipath device.
 .TP
 .B resize map|multipath $map
 Resizes map $map to the given size
-.TP 
+.TP
 .B switch|switchgroup map|multipath $map group $group
 Force a multipath device to switch to a specific path group. $group is the path group index, starting with 1.
 .TP
-- 
2.5.5
