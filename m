Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96CDBC00140
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 00:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660003591;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=I3Vpl9YXfXlh08C+Tkt0//GvcTtad6WT+TpYG0DXZQo=;
	b=C9Yr4Ngg9XzW8ndltCmnJNo8OtiIrRHAj9bMacSbBXCfLkGG/Yr/OcIVTxIztEmyUKua/6
	YFVKWdVnMeyeVRq0V+vxrh3E7CzG96f8M9PS1OxL1dqSjMbkuhC3m8R9fja1tQiaMlWB9q
	aTWG0/SsxAqkm4E858ZgFlIskosRI9M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-Ec8E9lF2PwuHDs9oLnvK0g-1; Mon, 08 Aug 2022 20:06:28 -0400
X-MC-Unique: Ec8E9lF2PwuHDs9oLnvK0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E029380391F;
	Tue,  9 Aug 2022 00:06:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 288479459C;
	Tue,  9 Aug 2022 00:06:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4C5361930E1F;
	Tue,  9 Aug 2022 00:06:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7D1461931A6B
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 00:06:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 599502166B2A; Tue,  9 Aug 2022 00:06:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5532A2166B29
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:06:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 351CF8039A5
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:06:10 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-JUXGkzBIO_2pFgFxsBWmLA-1; Mon, 08 Aug 2022 20:06:08 -0400
X-MC-Unique: JUXGkzBIO_2pFgFxsBWmLA-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NxYXJ000317;
 Tue, 9 Aug 2022 00:04:38 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsew155h6-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:38 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 278M0i97013162; Tue, 9 Aug 2022 00:04:36 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3hu0q2b9kk-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:35 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Date: Mon,  8 Aug 2022 19:04:08 -0500
