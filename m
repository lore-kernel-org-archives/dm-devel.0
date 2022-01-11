Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE21C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 11 Jan 2022 21:23:00 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-9e8M4FeBNLmrcADEwXjlDg-1; Tue, 11 Jan 2022 16:22:55 -0500
X-MC-Unique: 9e8M4FeBNLmrcADEwXjlDg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58B1510151E6;
	Tue, 11 Jan 2022 21:22:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 03F8260BD8;
	Tue, 11 Jan 2022 21:22:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 476CF1809CB8;
	Tue, 11 Jan 2022 21:22:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20BLMJsN024477 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 11 Jan 2022 16:22:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2179A40FF696; Tue, 11 Jan 2022 21:22:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1972640FF690
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 21:22:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA5DC2A5955B
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 21:22:18 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-515-Z77LAEChM6ijkZZHmoKbeA-3; Tue, 11 Jan 2022 16:22:13 -0500
X-MC-Unique: Z77LAEChM6ijkZZHmoKbeA-3
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	20BI1gGG032060; Tue, 11 Jan 2022 19:00:05 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dgkhx43bt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jan 2022 19:00:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20BIpdaw111017;
	Tue, 11 Jan 2022 19:00:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
	by userp3020.oracle.com with ESMTP id 3df42n7ddb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jan 2022 19:00:03 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB4814.namprd10.prod.outlook.com (2603:10b6:a03:2d5::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11;
	Tue, 11 Jan 2022 19:00:00 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::6814:f6c:b361:7071]) by SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::6814:f6c:b361:7071%8]) with mapi id 15.20.4867.012;
	Tue, 11 Jan 2022 19:00:00 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Tue, 11 Jan 2022 11:59:28 -0700
