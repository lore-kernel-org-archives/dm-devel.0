Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FBC0C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  5 Apr 2022 19:49:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-P0El91R8NbOGtSJSw6lr0g-1; Tue, 05 Apr 2022 15:49:14 -0400
X-MC-Unique: P0El91R8NbOGtSJSw6lr0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ED6785A5BE;
	Tue,  5 Apr 2022 19:49:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 27F2D9D45;
	Tue,  5 Apr 2022 19:49:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DB160194036B;
	Tue,  5 Apr 2022 19:49:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C69C11947BBD
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Apr 2022 19:49:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B41F5112131B; Tue,  5 Apr 2022 19:49:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE4F31121314
 for <dm-devel@redhat.com>; Tue,  5 Apr 2022 19:48:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FFF88E5F01
 for <dm-devel@redhat.com>; Tue,  5 Apr 2022 19:48:59 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-34DTtGpLNYygLtLDrWpsGg-1; Tue, 05 Apr 2022 15:48:58 -0400
X-MC-Unique: 34DTtGpLNYygLtLDrWpsGg-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235HDi4W012570; 
 Tue, 5 Apr 2022 19:48:24 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwcevwk-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 05 Apr 2022 19:48:23 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 235JaNKv002676; Tue, 5 Apr 2022 19:48:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3f6cx3tu73-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 05 Apr 2022 19:48:22 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by CO6PR10MB5475.namprd10.prod.outlook.com (2603:10b6:303:13e::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 19:48:21 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%7]) with mapi id 15.20.5123.030; Tue, 5 Apr 2022
 19:48:21 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
 hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
 ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, x86@kernel.org
Date: Tue,  5 Apr 2022 13:47:43 -0600
Message-Id: <20220405194747.2386619-3-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-1-jane.chu@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
X-ClientProxiedBy: SA9PR13CA0054.namprd13.prod.outlook.com
 (2603:10b6:806:22::29) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8958e909-0d82-477c-235c-08da173d3cdd
