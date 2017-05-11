From: Philip Yang <philip.yang@huawei.com>
Subject: Re: [PATCH] multipath-tools:Prioritizer based on a
 time-delay algorithm
Date: Thu, 11 May 2017 12:57:49 +0800
Message-ID: <0a8fcc64-0d5e-6f9b-8e65-f3b3365229b8@huawei.com>
References: <1494215904-7564-1-git-send-email-philip.yang@huawei.com>
	<d5205a96-32cb-3832-a93a-0057c445ef55@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d5205a96-32cb-3832-a93a-0057c445ef55@gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, hege09@huawei.com, zouming.zouming@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Hi Xose and Christophe,

On 2017/5/11 6:36, Xose Vazquez Perez wrote:
> On 05/08/2017 05:58 AM, Yang Feng wrote:
>
>> Prioritizer for device mapper multipath, where the corresponding priority
>> values of specific paths are provided by a time-delay algorithm. And the
>> time-delay algorithm is dependent on the following arguments(delay_interval,
>> cons_num).
> This new feature should be documented in multipath/multipath.conf.5
>
multipath/multipath.conf.5 has be documented in the following patch.

>> diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
>> index 4970fc0..7e433ca 100644
>> --- a/libmultipath/checkers/Makefile
>> +++ b/libmultipath/checkers/Makefile
>> @@ -14,19 +14,16 @@ LIBS= \
>>  	libcheckemc_clariion.so \
>>  	libcheckhp_sw.so \
>>  	libcheckrdac.so
>> -ifneq ($(ENABLE_RADOS),0)
>> -LIBS += libcheckrbd.so
>> -endif
>
> Is it right?
>
>
Thanks, fixed as the flollowing patch.


---
Prioritizer for device mapper multipath, where the corresponding priority values of specific paths are provided by a time-delay algorithm. And the time-delay algorithm is dependent on the following arguments(delay_interval, cons_num).
The principle of the algorithm is illustrated as follows:
1. By sending a certain number "cons_num" of read IOs to the current path
   continuously, the IOs' average delay can be calculated.
2. According to the average delay of each path and the weight value
   "delay_interval", the priority "rc" of each path can be provided.

     delay_interval  delay_interval  delay_interval       delay_interval
    |---------------|---------------|---------------|	 |---------------|
    |priority rank 1|priority rank 2|priority rank 3|... |priority rank x|
    |---------------|---------------|---------------|    |---------------|
                       Priority Rank Partitioning
---
 libmultipath/Makefile                   |   2 +-
 libmultipath/checkers/Makefile          |   4 +-
 libmultipath/checkers/emc_clariion.c    |   2 +-
 libmultipath/checkers/libsg.c           |  94 ------------
 libmultipath/checkers/libsg.h           |   9 --
 libmultipath/checkers/readsector0.c     |   2 +-
 libmultipath/libsg.c                    |  94 ++++++++++++
 libmultipath/libsg.h                    |   9 ++
 libmultipath/prioritizers/Makefile      |   6 +-
 libmultipath/prioritizers/delayedpath.c | 246 ++++++++++++++++++++++++++++++++
 libmultipath/prioritizers/delayedpath.h |  14 ++
 multipath/multipath.conf.5              |  19 +++++++++++++++++++
 12 files changed, 392 insertions(+), 109 deletions(-)  delete mode 100644 libmultipath/checkers/libsg.c  delete mode 100644 libmultipath/checkers/libsg.h  create mode 100644 libmultipath/libsg.c  create mode 100644 libmultipath/libsg.h  create mode 100644 libmultipath/prioritizers/delayedpath.c
 create mode 100644 libmultipath/prioritizers/delayedpath.h

diff --git a/libmultipath/Makefile b/libmultipath/Makefile index 1f5ec25..a4d725a 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -41,7 +41,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	structs.o discovery.o propsel.o dict.o \
 	pgpolicies.o debug.o defaults.o uevent.o time-util.o \
 	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
-	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
+	log.o configure.o structs_vec.o sysfs.o libsg.o prio.o checkers.o \
 	lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o

 all: $(LIBS)
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile index 4970fc0..7e433ca 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -14,19 +14,16 @@ LIBS= \
 	libcheckemc_clariion.so \
 	libcheckhp_sw.so \
 	libcheckrdac.so
 ifneq ($(ENABLE_RADOS),0)
 LIBS += libcheckrbd.so
 endif

 all: $(LIBS)

 libcheckrbd.so: rbd.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lrados -ludev

