Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1278DC433FE
	for <dm-devel@archiver.kernel.org>; Tue,  5 Apr 2022 19:49:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-kGTDusVeMV6lNtlDhrQ8dw-1; Tue, 05 Apr 2022 15:48:58 -0400
X-MC-Unique: kGTDusVeMV6lNtlDhrQ8dw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD620800B28;
	Tue,  5 Apr 2022 19:48:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B74371415105;
	Tue,  5 Apr 2022 19:48:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 524491940369;
	Tue,  5 Apr 2022 19:48:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 27F0E1947BBD
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Apr 2022 19:48:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 19FD4404D918; Tue,  5 Apr 2022 19:48:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 14A13405D4CC
 for <dm-devel@redhat.com>; Tue,  5 Apr 2022 19:48:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAB3B833960
 for <dm-devel@redhat.com>; Tue,  5 Apr 2022 19:48:54 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-TacVQg6DMr28MMDDhvwNrA-1; Tue, 05 Apr 2022 15:48:51 -0400
X-MC-Unique: TacVQg6DMr28MMDDhvwNrA-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235JGp2P005378; 
 Tue, 5 Apr 2022 19:48:34 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6d92y2a9-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 05 Apr 2022 19:48:34 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 235JahLx014819; Tue, 5 Apr 2022 19:48:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3f6cx3vtua-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 05 Apr 2022 19:48:33 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BN6PR10MB1425.namprd10.prod.outlook.com (2603:10b6:404:42::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 19:48:30 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%7]) with mapi id 15.20.5123.030; Tue, 5 Apr 2022
 19:48:30 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
 hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
 ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, x86@kernel.org
Date: Tue,  5 Apr 2022 13:47:46 -0600
Message-Id: <20220405194747.2386619-6-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-1-jane.chu@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
X-ClientProxiedBy: SA9PR13CA0054.namprd13.prod.outlook.com
 (2603:10b6:806:22::29) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fe97c7e-e48e-4e29-3b9a-08da173d4293
