Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C89C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 11 Jan 2022 19:29:26 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-p7J9cGT-N1qNUvHuYFLXPw-1; Tue, 11 Jan 2022 14:29:21 -0500
X-MC-Unique: p7J9cGT-N1qNUvHuYFLXPw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFBD61083F61;
	Tue, 11 Jan 2022 19:29:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 60CE910016FE;
	Tue, 11 Jan 2022 19:29:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C17984BB7C;
	Tue, 11 Jan 2022 19:29:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20BJTAFj017718 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 11 Jan 2022 14:29:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4800D1402409; Tue, 11 Jan 2022 19:29:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 427F71402408
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 19:29:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 241EE38011C3
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 19:29:10 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-517-7PWi1PpoN4eUYcntThDLrA-1; Tue, 11 Jan 2022 14:29:06 -0500
X-MC-Unique: 7PWi1PpoN4eUYcntThDLrA-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	20BI2LpB027852; Tue, 11 Jan 2022 18:59:55 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dgn74bwqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jan 2022 18:59:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20BIpx74169195;
	Tue, 11 Jan 2022 18:59:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by aserp3020.oracle.com with ESMTP id 3df2e568wa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jan 2022 18:59:54 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB5647.namprd10.prod.outlook.com (2603:10b6:a03:3d7::9)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11;
	Tue, 11 Jan 2022 18:59:52 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::6814:f6c:b361:7071]) by SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::6814:f6c:b361:7071%8]) with mapi id 15.20.4867.012;
	Tue, 11 Jan 2022 18:59:52 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Tue, 11 Jan 2022 11:59:25 -0700
