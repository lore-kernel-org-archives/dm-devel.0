From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace leading spaces with tabs
Date: Mon, 18 Jul 2016 14:27:07 +0200
Message-ID: <1468844827-3739-1-git-send-email-xose.vazquez@gmail.com>
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

replace ^8x(1,2,3,4,5,6 and 7) spaces with tabs.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/dasd.h                        |  76 +++++------
 kpartx/gpt.c                         | 238 +++++++++++++++++------------------
 kpartx/gpt.h                         |   6 +-
 kpartx/lopart.c                      |   2 +-
 kpartx/mac.c                         |   4 +-
 kpartx/mac.h                         |  18 +--
 kpartx/ps3.c                         |   2 +-
 libmpathpersist/mpath_pr_ioctl.c     |  62 ++++-----
 libmpathpersist/mpathpr.h            |  36 +++---
 libmultipath/configure.c             |   2 +-
 libmultipath/devmapper.c             |   8 +-
 libmultipath/memory.h                |   8 +-
 libmultipath/print.c                 |  10 +-
 libmultipath/print.h                 |  70 +++++------
 libmultipath/prioritizers/datacore.c |   6 +-
 libmultipath/prioritizers/hds.c      |   2 +-
 libmultipath/prioritizers/ontap.c    |   2 +-
 mpathpersist/main.c                  |  24 ++--
 18 files changed, 288 insertions(+), 288 deletions(-)

