Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C169DC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jan 2022 21:12:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-9BDHLxDYNyOI53YTKquGpg-1; Wed, 26 Jan 2022 16:12:33 -0500
X-MC-Unique: 9BDHLxDYNyOI53YTKquGpg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A86211091DA4;
	Wed, 26 Jan 2022 21:12:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B88A10246E3;
	Wed, 26 Jan 2022 21:12:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 638CB4CA9B;
	Wed, 26 Jan 2022 21:12:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20QLC6GT026028 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 Jan 2022 16:12:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5BC0140CFD14; Wed, 26 Jan 2022 21:12:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5616D40CFD04
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 21:12:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 399DC811E78
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 21:12:06 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-317-6pUdP0rGPa-Q8TSguL1E7g-1; Wed, 26 Jan 2022 16:12:02 -0500
X-MC-Unique: 6pUdP0rGPa-Q8TSguL1E7g-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	20QKYe4J012687; Wed, 26 Jan 2022 21:11:53 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dsvmjfuxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jan 2022 21:11:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20QL5L5Z082550;
	Wed, 26 Jan 2022 21:11:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by aserp3030.oracle.com with ESMTP id 3dr7yjfe30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jan 2022 21:11:52 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BL0PR10MB3044.namprd10.prod.outlook.com (2603:10b6:208:33::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8;
	Wed, 26 Jan 2022 21:11:50 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%4]) with mapi id 15.20.4909.019;
	Wed, 26 Jan 2022 21:11:50 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Wed, 26 Jan 2022 14:11:14 -0700
Message-Id: <20220126211116.860012-6-jane.chu@oracle.com>
In-Reply-To: <20220126211116.860012-1-jane.chu@oracle.com>
References: <20220126211116.860012-1-jane.chu@oracle.com>
X-ClientProxiedBy: SA9PR13CA0112.namprd13.prod.outlook.com
	(2603:10b6:806:24::27) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ba1e0f2-5776-456c-b2af-08d9e1107808
