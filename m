Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FCC7C43334
	for <dm-devel@archiver.kernel.org>; Sun, 17 Jul 2022 22:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658097952;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lkA1HMu6kPJofQj533+gu1plaYOQvY/l682R6gq4KHs=;
	b=ViXMphrN1T1YpaI4l0V970W1eXZJUhyFDeogajkhUe71m987F8uArULh4UKLPiabiS/Vt6
	lvOVOMO3Y0rAqgX33qdsrxZd9wxswG2wlLa5Kd/E4ujbL6++pBeWQrt2cUDW+t0N62VG/V
	8+Y69TSgPEww552yCtnbNKQt8LYBz3I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-81csthcmMTqWoqDZ2AAJYQ-1; Sun, 17 Jul 2022 18:45:49 -0400
X-MC-Unique: 81csthcmMTqWoqDZ2AAJYQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0D9D185A79C;
	Sun, 17 Jul 2022 22:45:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC6F0492C3B;
	Sun, 17 Jul 2022 22:45:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC5A61947054;
	Sun, 17 Jul 2022 22:45:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1D5841947054
 for <dm-devel@listman.corp.redhat.com>; Sun, 17 Jul 2022 22:45:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 03F8B400DFC9; Sun, 17 Jul 2022 22:45:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F369B40CF8E8
 for <dm-devel@redhat.com>; Sun, 17 Jul 2022 22:45:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D86F91019C8D
 for <dm-devel@redhat.com>; Sun, 17 Jul 2022 22:45:46 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-SY7JnvaUOVal0iWXOpCs6w-1; Sun, 17 Jul 2022 18:45:35 -0400
