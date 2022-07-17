Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43266C433EF
	for <dm-devel@archiver.kernel.org>; Sun, 17 Jul 2022 22:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658097951;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=t79LL527BOkAkJ/Pa7p0jhtdZBxe8pbTSRxRQ6wwqIE=;
	b=MiaKp5RXDbOtszRFPmQMndj4r0beueCTKP7kGg9z64/FlcuPotuvffeEQVwrkIyEDiTi4L
	yue/TcZvBY7eDN/Gsyv++agqHFk76w8RK4ZQyFNM1FAz3ZSIN+CHqG6ufFSVKm+nqmRdbh
	t4FQcCi0r5LpZl6JMld+nINIty4jMBY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-UxEzXiaUP1SVVgTDlxcvSA-1; Sun, 17 Jul 2022 18:45:43 -0400
X-MC-Unique: UxEzXiaUP1SVVgTDlxcvSA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF0CE8039AD;
	Sun, 17 Jul 2022 22:45:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 67E5C1121314;
	Sun, 17 Jul 2022 22:45:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3ABF41947075;
	Sun, 17 Jul 2022 22:45:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 425F5194704E
 for <dm-devel@listman.corp.redhat.com>; Sun, 17 Jul 2022 22:45:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 360A1906B6; Sun, 17 Jul 2022 22:45:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3144A906B9
 for <dm-devel@redhat.com>; Sun, 17 Jul 2022 22:45:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D02380418F
 for <dm-devel@redhat.com>; Sun, 17 Jul 2022 22:45:40 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-7k9ULwNjMa6MiB-2jpHtKA-1; Sun, 17 Jul 2022 18:45:36 -0400