Message-Id: <20220809000419.10674-10-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR03CA0209.namprd03.prod.outlook.com
 (2603:10b6:610:e4::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1af35c0-77a4-44ec-d3a2-08da799abe2f
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: bmRw3ED0LiOs5/vbwSR+TtTDg7QusfcJLka1fUrZjQwZg1vmppFq8pVILCBlVvO2GH7pD0rqJDSPyfvazIl5ZGJKOsT8BemjyN/rW2FogyaCBmFT5i2GUAy3/cyPRJAnHAi3K6B+9JwCoBwfDVeet7CRjSnkfBMQZHOc8cOs8DcYgSy3aoDXPQ1zZuw2wIhXqdwGfC4VJ58877Gw5L1JKpVzhAWbz8PFl2bXK6hv90MMNQoEIoJSpQ8QZFVXISYhdSrhbmf/kcA9c+Wn9HeTnLMfieieQkqReO+jdg7u/clq7OrGoP6WPXn0aSkGxQ3HgihfSDzyiCNJQisuc/ilBSLf9qdEWJu//HJZAqWMPjjgZOrdnYe0D7WtHJWEPzTazb/sNjeVuOoII2co2k9Lc4Srvv5y3Zrlqb+Bm3BJJ9bhgCcBAe/9cMo6J5n4aNa1YZfu6kc+2VwepISWpLY3Ct8SxoUOv26/5oT9DXBhvi2HSdKoi3ruL/gnqR5oKia4D0SrDpTjW+Y5ucmhNPin+H4v4YeSPCaQ6uII6yOCKwx19JKxr2SxFl3GuX7IIwEROX+Jv47z/5dTSMsmLWQP3WePC9kg10nRGQBHWFB3YtrsV5jansqL2T2Vyl3dXZurPMu1zPPlgAe8eTF4SU3CDclPZr/9A6j244QzLfi6aZUMyEPC0GLhH/AOxJHkukaZHaxdHtqIhBSwGqHhXHP2FnpTU9LxHU76JgmEqFPih6eCUZbVdvxivxoKAp+Jk8+dE4AMzw0Sb3fsCyAfAobLmq3FTiSbGuf7umnS9SDylWE=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?15Oj6XpeIhuRej44OkZxD3bGjMYvBxHiYm19ukKht/oIDRxVqxx7W9h2Wx5Y?=
 =?us-ascii?Q?Lfj1OISVrlnxOPNnN2oIcOH4Ir9BvA0krI0IJvAF6hwGkcxc2rurjN6sH0CP?=
 =?us-ascii?Q?uppoAbL5FGmc3GZivIdxbwqfRUu4zSAedtSYfdrtW0xvgYF5HMDTwlWLNoNw?=
 =?us-ascii?Q?YlyhDrLMH6bOFlii2LlgOR2QNlXW8mAMHDcfz9ViL7gYa68st7KmqRB7QmaK?=
 =?us-ascii?Q?TCxChN7c0LMpx3VKynh4glx0vxqsC5jr27oM8MtPWmyiVZp3WzuX1TxnM16a?=
 =?us-ascii?Q?KFBtnpeDeIYEUbgMRPK9YOPu92TihI0SJ0Zv4MC30R736CeYIkDHJ59DyMGu?=
 =?us-ascii?Q?W7jNZPluCmQaD72Wtoh2Qo4sgBJWy0XqHJ/psxHnp91oWu7F4Yo5/1vKkqVe?=
 =?us-ascii?Q?wiqfldBw5CSP7juEoSIwxRLj2y1TCddajehaw/MwADwL2roJVL1BdA/AyCB/?=
 =?us-ascii?Q?Nwy4SXtdG+eMcZXn3u8UyRWYINfLV654rGA5XMvn1nKBiUM9uvipKys4fSTl?=
 =?us-ascii?Q?50RzgT/BQTfMUfpgRwB7m+rGxl7NwnMS1IQmSmisAHh51ScZikrgcDFu7fsq?=
 =?us-ascii?Q?IYCSE8EyhfmpZyJ60qv8pnGU7wwQDVbmZutd6MbMyrRf61yrx8K3GGx4vLjY?=
 =?us-ascii?Q?9Mgsg+lDGnwwAkIzABgYUAk4EhY79QPCB4kRIPZVpjHtMsAudlitwi1txE3B?=
 =?us-ascii?Q?EGV3r3JW12yWFsE+S4iLruG6W5lnrgokxR+NybOjdCxuNvWj9GTBs8xSJwPn?=
 =?us-ascii?Q?62+omjB+AtxvCGTlQBF+xkAduyiE3l3UoW/ZN/WJYNtIaPPXWQDTEMlhUI/z?=
 =?us-ascii?Q?H18bQWs29qRYp1HwpQa8D2qGtOH0To2gTT4kRzEOUzMhuJX3gmHGKQkgghbp?=
 =?us-ascii?Q?9GwDI7fPkYBjZcYGF+aAUZ0+E4G6Fnfq0MArR26bP4UqguvYhChvl6KZTrON?=
 =?us-ascii?Q?czeQ1HJPUx1wPkL7G6wBfCniwgDfcEJk+M6O8eQSql9HKuDb4rkTTMZwmZRU?=
 =?us-ascii?Q?JHpNnKXKos6xATOIuXue2JftJXp+NDudl/opxCho+m7qYnbsFnsYU7B/yUtp?=
 =?us-ascii?Q?5z0MP1cBcwQovqq58g3PIFhUIO915IO+HFNhT85IQ+V49OXAt1XV0yn6avJ2?=
 =?us-ascii?Q?JovtUNPBfnl/5li3Gs/0sIVnS8J2MC2wNL89sHFwPVboYqnNs+XWDoO5k6Rf?=
 =?us-ascii?Q?FcljpJZz6CiGopW3B+ER31xp24+X84CZsSDb5vTEGIYw5c/lLW7yz1H7nbO5?=
 =?us-ascii?Q?HpQDQzxVZIzZOpSXHZ0PoohpR9NzLvRk42jrRrsrpjbxX+Ry4M7RPs2pbj6A?=
 =?us-ascii?Q?8gkfyLgkWuhjYct1wJuDwNAJmN+hmvAhHKoI+/M3KvHbNKL/JvybUpJWBD5a?=
 =?us-ascii?Q?eFi0f9kFG5UyKEgdh3++9DMvhz4MvcWSHzXGcJk7zJsdRC+ZGNxpzl/YAonl?=
 =?us-ascii?Q?sdH1A1eLdswBzLuFAkPMZp9XFxpbGiWN06BgEY4DA1xA1JjFLtYRlr3AAamz?=
 =?us-ascii?Q?yKcZatHji/vrJ5xtx/cNJ/uCAShKLqpcSwK8vkK2RCBM3CTZRdxBoT6bO57R?=
 =?us-ascii?Q?WTFNlOIwOTjaesmgE/DyOFtGTiEaUQ6J7MX5VOPyfBy2bpgAMyQ4TC8QvkNE?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1af35c0-77a4-44ec-d3a2-08da799abe2f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:35.0326 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXSmkbqGc8ANh4seI4wfza6ZEcOSrVaL/WYImjnx6D72647yYzkR/FlEFQk1leVqTyI4FPxuEiAsI0loV1xHIEjY/+FrjOXlW3nOFdG+MqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: h9vD1FbRq9vWMjTaCa3vo4Tnu9fEzJ1Q
X-Proofpoint-GUID: h9vD1FbRq9vWMjTaCa3vo4Tnu9fEzJ1Q
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH v2 09/20] nvme: Add helper to execute Reservation
 Report
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This adds a helper to execute the Reservation Report. The next patches
will then convert call it and convert that info to read_keys and
read_reservation.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/core.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0dc768ae0c16..6b22a5dec122 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2196,6 +2196,33 @@ static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
 
+static int nvme_pr_resv_report(struct block_device *bdev, u8 *data,
+		u32 data_len, bool *eds)
+{
+	struct nvme_command c = { };
+	int ret;
+
+	c.common.opcode = nvme_cmd_resv_report;
+	c.common.cdw10 = cpu_to_le32(nvme_bytes_to_numd(data_len));
+	c.common.cdw11 = 1;
+	*eds = true;
+
+retry:
+	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
+	    bdev->bd_disk->fops == &nvme_ns_head_ops)
+		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
+	else
+		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
+					      data, data_len);
+	if (ret == NVME_SC_HOST_ID_INCONSIST && c.common.cdw11) {
+		c.common.cdw11 = 0;
+		*eds = false;
+		goto retry;
+	}
+
+	return ret;
+}
+
 const struct pr_ops nvme_pr_ops = {
 	.pr_register	= nvme_pr_register,
 	.pr_reserve	= nvme_pr_reserve,
-- 
2.18.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