X-MS-TrafficTypeDiagnostic: CO6PR10MB5475:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5475A8E89A57DBA6B3C042C8F3E49@CO6PR10MB5475.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: zVrhY4Huk68bPeVCYr6GWRPLba3t6qYpWcGJ3TBt2105VGXbHwA4z2Qrmum9n8E3C1HxEz8hiD+7P96Oqs5t/lkD3/lMy1IytWq3Uaq+F8FbjD8hGyPwWBb449YDpVicb/b0VedjEd58pmGdcidWTRsctScPW/gKTD4vVni4OitSYjPAgtX9P9E7cPAjCjgJNDYjSoEek6jONeoV69WjFrw/y0EbsryWfHcL0zR8P6f/reHrEMh4aPQT+J/2GGkTDRK5uyYWChUd8D0xoOyRODUaJzPN1KTLgtmwIK5FZyG/nrcWsnOHaQ6rdovx1MHM/3ZlKbHO6sO6KwaFYIatQsRL+f47Oc+272n/uYPtFRLl1ddGponkrTX31MJ0oiv4Sq+V+6A7I912dfD9K7uevop/WFEHSqxSWR1hLAEwxJXHQCC//a4P3jPTVjB9rBBRT2l6VyRl8/4tEbbeZp8ccj51xfbMRbcvkrO8dqE34tEIu+Y8n4GcUB7HVkaNfkPZirwj85owNQGwzZLgQjDMGN9BAzWJyjCJRXLxWYwqESna0lJ1/nE78AGLnCDoO/vSoneVazPZRep4S7de4sFmSpz2TUDxx0hAduUXb78A+yHRBAEjPS6m7IPoZcrdzc5WflT50BCJmQCcYF6O9Pr7vclshh2FQJB7x08FLfHs6/vViKmE3z3A7sImD/AvtFEVyRKXBYMQwUaTlpjhzSc4tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(38100700002)(1076003)(186003)(2616005)(5660300002)(2906002)(316002)(6512007)(921005)(6486002)(8676002)(36756003)(6666004)(52116002)(6506007)(7416002)(508600001)(66946007)(8936002)(44832011)(83380400001)(66476007)(86362001)(66556008);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WoO3ybF/VyihrYBLovdEMunNnGRDzu2vREep3mS1pcNMoSBMzfY6Ot8dE60V?=
 =?us-ascii?Q?RIiyZpNVC+KoTfRGl3IIwudUzcYn0UGi610is48GQyk88YM0q0DcaDVGeOoH?=
 =?us-ascii?Q?PaDcyJyD+9mVCmRQXqh19hxeSQClcQ4eC+i85LmjaM/7+9BBFXdxzix+abw4?=
 =?us-ascii?Q?9rcsHSKPJENkPO1O5ujTTobnewgMT5xcYrJFo6cma60T/bXlYF8plIFr6AMr?=
 =?us-ascii?Q?g1dlJ2N+44JtT8AHeoaQg4+PHgnK2Jg0Qu5BIx45NwBDMoGlbzBNojI00JFa?=
 =?us-ascii?Q?v8eqfZYByK7R05300XKfRj7aDpajmfMk+n+WEZwA5kfQDUwPfelYEPDeyi00?=
 =?us-ascii?Q?ppA9th3KBARUMOfD1DgQNJbTzsH1EbIVIYqr8vTIwpkuPN9sTIrju768z2qp?=
 =?us-ascii?Q?ZMYhyhTbyQiNGHlxI5pIfobOhyQ1O+BE/19AEvHgio7L4s2oJ6uS8iG5iJsV?=
 =?us-ascii?Q?eg7Je1E4CsDOmcJV4f93cyQvNVkOh9h6err7qiEJTcvCm1+7qbWNm7LJeoGV?=
 =?us-ascii?Q?vdtJ2Ehg+zlsqpj66iDgd805sO415HRyayJTPc849IzVInHaWNFSQPkr4EN4?=
 =?us-ascii?Q?9fvnU+RmqPnqEyzRnIJWGwZeMTPRcFUZ7Bm5YTFJs2PPBbInARLPfE3v5TCp?=
 =?us-ascii?Q?H3JneRatSejqlPVwvOe/xlHYfMV1q1d3HkNjnRm4EwdrEneKupgJwYrShmsM?=
 =?us-ascii?Q?8iTd7PsTUOXSQFAZTTeUppmMCH+QExMsd9N0Bj5Gsbmz50pac4DboDVMNrwf?=
 =?us-ascii?Q?ipn70sV+iQ5TlEnZ98M4NnVjeEheMrnLftSjjfyg2CQYBDwwVnOri2eGoID6?=
 =?us-ascii?Q?1RxGPwwGmMOd2UNzSCg6E0e7wXei3PPaiaxr1xfA2wSqtHn50isT6IHdTCus?=
 =?us-ascii?Q?gOx0BQ75KtYLqvWPxgtEpChD9ZrdgOZcBbYfgzl0x5kX8Iyapg4flKO8FFes?=
 =?us-ascii?Q?nWGrqv+oyU3YKXeWbUFv3BMwEL+lhCXas4rabrwjcMNlXEhAewmEtujM4bGh?=
 =?us-ascii?Q?OxkGy5JJ1itMfFA8qVUAVlzr3NrxAANZgRAuUCWcEIcVfxhn0HGD5WGMFzF0?=
 =?us-ascii?Q?vF/hp84ZieiHeMrAXVFAAIpiCpm4Dm1I9ylmUo4MB18Ah6OL5oFzUa1decNy?=
 =?us-ascii?Q?5iTMTVq208laZTDuGy5sPYmiuU654Is98IrZJEE7qZKShuGROL//K5LpTo5y?=
 =?us-ascii?Q?CO1E8Oa+2JMh+1E7UjLsX4h9ocxuY+EQRlMakSe7i6n68KjcCHJW+nDjUTND?=
 =?us-ascii?Q?kNZZZfzbFrmzUsv39gu3rYgpoqV7Fm6VJw/D5R0fyFXRjK+/alpg0rSFBd69?=
 =?us-ascii?Q?qiKvFMqEIWRpEcHBIT+nzIyMiIzAjiVtisk17dzngy1dHTba8t3V8FAB42rS?=
 =?us-ascii?Q?e0jQ+ACqy6g7TUF3sTwUZlkxkyQeG+orHMGMmrJDdAkHRatYpjbrzuuSi6h+?=
 =?us-ascii?Q?GI/VrFv9C5VkE+q0ggEe7LASagM+hnGKSUwrxIL+4w1rUvyvyJZ/xMCxgTRk?=
 =?us-ascii?Q?QvK0qGJFq8GfKPAHydqgHkc3Fdw9jEyrU1p3WbcxLCQ5sH2xrSSvuirfD16Q?=
 =?us-ascii?Q?/hOfA1UBeF3DBaLClmH1u25qvpxfz5gbsc8CTukqTV/kleVHWHzwliNiYEAb?=
 =?us-ascii?Q?XkIPsN2NpP8VXgZIssi20EhqR7wFHfpyeqKkFuWP8QP+PTfDvvbmMRe1SKqW?=
 =?us-ascii?Q?JNZ9I5yf0a1sob2ZOWm+AsAkbdIUf7mCAqdOk0pvV4GKf8OSeOobAXcC+uOv?=
 =?us-ascii?Q?DZm900DeHwQON2FaknFUYuqa7w5ZEPY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8958e909-0d82-477c-235c-08da173d3cdd
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 19:48:20.9946 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BaCXkR24KiRHGSp4/4r/417osLj1ARCpXBbByJdiPWG8YdHyPZkBUtApx8da5YNPeah2Aaqg1bNphXbkHbsauA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5475
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-05_06:2022-04-04,
 2022-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204050110