X-MS-TrafficTypeDiagnostic: BN6PR10MB1425:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1425EFD003BE4B276C2F229FF3E49@BN6PR10MB1425.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: AqC9BEK1SvDIhjjVI+HTMSOEAHBJzgYaAtH0O4HvsxXXnQW9JBb1l2w+1UMNyNk8eWVRbIJh7VTPLxmJyP7CTpsCnaHVXy8LS3I+0WPfImrNEPgPlp7XKcCASVCg/oT4NJQVRAqqh5CQjAAbszctTY9SmT0+lnGmawZfucX8HGKsZ2UDb++dOmEbVCzdG/d1HWAFvPmIbzrU3mYg5qhefJrMi4F1/6OVhmpfXZok5GxpIJOYBrb9aII4zByAYNvkYkclnLwz+HEWzYK0oG8lzZZvTGR+yTLMro/0twnstGOcA19XivP1rp68h8aRcA+U+65xXOMQvgBRLoPfQP5yeHOJxxKWKwsFFZqTf162VKTHOocB5jdlzZnHEJJ/egDTmM56ArcVBXPmxieBPbLQfaYA0WpSKhvLESOpQbgHn5Iaci1GnhMyGj5wjwoHUuev0UoTJR/4Akav3zFSj/21jwh1sL1K3Lvqmva1b3Bp5SOv9gq7AafOJDT5zRnMTyeZS1Z+G9WdSaqL5Bck3pD6kooxMV/ep0/PZ2aPQs4Dx67pKDpE5J5QD3evvkPbzmoWEe/PAPLOrh23ja5PxBaP+NOnRJMX9HupqVSEbwS1DML0C0eu6r7UbXNC8XY7/U4r6bHmLEU0HxFgBuKzlEndJnCGcmk/gikpp1WRt9EuCqc05kNZEx390KLbHro2xxf6
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8936002)(66946007)(5660300002)(86362001)(44832011)(36756003)(921005)(83380400001)(6666004)(2906002)(38100700002)(66556008)(6506007)(2616005)(8676002)(508600001)(66476007)(186003)(7416002)(1076003)(6486002)(52116002)(6512007)(316002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?05dkk6zdBq3xw0qjHlA6bIEV6hirG6IlMTwpd4rH4XDNzeyvj/VZWD/gt8l/?=
 =?us-ascii?Q?AAwGKVuhmtNaUdhYH8AkKpHMHxR4HWYMS/5PnixpZILhWPxRjHAoovAq03iT?=
 =?us-ascii?Q?k3P5FNhET1TVYLG92x4VwEF/5PyS3Iu4ELussZOi70GO41RXi90Hj9m3XSYL?=
 =?us-ascii?Q?gyHJ6cKrYR9Doye3anmMx9fGELJBYYY9PaD6Wv9GDjiIKO2k4A7wBaP0wx8m?=
 =?us-ascii?Q?oNgf34ThDzzv0PNv/9iD5AdQcDmPcIvXr1uEM8Z/dCkAWr/fF7yFSLA6QMWG?=
 =?us-ascii?Q?Mytbiy+R0BKvuG7hZKYVXfUWlZWfG5zBFQAvnYhYXJTOmQ1XHcvV2U5VE2m6?=
 =?us-ascii?Q?aagGJvGKUBK8gIVXMFG3uvMFP71A+Kginpqt11hEvncMrYcWZgc2oBoOWtz4?=
 =?us-ascii?Q?2vspoYksUxRUqvN7la00S8vAfuthQSUhzebQFcHhXSUpwaDk5cKl4Erfcsxe?=
 =?us-ascii?Q?9oOHVJJxC6uza8mJXgeygZUmIJlmQufasiJPZ476GvtPb/j/xTrJenTrXxIs?=
 =?us-ascii?Q?K5BRf/NRLJMVehucZRi0zrzatKh2Ae+ZWBqdjgnHzGMqYByfaBpiHD0iXKjU?=
 =?us-ascii?Q?dDffKZQs/v+E0vaymq6b7LP3wci/VgRURhxKy1jBss3TJyhkmoI/o1NsFrIU?=
 =?us-ascii?Q?f8gtxbacuT4VcI39V5eacVz8HXYsZrObOz5amhAp4Vog6JZJk57IS3CECxYk?=
 =?us-ascii?Q?7T29/I5QU4bxELBocn2IUIZQWxbD3WXbQtHtSz1kOFRzRyVowZRDqCvxkcRK?=
 =?us-ascii?Q?x4vdq2GxLBgtIruKEtjQZttPSAkeGg2sADt8rxaA6Dh3ClniNBBsoI5oVa2l?=
 =?us-ascii?Q?4iaP0G6VEl0G/qOR99L9Sheel3oueCz3Y31Wcot7RgRIfxEtH5lkKlcxm3NF?=
 =?us-ascii?Q?9iELIkxMK9S+fIZK+iKSKllbzPktYW/GwHJGBDx+KSf/ytP46TN5FjMHwK2/?=
 =?us-ascii?Q?a3/gCzV+Ue/dXwp3DQTo75UktKBT4UWYJV8dL/7I+U73f4E5WAjfL+NoC1zq?=
 =?us-ascii?Q?KQx5HLzOcoo9YlnGw/IPWVVbKB5McYBIett/Uax60jZogaMJ7nwYPwoShHAH?=
 =?us-ascii?Q?fvGXV1uFMSU7qjzCuLVxbuoR41Ye7udxad3Q5Vb3WWqLV0UcL/7Is1S1WOr8?=
 =?us-ascii?Q?NGW5BNtbC8A9xLbye+zGcOtqt+mBeGNFzzXPD05havgMNhZEQJXQl0nSisnD?=
 =?us-ascii?Q?mhlkGUqeLF5BuEhEXii80aRHQyJyviRu/l2KxD012FYQ+7/xmlgBABOcO9fz?=
 =?us-ascii?Q?nZjL9cdj0a55naBQa6xOgau9civMmUzPHFX182Hc6FoSJgVUfX3umEwzNwwI?=
 =?us-ascii?Q?tCzM2siXtRur9NxR4Oz4M4i6j70K9rnEp1Nuei9ZFqqF3a2aiRRdJ+R/eGoq?=
 =?us-ascii?Q?rDlwqStv70CmLsnJW5f8+ch5FG/nobRwrvEl3gL87kOIYB6Lwim0mvWQh0zt?=
 =?us-ascii?Q?UzPDWgLqPHvi+PcrWKhtfj53TwWrVZ9jOY/i1HQrb2qzFxGhi4+bbJujL+ES?=
 =?us-ascii?Q?0AFYnp33CYvMgwlBp5AjwRFzoIQHd+btKDcd2kqBRjEelnwifNyl5M+a7b3M?=
 =?us-ascii?Q?Nj2l9N3nKsl3AlA7zzcPDMTRAHVch2FhBLsKLbf9ywILNCk7hN5+9J6c3p6q?=
 =?us-ascii?Q?HLgex6bZHr+4kD3cgVsBvbQFKf9WQPbiI+qG3/LhCHNdGNlf2r9RapvWNx+w?=
 =?us-ascii?Q?z7dcDEOpMkuL+tzg0iY7ys9j7IGXGlAFxQHVaah4HSuThe4pdVKLO6KmWsOX?=
 =?us-ascii?Q?BuvgwTDKDdD03wXtyR/FZkn5RbI1TUU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe97c7e-e48e-4e29-3b9a-08da173d4293
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 19:48:30.5766 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Wg+pPhO0zYn/v6iId7YP9V3iC1wwGNOvHwNZSfqkIp6+szEXB3T61K/K+loIs2i4Heq+Ht3JFSo/MIFO65juQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1425
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-05_06:2022-04-04,
 2022-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204050110
X-Proofpoint-ORIG-GUID: JDYBCsxZwNVLAsoHyw8V7_VmdTdO90UY
X-Proofpoint-GUID: JDYBCsxZwNVLAsoHyw8V7_VmdTdO90UY
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v7 5/6] pmem: refactor pmem_clear_poison()
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Refactor the pmem_clear_poison() in order to share common code
later.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/nvdimm/pmem.c | 78 ++++++++++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 26 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 0400c5a7ba39..56596be70400 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -45,10 +45,27 @@ static struct nd_region *to_region(struct pmem_device *pmem)
 	return to_nd_region(to_dev(pmem)->parent);
 }
 
