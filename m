Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC3CEC433EF
	for <dm-devel@archiver.kernel.org>; Sun, 17 Jul 2022 22:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658097944;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bTLnbuP8th1RL3oeuXUaWR3yqsPYajh6G7AmrTTmOrY=;
	b=JX24t3RcVQhirAqnlKw/sxsnlowmf5jVJ1A1OQyAjFt/NMCqAiE1W/HcYIhtKeEYvQyLSa
	1C0eOoyQ8AoL8mg44kE77yxCO7VoyccnrwyjfOkSOmgKyjcuDwjbi0E6s9MO1/vXeR+i6e
	s4giKOhDLPWVlkI4KAXKtqUGLz1gcbY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-A-PxnGFRP9S5X0UouRfJVQ-1; Sun, 17 Jul 2022 18:45:43 -0400
X-MC-Unique: A-PxnGFRP9S5X0UouRfJVQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C01EA1C04B7D;
	Sun, 17 Jul 2022 22:45:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 54BDD492C3B;
	Sun, 17 Jul 2022 22:45:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0BFDB1947054;
	Sun, 17 Jul 2022 22:45:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5EF72194704A
 for <dm-devel@listman.corp.redhat.com>; Sun, 17 Jul 2022 22:45:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 39BB01121315; Sun, 17 Jul 2022 22:45:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 347A31121314
 for <dm-devel@redhat.com>; Sun, 17 Jul 2022 22:45:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1387E85A586
 for <dm-devel@redhat.com>; Sun, 17 Jul 2022 22:45:37 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-O4ZetcyiNLmhEkp5G0V9Iw-1; Sun, 17 Jul 2022 18:45:34 -0400