X-Proofpoint-ORIG-GUID: _iOh065JPjAycjhgrELglKAqqHfZIujT
X-Proofpoint-GUID: _iOh065JPjAycjhgrELglKAqqHfZIujT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v7 2/6] x86/mce: relocate set{clear}_mce_nospec()
 functions
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Relocate the twin mce functions to arch/x86/mm/pat/set_memory.c
file where they belong.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 arch/x86/include/asm/set_memory.h | 52 -------------------------------
 arch/x86/mm/pat/set_memory.c      | 47 ++++++++++++++++++++++++++++
 include/linux/set_memory.h        |  9 +++---
 3 files changed, 52 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 78ca53512486..b45c4d27fd46 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -86,56 +86,4 @@ bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
 
-#ifdef CONFIG_X86_64
-/*
- * Prevent speculative access to the page by either unmapping
- * it (if we do not require access to any part of the page) or
- * marking it uncacheable (if we want to try to retrieve data
- * from non-poisoned lines in the page).
- */
-static inline int set_mce_nospec(unsigned long pfn, bool unmap)
-{
-	unsigned long decoy_addr;
-	int rc;
-
-	/* SGX pages are not in the 1:1 map */
-	if (arch_is_platform_page(pfn << PAGE_SHIFT))
-		return 0;
-	/*
-	 * We would like to just call:
-	 *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
-	 * but doing that would radically increase the odds of a
-	 * speculative access to the poison page because we'd have
-	 * the virtual address of the kernel 1:1 mapping sitting
-	 * around in registers.
-	 * Instead we get tricky.  We create a non-canonical address
-	 * that looks just like the one we want, but has bit 63 flipped.
-	 * This relies on set_memory_XX() properly sanitizing any __pa()
-	 * results with __PHYSICAL_MASK or PTE_PFN_MASK.
-	 */
-	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
-
-	if (unmap)
-		rc = set_memory_np(decoy_addr, 1);
-	else
-		rc = set_memory_uc(decoy_addr, 1);
-	if (rc)
-		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
-	return rc;
-}
-#define set_mce_nospec set_mce_nospec
-
-/* Restore full speculative operation to the pfn. */
-static inline int clear_mce_nospec(unsigned long pfn)
-{
-	return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
-}
-#define clear_mce_nospec clear_mce_nospec
-#else
-/*
- * Few people would run a 32-bit kernel on a machine that supports
- * recoverable errors because they have too much memory to boot 32-bit.
- */
-#endif
-
 #endif /* _ASM_X86_SET_MEMORY_H */
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 38af155aaba9..93dde949f224 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1925,6 +1925,53 @@ int set_memory_wb(unsigned long addr, int numpages)
 }
 EXPORT_SYMBOL(set_memory_wb);
 
+#ifdef CONFIG_X86_64
+/*
+ * Prevent speculative access to the page by either unmapping
+ * it (if we do not require access to any part of the page) or
+ * marking it uncacheable (if we want to try to retrieve data
+ * from non-poisoned lines in the page).
+ */
+int set_mce_nospec(unsigned long pfn, bool unmap)
+{
+	unsigned long decoy_addr;
+	int rc;
+
+	/* SGX pages are not in the 1:1 map */
+	if (arch_is_platform_page(pfn << PAGE_SHIFT))
+		return 0;
+	/*
+	 * We would like to just call:
+	 *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
+	 * but doing that would radically increase the odds of a
+	 * speculative access to the poison page because we'd have
+	 * the virtual address of the kernel 1:1 mapping sitting
+	 * around in registers.
+	 * Instead we get tricky.  We create a non-canonical address
+	 * that looks just like the one we want, but has bit 63 flipped.
+	 * This relies on set_memory_XX() properly sanitizing any __pa()
+	 * results with __PHYSICAL_MASK or PTE_PFN_MASK.
+	 */
+	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
+
+	if (unmap)
+		rc = set_memory_np(decoy_addr, 1);
+	else
+		rc = set_memory_uc(decoy_addr, 1);
+	if (rc)
+		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
+	return rc;
+}
+
+/* Restore full speculative operation to the pfn. */
+int clear_mce_nospec(unsigned long pfn)
+{
+	return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
+}
+EXPORT_SYMBOL_GPL(clear_mce_nospec);
+
+#endif
+
 int set_memory_x(unsigned long addr, int numpages)
 {
 	if (!(__supported_pte_mask & _PAGE_NX))
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index f36be5166c19..d6263d7afb55 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -42,20 +42,21 @@ static inline bool can_set_direct_map(void)
 #endif
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
-#ifndef set_mce_nospec
+#ifdef CONFIG_X86_64
+int set_mce_nospec(unsigned long pfn, bool unmap);
+int clear_mce_nospec(unsigned long pfn);
+#else
 static inline int set_mce_nospec(unsigned long pfn, bool unmap)
 {
 	return 0;
 }
-#endif
-
-#ifndef clear_mce_nospec
 static inline int clear_mce_nospec(unsigned long pfn)
 {
 	return 0;
 }
 #endif
 
+
 #ifndef CONFIG_ARCH_HAS_MEM_ENCRYPT
 static inline int set_memory_encrypted(unsigned long addr, int numpages)
 {
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

