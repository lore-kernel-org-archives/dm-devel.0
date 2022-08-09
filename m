Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0810C28B2B
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 00:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660003499;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Nl01s08NRxTqBBZVtTm7HvQY3uHCfnygWHCK4NuLC4E=;
	b=RLPm6t3WYfFdlwO2zR0girMlwbvL67tIlo3GJ6li4Kwlq08yttP8taDb/qj8ZmjFygn3i0
	UVCXB1N1eY3oIxVj2YZM4A/juI2UoJhca36l5o/CyazJcf5PtXsqAnaH1+5ccLmN8Ykt0H
	R2Nv6mNoORyCXrq0e2ZM5j0Iaq0GEGM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-PnN9bzJLOnG8y7-dsf6oJw-1; Mon, 08 Aug 2022 20:04:56 -0400
X-MC-Unique: PnN9bzJLOnG8y7-dsf6oJw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B9C0801585;
	Tue,  9 Aug 2022 00:04:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 49C622026D4C;
	Tue,  9 Aug 2022 00:04:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 387441946A5A;
	Tue,  9 Aug 2022 00:04:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DBE781946A5A
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 00:04:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C19CB1415128; Tue,  9 Aug 2022 00:04:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BCF2A1415124
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:04:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71CD11C05B02
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:04:51 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-QsYjBY4vNFK31ppv3Q9n4g-1; Mon, 08 Aug 2022 20:04:49 -0400
X-MC-Unique: QsYjBY4vNFK31ppv3Q9n4g-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NweGF020677;
 Tue, 9 Aug 2022 00:04:34 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsgut53a1-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:34 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 278M0h7n011564; Tue, 9 Aug 2022 00:04:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hser26u66-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:31 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Date: Mon,  8 Aug 2022 19:04:06 -0500
