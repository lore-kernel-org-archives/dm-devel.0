Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A98B0C48BE4
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 00:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660003499;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CFD/SM9suJbEfoSPDPLkZRDMWvMamxh7g6zkaX8harU=;
	b=hE6Cwmk5iNiYO1sp3ligwTwfxPoTgC9HZ6o7pshndODQVyI0g6FSHcIjviKBTXNL8baeJZ
	diqrG0LsSnCM3YlQloIetGcImp5vgiYTV+cUQvhU1WytpcP6UKKGZVXV12prtOaecmbOkx
	z0AcRdkkmb9/VO3FG8RoDLMi3gRLeRM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-C8TLP39WPJiW7rhCe4aOKQ-1; Mon, 08 Aug 2022 20:04:56 -0400
X-MC-Unique: C8TLP39WPJiW7rhCe4aOKQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1A8C824061;
	Tue,  9 Aug 2022 00:04:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C10092026D64;
	Tue,  9 Aug 2022 00:04:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 801821946A50;
	Tue,  9 Aug 2022 00:04:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 067231946A4F
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 00:04:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DFCFB1121319; Tue,  9 Aug 2022 00:04:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DB3261121315
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:04:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF40585A58D
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:04:52 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-9CswjlHFMvSzff2DZtwCXw-1; Mon, 08 Aug 2022 20:04:50 -0400
X-MC-Unique: 9CswjlHFMvSzff2DZtwCXw-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278Nwkdr007763;
 Tue, 9 Aug 2022 00:04:32 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsg69n1de-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:32 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 278M0hoB038112; Tue, 9 Aug 2022 00:04:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hu0n32vj1-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:29 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Date: Mon,  8 Aug 2022 19:04:04 -0500
