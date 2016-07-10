From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] multipath-tools: clean stealth whitespaces
	*.[ch]
Date: Sun, 10 Jul 2016 12:28:16 +0200
Message-ID: <1468146497-8170-2-git-send-email-xose.vazquez@gmail.com>
References: <1468146497-8170-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468146497-8170-1-git-send-email-xose.vazquez@gmail.com>
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
---
 kpartx/crc32.c                           | 32 ++++++++---------
 kpartx/dasd.h                            |  4 +--
 kpartx/gpt.c                             |  2 +-
 kpartx/ps3.c                             |  5 ---
 kpartx/solaris.c                         |  5 ++-
 kpartx/sun.c                             |  1 -
 kpartx/unixware.c                        |  6 ++--
 libmpathcmd/mpath_cmd.h                  | 60 ++++++++++++++++----------------
 libmpathpersist/mpath_persist.c          |  3 --
 libmpathpersist/mpath_persist.h          | 30 ++++++++--------
 libmpathpersist/mpath_pr_ioctl.c         |  2 +-
 libmpathpersist/mpath_pr_ioctl.h         |  2 --
 libmultipath/checkers/cciss.h            |  1 -
 libmultipath/config.c                    |  1 -
 libmultipath/list.h                      |  6 ++--
 libmultipath/lock.c                      |  1 -
 libmultipath/log_pthread.c               |  1 -
 libmultipath/print.c                     |  1 -
 libmultipath/print.h                     |  1 -
 libmultipath/prioritizers/alua_rtpg.c    |  1 -
 libmultipath/prioritizers/alua_rtpg.h    |  1 -
 libmultipath/prioritizers/alua_spc3.h    |  1 -
 libmultipath/prioritizers/datacore.c     |  1 -
 libmultipath/prioritizers/weightedpath.c |  1 -
 libmultipath/structs.c                   |  1 -
 libmultipath/structs_vec.c               |  1 -
 libmultipath/waiter.c                    |  1 -
 mpathpersist/main.c                      |  1 -
 mpathpersist/main.h                      |  1 -
 multipathd/cli.c                         |  1 -
 multipathd/cli_handlers.h                |  1 -
 multipathd/main.c                        |  1 -
 multipathd/uxlsnr.h                      |  1 -
 33 files changed, 73 insertions(+), 105 deletions(-)

