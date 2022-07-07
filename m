Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A377FC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 20:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657225801;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lLF0W9/0U4F+8Ma3ZYcuEV+fXLVp+7qJLSLE6YGtqXk=;
	b=VPagvv0r8NU4272UVxe+rbUIMemDZU4D/SBGMeTqcONR9JVc4/CqrkLhMZYYfCFqGweUAI
	FO6rfpHfjyAVexAYDhscvAXJqMILtpkc34sPCQSJeWnbmJ4nWgQQPgP/gitu5ET5moQWGG
	1nvsyovgRrKCAGz9h8qu5gD3avvqR/M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-RifvFKh_PpKFa1UQFIzhWA-1; Thu, 07 Jul 2022 16:30:00 -0400
X-MC-Unique: RifvFKh_PpKFa1UQFIzhWA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E5A93C0E227;
	Thu,  7 Jul 2022 20:29:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 00B7D492CA4;
	Thu,  7 Jul 2022 20:29:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E6EA71947B82;
	Thu,  7 Jul 2022 20:29:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 17D251947069
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Jul 2022 20:27:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0B0838287E; Thu,  7 Jul 2022 20:27:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 056182EFA1
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 20:27:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEDF3185A7B2
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 20:27:35 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-Vh9ukYK0O9mZ4RBGCdyoSA-1; Thu, 07 Jul 2022 16:27:34 -0400
X-MC-Unique: Vh9ukYK0O9mZ4RBGCdyoSA-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCRts003646;
 Thu, 7 Jul 2022 20:27:26 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubye25h-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Jul 2022 20:27:25 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 267K9vNj017175; Thu, 7 Jul 2022 20:27:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3h4udfs6ue-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Jul 2022 20:27:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY4PR1001MB2261.namprd10.prod.outlook.com (2603:10b6:910:41::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Thu, 7 Jul
 2022 20:27:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5395.020; Thu, 7 Jul 2022
 20:27:18 +0000
From: Mike Christie <michael.christie@oracle.com>
To: dm-devel@redhat.com, snitzer@redhat.com, hch@infradead.org
Date: Thu,  7 Jul 2022 15:27:09 -0500
Message-Id: <20220707202711.10836-2-michael.christie@oracle.com>
In-Reply-To: <20220707202711.10836-1-michael.christie@oracle.com>
References: <20220707202711.10836-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM6PR02CA0167.namprd02.prod.outlook.com
 (2603:10b6:5:332::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10a31b1d-23cc-4283-e9cc-08da6057168d
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2261:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: tYaubLRRAGgzh0TNuHz9MB+JE/XNBvnCWYk5Ua00h4v2Lt3w96l56wVNvfSwdrM9hMUFVscN3Pbs4lxqWXmopZ4xx/kD9GZqVu4m4k5vud35ZRr5TR8H/hVzHeZh0D1yC2bhrwRM+wbQVfL2aRa7RZo85J5OXNBOzxSscZTHRakuilzFi4xJj+v8r4BjEd7JizX7XmpOg3eUV6Fi49+zm9DFG/1Bb+DIrd4gJQOqZV2D5Tld8R4NMk8Bs1R6oi7RbzK+4/O/gpCBD3LviPUUu7ZKQq8zITZi+P/Uc9SEgNt4fJ6rzf/UN1TJcth8a8M4XavavJSf0gXCmDnDTIAw9eVrtPdCcdtnK8ymavW7TGFTIu0oP89kZu9J0OXSCqsj82C0qbsR9+V971WCmEzMPqBZcVPv118s9ijBcuObSUZsDgp8uLtxhe6zMUaH92pD6SqPHPoTNktz376S3K9R+L7pnNnGxT2Yk4X6Hp7ObjjiC8V3lwHFAZJV+5a7VnEALknILeNebK4TyfW/N7JAlc0GwDmEHEHHNhHOe3Bt6FELjk6QeuTS+G1YHtcrRdgQfotsJw1rbU+kM9P+B6sxiqGHpVBgI+0ZOiN8nhBb2Xhnz5Q5B97fWyVVF9EJ/jpLv4AQFdCoHK0VMpBw1TNt0mOFFwH1uFDq6p2nyhE68Dc5zjBv/CI+4CnTXEP3kqu3P86LiX1MtXjxWR2mek1z21WCPUNEfFDAoQ2svgjvO2NHvbR9J86jlko7npYOKhPMvcJMUih34yRqk6YMCFaML104x6UOmSzHOpLZK9KwswQYD5f/+Z52hgmZlqkyKlX9
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(136003)(376002)(396003)(346002)(366004)(39860400002)(83380400001)(8936002)(1076003)(2616005)(2906002)(36756003)(86362001)(5660300002)(6512007)(8676002)(66476007)(66556008)(66946007)(38350700002)(6666004)(4326008)(6506007)(52116002)(478600001)(26005)(316002)(41300700001)(186003)(107886003)(6486002)(38100700002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wp3qM3/8NrC2pRLoX17jrIZQ8BdAJAplHyER+uQFq12lzOyScGICKNb1yI+d?=
 =?us-ascii?Q?EPgW19yHqVFaY1QID7W3xyimH+iEXZuXWH+dBrvY63WxbFZR4MnxMJaai03f?=
 =?us-ascii?Q?G1bPoV8ZL7B5k+4pSUiMnY8HBs9QdJ0Fr4nXyKJBeTEXWy7JZ60Bddx+3vmW?=
 =?us-ascii?Q?IGrjrFA4TW4iC/29zqjINpeSLiWv8cqeWVNr2J/zwxBU/3FPtQEOylND/eyf?=
 =?us-ascii?Q?Pdc9rX0Fr8/C8hlyjzMwlytu7/TF8grRQvHmsmw4VEJS/lRJAL6vy4EYwS7o?=
 =?us-ascii?Q?Q5rL/oujGLWYvqpPcG2DkxFxEYCNBHX6pDLhgluGou+GHu/bdoDzSPVTDMgq?=
 =?us-ascii?Q?T0UFN56tOqeMrJ9gwgxePhglEVCRekz48FCBNFbWjje45qZGMIRo3uwePmjI?=
 =?us-ascii?Q?f9zw6T5SmXFS0bnpZjD2f2vaLilqWFz+doRDt6Gw+arMvT2tsOrG5QgoLB+E?=
 =?us-ascii?Q?nhuMJ+ZFwsMWHIDf6uQJNc+TWOAyzPXSTES8dOF95WnDy78qIj7oV5GSkK58?=
 =?us-ascii?Q?lbwhbMwbxgkvPviYoBDUAmxeMv/d121e8FBz2aeWuLXfD4rDU/WzWhcMN2RT?=
 =?us-ascii?Q?UjwNtnI0BPLOfQW9Q/kvuFf5K3r1aVhq1LEIw2JmNgoz77OaHj8q2xBXjU3T?=
 =?us-ascii?Q?jhWLgh9kU3A5N4am/hf12FRooieM9lxOcSrWtylqrzD40NMwulRXZkrGOVJh?=
 =?us-ascii?Q?vMJ/CFt+cuii0rNoL32b/sR2DSWgnIVzIn0LBLX2NPPCsJvHCV53Q4CAR1M5?=
 =?us-ascii?Q?ysnMaGc2Jywyk3xJdCytN9fAwV/5Empg2o2q5hi087hCRv541pk2x8dFf7qS?=
 =?us-ascii?Q?Glwf7WCVlI1LuReahi6AwMfzSNLQQeDTNhd39B9Ky1jroX6/jNpKi89QKBX3?=
 =?us-ascii?Q?+AKvyMgly1AW+pvF4Zw7BbfNH4WQVZmNHhQKWkwo6crThZ51LvYRqu+oybZE?=
 =?us-ascii?Q?cK5NgEQqmt2+KjYKYGDAVOySv+QC3gkHWfVQvj21jXG7RtGOn9supn9qeD6a?=
 =?us-ascii?Q?nztm51JlO65qX9FaQMOB/ROl5QDKap2M/6ROR9/62PMM2YcRA7jRH3XxOjzU?=
 =?us-ascii?Q?Spen1WhLNmWENjK7xFhTXjedKqOHEeY82xlgp6EfivN5+kJPRtVPK/lVzLOJ?=
 =?us-ascii?Q?TV7A3p9wkzUfZzu3mC1x0ppj+cnCqGCSZ1e78DmHOJ8qEypnJHVIY1NdhIZj?=
 =?us-ascii?Q?miEi+dEEb6iEuF8WnCW6A+D2jCevUHhBerCs3HcVCmOflWymeHBi0RRePZi/?=
 =?us-ascii?Q?Sb0KZ9oWprqvieoMsCW0VfHO3zY1PMc6DcO/m06gnJeftuRm3g/3S7MF6/Ve?=
 =?us-ascii?Q?Qz3w6MRvLWG87gEau7RNkon7/i6BoV9FqAGSZV4i6HtHWHRGXY8x4TsKkTAs?=
 =?us-ascii?Q?qJjKDHROUqQwPDAr0pZ/u45xxBHVhXkVW41FdGr+tLXZJzKrnQ9tpGQ3mnYI?=
 =?us-ascii?Q?AkxcX0dTuEDbXuKybWjwE/0SuLXvpbaHTzu90prvHjdAZU7KvzYXtsEFVoHM?=
 =?us-ascii?Q?OsDNvoTdFT7UYNFJJSkf/KPIP1FEZKrqsha51r/nq7fNI78HH/RpO7taDucV?=
 =?us-ascii?Q?lhdkkSRwwv0BUtfT9VAXyO1zoyz+13zDRtbatgUg8BDhpS8r+hRpxqydsV/Z?=
 =?us-ascii?Q?dg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a31b1d-23cc-4283-e9cc-08da6057168d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 20:27:18.4885 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OaFbcJY9SWvF89yNkt9Y9PnY4LTd667t9ESOe6u1dQCMbI/5P6xV6wIkjQJl6Dn0wGopGoAPHwotSAbguJ0/BCjREj0vyEjQBSwcEieArpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2261
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.883
 definitions=2022-07-07_17:2022-06-28,
 2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 suspectscore=0 spamscore=0
 malwarescore=0 mlxlogscore=841 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070081
X-Proofpoint-GUID: 4yVZkZP4mptp3mYRJqJsujJndQJmAiX3
X-Proofpoint-ORIG-GUID: 4yVZkZP4mptp3mYRJqJsujJndQJmAiX3
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Thu, 07 Jul 2022 20:29:55 +0000
Subject: [dm-devel] [PATCH 1/3] dm: Allow dm_call_pr to be used for path
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
target_core_pr.c for an example. It will also get more complicated because
other initiators can change the state so we will have to add in async
event/sense handling.

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

