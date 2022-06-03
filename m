Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E127C43334
	for <dm-devel@archiver.kernel.org>; Mon,  6 Jun 2022 06:47:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-1SevBIsdOUCwancecuAcjw-1; Mon, 06 Jun 2022 02:46:21 -0400
X-MC-Unique: 1SevBIsdOUCwancecuAcjw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 524171DC2427;
	Mon,  6 Jun 2022 06:46:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3EC541415101;
	Mon,  6 Jun 2022 06:46:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 03ACA1947B9E;
	Mon,  6 Jun 2022 06:46:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 688041947040
 for <dm-devel@listman.corp.redhat.com>; Fri,  3 Jun 2022 07:28:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 490112166B2E; Fri,  3 Jun 2022 07:28:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 440F12166B2D
 for <dm-devel@redhat.com>; Fri,  3 Jun 2022 07:28:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22A803806720
 for <dm-devel@redhat.com>; Fri,  3 Jun 2022 07:28:44 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-rk1jKUkjPwmjYIFA_yIUbw-1; Fri, 03 Jun 2022 03:28:42 -0400
X-MC-Unique: rk1jKUkjPwmjYIFA_yIUbw-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2533RLC7018224;
 Fri, 3 Jun 2022 06:55:53 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gf8rwrbeu-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 03 Jun 2022 06:55:53 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 2536oNhe025389; Fri, 3 Jun 2022 06:55:52 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3gc8p5nyqv-5
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 03 Jun 2022 06:55:52 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2789.namprd10.prod.outlook.com (2603:10b6:a03:82::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.19; Fri, 3 Jun 2022 06:55:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 06:55:51 +0000
From: Mike Christie <michael.christie@oracle.com>
To: linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 hch@lst.de, axboe@kernel.dk, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org
Date: Fri,  3 Jun 2022 01:55:31 -0500
Message-Id: <20220603065536.5641-7-michael.christie@oracle.com>
In-Reply-To: <20220603065536.5641-1-michael.christie@oracle.com>
References: <20220603065536.5641-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM5PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:3:c0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd23a3e4-912d-4224-2ae2-08da452e188b
X-MS-TrafficTypeDiagnostic: BYAPR10MB2789:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2789909981068555A667F44FF1A19@BYAPR10MB2789.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: iReRVgQOkF1GRV6cY2JXE2vU/RO+JGJCwK1VUhbkuAqOZj3UXTSFiwvr7c56wWdZ4PXCGxmz9QVs8eCv8p2hnUByzDkGQ8G9zcDuvctjVDt6PKsVlZz93jPeZQ9kR+gNqzbsSmmulnChEKBbz3ZHdBTOo7Ls/Olq2+Z7gGoU/hZk0jLpx0Vd+NhrRJqNAv+zXWpBjEUocc0br+SFc13uHFxDRNVXoNaijmsm1I0mKWKUQIp6GNaMs09Y6Qj4qobHL1wsaCopuq6wlcqAP0qxt9NJ8wG/8EjydYFYNP+yjzcWwQ4w6wTWqyxK5ZrFhgeYlhyGRyu5Po0tttrHwLMoLgeFlkFPX43nuanU7gF0Pmv+ufc2u5AM0BXKO7WYNcQRsV5EFFcoL/6yc4FKJeSF0mdZltqZN9nI707xXol5Azn6Eyn0gbxZYs/Lrd0lmE/IRihi95OIHcjnvfRiJQZyNa7O2YdEI/sQQo8Q9RmLNVpP4nlLLdtQrkgJTHlIIXg1pAcOK2Dnqu4Hq8IYwpq5c/3c/N/XoBnPcFFKfPXiIvJvcXD9WvcaCiXBbMwplEI7nDMV/hZXG8w3W2GvoaOsQDvk2A8tlF7N9xx8ZxwbNoOp1sT+Wvb7kHLQBteE//cy7k6jtDsqStloDsVHb0B/tx7zA8ZssjbWLvYnPDz8uTC1DYEIr0d1zM9RQ7xbbQ+GGW8YojxyzVDtNXJh9lQ4/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66946007)(8676002)(38350700002)(38100700002)(66476007)(4326008)(66556008)(86362001)(83380400001)(36756003)(8936002)(107886003)(6486002)(2616005)(316002)(5660300002)(1076003)(6512007)(26005)(2906002)(6506007)(52116002)(186003)(6666004)(508600001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+R8Sjq9a9gBhiz4yxU2sLZHJBsWRtSmMj0wUqvSMH33SsWXTvltaEvJtJIEm?=
 =?us-ascii?Q?wRQDEcpB8Ga8yRCZcMKnSwlgE0wS7DS9huhFgCSOO+3M/tNN/jCzwJX0qcZ+?=
 =?us-ascii?Q?wlNkf+4pT+aNC4YzjcA6WVdse3btiAEZqj3kAXpu84XLlT7DdOAlEbbtNgCL?=
 =?us-ascii?Q?5n2ly6f+2cSV+2xZnYJazt0pyemt06CEzoXOD6RSetBBicOOD/X41rJzgHE/?=
 =?us-ascii?Q?sXgFDZ/O4XUj+3Jbd1qL8eY7S7I3ID9s/K+tHflhqrgARjBZWA+CXj87B9nJ?=
 =?us-ascii?Q?A395HGehWRYoUoyRr8NgqMrv6Z4I94zjv9Jz+2I8/9gb4bvmRrvLJjBKK5Ig?=
 =?us-ascii?Q?cCv4Y+u+/nj2FJ/7oyNGKNpWmJ9PiLqwU5WXO8A6hBKUToKA5/RT3biB04p6?=
 =?us-ascii?Q?n3d9435FdE5gnNBDgHUKI44OUbJDlOhBen3hTY0xa4chzQB4OYDwvzIjMxe5?=
 =?us-ascii?Q?Eq76wuhcl+cM+Lq6orfLKikhXGP+LDiqd0kS88oDx2UPUV3uKvxqwHVmw37C?=
 =?us-ascii?Q?1BW/fAZGibFufT75E+Q/0nZ2A1RwW7Bxjz3iwo4zuctCtfyxfeVDGq2oFxap?=
 =?us-ascii?Q?24aTrSpptwqyPGgBm0560ir9KIr9MIBoXoM0xjHln630wMy8AuNXumhfCdFM?=
 =?us-ascii?Q?y5YDrszX1APxYChkEP9L5UibbSQ+C0jPHOvYBmYW4oxyUrvobmR6IuWdGfVm?=
 =?us-ascii?Q?yI6gRodUa7p1mMba6DqDCQFRZAxeoR+7TILk5AeiAlLCK+hHNHOUbyCriR9J?=
 =?us-ascii?Q?L7CNkmhFzUJ3cRvUJLUSlGgLZaOb+sU1SKyui9gM/UrLqaSDtQSuMvgAk8Pb?=
 =?us-ascii?Q?GN8K+YB0eGPOpkY+SDavXFKPbsdr1kgDXDduRdADNuIZe9o4YHR23k8iZdEE?=
 =?us-ascii?Q?RTjtM25l1FP47fuF7xF7Kyf0k+e0aIlUFGaEkbNtJwHt0oyfGit4NKTyGxQT?=
 =?us-ascii?Q?gsV9vmWuick88UCLp1J8/McM6gttY2aAO1yU3vWdrlXQqMr8umrM4ebkfZjU?=
 =?us-ascii?Q?1kotxIBEuLImIadgfWTchzLsk8arGcmj8j3CzLaQJDxXqbS9CUk0+FqeIhen?=
 =?us-ascii?Q?mWzp25EJPOeeHNaGLESVtT2f25lLWPngdEHMDqHyuDMy1t5cVfyU2bBMQ2FC?=
 =?us-ascii?Q?KPEzJVrGXAlSXqnnlGutKSb0vhRZD3WVTVTTVvTZ7doCSrSSSjGMt4gDiwtS?=
 =?us-ascii?Q?gJMt6F7eLfkNLcduB8hL9GltNTkkkt9zphdxPGkdjcUv+F2J+6+04KkH4MSp?=
 =?us-ascii?Q?kOlC5TXZ91eHeglMzTTHRIksLEOE1VdLSpw0q/S2LdjR4Qstphu/vndVZrUz?=
 =?us-ascii?Q?3z7EnQShyfqgodt6G3S+fdYUL+lCKeC++456DgU2K24gygf+oGFr2tSX4dDI?=
 =?us-ascii?Q?BuVSicUoNBV6lPEZ3GrQmGiOWhUzaKPcTYHNpiuan4IF/MjJM9yBFXEoEzKj?=
 =?us-ascii?Q?5miRgli5WN8YGQZnybepNz9ttNoThjXtKoCjLT4Cm/f0tSh//dRA60O4I4Eh?=
 =?us-ascii?Q?pyZGgvZBB80Z31c0lTNP7mYcsPwLrg1KGUkief/YLDQF2wLlqPuVERn6qdyA?=
 =?us-ascii?Q?iUOelighNLiMKEmRm9y97cc4os/vaCPwHeCsz9OGK/UIoK97XA3ReKVaE02q?=
 =?us-ascii?Q?ZYn+zeZKn6OiU1cONusakWEIHYRhU7rqzWzifm5UPHvDk6aHkjtZKNCN24eu?=
 =?us-ascii?Q?P5xPYXQhT1MvP1BJ1g6bjVw9rF8EjdpfoxYkdJs6niE0K//klvCjPfa+Q/ZY?=
 =?us-ascii?Q?JZFGC41h0obwJaMVRoY1y8vhu5Wh2k8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd23a3e4-912d-4224-2ae2-08da452e188b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 06:55:51.0650 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eeExv4M7MMoVkwa8ewfHBeHCldG1D+B24K2HXW7/ku86Swt+zyK+JmxLVEC3dzg2YkboasjaNOeRPRTQ5wjyDtZvAgkF7uceQv/lcRfSoLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2789
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.874
 definitions=2022-06-03_02:2022-06-02,
 2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030029
X-Proofpoint-GUID: 9g460uK30znmom4prnA6w7b226RLM_WW
X-Proofpoint-ORIG-GUID: 9g460uK30znmom4prnA6w7b226RLM_WW
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Mon, 06 Jun 2022 06:46:16 +0000
Subject: [dm-devel] [PATCH 06/11] dm: Add support for block PR read
 keys/reservation.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This adds support in dm for the block PR read keys and read reservation
callouts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/md/dm.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 82957bd460e8..ca544dfc3210 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3114,12 +3114,56 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
 	return r;
 }
 
