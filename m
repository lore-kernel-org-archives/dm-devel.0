Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F5F3C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Apr 2022 22:47:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-fNsUMNJPOQWCpxO_S8njeQ-1; Fri, 22 Apr 2022 18:46:59 -0400
X-MC-Unique: fNsUMNJPOQWCpxO_S8njeQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9AA03C00089;
	Fri, 22 Apr 2022 22:46:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A693F41617F;
	Fri, 22 Apr 2022 22:46:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8BF371940354;
	Fri, 22 Apr 2022 22:46:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B5681940352
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Apr 2022 22:46:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0ED6D404D2CA; Fri, 22 Apr 2022 22:46:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 09EAB403D198
 for <dm-devel@redhat.com>; Fri, 22 Apr 2022 22:46:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E34D185A5BE
 for <dm-devel@redhat.com>; Fri, 22 Apr 2022 22:46:50 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-gHEwx4mKONyb2iGm_UMzfg-1; Fri, 22 Apr 2022 18:46:47 -0400
X-MC-Unique: gHEwx4mKONyb2iGm_UMzfg-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23MKCxRl009531; 
 Fri, 22 Apr 2022 22:46:28 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ffmk2yvfm-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 22 Apr 2022 22:46:28 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23MMeocr007341; Fri, 22 Apr 2022 22:46:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3fk3awf5ut-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 22 Apr 2022 22:46:27 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB2550.namprd10.prod.outlook.com (2603:10b6:a02:b1::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 22:46:24 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 22:46:24 +0000
From: Jane Chu <jane.chu@oracle.com>
To: dan.j.williams@intel.com, bp@alien8.de, hch@infradead.org,
 dave.hansen@intel.com, peterz@infradead.org, luto@kernel.org,
 david@fromorbit.com, djwong@kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org
Date: Fri, 22 Apr 2022 16:45:08 -0600
Message-Id: <20220422224508.440670-8-jane.chu@oracle.com>
In-Reply-To: <20220422224508.440670-1-jane.chu@oracle.com>
References: <20220422224508.440670-1-jane.chu@oracle.com>
X-ClientProxiedBy: SN1PR12CA0057.namprd12.prod.outlook.com
 (2603:10b6:802:20::28) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 271b81fa-46b6-4b73-1b75-08da24b1ede0
X-MS-TrafficTypeDiagnostic: BYAPR10MB2550:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB255004ADF5E6945F3A95B388F3F79@BYAPR10MB2550.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 25uy3vsQXgPasuMAz9Yk/XCyb8KG93PnoIDlEiDUGG9z/yzHc40QVgK8U+QqJbYgbEnU/phPFCWUNHUImivRV8XVR1mcMPnN719avwZtoGc6qsNrZ6rK2hWhYtulZx8yWKOynQni9ZwCr0SSZrQddZ3NPHTSi3CBqNRq2tDJJasv/GS0uNDv52+0wY+exdlO+qhypD32vM9uQeiNj3R0fsNfBQ0rvnoGAz0s+/4D1wM7Xr+/2N6c17v9zfF2ocbb2EM9b4Sh60WB2+Hr5IZBmPhODQTWQ/ew+zS87exe+mMeEu6qfvb/vtnvScmRVznaTjPJioQqNCzPT2nyErWxhNb/DPN5vgBC8PyBuC1Vu8kx57h6xHeEGXrvV5C2/QPiouF3ha02S46JIRVWVUVMcPWbGsJvBQVm6VmHdXw8WnLshC4LC4UGLNnFdxc+SUZJkiXrFhm6xmOtdz9IGAHP7lOFlGCMo4BGEW02bSo+jt8YY0rDemdfArQeQFqtngpcA6ib6DWXI1+eHqnvXRLD5D/u43Y8MoZQB1656PYV1+3sQLveV0VHMWbI/lX1Pdu0uHIMHGHHpcuy8ShEIrKAxGLI7/o+kagA4QfzieklZ0QFnv1JDnNzLcGGICsBgmEivq7hxFf73A4b/dVYYBcM8AIGMzg9Zm9vAh3hDNOO0r55HG3DOZDRew0yOFQNw5+w
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6506007)(6666004)(6486002)(8936002)(508600001)(52116002)(83380400001)(36756003)(316002)(66556008)(66476007)(2906002)(8676002)(4326008)(66946007)(38100700002)(2616005)(86362001)(5660300002)(44832011)(186003)(6512007)(1076003)(7416002)(921005);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?szyhE4mqZjdpMHs1RiPFhqckN3Ba27VgtEtiMcdL/8VLpmzy0pJMGELnDvlR?=
 =?us-ascii?Q?/bYovwgrjxQwKlYmq5oDz/nQBA/7BON2S2c+2aAQxaFym1ayqj0YrcrGxnVs?=
 =?us-ascii?Q?DyRtMvBINw9+gv0pR4Z+3Q1iGRdGis67+IPThbCqS3W3yUlEK8sodILqOUr7?=
 =?us-ascii?Q?+YNfQP9+niKeWxm1BQVd3aaHAaQiXJCXMh0JUWo3Mm56pC1vTxLSc3xDmF96?=
 =?us-ascii?Q?nhEguI7emCR/Cjpf5L5KcL3LCkHd95Vho64TzzOmMrS0SqsoZlpI6hDXrCNZ?=
 =?us-ascii?Q?3y/fi6u9pXpSsppFBIqgURRTaJ4h9swLb7JVRDFsGK1VwyOUVkOy6oepkW9S?=
 =?us-ascii?Q?wGaWZeGFktH3ecepcO4cKb4YtB2kQ1rEvsvrobMe1X0SOmaTJFwbkr5U20yP?=
 =?us-ascii?Q?qoc3kpYIWOmabw2Cd5tsYf/MaDAGYmGjJi67sjjlEV/cEbAA6PE6BSneCkrF?=
 =?us-ascii?Q?Tu3SSvP4MjICyPtMb0iigGp+UKj2RzovUiyMAtLFOel3Ue8qAa/H58csc708?=
 =?us-ascii?Q?bP1TaHvlkS1rA9b7+LZpp2eGRpuS+q5rLVbg7dadJLkaBRX3fKp58TnJvvda?=
 =?us-ascii?Q?YD9Y+tn+j3g9PWvOedTrCLeOhMOSOTpTn+xMn4KybFpuqdtMaMXjzyVcWC5K?=
 =?us-ascii?Q?JBp8hJp2IqzYgX4k2xI/iNICBwJGN8MbjDW8d/FGHG3SL53jMANuk57STj92?=
 =?us-ascii?Q?iPAhqjI7OhswbeM1gzJZk1E42bZTIenSShtDVKFoSmPitZjBTlur5jjxJWMD?=
 =?us-ascii?Q?cAhrO+cHPOWg0xurYec2DhLcqFrvio6E+z5a3Wvjw5Kdo7vM5t3gZTtBSWSQ?=
 =?us-ascii?Q?Bk/6oZK2ycc07J8JqySkNgkXVbWMu+TVzVAFRhILlQqG+0/ieTyMvtS0c3OA?=
 =?us-ascii?Q?XYTa+haDgHrKXBjHec7zR3edUhCU25M+oXxDI+RGIsQak8LO/F7sj76wPXw5?=
 =?us-ascii?Q?x8JQLMq3M6I8EVFLbcdnZV9O7DaJdizTotGfpbvj/4Zfc8YstOX/8+K5j6DO?=
 =?us-ascii?Q?h+9vxyk4LaWUKdslMbXHWLgl9zftzGX8faAcpMXnELWKLAZFaif0mp/PYStu?=
 =?us-ascii?Q?nlkpe9CpIRPzYWRhOowlY53kUf3wB4DHKRd9i/dtvEb3frpFNIGjw94Xdt9s?=
 =?us-ascii?Q?zs2F3ql2P/Kg+vznWTJ3g8zbEfYUISAqUlGFNMOu0Vjh10eFlUg1CPkV3kF/?=
 =?us-ascii?Q?wkADErc4eRhzQAW+rSudppj1vl6QnypA9O1Df224qufT9NmuWFiHLRnifTH9?=
 =?us-ascii?Q?KuXR+xRWkA6VTIVphUH7XhBrxiS2YNemEIhK1XmqrxiwGOWWWYqGK2TkPKio?=
 =?us-ascii?Q?/Zv0OPCY8Q7z8q2B1i7YTI/UZAhCQ4IAr+iActg4prhqaxoX/mD83O4fZGpY?=
 =?us-ascii?Q?u2EzJS1iaxcORmksaXLw5K8oyUcWZ/Qx1mzR+LYdY97HocDndBFJReipCbmE?=
 =?us-ascii?Q?rBrSYBdXDewP+80s9Qvlqz3g3jaDAQgTw4QaoyWQAsAjwAgw3tXfve+0r2J5?=
 =?us-ascii?Q?j9v4BiFhT4t2hRPkZqDWyCYcOFVlTEsV+hyiubj9OROQpCbjUv6Wrpmm8Eae?=
 =?us-ascii?Q?wY0l1aZBIzHWp8FQZuVYipk1+jgD8fDtyB/GIG3UqU7uTPunxArBPZV7tBnS?=
 =?us-ascii?Q?O8egO0PbQzFwjKuIiFhvZf7nfw3eCZCWdRWi2XV+Ynp5hxNzdle7PpJvk7wb?=
 =?us-ascii?Q?QV+L8vqU+t7sZAnmJUC4AxoVWhr9oHIxBENRuCN0+P+FOl6d/keYEOEv9TtZ?=
 =?us-ascii?Q?5S446fjP1CpZ0rZx0ma3iTNBmxx1cwA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 271b81fa-46b6-4b73-1b75-08da24b1ede0
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 22:46:24.5981 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RAx1Ne9G1tvHOd652FbJtHEGWYlHtArVOyhcGrMQJ5XVe4X582p+aExqjituzGq1W8csSWQA6Eheg0VrzZLp/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2550
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-22_07:2022-04-22,
 2022-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204220095