diff --git a/kpartx/crc32.c b/kpartx/crc32.c
index cfbe8a5..b23a083 100644
--- a/kpartx/crc32.c
+++ b/kpartx/crc32.c
@@ -277,8 +277,8 @@ uint32_t attribute((pure)) crc32_be(uint32_t crc, unsigned char const *p, size_t
  *
  * A big-endian CRC written this way would be coded like:
  * for (i = 0; i < input_bits; i++) {
- * 	multiple = remainder & 0x80000000 ? CRCPOLY : 0;
- * 	remainder = (remainder << 1 | next_input_bit()) ^ multiple;
+ *	multiple = remainder & 0x80000000 ? CRCPOLY : 0;
+ *	remainder = (remainder << 1 | next_input_bit()) ^ multiple;
  * }
  * Notice how, to get at bit 32 of the shifted remainder, we look
  * at bit 31 of the remainder *before* shifting it.
@@ -297,14 +297,14 @@ uint32_t attribute((pure)) crc32_be(uint32_t crc, unsigned char const *p, size_t
  * This changes the code to:
  * for (i = 0; i < input_bits; i++) {
  *      remainder ^= next_input_bit() << 31;
- * 	multiple = (remainder & 0x80000000) ? CRCPOLY : 0;
- * 	remainder = (remainder << 1) ^ multiple;
+ *	multiple = (remainder & 0x80000000) ? CRCPOLY : 0;
+ *	remainder = (remainder << 1) ^ multiple;
  * }
  * With this optimization, the little-endian code is simpler:
  * for (i = 0; i < input_bits; i++) {
  *      remainder ^= next_input_bit();
- * 	multiple = (remainder & 1) ? CRCPOLY : 0;
- * 	remainder = (remainder >> 1) ^ multiple;
+ *	multiple = (remainder & 1) ? CRCPOLY : 0;
+ *	remainder = (remainder >> 1) ^ multiple;
  * }
  *
  * Note that the other details of endianness have been hidden in CRCPOLY
@@ -314,19 +314,19 @@ uint32_t attribute((pure)) crc32_be(uint32_t crc, unsigned char const *p, size_t
  * order, we can actually do the merging 8 or more bits at a time rather
  * than one bit at a time:
  * for (i = 0; i < input_bytes; i++) {
- * 	remainder ^= next_input_byte() << 24;
- * 	for (j = 0; j < 8; j++) {
- * 		multiple = (remainder & 0x80000000) ? CRCPOLY : 0;
- * 		remainder = (remainder << 1) ^ multiple;
- * 	}
+ *	remainder ^= next_input_byte() << 24;
+ *	for (j = 0; j < 8; j++) {
+ *		multiple = (remainder & 0x80000000) ? CRCPOLY : 0;
+ *		remainder = (remainder << 1) ^ multiple;
+ *	}
  * }
  * Or in little-endian:
  * for (i = 0; i < input_bytes; i++) {
- * 	remainder ^= next_input_byte();
- * 	for (j = 0; j < 8; j++) {
- * 		multiple = (remainder & 1) ? CRCPOLY : 0;
- * 		remainder = (remainder << 1) ^ multiple;
- * 	}
+ *	remainder ^= next_input_byte();
+ *	for (j = 0; j < 8; j++) {
+ *		multiple = (remainder & 1) ? CRCPOLY : 0;
+ *		remainder = (remainder << 1) ^ multiple;
+ *	}
  * }
  * If the input is a multiple of 32 bits, you can even XOR in a 32-bit
  * word at a time and increase the inner loop count to 32.
diff --git a/kpartx/dasd.h b/kpartx/dasd.h
index 2779366..961969e 100644
--- a/kpartx/dasd.h
+++ b/kpartx/dasd.h
@@ -113,7 +113,7 @@ typedef struct format1_label
         uint16_t DS1SCXTV;           /* secondary space extension value         */
         uint8_t  DS1DSRG1;           /* data set organisation byte 1            */
         uint8_t  DS1DSRG2;           /* data set organisation byte 2            */
-  	uint8_t  DS1RECFM;           /* record format                           */
+	uint8_t  DS1RECFM;           /* record format                           */
 	uint8_t  DS1OPTCD;           /* option code                             */
 	uint16_t DS1BLKL;            /* block length                            */
 	uint16_t DS1LRECL;           /* record length                           */
@@ -121,7 +121,7 @@ typedef struct format1_label
 	uint16_t DS1RKP;             /* relative key position                   */
 	uint8_t  DS1DSIND;           /* data set indicators                     */
         uint8_t  DS1SCAL1;           /* secondary allocation flag byte          */
-  	char DS1SCAL3[3];         /* secondary allocation quantity           */
+	char DS1SCAL3[3];         /* secondary allocation quantity           */
 	ttr_t DS1LSTAR;           /* last used track and block on track      */
 	uint16_t DS1TRBAL;           /* space remaining on last used track      */
         uint16_t res1;               /* reserved                                */
diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index 416eac8..de6d58d 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -333,7 +333,7 @@ is_gpt_valid(int fd, uint64_t lba,
 	if (__le64_to_cpu((*gpt)->my_lba) != lba) {
 		/*
 		printf( "my_lba % PRIx64 "x != lba %"PRIx64 "x.\n",
-		 		__le64_to_cpu((*gpt)->my_lba), lba);
+				__le64_to_cpu((*gpt)->my_lba), lba);
 		 */
 		free(*gpt);
 		*gpt = NULL;
diff --git a/kpartx/ps3.c b/kpartx/ps3.c
index d1e5d64..c17124d 100644
--- a/kpartx/ps3.c
+++ b/kpartx/ps3.c
@@ -70,8 +70,3 @@ read_ps3_pt(int fd, struct slice all, struct slice *sp, int ns) {
 
 	return n;
 }
-
-
-
-
-
diff --git a/kpartx/solaris.c b/kpartx/solaris.c
index e3000e9..355a6cb 100644
--- a/kpartx/solaris.c
+++ b/kpartx/solaris.c
@@ -11,7 +11,7 @@
 struct solaris_x86_slice {
 	unsigned short	s_tag;		/* ID tag of partition */
 	unsigned short	s_flag;		/* permision flags */
-	daddr_t 	s_start;	/* start sector no of partition */
+	daddr_t		s_start;	/* start sector no of partition */
 	long		s_size;		/* # of blocks in partition */
 };
 
@@ -37,7 +37,7 @@ read_solaris_pt(int fd, struct slice all, struct slice *sp, int ns) {
 	int i, n;
 	char *bp;
 
-	bp = getblock(fd, offset+1); 	/* 1 sector suffices */
+	bp = getblock(fd, offset+1);	/* 1 sector suffices */
 	if (bp == NULL)
 		return -1;
 
@@ -68,4 +68,3 @@ read_solaris_pt(int fd, struct slice all, struct slice *sp, int ns) {
 	}
 	return n;
 }
-
diff --git a/kpartx/sun.c b/kpartx/sun.c
index b8c023b..276066d 100644
--- a/kpartx/sun.c
+++ b/kpartx/sun.c
@@ -126,4 +126,3 @@ read_sun_pt(int fd, struct slice all, struct slice *sp, int ns) {
 	}
 	return n;
 }
-
diff --git a/kpartx/unixware.c b/kpartx/unixware.c
index 41cc957..c7b9786 100644
--- a/kpartx/unixware.c
+++ b/kpartx/unixware.c
@@ -17,7 +17,7 @@ struct unixware_disklabel {
 	unsigned int   d_type;		/* drive type */
 	unsigned char  d_magic[4];	/* the magic number */
 	unsigned int   d_version;	/* version number */
-	char    d_serial[12];	   	/* serial number of the device */
+	char    d_serial[12];		/* serial number of the device */
 	unsigned int   d_ncylinders;	/* # of data cylinders per device */
 	unsigned int   d_ntracks;	/* # of tracks per cylinder */
 	unsigned int   d_nsectors;	/* # of data sectors per track */
@@ -37,7 +37,7 @@ struct unixware_disklabel {
 	struct unixware_vtoc {
 		unsigned char   v_magic[4];	/* the magic number */
 		unsigned int    v_version;	/* version number */
-		char    v_name[8];	      	/* volume name */
+		char    v_name[8];		/* volume name */
 		unsigned short  v_nslices;	/* # of slices */
 		unsigned short  v_unknown1;	/* ? */
 		unsigned int    v_reserved[10];	/* reserved */
@@ -55,7 +55,7 @@ read_unixware_pt(int fd, struct slice all, struct slice *sp, int ns) {
 	char *bp;
 	int n = 0;
 
-	bp = getblock(fd, offset+29); 	/* 1 sector suffices */
+	bp = getblock(fd, offset+29);	/* 1 sector suffices */
 	if (bp == NULL)
 		return -1;
 
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index 92382e2..7293d91 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -31,38 +31,38 @@ extern "C" {
 
 /*
  * DESCRIPTION:
- * 	Connect to the running multipathd daemon. On systems with the
- * 	multipathd.socket systemd unit file installed, this command will
- * 	start multipathd if it is not already running. This function
- * 	must be run before any of the others in this library
+ *	Connect to the running multipathd daemon. On systems with the
+ *	multipathd.socket systemd unit file installed, this command will
+ *	start multipathd if it is not already running. This function
+ *	must be run before any of the others in this library
  *
  * RETURNS:
- * 	A file descriptor on success. -1 on failure (with errno set).
+ *	A file descriptor on success. -1 on failure (with errno set).
  */
 int mpath_connect(void);
 
 
 /*
  * DESCRIPTION:
- * 	Disconnect from the multipathd daemon. This function must be
- * 	run after after processing all the multipath commands.
+ *	Disconnect from the multipathd daemon. This function must be
+ *	run after after processing all the multipath commands.
  *
  * RETURNS:
- * 	0 on success. -1 on failure (with errno set).
+ *	0 on success. -1 on failure (with errno set).
  */
 int mpath_disconnect(int fd);
 
 
 /*
  * DESCRIPTION
- * 	Send multipathd a command and return the reply. This function
- * 	does the same as calling mpath_send_cmd() and then
+ *	Send multipathd a command and return the reply. This function
+ *	does the same as calling mpath_send_cmd() and then
  *	mpath_recv_reply()
  *
  * RETURNS:
- * 	0 on successs, and reply will either be NULL (if there was no
- * 	reply data), or point to the reply string, which must be freed by
- * 	the caller. -1 on failure (with errno set).
+ *	0 on successs, and reply will either be NULL (if there was no
+ *	reply data), or point to the reply string, which must be freed by
+ *	the caller. -1 on failure (with errno set).
  */
 int mpath_process_cmd(int fd, const char *cmd, char **reply,
 		      unsigned int timeout);
@@ -70,50 +70,50 @@ int mpath_process_cmd(int fd, const char *cmd, char **reply,
 
 /*
  * DESCRIPTION:
- * 	Send a command to multipathd
+ *	Send a command to multipathd
  *
  * RETURNS:
- * 	0 on success. -1 on failure (with errno set)
+ *	0 on success. -1 on failure (with errno set)
  */
 int mpath_send_cmd(int fd, const char *cmd);
 
 
 /*
  * DESCRIPTION:
- * 	Return a reply from multipathd for a previously sent command.
- * 	This is equivalent to calling mpath_recv_reply_len(), allocating
- * 	a buffer of the appropriate size, and then calling
+ *	Return a reply from multipathd for a previously sent command.
+ *	This is equivalent to calling mpath_recv_reply_len(), allocating
+ *	a buffer of the appropriate size, and then calling
  *	mpath_recv_reply_data() with that buffer.
  *
  * RETURNS:
- * 	0 on success, and reply will either be NULL (if there was no
- * 	reply data), or point to the reply string, which must be freed by
- * 	the caller, -1 on failure (with errno set).
+ *	0 on success, and reply will either be NULL (if there was no
+ *	reply data), or point to the reply string, which must be freed by
+ *	the caller, -1 on failure (with errno set).
  */
 int mpath_recv_reply(int fd, char **reply, unsigned int timeout);
 
 
 /*
  * DESCRIPTION:
- * 	Return the size of the upcoming reply data from the sent multipath
- * 	command. This must be called before calling mpath_recv_reply_data().
+ *	Return the size of the upcoming reply data from the sent multipath
+ *	command. This must be called before calling mpath_recv_reply_data().
  *
  * RETURNS:
- * 	The required size of the reply data buffer on success. -1 on
- * 	failure (with errno set).
+ *	The required size of the reply data buffer on success. -1 on
+ *	failure (with errno set).
  */
 ssize_t mpath_recv_reply_len(int fd, unsigned int timeout);
 
 
 /*
  * DESCRIPTION:
- * 	Return the reply data from the sent multipath command.
- * 	mpath_recv_reply_len must be called first. reply must point to a
- * 	buffer of len size.
+ *	Return the reply data from the sent multipath command.
+ *	mpath_recv_reply_len must be called first. reply must point to a
+ *	buffer of len size.
  *
  * RETURNS:
- * 	0 on success, and reply will contain the reply data string. -1
- * 	on failure (with errno set).
+ *	0 on success, and reply will contain the reply data string. -1
+ *	on failure (with errno set).
  */
 int mpath_recv_reply_data(int fd, char *reply, size_t len,
 			  unsigned int timeout);
diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index b037822..2936b5f 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -925,6 +925,3 @@ int update_map_pr(struct multipath *mpp)
 	free(resp);
 	return MPATH_PR_SUCCESS;
 }
-
-
-
diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index ef24d64..fde0416 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -12,7 +12,7 @@ extern "C" {
 
 #define MPATH_MAX_PARAM_LEN	8192
 
-#define MPATH_MX_TIDS 		32	  /* Max number of transport ids"*/
+#define MPATH_MX_TIDS		32	  /* Max number of transport ids"*/
 #define MPATH_MX_TID_LEN	256	  /* Max lenght of transport id */
 
 /* PRIN Service Actions */
@@ -34,24 +34,24 @@ extern "C" {
 #define MPATH_LU_SCOPE		0x00	    /* LU_SCOPE */
 
 /* Persistent reservations type */
-#define MPATH_PRTPE_WE	 	0x01	    /* Write Exclusive */
-#define MPATH_PRTPE_EA 		0x03	    /* Exclusive Access*/
-#define MPATH_PRTPE_WE_RO 	0x05	    /* WriteExclusive Registrants Only */
-#define MPATH_PRTPE_EA_RO 	0x06	    /* Exclusive Access. Registrants Only*/
+#define MPATH_PRTPE_WE		0x01	    /* Write Exclusive */
+#define MPATH_PRTPE_EA		0x03	    /* Exclusive Access*/
+#define MPATH_PRTPE_WE_RO	0x05	    /* WriteExclusive Registrants Only */
+#define MPATH_PRTPE_EA_RO	0x06	    /* Exclusive Access. Registrants Only*/
 #define MPATH_PRTPE_WE_AR	0x07	    /* Write Exclusive. All Registrants*/
-#define MPATH_PRTPE_EA_AR 	0x08	    /* Exclusive Access. All Registrants */
+#define MPATH_PRTPE_EA_AR	0x08	    /* Exclusive Access. All Registrants */
 
 
 /* PR RETURN_STATUS */
-#define MPATH_PR_SUCCESS 		0
+#define MPATH_PR_SUCCESS		0
 #define MPATH_PR_SYNTAX_ERROR		1   /*  syntax error or invalid parameter */
 					    /* status for check condition */
-#define MPATH_PR_SENSE_NOT_READY 	2   /*	[sk,asc,ascq: 0x2,*,*] */
+#define MPATH_PR_SENSE_NOT_READY	2   /*	[sk,asc,ascq: 0x2,*,*] */
 #define MPATH_PR_SENSE_MEDIUM_ERROR	3   /*	[sk,asc,ascq: 0x3,*,*] */
 #define MPATH_PR_SENSE_HARDWARE_ERROR	4   /*	[sk,asc,ascq: 0x4,*,*] */
-#define MPATH_PR_ILLEGAL_REQ 		5   /*	[sk,asc,ascq: 0x5,*,*]*/
+#define MPATH_PR_ILLEGAL_REQ		5   /*	[sk,asc,ascq: 0x5,*,*]*/
 #define MPATH_PR_SENSE_UNIT_ATTENTION	6   /*	[sk,asc,ascq: 0x6,*,*] */
-#define MPATH_PR_SENSE_INVALID_OP	7   /* 	[sk,asc,ascq: 0x5,0x20,0x0]*/
+#define MPATH_PR_SENSE_INVALID_OP	7   /*	[sk,asc,ascq: 0x5,0x20,0x0]*/
 #define MPATH_PR_SENSE_ABORTED_COMMAND  8   /*  [sk,asc,ascq: 0xb,*,*] */
 #define MPATH_PR_NO_SENSE		9   /*	[sk,asc,ascq: 0x0,*,*] */
 
@@ -66,7 +66,7 @@ extern "C" {
 #define MPATH_F_APTPL_MASK		0x01	/* APTPL MASK*/
 #define MPATH_F_ALL_TG_PT_MASK		0x04	/* ALL_TG_PT MASK*/
 #define MPATH_F_SPEC_I_PT_MASK		0x08	/* SPEC_I_PT MASK*/
-#define MPATH_PR_TYPE_MASK 		0x0f	/* TYPE MASK*/
+#define MPATH_PR_TYPE_MASK		0x0f	/* TYPE MASK*/
 #define MPATH_PR_SCOPE_MASK		0xf0	/* SCOPE MASK*/
 
 /*Transport ID PROTOCOL IDENTIFIER values */
@@ -125,7 +125,7 @@ struct transportid
 struct prin_fulldescr
 {
 	uint8_t key[8];
-	uint8_t flag; 			/* All_tg_pt and reservation holder */
+	uint8_t flag;			/* All_tg_pt and reservation holder */
 	uint8_t scope_type;		/* Use PR SCOPE AND TYPE MASK specified above.
 					   Meaningful only for reservation holder */
 	uint16_t rtpi;
@@ -151,7 +151,7 @@ struct prin_resp
 	}prin_descriptor;
 };
 
-struct prout_param_descriptor { 	/* PROUT parameter descriptor */
+struct prout_param_descriptor {		/* PROUT parameter descriptor */
 	uint8_t	 key[8];
 	uint8_t	 sa_key[8];
 	uint32_t _obsolete;
@@ -195,7 +195,7 @@ extern int mpath_lib_exit (struct config *conf);
  * @fd:	The file descriptor of a multipath device. Input argument.
  * @rq_servact: PRIN command service action. Input argument
  * @resp: The response from PRIN service action. The resp is a struct specified above. The caller should
- * 	manage the memory allocation of this struct
+ *	manage the memory allocation of this struct
  * @noisy: Turn on debugging trace: Input argument. 0->Disable, 1->Enable
  * @verbose: Set verbosity level. Input argument. value:[0-3]. 0->disabled, 3->Max verbose
  *
@@ -221,7 +221,7 @@ extern int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp
  *	7h (Write exclusive - All registrants)
  *	8h (Exclusive access - All registrants).
  * @paramp: PROUT command parameter data. The paramp is a struct which describes PROUT
- * 	    parameter list. The caller should manage the memory allocation of this struct.
+ *	    parameter list. The caller should manage the memory allocation of this struct.
  * @noisy: Turn on debugging trace: Input argument.0->Disable, 1->Enable.
  * @verbose: Set verbosity level. Input argument. value:0 to 3. 0->disabled, 3->Max verbose
  *
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index e45ae1e..d02ea67 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -307,7 +307,7 @@ int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int
 	snprintf(devname, FILE_NAME_SIZE, "/dev/%s",dev);
         fd = open(devname, O_WRONLY);
         if(fd < 0){
-        	condlog(0, "%s: Unable to open device ", dev);
+		condlog(0, "%s: Unable to open device ", dev);
 		return MPATH_PR_FILE_ERROR;
          }
 
diff --git a/libmpathpersist/mpath_pr_ioctl.h b/libmpathpersist/mpath_pr_ioctl.h
index 573ff15..7dfda5a 100644
--- a/libmpathpersist/mpath_pr_ioctl.h
+++ b/libmpathpersist/mpath_pr_ioctl.h
@@ -107,5 +107,3 @@ typedef struct SenseData
 
 /* Driver status */
 #define DRIVER_OK 0x00
-
-
diff --git a/libmultipath/checkers/cciss.h b/libmultipath/checkers/cciss.h
index ebdff06..c9fa84a 100644
--- a/libmultipath/checkers/cciss.h
+++ b/libmultipath/checkers/cciss.h
@@ -139,4 +139,3 @@ void cciss_free (struct checker * c);
 int cciss_tur( struct checker *);
 
 #endif
-
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 9a75b4e..a48b8af 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -734,4 +734,3 @@ out:
 	free_config(conf);
 	return NULL;
 }
-
diff --git a/libmultipath/list.h b/libmultipath/list.h
index 6d1e949..ceaa381 100644
--- a/libmultipath/list.h
+++ b/libmultipath/list.h
@@ -290,7 +290,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_entry((head)->next, typeof(*pos), member);	\
-	     &pos->member != (head); 					\
+	     &pos->member != (head);					\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
@@ -301,7 +301,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
 	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
-	     &pos->member != (head); 					\
+	     &pos->member != (head);					\
 	     pos = list_entry(pos->member.prev, typeof(*pos), member))
 
 /**
@@ -314,7 +314,7 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_entry((head)->next, typeof(*pos), member),	\
 		n = list_entry(pos->member.next, typeof(*pos), member);	\
-	     &pos->member != (head); 					\
+	     &pos->member != (head);					\
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
 #endif /* _LIST_H */
diff --git a/libmultipath/lock.c b/libmultipath/lock.c
index 6ce9a74..ec53a5e 100644
--- a/libmultipath/lock.c
+++ b/libmultipath/lock.c
@@ -6,4 +6,3 @@ void cleanup_lock (void * data)
 {
 	unlock ((*(struct mutex_lock *)data));
 }
-
diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index e6f4b5c..4d85de5 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -130,4 +130,3 @@ void log_thread_stop (void)
 
 	log_close();
 }
-
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 196af61..4e12a66 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1827,4 +1827,3 @@ print_all_paths_custo (vector pathvec, int banner, char *fmt)
 	vector_foreach_slot (pathvec, pp, i)
 		print_path(pp, fmt);
 }
-
diff --git a/libmultipath/print.h b/libmultipath/print.h
index b532f24..a9d753d 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -125,4 +125,3 @@ void print_map (struct multipath * mpp, char * params);
 void print_all_paths (vector pathvec, int banner);
 void print_all_paths_custo (vector pathvec, int banner, char *fmt);
 void print_hwtable (vector hwtable);
-
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index ec8bd22..e9d8328 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -357,4 +357,3 @@ out:
 	free(buf);
 	return rc;
 }
-
diff --git a/libmultipath/prioritizers/alua_rtpg.h b/libmultipath/prioritizers/alua_rtpg.h
index dc16eb7..35cffaf 100644
--- a/libmultipath/prioritizers/alua_rtpg.h
+++ b/libmultipath/prioritizers/alua_rtpg.h
@@ -27,4 +27,3 @@ int get_target_port_group(struct path * pp, unsigned int timeout);
 int get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout);
 
 #endif /* __RTPG_H__ */
-
diff --git a/libmultipath/prioritizers/alua_spc3.h b/libmultipath/prioritizers/alua_spc3.h
index 42d5ecf..4d4969b 100644
--- a/libmultipath/prioritizers/alua_spc3.h
+++ b/libmultipath/prioritizers/alua_spc3.h
@@ -323,4 +323,3 @@ struct rtpg_data {
 		)
 
 #endif /* __SPC3_H__ */
-
diff --git a/libmultipath/prioritizers/datacore.c b/libmultipath/prioritizers/datacore.c
index e3e6a51..4f46ad9 100644
--- a/libmultipath/prioritizers/datacore.c
+++ b/libmultipath/prioritizers/datacore.c
@@ -110,4 +110,3 @@ int getprio (struct path * pp, char * args)
 {
         return datacore_prio(pp->dev, pp->fd, args);
 }
-
diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index ba8c555..f07d35c 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -140,4 +140,3 @@ int getprio(struct path *pp, char *args)
 {
 	return prio_path_weight(pp, args);
 }
-
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index ed62b07..fee58e5 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -689,4 +689,3 @@ out:
 
 	return 0;
 }
-
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 74c53eb..adb1911 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -636,4 +636,3 @@ void update_queue_mode_add_path(struct multipath *mpp)
 	}
 	condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_active);
 }
-
diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
index 34c0110..06995b6 100644
--- a/libmultipath/waiter.c
+++ b/libmultipath/waiter.c
@@ -213,4 +213,3 @@ out:
 	condlog(0, "failed to start waiter thread");
 	return 1;
 }
-
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 953def5..da74d11 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -834,4 +834,3 @@ my_cont_b:
 	}
 	return 0;
 }