Message-Id: <20220111185930.2601421-6-jane.chu@oracle.com>
In-Reply-To: <20220111185930.2601421-1-jane.chu@oracle.com>
References: <20220111185930.2601421-1-jane.chu@oracle.com>
X-ClientProxiedBy: BY3PR04CA0005.namprd04.prod.outlook.com
	(2603:10b6:a03:217::10) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79305477-d77e-47d0-0d3f-08d9d5349173
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4814:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4814F909CC10B743F09EE566F3519@SJ0PR10MB4814.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ywZVXIhLG+ew/cAmlA0c6eazzcPbYOd1aW082TbGKZ9750ncUnMTS1b/pY0LKAQHryY2eJerwvd6XDlV8sfYdlQ+/U09ch3QdI/jCOr4uyrWlk2Zrsg3xt3xvGhBeQNjQ8ThOjk9FTZ7ZrR7wLQapX2lLhNQUhA3VD6cjJzVX0TgxssP/KsebSbSoqj7pQrXvZ+mOlePGxPmHp8TfvuhvdeK4t/OnJGK7cgDQy69hw5Ruod6cfQR1dU8rB6fZZLmOVMzpiU/+E9XvgeHx/pJbGmYFDFXRHRCsg8qt4Yiev9PZ2SaXX5qSLGSg2oN2gE1zb1QFWwpfxwtPuR2zh2r1aXbu1+PRKAeNS/vf5F0+Kbiuv8lzhcXxj6gl/4+OUfmbc42ayieGKN4LTJ3V3l7k/ClG5ivBAyLhg97xNYpT3AExfAuNXSp49nUO3UGGk8eBvPt/vxxIlXUKvytAAwh5unD+LQlJHqlkqYzO3e5StpGUchELKqJrOIV+yiWh6okBif1xFzW4LPhHRSwO7ClcRfdlxMZWBeZc7AcW2iYLAF2741BXKfPAt+xsyrVAiYU31eMlmjb64kSChJZMg4Jvz+q99ero1zJghPAaq1mKx2xpr59Hp9CQmQmJzw+OfOGVUGP9EDhaY/lO0GPaBAAK0UrK3OU4F4pYJyGyP9cRPqXM3LhkUrPvaEX3d7sa/dF
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8936002)(921005)(38100700002)(44832011)(186003)(6506007)(7416002)(66476007)(66556008)(66946007)(316002)(6666004)(2616005)(8676002)(86362001)(2906002)(6512007)(6486002)(1076003)(5660300002)(508600001)(83380400001)(36756003)(52116002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4od3/QrSOKH94v5CtRL1ZiUHvNlJEnTNr+vftThGARF5VX+ZbjOpBPKJdfv4?=
	=?us-ascii?Q?Daw2rgghi3RtqnKugLpoqZgXd6qxPxjWUhGHrB8NUq9IaYUY9oiPO4b+Akd9?=
	=?us-ascii?Q?8DVnJ2azCYcqe8UXXe73j77imXAjwaq20nC8Eox1yUS8YKGS2UpWUDUGNETA?=
	=?us-ascii?Q?US9DYygxpyFJccrov6OQUl6TZk9uO+l0f/KBc9rzCfuYqlCe7Ol9aTpjptCn?=
	=?us-ascii?Q?5sUolVqoFM0ZZ8gykUaeX4SI7WE6Rvklsel3hlQMsqhVfT1BuRKGcjvwUjPB?=
	=?us-ascii?Q?0Y2nhGnJ1O2Qk18qhPps4NSq3yrttjSXyaS+VP4+RSFP7FX0MxPwE/DMCVdf?=
	=?us-ascii?Q?lSr6890Cl/H6yuRkqL/FnaDfdus37oz9HeLU4aI8T2e3qXURvUyO51hCRPGh?=
	=?us-ascii?Q?T3LOB4hoQgo0xsmqUzMNEhfoNva992nbe6BRc86Z0B+M5EspGUWfmLXqlPJh?=
	=?us-ascii?Q?h6yFzmVWq0QMiDY3wTIYA3LJPv5tuPvarXDhdrhRuBwdplYC1vd/2UNb5Mtt?=
	=?us-ascii?Q?nGhM8NRC3T2UiZXYpnMClRNwBEA1Y04CvD0JFyCfhZrK3cvMysu2QCKU5E7B?=
	=?us-ascii?Q?YuT1fs54XuG0qiB+9qMTOqhCS1FcLK1DVWl0gm1w7KVR9Kjzpk0pk/Z1DmhI?=
	=?us-ascii?Q?/uxjEsqv+XeO4ISROFMjdxxQ+t7SqS6XjciG9MrdnifIkG7sa9QK+Z9C2SRV?=
	=?us-ascii?Q?2Exiy3VbZixMLn4f+mfX2ejnO5MOMm0AtN9Wx/K0ZHZm8g7673FLkQMIMVbx?=
	=?us-ascii?Q?WQsjxJuH7T3jI2aFdkm/6JDzpyWewZFkD6Fov8yJkXjjibG4nIZ6mUy7LFUv?=
	=?us-ascii?Q?tlBIzpb3tVzymcIY2QgKbBK8bKJourB+fWle0VhxRzL7iJGsU4htKGG94E0E?=
	=?us-ascii?Q?KfoqNdVg8o+5NeU1HsRUF7QWjwTbB3DSgANRvxcXxCANBQXHHBOzzQybs8bE?=
	=?us-ascii?Q?OZ1jVOcKo1jXwpsCCQKAwGSvI08AxJsd8CBydSr8sjktFtaCz27SP/+ayWcx?=
	=?us-ascii?Q?GGc72AmJXd7ptE6efBL9VGSqmyV0fvn4QP0Zc8R5XSdEi8VOwl4LzAxBm19z?=
	=?us-ascii?Q?M+Mbeghrs8sFm2TlIKdwwHUoH8uPyHuNrfTBaiGG6SJDOTkMc95LC72UzQ7z?=
	=?us-ascii?Q?/KIE6ppnJXh+0NZ8J1nb3mRK2hNX/NW49pRbwZfZMRDSq9TPP0x+OUCLzqM9?=
	=?us-ascii?Q?Z22nIF3FBSt/zIgRDKrDWhh4sPQfPdVHchQUk27lTaMMe3i4jKJSJ77NY9OM?=
	=?us-ascii?Q?eMWe9PTn2RZT/q128LapkifwB6O008Uwl8o0pgG2SbPd9liiXJPSnSWUkW3m?=
	=?us-ascii?Q?qkot2/PKI8XqiUnYR5+XuHHBKSgIVKmXya6Rf+UO/yiRRDzlHT/W06/aW5tH?=
	=?us-ascii?Q?TkcMhGbnd7U/O+mn6hd9EwsSiBOD+sts77uvwJQsi1VgrgmwUaEPyPvxThhM?=
	=?us-ascii?Q?Ol7vncvXIIx5yCRYSaT0pHWu7EXgqhBOBqQtzoYmaAP+Lq7T/Y98fwtPEL5+?=
	=?us-ascii?Q?9njt5znKmTcqvaOma2fT1jVmHYQNASG+K3WsaMU1RsytbVPHLTenhiFVZxdM?=
	=?us-ascii?Q?rNxvNFJnObJQ2/ZQpBjviEcZy2HanBaB9TmIH2ijs4PaDHfwevhlYdh8FH0t?=
	=?us-ascii?Q?MMpcxd5fYMQlPD5bPl8ghaJXcPnleGhsVXVvNt3CGndF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79305477-d77e-47d0-0d3f-08d9d5349173
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 19:00:00.7118 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mwojBZ5EzuxzE1N+jMO1krTecJoaYDOnXWjqmN2ixDweMnf1gGq0I5M6zsyaroIEZKCVXDDOIzQLPxMam1wPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4814
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10224
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	mlxscore=0 phishscore=0
	mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2201110101
X-Proofpoint-GUID: WCkMvk99iqFEf7Lx5pXzx76cYIwQm5xn
X-Proofpoint-ORIG-GUID: WCkMvk99iqFEf7Lx5pXzx76cYIwQm5xn
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v3 5/7] pmem: add pmem_recovery_write() dax op
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

pmem_recovery_write() consists of clearing poison via DSM,
clearing page HWPoison bit, re-state _PAGE_PRESENT bit,
cacheflush, write, and finally clearing bad-block record.

