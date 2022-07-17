Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F139AC43334
	for <dm-devel@archiver.kernel.org>; Sun, 17 Jul 2022 22:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658097947;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rqSNQcaKcqs/zhDyx18bA0Xphwo18LG4y5d/wwEMgZ8=;
	b=XqwqPAr3lLvO4qPAQ0nUfSRe4FbIpGykIzqL1crUoDUk91BGkyvrm6LYC4/AK8fuJHwjMT
	EOXvCyWKj4CWBdwU89E3jU+JDlNDraHoARZfsAoDp9F4YADcwmpwPRIk28Ye/K+aOYug/j
	qf7/2fU6GX5wFthf4rKXVxw+OqhqomY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-_jHJH2qUOpmELqqjlLeUuA-1; Sun, 17 Jul 2022 18:45:43 -0400
X-MC-Unique: _jHJH2qUOpmELqqjlLeUuA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEEDC1019DE1;
	Sun, 17 Jul 2022 22:45:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E3A38492CA2;
	Sun, 17 Jul 2022 22:45:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BA05B194704E;
	Sun, 17 Jul 2022 22:45:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 03ED6194704A
 for <dm-devel@listman.corp.redhat.com>; Sun, 17 Jul 2022 22:45:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EBB532026D64; Sun, 17 Jul 2022 22:45:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E6A2A2027EB4
 for <dm-devel@redhat.com>; Sun, 17 Jul 2022 22:45:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C481C801755
 for <dm-devel@redhat.com>; Sun, 17 Jul 2022 22:45:38 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-h1kfqEVyNY6KJs1xvChpiA-1; Sun, 17 Jul 2022 18:45:36 -0400
