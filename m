Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8994C00140
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 00:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660006142;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cD5ply0tRJTf6HVrXNBjXs+jyKHdUKVd+4JI+LhER+o=;
	b=KoM/lR6OG/VocDglPWYByMcNWmKKCR9mX2dP8ay3FJNRNEgR3Hj+je5WlI1x2m00gOo3FO
	8+dY1pxDcFtiw1dWOAX9pKODouAF2UuQxef0yudJpKxL/n3Nnvvz6wdRWol08hshTklBTl
	tlpJGQ3MslgApsBTvQk4R8yPdSrDA+E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-ekzJNv9aNtqiRzJHSV2-OQ-1; Mon, 08 Aug 2022 20:48:59 -0400
X-MC-Unique: ekzJNv9aNtqiRzJHSV2-OQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 973AC85A58A;
	Tue,  9 Aug 2022 00:48:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3D086400E403;
	Tue,  9 Aug 2022 00:48:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0DC6A1946A55;
	Tue,  9 Aug 2022 00:48:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 842CD1946A4F
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 00:48:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 684F49457F; Tue,  9 Aug 2022 00:48:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 63A6818ECC
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:48:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ED8A1C06901
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:48:56 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-8mCZfz0-NMaxbEXUNkAE1Q-1; Mon, 08 Aug 2022 20:48:54 -0400
X-MC-Unique: 8mCZfz0-NMaxbEXUNkAE1Q-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NweGJ020677;
 Tue, 9 Aug 2022 00:04:42 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsgut53aa-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:41 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 278M0hHn032800; Tue, 9 Aug 2022 00:04:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hser2cbrd-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:38 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Date: Mon,  8 Aug 2022 19:04:10 -0500
