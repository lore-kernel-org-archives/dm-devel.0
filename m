Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EB11C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 23:51:21 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-uFA8ttsYMniIz44LeI5E0Q-1; Fri, 11 Feb 2022 18:51:17 -0500
X-MC-Unique: uFA8ttsYMniIz44LeI5E0Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB6DB18B613A;
	Fri, 11 Feb 2022 23:51:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 74DE21017E38;
	Fri, 11 Feb 2022 23:51:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 700381809CB8;
	Fri, 11 Feb 2022 23:51:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BNpAsu002381 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 18:51:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4112B2027EB3; Fri, 11 Feb 2022 23:51:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AFA82026D6B
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 23:51:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9639E800883
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 23:51:03 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-220-FKPaCsELNkyE4_dS2_JlQA-3; Fri, 11 Feb 2022 18:51:02 -0500
X-MC-Unique: FKPaCsELNkyE4_dS2_JlQA-3
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21BIlTcs015522
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:00:36 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e5g98a5pg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:00:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BKu0xY042755
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:00:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by userp3030.oracle.com with ESMTP id 3e1ec81rs1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:00:34 +0000
Received: from SJ0PR10MB4654.namprd10.prod.outlook.com (2603:10b6:a03:2d2::16)
	by DS7PR10MB5310.namprd10.prod.outlook.com (2603:10b6:5:3ac::22) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Fri, 11 Feb 2022 21:00:32 +0000
Received: from SJ0PR10MB4654.namprd10.prod.outlook.com
	([fe80::f81a:f3f8:6f54:fbbd]) by
	SJ0PR10MB4654.namprd10.prod.outlook.com
	([fe80::f81a:f3f8:6f54:fbbd%6]) with mapi id 15.20.4975.015;
	Fri, 11 Feb 2022 21:00:32 +0000