X-MC-Unique: h1kfqEVyNY6KJs1xvChpiA-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26H94FbI018603;
 Sun, 17 Jul 2022 22:45:25 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbnvt9uqa-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 17 Jul 2022 22:45:25 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 26HJc6rZ004037; Sun, 17 Jul 2022 22:45:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hc1k3bras-3
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
Date: Sun, 17 Jul 2022 17:45:06 -0500
Message-Id: <20220717224508.10404-3-michael.christie@oracle.com>
In-Reply-To: <20220717224508.10404-1-michael.christie@oracle.com>
References: <20220717224508.10404-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:610:76::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf142fde-6385-4195-91c2-08da68460510
X-MS-TrafficTypeDiagnostic: DM6PR10MB4137:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 2h0Z/DakWjwTyz2txH6aWyJEPda7bBUIlwEfC9vpOTqyJ04OCH3hBIc2pvIOwDERMkAuINSM+bs1iA1t5/o7tQDuZR7VXRlVZmEcCHVgNB0HIv5lB55C0i05OCeiq32bMOFUcb0f4SRv7abPA70fndyINS65kPSXIK8Pb7zE/nHmcdSmImntV0DlC4b02JSF2b3z+q6Wv+6fJq7qLBYuVPFQ5swEJMnwM3sDr+sr1PA0mZCcRGQMMDsoGN3/JarvxxIdB8EEmW6F+7LkyA/ArH4I2c72euwEXTLui2hpFpLuNJ6ua7i43ftB05tVcxZVRIaLuVijWZIf0kevYBoRZjwxycVf6q41NoUZ0BrUMImJy3nIMff+rSuffmwZxl1bcjqTTRsaWU1XcGF/r3Jsv57Mce6Y3TcqxzOJqYxwYTvEGEETj2q5xcSqqcZjZogoliRsv/c0rKiBn/MI055YVq1gOm+bjAa9COvmC06gjSbUnZJs6geXXtHjGNk0yD2BqNbzvQf9DbzESyGp797Vve/kgk9uAJxndSM+24OMDlAW8bLDygReUiK5PPuB23J85Liv+PFP/Xv7BnYJzdVyUfM8BhW3WPUOuKzOkMv8nAkZ2jmdrIfRY2kI4+rV/k14t6MZkhdhDu07+w62udGEUgxkzGbHyzzPnRvOcYWffPvMaxNBZ66+s4zZFH9hd5bWagfySnZ0/kCNyFPFuU7dGW5mBvUNKCBPOaokPy4Y4qB6Xm5umA71cQ4AkmKItNVCaoY88HLhS7Em2tz3433ne/km556c3PtZaD8YrTHno6PdOrf9t4R+pmw2m/YXhJiH
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(376002)(136003)(346002)(39860400002)(366004)(316002)(36756003)(2616005)(6512007)(38350700002)(26005)(38100700002)(1076003)(107886003)(186003)(83380400001)(6666004)(4326008)(8676002)(66946007)(5660300002)(8936002)(2906002)(41300700001)(52116002)(66476007)(86362001)(6506007)(66556008)(478600001)(6486002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DPnn0cd90YnRe658vHRDVOm2tJeKAdAFMuICenNOdIYc5ioP6eJ5F0f9SCzq?=
 =?us-ascii?Q?/0mFX3fFwMzRfm1d/LPEmKerRTChhyhLEIfy3ONWT9E6CKRr8KeK4pbon1rO?=
 =?us-ascii?Q?tWqejwblCn80wt9lWSTtpy08e088YNxpWy3Dv0W30B72r+DRR4JyPM7giMe7?=
 =?us-ascii?Q?dVrDb/Xu0KA6NrT3zgDPQHNm2pTasn6QiIOgK9yq2pxmL1wob3HeQWCFlfli?=
 =?us-ascii?Q?5uFaqx8R7p0yWkExdqZDaCyGedSI/zMbQ3ffTEVAQ1Z52+L+3INnxbZKqmlt?=
 =?us-ascii?Q?FpO+6ixp7og63j8JUdMLsta1rtWGZ9BEYwYR9YcOcN5Vw05GFQWZ3iBq+RcE?=
 =?us-ascii?Q?kQXU1mFCx/ouGpRLxkGayKQ2DF8S56o6jA+x50wNI2OXiXyGxoVSfvlK6IGD?=
 =?us-ascii?Q?deOXlpB9kU1BlNEjlniHLSIBr5T43ObuzXrn003pzoJfuq6PMV0mi35aqIPX?=
 =?us-ascii?Q?vySRWvOoAJX7ws3aXr3mgXhh7BB6P5Ffz/ZvmZI8ztAQMBCXQxuUyYbe6IZw?=
 =?us-ascii?Q?IcytDjpnfcmShA7oL8jkKUIE1S5wZbVp9pAmzeinF8mM2oFw9AuRAxxpY++B?=
 =?us-ascii?Q?ElHkjsyhON0AyRAVdrW/hR14QENSsj5fSlyedSJe7Zj3YzYE6n5FmznKzJ3x?=
 =?us-ascii?Q?8u5RRsZ+lA1kF23ZH1ATRgcoJAuubaxCOrQokB1mG+ITDpvtNOJI+u4a5o+t?=
 =?us-ascii?Q?MR+a1M47V+sMT9Ovuxfx2ekPvu6Su2U0frI7B7UCF3kagLEE23SrUkrAw40n?=
 =?us-ascii?Q?jRosRkp6rxbKi8UhSXCTiANgKVlN+0pXjwQ9zDrMD1ISuZBeRVEjh+6q3jJN?=
 =?us-ascii?Q?5aKxuOHICZ4bDd1VIJ0dXR0QDbk+B1Y/NL765fR+0hltQiHuHjhdiu6KGfYZ?=
 =?us-ascii?Q?/bkQfC8k6r/D/R4tKFLb4iFz3ioqonI1oxJ0LRN6ADs3Iczrhtn/mjBKCrHi?=
 =?us-ascii?Q?JSnlpYwRnrmusAinGu+9aRp0k0qRSfnW+oTKbCgPKFHD6vSgtuCVC6hz4AFk?=
 =?us-ascii?Q?A2n/oZPyPa6cR/kLWqdb7gM3vZdoIIaa2Z6rEnJVDbQYKmtICO63ovjOb8/U?=
 =?us-ascii?Q?ntUxpAc48fXwc7l2Is2LZDx/0iWxLn7bpR6sCyksbO4PmANStFyJwV/3M0A2?=
 =?us-ascii?Q?eD1pIDaVmzIE8UhRqDj8NYV7wpi4Lo+RdrEUduWOJ6it7x/pk0BEFaDk5eVv?=
 =?us-ascii?Q?fAhJhc+1/+Npf7DEFaohrkYG7iTRomJEJyB2MJiVhxnIoxAT/6KfevU1z8yT?=
 =?us-ascii?Q?l/GhRBdKzkfJzYaY2x55MqZm5J8iv2PTkR4yZxCu1bJvzPLdfHVkWOuHE71v?=
 =?us-ascii?Q?a7VOT2xSDwHmc3ozAwRFPp8QPjFLL8c2S9bNuKSSrGs26XvWnWO/PqIIqiwe?=
 =?us-ascii?Q?9jjvfJ9VJTWI8nmhKecjQf9s0/RfZmbXuaU8IFyLWLugYRGOU1/2KHVyUzB5?=
 =?us-ascii?Q?bn7HCy2PwfktxOWO/MBbZx+atyc0ZSyGyZ5Ve7sEHuU6A67W2ZNi4it0C/uv?=
 =?us-ascii?Q?bZh2y2g0J3BubtjvvV27uWLUsMTfcSi6jSE4XpF3KdpAxyrRQw8u6cu1udWj?=
 =?us-ascii?Q?1eMY3486fBhgrj3mMb98YLxKHO14mpU+DW3qZ1F//+ZDjVYu6a/MmerfQUIq?=
 =?us-ascii?Q?eg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf142fde-6385-4195-91c2-08da68460510
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 22:45:17.0036 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ym8VwButm/oogbz36eCyPgrJZfsEeN7JpUpoze2y+wUbDkCMm+WVTgmf+78rT8LQohEaJexib6WPcSSNHNFqNS3Hgzhj2aFcL6hyCMWSkso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-17_16,2022-07-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207170108
X-Proofpoint-GUID: 8TYh8rk0NGntQmw3EjgMvNGrvGBU_hr0
X-Proofpoint-ORIG-GUID: 8TYh8rk0NGntQmw3EjgMvNGrvGBU_hr0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH v2 2/4] dm: Start pr_reserve from the same
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When an app does a pr_reserve it will go to whatever path we happen to
be using at the time. This can result in errors where the app does a
second pr_reserve call and expects success but gets a failure becuase
the reserve is not done on the holder's path. This patch has us always
start trying to do reserves from the first path in the first group.