Message-Id: <20220809000419.10674-12-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH2PR18CA0044.namprd18.prod.outlook.com
 (2603:10b6:610:55::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c50eed6-b28f-45d6-7306-08da799ac062
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: cYaXt14XyEP3f879pPAFFtLBsRfRz2bpRQtZ11ny5nTvpLgKYW3aEi2iHVpvWBE4MBh1DGXTX7s+IjaD033dUyQxj0b0UTqnK4eFfOZjqhG8vYLmROd8lKnDvZ+yrzx3JA/iNL1EAcXKdrUUaJRtZbIywyCZQ7D2lKKGD/Be2tivqcSlNlJUoKAKnMttDjKH0d0z+SmDDqLDB33A2dJ3jmJEg7Q0GW6i0JUc0dJJawPodPtBXKc9iQ1rY9hJvOBdxyz2u1PL4UAihU2OrWv7+aCpd0K/48SzfIIdH7SKHdcTcCLU1NpVSayFTGCCk+4pqAaCw8Z+h6sZcylQwr31XDIO7Azl4aqumhjNr2/T16VfR7d/XzpncyvluQrtM1iHoScFjxrgjn8JcIktZzk35OA4mBkEN0o2mCPFRurL6/yBs5f6xq4VYAM2+wkfPL7rPLBWoFDCAqgBXWHNBj6wmMSfy9xvtbwLLALlNH9J1HadPD4n5RjVFhXlNqspovzrbwL4ythPDHYwAsgHRx/GfXx/5VQZcNrEv+2beXpUIiVlXTCjjL+d7xHZFF1jY9yFKJiO+OEcW0CGeeEViJh49IDi//2rPjZ/ocWYk4Vnoj62BRNhdEe8urYq2TUya+vGXFsjlE+VMlml2YSjBxo1lzjhMH1pE8jt0WTmGcoLYPkxlaXPCLxoLR47DbTrpsa07oRYgrmN8WrM9Gv8JBQW4Z0g/BJm0TgXOSnHjC6TvF7ptvcaJyGuPBqXZ9qEgXijgKYnme9R5we8IR3ws0QdyjK7Visgbxvrxnz8Za5aRIA=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1c6RnEyEJY+HQJo13NuxrkD4Y+Mia5m7ds0aJSxmaPATYjZQ2oUZVHne0OIP?=
 =?us-ascii?Q?3r4hNO2d68OhCoju5yXbV8sFBgyvbUdrAdtBMtLWTzVXbmXEdXlZJYFlwijJ?=
 =?us-ascii?Q?pNiQozr9znfwGvFCaH1mhY+sEVWXhZeSJRtC2C74Lphg1r2tkuX4ItpUf7++?=
 =?us-ascii?Q?yrVc08jYtfpW2CYxgq8Cb6zpVK7CEVYz6a+ZYMKLC/rrCfH2w3XxuLiAP8bz?=
 =?us-ascii?Q?FCaThcghEKymC5L7Jyz3KUbeH1p3RfVUTfEyHibNcmcbECHt8PefIwNQmn+p?=
 =?us-ascii?Q?qhyhsgIuri5R8QFuzbNr78B3DtITnaFfOcm1FjFe2CVG4Q/k2tYJ7dPmadOR?=
 =?us-ascii?Q?3RsKD68+KnNuM2DOmqbnq2/G3MSbZgcUvyvNRtYjRRahxKXFl1z3UFblLFQD?=
 =?us-ascii?Q?pfHAvxNsIsgtSYE/AKe9GM+z/ksVC+7z+jtoV8N1jc/sanFPqEci1KPB6Il3?=
 =?us-ascii?Q?bCDBhsivsYhOyWNb31FaXQEltXUWHd+OgA+/cUF1VavqR3ovzENnJVYmurqS?=
 =?us-ascii?Q?eC7AvdJO2lHA5/DrS7u5Qp9FZbvLEZ7ql6ix2H9y6SkLchirWwuLpSdlgcU+?=
 =?us-ascii?Q?6i38xcEruOPrYCh0gSgSTRW1E6APT12E98+tv/8aZUvoRg/l/APB/cpdJMm7?=
 =?us-ascii?Q?0RFL4dVqtex8PKRCDuRVRyjvDp8CXJ5u0rwcDqH0fQcQOQC0YsIgWQEBAyrL?=
 =?us-ascii?Q?/UNElONZvR22zUW5UgxMJEV8ZdIW5yRQbqKd60ugflW5F7niUwAPfsEmHrcq?=
 =?us-ascii?Q?YikKF355Qx2yjCO3ZraUq/8u41zLRM0vnat1K27tOXfOEYHNLh7Sl0NOa7qZ?=
 =?us-ascii?Q?rxDvirZAMVeebmVX7Ahj2e0Zm3j+cG6YEe6JiDm2kSO6yeGTG2WV2W2MSVsh?=
 =?us-ascii?Q?Yy2YbXR2T1xHh6V3ITnqJbCFBbltaqD3RdGKvz7IR33q+wUt1I3Xw78sFyDv?=
 =?us-ascii?Q?o6WyOWYkhS2FcBBi+8L6TGQNwm9skj0q5Gegw1UtaWLDUEj4z80HnUvGWDAJ?=
 =?us-ascii?Q?HwmajxjfoUo73NYV5PiFHQGqE3K5NyqyAbpub/2jiNNACTEF9pq7hr0MI9KE?=
 =?us-ascii?Q?Wd8FRqw+hnaaKoeV1Vh3MrhhLZtMl33zgC5qrU1vk5hGzJLkJbm641JYNRoO?=
 =?us-ascii?Q?m+zxzeNLQcIe82ctXAwsUHQ+GjTzmZrXwADa1PCwJKvgdzx+mXvnAJtDlKvN?=
 =?us-ascii?Q?ezce2t4oxOYP6VNk+MmhMaDAW55KMvMrlyXM1l9yCR7sTF22raLt+1eq+3Bx?=
 =?us-ascii?Q?3znwjCGsFCKMGhIV9IyUMiip9gImTr7JN3BlR2CZyx6xnsEfvT1K+BW+DLIz?=
 =?us-ascii?Q?1fz/7KbHG1FWRWmxCJhn0nPnc133UnsiOIzBzZgGzPhp8WkMkbT47jzp4JTc?=
 =?us-ascii?Q?8qLsWbr07PNkZagu6T1q9diLPMKwAAL+3rC0KABhcyQR+AjSn4Av5nWhi9az?=
 =?us-ascii?Q?D3IET4lIy/fdGEO6MYAceKNZI83irL06yTgTy6CdR7z3yn3C7TSJN+rFvw/b?=
 =?us-ascii?Q?0xRF0rnf8g4Lh67DZpuuZzisxVkFTMAFZHFYJ9opgDI3BJ9cLOHtzIED4aSv?=
 =?us-ascii?Q?k9CeB18wt5zm6Gic7Ns3Ab/QmgEhrCGW4vXW/Jvk3wVrIV+l+uQJNsJYJwpN?=
 =?us-ascii?Q?kg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c50eed6-b28f-45d6-7306-08da799ac062
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:38.7354 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yex6dyQzfFbVS7lOwkdc/7B7kYPoZbl0fwiSU5KPI3EIgjf3y0wnryw1hIRwfoPAsduvJ3FUe8sZvo+iOUO+deyA9x1LCynZU0du+bsTc6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: KSxOCj_gnIkONoC4guM_FB7JPr5LkXGS
X-Proofpoint-GUID: KSxOCj_gnIkONoC4guM_FB7JPr5LkXGS
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH v2 11/20] nvme: Add pr_ops read_reservation
 support
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch adds support for the pr_ops read_reservation callout by
calling the NVMe Reservation Report helper. It then parses that info to
detect if there is a reservation and if there is then convert the
returned info to a pr_ops pr_held_reservation struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/core.c | 68 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 230e5deca391..5bbc1d84a87e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2267,6 +2267,73 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 	return ret;
 }
 
