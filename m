Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0C10C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 19 Mar 2022 07:20:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-i5g338pROZi8y8PVX94yTg-1; Sat, 19 Mar 2022 03:20:23 -0400
X-MC-Unique: i5g338pROZi8y8PVX94yTg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44C0B811E78;
	Sat, 19 Mar 2022 07:20:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D98131121322;
	Sat, 19 Mar 2022 07:20:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DEEB8194035B;
	Sat, 19 Mar 2022 07:20:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DF47E1940341
 for <dm-devel@listman.corp.redhat.com>; Sat, 19 Mar 2022 07:20:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C7E38442CA2; Sat, 19 Mar 2022 07:20:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C3354482CD1
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 07:20:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CAAE185A7A4
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 07:20:18 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-LIiMtXpAONqFNp0D_iksLg-1; Sat, 19 Mar 2022 03:20:16 -0400
X-MC-Unique: LIiMtXpAONqFNp0D_iksLg-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22J2rfog012483; 
 Sat, 19 Mar 2022 06:29:32 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss04bu-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 19 Mar 2022 06:29:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
 by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22J6MHPA187254;
 Sat, 19 Mar 2022 06:29:31 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com
 (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
 by aserp3020.oracle.com with ESMTP id 3ew6yyhedt-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 19 Mar 2022 06:29:31 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by CY4PR10MB1798.namprd10.prod.outlook.com (2603:10b6:903:126::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sat, 19 Mar
 2022 06:29:29 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336%8]) with mapi id 15.20.5081.019; Sat, 19 Mar 2022
 06:29:29 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
 hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
 ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Sat, 19 Mar 2022 00:28:33 -0600