X-MC-Unique: SY7JnvaUOVal0iWXOpCs6w-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26H94EYv023597;
 Sun, 17 Jul 2022 22:45:25 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbmxs1uvk-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 17 Jul 2022 22:45:25 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 26HJc6rY004037; Sun, 17 Jul 2022 22:45:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hc1k3bras-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 17 Jul 2022 22:45:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4137.namprd10.prod.outlook.com (2603:10b6:5:217::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.19; Sun, 17 Jul 2022 22:45:17 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5438.023; Sun, 17 Jul 2022
 22:45:17 +0000
From: Mike Christie <michael.christie@oracle.com>
To: dm-devel@redhat.com, snitzer@redhat.com, hch@infradead.org
Date: Sun, 17 Jul 2022 17:45:05 -0500
Message-Id: <20220717224508.10404-2-michael.christie@oracle.com>
In-Reply-To: <20220717224508.10404-1-michael.christie@oracle.com>
References: <20220717224508.10404-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:610:76::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5bf14ee-6b92-4ffc-5a83-08da684604d7
X-MS-TrafficTypeDiagnostic: DM6PR10MB4137:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: oC7Y8+3ijJsMPriNV0RhIH5ALPlqHZIe9cUbPc/X4h+IBb3sc7yWB9U1Gaelp6v/4FXTm28QJBZpsAmy5YvGnk5Mw+hzU+FmfA3QWDb0kBhPJH2AyYVqs9xTsPcHDIl61tZKkzr6Ha+lqGGqmTPy0iD/a8b2f7+2pp0dGtePQ1F4+5hsQBolslYkE+EnuqzZwk853qzcAzAEq0pGnrfF67C4kf6pnzkRZC/aMwbQNgc/FnqZWyrf5fXqtfja4eQtR9PIXXyfDQdenZyNtnnAQwOvGVBxi+DviBLidwEuKnRNtLs+XECGSBWMPxi1g8jezDnAzxNpG2/STYPYsRNlfpcMtGgeIlsrT03LiSQogQR8CPXre/NeyOQ/6fKJR9ywm5y1bFhDfiWRg6UZqfZmlY+fXDllMQc3sTh9hwG/5Z1oGZyBN0f1tzwd0adLllD175CEB48MzFQquoR23D5I8mAhDPLWRPFNsdMgDcctH+89X9IPomthT0IQ3Ots3BMIy/Z7L1wf3avHR/3Sjh0ECnCsktqLAzY4yGD1LNUvq6Pim+L8/1sjSSdujPlvIwzTtBA3NAEtlWvZMuyfFDjQSNU9Di2BtxQMCtJkUE0oUKu6Eq/Mkvimq4JDAyLQFlCk4wcxz51camDDHKIrXvxhaSYcomuDGRVfh7yXww36GDcWDp4/8eEMQP/MSpxAIVjJDSthlfMro+v+Sq3XypNNfniOVdOfZAN4JI/oeJv3jc9syw/JbMdixyMDxxAkzroy2AdS2mIKg09Z/2TETBqw5BY2MfV2pz+D2gaCCcaHf3oMC8MkNAMy4+xSyrDmpXWC
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(376002)(136003)(346002)(39860400002)(366004)(316002)(36756003)(2616005)(6512007)(38350700002)(26005)(38100700002)(1076003)(107886003)(186003)(83380400001)(6666004)(4326008)(8676002)(66946007)(5660300002)(8936002)(2906002)(41300700001)(52116002)(66476007)(86362001)(6506007)(66556008)(478600001)(6486002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nIub+Kc6rG1Ljjw4kUCBRsdt3wTtQFUwzrxxNiyeh9/ftE0NLYPB+Mj7bF7F?=
 =?us-ascii?Q?JzEqGKeZGo+ejgTEfOGENtJ99xlR400HirbiiuLGfx2NJbTD3csKxg2VIKBz?=
 =?us-ascii?Q?QqcoRkjIfZAKDxqt3nUG0Ra+4EyLOYoIubUYxtUt4fK7ke65yUrgtVub+CrS?=
 =?us-ascii?Q?mW9v1BKTtZx82Wlb6cw91fDDbIdXYIJ6f8GZw8O3RBtyHhoFRAJCkFDY9ifw?=
 =?us-ascii?Q?PmGXrLwIsW8qF7vGM418rjS2X/J54S+t6mVZPyeRTaOgt+aTqoqkZh8oPVm+?=
 =?us-ascii?Q?hbQQL83+6hrPMLBZIeeKB/61dR58USJ4fOZKDJnH8ozoS9rRLC7G9JLfEH4h?=
 =?us-ascii?Q?B00lJ42JWf10WPgaRWV8MzidM3HnbeadBBuFIRhh9MnYaS1olXUwr8OlYaMI?=
 =?us-ascii?Q?drZ0FPQXMJdiSfzVeuBQ8g/6yND+c4mX+ozm9G4YlMjwiMG1y0+8kGPGGj0b?=
 =?us-ascii?Q?l1/ZJlcf4U7wUipNOCm3Rs647gfxA7+Gf/vioMKjld+0rqlLrDtO7I+VSexJ?=
 =?us-ascii?Q?vkj3acgP75UEoFwV3siT+MGI69DuMGgFtxAlUIbms+MOu7/dshqagEQD/pEW?=
 =?us-ascii?Q?9YCZALsYU1QU39sbsJ21eGpICK7jMJHBNMzYHAp6K/fdIic5FMuha2tfSBJi?=
 =?us-ascii?Q?aG7ZAhY5CyZ+lNiEVU7CCFUAMyWoCNIaZuFyExJoRhffvhfACLPevsV4P7G8?=
 =?us-ascii?Q?43IuEp7XmXsocKydS64xNSMqvIKyaTbQr0gO01JCLEYTWbQYRzVFtleZiDtA?=
 =?us-ascii?Q?wViLhZtGNbqlX6BZUry6ED4gyZjyBbexEQXXo7foncFpIBHg3vCIUJmoe/me?=
 =?us-ascii?Q?M3viIbFUyGzd38u+oIgHfJn/n0L/NYiSkXbpA3I9ZQjgjRkq4oeXDRTeIAGE?=
 =?us-ascii?Q?vdMkD0EL/jLZxIwvLzEC0SCVD/TTNyjgrFMnRB0XDJlLSC5QcO7VnfVscmPu?=
 =?us-ascii?Q?wiv5MjKL6gB815rVdmM+eaiWxMYzh96/abD0dcGIi/6+bCWfjERTSRr2mvHn?=
 =?us-ascii?Q?avL+pK+kb1UvWil2m/g2cWzvSXuNnlGEg75CVPDiCRhrtweyKBJnFxMY4KAm?=
 =?us-ascii?Q?QcCjisizz+mUFAogzeg81Vyyi9V5CEGvWzLp2IZgTfeTIZxQYisVJeqWz+TM?=
 =?us-ascii?Q?b+UB52UCBbou+fjCTFcoGr5WFm00uEW0OukBWcnlhln3zSWItufFuYr4ycUR?=
 =?us-ascii?Q?Kb7KeVoUSbtR7K4wpBwmQwCursd/GQvNZOpc5acsMFbNdWA87iosZNbmSeb7?=
 =?us-ascii?Q?gqdWHs0lt3NKl5sXFBkOzqY2Zp4yX0epKl2XvIm/eD8cVa89zj/MWKAYMcBl?=
 =?us-ascii?Q?SnjkDaMyjmW/fW8quXmrWa/sYRTWGB2H71VE3BxmnI1hbHuB5O9ACHGLgOQj?=
 =?us-ascii?Q?NLCpQkHoyfNSY5KQajsJQjyg2q2c57QH7ZrqKxJgaRRRzhyU4Op6Hk03PRRX?=
 =?us-ascii?Q?VBJg49ocgSc8qCDiynnUT6M3GAr39ujMxXDd+17l7c0qVzUQvq177DCNom1G?=
 =?us-ascii?Q?UnopqQAiaGT76034hsKE2OrwHoiXaWqq0aE7QATmkeL98xMijCVdi4LBtDOh?=
 =?us-ascii?Q?xaTyn53mr6sN9nFM1D5GBM3TkCWSOwJAUBHnFvk5fnmWR7CyZGhlHneHfbJM?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5bf14ee-6b92-4ffc-5a83-08da684604d7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 22:45:16.5974 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KApA8n17+W9Ei1qNLIypzla+GQ3lEfxMyXu8M13Ympr1Fg6JJqyiPIyujqzCYAaABkvaJtwpchoUwmUUglXbZeeCzOGWpzbmu/c/POI6CM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-17_16,2022-07-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0
 mlxlogscore=833 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207170108
X-Proofpoint-GUID: uYqfyh9nuO_HI0c1vLaFrzA-CkF_G-uu
X-Proofpoint-ORIG-GUID: uYqfyh9nuO_HI0c1vLaFrzA-CkF_G-uu
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v2 1/4] dm: Allow dm_call_pr to be used for path
 searches
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The specs state that if you send a reserve down a path that is already
the holder success must be returned and if it goes down a path that
is not the holder reservation conflict must be returned. Windows failover
clustering will send a second reservation and expects that a device
returns success. The problem for multipathing is that for an All
Registrants reservation, we can send the reserve down any path but for all
other reservation types there is one path that is the holder.

To handle this we could add PR state to dm but that can get nasty. Look at
target_core_pr.c for an example of the type things we will have to track.
It will also get more complicated because other initiators can change the
state so we will have to add in async event/sense handling.

This patchset tries to keep dm simple and keep just doing passthrough.
This patch modifies dm_call_pr to be able to find the first usable path
that can execute our pr_op then return. When dm_pr_reserve is converted to
dm_call_pr in the next patch for the normal case we will use the same
path for every reserve.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/md/dm.c | 51 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2b75f1ef7386..67b46ae896b1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3047,10 +3047,11 @@ struct dm_pr {
 	u64	new_key;
 	u32	flags;
 	bool	fail_early;
+	int	ret;
 };
 
 static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
-		      void *data)
+		      struct dm_pr *pr)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
 	struct dm_table *table;
