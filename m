From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 4/5] multipath-tools: replace leading spaces with
	tabs II
Date: Sat, 23 Jul 2016 02:29:11 +0200
Message-ID: <1469233752-11708-4-git-send-email-xose.vazquez@gmail.com>
References: <1469233752-11708-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469233752-11708-1-git-send-email-xose.vazquez@gmail.com>
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

Mainly replace less than 8 ^spaces with tabs where is required and remove
^space from goto labels.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/Makefile                   |   2 +-
 kpartx/dasd.c                     |   2 +-
 kpartx/gpt.c                      |   2 +-
 kpartx/kpartx.rules               |   2 +-
 libmpathpersist/mpath_pr_ioctl.h  |  96 +++++++++++++++++-----------------
 libmultipath/Makefile             |  12 ++---
 libmultipath/checkers.c           |  20 +++----
 libmultipath/checkers/cciss.h     | 106 +++++++++++++++++++-------------------
 libmultipath/checkers/tur.c       |   2 +-
 libmultipath/devmapper.h          |   6 +--
 libmultipath/prioritizers/hp_sw.c |   2 +-
 libmultipath/prioritizers/ontap.c |   8 +--
 libmultipath/structs.h            |   8 +--
 multipathd/main.h                 |  12 ++---
 14 files changed, 140 insertions(+), 140 deletions(-)

diff --git a/kpartx/Makefile b/kpartx/Makefile
index 5476545..70f836e 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -14,7 +14,7 @@ endif
 
 LDFLAGS = -ldevmapper
 OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o sun.o \
-       gpt.o mac.o ps3.o crc32.o lopart.o xstrncpy.o devmapper.o
+	gpt.o mac.o ps3.o crc32.o lopart.o xstrncpy.o devmapper.o
 EXEC = kpartx
 
 all: $(EXEC)
diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index 046a08b..0cd2002 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -280,7 +280,7 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 		retval = 1;
 	}
 
- out:
+out:
 	if (data != NULL)
 		free(data);
 	if (fd_dasd != -1 && fd_dasd != fd)
diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index 75a1c2b..3511886 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -592,7 +592,7 @@ find_valid_gpt(int fd, gpt_header ** gpt, gpt_entry ** ptes)
 		return 1;
 	}
 
- fail:
+fail:
 	if (pgpt)  { free(pgpt);   pgpt=NULL; }
 	if (agpt)  { free(agpt);   agpt=NULL; }
 	if (pptes) { free(pptes); pptes=NULL; }
diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 8858a60..1713f3c 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -38,6 +38,6 @@ ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*", \
 ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", GOTO="kpartx_end"
 ENV{DM_NR_VALID_PATHS}=="0", GOTO="kpartx_end"
 ENV{DM_STATE}!="SUSPENDED", ENV{DM_UUID}=="mpath-*", \
-        RUN+="/sbin/kpartx -u -p -part /dev/$name"
+	RUN+="/sbin/kpartx -u -p -part /dev/$name"
 
 LABEL="kpartx_end"
diff --git a/libmpathpersist/mpath_pr_ioctl.h b/libmpathpersist/mpath_pr_ioctl.h
index 7dfda5a..625490f 100644
--- a/libmpathpersist/mpath_pr_ioctl.h
+++ b/libmpathpersist/mpath_pr_ioctl.h
@@ -5,17 +5,17 @@
 
 #if 0
 static const char * pr_type_strs[] = {
-    "obsolete [0]",
-    "Write Exclusive",
-    "obsolete [2]",
-    "Exclusive Access",
-    "obsolete [4]",
-    "Write Exclusive, registrants only",
-    "Exclusive Access, registrants only",
-    "Write Exclusive, all registrants",
-    "Exclusive Access, all registrants",
-    "obsolete [9]", "obsolete [0xa]", "obsolete [0xb]", "obsolete [0xc]",
-    "obsolete [0xd]", "obsolete [0xe]", "obsolete [0xf]",
+	"obsolete [0]",
+	"Write Exclusive",
+	"obsolete [2]",
+	"Exclusive Access",
+	"obsolete [4]",
+	"Write Exclusive, registrants only",
+	"Exclusive Access, registrants only",
+	"Write Exclusive, all registrants",
+	"Exclusive Access, all registrants",
+	"obsolete [9]", "obsolete [0xa]", "obsolete [0xb]", "obsolete [0xc]",
+	"obsolete [0xd]", "obsolete [0xe]", "obsolete [0xf]",
 };
 #endif
 