-
diff --git a/mpathpersist/main.h b/mpathpersist/main.h
index 84b10e0..7c31262 100644
--- a/mpathpersist/main.h
+++ b/mpathpersist/main.h
@@ -26,4 +26,3 @@ static struct option long_options[] = {
 };
 
 static void usage(void);
-
diff --git a/multipathd/cli.c b/multipathd/cli.c
index dc675b5..49df174 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -688,4 +688,3 @@ key_generator (const char * str, int state)
 	 */
 	return ((char *)NULL);
 }
-
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index e838f19..19e003d 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -43,4 +43,3 @@ int cli_reassign (void * v, char ** reply, int * len, void * data);
 int cli_getprstatus(void * v, char ** reply, int * len, void * data);
 int cli_setprstatus(void * v, char ** reply, int * len, void * data);
 int cli_unsetprstatus(void * v, char ** reply, int * len, void * data);
-
diff --git a/multipathd/main.c b/multipathd/main.c
index 754a855..353de40 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2713,4 +2713,3 @@ int mpath_pr_event_handle(struct path *pp)
 	rc = pthread_join(thread, NULL);
 	return 0;
 }
-
diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
index d274b04..7839fce 100644
--- a/multipathd/uxlsnr.h
+++ b/multipathd/uxlsnr.h
@@ -10,4 +10,3 @@ extern volatile sig_atomic_t reconfig_sig;
 extern volatile sig_atomic_t log_reset_sig;
 
 #endif
-
-- 
2.7.4