X-Proofpoint-GUID: 72kJ_8G3j_TQco9eRrdR7IHSjCkHhy8j
X-Proofpoint-ORIG-GUID: 72kJ_8G3j_TQco9eRrdR7IHSjCkHhy8j
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v9 7/7] pmem: implement pmem_recovery_write()
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
Cc: dave.jiang@intel.com, snitzer@redhat.com, vishal.l.verma@intel.com,
 willy@infradead.org, dm-devel@redhat.com, vgoyal@redhat.com,
 ira.weiny@intel.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
are already serialized by writer lock held by dax_iomap_rw().

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/nvdimm/pmem.c | 87 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 79 insertions(+), 8 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 0961625dfa05..91ce7b2b2ada 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -266,21 +266,43 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 		pfn_t *pfn)
 {
 	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
-
-	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
-					PFN_PHYS(nr_pages))))
-		return -EIO;
+	sector_t sector = PFN_PHYS(pgoff) >> SECTOR_SHIFT;
+	unsigned int num = PFN_PHYS(nr_pages) >> SECTOR_SHIFT;
+	struct badblocks *bb = &pmem->bb;
+	sector_t first_bad;
+	int num_bad;
 
 	if (kaddr)
 		*kaddr = pmem->virt_addr + offset;
 	if (pfn)
 		*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
 