Message-Id: <20220809000419.10674-6-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH2PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:610:38::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e9dbac0-1d8f-49ff-4af3-08da799abaa8
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: B5G5EfQlhiqwsnpOkUCsIdSsm4LRB2zQsBrAFHJmyZsxQIVtdgmvm05aTdk3ndXwvIrnfWkiD2lHI3bkXg0UWivAXHqZ+wq7VCrpu+ctjrGoAYhWxCQ+Y8wsStT3WRZzZfTMDR79467syqSqYO5k2gNvzKCLlUOHrakStLmrXrdztCPSi2oTW/LjW/Ow6BbdAU+ykk8/Th1wiRnX/96cHzKSKF40ul39m/OKG+1M7QtS/QN9+3mGSgPpmniyxP/gowmyL6cQEyJMTRKTnHVA5mFS+6K3up+rFHG9WvzR/2ueGa+yKvadlb7HCR8JkMSRUBHU18VIygJLvP9xaR8ZKvTWPVzQJDqj2Q5toG70Cn3wBZc3Ip3Pf6ERJ5mDzAHoIm0oEjGwugc5g0f/kJDVQMiv49NkRPVMLkYxloP5TOm0zMuCBDtkfF9n3LtDyU72dsoYdGYIL/WWX7Pthw66fIqQCC/b3S65WPXTHVCUxEspJqLtgiy869vj0kdLIo6NynifZjyAldz24iCfsdQOl6SEeoxfsmiIXaCdILq9IYQ83O39O83ICLvIgfmN5mn+NEy1aFz95SNAy/F1osFELDmhNnDIvHrHZuTBA8sWSfjgosQb2OOexRbAPPdmvBr+VsTWEplsuzYLGwNFMyZEM1apE4gL4OWmB+5Akuaoo2gUDeuCyt196NFJZyt5xOtL0rhGf6VoTUZu6ynW/NeWYUFY9oOWOhU/l97kGQCarUj+XVrwuyWVBsyzF5t841Tfl93JaSXeqQlZO+Ocan9qwTsGrOsM72RwkGtmJJYe5gM=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Ao6nZjBfSfXcZYIxJ5ahtNt6qNGYkecdjr0KAZZsLVEPRfM+i5/zXE30/Hv?=
 =?us-ascii?Q?XVuRhW48auQECvyBJrUscwDkx45gCSSsw6KSuVPZqdSO+h9vEgJ9MofNWYIT?=
 =?us-ascii?Q?fhhA6HomAG/T5NxvuN13nk7Y6c4Ru/8BrTfby04PGe7UQ2RS0NO81zBaS/r5?=
 =?us-ascii?Q?p8FvjO2XrVoYvHtYPVEwd8yCX8rtn1Da71wDmo+pW34PD0qUM6lUIdLtYDmE?=
 =?us-ascii?Q?ljZg0YBNHbT8AQ44XOpShpKYdKcgiEZjJqkhJwfYaQwhzcPxD1k+OvKKn7E0?=
 =?us-ascii?Q?AbdNtqfTJZCXsibBViirZ090ZbJz4GEll2v89Q0+KgjdKX1ZF00L6hfCaxiC?=
 =?us-ascii?Q?FUXUs75yE4gXSxDTMO5TKJ0zgqJ61/UN5LD9ZldS0hF0R/q9PHg0VoSqqSY3?=
 =?us-ascii?Q?JyogyxD4nYHt/6WcwMcJ08l1OB1tqzHzFv0a7Jdh7dNSDlhW/HFmWtSJR3sP?=
 =?us-ascii?Q?V9FAyCpsqrWuw+CL7GWIkN8Px1C2ECe7cvEzU62UO8rnKq2byE+g8/gdH9fp?=
 =?us-ascii?Q?lq69nAXJTGfE1g8fB764OCXb53lHYNCci8NBgQ6RKmPX1O/qGib2CWeLH92J?=
 =?us-ascii?Q?8JfeG1zH2pboEiDZg4zcmVrb4QXoSlDtbFCjR9H71nJy5KYGYsOwzOqL4rS5?=
 =?us-ascii?Q?toE9wNkRPrr6syiE5LcVXLBOzgiu9wcm15KMzxm0pO167bW+wQ4BLD6bLnSD?=
 =?us-ascii?Q?l4IivPQF+KPnh7Te+NxzE+QwlVDk4RPhiqByRU2pLi1sk217AKUr397lLY5o?=
 =?us-ascii?Q?2c+ZeBG8Bw6agkref0/bt+gLtE94q9PBH9+Jig1yIIoNr/pat4pE6ZDGVJat?=
 =?us-ascii?Q?akWrtVwv+xxZtlnWqNYHoI32HxytSQROttmNTajDGi3PXSNW5CebmfsEL7XG?=
 =?us-ascii?Q?M0BI+yGiuRWJUpQ3AFCDjH1p6sSGSYZZLeOyHsa5Weaxrt26njdyAyc3MqzU?=
 =?us-ascii?Q?bIRWAsa5MS397SBi3XEdPRFcrg+bGr/5YJPw4TKzDNPymIdpYP7dkB+w2NvF?=
 =?us-ascii?Q?y8wHQzj3Y0/KTk3JRjMmbo3Dz4oyKKH+I+hw4wMDmC/+ijhmlvocIVOzmyDq?=
 =?us-ascii?Q?0K4VZw/nhU4CxCiaixCXQSf36yvE7SqpFNOVO/rvG9OohR+89/s/eKijGvDU?=
 =?us-ascii?Q?vzUjigpmsVU1HEMZACt5IAZO0KddH5Io7xsygrXwbgmTnyj6t6W16/ZCq4lZ?=
 =?us-ascii?Q?Da2yLxYjfsQ+7Vhlo0YVk5RGvW7h1bG5wDj5gy89Stu68rkYWJ6egFTsvHhN?=
 =?us-ascii?Q?Xo/IBiAZJHngJJd2tXxc34dTwrGON3iMEErYAwKsyj5nrYnVoF/UUO4y9phb?=
 =?us-ascii?Q?X+5LIEWY6Z1/sZ1E2gNzjTWMv96wutq9rNkoOY6KuRYJxCel2vDAE8dpaIwG?=
 =?us-ascii?Q?lT8a4FszNS3CTx2D48k7nIAnJiYZwZu4sFCTW8Ka8AnoItwVmDAB8raVEQZF?=
 =?us-ascii?Q?AAtvgoRgM3ntokLdvzKRXvIRxmebkjbVW6vB73ULc0mHUPdKLrj3MbsTsGdj?=
 =?us-ascii?Q?mbuhQzzQKD+9KNe+Gwf2icspXiJuB9e0CPPaFB4GCRY1mZuqzvpXVL4oiaV3?=
 =?us-ascii?Q?/r2JTetcCmSvvzNWxTMhQqMvoLhPZVRXk54e6PdFdRaHkR+TkVpTETNnzjV8?=
 =?us-ascii?Q?Pg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e9dbac0-1d8f-49ff-4af3-08da799abaa8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:29.1424 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2YyYQgz4U5r+TQrWnjRg+9E96YSGN0p1r/F/PCGd8bELUnojezpl7u48wpuhSTolD++bfvWlSCMVjtWCwcAkpuM+wLFFBdYIU4cN6lUl4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=999
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: gI-7VgP1RgYsg1kSWbDMQiHzUxnkSrLY
X-Proofpoint-GUID: gI-7VgP1RgYsg1kSWbDMQiHzUxnkSrLY
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v2 05/20] dm: Add support for block PR read
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
index 60549b65c799..1b15295bdf24 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3313,12 +3313,56 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
 	return r;
 }
 
+static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys,
+			   u32 keys_len)
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
+		r = ops->pr_read_keys(bdev, keys, keys_len);
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
2.18.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