@@ -24,43 +24,43 @@ typedef unsigned char    BYTE;      /* unsigned numeric, bit patterns */
 
 typedef struct SenseData
 {
-    BYTE        Error_Code;
-    BYTE        Segment_Number; /* not applicable to DAC */
-    BYTE        Sense_Key;
-    BYTE        Information[ 4 ];
-    BYTE        Additional_Len;
-    LWORD       Command_Specific_Info;
-    BYTE        ASC;
-    BYTE        ASCQ;
-    BYTE        Field_Replaceable_Unit;
-    BYTE        Sense_Key_Specific_Info[ 3 ];
-    BYTE        Recovery_Action[ 2 ];
-    BYTE        Total_Errors;
-    BYTE        Total_Retries;
-    BYTE        ASC_Stack_1;
-    BYTE        ASCQ_Stack_1;
-    BYTE        ASC_Stack_2;
-    BYTE        ASCQ_Stack_2;
-    BYTE        Additional_FRU_Info[ 8 ];
-    BYTE        Error_Specific_Info[ 3 ];
-    BYTE        Error_Detection_Point[ 4 ];
-    BYTE        Original_CDB[10];
-    BYTE        Host_ID;
-    BYTE        Host_Descriptor[ 2 ];
-    BYTE        Serial_Number[ 16 ];
-    BYTE        Array_SW_Revision[ 4 ];
-    BYTE        Data_Xfer_Operation;
-    BYTE        LUN_Number;
-    BYTE        LUN_Status;
-    BYTE        Drive_ID;
-    BYTE        Xfer_Start_Drive_ID;
-    BYTE        Drive_SW_Revision[ 4 ];
-    BYTE        Drive_Product_ID[ 16 ];
-    BYTE        PowerUp_Status[ 2 ];
-    BYTE        RAID_Level;
-    BYTE        Drive_Sense_ID[ 2 ];
-    BYTE        Drive_Sense_Data[ 32 ];
-    BYTE        Reserved2[24];
+	BYTE        Error_Code;
+	BYTE        Segment_Number; /* not applicable to DAC */
+	BYTE        Sense_Key;
+	BYTE        Information[ 4 ];
+	BYTE        Additional_Len;
+	LWORD       Command_Specific_Info;
+	BYTE        ASC;
+	BYTE        ASCQ;
+	BYTE        Field_Replaceable_Unit;
+	BYTE        Sense_Key_Specific_Info[ 3 ];
+	BYTE        Recovery_Action[ 2 ];
+	BYTE        Total_Errors;
+	BYTE        Total_Retries;
+	BYTE        ASC_Stack_1;
+	BYTE        ASCQ_Stack_1;
+	BYTE        ASC_Stack_2;
+	BYTE        ASCQ_Stack_2;
+	BYTE        Additional_FRU_Info[ 8 ];
+	BYTE        Error_Specific_Info[ 3 ];
+	BYTE        Error_Detection_Point[ 4 ];
+	BYTE        Original_CDB[10];
+	BYTE        Host_ID;
+	BYTE        Host_Descriptor[ 2 ];
+	BYTE        Serial_Number[ 16 ];
+	BYTE        Array_SW_Revision[ 4 ];
+	BYTE        Data_Xfer_Operation;
+	BYTE        LUN_Number;
+	BYTE        LUN_Status;
+	BYTE        Drive_ID;
+	BYTE        Xfer_Start_Drive_ID;
+	BYTE        Drive_SW_Revision[ 4 ];
+	BYTE        Drive_Product_ID[ 16 ];
+	BYTE        PowerUp_Status[ 2 ];
+	BYTE        RAID_Level;
+	BYTE        Drive_Sense_ID[ 2 ];
+	BYTE        Drive_Sense_Data[ 32 ];
+	BYTE        Reserved2[24];
 } SenseData_t;
 
 #define MPATH_PRIN_CMD 0x5e
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index a14d4b3..e44397b 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -18,12 +18,12 @@ ifdef SYSTEMD
 endif
 
 OBJS = memory.o parser.o vector.o devmapper.o callout.o \
-       hwtable.o blacklist.o util.o dmparser.o config.o \
-       structs.o discovery.o propsel.o dict.o \
-       pgpolicies.o debug.o defaults.o uevent.o \
-       switchgroup.o uxsock.o print.o alias.o log_pthread.o \
-       log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
-       lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o
+	hwtable.o blacklist.o util.o dmparser.o config.o \
+	structs.o discovery.o propsel.o dict.o \
+	pgpolicies.o debug.o defaults.o uevent.o \
+	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
+	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
+	lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o
 
 LIBDM_API_FLUSH = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_no_flush' /usr/include/libdevmapper.h)
 
diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index ad7d96c..42baa86 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -9,16 +9,16 @@
 #include "vector.h"
 
 char *checker_state_names[] = {
-      "wild",
-      "unchecked",
-      "down",
-      "up",
-      "shaky",
-      "ghost",
-      "pending",
-      "timeout",
-      "removed",
-      "delayed",
+	"wild",
+	"unchecked",
+	"down",
+	"up",
+	"shaky",
+	"ghost",
+	"pending",
+	"timeout",
+	"removed",
+	"delayed",
 };
 
 static LIST_HEAD(checkers);
diff --git a/libmultipath/checkers/cciss.h b/libmultipath/checkers/cciss.h
index c9fa84a..cf20946 100644
--- a/libmultipath/checkers/cciss.h
+++ b/libmultipath/checkers/cciss.h
@@ -43,76 +43,76 @@
 
 //Command List Structure
 typedef union _SCSI3Addr_struct {
-   struct {
-    BYTE Dev;
-    BYTE Bus:6;
-    BYTE Mode:2;        // b00
-  } PeripDev;
-   struct {
-    BYTE DevLSB;
-    BYTE DevMSB:6;
-    BYTE Mode:2;        // b01
-  } LogDev;
-   struct {
-    BYTE Dev:5;
-    BYTE Bus:3;
-    BYTE Targ:6;
-    BYTE Mode:2;        // b10
-  } LogUnit;
+	struct {
+		BYTE Dev;
+		BYTE Bus:6;
+		BYTE Mode:2;        // b00
+	} PeripDev;
+	struct {
+		BYTE DevLSB;
+		BYTE DevMSB:6;
+		BYTE Mode:2;        // b01
+	} LogDev;
+	struct {
+		BYTE Dev:5;
+		BYTE Bus:3;
+		BYTE Targ:6;
+		BYTE Mode:2;        // b10
+	} LogUnit;
 } SCSI3Addr_struct;
 
 typedef struct _PhysDevAddr_struct {
-  DWORD             TargetId:24;
-  DWORD             Bus:6;
-  DWORD             Mode:2;
-  SCSI3Addr_struct  Target[2]; //2 level target device addr
+	DWORD             TargetId:24;
+	DWORD             Bus:6;
+	DWORD             Mode:2;
+	SCSI3Addr_struct  Target[2]; //2 level target device addr
 } PhysDevAddr_struct;
 
 typedef struct _LogDevAddr_struct {
-  DWORD            VolId:30;
-  DWORD            Mode:2;
-  BYTE             reserved[4];
+	DWORD            VolId:30;
+	DWORD            Mode:2;
+	BYTE             reserved[4];
 } LogDevAddr_struct;
 
 typedef union _LUNAddr_struct {
-  BYTE               LunAddrBytes[8];
-  SCSI3Addr_struct   SCSI3Lun[4];
-  PhysDevAddr_struct PhysDev;
-  LogDevAddr_struct  LogDev;
+	BYTE               LunAddrBytes[8];
+	SCSI3Addr_struct   SCSI3Lun[4];
+	PhysDevAddr_struct PhysDev;
+	LogDevAddr_struct  LogDev;
 } LUNAddr_struct;
 
 typedef struct _RequestBlock_struct {
-  BYTE   CDBLen;
-  struct {
-    BYTE Type:3;
-    BYTE Attribute:3;
-    BYTE Direction:2;
-  } Type;
-  HWORD  Timeout;
-  BYTE   CDB[16];
+	BYTE   CDBLen;
+	struct {
+		BYTE Type:3;
+		BYTE Attribute:3;
+		BYTE Direction:2;
+	} Type;
+	HWORD  Timeout;
+	BYTE   CDB[16];
 } RequestBlock_struct;
 
 typedef union _MoreErrInfo_struct{
-  struct {
-    BYTE  Reserved[3];
-    BYTE  Type;
-    DWORD ErrorInfo;
-  }Common_Info;
-  struct{
-    BYTE  Reserved[2];
-    BYTE  offense_size;//size of offending entry
-    BYTE  offense_num; //byte # of offense 0-base
-    DWORD offense_value;
-  }Invalid_Cmd;
-}MoreErrInfo_struct;
+	struct {
+		BYTE  Reserved[3];
+		BYTE  Type;
+		DWORD ErrorInfo;
+	} Common_Info;
+	struct{
+		BYTE  Reserved[2];
+		BYTE  offense_size;//size of offending entry
+		BYTE  offense_num; //byte # of offense 0-base
+		DWORD offense_value;
+	} Invalid_Cmd;
+} MoreErrInfo_struct;
 
 typedef struct _ErrorInfo_struct {
-  BYTE               ScsiStatus;
-  BYTE               SenseLen;
-  HWORD              CommandStatus;
-  DWORD              ResidualCnt;
-  MoreErrInfo_struct MoreErrInfo;
-  BYTE               SenseInfo[SENSEINFOBYTES];
+	BYTE               ScsiStatus;
+	BYTE               SenseLen;
+	HWORD              CommandStatus;
+	DWORD              ResidualCnt;
+	MoreErrInfo_struct MoreErrInfo;
+	BYTE               SenseInfo[SENSEINFOBYTES];
 } ErrorInfo_struct;
 
 #pragma pack()
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 2edc8ad..c4ef8a8 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -107,7 +107,7 @@ tur_check(int fd, unsigned int timeout, char *msg)
 	unsigned char sense_buffer[32];
 	int retry_tur = 5;
 