-static void hwpoison_clear(struct pmem_device *pmem,
-		phys_addr_t phys, unsigned int len)
+static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
 {
+	return (pmem->phys_addr + offset);
+}
+
+static sector_t to_sect(struct pmem_device *pmem, phys_addr_t offset)
+{
+	return (offset - pmem->data_offset) >> SECTOR_SHIFT;
+}
+
+static phys_addr_t to_offset(struct pmem_device *pmem, sector_t sector)
+{
+	return ((sector << SECTOR_SHIFT) + pmem->data_offset);
+}
+
+static void pmem_clear_hwpoison(struct pmem_device *pmem, phys_addr_t offset,
+		unsigned int len)
+{
+	phys_addr_t phys = to_phys(pmem, offset);
 	unsigned long pfn_start, pfn_end, pfn;
+	unsigned int blks = len >> SECTOR_SHIFT;
 
 	/* only pmem in the linear map supports HWPoison */
 	if (is_vmalloc_addr(pmem->virt_addr))
@@ -67,35 +84,44 @@ static void hwpoison_clear(struct pmem_device *pmem,
 		if (test_and_clear_pmem_poison(page))
 			clear_mce_nospec(pfn);
 	}
+
+	dev_dbg(to_dev(pmem), "%#llx clear %u sector%s\n",
+		(unsigned long long) to_sect(pmem, offset), blks,
+		blks > 1 ? "s" : "");
 }
 
-static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
+static void pmem_clear_bb(struct pmem_device *pmem, sector_t sector, long blks)
+{
+	if (blks == 0)
+		return;
+	badblocks_clear(&pmem->bb, sector, blks);
+	if (pmem->bb_state)
+		sysfs_notify_dirent(pmem->bb_state);
+}
+
+static long __pmem_clear_poison(struct pmem_device *pmem,
 		phys_addr_t offset, unsigned int len)
 {
-	struct device *dev = to_dev(pmem);
-	sector_t sector;
-	long cleared;
-	blk_status_t rc = BLK_STS_OK;
-
-	sector = (offset - pmem->data_offset) / 512;
-
-	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
-	if (cleared < len)
-		rc = BLK_STS_IOERR;
-	if (cleared > 0 && cleared / 512) {
-		hwpoison_clear(pmem, pmem->phys_addr + offset, cleared);
-		cleared /= 512;
-		dev_dbg(dev, "%#llx clear %ld sector%s\n",
-				(unsigned long long) sector, cleared,
-				cleared > 1 ? "s" : "");
-		badblocks_clear(&pmem->bb, sector, cleared);
-		if (pmem->bb_state)
-			sysfs_notify_dirent(pmem->bb_state);
+	phys_addr_t phys = to_phys(pmem, offset);
+	long cleared = nvdimm_clear_poison(to_dev(pmem), phys, len);
+
+	if (cleared > 0) {
+		pmem_clear_hwpoison(pmem, offset, cleared);
+		arch_invalidate_pmem(pmem->virt_addr + offset, len);
 	}
+	return cleared;
+}
 
-	arch_invalidate_pmem(pmem->virt_addr + offset, len);
+static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
+		phys_addr_t offset, unsigned int len)
+{
+	long cleared = __pmem_clear_poison(pmem, offset, len);
 
-	return rc;
+	if (cleared < 0)
+		return BLK_STS_IOERR;
+
+	pmem_clear_bb(pmem, to_sect(pmem, offset), cleared >> SECTOR_SHIFT);
+	return (cleared < len) ? BLK_STS_IOERR : BLK_STS_OK;
 }
 
 static void write_pmem(void *pmem_addr, struct page *page,
@@ -143,7 +169,7 @@ static blk_status_t pmem_do_read(struct pmem_device *pmem,
 			sector_t sector, unsigned int len)
 {
 	blk_status_t rc;
-	phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
+	phys_addr_t pmem_off = to_offset(pmem, sector);
 	void *pmem_addr = pmem->virt_addr + pmem_off;
 
 	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
@@ -158,7 +184,7 @@ static blk_status_t pmem_do_write(struct pmem_device *pmem,
 			struct page *page, unsigned int page_off,
 			sector_t sector, unsigned int len)
 {
-	phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
+	phys_addr_t pmem_off = to_offset(pmem, sector);
 	void *pmem_addr = pmem->virt_addr + pmem_off;
 
 	if (unlikely(is_bad_pmem(&pmem->bb, sector, len))) {
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