A competing pread thread is held off during recovery write
by the presence of bad-block record. A competing recovery_write
thread is serialized by a lock.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/nvdimm/pmem.c | 84 +++++++++++++++++++++++++++++++++++++++----
 drivers/nvdimm/pmem.h |  1 +
 2 files changed, 79 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index a68e7d3ed27e..dd2db4905c85 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -69,6 +69,14 @@ static void hwpoison_clear(struct pmem_device *pmem,
 	}
 }
 
+static void pmem_clear_badblocks(struct pmem_device *pmem, sector_t sector,
+				long cleared_blks)
+{
+	badblocks_clear(&pmem->bb, sector, cleared_blks);
+	if (pmem->bb_state)
+		sysfs_notify_dirent(pmem->bb_state);
+}
+
 static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
 		phys_addr_t offset, unsigned int len)
 {
@@ -88,9 +96,7 @@ static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
 		dev_dbg(dev, "%#llx clear %ld sector%s\n",
 				(unsigned long long) sector, cleared,
 				cleared > 1 ? "s" : "");
-		badblocks_clear(&pmem->bb, sector, cleared);
-		if (pmem->bb_state)
-			sysfs_notify_dirent(pmem->bb_state);
+		pmem_clear_badblocks(pmem, sector, cleared);
 	}
 
 	arch_invalidate_pmem(pmem->virt_addr + offset, len);
@@ -257,10 +263,15 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
+	bool bad_pmem;
+	bool do_recovery = false;
 	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
 
-	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
-					PFN_PHYS(nr_pages))))
+	bad_pmem = is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
+					PFN_PHYS(nr_pages));
+	if (bad_pmem && kaddr)
+		do_recovery = dax_recovery_started(pmem->dax_dev, kaddr);
+	if (bad_pmem && !do_recovery)
 		return -EIO;
 
 	if (kaddr)
@@ -319,10 +330,70 @@ static size_t pmem_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 	return _copy_mc_to_iter(addr, bytes, i);
 }
 
+/*
+ * The recovery write thread started out as a normal pwrite thread and
+ * when the filesystem was told about potential media error in the
+ * range, filesystem turns the normal pwrite to a dax_recovery_write.
+ *
+ * The recovery write consists of clearing poison via DSM, clearing page
+ * HWPoison bit, reenable page-wide read-write permission, flush the
+ * caches and finally write.  A competing pread thread needs to be held
+ * off during the recovery process since data read back might not be valid.
+ * And that's achieved by placing the badblock records clearing after
+ * the completion of the recovery write.
+ *
+ * Any competing recovery write thread needs to be serialized, and this is
+ * done via pmem device level lock .recovery_lock.
+ */
 static size_t pmem_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	return 0;
+	size_t rc, len, off;
+	phys_addr_t pmem_off;
+	struct pmem_device *pmem = dax_get_private(dax_dev);
+	struct device *dev = pmem->bb.dev;
+	sector_t sector;
+	long cleared, cleared_blk;
+
+	mutex_lock(&pmem->recovery_lock);
+
+	/* If no poison found in the range, go ahead with write */
+	off = (unsigned long)addr & ~PAGE_MASK;
+	len = PFN_PHYS(PFN_UP(off + bytes));
+	if (!is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
+		rc = _copy_from_iter_flushcache(addr, bytes, i);
+		goto write_done;
+	}
+
+	/* Not page-aligned range cannot be recovered */
+	if (off || !(PAGE_ALIGNED(bytes))) {
+		dev_warn(dev, "Found poison, but addr(%p) or bytes(%#lx) not page aligned\n",
+			addr, bytes);
+		rc = (size_t) -EIO;
+		goto write_done;
+	}
+
+	pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
+	sector = (pmem_off - pmem->data_offset) / 512;
+	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + pmem_off, len);
+	cleared_blk = cleared / 512;
+	if (cleared_blk > 0) {
+		hwpoison_clear(pmem, pmem->phys_addr + pmem_off, cleared);
+	} else {
+		dev_warn(dev, "pmem_recovery_write: cleared_blk: %ld\n",
+			cleared_blk);
+		rc = (size_t) -EIO;
+		goto write_done;
+	}
+	arch_invalidate_pmem(pmem->virt_addr + pmem_off, bytes);
+
+	rc = _copy_from_iter_flushcache(addr, bytes, i);
+
+	pmem_clear_badblocks(pmem, sector, cleared_blk);
+
+write_done:
+	mutex_unlock(&pmem->recovery_lock);
+	return rc;
 }
 
 static const struct dax_operations pmem_dax_ops = {
@@ -514,6 +585,7 @@ static int pmem_attach_disk(struct device *dev,
 		goto out_cleanup_dax;
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	set_dax_recovery(dax_dev);
+	mutex_init(&pmem->recovery_lock);
 	pmem->dax_dev = dax_dev;
 
 	rc = device_add_disk(dev, disk, pmem_attribute_groups);
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 59cfe13ea8a8..971bff7552d6 100644
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