diff --git a/kpartx/dasd.h b/kpartx/dasd.h
index 2779366..0356066 100644
--- a/kpartx/dasd.h
+++ b/kpartx/dasd.h
@@ -27,40 +27,40 @@
 
 typedef struct ttr
 {
-        uint16_t tt;
-        uint8_t  r;
+	uint16_t tt;
+	uint8_t  r;
 } __attribute__ ((packed)) ttr_t;
 
 typedef struct cchhb
 {
-        uint16_t cc;
-        uint16_t hh;
-        uint8_t b;
+	uint16_t cc;
+	uint16_t hh;
+	uint8_t b;
 } __attribute__ ((packed)) cchhb_t;
 
 typedef struct cchh
 {
-        uint16_t cc;
-        uint16_t hh;
+	uint16_t cc;
+	uint16_t hh;
 } __attribute__ ((packed)) cchh_t;
 
 typedef struct labeldate
 {
-        uint8_t  year;
-        uint16_t day;
+	uint8_t  year;
+	uint16_t day;
 } __attribute__ ((packed)) labeldate_t;
 
 
 typedef struct volume_label
 {
-        char volkey[4];         /* volume key = volume label                 */
+	char volkey[4];         /* volume key = volume label                 */
 	char vollbl[4];	        /* volume label                              */
 	char volid[6];	        /* volume identifier                         */
 	uint8_t security;	        /* security byte                             */
 	cchhb_t vtoc;           /* VTOC address                              */
 	char res1[5];	        /* reserved                                  */
-        char cisize[4];	        /* CI-size for FBA,...                       */
-                                /* ...blanks for CKD                         */
+	char cisize[4];	        /* CI-size for FBA,...                       */
+				/* ...blanks for CKD                         */
 	char blkperci[4];       /* no of blocks per CI (FBA), blanks for CKD */
 	char labperci[4];       /* no of labels per CI (FBA), blanks for CKD */
 	char res2[4];	        /* reserved                                  */
@@ -73,25 +73,25 @@ typedef struct volume_label
 
 typedef struct extent
 {
-        uint8_t  typeind;          /* extent type indicator                     */
-        uint8_t  seqno;            /* extent sequence number                    */
-        cchh_t llimit;          /* starting point of this extent             */
-        cchh_t ulimit;          /* ending point of this extent               */
+	uint8_t  typeind;          /* extent type indicator                     */
+	uint8_t  seqno;            /* extent sequence number                    */
+	cchh_t llimit;          /* starting point of this extent             */
+	cchh_t ulimit;          /* ending point of this extent               */
 } __attribute__ ((packed)) extent_t;
 
 
 typedef struct dev_const
 {
-        uint16_t DS4DSCYL;           /* number of logical cyls                  */
-        uint16_t DS4DSTRK;           /* number of tracks in a logical cylinder  */
-        uint16_t DS4DEVTK;           /* device track length                     */
-        uint8_t  DS4DEVI;            /* non-last keyed record overhead          */
-        uint8_t  DS4DEVL;            /* last keyed record overhead              */
-        uint8_t  DS4DEVK;            /* non-keyed record overhead differential  */
-        uint8_t  DS4DEVFG;           /* flag byte                               */
-        uint16_t DS4DEVTL;           /* device tolerance                        */
-        uint8_t  DS4DEVDT;           /* number of DSCB's per track              */
-        uint8_t  DS4DEVDB;           /* number of directory blocks per track    */
+	uint16_t DS4DSCYL;           /* number of logical cyls                  */
+	uint16_t DS4DSTRK;           /* number of tracks in a logical cylinder  */
+	uint16_t DS4DEVTK;           /* device track length                     */
+	uint8_t  DS4DEVI;            /* non-last keyed record overhead          */
+	uint8_t  DS4DEVL;            /* last keyed record overhead              */
+	uint8_t  DS4DEVK;            /* non-keyed record overhead differential  */
+	uint8_t  DS4DEVFG;           /* flag byte                               */
+	uint16_t DS4DEVTL;           /* device tolerance                        */
+	uint8_t  DS4DEVDT;           /* number of DSCB's per track              */
+	uint8_t  DS4DEVDB;           /* number of directory blocks per track    */
 } __attribute__ ((packed)) dev_const_t;
 
 
@@ -104,15 +104,15 @@ typedef struct format1_label
 	labeldate_t DS1CREDT;     /* creation date: ydd                      */
 	labeldate_t DS1EXPDT;     /* expiration date                         */
 	uint8_t  DS1NOEPV;           /* number of extents on volume             */
-        uint8_t  DS1NOBDB;           /* no. of bytes used in last direction blk */
+	uint8_t  DS1NOBDB;           /* no. of bytes used in last direction blk */
 	uint8_t  DS1FLAG1;           /* flag 1                                  */
 	char  DS1SYSCD[13];       /* system code                             */
 	labeldate_t DS1REFD;      /* date last referenced                    */
-        uint8_t  DS1SMSFG;           /* system managed storage indicators       */
-        uint8_t  DS1SCXTF;           /* sec. space extension flag byte          */
-        uint16_t DS1SCXTV;           /* secondary space extension value         */
-        uint8_t  DS1DSRG1;           /* data set organisation byte 1            */
-        uint8_t  DS1DSRG2;           /* data set organisation byte 2            */
+	uint8_t  DS1SMSFG;           /* system managed storage indicators       */
+	uint8_t  DS1SCXTF;           /* sec. space extension flag byte          */
+	uint16_t DS1SCXTV;           /* secondary space extension value         */
+	uint8_t  DS1DSRG1;           /* data set organisation byte 1            */
+	uint8_t  DS1DSRG2;           /* data set organisation byte 2            */
   	uint8_t  DS1RECFM;           /* record format                           */
 	uint8_t  DS1OPTCD;           /* option code                             */
 	uint16_t DS1BLKL;            /* block length                            */
@@ -120,11 +120,11 @@ typedef struct format1_label
 	uint8_t  DS1KEYL;            /* key length                              */
 	uint16_t DS1RKP;             /* relative key position                   */
 	uint8_t  DS1DSIND;           /* data set indicators                     */
-        uint8_t  DS1SCAL1;           /* secondary allocation flag byte          */
+	uint8_t  DS1SCAL1;           /* secondary allocation flag byte          */
   	char DS1SCAL3[3];         /* secondary allocation quantity           */
 	ttr_t DS1LSTAR;           /* last used track and block on track      */
 	uint16_t DS1TRBAL;           /* space remaining on last used track      */
-        uint16_t res1;               /* reserved                                */
+	uint16_t res1;               /* reserved                                */
 	extent_t DS1EXT1;         /* first extent description                */
 	extent_t DS1EXT2;         /* second extent description               */
 	extent_t DS1EXT3;         /* third extent description                */
@@ -176,16 +176,16 @@ static unsigned char EBCtoASC[256] =
 /* 0x08  -GE  -SPS  -RPT    VT    FF    CR    SO    SI */
 	0x07, 0x07, 0x07, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
 /* 0x10  DLE   DC1   DC2   DC3  -RES   -NL    BS  -POC
-                                -ENP  ->LF             */
+				-ENP  ->LF             */
 	0x10, 0x11, 0x12, 0x13, 0x07, 0x0A, 0x08, 0x07,
 /* 0x18  CAN    EM  -UBS  -CU1  -IFS  -IGS  -IRS  -ITB
-                                                  -IUS */
+						  -IUS */
 	0x18, 0x19, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
 /* 0x20  -DS  -SOS    FS  -WUS  -BYP    LF   ETB   ESC
-                                -INP                   */
+				-INP                   */
 	0x07, 0x07, 0x1C, 0x07, 0x07, 0x0A, 0x17, 0x1B,
 /* 0x28  -SA  -SFE   -SM  -CSP  -MFA   ENQ   ACK   BEL
-                     -SW                               */
+		     -SW                               */
 	0x07, 0x07, 0x07, 0x07, 0x07, 0x05, 0x06, 0x07,
 /* 0x30 ----  ----   SYN   -IR   -PP  -TRN  -NBS   EOT */
 	0x07, 0x07, 0x16, 0x07, 0x07, 0x07, 0x07, 0x04,
diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index 416eac8..812129a 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -65,9 +65,9 @@
 #endif
 
 struct blkdev_ioctl_param {
-        unsigned int block;
-        size_t content_length;
-        char * block_contents;
+	unsigned int block;
+	size_t content_length;
+	char * block_contents;
 };
 
 /**
@@ -106,7 +106,7 @@ is_pmbr_valid(legacy_mbr *mbr)
 	signature = (__le16_to_cpu(mbr->signature) == MSDOS_MBR_SIGNATURE);
 	for (i = 0; signature && i < 4; i++) {
 		if (mbr->partition[i].sys_type ==
-                    EFI_PMBR_OSTYPE_EFI_GPT) {
+		    EFI_PMBR_OSTYPE_EFI_GPT) {
 			found = 1;
 			break;
 		}
@@ -184,19 +184,19 @@ last_lba(int filedes)
 static ssize_t
 read_lastoddsector(int fd, uint64_t lba, void *buffer, size_t count)
 {
-        int rc;
-        struct blkdev_ioctl_param ioctl_param;
+	int rc;
+	struct blkdev_ioctl_param ioctl_param;
 
-        if (!buffer) return 0;
+	if (!buffer) return 0;
 
-        ioctl_param.block = 0; /* read the last sector */
-        ioctl_param.content_length = count;
-        ioctl_param.block_contents = buffer;
+	ioctl_param.block = 0; /* read the last sector */
+	ioctl_param.content_length = count;
+	ioctl_param.block_contents = buffer;
 
-        rc = ioctl(fd, BLKGETLASTSECT, &ioctl_param);
-        if (rc == -1) perror("read failed");
+	rc = ioctl(fd, BLKGETLASTSECT, &ioctl_param);
+	if (rc == -1) perror("read failed");
 
-        return !rc;
+	return !rc;
 }
 
 static ssize_t
@@ -215,15 +215,15 @@ read_lba(int fd, uint64_t lba, void *buffer, size_t bytes)
 	if (!lastlba)
 		return bytesread;
 
