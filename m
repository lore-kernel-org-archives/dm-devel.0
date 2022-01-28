Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB453C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 21:33:06 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-3Wnk5bBoMbuxYxDqH5fwaw-1; Fri, 28 Jan 2022 16:33:02 -0500
X-MC-Unique: 3Wnk5bBoMbuxYxDqH5fwaw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6385D100C619;
	Fri, 28 Jan 2022 21:32:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46A6A1002390;
	Fri, 28 Jan 2022 21:32:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1FDF84CA9B;
	Fri, 28 Jan 2022 21:32:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SLWjUs018749 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 16:32:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DA410201AC74; Fri, 28 Jan 2022 21:32:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D49232024CAE
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 21:32:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D13D185A794
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 21:32:40 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-90-2mPio8YtOCmcGoOGYTYd6w-1; Fri, 28 Jan 2022 16:32:36 -0500
X-MC-Unique: 2mPio8YtOCmcGoOGYTYd6w-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	20SK3uGo030747; Fri, 28 Jan 2022 21:32:24 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3duvquvmpq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jan 2022 21:32:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20SLQvRu134915;
	Fri, 28 Jan 2022 21:32:23 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com
	(mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
	by aserp3020.oracle.com with ESMTP id 3dtaxd6usq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jan 2022 21:32:23 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by PH0PR10MB5753.namprd10.prod.outlook.com (2603:10b6:510:146::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8;
	Fri, 28 Jan 2022 21:32:21 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4930.018;
	Fri, 28 Jan 2022 21:32:21 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Fri, 28 Jan 2022 14:31:45 -0700
Message-Id: <20220128213150.1333552-3-jane.chu@oracle.com>
In-Reply-To: <20220128213150.1333552-1-jane.chu@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
X-ClientProxiedBy: SN7PR04CA0071.namprd04.prod.outlook.com
	(2603:10b6:806:121::16) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22f7e4cf-14ab-4157-6ac1-08d9e2a5aaf5
X-MS-TrafficTypeDiagnostic: PH0PR10MB5753:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5753E02999CD2FF00702C380F3229@PH0PR10MB5753.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: RR7oyGEV27hMJt0YyXLAUgtBDJyfbkxvSPqPdHldzecEnbhSHc5VuHay+ZvAUwc29uv4SIClTPy0Zjtjb5Kcbo2ZB6xl5WeJs5hMki6oy4H0XxMd3nERNdTcNHX2XlqFZ9gl1hzDRx+BFFSwwylcrVwBXLGnqc+shqv1vS8xtTrg3+XbKucGS6MI/iVvnhcr428+4Y6AZ8vJxJ7epexi7nQ3quqJRfhA5ZwcrYfJjB9PkVlLTSwF119qsFSezkyVnWuRQ4oNFdmuF9bGt3CrmnWMz68WHFmCowIbwXXQkOiXlDev8icfSv82FzCkTTpSYNYPfop4/REbC3OXnhncqJ6EFAjNMFPil6P4E8POtSZMm5DYkr2QwdbLfLw9MakYEnhjvxB6908QjYhQvzTXynaDqUudHhx+kMXzhnCo9GizrJsYkAkcfNGkK8gj0VphLrYrdCCpiKKbvhV1UD+pijKK1hlFj313Bw/LCVKvpqPqaDA7sKYU/f6NrBaxFcRfXruvOktfD/EL6BWpqZnVGlynwKruLlz6exUrFWCyYE/cIeg67umetajY6tCRoGpIvXHdcF2AD+Z9/amCrp0JX6Y0YNfInwUbfc5uE6qnMf+pQhadnSWOnyuZVSRHB03xenfVkFVfeem64Xu5nsySDea+RMdDKIR95HvSpgJkqT8jalpK2eoNhn11tadr7CJ0j7hqPcaC+uN7S7YzgabTXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(83380400001)(8676002)(36756003)(38100700002)(508600001)(86362001)(6486002)(2906002)(6666004)(2616005)(8936002)(6506007)(316002)(52116002)(66556008)(6512007)(5660300002)(66476007)(66946007)(44832011)(1076003)(7416002)(186003)(921005);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xt4zstu4i9pT9y6pK+xHXz+BYffnpbrCgl4JTfTnco+2/a/L4s0LEegcpqLL?=
	=?us-ascii?Q?ne69FGmkgXfJsyaWrPvh0ARTYnoT7FkpdvMfZF/njEz4j2S43olEiA8srG3i?=
	=?us-ascii?Q?AjDoGxoh21f+3DAaWky15pJeXVebzbIhPGKUBDE5ix1ZnMqSQJtcRH8q6pvC?=
	=?us-ascii?Q?mjhtdxPczG6s2mPSGNtCN6uSwPEQFb5W8j7nFgSpF8pYDENKcL+bWVe99g5o?=
	=?us-ascii?Q?/+qgBpdz8HZL1/DbVHeEoW/WH3Yg21p0utKLJzueExfqJi0fq1kkYl2JJKn7?=
	=?us-ascii?Q?/XkF7YFuePiXHbIA/ldVdd7bJFOyhEdAYPB8cnaqYi3+gUmfPXNIgBjdFxDv?=
	=?us-ascii?Q?BEQlPhAGOiMYhJdwsOJOSryvjdWMmZuvVzADCrVDwfPhIsXfV/k+RAod5zZi?=
	=?us-ascii?Q?RsVBBTbOSvcUhTd/B2Nz6FNa/cPf8nhcnlD7KwWiKbnzC6RuUnPXLK67l7nO?=
	=?us-ascii?Q?1S4lwx244ExilUyVvbbWdr0pHiVPFwULHxeIuUq+U8s+3P8tdQar5mULrXrR?=
	=?us-ascii?Q?aTyuSxIaHlnX0N/35bP1JybLZh8m494OLC/WQ62EdMRlKBkX0g4hzWtEu2Rw?=
	=?us-ascii?Q?aUW2J4ZxlByrsCwPDkFXFrEGoud9e+Ln8WkRzHXVQVkx7nCtGrHRUqA2ALKN?=
	=?us-ascii?Q?7sxibxpWr0v18SW/unFq7NN0Q87qmiOCJGVhAaA6wMmoLk9fE00diomWm+Wo?=
	=?us-ascii?Q?SSfjUT3FNO/Q757k8camjZymhDk+NRkxCc65LxqUMC43XEzMKSJlDFQlKFN0?=
	=?us-ascii?Q?e6HBDHS/uUmQHRSTsqpXNcU7GDDUHeZDLSK8G0vwLlv87k3FTFbJVZbl/rCO?=
	=?us-ascii?Q?BHPRu2zmjYX251DtvzEqnnPTqC3hyCs/pW7UDj5kK07QC9eMuoA79rk33HI/?=
	=?us-ascii?Q?pBa2mC8ElaGtNrBZQ6f/tN9NvIjiv+QDRCMc5EzW42Df99c/fW5Dw0dm4wqs?=
	=?us-ascii?Q?wQK0F6Vq9JVXmctImoyFP9eebf7KT/1M2lEdFUewbeAdF9UgRCRmfVdnqeRG?=
	=?us-ascii?Q?1KOZf3B8uM0L5dMHTaP/JPolyGR1pke7acmY4q8LQ8oxACjJ9HRCBHm3UCnO?=
	=?us-ascii?Q?k7vqFfPhDwl7oFtqR6Vqqbur5+BDfriWjbVNQ9DvdmvMpUGq48DQaZXbvDTv?=
	=?us-ascii?Q?jUhYSCbNZXrSbyydQiQF8HnsOVgdm4dOvF9gTLfZmbAcHVmbWzlix9ymt6M+?=
	=?us-ascii?Q?aGDD9l7swqZW2K9vn85S4TrkYqVEdHZGaEfm8pPKBQpGWnIbNA5BTwrFdflw?=
	=?us-ascii?Q?xRZJRuI/N5Y6MKerwrPnzoBoiireYhSZxfdFMC/lyWZc7k2IjQ+W8Bf0xuXT?=
	=?us-ascii?Q?eemy9zgTqnBYWlTEGZhlyFr7qIvhKlAxgYyuRVioPYAMVylZSUjwI0wrkUvd?=
	=?us-ascii?Q?LOchlr+XGyH79ZMEqNEiILi8zJdCORSkYHrF6/Wi8gsThgQgMD448fq+HBxg?=
	=?us-ascii?Q?sfExxQKPHxbAh+jMNCpP7kbKlkwM+8q7uEEkQz0ivkwmgqGgUGbOTRU0OfZU?=
	=?us-ascii?Q?+0ClNgZxoSdlnmBSwOP7Hj3NEPcihJp8xaGiXZk64npaVL25qdezt2TpxQ/y?=
	=?us-ascii?Q?YC7RGzRGnh/xRm+Mf0+wxeaYlLTkVESgiCJZzkAjCS9FERsT7k/BzJRndlj7?=
	=?us-ascii?Q?h2FSeFgFsRlH3D5LPgbZo8NsUJr8M9M8wOLfCOagGIh6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f7e4cf-14ab-4157-6ac1-08d9e2a5aaf5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 21:32:21.7419 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /3Wya0MQiXiqSpXYO33gqRin68k4eRgfaAbmIGiqRdYssNkGiaoXBy4LnFdWfV1k2YYGdKCj3iIZUAfrIBOWuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5753
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10241
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	bulkscore=0 mlxscore=0
	phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2201280122
X-Proofpoint-GUID: AIYoBLlnMQQ6ALiFz0_YnVaaqldUUNNY
X-Proofpoint-ORIG-GUID: AIYoBLlnMQQ6ALiFz0_YnVaaqldUUNNY
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v5 2/7] dax: introduce dax device flag
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
 drivers/dax/super.c   | 24 ++++++++++++++++++++++++
 drivers/nvdimm/pmem.c |  1 +
 include/linux/dax.h   | 14 ++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e3029389d809..f4f607d9698b 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -109,6 +109,8 @@ enum dax_device_flags {
 	DAXDEV_NOCACHE,
 	/* handle CPU fetch exceptions during reads */
 	DAXDEV_NOMC,
+	/* flag to indicate device capable of poison recovery */
+	DAXDEV_RECOVERY,
 };
 
 /**
@@ -311,6 +313,28 @@ static void dax_destroy_inode(struct inode *inode)
 			"kill_dax() must be called before final iput()\n");
 }
 
+void set_dax_recovery(struct dax_device *dax_dev)
+{
+	set_bit(DAXDEV_RECOVERY, &dax_dev->flags);
+}
+EXPORT_SYMBOL_GPL(set_dax_recovery);
+
+bool dax_recovery_capable(struct dax_device *dax_dev)
+{
+	return test_bit(DAXDEV_RECOVERY, &dax_dev->flags);
+}
+EXPORT_SYMBOL_GPL(dax_recovery_capable);
+
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
 static const struct super_operations dax_sops = {
 	.statfs = simple_statfs,
 	.alloc_inode = dax_alloc_inode,
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 58d95242a836..e8823813a8df 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -487,6 +487,7 @@ static int pmem_attach_disk(struct device *dev,
 	if (rc)
 		goto out_cleanup_dax;
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
+	set_dax_recovery(dax_dev);
 	pmem->dax_dev = dax_dev;
 
 	rc = device_add_disk(dev, disk, pmem_attribute_groups);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 9fc5f99a0ae2..2fc776653c6e 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -40,6 +40,9 @@ void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
 bool dax_synchronous(struct dax_device *dax_dev);
 void set_dax_synchronous(struct dax_device *dax_dev);
+void set_dax_recovery(struct dax_device *dax_dev);
+bool dax_recovery_capable(struct dax_device *dax_dev);
+int dax_prep_recovery(struct dax_device *dax_dev, void **kaddr);
 /*
  * Check if given mapping is supported by the file / underlying device.
  */
@@ -87,6 +90,17 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
 {
 	return !(vma->vm_flags & VM_SYNC);
 }
+static inline void set_dax_recovery(struct dax_device *dax_dev)
+{
+}
+static inline bool dax_recovery_capable(struct dax_device *dax_dev)
+{
+	return false;
+}
+static inline int dax_prep_recovery(struct dax_device *dax_dev, void **kaddr)
+{
+	return -EINVAL;
+}
 #endif
 
 void set_dax_nocache(struct dax_device *dax_dev);
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

