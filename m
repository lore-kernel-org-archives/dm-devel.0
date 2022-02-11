Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3382BC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 22:53:39 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-JTSLK6lpPbylcE32XNlNxQ-1; Fri, 11 Feb 2022 17:53:35 -0500
X-MC-Unique: JTSLK6lpPbylcE32XNlNxQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AD001853020;
	Fri, 11 Feb 2022 22:53:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D9065E26C;
	Fri, 11 Feb 2022 22:53:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A089E1809CB8;
	Fri, 11 Feb 2022 22:53:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BMrOrZ030825 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 17:53:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DBF03C07F42; Fri, 11 Feb 2022 22:53:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D83E0C01784
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 22:53:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF4BC1066558
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 22:53:21 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-543-jpiue96iMiSZx_2D2oP94Q-1; Fri, 11 Feb 2022 17:53:12 -0500
X-MC-Unique: jpiue96iMiSZx_2D2oP94Q-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21BMckij015541
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 22:53:11 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e5g98ab3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 22:53:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BMo3fw181570
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 22:53:10 GMT
Received: from rsrivast-us.us.oracle.com (rsrivast-us.us.oracle.com
	[10.211.44.96]) by userp3020.oracle.com with ESMTP id 3e1jpyjg44-1
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 22:53:09 +0000
From: Ritika Srivastava <ritika.srivastava@oracle.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 14:34:25 -0800
Message-Id: <1644618865-9567-1-git-send-email-ritika.srivastava@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255
	signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0 bulkscore=0
	malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202110115
X-Proofpoint-GUID: 7hhD2XoQgUgQVyHtdEVd9MmrcZ4fGeJD
X-Proofpoint-ORIG-GUID: 7hhD2XoQgUgQVyHtdEVd9MmrcZ4fGeJD
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Subject: [dm-devel]  [PATCH] kpartx: Add -P option for partition scanning
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add -P, partition scanning option to kpartx which would set
LO_FLAGS_PARTSCAN flag during loop device creation.
This option is same as losetup -P option.

Signed-off-by: Ritika Srivastava <ritika.srivastava@oracle.com>
---
 kpartx/kpartx.c | 17 +++++++++++++----
 kpartx/lopart.c |  5 ++++-
 kpartx/lopart.h |  2 +-
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 3c49999..a26d0a2 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -87,7 +87,7 @@ initpts(void)
 	addpts("ps3", read_ps3_pt);
 }
 
-static char short_opts[] = "rladfgvp:t:snu";
+static char short_opts[] = "rladfPgvp:t:snu";
 
 /* Used in gpt.c */
 int force_gpt=0;
@@ -98,7 +98,7 @@ static int
 usage(void) {
 	printf(VERSION_STRING);
 	printf("Usage:\n");
-	printf("  kpartx [-a|-d|-u|-l] [-r] [-p] [-f] [-g] [-s|-n] [-v] wholedisk\n");
+	printf("  kpartx [-a|-d|-u|-l] [-r] [-p] [-f] [-g] [-s|-n] [-v] [-P] wholedisk\n");
 	printf("\t-a add partition devmappings\n");
 	printf("\t-r devmappings will be readonly\n");
 	printf("\t-d del partition devmappings\n");
@@ -110,6 +110,7 @@ usage(void) {
 	printf("\t-v verbose\n");
 	printf("\t-n nosync mode. Return before the partitions are created\n");
 	printf("\t-s sync mode (Default). Don't return until the partitions are created\n");
+	printf("\t-P create partitioned loop device\n");
 	return 1;
 }
 
@@ -228,7 +229,7 @@ xmalloc (size_t size) {
 
 int
 main(int argc, char **argv){
-	int i, j, m, n, op, off, arg, c, d, ro=0;
+	int i, j, m, n, op, off, arg, c, d, ro=0, partscan = 0;
 	int fd = -1;
 	struct slice all;
 	struct pt *ptp;
@@ -311,6 +312,9 @@ main(int argc, char **argv){
 		case 'u':
 			what = UPDATE;
 			break;
+		case 'P':
+			partscan = 1;
+			break;
 		default:
 			usage();
 			exit(1);
@@ -328,6 +332,11 @@ main(int argc, char **argv){
 		exit(1);
 	}
 
+	if (what != ADD && partscan == 1)       {
+		printf("-P option is allowed only during loop device setup\n");
+		exit(1);
+	}
+
 	if (hotplug) {
 		/* already got [disk]device */
 	} else if (optind == argc-2) {
@@ -359,7 +368,7 @@ main(int argc, char **argv){
 			exit (0);
 
 		if (!loopdev) {
-			if (set_loop(&loopdev, rpath, 0, &ro)) {
+			if (set_loop(&loopdev, rpath, 0, &ro, partscan)) {
 				fprintf(stderr, "can't set up loop\n");
 				exit (1);
 			}
diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 512a59f..9a1ce48 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -233,7 +233,8 @@ no_loop_fd:
 	return NULL;
 }
 
-int set_loop(char **device, const char *file, int offset, int *loopro)
+int set_loop(char **device, const char *file, int offset, int *loopro,
+	     int partscan)
 {
 	struct loop_info loopinfo;
 	int fd = -1, ret = 1, ffd, mode;
@@ -264,6 +265,8 @@ int set_loop(char **device, const char *file, int offset, int *loopro)
 	loopinfo.lo_offset = offset;
 	loopinfo.lo_encrypt_type = LO_CRYPT_NONE;
 	loopinfo.lo_encrypt_key_size = 0;
+	if (partscan == 1)
+		loopinfo.lo_flags |= LO_FLAGS_PARTSCAN;
 
 	if (ioctl(fd, LOOP_SET_FD, (void*)(uintptr_t)(ffd)) < 0) {
 		perror ("ioctl: LOOP_SET_FD");
diff --git a/kpartx/lopart.h b/kpartx/lopart.h
index c73ab23..81534e2 100644
--- a/kpartx/lopart.h
+++ b/kpartx/lopart.h
@@ -1,4 +1,4 @@
 extern int verbose;
-extern int set_loop (char **, const char *, int, int *);
+extern int set_loop (char **, const char *, int, int *, int);
 extern int del_loop (const char *);
 extern char * find_loop_by_file (const char *);
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