-        /* Kludge.  This is necessary to read/write the last
-           block of an odd-sized disk, until Linux 2.5.x kernel fixes.
-           This is only used by gpt.c, and only to read
-           one sector, so we don't have to be fancy.
-        */
-        if (!bytesread && !(lastlba & 1) && lba == lastlba) {
-                bytesread = read_lastoddsector(fd, lba, buffer, bytes);
-        }
-        return bytesread;
+	/* Kludge.  This is necessary to read/write the last
+	   block of an odd-sized disk, until Linux 2.5.x kernel fixes.
+	   This is only used by gpt.c, and only to read
+	   one sector, so we don't have to be fancy.
+	*/
+	if (!bytesread && !(lastlba & 1) && lba == lastlba) {
+		bytesread = read_lastoddsector(fd, lba, buffer, bytes);
+	}
+	return bytesread;
 }
 
 /**
@@ -238,10 +238,10 @@ static gpt_entry *
 alloc_read_gpt_entries(int fd, gpt_header * gpt)
 {
 	gpt_entry *pte;
-        size_t count = __le32_to_cpu(gpt->num_partition_entries) *
-                __le32_to_cpu(gpt->sizeof_partition_entry);
+	size_t count = __le32_to_cpu(gpt->num_partition_entries) *
+		__le32_to_cpu(gpt->sizeof_partition_entry);
 
-        if (!count) return NULL;
+	if (!count) return NULL;
 
 	pte = (gpt_entry *)malloc(count);
 	if (!pte)
@@ -249,7 +249,7 @@ alloc_read_gpt_entries(int fd, gpt_header * gpt)
 	memset(pte, 0, count);
 
 	if (!read_lba(fd, __le64_to_cpu(gpt->partition_entry_lba), pte,
-                      count)) {
+		      count)) {
 		free(pte);
 		return NULL;
 	}
@@ -294,13 +294,13 @@ alloc_read_gpt_header(int fd, uint64_t lba)
  */
 static int
 is_gpt_valid(int fd, uint64_t lba,
-             gpt_header ** gpt, gpt_entry ** ptes)
+	     gpt_header ** gpt, gpt_entry ** ptes)
 {
 	int rc = 0;		/* default to not valid */
 	uint32_t crc, origcrc;
 
 	if (!gpt || !ptes)
-                return 0;
+		return 0;
 	if (!(*gpt = alloc_read_gpt_header(fd, lba)))
 		return 0;
 
@@ -366,7 +366,7 @@ is_gpt_valid(int fd, uint64_t lba,
 
 	/* Check the GUID Partition Entry Array CRC */
 	crc = efi_crc32(*ptes,
-                        __le32_to_cpu((*gpt)->num_partition_entries) *
+			__le32_to_cpu((*gpt)->num_partition_entries) *
 			__le32_to_cpu((*gpt)->sizeof_partition_entry));
 	if (crc != __le32_to_cpu((*gpt)->partition_entry_array_crc32)) {
 		// printf("GUID Partitition Entry Array CRC check failed.\n");
@@ -402,7 +402,7 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
 #ifdef DEBUG
 		fprintf(stderr,  "GPT:%" PRIx64 " != %" PRIx64 "\n",
 		       __le64_to_cpu(pgpt->my_lba),
-                       __le64_to_cpu(agpt->alternate_lba));
+		       __le64_to_cpu(agpt->alternate_lba));
 #endif
 	}
 	if (__le64_to_cpu(pgpt->alternate_lba) != __le64_to_cpu(agpt->my_lba)) {
@@ -412,27 +412,27 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
 #ifdef DEBUG
 		fprintf(stderr,  "GPT:%" PRIx64 " != %" PRIx64 "\n",
 		       __le64_to_cpu(pgpt->alternate_lba),
-                       __le64_to_cpu(agpt->my_lba));
+		       __le64_to_cpu(agpt->my_lba));
 #endif
 	}
 	if (__le64_to_cpu(pgpt->first_usable_lba) !=
-            __le64_to_cpu(agpt->first_usable_lba)) {
+	    __le64_to_cpu(agpt->first_usable_lba)) {
 		error_found++;
 		fprintf(stderr,  "GPT:first_usable_lbas don't match.\n");
 #ifdef DEBUG
 		fprintf(stderr,  "GPT:%" PRIx64 " != %" PRIx64 "\n",
 		       __le64_to_cpu(pgpt->first_usable_lba),
-                       __le64_to_cpu(agpt->first_usable_lba));
+		       __le64_to_cpu(agpt->first_usable_lba));
 #endif
 	}
 	if (__le64_to_cpu(pgpt->last_usable_lba) !=
-            __le64_to_cpu(agpt->last_usable_lba)) {
+	    __le64_to_cpu(agpt->last_usable_lba)) {
 		error_found++;
 		fprintf(stderr,  "GPT:last_usable_lbas don't match.\n");
 #ifdef DEBUG
 		fprintf(stderr,  "GPT:%" PRIx64 " != %" PRIx64 "\n",
 		       __le64_to_cpu(pgpt->last_usable_lba),
-                       __le64_to_cpu(agpt->last_usable_lba));
+		       __le64_to_cpu(agpt->last_usable_lba));
 #endif
 	}
 	if (efi_guidcmp(pgpt->disk_guid, agpt->disk_guid)) {
@@ -440,7 +440,7 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
 		fprintf(stderr,  "GPT:disk_guids don't match.\n");
 	}
 	if (__le32_to_cpu(pgpt->num_partition_entries) !=
-            __le32_to_cpu(agpt->num_partition_entries)) {
+	    __le32_to_cpu(agpt->num_partition_entries)) {
 		error_found++;
 		fprintf(stderr,  "GPT:num_partition_entries don't match: "
 		       "0x%x != 0x%x\n",
@@ -448,21 +448,21 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
 		       __le32_to_cpu(agpt->num_partition_entries));
 	}
 	if (__le32_to_cpu(pgpt->sizeof_partition_entry) !=
-            __le32_to_cpu(agpt->sizeof_partition_entry)) {
+	    __le32_to_cpu(agpt->sizeof_partition_entry)) {
 		error_found++;
 		fprintf(stderr,
 		       "GPT:sizeof_partition_entry values don't match: "
 		       "0x%x != 0x%x\n",
-                       __le32_to_cpu(pgpt->sizeof_partition_entry),
+		       __le32_to_cpu(pgpt->sizeof_partition_entry),
 		       __le32_to_cpu(agpt->sizeof_partition_entry));
 	}
 	if (__le32_to_cpu(pgpt->partition_entry_array_crc32) !=
-            __le32_to_cpu(agpt->partition_entry_array_crc32)) {
+	    __le32_to_cpu(agpt->partition_entry_array_crc32)) {
 		error_found++;
 		fprintf(stderr,
 		       "GPT:partition_entry_array_crc32 values don't match: "
 		       "0x%x != 0x%x\n",
-                       __le32_to_cpu(pgpt->partition_entry_array_crc32),
+		       __le32_to_cpu(pgpt->partition_entry_array_crc32),
 		       __le32_to_cpu(agpt->partition_entry_array_crc32));
 	}
 	if (__le64_to_cpu(pgpt->alternate_lba) != lastlba) {
@@ -504,7 +504,7 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
 static int
 find_valid_gpt(int fd, gpt_header ** gpt, gpt_entry ** ptes)
 {
-        extern int force_gpt;
+	extern int force_gpt;
 	int good_pgpt = 0, good_agpt = 0, good_pmbr = 0;
 	gpt_header *pgpt = NULL, *agpt = NULL;
 	gpt_entry *pptes = NULL, *aptes = NULL;
@@ -517,89 +517,89 @@ find_valid_gpt(int fd, gpt_header ** gpt, gpt_entry ** ptes)
 		return 0;
 	good_pgpt = is_gpt_valid(fd, GPT_PRIMARY_PARTITION_TABLE_LBA,
 				 &pgpt, &pptes);
-        if (good_pgpt) {
+	if (good_pgpt) {
 		good_agpt = is_gpt_valid(fd,
-                                         __le64_to_cpu(pgpt->alternate_lba),
+					 __le64_to_cpu(pgpt->alternate_lba),
+					 &agpt, &aptes);
+		if (!good_agpt) {
+			good_agpt = is_gpt_valid(fd, lastlba,
+						 &agpt, &aptes);
+		}
+	}
+	else {
+		good_agpt = is_gpt_valid(fd, lastlba,
 					 &agpt, &aptes);
-                if (!good_agpt) {
-                        good_agpt = is_gpt_valid(fd, lastlba,
-                                                 &agpt, &aptes);
-                }
-        }
-        else {
-                good_agpt = is_gpt_valid(fd, lastlba,
-                                         &agpt, &aptes);
-        }
-
-        /* The obviously unsuccessful case */
-        if (!good_pgpt && !good_agpt) {
-                goto fail;
-        }
+	}
+
+	/* The obviously unsuccessful case */
+	if (!good_pgpt && !good_agpt) {
+		goto fail;
+	}
 
 	/* This will be added to the EFI Spec. per Intel after v1.02. */
-        legacymbr = malloc(sizeof (*legacymbr));
-        if (legacymbr) {
-                memset(legacymbr, 0, sizeof (*legacymbr));
-                read_lba(fd, 0, (uint8_t *) legacymbr,
-                         sizeof (*legacymbr));
-                good_pmbr = is_pmbr_valid(legacymbr);
-                free(legacymbr);
-                legacymbr=NULL;
-        }
-
-        /* Failure due to bad PMBR */
-        if ((good_pgpt || good_agpt) && !good_pmbr && !force_gpt) {
-                fprintf(stderr,
-                       "  Warning: Disk has a valid GPT signature "
-                       "but invalid PMBR.\n"
-                       "  Assuming this disk is *not* a GPT disk anymore.\n"
-                       "  Use gpt kernel option to override.  "
-                       "Use GNU Parted to correct disk.\n");
-                goto fail;
-        }
-
-        /* Would fail due to bad PMBR, but force GPT anyhow */
-        if ((good_pgpt || good_agpt) && !good_pmbr && force_gpt) {
-                fprintf(stderr,
-                       "  Warning: Disk has a valid GPT signature but "
-                       "invalid PMBR.\n"
-                       "  Use GNU Parted to correct disk.\n"
-                       "  gpt option taken, disk treated as GPT.\n");
-        }
-
-        compare_gpts(pgpt, agpt, lastlba);
-
-        /* The good cases */
-        if (good_pgpt && (good_pmbr || force_gpt)) {
-                *gpt  = pgpt;
-                *ptes = pptes;
-                if (agpt)  { free(agpt);   agpt = NULL; }
-                if (aptes) { free(aptes); aptes = NULL; }
-                if (!good_agpt) {
-                        fprintf(stderr,
+	legacymbr = malloc(sizeof (*legacymbr));
+	if (legacymbr) {
+		memset(legacymbr, 0, sizeof (*legacymbr));
+		read_lba(fd, 0, (uint8_t *) legacymbr,
+			 sizeof (*legacymbr));
+		good_pmbr = is_pmbr_valid(legacymbr);
+		free(legacymbr);
+		legacymbr=NULL;
+	}
+
+	/* Failure due to bad PMBR */
+	if ((good_pgpt || good_agpt) && !good_pmbr && !force_gpt) {
+		fprintf(stderr,
+		       "  Warning: Disk has a valid GPT signature "
+		       "but invalid PMBR.\n"
+		       "  Assuming this disk is *not* a GPT disk anymore.\n"
+		       "  Use gpt kernel option to override.  "
+		       "Use GNU Parted to correct disk.\n");
+		goto fail;
+	}
+
+	/* Would fail due to bad PMBR, but force GPT anyhow */
+	if ((good_pgpt || good_agpt) && !good_pmbr && force_gpt) {
+		fprintf(stderr,
+		       "  Warning: Disk has a valid GPT signature but "
+		       "invalid PMBR.\n"
+		       "  Use GNU Parted to correct disk.\n"
+		       "  gpt option taken, disk treated as GPT.\n");
+	}
+
+	compare_gpts(pgpt, agpt, lastlba);
+
+	/* The good cases */
+	if (good_pgpt && (good_pmbr || force_gpt)) {
+		*gpt  = pgpt;
+		*ptes = pptes;
+		if (agpt)  { free(agpt);   agpt = NULL; }
+		if (aptes) { free(aptes); aptes = NULL; }
+		if (!good_agpt) {
+			fprintf(stderr,
 			       "Alternate GPT is invalid, "
-                               "using primary GPT.\n");
-                }
-                return 1;
-        }
-        else if (good_agpt && (good_pmbr || force_gpt)) {
-                *gpt  = agpt;
-                *ptes = aptes;
-                if (pgpt)  { free(pgpt);   pgpt = NULL; }
-                if (pptes) { free(pptes); pptes = NULL; }
-                fprintf(stderr,
-                       "Primary GPT is invalid, using alternate GPT.\n");
-                return 1;
-        }
+			       "using primary GPT.\n");
+		}
+		return 1;
+	}
+	else if (good_agpt && (good_pmbr || force_gpt)) {
+		*gpt  = agpt;
+		*ptes = aptes;
+		if (pgpt)  { free(pgpt);   pgpt = NULL; }
+		if (pptes) { free(pptes); pptes = NULL; }
+		fprintf(stderr,
+		       "Primary GPT is invalid, using alternate GPT.\n");
+		return 1;
+	}
 
  fail:
-        if (pgpt)  { free(pgpt);   pgpt=NULL; }
-        if (agpt)  { free(agpt);   agpt=NULL; }
-        if (pptes) { free(pptes); pptes=NULL; }
-        if (aptes) { free(aptes); aptes=NULL; }
-        *gpt = NULL;
-        *ptes = NULL;
-        return 0;
+	if (pgpt)  { free(pgpt);   pgpt=NULL; }
+	if (agpt)  { free(agpt);   agpt=NULL; }
+	if (pptes) { free(pptes); pptes=NULL; }
+	if (aptes) { free(aptes); aptes=NULL; }
+	*gpt = NULL;
+	*ptes = NULL;
+	return 0;
 }
 
 /**
@@ -618,7 +618,7 @@ read_gpt_pt (int fd, struct slice all, struct slice *sp, int ns)
 	gpt_entry *ptes = NULL;
 	uint32_t i;
 	int n = 0;
-        int last_used_index=-1;
+	int last_used_index=-1;
 	int sector_size_mul = get_sector_size(fd)/512;
 
 	if (!find_valid_gpt (fd, &gpt, &ptes) || !gpt || !ptes) {
@@ -640,7 +640,7 @@ read_gpt_pt (int fd, struct slice all, struct slice *sp, int ns)
 			sp[n].size  = sector_size_mul *
 				      (__le64_to_cpu(ptes[i].ending_lba) -
 				       __le64_to_cpu(ptes[i].starting_lba) + 1);
-                        last_used_index=n;
+			last_used_index=n;
 			n++;
 		}
 	}
diff --git a/kpartx/gpt.h b/kpartx/gpt.h
index 515306e..66ce8f1 100644
--- a/kpartx/gpt.h
+++ b/kpartx/gpt.h
@@ -62,7 +62,7 @@ typedef struct _gpt_header {
 typedef struct _gpt_entry_attributes {
 	uint64_t required_to_function:1;
 	uint64_t reserved:47;
-        uint64_t type_guid_specific:16;
+	uint64_t type_guid_specific:16;
 } __attribute__ ((packed)) gpt_entry_attributes;
 
 typedef struct _gpt_entry {
@@ -86,8 +86,8 @@ typedef struct _gpt_entry {
    as:
 */
 #define GPT_DEFAULT_RESERVED_PARTITION_ENTRIES \
-        (GPT_DEFAULT_RESERVED_PARTITION_ENTRY_ARRAY_SIZE / \
-         sizeof(gpt_entry))
+	(GPT_DEFAULT_RESERVED_PARTITION_ENTRY_ARRAY_SIZE / \
+	 sizeof(gpt_entry))
 
 
 /* Protected Master Boot Record  & Legacy MBR share same structure */
diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index b35cbf4..5d4967b 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -38,7 +38,7 @@
 #endif
 
 #if !defined (__alpha__) && !defined (__ia64__) && !defined (__x86_64__) \
-        && !defined (__s390x__)
+	&& !defined (__s390x__)
 #define int2ptr(x)	((void *) ((int) x))
 #else
 #define int2ptr(x)	((void *) ((long) x))
diff --git a/kpartx/mac.c b/kpartx/mac.c
index 5432e67..6e82c95 100644
--- a/kpartx/mac.c
+++ b/kpartx/mac.c
@@ -7,11 +7,11 @@
 int
 read_mac_pt(int fd, struct slice all, struct slice *sp, int ns) {
 	struct mac_driver_desc *md;
-        struct mac_partition *part;
+	struct mac_partition *part;
 	unsigned secsize;
 	char *data;
 	int blk, blocks_in_map;
-        int n = 0;
+	int n = 0;
 
 	md = (struct mac_driver_desc *) getblock(fd, 0);
 	if (md == NULL)
diff --git a/kpartx/mac.h b/kpartx/mac.h
index 3c712ba..a44cf38 100644
--- a/kpartx/mac.h
+++ b/kpartx/mac.h
@@ -9,21 +9,21 @@
 #define APPLE_AUX_TYPE  "Apple_UNIX_SVR2"
 
 struct mac_partition {
-        uint16_t  signature;      /* expected to be MAC_PARTITION_MAGIC */
-        uint16_t  res1;
-        uint32_t  map_count;      /* # blocks in partition map */
-        uint32_t  start_block;    /* absolute starting block # of partition */
-        uint32_t  block_count;    /* number of blocks in partition */
-        /* there is more stuff after this that we don't need */
+	uint16_t  signature;      /* expected to be MAC_PARTITION_MAGIC */
+	uint16_t  res1;
+	uint32_t  map_count;      /* # blocks in partition map */
+	uint32_t  start_block;    /* absolute starting block # of partition */
+	uint32_t  block_count;    /* number of blocks in partition */
+	/* there is more stuff after this that we don't need */
 };
 
 #define MAC_DRIVER_MAGIC        0x4552
 
 /* Driver descriptor structure, in block 0 */
 struct mac_driver_desc {
-        uint16_t  signature;      /* expected to be MAC_DRIVER_MAGIC */
-        uint16_t  block_size;
-        uint32_t  block_count;
+	uint16_t  signature;      /* expected to be MAC_DRIVER_MAGIC */
+	uint16_t  block_size;
+	uint32_t  block_count;
     /* ... more stuff */
 };
 
diff --git a/kpartx/ps3.c b/kpartx/ps3.c
index d1e5d64..f0a2a9a 100644
--- a/kpartx/ps3.c
+++ b/kpartx/ps3.c
@@ -50,7 +50,7 @@ read_disklabel(int fd, struct disklabel *label) {
 int
 read_ps3_pt(int fd, struct slice all, struct slice *sp, int ns) {
 	struct disklabel label;
-        int n = 0;
+	int n = 0;
 	int i;
 
 	if (!read_disklabel(fd, &label))
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index e45ae1e..e54c804 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -28,7 +28,7 @@ int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr,
 			      SenseData_t *Sensedata, int noisy);
 void dumpHex(const char* str, int len, int no_ascii);
 int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
-                unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
+		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
 uint32_t  format_transportids(struct prout_param_descriptor *paramp);
 void mpath_reverse_uint32_byteorder(uint32_t *num);
 void mpath_reverse_uint16_byteorder(uint16_t *num);
@@ -39,7 +39,7 @@ int mpath_isLittleEndian(void);
 extern unsigned int mpath_mx_alloc_len;
 
 int prout_do_scsi_ioctl(char * dev, int rq_servact, int rq_scope,
-                unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy)
+		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy)
 {
 
 	int status, paramlen = 24, ret = 0;
@@ -182,25 +182,25 @@ uint32_t  format_transportids(struct prout_param_descriptor *paramp)
 
 void mpath_format_readkeys( struct prin_resp *pr_buff, int len, int noisy)
 {
-        mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.prgeneration);
-        mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.additional_length);
+	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.prgeneration);
+	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.additional_length);
 }
 
 void mpath_format_readresv(struct prin_resp *pr_buff, int len, int noisy)
 {
 
-        mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.prgeneration);
-        mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.additional_length);
+	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.prgeneration);
+	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.additional_length);
 