Message-Id: <20220111185930.2601421-3-jane.chu@oracle.com>
In-Reply-To: <20220111185930.2601421-1-jane.chu@oracle.com>
References: <20220111185930.2601421-1-jane.chu@oracle.com>
X-ClientProxiedBy: BY3PR04CA0005.namprd04.prod.outlook.com
	(2603:10b6:a03:217::10) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6872c48b-9dbf-47d2-7bd5-08d9d5348c7b
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5647:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB56473D01873F6F809626C1B8F3519@SJ0PR10MB5647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 8ZKU0B8f9uS6AiZuco4uz1f8hgjjT4i2RridnoUkBjpdSe+5uCBEiWdlJ+oX8tC24vc0FGINAvP8BrE0LLT73DulNBE11MLwYS5qrGqeKBn9PvqF1SzYiHHtlbDcLkpibTJarbNyICFxDIMM4qTUfTe6OvIdKBkXh4K0DQeDHo47KleYYIUrvnphiISR8zkLbe1UMd8wqwki9sT2xohWZptrMFgJcF8ckfsR+FDe+FiyeY9Nd9fxXisvAku7yaLSYhlccWbZ03iSHNFsAZ3ixUk3ubALgZ4edWaN57hF4NJan5o8HwVS3r8rUX6vvA6KIVj3BbO+SMvUrOn+dxMwKtkUJvKvFp8AqOlAWSjVfeUE9zQ0RDI08at3Eogw5qkBbErSIIVZ+sy3s4bvhoiw1pymgG5KzPSwmuSTcLeROxhQQcmNmnjkn+A5DE4BBn1VuojadPkpMmnV6HRmTyYzK3QEPa2xOd1qw+WwTx5D96ArREf/DxdJre2ayU/xCv3Q2yvzg8ufaHqaRzCjUjeell6BaIt5RAaIvBl73pjax8kKS4RBLcEOpdQ+AgrvqEXJOZgA3/kzQ5AVPljsPQNEj6GrctqPd2u2eDrRS1xDzfR39L8wdvDSWQHKG+A9slrW6Kk9HgpBi3UumJJbnu9RiRlOIk2zjMziWclBavTSPHoNuI0Rb40LYdJsxMpZTb2T
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(5660300002)(66476007)(508600001)(6512007)(44832011)(66556008)(66946007)(86362001)(83380400001)(1076003)(38100700002)(6486002)(36756003)(316002)(8936002)(6666004)(2616005)(921005)(7416002)(6506007)(2906002)(186003)(52116002)(8676002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/kp/8H/lUfpBP1ZnIj/Rbr03DCJscVM+qZskoHu57XUs4WJihPi8yqJURDbF?=
	=?us-ascii?Q?HNIj7NA2PjPCNQIQ3IaI4dVHFemxQqd9TwpdJarp+Vdw4Rb34CdcDJPxOclS?=
	=?us-ascii?Q?0nbTQbF1wMJbrIsK6MKUYvM0TAgT5r2dMDdcnmHEDawxg1lS9yjowwBs6Jjb?=
	=?us-ascii?Q?or59NTG5EaRx6j63+alt29BStQfks6lsy3nJAoKc9/I8BFQNxB2+8FcegwVM?=
	=?us-ascii?Q?n2xxwAVoZJ/47TWWKKiFt7+kyZvPTVGXCNy9ZgJKhXdewN4ZeP0BbO0EqTqg?=
	=?us-ascii?Q?6f2/Cdz4TiiTNdhgdAXCSaOdZYGZVPHPWLBevj0R2AGIvwukjaTruLFA0KdJ?=
	=?us-ascii?Q?4CND5HByudQ4lhJ1fBvP0gh+eIjfw/s1JyV42pom2uAaQkDP2V3bAAt/+Pty?=
	=?us-ascii?Q?g1kYsKZ0XPxKqmr161fnUXlo4zB7/vR6igB0uAOU63Z2nkgX5BfgtIZS1xyT?=
	=?us-ascii?Q?NJqfV6QUpPljAB4n+PdFL0N5IKpjbgZscoSQvl2hwsn5RIUO/fvlOt/JFB4q?=
	=?us-ascii?Q?A/fxL9VxJ+A+Wneu9RQ80kRXaikTph6/uZQ/WRy+TJLkhHy1MDtrqVTITO4n?=
	=?us-ascii?Q?Tuw2pGe7Oqq1QM6ExJbwXem2CbJSMZ5pIHn3OiJmYMnRgDO2b7dAtEFW1wjf?=
	=?us-ascii?Q?JkBy8SctpyUhnmcjzpZ07M3qO72Ayd0KPRxcfEFSqrHGFPTMX5DW2On5wqmL?=
	=?us-ascii?Q?BxB67wOA/RLMczVwSTvK9gGXMF3df2B6smwJYvP1hVBWdMDCyAZ3oquKrPJL?=
	=?us-ascii?Q?B+NqA7V1MvZPxzbmAjmzKxFg7lIMohfdP80GZMDBpdtkQ/6he2G4lmCxulsf?=
	=?us-ascii?Q?kDrmXPG0DNIDCMlub0ZpZEkmxstM6yaToFOhRdSRTAqHDOiA94h1BOhL2xoH?=
	=?us-ascii?Q?uYzOZmZm2S9pyva/+QH+bz1TuJX/RuPexR48/6KEMUG7KJgYMS8IH4NVU9W0?=
	=?us-ascii?Q?+EbRUkbIuUtYBfWNkSv9EQ5SVr41PNZu2PIcbQlTjRoNNEpb9l+RiOb1NT3N?=
	=?us-ascii?Q?QdQAW4MZcaoI7+Gnlsi5rE5cm8f0DH/8bDaronN7SpmurTVEI88A4KpCdY9+?=
	=?us-ascii?Q?p8SPthhgmaqXAHiDHyr+KvrzTuPtA0lItHHuwsuXyvtI18+l9kxQG4mL00pP?=
	=?us-ascii?Q?emsRmjmCSyZlkD4wT7uUmB2MQgbgo+4gfwcixGS4k7jeNAO1RnloDERI5LmO?=
	=?us-ascii?Q?9y3tifUM9BI9qYtORiQsXbpqn1+4rnNQZzqPPrJkmntEOoNLKwNooDnTjLk1?=
	=?us-ascii?Q?qrao2ytOHNVFs8IgCyguZnL4eamtf63qCw1mFxE9UftT+H1V7QZS/3v/PeNN?=
	=?us-ascii?Q?P8sKDuwX/PF7PDwrs3qpaTxhOGTTFvJZHc1drAGVjTWuyIpd2n4Jv9JAJ/DR?=
	=?us-ascii?Q?ipZm1bf3KVAzTPWc3FkMcs/KE/FpmmQS2g4vwzml2YmjHDacOZ9uMhwHSxFD?=
	=?us-ascii?Q?tJ24cZKjTTHLoiJDrQBZz7Vn53Hkk5QHE3o3w68tkCKFuwBg1iGnil/oLL5V?=
	=?us-ascii?Q?FJ98ohFwPtjbsOxzWH/+EVgFGbCHbvUBX+Oe3OiDYqkXAeooRDVtFnqYl02i?=
	=?us-ascii?Q?H84/DBGPmNlut+vdLha/m16xMiBb6aUtyVgAniNL8dFkkzieGVAT8JY0gOAx?=
	=?us-ascii?Q?DGMnMgfyb3bEQLS4075FSqLmjRLm6judbSh/z026OA5V?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6872c48b-9dbf-47d2-7bd5-08d9d5348c7b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 18:59:52.3774 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rhZUh51ZnpVgSPxuHYmohiYJ70tH3ICC3R74RkZp06YrYMtnMzXEPmH6JGih0Sfk72mFnEMrAeAGSIm9wpjoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5647
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10224
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	mlxscore=0 adultscore=0
	suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2201110101
X-Proofpoint-ORIG-GUID: wv7hQH7Ahn5yg0LCetQHDGm7ICNxwlrh
X-Proofpoint-GUID: wv7hQH7Ahn5yg0LCetQHDGm7ICNxwlrh
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v3 2/7] dax: introduce dax device flag
	DAXDEV_RECOVERY
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Introduce dax device flag DAXDEV_RECOVERY to indicate a device
that is capable of recoverying from media poison.
For MD raid DAX devices, the capability is allowed for partial
device as oppose to the entire device. And the final poison
detection and repair rely on the provisioning base drivers.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/dax/super.c   | 34 ++++++++++++++++++++++++++++++++++
 drivers/nvdimm/pmem.c |  1 +
 include/linux/dax.h   |  3 +++
 3 files changed, 38 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e7152a6c4cc4..bfb2f5d0921e 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -105,6 +105,8 @@ enum dax_device_flags {
 	DAXDEV_WRITE_CACHE,
 	/* flag to check if device supports synchronous flush */
 	DAXDEV_SYNC,
+	/* flag to indicate device capable of poison recovery */
+	DAXDEV_RECOVERY,
 };
 
 /**
@@ -227,6 +229,38 @@ bool dax_alive(struct dax_device *dax_dev)
 }
 EXPORT_SYMBOL_GPL(dax_alive);
 
+/* set by driver */
+/* for md: set if any participant target has the capability */
+void set_dax_recovery(struct dax_device *dax_dev)
+{
+	set_bit(DAXDEV_RECOVERY, &dax_dev->flags);
+}
+EXPORT_SYMBOL_GPL(set_dax_recovery);
+
+/* query by dax, and md drivers, and .... */
+/* can be true for md raid, but untrue for a target within */
+bool dax_recovery_capable(struct dax_device *dax_dev)
+{
+	return test_bit(DAXDEV_RECOVERY, &dax_dev->flags);
+}
+EXPORT_SYMBOL_GPL(dax_recovery_capable);
+
+/* requested by fs */
+/* can be true for md raid, and ought to be true for the target
+ * because kaddr ought to fall into the target which complained
+ * about BB and only pmem do that. however in theory, this could
+ * be true for md but untrue for a target strip
+ */
+int dax_prep_recovery(struct dax_device *dax_dev, void **kaddr)
+{
+	if (dax_recovery_capable(dax_dev)) {
+		set_bit(DAXDEV_RECOVERY, (unsigned long *)kaddr);
+		return 0;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(dax_prep_recovery);
+
 /*
  * Note, rcu is not protecting the liveness of dax_dev, rcu is ensuring
  * that any fault handlers or operations that might have seen
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 4190c8c46ca8..10d7781c6424 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -506,6 +506,7 @@ static int pmem_attach_disk(struct device *dev,
 	if (rc)
 		goto out_cleanup_dax;
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
+	set_dax_recovery(dax_dev);
 	pmem->dax_dev = dax_dev;
 
 	rc = device_add_disk(dev, disk, pmem_attribute_groups);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 87ae4c9b1d65..768bb9ae31c1 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -49,6 +49,9 @@ void kill_dax(struct dax_device *dax_dev);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
 bool __dax_synchronous(struct dax_device *dax_dev);
+void set_dax_recovery(struct dax_device *dax_dev);
+bool dax_recovery_capable(struct dax_device *dax_dev);
+int dax_prep_recovery(struct dax_device *dax_dev, void **kaddr);
 static inline bool dax_synchronous(struct dax_device *dax_dev)
 {
 	return  __dax_synchronous(dax_dev);
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

