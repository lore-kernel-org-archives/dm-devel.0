Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A16DCCA479
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 20:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657225807;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6dASHQIo5WZQmiPr/UGmmdVTnQDvbcirWcO50gk2LIo=;
	b=B9WNl60c0b3OLdMvnJjoGS4XVQjHqdW/BJERnGEXqJzDQGceo2FqVdUOgrv1UJOMW9Ye0s
	baTLruBsObGIFUc4UNsZVQ1klZS7tIqG/us30VXWZPiDf9UQdx9w5ismFLlpON7kb1SXjg
	ldhpnn636W8v9AcaY5wOtuMQIj78KGQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-W6or3w6xPGm3RJgUqU9ygg-1; Thu, 07 Jul 2022 16:29:59 -0400
X-MC-Unique: W6or3w6xPGm3RJgUqU9ygg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35ED2805F53;
	Thu,  7 Jul 2022 20:29:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 91B03404C6DE;
	Thu,  7 Jul 2022 20:29:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC895194707F;
	Thu,  7 Jul 2022 20:29:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D6C27194704C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Jul 2022 20:27:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B970B40357BA; Thu,  7 Jul 2022 20:27:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B44E2407EE6A
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 20:27:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 963AA963482
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 20:27:35 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-y8tIttd6NRyWket8DuTciw-1; Thu, 07 Jul 2022 16:27:33 -0400
X-MC-Unique: y8tIttd6NRyWket8DuTciw-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCLk0020294;
 Thu, 7 Jul 2022 20:27:27 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4uby6bgt-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Jul 2022 20:27:26 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 267K9vNl017175; Thu, 7 Jul 2022 20:27:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3h4udfs6ue-4
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Jul 2022 20:27:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY4PR1001MB2261.namprd10.prod.outlook.com (2603:10b6:910:41::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Thu, 7 Jul
 2022 20:27:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5395.020; Thu, 7 Jul 2022
 20:27:19 +0000
From: Mike Christie <michael.christie@oracle.com>
To: dm-devel@redhat.com, snitzer@redhat.com, hch@infradead.org
Date: Thu,  7 Jul 2022 15:27:11 -0500
Message-Id: <20220707202711.10836-4-michael.christie@oracle.com>
In-Reply-To: <20220707202711.10836-1-michael.christie@oracle.com>
References: <20220707202711.10836-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM6PR02CA0167.namprd02.prod.outlook.com
 (2603:10b6:5:332::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc5f18b5-f759-42a2-41c7-08da6057172b
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2261:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: FFz6G2l2AndU4pu0vBDuzt4uaKIcWIJhjlc13RZeMsYUPgMv+EnI4lZp6OsRYn63oYphkVgkl5r4FD9/6VYsRlrNhRRgI2221/Lz/Ry66+hYLKAEB1PvGnngSMoWAtSiSLfJiJYqdOijI7uofFB47GxHE/j8AFAtwMsITgXilCbThBtJW9FDFZvA+MvX24NNchfFcScOaABIR/mrEHYbdKOYiM/YR7LjM6wTEZBiZVWAS5vCqeCKy96Wg7b5HkPbeGc/UMGeRov9qwCmOi4w87lt65SUb8lN6qyxjE1lSjUEnk1JP4IOFCuSNBITOkCxAESwlIlrEtaRlP0ZdeLv8k8e66bK4wT5YJ/aSPjeV+5W5PgfOnJDNwQjQXhjBoXw/i8i8vKgrH+QfBuhSzbJW1Q/XQ/OICFs6ambHEqKkCgpf3lkCfuHY1Zf8m7e7F3qlQYOuQ4bDPV/CcXq4iZwsrPP4lHns9gGKeEsItrS3ZFdLYJ3iTmTlKIJl6viKrpiNn6+d9I49oKDh5DfXcVzbRS+W6tNCHnTL1eYF7xi/CLeS7kW4rJbwc3rJAxdMxHV59GneYAlC4jAeLNoHuyQpEfriUmhy7lZUm9mHIaS/Gyyrw98U7k/a0BmIOFvk57kjnBFBC0zmpHYuRnzarBUdw9afVT/XXWy1qo3/XPFNdiIWMQsvwEtmi3ubDRTlJYXxxtFj85fLMa80LEReO/erGqGIwaGlXbM2Z53GBbnk2rR6hWDc/z3FPw/KdvCnI+4aocFbizkEvkd3dnwJwxeCT4JWCOwbFTTDmdV0v/M4mBnHEANbZv7ObZwPkWdheCQ
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(136003)(376002)(396003)(346002)(366004)(39860400002)(83380400001)(8936002)(1076003)(2616005)(2906002)(36756003)(86362001)(5660300002)(6512007)(8676002)(66476007)(66556008)(66946007)(38350700002)(6666004)(4326008)(6506007)(52116002)(478600001)(26005)(316002)(41300700001)(186003)(107886003)(6486002)(38100700002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WoUPMT29s+0Mxm/iof6+tE8B4VHkz+wSj5X6VchucraWHn/j6l4JyBSOhTd8?=
 =?us-ascii?Q?tsoM3EEZzka3NIrG9umclIO3zRx/e9jer0q5/VOdbdanrKSDb9H0CPYp8GRL?=
 =?us-ascii?Q?qGpFA6sRZrLsSuguRjSYYbO8k7G53ouL71ojsF+q9ZTaFGg6aAG4/EEMo83l?=
 =?us-ascii?Q?ImSnhnn+18sBPCAq7pMRfaFVGveRepS+RM6M7em1I1ZDSjis9URZSf1SR8F/?=
 =?us-ascii?Q?OFSHHhfSGmuMGIzMahBTaJP2inwDjysKzyLNv7rAXHrmT5QkYAMq8hPUlysc?=
 =?us-ascii?Q?Vjym0UsxYsa4s3/LaQS0T3ZCGdaTQsSfkvQ8+yPJfUNYChijpQI6oMC9vZRH?=
 =?us-ascii?Q?n/Arkq36hLVz9KtDKcPUw6Wq4jFz36/7X+/g5PRTXem4GfG2NUDCihS4rOxL?=
 =?us-ascii?Q?tB+4oWJ4oNh76/4io19ydXh4H3H+RrmZGKxW6pqDxPalRdfbxvZhNQWigWqV?=
 =?us-ascii?Q?1FX9Ayr7U7+f8iewCtCEdWkclLM5gLeALzAEHGEN2fNQb2l9i91dviO/VYsN?=
 =?us-ascii?Q?9372YbvM5QY3QR4QWehUpMdB6H8PWZdlgyMHnMEyFCYdyhe1WGfVWnQScr5w?=
 =?us-ascii?Q?9MHPuXrE0sudKWmRS0JH84JXTOfomg51Ho8sqrw/nPvgI/xQ9J568si87Mld?=
 =?us-ascii?Q?JXFwGACNP/ehBMlkpfeSoyrYd/HgHmmjlntIe8XDGcnyvrS5VyvzCVBLSqV9?=
 =?us-ascii?Q?sA9lLFj0LzBuKAJxYvpfCW3hu6jeM1Mx3F5ojWkd9oEW1aOAV75PqQLm/lQk?=
 =?us-ascii?Q?nYFU+uug8QprnyaKAmvqpxRX/EKrhsdBGkdSiWha5YvBsRHvAlBH2Oy/XIgv?=
 =?us-ascii?Q?QD1Z8+QU7y3oVvyyA/Y7S4thdEmcTgxJ29eCqFQwt+oKrmWeEhn2O5Yx7yyX?=
 =?us-ascii?Q?nV2mq9Pj+TPgarQtoE3sfxO7VVCqzZHLZ7MaMQq6acQZR/E3Ln4filpfMDPT?=
 =?us-ascii?Q?Th83kWbL56TQZyCKTaA8SezvJf9mNV0eGShCZB92DV2Yv3hAfsOEGiAxFvoM?=
 =?us-ascii?Q?LFMbPHyCqqk26DawUiFuI0QkjUoeRLzFNUSfWOOqdIAdAJwyn4bzYVaRWIvP?=
 =?us-ascii?Q?HAM/JQMYgeH2t9VPHw+m266L1rlYOdRINcNQu8aiRr3fR6LEOHNlStB6JvQ4?=
 =?us-ascii?Q?5iXdcMosoCb9SGRZtG+FL9Vk3TEvwuaaTjsmFNmQxAs7voNBizr8A1Z722iv?=
 =?us-ascii?Q?/r0qCrx9E0BFOIJift8p7bIDyCy6cp+Y4RmLMmKHrAOFSpuvvDL8iG3kMuzO?=
 =?us-ascii?Q?gaO3JQ8FuYJPSaI5Sa5TpwMNivaLSkUP+c95LYQrXaAw76tK6XD6L7ueH2pb?=
 =?us-ascii?Q?cY9Eqn+df+JjioTosya8J+b/62sfwrFJZ9U7k6SXVbDZIDO6WVehIsAGQA0d?=
 =?us-ascii?Q?yuIbhWfnp0qxWo4LNfSqCzWJlwxiszR7S3RRJJs0+xDnG+OD/NFYW+UfRfB1?=
 =?us-ascii?Q?hGdAG+XcDig0hJyt1q5RNjLgZgdnG2wZh6n8Kg4id/i4+OCd49y9N/Axt7f7?=
 =?us-ascii?Q?Nb4L1CTpmsux1SkqgRZ/oy/HAxRbau70oHeQuxc/7bfyyPjDSkugq/0aKWvG?=
 =?us-ascii?Q?Z1zsU2ciqSl3kRo/9b5BKhZ5KVF1WjwtHYvR+Ui6rcsiWEmG5ZT8XcMbap7J?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc5f18b5-f759-42a2-41c7-08da6057172b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 20:27:19.4884 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: idw84gwX+mJCzWvmLxtwwN40cJeZd1UUj6l4QlmGt2BbNwx6T1XKDxFt3hSZMFTldvHYbUoXDrHqx18jwTAPna8X7yEgQQIDjou4cA0pkSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2261
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.883
 definitions=2022-07-07_17:2022-06-28,
 2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 suspectscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070081
X-Proofpoint-ORIG-GUID: ZMV9PK7m3qlBkDKXIGYUwXJfNP6QHjGk
X-Proofpoint-GUID: ZMV9PK7m3qlBkDKXIGYUwXJfNP6QHjGk
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Thu, 07 Jul 2022 20:29:55 +0000
Subject: [dm-devel] [PATCH 3/3] dm: Fix PR release handling for non All
 Registrants
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch fixes a bug where we are leaving the reservation in place
even though pr_release has run and returned success.

If we have a Write Exclusive, Exclusive Access, or Write/Exclusive
Registrants only reservation, the release must be sent down the path
that is the reservation holder. The problem is multipath_prepare_ioctl
most likely selected path N for the reservation, then later when we do
the release multipath_prepare_ioctl will select a completely different
path. The device will then return success becuase the nvme and scsi
specs say to return success if there is no reservation or if the release
is sent down from a path that is not the holder. We then think we have
released the reservation.

This patch has us loop over each path and send a release so we can make
sure the release is executed on the correct path.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/md/dm.c | 48 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index cdd1656b99d6..c31f99c9d2b2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3178,24 +3178,44 @@ static int dm_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 	return pr.ret;
 }
 
+/*
+ * If there is a non-All Registrants type of reservation, the release must be
+ * sent down the holding path. For the cases where there is no reservation or
+ * the path is not the holder the device will also return success, so we must
+ * try each path to make sure we got the correct path.
+ */
+static int __dm_pr_release(struct dm_target *ti, struct dm_dev *dev,
+			   sector_t start, sector_t len, void *data)
+{
+	struct dm_pr *pr = data;
+	const struct pr_ops *ops = dev->bdev->bd_disk->fops->pr_ops;
+
+	if (!ops || !ops->pr_release) {
+		pr->ret = -EOPNOTSUPP;
+		return -1;
+	}
+
+	pr->ret = ops->pr_release(dev->bdev, pr->old_key, pr->type);
+	if (pr->ret)
+		return -1;
+
+	return 0;
+}
+
 static int dm_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	struct mapped_device *md = bdev->bd_disk->private_data;
-	const struct pr_ops *ops;
-	int r, srcu_idx;
+	struct dm_pr pr = {
+		.old_key	= key,
+		.type		= type,
+		.fail_early	= false,
+	};
+	int ret;
 
-	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
-	if (r < 0)
-		goto out;
+	ret = dm_call_pr(bdev, __dm_pr_release, &pr);
+	if (ret)
+		return ret;
 
-	ops = bdev->bd_disk->fops->pr_ops;
-	if (ops && ops->pr_release)
-		r = ops->pr_release(bdev, key, type);
-	else
-		r = -EOPNOTSUPP;
-out:
-	dm_unprepare_ioctl(md, srcu_idx);
-	return r;
+	return pr.ret;
 }
 
 static int dm_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