-        return;
+	return;
 }
 
 void mpath_format_reportcapabilities(struct prin_resp *pr_buff, int len, int noisy)
 {
-        mpath_reverse_uint16_byteorder(&pr_buff->prin_descriptor.prin_readcap.length);
-        mpath_reverse_uint16_byteorder(&pr_buff->prin_descriptor.prin_readcap.pr_type_mask);
+	mpath_reverse_uint16_byteorder(&pr_buff->prin_descriptor.prin_readcap.length);
+	mpath_reverse_uint16_byteorder(&pr_buff->prin_descriptor.prin_readcap.pr_type_mask);
 
-        return;
+	return;
 }
 
 void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy)
@@ -305,11 +305,11 @@ int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int
 	{MPATH_PRIN_CMD, 0, 0, 0, 0, 0, 0, 0, 0, 0};
 
 	snprintf(devname, FILE_NAME_SIZE, "/dev/%s",dev);
-        fd = open(devname, O_WRONLY);
-        if(fd < 0){
-        	condlog(0, "%s: Unable to open device ", dev);
+	fd = open(devname, O_WRONLY);
+	if(fd < 0){
+		condlog(0, "%s: Unable to open device ", dev);
 		return MPATH_PR_FILE_ERROR;
-         }
+	 }
 
 	if (mpath_mx_alloc_len)
 		mx_resp_len = mpath_mx_alloc_len;
