Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93976C00140
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 00:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660006509;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JmM4Wdj0Oe6RfIN3Re5dL8veuLtlxShzXFFOqEyYdeY=;
	b=i/SpgLKRzL8laSynMv8YSivkOvz9+nYMn6nVRRJpHEwygGQeXY3yaObsBtkTzALX7fHDT3
	deJR2L/SMDdmJYgMjxr5CpnXe+Nh7vnbW46g3JlXvOdbpGSTddoEkzvaOzB8STS5tXz2aJ
	lPaTZ23vDsqjzAerRl0XohuHpjng4cI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-COO04EzANZuc3FjC9R7sjg-1; Mon, 08 Aug 2022 20:55:06 -0400
X-MC-Unique: COO04EzANZuc3FjC9R7sjg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 362F71824603;
	Tue,  9 Aug 2022 00:55:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D807B2166B26;
	Tue,  9 Aug 2022 00:55:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ABBE51946A50;
	Tue,  9 Aug 2022 00:55:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D1D2C1946A4F
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 00:55:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B69A51121315; Tue,  9 Aug 2022 00:55:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B1B2F1121314
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:55:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91AB08037B5
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:55:01 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-Obye74lnMUyh7H0c1shzUg-1; Mon, 08 Aug 2022 20:54:59 -0400
X-MC-Unique: Obye74lnMUyh7H0c1shzUg-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NweGG020677;
 Tue, 9 Aug 2022 00:04:37 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsgut53a4-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:36 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 278M0h90013949; Tue, 9 Aug 2022 00:04:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3hser8emfh-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:33 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Date: Mon,  8 Aug 2022 19:04:07 -0500