-libcheckdirectio.so: libsg.o directio.o
+libcheckdirectio.so: ../libsg.o directio.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -laio

-libcheck%.so: libsg.o %.o
+libcheck%.so: ../libsg.o %.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^

 install:
diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index 9c1ffed..e4ba757 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -12,7 +12,7 @@
 #include <errno.h>

 #include "../libmultipath/sg_include.h"
-#include "libsg.h"
+#include "../libmultipath/libsg.h"
 #include "checkers.h"
 #include "debug.h"
 #include "memory.h"
diff --git a/libmultipath/checkers/libsg.c b/libmultipath/checkers/libsg.c deleted file mode 100644 index 958ea92..0000000
--- a/libmultipath/checkers/libsg.c
+++ /dev/null
@@ -1,94 +0,0 @@
-/*
- * Copyright (c) 2004, 2005 Christophe Varoqui
- */
-#include <string.h>
-#include <sys/ioctl.h>
-#include <errno.h>
-#include <sys/stat.h>
-
-#include "checkers.h"
-#include "libsg.h"
-#include "../libmultipath/sg_include.h"
-
-int
-sg_read (int sg_fd, unsigned char * buff, int buff_len,
-	 unsigned char * sense, int sense_len, unsigned int timeout)
-{
-	/* defaults */
-	int blocks;
-	long long start_block = 0;
-	int bs = 512;
-	int cdbsz = 10;
-
-	unsigned char rdCmd[cdbsz];
-	unsigned char *sbb = sense;
-	struct sg_io_hdr io_hdr;
-	int res;
-	int rd_opcode[] = {0x8, 0x28, 0xa8, 0x88};
-	int sz_ind;
-	struct stat filestatus;
-	int retry_count = 3;
-
-	if (fstat(sg_fd, &filestatus) != 0)
-		return PATH_DOWN;
-	bs = (filestatus.st_blksize > 4096)? 4096: filestatus.st_blksize;
-	blocks = buff_len / bs;
-	memset(rdCmd, 0, cdbsz);
-	sz_ind = 1;
-	rdCmd[0] = rd_opcode[sz_ind];
-	rdCmd[2] = (unsigned char)((start_block >> 24) & 0xff);
-	rdCmd[3] = (unsigned char)((start_block >> 16) & 0xff);
-	rdCmd[4] = (unsigned char)((start_block >> 8) & 0xff);
-	rdCmd[5] = (unsigned char)(start_block & 0xff);
-	rdCmd[7] = (unsigned char)((blocks >> 8) & 0xff);
-	rdCmd[8] = (unsigned char)(blocks & 0xff);
-
-	memset(&io_hdr, 0, sizeof(struct sg_io_hdr));
-	io_hdr.interface_id = 'S';
-	io_hdr.cmd_len = cdbsz;
-	io_hdr.cmdp = rdCmd;
-	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
-	io_hdr.dxfer_len = bs * blocks;
-	io_hdr.dxferp = buff;
-	io_hdr.mx_sb_len = sense_len;
-	io_hdr.sbp = sense;
-	io_hdr.timeout = timeout * 1000;
-	io_hdr.pack_id = (int)start_block;
-
-retry:
-	memset(sense, 0, sense_len);
-	while (((res = ioctl(sg_fd, SG_IO, &io_hdr)) < 0) && (EINTR == errno));
-
-	if (res < 0) {
-		if (ENOMEM == errno) {
-			return PATH_UP;
-		}
-		return PATH_DOWN;
-	}
-
-	if ((0 == io_hdr.status) &&
-	    (0 == io_hdr.host_status) &&
-	    (0 == io_hdr.driver_status)) {
-		return PATH_UP;
-	} else {
-		int key = 0;
-
-		if (io_hdr.sb_len_wr > 3) {
-			if (sbb[0] == 0x72 || sbb[0] == 0x73)
-				key = sbb[1] & 0x0f;
-			else if (io_hdr.sb_len_wr > 13 &&
-				 ((sbb[0] & 0x7f) == 0x70 ||
-				  (sbb[0] & 0x7f) == 0x71))
-				key = sbb[2] & 0x0f;
-		}
-
-		/*
-		 * Retry if UNIT_ATTENTION check condition.
-		 */
-		if (key == 0x6) {
-			if (--retry_count)
-				goto retry;
-		}
-		return PATH_DOWN;
-	}
-}
diff --git a/libmultipath/checkers/libsg.h b/libmultipath/checkers/libsg.h deleted file mode 100644 index 3994f45..0000000
--- a/libmultipath/checkers/libsg.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _LIBSG_H
-#define _LIBSG_H
-
-#define SENSE_BUFF_LEN 32
-
-int sg_read (int sg_fd, unsigned char * buff, int buff_len,
-	     unsigned char * sense, int sense_len, unsigned int timeout);
-
-#endif /* _LIBSG_H */
diff --git a/libmultipath/checkers/readsector0.c b/libmultipath/checkers/readsector0.c
index 8fccb46..d70c5c5 100644
--- a/libmultipath/checkers/readsector0.c
+++ b/libmultipath/checkers/readsector0.c
@@ -4,7 +4,7 @@
 #include <stdio.h>

 #include "checkers.h"