@@ -559,25 +559,25 @@ dumpHex(const char* str, int len, int log)
 
 int get_prin_length(int rq_servact)
 {
-        int mx_resp_len;
-        switch (rq_servact)
-        {
-                case MPATH_PRIN_RKEY_SA:
-                        mx_resp_len =  sizeof(struct prin_readdescr);
-                        break;
-                case MPATH_PRIN_RRES_SA :
-                        mx_resp_len =  sizeof(struct prin_resvdescr);
-                        break;
-                case MPATH_PRIN_RCAP_SA :
-                        mx_resp_len = sizeof(struct prin_capdescr);
-                        break;
-                case MPATH_PRIN_RFSTAT_SA:
-                        mx_resp_len = sizeof(struct print_fulldescr_list) + sizeof(struct prin_fulldescr *)*32;
-                        break;
+	int mx_resp_len;
+	switch (rq_servact)
+	{
+		case MPATH_PRIN_RKEY_SA:
+			mx_resp_len =  sizeof(struct prin_readdescr);
+			break;
+		case MPATH_PRIN_RRES_SA :
+			mx_resp_len =  sizeof(struct prin_resvdescr);
+			break;
+		case MPATH_PRIN_RCAP_SA :
+			mx_resp_len = sizeof(struct prin_capdescr);
+			break;
+		case MPATH_PRIN_RFSTAT_SA:
+			mx_resp_len = sizeof(struct print_fulldescr_list) + sizeof(struct prin_fulldescr *)*32;
+			break;
 		default:
 			condlog(0, "invalid service action, %d", rq_servact);
 			mx_resp_len = 0;
 			break;
-        }
-        return mx_resp_len;
+	}
+	return mx_resp_len;
 }
diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
index d69a732..cd58201 100644
--- a/libmpathpersist/mpathpr.h
+++ b/libmpathpersist/mpathpr.h
@@ -3,26 +3,26 @@
 
 struct prin_param {
 	char dev[FILE_NAME_SIZE];
-        int rq_servact;
-        struct prin_resp *resp;
-        int noisy;
-        int status;
+	int rq_servact;
+	struct prin_resp *resp;
+	int noisy;
+	int status;
 };
 
 struct prout_param {
 	char dev[FILE_NAME_SIZE];
-        int rq_servact;
-        int rq_scope;
-        unsigned int rq_type;
-        struct prout_param_descriptor  *paramp;
-        int noisy;
-        int status;
+	int rq_servact;
+	int rq_scope;
+	unsigned int rq_type;
+	struct prout_param_descriptor  *paramp;
+	int noisy;
+	int status;
 };
 
 struct threadinfo {
-        int status;
-        pthread_t id;
-        struct prout_param param;
+	int status;
+	pthread_t id;
+	struct prout_param param;
 };
 
 
@@ -31,7 +31,7 @@ struct config * conf;
 
 int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int noisy);
 int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
-                unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
+		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
 void * _mpath_pr_update (void *arg);
 int mpath_send_prin_activepath (char * dev, int rq_servact, struct prin_resp * resp, int noisy);
 int get_mpvec (vector curmp, vector pathvec, char * refwwid);
@@ -39,13 +39,13 @@ void * mpath_prout_pthread_fn(void *p);
 void dumpHex(const char* , int len, int no_ascii);
 
 int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
-        unsigned int rq_type,  struct prout_param_descriptor * paramp, int noisy);
+	unsigned int rq_type,  struct prout_param_descriptor * paramp, int noisy);
 int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope,
-        unsigned int rq_type,  struct prout_param_descriptor * paramp, int noisy);
+	unsigned int rq_type,  struct prout_param_descriptor * paramp, int noisy);
 int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
-        unsigned int rq_type,  struct prout_param_descriptor * paramp, int noisy);
+	unsigned int rq_type,  struct prout_param_descriptor * paramp, int noisy);
 int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