Message-Id: <20220809000419.10674-8-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:610:e4::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f5e2cf6-692e-4914-946a-08da799abc1e
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: FPNjE1eVnZaAauowI7QaXchWa14QA5JrnBwEWBq0R47tO5yvZf5RKcKcseGnbjMZhJDm4/BacuH6M7M9pSrKVg3STJ44GWoRO4Wgw15Nzt34k8z+qtfguJtwEISoJZundwmyE7AntbMTfeEftMFg/ajn5g/pb4zvQjb758bWabhDOHMZeKooDTiX0L5Cw7poW5tBf0iR8avgeEvVVe6QNt2Q1+GHZXj6K5XGLuIzibKU47UVKhM5chEjFXUIsGy2YwZYIifrGCc2JYS0RPTixP5iCRMtzDJfbIMYVfs4TRXzLM9D9/I6PVxCecqNZNqTWG0weDKucmx8YDR/LR3rQ8fyaOYQ12MXfHtTfSiecJniC6HsuYX/8uVz0zUKX9Afxy4auuX9WCjAWUPkjadUN3dlLsmpHt2Y6yNpXFNpLPkW640Sjq+wcDCJv/kc+9FOSm8c+WqwXwXOGjJmYcnjrNrGKWc9siDQHk2U69VKRtdQbhZVmkK6T11feFewjMCqmEOecKNfbdr7TPWSh+11jRAmkLQk0eTEOY2hRI+g4+hmXiC5bmkv+gfI52Xj5oMoT9bBblohg1OFQ1hrjfKTaDOJJ6jSaG4F6N3hUgs1iQhSuirnNM9Hsn0NUNJh+kZXWFjhBX44ZAKRq01DrPj+cwg7qwvg8kPw/xIW3JpwVgw0VEbxY8HP4fdF178fpNdvX8w22Uq2ABkOUHRQC9kDllXxixI6K1R2F/hYkLzQvOw2jDA8TCZ3/dr4bumqM27euBAlInvb+69Q73opvK1O62C/G5zcSA3jEVEvau4tsok=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Bvu9/4+f85oUOCkUtotIBbP2HqYgss2MZR+1vdG6TmvLySZM7+ndqy+DeGL?=
 =?us-ascii?Q?6T9Nmr3WBIhcWhnhASPjH8IzIJ6eTeFwQnDpeIr+YfHFGnsjRpLL2+eDvOKe?=
 =?us-ascii?Q?gAoAYr8a5PCgdvvWXwaaGORWfp7H42m8G721ofzX0z7O1NKMAUPCeglHb4mG?=
 =?us-ascii?Q?2CKHs+6e8DMWAVQmulnQdcESGnwZ2VCpB3tZYe9s+wZpqs1zVtn+ymPTVvSC?=
 =?us-ascii?Q?+Gbwc7tvnVQ3JksVXs8uHutL/8XOv26qOnvPyH0+NHuqjkLEV+3M7QtAmyHm?=
 =?us-ascii?Q?nUmMUyGbb6vCWSH1XZi1/dqWv0Say3pwHD89rYvZ6WnGigo7wANis7kkJqyF?=
 =?us-ascii?Q?aKUdAly3VYucuMAG7vMGG8XfoY2Ewr1n4Xw5cDCFwSpfEIBG264vbWPHWvID?=
 =?us-ascii?Q?JTulos4yd5YfRTKNA4hG9wOCMHeZrn2kzkWmiqtSx4Wlj9SbKN39apBuGafu?=
 =?us-ascii?Q?U2RZG7uw+2foPDymtJG3G7LX5zmHfE17ATnHGnR9Axq4oqLTFAr02dHSgMIk?=
 =?us-ascii?Q?2DpdxIc1CU6qB8Z98EjLT8T3BTxFmBHjKwvGpUzpMixxXQiDga3k5Hf92jvm?=
 =?us-ascii?Q?GZCo3PVlIKpheZKMjJAe9iWXZEfgyMBftdVCvroIAlExH+sfQfAwBBiHIqJS?=
 =?us-ascii?Q?Tgl8ihiNBBmQFgjPlah0pXsLKnpzitNxdOUNKnUcLnf7EX+0ntLkIcA3R1ju?=
 =?us-ascii?Q?8vF9jLxZppeS6UNKdb0aZRrK0xoDMfIhILq1iMolzbQsl6r4iAtq66nzdrBH?=
 =?us-ascii?Q?F6gzSYf5ht8zXmCZ/jLEsDwkQnrddaqwl5LOoR1/cmCnBytyESGMp9XWlt4x?=
 =?us-ascii?Q?dJxk8e2VakEQ91TWB/llqbtvXewwOb7Brf54Qr2Ygf7yBwvTPe8w53Cqp+9x?=
 =?us-ascii?Q?okSoUfX3nmgcTpHhWQ0tK7toUMK6/hszjh/AJgEFZxgvWCuo+n1QhjdZ1S25?=
 =?us-ascii?Q?bZ6Q/PBlLD4IzcPj5I/4rfhF2KXvMVC3wzXnzbswh6RlbYRnJGKiIM5ibRca?=
 =?us-ascii?Q?xYO4aJsamG1Z2yA4ED1eQXlm/TE5bii98a0/2SElRm+uwyRaWYxeGWh0sfnW?=
 =?us-ascii?Q?YnustDYdezUSy5CvEZTouzMvg9iI5f6SOc15Q59iz8a8CuqVHDKG5fPiMPKo?=
 =?us-ascii?Q?oc2o79w68RbbD8DW6DXrQr6p6uB0/bQo41C5LT5cBf/e1xKdtGlFoyFGpy/Z?=
 =?us-ascii?Q?SVYLLHYSnmBYCSfs+gbCrXEVZnUQ8LRKdcPsxqPMAQ19bhgB4dIW7XH7HQOU?=
 =?us-ascii?Q?UJ6qkWdVlqBWQYpiQeYLwwSwl8wUN4SdbALfsLLKZap3BRyoxUf2srlR8pxC?=
 =?us-ascii?Q?adeGasjdena3PM23fEZOanInUGnrn53aTEY1kuCWTPvgjZQf+h5hXBnUDxTk?=
 =?us-ascii?Q?rb0+9N+stUNtBsoa6WOUcBNHLIqMXhv59pbt4eM0Uukba3k4bWpAV5kIwEX4?=
 =?us-ascii?Q?hVlpoUsdRfyCVh2wTVr1B78OUVxjJCBh/FH5SxFgVkmr1ct61qHgzbChFzID?=
 =?us-ascii?Q?iG6aav7BngjFW50k1t/od0IXedlO4zqJ0DP6H7bXJQdLRX73cLaZ2VadUC7r?=
 =?us-ascii?Q?vZesgmC3UMmqrtlnQY97tSEkg37wQ2vR5yzG7pSOpn0YKOnpGqKBm7LHyhhv?=
 =?us-ascii?Q?4Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f5e2cf6-692e-4914-946a-08da799abc1e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:31.5797 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kMvn1ZkNBdm86LzEP/vwfPucUgJhhwP6vlOqQ+8F+PJR9cbclFW+GWLSk98IZpqWgGdYvpuuWI+2w7fN6vOJ5Md0YCywWMVMeHTAs5yFJB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: jJcrh_hnpl-ld1fjQ_QgDWpEF08LTI07
X-Proofpoint-GUID: jJcrh_hnpl-ld1fjQ_QgDWpEF08LTI07
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v2 07/20] nvme: Don't hardcode the data len for
 pr commands.
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

Reservation Report support needs to pass in a variable sized buffer, so
this patch has the pr command helpers take a data length argument.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index af367b22871b..3f223641f321 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2085,7 +2085,7 @@ static char nvme_pr_type(enum pr_type type)
 }
 
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
-		struct nvme_command *c, u8 data[16])
+		struct nvme_command *c, u8 *data, unsigned int data_len)
 {
 	struct nvme_ns_head *head = bdev->bd_disk->private_data;
 	int srcu_idx = srcu_read_lock(&head->srcu);
@@ -2094,17 +2094,17 @@ static int nvme_send_ns_head_pr_command(struct block_device *bdev,
 
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
@@ -2121,8 +2121,10 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 
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
2.18.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