X-MS-TrafficTypeDiagnostic: BL0PR10MB3044:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB3044DC768A7F55927DA761B7F3209@BL0PR10MB3044.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: mSX7M1y+qRiY6oc46GYihr1oGe1+ZKPi+N1kWMgujDqTcFMo1/HORmgfgk+fYmoL5am6VwiAbw9cEdD4kI7Lmr5GcxfCZs83PJIW0HRP0TR7EL5omFgynK6L2alwPb79wVEiZqsiRU4s9s1J38YMgQxSvwhpKwQZ6T/ZsOBa2U2tpenjDb1QzdFMJmliq0Yk8Glhq0T9VZYlA1Ave8xptG7HUKxEQbkNVDjHB4mT5/+/MI/nwQbQaso3J5iFeIGgPFRy8dRS8Y2HxCYc+8opU+7ZyCCYD7oiU/N1b6kWyUELBbTFtEyHS3rRAl8Rzft7k9lw8Jvj2Kz6kUbUcuSTIfh/e0V6wYP3c6gS97XwnW8xfXUfTW9q1D3CefSp1x4PapPqiyDaz4sPpMmUNTsp2IDOai0C+R68uuvg4GIXXIdZvOwJju1uaswG121+hsNFoGCcmOXEz9TUAgnEWxnwedfbMwNk1/59duCGSuRS7aJgMpxPIXJF3Hf4E8ApyESQPdJowW7xCgNzCoiLPNK+iBv9I6TPZYHnZ7MBBoo29C0237VQYM88R8LSQs3pGoGyhMDuao6Xfh45l8bdFBB+S8X5j1E01+OWdm8TWB7Zu6u9ORJYHfpUibYt0u5wBDyXJprOVdLHSa+bmaXYUIxTOhUfqPaE74InmrMdF7IXCbzY2FABgtRxlnfdpR5+/nmt
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(38100700002)(8676002)(36756003)(86362001)(1076003)(52116002)(83380400001)(921005)(7416002)(8936002)(2906002)(6666004)(186003)(508600001)(6486002)(5660300002)(44832011)(6506007)(2616005)(6512007)(66476007)(66946007)(66556008)(316002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ukApHDTAjjySXZBDSd6OX5x/teCnSO3nuA6aDNSOCaqXItQL+ENV8G2+dyec?=
	=?us-ascii?Q?wuQo/eFZjVne/kX9L685BX0KxXt5IbXxUJHFB3zePx/XnXWBnUnBEkikeqkm?=
	=?us-ascii?Q?MAlsCMSLzx8vFjJ7bBdG8MlXMHA8J44lyHP/Af2IhPDI9AwZnFIpK2QOsbLP?=
	=?us-ascii?Q?1yb4qzcbxpHVeZNAt3QIMAhcRIbaq2lFNjrAxAQ+4Br4iCGaH0mxdLX4Ucf7?=
	=?us-ascii?Q?dzuiWqccH/W1L4oYmVrepX5Q61CjyEMTP88qZ1okVqZNTjWjYCKCiJMkjErG?=
	=?us-ascii?Q?sfIfo7RoPdL1xVi5BqKDpGrqpZeoge6/Q3PYHQEpzKIXxhuR69zICKErO2Rh?=
	=?us-ascii?Q?MsWgx4dJL96Q/UuWTTuz7SbP+2VD+11LeF3iYcfvv+MEo9oN1EQNg06t0IZr?=
	=?us-ascii?Q?hbFSCz0gG49uVAb2MJk7J7lQnMiKxQ4SJMJggu/NwrcyvMYKmfeyNA1eg1mg?=
	=?us-ascii?Q?2xfyoAU+jfTjP/WkAYBn5o2bc9DcruPYER0Ezml6WPyONAuw4t8omF3jw6f2?=
	=?us-ascii?Q?HRbEObEhcdjWNlOPo6g72rZHWarN2NSkveOchY/EdvotaclNO/EPvHmalbZq?=
	=?us-ascii?Q?ChZRR1QI9ACcI05ifcA0zIJieVm6Z+33Lv6agq2buOMX0fxBb5qrbMpCo8L6?=
	=?us-ascii?Q?/MMubul/+bBwQImivghOf9suWwL/oF4d0QJOVwCf8zoTFh/QCjLOFLnBNRf2?=
	=?us-ascii?Q?6Me+uoEwYUZ9XQv3axvdWALpp2ncbaWc8RUMQIGLSie5uPxzaqWwdlOXq8BR?=
	=?us-ascii?Q?soOTXd3kLfIo4iPBQcm8TNPcSeaOXWksOLKvqfNe4B9TUMzmkgkeZG1fL5JZ?=
	=?us-ascii?Q?K9MzFZbpXL6iMwP9V1N9fMjnPmm8go+rDps2qfodv6NwlBWKSjSyJ9whULjJ?=
	=?us-ascii?Q?RjE5zOXaQJKnPlsWy3Wx/ymvDAL6RgedGKL+fqCgoiJo0eg4bK/NajHxpk7m?=
	=?us-ascii?Q?DMKwfHxMZ0LqLh64V068rEKO2Ev3C13sBwEeb7tr5EOAuh37K5fmFzXbEgVq?=
	=?us-ascii?Q?HqwsQ6TsLJk/NK2pDreJyILY+46Hi4i2FQyxpcrbI76gcakypejeTyy9Scw2?=
	=?us-ascii?Q?XdQ+lclEjpnZorNJIUx9CRArwyJMUVNMnKGfDBW03JnG1Wldq4QFAMSA399u?=
	=?us-ascii?Q?zPlwZxop6+eyFxJro/0jqX1KtTw+qAqx2qlD5JwE08Ulmi1yPnAhKo/1/2Ad?=
	=?us-ascii?Q?HHZiaUIBSzASwsM+qDH63M40MLk29bku/5oxyjzQJ68fsFdsKXidJoQqS3IY?=
	=?us-ascii?Q?ACMGYH+AMsmWdGoQdVQtWDXSwo1yPIk5GAg22wyF+WzSkgvc/hWSuI9PvBgv?=
	=?us-ascii?Q?q8j/M5XOUHmu1HmtYu2LPtvjT4PYWQaVn6Ffv+Pg4gnVkiz1PolE1EBLN7SX?=
	=?us-ascii?Q?XRVyANUBHBju9UFEIHo6C1ipXRbnejTWab4sFB3/JuP2idVtLbd4PvQK/GH1?=
	=?us-ascii?Q?f/vCIL+Yisv3CaE9zHLyR0aZ/vHdZg0Wze5bp1rkEVrUSAa76JU/RFB2q9lE?=
	=?us-ascii?Q?im4l4clOZ8XQzpl2vu9zLpHtUFiakgkM0x+9341RPUVxuwMm2QxGvsS5iFGL?=
	=?us-ascii?Q?rAPTwaaIEjdmI7Vos5YUp04tsJO1Yz5/jNwOW8jECyXIYVH4oSAjlR7XEF1S?=
	=?us-ascii?Q?Vn1Y8VeKrJqI9taPGGHZICwbSLKHuUiDg8PQcUC8tT7m?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ba1e0f2-5776-456c-b2af-08d9e1107808
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 21:11:50.0928 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AJ4uhETFemSmVaDlO9mJVlDV87LMn4JqzDGrPjloiDcc3HOuM6cT7/8ydmlnAJZcCflGL06vfQcyEoRAci7Ceg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3044
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10239
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	phishscore=0 bulkscore=0
	suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2201260122
X-Proofpoint-GUID: wKbf7r2juN7yBGE0IyQQdaPFOyuzfyJw
X-Proofpoint-ORIG-GUID: wKbf7r2juN7yBGE0IyQQdaPFOyuzfyJw
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
Subject: [dm-devel] [PATCH v4 5/7] pmem: add pmem_recovery_write() dax op
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

pmem_recovery_write() consists of clearing poison via DSM,
clearing page HWPoison bit, re-state _PAGE_PRESENT bit,
cacheflush, write, and finally clearing bad-block record.

A competing pread thread is held off during recovery write
by the presence of bad-block record. A competing recovery_write
thread is serialized by a lock.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/nvdimm/pmem.c | 82 +++++++++++++++++++++++++++++++++++++++----
 drivers/nvdimm/pmem.h |  1 +
 2 files changed, 77 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 638e64681db9..f2d6b34d48de 100644
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
+				PFN_PHYS(nr_pages));
+	if (bad_pmem && kaddr)
+		do_recovery = dax_recovery_started(pmem->dax_dev, kaddr);
+	if (bad_pmem && !do_recovery)
 		return -EIO;
 
 	if (kaddr)
@@ -301,10 +312,68 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
 	return __pmem_direct_access(pmem, pgoff, nr_pages, kaddr, pfn);
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
+	rc = _copy_from_iter_flushcache(addr, bytes, i);
+	pmem_clear_badblocks(pmem, sector, cleared_blk);
+
+write_done:
+	mutex_unlock(&pmem->recovery_lock);
+	return rc;
 }
 
 static const struct dax_operations pmem_dax_ops = {
@@ -495,6 +564,7 @@ static int pmem_attach_disk(struct device *dev,
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