-        unsigned int rq_type,   struct prout_param_descriptor * paramp, int noisy);
+	unsigned int rq_type,   struct prout_param_descriptor * paramp, int noisy);
 
 int update_prflag(char * arg1, char * arg2, int noisy);
 void * mpath_alloc_prin_response(int prin_sa);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a9b9cf0..4b9d0c6 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -459,7 +459,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 		return;
 	}
 	if (mpp->retain_hwhandler != RETAIN_HWHANDLER_ON &&
-            (strlen(cmpp->hwhandler) != strlen(mpp->hwhandler) ||
+	    (strlen(cmpp->hwhandler) != strlen(mpp->hwhandler) ||
 	     strncmp(cmpp->hwhandler, mpp->hwhandler,
 		    strlen(mpp->hwhandler)))) {
 		mpp->action = ACT_RELOAD;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index b50e9e6..2c76d8b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -167,9 +167,9 @@ dm_drv_version (unsigned int * version, char * str)
 		goto out;
 	}
 	v = target->version;
-        version[0] = v[0];
-        version[1] = v[1];
-        version[2] = v[2];
+	version[0] = v[0];
+	version[1] = v[1];
+	version[2] = v[2];
 	r = 0;
 out:
 	dm_task_destroy(dmt);
@@ -181,7 +181,7 @@ dm_drv_prereq (void)
 {
 	unsigned int minv[3] = {1, 0, 3};
 	unsigned int version[3] = {0, 0, 0};
-        unsigned int * v = version;
+	unsigned int * v = version;
 
 	if (dm_drv_version(v, TGT_MPATH)) {
 		/* in doubt return not capable */
diff --git a/libmultipath/memory.h b/libmultipath/memory.h
index 882699b..8573f6f 100644
--- a/libmultipath/memory.h
+++ b/libmultipath/memory.h
@@ -46,13 +46,13 @@ int debug;
 #define MAX_ALLOC_LIST 2048
 
 #define MALLOC(n)    ( dbg_malloc((n), \
-                      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
+		      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
 #define FREE(b)      ( dbg_free((b), \
-                      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
+		      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
 #define REALLOC(b,n) ( dbg_realloc((b), (n), \
-                      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
+		      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
 #define STRDUP(n)    ( dbg_strdup((n), \
-                      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
+		      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
 
 /* Memory debug prototypes defs */
 extern void *dbg_malloc(unsigned long, char *, char *, int);
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 196af61..9c94f66 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1671,12 +1671,12 @@ snprint_status (char * buff, int len, struct vectors *vecs)
 				checker_state_name(i), count[i]);
 	}
 
-        int monitored_count = 0;
+	int monitored_count = 0;
 
-        vector_foreach_slot(vecs->pathvec, pp, i)
-                if (pp->fd != -1)
-                        monitored_count++;
-        fwd += snprintf(buff + fwd, len - fwd, "\npaths: %d\nbusy: %s\n",
+	vector_foreach_slot(vecs->pathvec, pp, i)
+		if (pp->fd != -1)
+			monitored_count++;
+	fwd += snprintf(buff + fwd, len - fwd, "\npaths: %d\nbusy: %s\n",
 			monitored_count, is_uevent_busy()? "True" : "False");
 
 	if (fwd > len)
diff --git a/libmultipath/print.h b/libmultipath/print.h
index b532f24..1a79030 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -11,7 +11,7 @@
 #define PRINT_JSON_MAJOR_VERSION  0
 #define PRINT_JSON_MINOR_VERSION  1
 #define PRINT_JSON_START_VERSION  "   \"major_version\": %d,\n" \
-                                  "   \"minor_version\": %d,\n"
+				  "   \"minor_version\": %d,\n"
 #define PRINT_JSON_START_ELEM     "{\n"
 #define PRINT_JSON_START_MAP      "   \"map\":"
 #define PRINT_JSON_START_MAPS     "\"maps\": ["
@@ -23,46 +23,46 @@
 #define PRINT_JSON_END_ARRAY      "]\n"
 #define PRINT_JSON_INDENT    "   "
 #define PRINT_JSON_MAP       "{\n" \
-                             "      \"name\" : \"%n\",\n" \
-                             "      \"uuid\" : \"%w\",\n" \
-                             "      \"sysfs\" : \"%d\",\n" \
-                             "      \"failback\" : \"%F\",\n" \
-                             "      \"queueing\" : \"%Q\",\n" \
-                             "      \"paths\" : %N,\n" \
-                             "      \"write_prot\" : \"%r\",\n" \
-                             "      \"dm_st\" : \"%t\",\n" \
-                             "      \"features\" : \"%f\",\n" \
-                             "      \"hwhandler\" : \"%h\",\n" \
-                             "      \"action\" : \"%A\",\n" \
-                             "      \"path_faults\" : %0,\n" \
-                             "      \"vend\" : \"%v\",\n" \
-                             "      \"prod\" : \"%p\",\n" \
-                             "      \"rev\" : \"%e\",\n" \
-                             "      \"switch_grp\" : %1,\n" \
-                             "      \"map_loads\" : %2,\n" \
-                             "      \"total_q_time\" : %3,\n" \
-                             "      \"q_timeouts\" : %4,"
+			     "      \"name\" : \"%n\",\n" \
+			     "      \"uuid\" : \"%w\",\n" \
+			     "      \"sysfs\" : \"%d\",\n" \
+			     "      \"failback\" : \"%F\",\n" \
+			     "      \"queueing\" : \"%Q\",\n" \
+			     "      \"paths\" : %N,\n" \
+			     "      \"write_prot\" : \"%r\",\n" \
+			     "      \"dm_st\" : \"%t\",\n" \
+			     "      \"features\" : \"%f\",\n" \
+			     "      \"hwhandler\" : \"%h\",\n" \
+			     "      \"action\" : \"%A\",\n" \
+			     "      \"path_faults\" : %0,\n" \
+			     "      \"vend\" : \"%v\",\n" \
+			     "      \"prod\" : \"%p\",\n" \
+			     "      \"rev\" : \"%e\",\n" \
+			     "      \"switch_grp\" : %1,\n" \
+			     "      \"map_loads\" : %2,\n" \
+			     "      \"total_q_time\" : %3,\n" \
+			     "      \"q_timeouts\" : %4,"
 
 #define PRINT_JSON_GROUP     "{\n" \
-                             "         \"selector\" : \"%s\",\n" \
-                             "         \"pri\" : %p,\n" \
-                             "         \"dm_st\" : \"%t\","
+			     "         \"selector\" : \"%s\",\n" \
+			     "         \"pri\" : %p,\n" \
+			     "         \"dm_st\" : \"%t\","
 
 #define PRINT_JSON_GROUP_NUM "         \"group\" : %d,\n"
 
 #define PRINT_JSON_PATH      "{\n" \
-                             "            \"dev\" : \"%d\",\n"\
-                             "            \"dev_t\" : \"%D\",\n" \
-                             "            \"dm_st\" : \"%t\",\n" \
-                             "            \"dev_st\" : \"%o\",\n" \
-                             "            \"chk_st\" : \"%T\",\n" \
-                             "            \"checker\" : \"%c\",\n" \
-                             "            \"pri\" : %p,\n" \
-                             "            \"host_wwnn\" : \"%N\",\n" \
-                             "            \"target_wwnn\" : \"%n\",\n" \
-                             "            \"host_wwpn\" : \"%R\",\n" \
-                             "            \"target_wwpn\" : \"%r\",\n" \
-                             "            \"host_adapter\" : \"%a\""
+			     "            \"dev\" : \"%d\",\n"\
+			     "            \"dev_t\" : \"%D\",\n" \
+			     "            \"dm_st\" : \"%t\",\n" \
+			     "            \"dev_st\" : \"%o\",\n" \
+			     "            \"chk_st\" : \"%T\",\n" \
+			     "            \"checker\" : \"%c\",\n" \
+			     "            \"pri\" : %p,\n" \
+			     "            \"host_wwnn\" : \"%N\",\n" \
+			     "            \"target_wwnn\" : \"%n\",\n" \
+			     "            \"host_wwpn\" : \"%R\",\n" \
+			     "            \"target_wwpn\" : \"%r\",\n" \
+			     "            \"host_adapter\" : \"%a\""
 
 #define MAX_LINE_LEN  80
 #define MAX_LINES     64
diff --git a/libmultipath/prioritizers/datacore.c b/libmultipath/prioritizers/datacore.c
index e3e6a51..658a598 100644
--- a/libmultipath/prioritizers/datacore.c
+++ b/libmultipath/prioritizers/datacore.c
@@ -46,7 +46,7 @@ int datacore_prio (const char *dev, int sg_fd, char * args)
 	unsigned char sense_buffer[32];
 	sg_io_hdr_t io_hdr;
 
-        int timeout = 2000;
+	int timeout = 2000;
 	char preferredsds_buff[255] = "";
 	char * preferredsds = &preferredsds_buff[0];
 
@@ -56,7 +56,7 @@ int datacore_prio (const char *dev, int sg_fd, char * args)
 	}
 
 	if (sscanf(args, "timeout=%i preferredsds=%s",
-                   &timeout, preferredsds) == 2) {}
+		   &timeout, preferredsds) == 2) {}
 	else if (sscanf(args, "preferredsds=%s timeout=%i",
 			preferredsds, &timeout) == 2) {}
 	else if (sscanf(args, "preferredsds=%s",
@@ -108,6 +108,6 @@ int datacore_prio (const char *dev, int sg_fd, char * args)
 
 int getprio (struct path * pp, char * args)
 {
-        return datacore_prio(pp->dev, pp->fd, args);
+	return datacore_prio(pp->dev, pp->fd, args);
 }
 
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index be00e44..b8df8f0 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -82,7 +82,7 @@
 #define INQ_CMD_LEN 6
 
 #define pp_hds_log(prio, fmt, args...) \
-        condlog(prio, "%s: hds prio: " fmt, dev, ##args)
+	condlog(prio, "%s: hds prio: " fmt, dev, ##args)
 
 int hds_modular_prio (const char *dev, int fd, unsigned int timeout)
 {
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index d6872fe..f78e1f6 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -31,7 +31,7 @@
 #define SG_TIMEOUT	60000
 
 #define pp_ontap_log(prio, fmt, args...) \
-        condlog(prio, "%s: ontap prio: " fmt, dev, ##args)
+	condlog(prio, "%s: ontap prio: " fmt, dev, ##args)
 
 static void dump_cdb(unsigned char *cdb, int size)
 {
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 5fb831e..c46fca5 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -243,15 +243,15 @@ int main (int argc, char * argv[])
 				break;
 
 			case 'l':
-                                if (1 != sscanf(optarg, "%u", &mpath_mx_alloc_len)) {
-                                        fprintf(stderr, "bad argument to '--alloc-length'\n");
-                                        return MPATH_PR_SYNTAX_ERROR;
-                                } else if (MPATH_MAX_PARAM_LEN < mpath_mx_alloc_len) {
-                                        fprintf(stderr, "'--alloc-length' argument exceeds maximum"
-                                                        " limit(%d)\n", MPATH_MAX_PARAM_LEN);
-                                        return MPATH_PR_SYNTAX_ERROR;
-                                }
-                                break;
+				if (1 != sscanf(optarg, "%u", &mpath_mx_alloc_len)) {
+					fprintf(stderr, "bad argument to '--alloc-length'\n");
+					return MPATH_PR_SYNTAX_ERROR;
+				} else if (MPATH_MAX_PARAM_LEN < mpath_mx_alloc_len) {
+					fprintf(stderr, "'--alloc-length' argument exceeds maximum"
+							" limit(%d)\n", MPATH_MAX_PARAM_LEN);
+					return MPATH_PR_SYNTAX_ERROR;
+				}
+				break;
 
 			default:
 				fprintf(stderr, "unrecognised switch " "code 0x%x ??\n", c);
@@ -745,9 +745,9 @@ mpath_print_transport_id(struct prin_fulldescr *fdesc)
 		case MPATH_PROTOCOL_ID_SAS:
 			printf("   SAS ");
 			 if (0 != fdesc->trnptid.format_code)
-                                printf(" [Unexpected format code: %d]\n",
-                                                fdesc->trnptid.format_code);
-                        dumpHex((const char *)fdesc->trnptid.sas_address, 8, 0);
+				printf(" [Unexpected format code: %d]\n",
+						fdesc->trnptid.format_code);
+			dumpHex((const char *)fdesc->trnptid.sas_address, 8, 0);
 			break;
 		default:
 			return;
-- 
2.7.4