-#include "libsg.h"
+#include "../libmultipath/libsg.h"

 #define MSG_READSECTOR0_UP	"readsector0 checker reports path is up"
 #define MSG_READSECTOR0_DOWN	"readsector0 checker reports path is down"
diff --git a/libmultipath/libsg.c b/libmultipath/libsg.c new file mode 100644 index 0000000..99c91a4
--- /dev/null
+++ b/libmultipath/libsg.c
@@ -0,0 +1,94 @@
+/*
+ * Copyright (c) 2004, 2005 Christophe Varoqui  */ #include <string.h>
+#include <sys/ioctl.h> #include <errno.h> #include <sys/stat.h>
+
+#include "checkers.h"
+#include "libsg.h"
+#include "sg_include.h"
+
+int
+sg_read (int sg_fd, unsigned char * buff, int buff_len,
+	 unsigned char * sense, int sense_len, unsigned int timeout) {
+	/* defaults */
+	int blocks;
+	long long start_block = 0;
+	int bs = 512;
+	int cdbsz = 10;
+
+	unsigned char rdCmd[cdbsz];
+	unsigned char *sbb = sense;
+	struct sg_io_hdr io_hdr;
+	int res;
+	int rd_opcode[] = {0x8, 0x28, 0xa8, 0x88};
+	int sz_ind;
+	struct stat filestatus;
+	int retry_count = 3;
+
+	if (fstat(sg_fd, &filestatus) != 0)
+		return PATH_DOWN;
+	bs = (filestatus.st_blksize > 4096)? 4096: filestatus.st_blksize;
+	blocks = buff_len / bs;
+	memset(rdCmd, 0, cdbsz);
+	sz_ind = 1;
+	rdCmd[0] = rd_opcode[sz_ind];
+	rdCmd[2] = (unsigned char)((start_block >> 24) & 0xff);
+	rdCmd[3] = (unsigned char)((start_block >> 16) & 0xff);
+	rdCmd[4] = (unsigned char)((start_block >> 8) & 0xff);
+	rdCmd[5] = (unsigned char)(start_block & 0xff);
+	rdCmd[7] = (unsigned char)((blocks >> 8) & 0xff);
+	rdCmd[8] = (unsigned char)(blocks & 0xff);
+
+	memset(&io_hdr, 0, sizeof(struct sg_io_hdr));
+	io_hdr.interface_id = 'S';
+	io_hdr.cmd_len = cdbsz;
+	io_hdr.cmdp = rdCmd;
+	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	io_hdr.dxfer_len = bs * blocks;
+	io_hdr.dxferp = buff;
+	io_hdr.mx_sb_len = sense_len;
+	io_hdr.sbp = sense;
+	io_hdr.timeout = timeout * 1000;
+	io_hdr.pack_id = (int)start_block;
+
+retry:
+	memset(sense, 0, sense_len);
+	while (((res = ioctl(sg_fd, SG_IO, &io_hdr)) < 0) && (EINTR ==
+errno));
+
+	if (res < 0) {
+		if (ENOMEM == errno) {
+			return PATH_UP;
+		}
+		return PATH_DOWN;
+	}
+
+	if ((0 == io_hdr.status) &&
+	    (0 == io_hdr.host_status) &&
+	    (0 == io_hdr.driver_status)) {
+		return PATH_UP;
+	} else {
+		int key = 0;
+
+		if (io_hdr.sb_len_wr > 3) {
+			if (sbb[0] == 0x72 || sbb[0] == 0x73)
+				key = sbb[1] & 0x0f;
+			else if (io_hdr.sb_len_wr > 13 &&
+				 ((sbb[0] & 0x7f) == 0x70 ||
+				  (sbb[0] & 0x7f) == 0x71))
+				key = sbb[2] & 0x0f;
+		}
+
+		/*
+		 * Retry if UNIT_ATTENTION check condition.
+		 */
+		if (key == 0x6) {
+			if (--retry_count)
+				goto retry;
+		}
+		return PATH_DOWN;
+	}
+}
diff --git a/libmultipath/libsg.h b/libmultipath/libsg.h new file mode 100644 index 0000000..3994f45
--- /dev/null
+++ b/libmultipath/libsg.h
@@ -0,0 +1,9 @@
+#ifndef _LIBSG_H
+#define _LIBSG_H
+
+#define SENSE_BUFF_LEN 32
+
+int sg_read (int sg_fd, unsigned char * buff, int buff_len,
+	     unsigned char * sense, int sense_len, unsigned int timeout);
+
+#endif /* _LIBSG_H */
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 36b42e4..7e3da51 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -18,13 +18,17 @@ LIBS = \
 	libpriorandom.so \
 	libpriordac.so \
 	libprioweightedpath.so \