+	if (bb->count &&
+	    badblocks_check(bb, sector, num, &first_bad, &num_bad)) {
+		long actual_nr;
+
+		if (mode != DAX_RECOVERY_WRITE)
+			return -EIO;
+
+		/*
+		 * Set the recovery stride is set to kernel page size because
+		 * the underlying driver and firmware clear poison functions
+		 * don't appear to handle large chunk(such as 2MiB) reliably.
+		 */
+		actual_nr = PHYS_PFN(
+			PAGE_ALIGN((first_bad - sector) << SECTOR_SHIFT));
+		dev_dbg(pmem->bb.dev, "start sector(%llu), nr_pages(%ld), first_bad(%llu), actual_nr(%ld)\n",
+				sector, nr_pages, first_bad, actual_nr);
+		if (actual_nr)
+			return actual_nr;
+		return 1;
+	}
+
 	/*
-	 * If badblocks are present, limit known good range to the
-	 * requested range.
+	 * If badblocks are present but not in the range, limit known good range
+	 * to the requested range.
 	 */
-	if (unlikely(pmem->bb.count))
+	if (bb->count)
 		return nr_pages;
 	return PHYS_PFN(pmem->size - pmem->pfn_pad - offset);
 }
@@ -310,10 +332,59 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
 	return __pmem_direct_access(pmem, pgoff, nr_pages, mode, kaddr, pfn);
 }
 
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
+ * are already serialized by writer lock held by dax_iomap_rw().
+ */
 static size_t pmem_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	return 0;
+	struct pmem_device *pmem = dax_get_private(dax_dev);
+	size_t olen, len, off;
+	phys_addr_t pmem_off;
+	struct device *dev = pmem->bb.dev;
+	long cleared;
+
+	off = offset_in_page(addr);
+	len = PFN_PHYS(PFN_UP(off + bytes));
+	if (!is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) >> SECTOR_SHIFT, len))
+		return _copy_from_iter_flushcache(addr, bytes, i);
+
+	/*
+	 * Not page-aligned range cannot be recovered. This should not
+	 * happen unless something else went wrong.
+	 */
+	if (off || !PAGE_ALIGNED(bytes)) {
+		dev_dbg(dev, "Found poison, but addr(%p) or bytes(%#lx) not page aligned\n",
+			addr, bytes);
+		return 0;
+	}
+
+	pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
+	cleared = __pmem_clear_poison(pmem, pmem_off, len);
+	if (cleared > 0 && cleared < len) {
+		dev_dbg(dev, "poison cleared only %ld out of %lu bytes\n",
+			cleared, len);
+		return 0;
+	}
+	if (cleared < 0) {
+		dev_dbg(dev, "poison clear failed: %ld\n", cleared);
+		return 0;
+	}
+
+	olen = _copy_from_iter_flushcache(addr, bytes, i);
+	pmem_clear_bb(pmem, to_sect(pmem, pmem_off), cleared >> SECTOR_SHIFT);
+
+	return olen;
 }
 
 static const struct dax_operations pmem_dax_ops = {
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

