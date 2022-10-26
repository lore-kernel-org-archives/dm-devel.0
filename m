Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F28FA3746
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198335;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uqH4+LynvX/a7BBDYTGSTw0k2+L7JgVzp+LFWtDmB+g=;
	b=WhR8Z9KFekBsNkV7Qcfbh9HfteAngsKimUjh/3cU9GKzg8Udi9mlYIGvwOxFV5MkC03CQ3
	bUCv70o3hig+1040L3VWWKO2h95ausXmkSpAfqjdO3Li1ZzOAzJ0Uk7j/NLLx7hs2hTykv
	xs9a4pMoaCAM6L7W8Zvk1Q1053I5DkQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-crMHYWGuNGKt_fUvFZKKQQ-1; Mon, 31 Oct 2022 02:38:52 -0400
X-MC-Unique: crMHYWGuNGKt_fUvFZKKQQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F7133C0F809;
	Mon, 31 Oct 2022 06:38:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 79F412166B2A;
	Mon, 31 Oct 2022 06:38:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6323919465B3;
	Mon, 31 Oct 2022 06:38:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 01B381946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Oct 2022 23:22:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E84B84B3FC7; Wed, 26 Oct 2022 23:22:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DFD344B3FC6
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD914185A7AE
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:19 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-02IRAhk3NuivRGhar2MoSw-1; Wed, 26 Oct 2022 19:22:18 -0400
X-MC-Unique: 02IRAhk3NuivRGhar2MoSw-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM3G34014699;
 Wed, 26 Oct 2022 23:20:02 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfays0jf4-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:20:01 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29QMAWiq006963; Wed, 26 Oct 2022 23:20:00 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kfaggdrhk-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:20:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:19:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:19:58 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Wed, 26 Oct 2022 18:19:33 -0500