X-MC-Unique: 7k9ULwNjMa6MiB-2jpHtKA-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26H94UWp002464;
 Sun, 17 Jul 2022 22:45:26 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbn7a1v77-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 17 Jul 2022 22:45:26 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 26HJc6ra004037; Sun, 17 Jul 2022 22:45:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hc1k3bras-4
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 17 Jul 2022 22:45:25 +0000
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
Date: Sun, 17 Jul 2022 17:45:07 -0500
Message-Id: <20220717224508.10404-4-michael.christie@oracle.com>
In-Reply-To: <20220717224508.10404-1-michael.christie@oracle.com>
References: <20220717224508.10404-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:610:76::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f61da92-54f0-4abf-16cc-08da68460558
X-MS-TrafficTypeDiagnostic: DM6PR10MB4137:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: CW+sZPi4sSuqCIY/mLZI3rZnhKvJkDTgC5R1nspEv/z3cAE2XCcwatpuUFDczdEME0pwI+5rCkuPcL+jvz1yPKHnGJDstQeMsAF36BJVOkc2TACFE5qRlO7NIER68TNahqXSDW4sc+U9G3qr0PHCMvkuMO4yuyqzo6UOZlPnkEH9b0J3HVrmfTT64NbbEVzrhsgLq5NO/zDO9G7oYRSlW10VqS8Xo8SkiBeKpvZjfQuquNnO2QnXJ70ce1ae7R9uPA59ypmJjSCUHM1KoOwfS9bz0Rc0BUZK7ZFRyt8XPk07LV/otx6SRYCgxhPx2/XOd5NE9VEe0Za+nzPS2obGB9jpkqU3/GYyinPCEeagd3KIH/stduGjMWprb/L0mkqUZkTJkW6EWBNyEbazDJ9wa7p/9wjsJaNYoYAojadJxzeUMsSpGz2+y/TBkdajQbZZgZwe1eJV3j08+nR37Tn9JCiTIJMYyXB6vYdUhsm2/tWT440Z8FU5UDnAlDF8LzK4INCarK6Uh1KXCYbNHrc0wPs3MgGB/7uKnaC1yj6cNYwsW/Jql+BSwoGePINObohOMDYswjMTJyMSqne0oiKjhVCM7cmdBZtNNDC2YJn7Ih9o0vdqeR9pbCJvInw1WmfjUTmCfkrig31m60Au2gALQJBp3tL54m3veDl7zbto9RRjYQR04bdlO+8wMrORL8GpSlWu5NxSAxfr9DuKOkb69VxMtzjeGqzZXyHaYV8mCorgZfQBIDLETp6C1QEhNomqT3OYCjU0cG0O/i5IqZ0GgJN/CxLGtWdNkh3GDqwB2CH4BN0pRJ7E/XzOaDZ0P5Wx
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(376002)(136003)(346002)(39860400002)(366004)(316002)(36756003)(2616005)(6512007)(38350700002)(26005)(38100700002)(1076003)(107886003)(186003)(83380400001)(6666004)(4326008)(8676002)(66946007)(5660300002)(8936002)(2906002)(41300700001)(52116002)(66476007)(86362001)(6506007)(66556008)(478600001)(6486002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?luzqZK6YuRVnS0xivkV6/fozfWupy44BkTXNXY9NIyN8N2jzcJc5qSgrqMaJ?=
 =?us-ascii?Q?Hfxo4dIGIxDvvXwCix7w6PGks04tFLNnQXU201GHOl2JtaPPrVw9/hRXq/7s?=
 =?us-ascii?Q?qvc+ohJNoLO05f327kDBId92mi6fSqAB8xN70Lijai8rgMSJTCvs4QQgb2yk?=
 =?us-ascii?Q?EYqHAxMuFTSvCJxSlFwACn7C0dINrH9KbMDaPmzC5FjTMPXAU1esw0d25cwI?=
 =?us-ascii?Q?BlIL8odHLzGPtK7ijezghttIvqeGCC4KAZzdnb1c1IKKLPGwmdZ/7A8P/Vj7?=
 =?us-ascii?Q?YWnh9iPHtImLhV/WmKL0eMmWyqSY98yon4Pk0bHEbc7/TrM1T+PUu73vFsyP?=
 =?us-ascii?Q?m+bVrhTbfOOeaEGMwCp+BD1Ud+H+M4PYejZ2dsnOkE7bRpXwR82qSdUcYoiS?=
 =?us-ascii?Q?kwdhS4hiDGvP27v3sVUvHUuoOBFu1Kqs9HMAFUiHGGsdcdubpGOfn6Eg2nSE?=
 =?us-ascii?Q?lhsNDJodjg97IjWOVDRhA01hYRSKqvpz4QDGQriMG6ToncwSHDsZbtXZDt9u?=
 =?us-ascii?Q?GRGpCrre0fACzvEAVUVGYwo9jpMyjWqRNb7ucvAqEp+uJQLHKK+OfEjT+20A?=
 =?us-ascii?Q?F4I1Xx5Vcnxe24HmwCQhIpBKuodPmOFdAXGhEdnHcJdupsu9KdpUP16Sql7C?=
 =?us-ascii?Q?7P6bubqovmloeFoLTZB9reUPz/b3YHDLzhgBEPwyJ38T2aNdhzbsTGkaJAce?=
 =?us-ascii?Q?u4dybzB4phlSWeVjRg4nPQejCyrobnk7cQ7/I/Mx3XJx/xepMOguHnlSkgE1?=
 =?us-ascii?Q?j6Pf+6nBl77uXG8Hm8Wmwobqu6lH3k1OCN6P1w7qY0NtMFMrTVe6gnz7OcTt?=
 =?us-ascii?Q?brzZ2aLXxCgqsnwrDc5+lak9d8dkbk2Uv4usvlK/L+QhvqncsFIhYCq9NSrc?=
 =?us-ascii?Q?rPAtPUr7LJnNdDFcof42MLAj5tVHHcDMXOfZyMgp4o7kFfmqMBlTE9NWXeNT?=
 =?us-ascii?Q?Fw76+X+tRd8HkxnaYjDRQFA4VVB+wLatNhNhBYdPfK3MuyFDe8rZKf6G8hxP?=
 =?us-ascii?Q?Uy2MN7WCxWaRSvyd6b02r3XTzLNhq74WcpkDlo/Hz2xfMcweT9TxcWK79AaL?=
 =?us-ascii?Q?fkmFolreTLs8Pr8z3P9bzJAwh+OxxeF7lWTtuLH8diZ2j3An53vazmPJa1nz?=
 =?us-ascii?Q?DPJQnvnuzTMh97mRcYbq1mmmMcl1ic6ldfVmmpQRP13nSq0N95rq3xjBX7QV?=
 =?us-ascii?Q?2xRn7i8pBPCpRKq7q9kCwMDAjK1OGLJY3yaP/16+qPg4n+O0Sam9fc/CveBv?=
 =?us-ascii?Q?xlDATJvPZF8vkmcEoGMFUS1sI6xldiKvmgFN7fMtPfXWCS51q0fwQnYsTB9S?=
 =?us-ascii?Q?bRnn4WLgFD4O8q100uy/v5XbTG3uq7j1/ku6pGKcq/m+n03+XvuT2HC7/JGF?=
 =?us-ascii?Q?1RlHcXWkhhvIRxzkFf0DbIE46vxYXYDVuC/8wsBzdx9YKJz5j+I+zzPkS9ur?=
 =?us-ascii?Q?SSSkfNycFhHRH4kDyGpIyGjw+89eZnDcss00ItvUN7K2aQKZSTr75q2LqUuc?=
 =?us-ascii?Q?UZresahSWgYBQ+UeBMTKbickIGdaK/Fa6n7UF73o+Zc/KUZTJS35+8N7yHEJ?=
 =?us-ascii?Q?p5/cAVDqykm7fqQW9/bE5qZtfWEM6VH6GhhDmS5BhocXrnBdLC5XPHCdRUsQ?=
 =?us-ascii?Q?Gg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f61da92-54f0-4abf-16cc-08da68460558
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 22:45:17.3942 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqjjNQfablW0PpEzhgK5sGwWObBb6jSZz0d8Gui9ziC/0oLSr8OKxU+zDXqebSc1q+HouFO/AGuy2OifF0g+qdzu/UHZdy4AYxUffC0xe6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-17_16,2022-07-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207170108
X-Proofpoint-ORIG-GUID: PMSBBtq2cmpLyWv36PCnjw4NA7CO6Wdt
X-Proofpoint-GUID: PMSBBtq2cmpLyWv36PCnjw4NA7CO6Wdt
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH v2 3/4] dm: Fix PR release handling for non All
 Registrants
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch fixes a bug where we are leaving the reservation in place
even though pr_release has run and returned success.