From: Ritika Srivastava <ritika.srivastava@oracle.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 12:41:48 -0800
Message-Id: <1644612108-2445-1-git-send-email-ritika.srivastava@oracle.com>
X-ClientProxiedBy: BYAPR21CA0024.namprd21.prod.outlook.com
	(2603:10b6:a03:114::34) To SJ0PR10MB4654.namprd10.prod.outlook.com
	(2603:10b6:a03:2d2::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf2a9193-81b8-4cbf-8180-08d9eda18aec
X-MS-TrafficTypeDiagnostic: DS7PR10MB5310:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB531056F996FFB669D5FFA9EA8F309@DS7PR10MB5310.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:186
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: zGlWtpL69cw62vA/Dauqsf37pRr8eAHHtUB7GT+mNb/ZWJQI2mi0kOUjYqYJFaTIUiEO4nyRS2ikG6D5Ri8PWURvRJkEaMQKYgp2o9Isuoh0DRNQ0GDcEp/k5tKpHPtPR48pRpj2txlzYcvVGVFmzF7B5X4WQAr8C/3e7tmTv9DJhClFfuc9oSWyw5HhH59vn8mXOrCavnj7OmtllSagGrLp6V1WJb0QIDhMpot6Yvzk75o75iFqarJi/0p22d/6Yge0h82j2fke8iP+6w+f+8ZZITIX/CF0yvFbWGEViq0LtRNq8ShdxnVC7wyVvE9trl2BFqC9PJ6+XSxyR1hORtCE0LvRdgdJl1RdIbwjS4urlioOt2YXAFWZfbaBnXCOjx+xlEX3JFAOBWYLp9xo1BOAa9yZgWghM3yLka7kZDX8JDS+j1OpdZIW+nqgtzyrWMKTURMJZZ8+49mqT7BEJSq+0sSJQWxxujwEIGeNYKZD5F2qoLCgJz0cYLAY31Y6vbjRffG1e80TDNP6RlM4MlxyB5DRT5GnNAE4bV7q9iKrbZoRy5P8nJpULVsU6GlBSiQ4vxrdQanKBKqq4GLZIFSEor42HvM1jRIuV1qeUaJJdbOdVqow149AytVx2RAv8DuJEFNR7/8LhxilZtocyYGKKuhlsx/A++wbTk+49jSRyLS7+5UUzrD4g2t94SDBmuzsni8l26SMykiaWK8C5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4654.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(66476007)(66556008)(8936002)(508600001)(5660300002)(8676002)(6506007)(66946007)(6486002)(52116002)(2616005)(86362001)(38350700002)(6666004)(2906002)(36756003)(6916009)(186003)(26005)(316002)(44832011)(38100700002)(83380400001)(6512007);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4lt+ngab/jEp6RWAL0WCQ4vi/u2/rvTtM/tVQuZHnk0PvY+H5+lo8l8mqGrR?=
	=?us-ascii?Q?Mcoz2H3rLg3liIWz3WEAtAfx7V6/s2LNOQwuVxNcDczc37aJwFuTZe/X5pRB?=
	=?us-ascii?Q?wx+oBuNC5tTT0AIDqIyzlDzGWW30sXFgrQryi4rZw7rsdK5p7eqTHhqspjh0?=
	=?us-ascii?Q?CZUzWN5iAo8/XXo6+4XCFG2aUXhM0b4JzAt3vLXYe7trLAcS0wzg1Vhjmzpi?=
	=?us-ascii?Q?Nr3KqFH1D6pCbZa/xSLjf9bfmlT47vc3C8B1IK5rOrbjyTAuRdc2QXJEZnq+?=
	=?us-ascii?Q?0yE0Fu4RN5eKBpGZzvnOHkkhtUSGlpStuZAvZZ/Yee2Xk0YzNip/AAkz/uy2?=
	=?us-ascii?Q?0VzqQIjcMFD/88mYTmH0npMIC2vGGhYTrjfNZut/0cpbSrKQHstcjm9i+/nL?=
	=?us-ascii?Q?7TppMDeuQ2cxrk+0COmDnEtnNqL5gUsimdG45mVHcqqUBJBruH+aFdrWcvMu?=
	=?us-ascii?Q?VIlodNMEGSICJ5oojHM+n9Ao3HRBw92QyvYa2hPs0kRxKwPcRK931eBisJCs?=
	=?us-ascii?Q?qJrasCEeMfnDfMb0WYSsE/UPvecw9j2L6TleGK94ERl0IXv5AxUeHqP8ZuJ7?=
	=?us-ascii?Q?WuF4z7RXlAiSr1slwCwY83SPabczLY3EFkdxSklTxl2MGDc0rWG16hv64eev?=
	=?us-ascii?Q?k7xmly3DO46Bn0Z6a7CI18oIEBmzThh1Bjskqw1uT4kcX4M7fVmqp1YTum+0?=
	=?us-ascii?Q?32qY1qwd1jL0zUJKA8CB7f3eYhtM03uhyprZu0FWXGrTOyxShaPw9WxOhaPp?=
	=?us-ascii?Q?AcGomwmJTHgM1CgEYHt9jpFzPXI/uMwWT7XB5Otj3zOD/+SjdLty9p2I32B6?=
	=?us-ascii?Q?1Ez+VZcx+riBSzNSHwZwuhRb8LvUhLN70JiiG+StYUox2g9NrUdUkHN13Sv1?=
	=?us-ascii?Q?kfmAP9zKG97nIOIrIgy3/9g9nprXBPJyY4EABcKqmWfeiEBsZJAru/zWPGr2?=
	=?us-ascii?Q?ESDE/NCGlxNWDNI4M75N9y5Cx50RZweZ62NzdhEbNnrjGE4JqUuU5SX2Q7rI?=
	=?us-ascii?Q?KVj9tH2qfSPQSoXsL/ueQYI3APdwabzhmWG7r3ZDyipOdzPIRtjlglvukQ6K?=
	=?us-ascii?Q?wcV6N7dByp+xhbkqzjbKcQmS/4LeO/bMCpbs1/yQxQhFo4y0i2WPdZMZaRDr?=
	=?us-ascii?Q?EGIXOHfAtjXhuzUMJVq+hQTYBokzpiMfEI7ag9d1E9AnWTlTQk8NXCkdBN4v?=
	=?us-ascii?Q?6NqohkKygopWNfnvocAJAtslmHvbgKpU4/D0ofZl9h96XgB9KevEMm1GWQKs?=
	=?us-ascii?Q?2le8Fyacm4gC4ztV2y+Y54PI+8SR6sBTtGYUhdUKSlSlcg7kkCs6vvPzzAkN?=
	=?us-ascii?Q?K7XnXQ9lEXscZKOTce3f6NFDgnwdvOnTWbhA1SxX2WW3XKrQDeuls2PwmdY3?=
	=?us-ascii?Q?VxviRcb2bzZYb88MHZibQ8AYPphHVRlGJRgHq/YvLqCxJTQO51rmtPiyAvpl?=
	=?us-ascii?Q?J2Drh2w//+ehv4r9m24p/+0APsTDLGj3x+REC7sca5yDB2iaC+BATIknKyGG?=
	=?us-ascii?Q?dpninrfD36fG8qfzkqrtglr6Roa88J+kMqC8oZ49sYzP3VyXLmbFWTD4Oqpi?=
	=?us-ascii?Q?wDIBSurCRgk6C6zVxE1auO0pS/pvH0vdEF9l0C6DwL94FlUViv3nIrDOn74w?=
	=?us-ascii?Q?cRuTT//G5+Xc+ONMSPmSGOf4Y8Uz00QE2uOHNgZzPP/VgRlvYt+hlYMJme6a?=
	=?us-ascii?Q?BOb37w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf2a9193-81b8-4cbf-8180-08d9eda18aec
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4654.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 21:00:32.7158 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r397SiCq3FhgAauzoxDaTFdcDlMFCZIXwYvnaVX/gtM2REqsKNup900VEAZWYPd0cC4tGAYNgpcqYF0uesxSdjamXEJauxp/OWEmTLOQL0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5310
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255
	signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	bulkscore=0 suspectscore=0
	mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202110107
X-Proofpoint-GUID: v3dcbCGF_mScFIB84_NsaCSB1SzUUob_
X-Proofpoint-ORIG-GUID: v3dcbCGF_mScFIB84_NsaCSB1SzUUob_
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