Message-Id: <20221026231945.6609-8-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH2PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:610:4c::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: ac7b48d3-911e-4b2d-e111-08dab7a899b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: wR/wL35yvET7sImlglaHcYF+xepVsePAfGhMqTLKZkurJmueinr/0jp16ben4FeuTf8xZIeH4ETLtZEE1aU9S6wm4J9eAoJoq/Lk2aad1KUIu6pwvc6Nf9xsdaVZCx8HesN8o1JfOMCjZv0Vcf0ASvuUg4u26ZyuAiWYwpWT1U/RAPiLT0Jx8T4tm8V4DoJWtETsF1SEffJWg0/bLHljCFDEEM375H2CTo9IWrhY6SNbRtk4HxKPELPIkzLsMlxyp5uoA00z8w39gK34Gp8QDNyycErSA0rhOGafS90+i2uUj/nwywwaEUWZSsUp40OkTR7qxh3DIRcBzWOwBxIyZkhz2+hhMA9QVoHBIG1hKoWhqvjyBtNdfd+HO4pPERhvsOE44leeWNRGl2DDx7bZLlWgcGD86XcDRx9xRMHJS3KqpFd1SJvixdvHndlkky/0YyHjHH6NklhfE5f5khiLYrUXRxkAWr5/R8PeSD1BB2h3ieTgeIxVoiTYS8yt1OO/7ojwXpY60MFMOw3z1EB2Pib4eIX1aaujGDdykf3w1giCzJ4bpRwhAhnXHN24yiALbi3Hv6FSPQ1immVG+qI+Q4I3XfmRzzRA8ejDxxD+OWczTf3K+7FT8GNTT3rbxbW5gq329NasD0PzTkhBrA63OfVu/+ylEJjo4l4Wgw9oU9alxcQZa3/u/jRLBvF6vaNlK8/jFhgnYMIaCuO4ImxtRlQqITPlQKWLt9YDvkTLRz+IX2CslKck3Geda+itlpdB
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3hmrusyB1qR1CM8R17et/gmlzxxTursY0sgMexAarS/BvQ8BnFbg9mXRbO2o?=
 =?us-ascii?Q?Fj6ulwZl/GgjAUFtMMNZKkcdESxy0a58zvXRycZmI1lD14obFiFZi3eCliee?=
 =?us-ascii?Q?yR9VuaqB5uQNf01dLDwAodYTgqg0c8rTzjRmA9P9uqGRvS6+UwrKdfBTlSP6?=
 =?us-ascii?Q?u+3MshHjHLH4CRYaSov5lHaL7wsm1eWzigX4y1dhHnDTVtkWpcAz5+QHdJZg?=
 =?us-ascii?Q?qLRxEKtLnoPF3TiIKA/PxJsbyqJyX4T3n5opeB2tMphE0d25kHWHGNnvTfFN?=
 =?us-ascii?Q?986hszVZDvz6jT79jPXurxKyqTXddKkNiWEzKZvjUUqPjXX2ftcmeS87w07T?=
 =?us-ascii?Q?N22J7r0QgzhnVK2FR59PuVZbeqGwHfMRqaVsMt87GyeHUX6ciJdeFwbWbWNT?=
 =?us-ascii?Q?kR4TPhkkpsmkNpZ9QBpwbNL0Ywkh3OOgZsJKivV1wqAUdesdC/tpo69P3Zzr?=
 =?us-ascii?Q?HrcJsSTLHjVMryaDIr1RP80ZVPn0Xq+pKpuAPBgnL0NqzJnycyisFvjkcuRq?=
 =?us-ascii?Q?prOZQGjLgjyCEd9JQ3rBXg5T+No69grBJxBJ8/CHtOab2o2LvEkSPwwdJrOk?=
 =?us-ascii?Q?cqVjRtHerCS15Iv9hv3srOgm1BChJlidE5fJ4c8ex/lm3s8++ttsimt8g9hY?=
 =?us-ascii?Q?Q1wZupmqkG1Dvj03sQjFQ/5VmAb5KYjrsZc0atxrWy6LzSrm3EcSp0Vm4x/5?=
 =?us-ascii?Q?dJK91pLkakpTY24XZASRvYiDJi7weMncAE4e4OqR/UZiPTzNgXKMyzS4mDJ8?=
 =?us-ascii?Q?BD2fUIL9oB806A0m8kx1KkRxTlBKf6ObAGg1J4N8t4vFSZobWIqpGqEqVBu/?=
 =?us-ascii?Q?S41QU6Z8hv7la1SavGbITz45DlF95sGTXf4GpkUREmcdAPXYjR6a4wRyFEsp?=
 =?us-ascii?Q?YIXMwl80F7w/7YvbqmpYYmCp1f/sMBA90cM0RMIr6pO3Um0wQ6f3WLvubEWS?=
 =?us-ascii?Q?XP/VtVNLPY6gaHyL/NDmS9iljRLYofLlr03msdGNlQE9QqNdY3I/4QQTxUSp?=
 =?us-ascii?Q?Dr5eFFqOzXXgmNvbqHKaz5PRQkzSc+ODot7A5GU3kPo9ULP+/2Eq57wU1o2C?=
 =?us-ascii?Q?N7I8dvtw+nxlJnn28bOwYSnJfFffdgTi4Sk5WWUOCwPGKyN3DMW3lmzK4RPr?=
 =?us-ascii?Q?DDMaobR4CzbGW9Zmen3MgfCoe+qKLF+N2wR2zGctMwDc6hA62xLN/M/kDWvh?=
 =?us-ascii?Q?iewVHf/Eq3W5Ibe3/W80cWK+9nD05zwA9zRv2VyjO6kJ42zuq2e0EdD2OThq?=
 =?us-ascii?Q?EYg9ijaQoVa7CgN8+f6JNVPFOMhBgAEH/nHZgpG/0N0cRf1TPuy0pn4IGbph?=
 =?us-ascii?Q?gwKFA6neRp9LLWSsfQ2KdLt9829xZoe4Ym90WeA/HY83PvvHqC2KSfLeQFPf?=
 =?us-ascii?Q?Lp9al3tFeDZyzvYcgiYT5pCLPnxydII+IhnNboCBB7gTFAdX+4yhKMQxy/qz?=
 =?us-ascii?Q?qnsRyNgA68Rb/fqxfz7wjaIHampS5IcJJeJeKYakXu8QqBY8GM8h9BibC9Mw?=
 =?us-ascii?Q?+EFDRPnbTPLAslKF+Ae7w+jEgGngb2AqL/w+KzBkgiHryKil+sH9McDOR2/z?=
 =?us-ascii?Q?aFperdIZ/djcDCpZEKo4JfchcQH48C0bVQj+By7FlqHof+NKbU6loxhCP1iU?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac7b48d3-911e-4b2d-e111-08dab7a899b5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:19:58.8975 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wV10Kt6pKBl7ioIw+6x0O29bHUnenMWAlUK+JQcxZExMOwMsfWObGx24Qu1+8aoRFZuREzqRkmiSmw0KFZn8GodA8vTuhxoj7pXrk5TXrss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-ORIG-GUID: k-a1PlwRVuJp795pHmAp65pfy9emQpoI
X-Proofpoint-GUID: k-a1PlwRVuJp795pHmAp65pfy9emQpoI
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: [dm-devel] [PATCH v3 07/19] nvme: Don't hardcode the data len for
 pr commands
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Reservation Report support needs to pass in a variable sized buffer, so
this patch has the pr command helpers take a data length argument.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index dc4220600585..a79fa710d012 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2082,7 +2082,7 @@ static char nvme_pr_type(enum pr_type type)
 }
 
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
-		struct nvme_command *c, u8 data[16])
+		struct nvme_command *c, u8 *data, unsigned int data_len)
 {
 	struct nvme_ns_head *head = bdev->bd_disk->private_data;
 	int srcu_idx = srcu_read_lock(&head->srcu);
@@ -2091,17 +2091,17 @@ static int nvme_send_ns_head_pr_command(struct block_device *bdev,
 
 	if (ns) {
 		c->common.nsid = cpu_to_le32(ns->head->ns_id);
-		ret = nvme_submit_sync_cmd(ns->queue, c, data, 16);
+		ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
 	}
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
 	
 static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
-		u8 data[16])
+		u8 *data, unsigned int data_len)
 {
 	c->common.nsid = cpu_to_le32(ns->head->ns_id);
-	return nvme_submit_sync_cmd(ns->queue, c, data, 16);
+	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
 }
 
 static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
@@ -2118,8 +2118,10 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 
 	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
 	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		return nvme_send_ns_head_pr_command(bdev, &c, data);
-	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c, data);
+		return nvme_send_ns_head_pr_command(bdev, &c, data,
+						    sizeof(data));
+	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c, data,
+				       sizeof(data));
 }
 
 static int nvme_pr_register(struct block_device *bdev, u64 old,
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