If we have a Write Exclusive, Exclusive Access, or Write/Exclusive
Registrants only reservation, the release must be sent down the path
that is the reservation holder. The problem is multipath_prepare_ioctl
most likely selected path N for the reservation, then later when we do
the release multipath_prepare_ioctl will select a completely different
path. The device will then return success becuase the nvme and scsi
specs say to return success if there is no reservation or if the release
is sent down from a path that is not the holder. We then think we have
released the reservation.

This patch has us loop over each path and send a release so we can make
sure the release is executed on the correct path. It has been tested with
windows failover clustering's validation test which checks this case, and
it has been tested manually (the libiscsi PGR tests don't have a test case
for this yet, but I will be adding one).

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/md/dm.c | 48 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index cdd1656b99d6..c31f99c9d2b2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3178,24 +3178,44 @@ static int dm_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 	return pr.ret;
 }
 
+/*
+ * If there is a non-All Registrants type of reservation, the release must be
+ * sent down the holding path. For the cases where there is no reservation or
+ * the path is not the holder the device will also return success, so we must
+ * try each path to make sure we got the correct path.
+ */
+static int __dm_pr_release(struct dm_target *ti, struct dm_dev *dev,
+			   sector_t start, sector_t len, void *data)
+{
+	struct dm_pr *pr = data;
+	const struct pr_ops *ops = dev->bdev->bd_disk->fops->pr_ops;
+
+	if (!ops || !ops->pr_release) {
+		pr->ret = -EOPNOTSUPP;
+		return -1;
+	}
+
+	pr->ret = ops->pr_release(dev->bdev, pr->old_key, pr->type);
+	if (pr->ret)
+		return -1;
+
+	return 0;
+}
+
 static int dm_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	struct mapped_device *md = bdev->bd_disk->private_data;
-	const struct pr_ops *ops;
-	int r, srcu_idx;
+	struct dm_pr pr = {
+		.old_key	= key,
+		.type		= type,
+		.fail_early	= false,
+	};
+	int ret;
 
-	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
-	if (r < 0)
-		goto out;
+	ret = dm_call_pr(bdev, __dm_pr_release, &pr);
+	if (ret)
+		return ret;
 
-	ops = bdev->bd_disk->fops->pr_ops;
-	if (ops && ops->pr_release)
-		r = ops->pr_release(bdev, key, type);
-	else
-		r = -EOPNOTSUPP;
-out:
-	dm_unprepare_ioctl(md, srcu_idx);
-	return r;
+	return pr.ret;
 }
 
 static int dm_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