Windows failover clustering will produce the type of pattern above. With
this patch, we will now pass its validation test for this case.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/md/dm.c | 46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 67b46ae896b1..cdd1656b99d6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3048,6 +3048,7 @@ struct dm_pr {
 	u32	flags;
 	bool	fail_early;
 	int	ret;
+	enum pr_type type;
 };
 
 static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
@@ -3139,25 +3140,42 @@ static int dm_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 	return ret;
 }
 
+
+static int __dm_pr_reserve(struct dm_target *ti, struct dm_dev *dev,
+			   sector_t start, sector_t len, void *data)
+{
+	struct dm_pr *pr = data;
+	const struct pr_ops *ops = dev->bdev->bd_disk->fops->pr_ops;
+
+	if (!ops || !ops->pr_reserve) {
+		pr->ret = -EOPNOTSUPP;
+		return -1;
+	}
+
+	pr->ret = ops->pr_reserve(dev->bdev, pr->old_key, pr->type, pr->flags);
+	if (!pr->ret)
+		return -1;
+
+	return 0;
+}
+
 static int dm_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 			 u32 flags)
 {
-	struct mapped_device *md = bdev->bd_disk->private_data;
-	const struct pr_ops *ops;
-	int r, srcu_idx;
+	struct dm_pr pr = {
+		.old_key	= key,
+		.flags		= flags,
+		.type		= type,
+		.fail_early	= false,
+		.ret		= 0,
+	};
+	int ret;
 
-	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
-	if (r < 0)
-		goto out;
+	ret = dm_call_pr(bdev, __dm_pr_reserve, &pr);
+	if (ret)
+		return ret;
 
-	ops = bdev->bd_disk->fops->pr_ops;
-	if (ops && ops->pr_reserve)
-		r = ops->pr_reserve(bdev, key, type, flags);
-	else
-		r = -EOPNOTSUPP;
-out:
-	dm_unprepare_ioctl(md, srcu_idx);
-	return r;
+	return pr.ret;
 }
 
 static int dm_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