+static int nvme_pr_read_reservation(struct block_device *bdev,
+		struct pr_held_reservation *resv)
+{
+	struct nvme_reservation_status tmp_status, *status;
+	int ret, i, num_regs;
+	u32 data_len;
+	bool eds;
+	u8 *data;
+
+	memset(resv, 0, sizeof(*resv));
+
+retry:
+	/*
+	 * Get the number of registrations so we know how big to allocate
+	 * the response buffer.
+	 */
+	ret = nvme_pr_resv_report(bdev, (u8 *)&tmp_status, sizeof(tmp_status),
+				  &eds);
+	if (ret)
+		return 0;
+
+	num_regs = get_unaligned_le16(&tmp_status.regctl);
+	if (!num_regs) {
+		resv->generation = le32_to_cpu(tmp_status.gen);
+		return 0;
+	}
+
+	data_len = sizeof(*status) +
+			num_regs * sizeof(struct nvme_registered_ctrl_ext);
+	data = kzalloc(data_len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = nvme_pr_resv_report(bdev, data, data_len, &eds);
+	if (ret)
+		goto free_data;
+	status = (struct nvme_reservation_status *)data;
+
+	if (num_regs != get_unaligned_le16(&status->regctl)) {
+		kfree(data);
+		goto retry;
+	}
+
+	resv->generation = le32_to_cpu(status->gen);
+	resv->type = block_pr_type(status->rtype);
+
+	for (i = 0; i < num_regs; i++) {
+		if (eds) {
+			if (status->regctl_eds[i].rcsts) {
+				resv->key =
+					le64_to_cpu(status->regctl_eds[i].rkey);
+				break;
+			}
+		} else {
+			if (status->regctl_ds[i].rcsts) {
+				resv->key =
+					le64_to_cpu(status->regctl_ds[i].rkey);
+				break;
+			}
+		}
+	}
+
+free_data:
+	kfree(data);
+	return ret;
+}
+
 const struct pr_ops nvme_pr_ops = {
 	.pr_register	= nvme_pr_register,
 	.pr_reserve	= nvme_pr_reserve,
@@ -2274,6 +2341,7 @@ const struct pr_ops nvme_pr_ops = {
 	.pr_preempt	= nvme_pr_preempt,
 	.pr_clear	= nvme_pr_clear,
 	.pr_read_keys	= nvme_pr_read_keys,
+	.pr_read_reservation = nvme_pr_read_reservation,
 };
 
 #ifdef CONFIG_BLK_SED_OPAL
-- 
2.18.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