- retry:
+retry:
 	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
 	memset(&sense_buffer, 0, 32);
 	io_hdr.interface_id = 'S';
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 4bc3b11..442d42e 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -52,9 +52,9 @@ int dm_reassign_table(const char *name, char *old, char *new);
 int dm_setgeometry(struct multipath *mpp);
 
 #define VERSION_GE(v, minv) ( \
- (v[0] > minv[0]) || \
- ((v[0] == minv[0]) && (v[1] > minv[1])) || \
- ((v[0] == minv[0]) && (v[1] == minv[1]) && (v[2] >= minv[2])) \
+	(v[0] > minv[0]) || \
+	((v[0] == minv[0]) && (v[1] > minv[1])) || \
+	((v[0] == minv[0]) && (v[1] == minv[1]) && (v[2] >= minv[2])) \
 )
 
 #endif /* _DEVMAPPER_H */
diff --git a/libmultipath/prioritizers/hp_sw.c b/libmultipath/prioritizers/hp_sw.c
index 253fd51..6b0ed39 100644
--- a/libmultipath/prioritizers/hp_sw.c
+++ b/libmultipath/prioritizers/hp_sw.c
@@ -48,7 +48,7 @@ int hp_sw_prio(const char *dev, int fd, unsigned int timeout)
 	io_hdr.sbp = sb;
 	io_hdr.timeout = get_prio_timeout(timeout, 60000);
 	io_hdr.pack_id = 0;
- retry:
+retry:
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		pp_hp_sw_log(0, "sending tur command failed");
 		goto out;
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 747dfb5..4084c65 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -113,7 +113,7 @@ static int send_gva(const char *dev, int fd, unsigned char pg,
 		goto out;
 	}
 	ret = 0;
- out:
+out:
 	return(ret);
 }
 
@@ -171,7 +171,7 @@ static int get_proxy(const char *dev, int fd, unsigned int timeout)
 	}
 	ret = (results[19] & 0x02) >> 1;
 
- out:
+out:
 	return(ret);
 }
 
@@ -221,13 +221,13 @@ static int ontap_prio(const char *dev, int fd, unsigned int timeout)
 		return 0;
 	}
 
- try_fcp_proxy:
+try_fcp_proxy:
 	rc = get_proxy(dev, fd, timeout);
 	if (rc >= 0) {
 		is_proxy = rc;
 	}
 
- prio_select:
+prio_select:
 	if (is_iscsi_hardware) {
 		return 3;
 	} else if (is_iscsi_software) {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 9f216df..a87cda6 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -167,10 +167,10 @@ struct sg_id {
 #  define HDIO_GETGEO	0x0301	/* get device geometry */
 
 struct hd_geometry {
-      unsigned char heads;
-      unsigned char sectors;
-      unsigned short cylinders;
-      unsigned long start;
+	unsigned char heads;
+	unsigned char sectors;
+	unsigned short cylinders;
+	unsigned long start;
 };
 #endif
 
diff --git a/multipathd/main.h b/multipathd/main.h
index 10b3a6d..f72580d 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -4,12 +4,12 @@
 #define MAPGCINT 5
 
 enum daemon_status {
-    DAEMON_INIT,
-    DAEMON_START,
-    DAEMON_CONFIGURE,
-    DAEMON_IDLE,
-    DAEMON_RUNNING,
-    DAEMON_SHUTDOWN,
+	DAEMON_INIT,
+	DAEMON_START,
+	DAEMON_CONFIGURE,
+	DAEMON_IDLE,
+	DAEMON_RUNNING,
+	DAEMON_SHUTDOWN,
 };
 
 struct prout_param_descriptor;
-- 
2.7.4