Message-Id: <20220809000419.10674-9-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR03CA0187.namprd03.prod.outlook.com
 (2603:10b6:610:e4::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d056eec4-709b-45c3-a8c4-08da799abd3c
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 6gK8004ju5ayGXYBsD9z74FRAKm2tYkS2cCC1KEzTn/CkBJ6p7vn9oC77hOEvQ8QgV1H2rzSN8dsuffqn3sHQc1n+RpJlPBRUnmzfFnYknxrDX0p3yW1qeE1S1Njf7is+98yKCzxqLCGQMLuuXMbilhDzy2hF882/LBdKCU3budcLR/dPmdCDXOX6VGJKHB4AyC5bZx4n9VLJ2uMNeh2RPPzFMm67LmwLJJOaigL0buKamImKrM9S7bCTKTuhlurS0NntNRfVRjs4pwuGwa+unmHfnfWxPs6O/gjntqHE2YYfJp8KOhEqPJ6NZR72b8RtuNm/RZQJeGa/WwuV1yLRmNr6rUIsuqxSw2LN5AWLFmhS/j/C0bImSSiNANdhiKAvgBzZAdgr46a0+5vbZh3ryR12pJTKGDVUjLPMgUwe1Tt4wSuAljS7qWgbyBTC2swPbLdDYBmL0SbPhlLfRCMDL1fcsc8/oTXYxSGVG7gt+GkL/gR5cmYlwFcAcxPWlXEdnOo6tAO4GOR3CCzQeG8Xhq051DTgTsOQRBpjFKFkI/z3QEOLZhFeXj1J9iBEkpln4PwfaHRWR6on+o8ji/oCnLXf+oBSMDZ/AKNr2oT1Pz5JgFa7wD6mwS81kxZOHT9iBCFL+8mal681cKHtYPgiyeZlHeQX4tqirqyIF5IXCKQOjWJN/h5gmWxW700M55lxb9ZtCwBmpza4mlaUQA+WaUQGSfGaz26gIxYoH55yPTfuTNe4sGBiHtF/nL98Yf89tuznagcArKI+MUJ3AfaZadVze6UTjWSHyw41m5Jlzc=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Votud9S0PXyelVsKXD4y4LZ7XV1DONTI58JrlOC+/mxEkHpiK5hSZAmhBlDj?=
 =?us-ascii?Q?Hpw/O6+nzFhAXkwpAiH4ERlkQgAClrjDTsgVhpmphr8cdhXZhImT4zVykb2T?=
 =?us-ascii?Q?ZzG1jVp5yeLfJgQQtAm9nFtu91Mq4WCJ3JteRCxl5WarxvNTdO3Qvet0rMLz?=
 =?us-ascii?Q?ZqOG5jYaHBiB4F3hdvcSiWd+9Nr1BO7EyAL4yGfBq5+SaRWUbMgFoMpp4mp8?=
 =?us-ascii?Q?rIRtfCVyjhnKefYsjJfxgicO/R2CkXWcXvZmENRhmSsl9gNflpfF4pscuBzk?=
 =?us-ascii?Q?Rha+NTJMtBnGudBI9ZuxaN9orzNHgo7uOrL/XWM33m9XyzRW9tiSq0lvuQ8u?=
 =?us-ascii?Q?Yx7YDRBn7qKTUZJozwpbcWj/RhlT4J+YAazNwM25Srb1R0K+kbpVTcKN61fH?=
 =?us-ascii?Q?gnta9D/QAHWAOkirNiOnBEmfxCeB3vc3mrYAvy6JUFHwrd2vmNj4FmedacX0?=
 =?us-ascii?Q?yZs5ax++/hMhNLWsJK4cvi3m+dS6zSg5FlsctS/T8J1GFhbinfLjeIqH7uIp?=
 =?us-ascii?Q?18bzEyz9RDEbm3SpzT+8EGoiEiJB6vbvqV1qBduJGVFoR85P/935Ox64a5UH?=
 =?us-ascii?Q?GvF7wj2rV9EUOipI1z67cN8jQupBVOzfP8IoGHHcresFPG3NaFR9fKYW2tKo?=
 =?us-ascii?Q?JgqgG2rsc0+sheBxzJx4yFWSObcvHR6Jg4JiBlmPKGfsGZRQXPLpVV29POG0?=
 =?us-ascii?Q?o9NgfyIHj25+cRVodP46OlxZ86mOQAU3YXGNVLRNzs2XSqunnT+re2bT+Q31?=
 =?us-ascii?Q?3xgUqFIWDUzHhkNFSOAfLnjddi4cMb/i3vdkSQN88TJL2e4QHxZoorpg/iA0?=
 =?us-ascii?Q?LpJJ1ZA0JG2c9n0DyV0wJH3Pei8nKEHORcyOG6+JOaOO0lhZgyN/y+uhsq7r?=
 =?us-ascii?Q?8Rhq0yqqQ68LGqSHe4M0q727u5OZu6Qs2LkDdGHtjq1y8x1lN70BJsuMTD25?=
 =?us-ascii?Q?JJQj/2AVMVzkFVEBd1+EqOggkJrfSueZ9Tl24N4mG1LA9qWrpyYeG8NWLa9q?=
 =?us-ascii?Q?ZoDllb9tIqr1FDX7X5X2WVQvxrz2pYxzrxLx4ci1ti2FnEX1lQxnJepFB94E?=
 =?us-ascii?Q?f33HhwTFqoTTeQIZ7Vkz5XuQKEEpn5I9r+P4kJBbJo7ayUTDamE0M1WRE93W?=
 =?us-ascii?Q?Xb+x3KMRe+Ed3Xf8Tyk0IQcz+7Q+5Z0BLoros6jUPI/nxVScA+56ZliAAFi/?=
 =?us-ascii?Q?afNINVGTIHQoUTaFsxXRY9xGEgq/s/C86j0vLoP9WTtmupDSgm8ckvPdXJqV?=
 =?us-ascii?Q?VhAddElfERII92sTbGCxwPUeVWmwd5GjEoy+i3SBNBigOx0J/fyFoXQx1K7t?=
 =?us-ascii?Q?Pvhruf2nnqodHrxioU0+yv4GcTdfT7yRz9Q0K6CvF569Zm6yt41OmA7XA+vZ?=
 =?us-ascii?Q?48ivxnLy9dkjvLUG7yf5aXF7kvwPqwutro85Ejh8ZEPMeIGVuy8T7jQ1Kn/f?=
 =?us-ascii?Q?W/xFsPRjYMZouFs59dPtXxS6FozK3UaOOIl72kpEUAHflsEJrtEBvewRyucf?=
 =?us-ascii?Q?UwuI9jzBWqfXcUvfKKqy0cp2465YobyRkabjkKG6CatYklohA6vVzeko53Uh?=
 =?us-ascii?Q?EhFYMwjyMPMu2BPHM1aRQWD/UqJ5LY/GCmKMVXmIWvVfWoIddzh0qtRvegI6?=
 =?us-ascii?Q?LA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d056eec4-709b-45c3-a8c4-08da799abd3c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:33.5015 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +hTokK0iXqj83/0h83VxSnTTY7GClIqGHV7X2PXB7CInEaDSRmIXeuXGTReuGixGqxbjstvO+wq8BJFkUzRmTTsdZZKTdzd2TANnxO0Ga6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 bulkscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: GYO9T0WwwwTr_637bGbSW-W4N6RMW1Yd
X-Proofpoint-GUID: GYO9T0WwwwTr_637bGbSW-W4N6RMW1Yd
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v2 08/20] nvme: Add helper to convert to a pr_ops
 PR type
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This adds a helper to go from the NVMe spec PR type value to the block
layer pr_type, so for Reservation Report support we can convert from its
value.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/core.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 3f223641f321..0dc768ae0c16 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2064,6 +2064,26 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 	}
 }
 
+static enum pr_type block_pr_type(u8 nvme_type)
+{
+	switch (nvme_type) {
+	case 1:
+		return PR_WRITE_EXCLUSIVE;
+	case 2:
+		return PR_EXCLUSIVE_ACCESS;
+	case 3:
+		return PR_WRITE_EXCLUSIVE_REG_ONLY;
+	case 4:
+		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
+	case 5:
+		return PR_WRITE_EXCLUSIVE_ALL_REGS;
+	case 6:
+		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
+	default:
+		return 0;
+	}
+}
+
 static char nvme_pr_type(enum pr_type type)
 {
 	switch (type) {
-- 
2.18.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