+static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys,
+			   int keys_data_len)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	int r, srcu_idx;
+
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
+	if (r < 0)
+		goto out;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_read_keys)
+		r = ops->pr_read_keys(bdev, keys, keys_data_len);
+	else
+		r = -EOPNOTSUPP;
+out:
+	dm_unprepare_ioctl(md, srcu_idx);
+	return r;
+}
+
+static int dm_pr_read_reservation(struct block_device *bdev,
+				  struct pr_held_reservation *rsv)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	int r, srcu_idx;
+
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
+	if (r < 0)
+		goto out;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_read_reservation)
+		r = ops->pr_read_reservation(bdev, rsv);
+	else
+		r = -EOPNOTSUPP;
+out:
+	dm_unprepare_ioctl(md, srcu_idx);
+	return r;
+}
+
 static const struct pr_ops dm_pr_ops = {
 	.pr_register	= dm_pr_register,
 	.pr_reserve	= dm_pr_reserve,
 	.pr_release	= dm_pr_release,
 	.pr_preempt	= dm_pr_preempt,
 	.pr_clear	= dm_pr_clear,
+	.pr_read_keys	= dm_pr_read_keys,
+	.pr_read_reservation = dm_pr_read_reservation,
 };
 
 static const struct block_device_operations dm_blk_dops = {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