-	libpriosysfs.so
+	libpriodelayedpath.so \
+	libpriosysfs.so

 all: $(LIBS)

 libprioalua.so: alua.o alua_rtpg.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^

+libpriodelayedpath.so: delayedpath.o  ../libsg.o
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
+
 libprio%.so: %.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^

diff --git a/libmultipath/prioritizers/delayedpath.c b/libmultipath/prioritizers/delayedpath.c
new file mode 100644
index 0000000..4c1cfea
--- /dev/null
+++ b/libmultipath/prioritizers/delayedpath.c
@@ -0,0 +1,246 @@
+/*
+ * (C) Copyright HUAWEI Technology Corp. 2017, 2021   All Rights Reserved.
+ *
+ * main.c
+ *
+ * Prioritizer for device mapper multipath, where the corresponding
+priority
+ * values of specific paths are provided by a time-delay algorithm. And
+the
+ * time-delay algorithm is dependent on arguments.
+ *
+ * The principle of the algorithm as follows:
+ * 1. By sending a certain number "cons_num" of read IOs to the current path
+ *    continuously, the IOs' average delay can be calculated.
+ * 2. According to the average delay of each path and the weight value
+ *    "delay_interval", the priority "rc" of each path can be provided.
+ *
+ * Author(s): Yang Feng <philip.yang@huawei.com>
+ *            Zou Ming <zouming.zouming@huawei.com>
+ *
+ * This file is released under the GPL.
+ */
+#include <stdio.h>
+#include <ctype.h>
+#include <sys/time.h>
+
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
+#include "../libmultipath/libsg.h"
+
+#include "delayedpath.h"
+
+#define THRES_USEC_VALUE        300000000LL    /*USEC, 300SEC*/
+#define DEFAULT_DELAY_INTERVAL  10             /*MSEC*/
+#define DEFAULT_CONS_NUM        20
+
+#define MAX_CHAR_SIZE           30
+
+#define CHAR_SEC                "SEC"
+#define CHAR_MSEC               "MSEC"
+#define CHAR_USEC               "USEC"
+
+enum interval_type {
+    INTERVAL_SEC,
+    INTERVAL_MSEC,
+    INTERVAL_USEC,
+    INTERVAL_INVALID
+};
+
+static int conversion_ratio[] = {
+	[INTERVAL_SEC]		= USEC_PER_SEC,
+	[INTERVAL_MSEC]	    = USEC_PER_MSEC,
+	[INTERVAL_USEC]		= USEC_PER_USEC,
+	[INTERVAL_INVALID]	= 0,
+};
+
+
+static int do_readsector0(int fd, unsigned int timeout) {
+	unsigned char buf[4096];
+	unsigned char sbuf[SENSE_BUFF_LEN];
+	int ret;
+
+	ret = sg_read(fd, &buf[0], 4096, &sbuf[0],
+		      SENSE_BUFF_LEN, timeout);
+
+	return ret;
+}
+
+static int get_interval_type(char *source, char *type) {
+    /*is USEC*/
+    if ((strstr(source, CHAR_USEC) != NULL)
+        && (strstr(source, CHAR_USEC)[4] == '|'))
+    {
+        memcpy(type, CHAR_USEC, strlen(CHAR_USEC)+1);
+        return INTERVAL_USEC;
+    }
+
+    /*is MSEC*/
+    if ((strstr(source, CHAR_MSEC) != NULL)
+        && (strstr(source, CHAR_MSEC)[4] == '|'))
+    {
+        memcpy(type, CHAR_MSEC, strlen(CHAR_MSEC)+1);
+        return INTERVAL_MSEC;
+    }
+
+    /*is SEC*/
+	if ((strstr(source, CHAR_SEC) != NULL)
+        && (strstr(source, CHAR_SEC)[4] == '|'))
+    {
+        memcpy(type, CHAR_SEC, strlen(CHAR_SEC)+1);
+        return INTERVAL_SEC;
+    }
+
+    return INTERVAL_INVALID;
+}
+
+static int get_string_from_vertica(char *args,
+                                        char *beforestring,
+                                        char *afterstring,
+                                        int *type) {
+    char source[MAX_CHAR_SIZE];
+    char char_type[MAX_CHAR_SIZE];
+    char vertica[] = "|";
+    char *token  = NULL;
+    char *tmp = NULL;
+    char *saveptr = NULL;
+    unsigned int size = strlen(args);
+
+    if ((args == NULL) || (beforestring == NULL)
+        || (afterstring == NULL) || (type == NULL))
+        return 0;
+
+    /* int type */
+    if ((size < 1) || (size > MAX_CHAR_SIZE-1))
+        return 0;
+
+    memcpy(source, args, size+1);
+    if (strstr(source, vertica) == NULL)
+        return 0;
+
+    *type = get_interval_type(source, char_type);
+    if (*type == INTERVAL_INVALID)
+        return 0;
+
+    token = strtok_r(source, vertica, &saveptr);
+    token = strtok(token, char_type);
+    if ((token == NULL) || (saveptr == NULL))
+        return 0;
+
+    tmp = token;
+    while (*tmp != '\0')
+        if (!isdigit(*tmp++))
+            return 0;
+
+    tmp = saveptr;
+    while (*tmp != '\0')
+        if (!isdigit(*tmp++))
+            return 0;
+
+    strncpy(beforestring, token, strlen(token) + 1);
+    strncpy(afterstring, saveptr, strlen(saveptr) + 1);
+    return 1;
+}
+
+int checkargvalid(int delay_interval, int cons_num, int type) {
+    if (type == INTERVAL_SEC)
+    {
+        if ((delay_interval < 1) || (delay_interval > 60))
+            return 0;
+    }
+    else if (type != INTERVAL_INVALID)
+    {
+        if ((delay_interval < 1) || (delay_interval >= 1000))
+            return 0;
+    }
+
+    if ((cons_num < 3) || (cons_num > 1000))
+        return 0;
+
+    return 1;
+}
+
+int get_delay_pref_arg(char *args, int *delay_interval, int *cons_num,
+int *type) {
+    char delayintervalstr[MAX_CHAR_SIZE];
+    char consnumstr[MAX_CHAR_SIZE];
+
+    if (get_string_from_vertica(args, delayintervalstr, consnumstr, type) == 0)
+        return 0;
+
+    *delay_interval = atoi(delayintervalstr);
+    *cons_num = atoi(consnumstr);
+
+    if (checkargvalid(*delay_interval, *cons_num, *type) == 0)
+        return 0;
+
+    return 1;
+}
+
+long long get_conversion_ratio(int type) {
+    return conversion_ratio[type];
+}
+
+int getprio (struct path *pp, char *args, unsigned int timeout) {
+    int rc, delay_interval, cons_num, type, temp;
+    long long delay, avgdelay, ratio;
+    long long min = THRES_USEC_VALUE;
+    long long max = 0;
+    long long toldelay = 0;
+    long long before, after;
+    struct timeval tv;
+
+    if (get_delay_pref_arg(args, &delay_interval, &cons_num, &type) == 0)
+    {
+        condlog(3, "%s: get delay arg fail", pp->dev);
+        delay_interval = DEFAULT_DELAY_INTERVAL;
+        cons_num = DEFAULT_CONS_NUM;
+        type = INTERVAL_MSEC;
+    }
+
+    temp = cons_num;
+    while (temp-- > 0)
+    {
+        (void)gettimeofday(&tv, NULL);
+        before = timeval_to_us(&tv);		
+
+        if (do_readsector0(pp->fd, timeout) == 2)
+        {
+            condlog(0, "%s: path down", pp->dev);
+            return 1;
+        }
+
+        (void)gettimeofday(&tv, NULL);
+        after = timeval_to_us(&tv);
+
+        delay = after - before;
+        if (delay < 0)
+        {
+            condlog(0, "%s: delay calc error", pp->dev);
+            return 1;
+        }
+    	
+        min = (min <= delay) ? min : delay;
+        max = (max >= delay) ? max : delay;
+
+        toldelay += delay;
+    }
+
+    toldelay -= min + max;
+    avgdelay = toldelay/(long long)(cons_num - 2);
+    if (avgdelay > THRES_USEC_VALUE)
+    {
+        condlog(0, "%s: avgdelay is more than thresold", pp->dev);
+        return 1;
+    }
+
+	ratio = get_conversion_ratio(type);
+	rc = (int)(THRES_USEC_VALUE - (avgdelay/(((long long)delay_interval) *
+ratio)));
+
+    return rc;
+}
diff --git a/libmultipath/prioritizers/delayedpath.h b/libmultipath/prioritizers/delayedpath.h
new file mode 100644
index 0000000..ca89702
--- /dev/null
+++ b/libmultipath/prioritizers/delayedpath.h
@@ -0,0 +1,14 @@
+#ifndef _DELAYEDPATH_H
+#define _DELAYEDPATH_H
+
+#define PRIO_DELAYED_PATH "delayedpath"
+#define USEC_PER_SEC      1000000LL
+#define USEC_PER_MSEC     1000LL
+#define USEC_PER_USEC     1LL
+
+static inline long long timeval_to_us(const struct timeval *tv) {
+	return ((long long) tv->tv_sec * USEC_PER_SEC) + tv->tv_usec; }
+
+#endif
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 5939688..b787634 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -293,6 +293,10 @@ Generate a random priority between 1 and 10.
 Generate the path priority based on the regular expression and the
 priority provided as argument. Requires prio_args keyword.
 .TP
+.I delayedpath
+Generate the path priority based on a time-delay algorithm.
+Requires prio_args keyword.
+.TP
 .I datacore
 .\" XXX
 ???. Requires prio_args keyword.
@@ -333,6 +337,21 @@ these values can be looked up through sysfs or by running \fImultipathd show pat
 "%N:%R:%n:%r"\fR. For example: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
 .RE
 .TP 12
+.I delayed
+Needs a value of the form
+\fI"<delay_interval|cons_num>"\fR
+.RS
+.TP 8
+.I delay_interval
+The interval values of average IO-time-delay between two different neighbour ranks of path priority, used to partition different priority ranks.
+Form: XXSEC, or XXXUSEC, or XXXMSEC. Unit: Second, or Microsecond, or Millisecond. Valid Values: Integer, SEC [1, 60], USEC [1, 1000), MSEC [1, 1000),
+For example: 10SEC, or 100USEC, or 100MSEC. The default is: 10MSEC.
+.TP
+.I cons_num
+The number of read IOs sent to the current path continuously, used to calculate the average IO-time-delay. Valid Values: Integer, [3, 1000].
+For example: 30. The default is: 20.
+.RE
+.TP 12
 .I alua
 If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR bit
 set will always be in their own path group.
-- 