X-MC-Unique: O4ZetcyiNLmhEkp5G0V9Iw-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26H94D3r018487;
 Sun, 17 Jul 2022 22:45:26 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbnvt9uqb-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 17 Jul 2022 22:45:26 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 26HJc6rb004037; Sun, 17 Jul 2022 22:45:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hc1k3bras-5
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 17 Jul 2022 22:45:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4137.namprd10.prod.outlook.com (2603:10b6:5:217::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.19; Sun, 17 Jul 2022 22:45:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5438.023; Sun, 17 Jul 2022
 22:45:18 +0000
From: Mike Christie <michael.christie@oracle.com>
To: dm-devel@redhat.com, snitzer@redhat.com, hch@infradead.org
Date: Sun, 17 Jul 2022 17:45:08 -0500
Message-Id: <20220717224508.10404-5-michael.christie@oracle.com>
In-Reply-To: <20220717224508.10404-1-michael.christie@oracle.com>
References: <20220717224508.10404-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:610:76::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7c1ead1-5d37-4cae-ebbc-08da6846058e
X-MS-TrafficTypeDiagnostic: DM6PR10MB4137:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: B1B4iRfHxQ5C8iT7/EHiPF6qm+JmyCu2qUiL+bxOhDcBjOz6bAJoTCwGcGrDA+QLI72izmn3+RxUXlk9VGLMWLD76U6jhnRTEYeJilAOqKCmRQyQcr1G23mdTLGz2wR5Djr7V2mJG45+VWf0NZjz0EFmaHHLj8ENuLiKglS43xF7LM0oU3QXbvKVluGmtJ2zp9GyBF/zvR91adtlmkwTIURY7vha3erGKgpSER0FTJVEC704D/5vA9C9A1UdIRYOw1v6wXSGRrgocpcG9J6f4yqhjKV7GRV42bNSSagHzmG5O6RBi0YbzdI1kpXzrvloWCyCFB8RFivxvjwWxN3QMRT2wcoLxKaJQr+FDvjep/M1baIXfwJ4eAHNO5MY0W0GH6Bdhhfv9qgvowObg1SdWwdO/Kc2w6LA8CmX5WsIkT3gdNwa8g4nj6pHrD6bG81brRqV1s65thwUsBy9SygBvj7IqlYwxwRleygaVFOjsUFo7L9F9f+WB69yMbfUnCM4HdlF/7tDDv8TvhJk3mOwulq18CD3xVr3RnjM9m/4GW8xqOP5C5XPcv1O7kpHzGZuEvX0UGjPUXCqa7Q2exMjqbaOxyHL/koXkMkuk8+FEJJkbvrGOgPgE+Dg+p8zhY6gpdGTTLKgxUOxMP1ZDZfSAkpnh2RVENnGWIQhBeZVmeX+nncfBW3vX0IAlb0t4O69tCSKTeXcX8p4Y0bDhMU9B0ZdLiFDITr441p3I7kIOl/k2hzMWePhvE+wS4Vmh2FY6jjNLPvL32O1MgRkG3y4onKOf50Tq8U9NvljY4GtUe7+b89vqTiGRISH+RaLbKBp
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(376002)(136003)(346002)(39860400002)(366004)(316002)(36756003)(2616005)(6512007)(38350700002)(26005)(38100700002)(1076003)(107886003)(186003)(83380400001)(6666004)(4326008)(8676002)(66946007)(5660300002)(8936002)(2906002)(41300700001)(52116002)(66476007)(86362001)(6506007)(66556008)(478600001)(6486002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x/prbX02m7i9S16zlP18R12veYXeHUOAKDMvu0s7g/8q7sLb0kqfws/aSwvz?=
 =?us-ascii?Q?h/8/UyiBwJD8i6IdWtCeWIf3FxGyucLSrZ1EEm5I0SNse0lfSMfsMeLzgVJX?=
 =?us-ascii?Q?BQSdbJG6A404zbVhHsazp94yuEE3LwEhKrKLpZCQwzf54KpGSli9a1yTg50v?=
 =?us-ascii?Q?jqG2CBIY8XiXn7toh8eW4gjr1PQaL1vKRymu5o5gvhBNIid2VB2hBwnUVvmd?=
 =?us-ascii?Q?2SI4pTk3mKbna5/OTs0C/+XRSgOVtyeOFLr4sLuKZRJqWC8lu46LF37Cs/ub?=
 =?us-ascii?Q?Cxacaw4R1uImqNJ8KqFbozVftIAGEKzGaEOPKQlwSNqzMc6r56EGAHGqUTMR?=
 =?us-ascii?Q?3vWLBuYcoCLdwDIOsplFYX9y1OYFOk9mz9znKIOngw8t43P6ddz0lkXbom8d?=
 =?us-ascii?Q?/SqZbRVkve+LxLcAJuyKSDdBq0DIq0f8pFjrmvh5oNFNFDG7YAv/12xeUxis?=
 =?us-ascii?Q?mJKrFeYf8GejNT3yfe4EzeZ+Kj+1teEfJL0a2BsQMhsRTADLA4iSufzYNSt6?=
 =?us-ascii?Q?Kz7VQPU/mDQX0dhGoBbMNQ76YCdv8GDWCobiVuvjOa9IB9abRWdQajonzx9V?=
 =?us-ascii?Q?F+dmG4rn6EGcwEuO9PJ+ntdlzSzZTtqwrx8oCHwUQ44t1vvjZaetDjfB3pMl?=
 =?us-ascii?Q?ChERhdgpk2tcPuDF/4yI8B8ewgfFvsoxLrqxSPBa1bFIlY0osB9EPvYgF3Hc?=
 =?us-ascii?Q?XbbbdovmEuJ214BXK4hPFJPWUU/arhW4OoM9pcu/x+5SXSEYglZsEQixtSCo?=
 =?us-ascii?Q?jriYqBOkzA/9LQ6WxUwMo9u4DQTJqvkdgkoNRehUan9zN73AT7AxD8bulpHI?=
 =?us-ascii?Q?aTnVBkRIwwF8P9WEy2fvqiBTk0L9oUdNMIPVk5IUNOoBBWqEkNBFLRHUsTzV?=
 =?us-ascii?Q?K4BaWrWzYLUXqUInn3a3hUnsrwn1AAj3Gk07lO8G/+sOwe21b/TcmxIfSyvM?=
 =?us-ascii?Q?dxllCeOdqOowaef2pCckV7I5l9l2DboaqUxr1art4JYi0rd77VgAhRbsC3K2?=
 =?us-ascii?Q?zNzXrPu0Vqa3dHrdhnvIJBRd7RZneh0NPGar7tvAF8WjLoRaE/ceHgmRt6su?=
 =?us-ascii?Q?jn6Qqn8qHVrlKmRoIgIo4oQ2LNLpmSxNX9XfSbWIIGDhI5M/4mb7KzV0OZv8?=
 =?us-ascii?Q?DcIVOGCV2tjyFzTuKtNxlO5MlOqK/EKdoJjzexGA1fDcDhl7Cmiugdts8dhc?=
 =?us-ascii?Q?pnaJjtR0hIZJ86DF6SEbae/EP63GZGpGmUhIpicGXQvUU8YzOUb/bdt78csI?=
 =?us-ascii?Q?T9SYdSMEg5jmehiT3mbiRsrfkzgLPDNASxRVd6/mtqZIRuPghEgQAPNOMSAF?=
 =?us-ascii?Q?NTrKOdnauHJBJ8GjlM7jSwqJjn8Jfw7O0DKG9izZcjk6kE0YxzxAgNJibC6K?=
 =?us-ascii?Q?rXtflIkT547an6icQvddt16od2YbaAbBr+/g5gvCpJ2dbWkvH6a6vRYvtA+3?=
 =?us-ascii?Q?hiYFzAWUgpAktvaUO8KtHvnfoIL8UZMCVL+lskAw7jfFz32FAx++/RiUP9Sm?=
 =?us-ascii?Q?dH/xhbIt3kagRJkqQa4c5TinmXQ5hMBTqKeap52qBPSOj4TOKIZ8WmaqhYGH?=
 =?us-ascii?Q?ZMZS7copNzst0HwRbHQA41pdCnr67cK2WilhKO4iyYUuQ/xk/EhjeB/lC1xX?=
 =?us-ascii?Q?fw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c1ead1-5d37-4cae-ebbc-08da6846058e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 22:45:17.7692 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c7B6HzpBI1hUjdysCimsYPUaHIWNUN2qJ5sGbB0dHLY8pj8ggUfG5hJRlvNsJXmUk4IOTCpKdq22gnPE5wX5idIMqfvB4mMQTsl28c5nm74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-17_16,2022-07-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207170108
X-Proofpoint-GUID: So18iWCxOpL1PRtRl8m4eIC2_cE4zdgp
X-Proofpoint-ORIG-GUID: So18iWCxOpL1PRtRl8m4eIC2_cE4zdgp
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v2 4/4] dm: Start pr_preempt from the same
 starting path
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

pr_preempt has a similar issue as reserve where for all the reservation
types except the All Registrants ones the preempt can create a
reservation. And a follow up reservation or release needs to go down the
same path the preempt did. This has the pr_preempt work like reserve
and release where we always start from the first path in the first
group.

This patch has been tested with windows failover clustering's validation
test and libiscsi's PGR tests to check for regressions. They both don't
have tests to verify this case, so I tested it manually.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/md/dm.c | 45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c31f99c9d2b2..7f23dde45088 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3046,6 +3046,7 @@ struct dm_pr {
 	u64	old_key;
 	u64	new_key;
 	u32	flags;
+	bool	abort;
 	bool	fail_early;
 	int	ret;
 	enum pr_type type;
@@ -3218,25 +3219,41 @@ static int dm_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 	return pr.ret;
 }
 
+static int __dm_pr_preempt(struct dm_target *ti, struct dm_dev *dev,
+			   sector_t start, sector_t len, void *data)
+{
+	struct dm_pr *pr = data;
+	const struct pr_ops *ops = dev->bdev->bd_disk->fops->pr_ops;
+
+	if (!ops || !ops->pr_preempt) {
+		pr->ret = -EOPNOTSUPP;
+		return -1;
+	}
+
+	pr->ret = ops->pr_preempt(dev->bdev, pr->old_key, pr->new_key, pr->type,
+				  pr->abort);
+	if (!pr->ret)
+		return -1;
+
+	return 0;
+}
+
 static int dm_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 			 enum pr_type type, bool abort)
 {
-	struct mapped_device *md = bdev->bd_disk->private_data;
-	const struct pr_ops *ops;
-	int r, srcu_idx;
+	struct dm_pr pr = {
+		.new_key	= new_key,
+		.old_key	= old_key,
+		.type		= type,
+		.fail_early	= false,
+	};
+	int ret;
 
-	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
-	if (r < 0)
-		goto out;
+	ret = dm_call_pr(bdev, __dm_pr_preempt, &pr);
+	if (ret)
+		return ret;
 
-	ops = bdev->bd_disk->fops->pr_ops;
-	if (ops && ops->pr_preempt)
-		r = ops->pr_preempt(bdev, old_key, new_key, type, abort);
-	else
-		r = -EOPNOTSUPP;
-out:
-	dm_unprepare_ioctl(md, srcu_idx);
-	return r;
+	return pr.ret;
 }
 
 static int dm_pr_clear(struct block_device *bdev, u64 key)
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