@@ -3070,7 +3071,8 @@ static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
 	if (!ti->type->iterate_devices)
 		goto out;
 
-	ret = ti->type->iterate_devices(ti, fn, data);
+	ti->type->iterate_devices(ti, fn, pr);
+	ret = 0;
 out:
 	dm_put_live_table(md, srcu_idx);
 	return ret;
@@ -3084,10 +3086,24 @@ static int __dm_pr_register(struct dm_target *ti, struct dm_dev *dev,
 {
 	struct dm_pr *pr = data;
 	const struct pr_ops *ops = dev->bdev->bd_disk->fops->pr_ops;
+	int ret;
+
+	if (!ops || !ops->pr_register) {
+		pr->ret = -EOPNOTSUPP;
+		return -1;
+	}
+
+	ret = ops->pr_register(dev->bdev, pr->old_key, pr->new_key, pr->flags);
+	if (!ret)
+		return 0;
+
+	if (!pr->ret)
+		pr->ret = ret;
+
+	if (pr->fail_early)
+		return -1;
 
-	if (!ops || !ops->pr_register)
-		return -EOPNOTSUPP;
-	return ops->pr_register(dev->bdev, pr->old_key, pr->new_key, pr->flags);
+	return 0;
 }
 
 static int dm_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
@@ -3098,19 +3114,28 @@ static int dm_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 		.new_key	= new_key,
 		.flags		= flags,
 		.fail_early	= true,
+		.ret		= 0,
 	};
 	int ret;
 
 	ret = dm_call_pr(bdev, __dm_pr_register, &pr);
-	if (ret && new_key) {
-		/* unregister all paths if we failed to register any path */
-		pr.old_key = new_key;
-		pr.new_key = 0;
-		pr.flags = 0;
-		pr.fail_early = false;
-		dm_call_pr(bdev, __dm_pr_register, &pr);
-	}
+	if (ret)
+		/* Didn't even get to register a path */
+		return ret;
+
+	if (!pr.ret)
+		return 0;
+	ret = pr.ret;
+
+	if (!new_key)
+		return ret;
 
+	/* unregister all paths if we failed to register any path */
+	pr.old_key = new_key;
+	pr.new_key = 0;
+	pr.flags = 0;
+	pr.fail_early = false;
+	dm_call_pr(bdev, __dm_pr_register, &pr);
 	return ret;
 }
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