Message-Id: <20220319062833.3136528-7-jane.chu@oracle.com>
In-Reply-To: <20220319062833.3136528-1-jane.chu@oracle.com>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33974118-ddd2-4a72-9db4-08da0971d2a8
X-MS-TrafficTypeDiagnostic: CY4PR10MB1798:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1798577C62A4DED61D2F6B7AF3149@CY4PR10MB1798.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ciAR7p9FLiDZ3s3welcDtJrS/WCCBJjenYczq3x3GDRSbF7GFsz/o/rqagM22Q30NfdfcqCUmrm3DfXCvMN/IzpMdHj7H04of2osJxnPSx4fl8xqLT+K4fKBEAcff7KLSwn4D6IAv+T5vbjm146bBXSKLHeia2oy5y6CkopOKNn+qAKIFhL1obvAs0G9isLl8Jjo29ia37tToKb3UgA11v8/CqPG9K7Lsy1s+Mva48UWNnqSKmKCou/CPjoN1M9V2kTTogl8iYZ/+pqtL0vdH218MeBJ346aDxaVSgv4UHyU/14ttMzY9OiF7KerkTSmEtLW4zLXwIWjQdfEvCjHhxZhjYJI4omZtdRtSUvAFS2nM8GeR5OIs3HUtLHmIhe6hdGu4iFPHklby99IGsa1Faz2jHpGfPshPLHqS35ZfoL7xOz/LruZjoYJFiM7cgkbPAEJWEiD3ahbVobAHWoxb51NGnnbx9jlZKDxcE56ynZNDwrZx8RTidg5x8wfcnXwFpoj9wCZkjhIb+wDS9AlsVJ5tt4mKr7PUaFHwWB3bNvC6QD1aDvOfy5PHZGdbPtsAs6syKrLxImxmnz0ZyN6hnEdbYeGRs917zT881A7TG8oE/0+lOkYW2BlHC3UdQHStc+b0/D0jtl7pg57idrYHeXL0/8v0p5GaCxrpnsMHb5wGl/TW0JmqkjQQFSYkl2DsS7LzwNHBhTPDyYvKupeOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(52116002)(6512007)(66476007)(8676002)(83380400001)(66556008)(316002)(6506007)(2906002)(38100700002)(66946007)(508600001)(44832011)(5660300002)(8936002)(7416002)(36756003)(1076003)(6486002)(86362001)(186003)(2616005)(921005)(6666004)(21314003);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dek/ppI6IhNcKYqVP4C/gJzE2kBloNsgjm3t17ShlGTGCI4LYTd3fWt734R2?=
 =?us-ascii?Q?GbFjCzHPFkWflK00LNr9yvNwtUQU8XAXAKdM1KgbZ/+kjLK45qCMP8XWLOM4?=
 =?us-ascii?Q?MsSKnhC/N1OOUgVKNCkx8lF13lHVA2MBVuEpqKx0Nu4rAiufxwGqqFS2HgI1?=
 =?us-ascii?Q?7y5nSmCyt961CGAkk4/dYkEmSvPHdlGg1GkrB1atasQQTT0JIKmi+Yz7Mw5/?=
 =?us-ascii?Q?1fOYgOdIN+Mh2rv5UwNQY7t7ESDKxlFnCdOeWD/F6xCBwRxeE3n3wPWA17s4?=
 =?us-ascii?Q?yxHDUTVsICtTAs8zMBJNZt77+aiMHn5M2YQRPPmx2Kx0VLTcDN1jHTOq70xx?=
 =?us-ascii?Q?32ek/WGlh1wt6exPSL08Pm8nfjDZCRWHM3c2NYMG4heG7XLx5Zf/NgNubnKu?=
 =?us-ascii?Q?XmEwXuSQuTUgxuy5+HjMAuLJvIVrxx97jsas8PV3VGqLT3K5UBwZjSokN33o?=
 =?us-ascii?Q?WWrardkUfQcb8OwMHmYRmgbIhjXL8nVs4Dmjkrjtj5jCqqj/qJPS5nVetUNl?=
 =?us-ascii?Q?36CKuDsh7su2riedRF1Hn/gLtn52jhj5JSw7w8K1nXyuS8CIezWeBczXRaXI?=
 =?us-ascii?Q?DTqtHmqoVzIUYK1DzueWkhmtkOWCj2QwCdmOdHMwyKv0GKAi0gpb3euIIPuW?=
 =?us-ascii?Q?RL3TRpOwnDEBuDXKa2s15JH181SQm+uGmLwYM5xYvH0/E8rce25+AQ7mI/xN?=
 =?us-ascii?Q?6T8RtMoJzJSh3KXD4wD8p9qXmNxN1wn+iQNi2TermtIaCLpOBjf/7ZK2Apeg?=
 =?us-ascii?Q?suYtdyjgKcprFyC7FacqiVl9LcPXa/COkaTsc1lX9gW3lXmX0b6DnVA8vduy?=
 =?us-ascii?Q?xZhfuU3F+wY6kU96/mdSB/QQS6xhB4iWWZBdSFvwuxGBXakviDn4t00gEgaV?=
 =?us-ascii?Q?UTnzGtIslUrVgEYQuzrfnhKDrzLvhmncMcagZwH4IVq2ekw1q8iKUuMaLB5C?=
 =?us-ascii?Q?Te/PoNAN/H29TlwXjBcBYAsjzdIuMzNxpzTgT2lChr00R6QdMN86DzlWPWcI?=
 =?us-ascii?Q?6xNZmdr/H2inb4Sl8Cr888J6AkLHCCXLODXG0WOiDlNl/C+6Oq7KGPv8r2oV?=
 =?us-ascii?Q?TzLaG+x3vHcmFeKOGFNgXtXenW1CVUDU+iLtSApZ18Y76f8eUeBuLdlEENJe?=
 =?us-ascii?Q?JZFo1tdohQytnnpTXnabZqbudQxwItgLn9f7uW1tMFIg2zm9n8iZNuhXU6+7?=
 =?us-ascii?Q?tRnwqvUTYSiOIsQBFJRtPyq5jNcinrazXHsuL7MU7aCJpvqBnuBzS2I8if6Y?=
 =?us-ascii?Q?ps6tbHh3UZa7LmSwBPOt7dYmW6WcaYmq1exxubZ8XGqfatQRV3JuUOxLs58R?=
 =?us-ascii?Q?znf2E62EltswcY6ALqDLfUWNoIOM/2AiD9QAns7/jRtR0VE0b9ozWDwIUgxG?=
 =?us-ascii?Q?r6b7uqEfjTZzHM7P76QhNWyturdCTdTAyIzzR97QHmpYRgDiPA993zsA+jn8?=
 =?us-ascii?Q?EWricDHVir3Lfr3/+BlrYjPLWNWrQ8apEOCFzYdW9en67fUX512BEA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33974118-ddd2-4a72-9db4-08da0971d2a8
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2022 06:29:29.7504 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGqecdbL3+HzzpFFfHZeJKFe1/WMx/JqhHEhivfmwTKA9yMkH24+wdJhnAr7mN9i2+HQFLaDqZRclhaZphTcFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1798
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10290
 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203190038
