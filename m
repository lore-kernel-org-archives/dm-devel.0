Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA9FFC43334
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 20:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657225801;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RacktUl3+gRxoCunrbK0Xvl4+9cBEOJ26AYEOKhtkKE=;
	b=NNMVIHepgsNzq3W1UiZU8ClLiRg851CkR4omp2Sf8CUSwMO9kktpATh7hztclJMirCYhxi
	tjt5yNQlKMwn5cgIZKr9FOM8LZTaX2yyg1ZEawU/jfnzN0SLuUmNSb7KCdcBsRH3Q0NVuX
	HuK+7gkyezCLQNW/R9NDwWswJwN9WLQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-bNlPxVpwPYmAEYpM3Y58Dg-1; Thu, 07 Jul 2022 16:30:00 -0400
X-MC-Unique: bNlPxVpwPYmAEYpM3Y58Dg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37584805F63;
	Thu,  7 Jul 2022 20:29:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3FC06154E080;
	Thu,  7 Jul 2022 20:29:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CA5591947069;
	Thu,  7 Jul 2022 20:29:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 81BE9194704C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Jul 2022 20:27:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 65010C28118; Thu,  7 Jul 2022 20:27:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6032EC27DB3
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 20:27:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 446821C1BD22
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 20:27:35 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-q4Gw3dceP-65hrsmKEuD3g-1; Thu, 07 Jul 2022 16:27:33 -0400
X-MC-Unique: q4Gw3dceP-65hrsmKEuD3g-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCvGF020796;
 Thu, 7 Jul 2022 20:27:26 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4uby6bgs-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Jul 2022 20:27:26 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 267K9vNk017175; Thu, 7 Jul 2022 20:27:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3h4udfs6ue-3
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
Date: Thu,  7 Jul 2022 15:27:10 -0500
Message-Id: <20220707202711.10836-3-michael.christie@oracle.com>
In-Reply-To: <20220707202711.10836-1-michael.christie@oracle.com>
References: <20220707202711.10836-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM6PR02CA0167.namprd02.prod.outlook.com
 (2603:10b6:5:332::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 864e4e53-1479-4893-f810-08da605716de
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2261:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Y9grQpl5o5gDAWt9CeMhwJcFk8QaMn/GlKlLM/r8zFrMHAjO1X7qLrMguwj9tS9sC9AIqjz/Ut9LlQlXAACtdg8UnUqT/8vTyZNtQvefyuCSkqN/Oq4rta6f5eNPP0ldk6u4XsIjTBnYw/bPduAL9iMcvlQipczhuDJW04JCoqQxTXhSvyzY5oWaJ1KOQVp2Swa7UQnytLNx2IY5EA4OKfOqFnikKRrJnSKPUjQllpDdKGf3SpOOyOXFzpZ8wfOV3WxBiQY3fZcLTHESMHMWOvdYSWBdNZSX4EFppHMupqYCX5GbJsek2HbHDdQf5ls8dfY2jOb/bEi83p4YKKXzSWt95H/uFmNaXBm3agz3HZREXablbTgm4dAqvXVK0NJ2tfWLmzYlFosp2N7Hu2Vvav5oNexoyEbL1e9M3h63dZbLccQwImGot2y25gOdPC4RFmsFh9pKsJPPcGVyi52ZigRyBsQzkT9RKzwpeWDePX8xNtsjcSipcfiLigAswPFAPzx5hqiOHoGUR3pq4x9iZarbjfJTFbMnjrb3+pSlnAshD/yrfIqHNs7+h3sYewKCIX/DGpT/DnWYzGczNqu8cZvJS9G6ea4jE/FcOSxFZi69g2cjeXF2DZalk91CjjlzuxczA2yeYHcIygq8yxHBEN2ZZcelkXTUTwPvAEoE+03+NLuODvikoSTWvm2XxFpw5lsT8ZV8YEFHCpaV8fqStobLuecvTgGZ21GFjET94AmfVTH/7L8RGAILbvmhK32HyI847PoJ9YfU4+dyQUWvyRz/urn40wqyjEVUJLu2J3Dr+L4cDIsfbjleLwMoq0p7
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(136003)(376002)(396003)(346002)(366004)(39860400002)(83380400001)(8936002)(1076003)(2616005)(2906002)(36756003)(86362001)(5660300002)(6512007)(8676002)(66476007)(66556008)(66946007)(38350700002)(6666004)(4326008)(6506007)(52116002)(478600001)(26005)(316002)(41300700001)(186003)(107886003)(6486002)(38100700002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZkdfNj0En0bYZOVTi2VrF4GfJ5SW9z/TyIQlvSxWUW7JQZOfMfFKAxd8Jib6?=
 =?us-ascii?Q?ajpxXEX+iGzFaE3V6YMQwnqXAnGLX6+atnZYMKVoUustcLJo9dqX+pdnScOx?=
 =?us-ascii?Q?IXJmSiSsuJ/XGfGU5J0iLG2LyLiIwwVXl94oocXgMBdF1Nl81ADWc2OEMgQ5?=
 =?us-ascii?Q?49hR2L47YtCZyN84I7wqEL6l/YXzE6ykGDKCCs68gbztcDBJVKjYrpeAu0o4?=
 =?us-ascii?Q?4GquPIn4cwHKQ4zGswSii4tUEV9NWaMwigr17dYrhri6XLPP6lGrGhHs7KoS?=
 =?us-ascii?Q?LtDmkBhfsIdw90O1Vf9x9RRSnneRjcF2GwhfwpK/JR1Rw7ZYM9dXVjpHh+W9?=
 =?us-ascii?Q?lBZ9E2n2l+FpTN76/HGiRBgluFZlBepSAKFbHPdCAHGwo81AMMtpsxHw/dn3?=
 =?us-ascii?Q?X3G8U0LoJmOtn592pt4wJRacY93DHodMICwt6n65HItBKa9RoOaE19Cu4nkS?=
 =?us-ascii?Q?AM2Yciq/f+jhepwCgf5ENSEmi+Bv3q5xTy0LQ9MC8bI/NAp+jt01Ux7rR6vq?=
 =?us-ascii?Q?7oU+8+wbDo1CS86zdd5T2rwdkvoIgF/yXAXPsPgsiFNl/PNeOIpkmifoov8R?=
 =?us-ascii?Q?tWNBO6oUdpAZ/7ntddZW1wZQEloRvjcaIOFsjIDYlPoIApWzM5QjgfM59SAr?=
 =?us-ascii?Q?rBaigFvpD4BkZj+8J+4FcV3EWK6rPoVQd5pji8axNoAWOv7LUXDiecxE8Q5b?=
 =?us-ascii?Q?z6JFW9rvZKfubcnzB73CA9yDe6o4GY8o0cIaZST0tnLOvRdnitzt0JryInX3?=
 =?us-ascii?Q?2oDabr9VftRAjJ90Y6m3b+awdGWs5X9el+NzvSeuzi6qH6jZtq/TD9zokoWd?=
 =?us-ascii?Q?A9BFCWEUqFYIANSOifxP06W3TvSEftHKVhFUHUg4zfPZ+s16VucKpdIPdKC7?=
 =?us-ascii?Q?d5BnaoDJrSTrKEjkFmlCCSINRoRZIU9C/IdpMBKRw0Hw0NL+AugmOUQwf6e9?=
 =?us-ascii?Q?gCmkvjq2kjCZhWYimsh9xXwhqJvc/gK/hO4yZDPs3KjbTaPiyNuGZSw4oCfK?=
 =?us-ascii?Q?CBb8oGJFX7RCNwvrDnBFDHLOzQdR1ydco1WqvYV4L801Dj6eiSERnA8hfv1k?=
 =?us-ascii?Q?YUPpNjPtXlchC8mGSiT1P2SmbGxlm4IlucpiH8d6rnbnHbtcFEIUyMvN9VT7?=
 =?us-ascii?Q?be//OD1tBrHrGkdDsXkwl4LHM79MFt5aLGm60KzMIQhYxbTOGPk+eCrjOEbh?=
 =?us-ascii?Q?10Zw8CVeRld/mtgR07jQryfczNkR64N0Sp3fE0uoWJdbcxG/UxFxiGxrq8qC?=
 =?us-ascii?Q?gr0doDoNa5bZaJmJrNTH8MPMa3YrqRZmm3SRAEFY1mA1NFPc+CtozgIt+ZoK?=
 =?us-ascii?Q?ckHmlJjT9vzhceGEvc9whfRJ/Ze/Qju6EdFU/4ZVxSR4UEGstgeWItuzrQ4V?=
 =?us-ascii?Q?sD8mRjU5GqcTALDEevNFkov+/za9uzexZOcvzUllJNwtmujeBlgGZZUEerwP?=
 =?us-ascii?Q?/7qP4Xv1u57Mwui5n8AqxUYq+Eh+N+zZ3v8TiLqtkqMJc7IdTvjecJGTRKnC?=
 =?us-ascii?Q?seSWk2mCuVALL3z4QcZSZllMc8iNqfPVnin++9rkk6bt8OyhzqufZTl2ka+p?=
 =?us-ascii?Q?vAUdhgqG/LYZDt9Lr83/9QChPm6ZUAQ1aQAQpdvxWAwqf1VCaccyWN3sVVt9?=
 =?us-ascii?Q?Og=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 864e4e53-1479-4893-f810-08da605716de
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 20:27:19.0041 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hrkbkySpCsYZnBiW6HBAgqP6VGrsYZ78ZFub/c+PHlq6xz+mGfcMHyQxrIXi7DkCfT7LgKBn30fZ+UITtZgaeGiR9NfUDHybD8dw4boZfyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2261
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.883
 definitions=2022-07-07_17:2022-06-28,
 2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 suspectscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070081
X-Proofpoint-ORIG-GUID: YXJTg61yaFBUIkBxVd7szGd-cuOQdGqV
X-Proofpoint-GUID: YXJTg61yaFBUIkBxVd7szGd-cuOQdGqV
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Thu, 07 Jul 2022 20:29:55 +0000
Subject: [dm-devel] [PATCH 2/3] dm: Start pr_reserve from the same starting
 path
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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