X-Proofpoint-ORIG-GUID: 3KeeVu4cox7pGNRbO06qvrn__SyZQjiZ
X-Proofpoint-GUID: 3KeeVu4cox7pGNRbO06qvrn__SyZQjiZ
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v6 6/6] pmem: implement pmem_recovery_write()
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The recovery write thread started out as a normal pwrite thread and
when the filesystem was told about potential media error in the
range, filesystem turns the normal pwrite to a dax_recovery_write.

The recovery write consists of clearing media poison, clearing page
HWPoison bit, reenable page-wide read-write permission, flush the
caches and finally write.  A competing pread thread will be held
off during the recovery process since data read back might not be
valid, and this is achieved by clearing the badblock records after
the recovery write is complete. Competing recovery write threads
are serialized by pmem device level .recovery_lock.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/nvdimm/pmem.c | 49 ++++++++++++++++++++++++++++++++++++++++---
 drivers/nvdimm/pmem.h |  1 +
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 18f357fbef69..c4fbd9426075 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -321,15 +321,57 @@ static const struct dax_operations pmem_dax_ops = {
 	.zero_page_range = pmem_dax_zero_page_range,
 };
 
+/*
+ * The recovery write thread started out as a normal pwrite thread and
+ * when the filesystem was told about potential media error in the
+ * range, filesystem turns the normal pwrite to a dax_recovery_write.
+ *
+ * The recovery write consists of clearing media poison, clearing page
+ * HWPoison bit, reenable page-wide read-write permission, flush the
+ * caches and finally write.  A competing pread thread will be held
+ * off during the recovery process since data read back might not be
+ * valid, and this is achieved by clearing the badblock records after
+ * the recovery write is complete. Competing recovery write threads
+ * are serialized by pmem device level .recovery_lock.
+ */
 static size_t pmem_recovery_write(struct dev_pagemap *pgmap, pgoff_t pgoff,
 		void *addr, size_t bytes, void *iter)
 {
 	struct pmem_device *pmem = pgmap->owner;
+	size_t olen, len, off;
+	phys_addr_t pmem_off;
+	struct device *dev = pmem->bb.dev;
+	unsigned int blks;
 
-	dev_warn(pmem->bb.dev, "%s: not yet implemented\n", __func__);
+	off = (unsigned long)addr & ~PAGE_MASK;
+	len = PFN_PHYS(PFN_UP(off + bytes));
+	if (!is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len))
+		return _copy_from_iter_flushcache(addr, bytes, iter);
 
-	/* XXX more later */
-	return 0;
+	/*
+	 * Not page-aligned range cannot be recovered. This should not
+	 * happen unless something else went wrong.
+	 */
+	if (off || !(PAGE_ALIGNED(bytes))) {
+		dev_warn(dev, "Found poison, but addr(%p) or bytes(%#lx) not page aligned\n",
+			addr, bytes);
+		return (size_t) -EIO;
+	}
+
+	mutex_lock(&pmem->recovery_lock);
+	pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
+	if (__pmem_clear_poison(pmem, pmem_off, len, &blks) != BLK_STS_OK) {
+		dev_warn(dev, "pmem dimm poison clearing failed\n");
+		mutex_unlock(&pmem->recovery_lock);
+		return (size_t) -EIO;
+	}
+
+	olen = _copy_from_iter_flushcache(addr, bytes, iter);
+	if (blks > 0)
+		clear_bb(pmem, to_sect(pmem, pmem_off), blks);
+
+	mutex_unlock(&pmem->recovery_lock);
+	return olen;
 }
 
 static ssize_t write_cache_show(struct device *dev,
@@ -520,6 +562,7 @@ static int pmem_attach_disk(struct device *dev,
 	if (rc)
 		goto out_cleanup_dax;
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
+	mutex_init(&pmem->recovery_lock);
 	pmem->dax_dev = dax_dev;
 
 	rc = device_add_disk(dev, disk, pmem_attribute_groups);
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 823eeffa7298..bad7d1b05691 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -24,6 +24,7 @@ struct pmem_device {
 	struct dax_device	*dax_dev;
 	struct gendisk		*disk;
 	struct dev_pagemap	pgmap;
+	struct mutex		recovery_lock;
 };
 
 long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

