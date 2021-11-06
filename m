Return-Path: <SRS0=0/af=PZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED56FC433EF
	for <dm-devel@archiver.kernel.org>; Sat,  6 Nov 2021 18:07:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 84B04603E8
	for <dm-devel@archiver.kernel.org>; Sat,  6 Nov 2021 18:07:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 84B04603E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-iCXVPthyOhGhL9aPrDfEUA-1; Sat, 06 Nov 2021 14:06:59 -0400
X-MC-Unique: iCXVPthyOhGhL9aPrDfEUA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C659C87D541;
	Sat,  6 Nov 2021 18:06:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD73D1B4B8;
	Sat,  6 Nov 2021 18:06:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8B94D181A1D0;
	Sat,  6 Nov 2021 18:06:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A6I6reC012567 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 6 Nov 2021 14:06:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2A429518B; Sat,  6 Nov 2021 18:06:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1707F51E1
	for <dm-devel@redhat.com>; Sat,  6 Nov 2021 18:06:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC1D21066569
	for <dm-devel@redhat.com>; Sat,  6 Nov 2021 18:06:52 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-441-zECjAy89PrSaWHNX8vz6dw-1; Fri, 05 Nov 2021 21:17:44 -0400
X-MC-Unique: zECjAy89PrSaWHNX8vz6dw-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A5MiUTY004533; Sat, 6 Nov 2021 01:17:17 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7k5gp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Nov 2021 01:17:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A615rjQ064774;
	Sat, 6 Nov 2021 01:17:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by aserp3030.oracle.com with ESMTP id 3c5fra86fv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Nov 2021 01:17:15 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB5890.namprd10.prod.outlook.com (2603:10b6:a03:3ef::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13;
	Sat, 6 Nov 2021 01:17:13 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.013;
	Sat, 6 Nov 2021 01:17:13 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Fri,  5 Nov 2021 19:16:38 -0600
Message-Id: <20211106011638.2613039-3-jane.chu@oracle.com>
In-Reply-To: <20211106011638.2613039-1-jane.chu@oracle.com>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
X-ClientProxiedBy: SJ0PR03CA0357.namprd03.prod.outlook.com
	(2603:10b6:a03:39c::32) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
Received: from brm-x62-16.us.oracle.com (2606:b400:8004:44::1c) by
	SJ0PR03CA0357.namprd03.prod.outlook.com (2603:10b6:a03:39c::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11
	via Frontend Transport; Sat, 6 Nov 2021 01:17:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3a5fe25-00db-411b-1651-08d9a0c32a31
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5890:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5890D3C8F371157D99447E78F38F9@SJ0PR10MB5890.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: d8lN4WQn8vgs29dN3eW8aEm7O1FDMLSZtI9scVD7shXvHMP/5zJm1sgPDMUU7c/40eePadtjofBwjhxpUMiDW1x4Kp8isvCKI070G0urN/JZyCgxIm1yWewVLWN14nDrt6WZeDrg2hqZnr2IKtMejrf3D6S2sVH6JdUv2ThkbHJ+S59Ho59s6f9p0QUxfsuHKDKlfoRbvxzhir8P4mvNEYLNrE9D+b/KnlnW2okBo0hAcat4h9TnuP87dOwtq0hWcLX1H/+iKZ4LgE9NNtW0wIaFpBajf+5cN/OVIbX7xvcod1vJAD7sNCBNSwoiXotwvm4CyeQzNWeaIDmQNu+ISB2XDlBKT/Hii0sEaA69idMsEW6pk9BxQatHTEqokslI3SR00TFAUK09o7AZeD//BphQCj4iaqfFncQWrBBsZ2mpin/IO9+kdAJ7GWRv5ev8E142xQxncwiz7KAx6RDJb6Vw/KiyHZoK3BiaRWgN4y5WKwWf7jVz7hQnqm0fJ/goRqxTwm/2/6Zec7+2iP8Cx+5QZ5WasWnv/Ti5Cz+wOJINd7/XfRsBcHEv7jYb4p6jf02hm8Njdu2O9Wx7dQw9cnGLjuAHHDU6nwYAoLspgfaoFXNk7Ns8K9wPL0oR/m4yebF/vqRb6N/m7RzNzQPBW3DFGNl/cOlP/tI5SQ7ejRbJ9CACWExr6/+dDq0hShNMmYEP1kh2HlMdv8ScEUDaQFN/9FhKF6KYxJrmt1EB1LU=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(921005)(36756003)(8676002)(316002)(86362001)(66476007)(66946007)(508600001)(2906002)(44832011)(6486002)(83380400001)(2616005)(5660300002)(186003)(52116002)(7416002)(7696005)(1076003)(6666004)(38100700002)(8936002)(66556008)(309714004);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DjQAfA7cdzLYsIHL2GD14ScvUs5h2xheFKca+ftoQnzohGlOhTCq8euL9laU?=
	=?us-ascii?Q?VMolmDB9ElzldgAMPpfpn8EOmcmQGTG/jaqKqifVtcoMPdpPsakarCJR9O7F?=
	=?us-ascii?Q?FwaS/pfKMVhAhznd/tvwMgGzDhGOkN3hgzvwiaODS2WMX1ez+PNvRROwq0ts?=
	=?us-ascii?Q?3eJ7R6RrbA5upL5HoP5a9IelMSixNzVuQ2sgUA2L4MAwDGMKai/oNZsCvooX?=
	=?us-ascii?Q?2hI82jfAIa/O7BNXJZLc0XWinw5K+eoBgrSd+0VNAedUIrZ5nZ31kcjHfnX+?=
	=?us-ascii?Q?5FHpa57bW3pD3OyOjteO9OTUHAGBw5HrCFO8UTkWmaEFWa/LAakbUANMhHxT?=
	=?us-ascii?Q?OK3939VWdiyZkx6N6MpGQUMv/wcdFsgiVmvl8Ir+293mO45QSMepwAxK66XG?=
	=?us-ascii?Q?R4/75NDzas8p7I91Oe5ONIUn3AtzNbkyoNgJf1oD24uw0z0aO3DAE0MfcYcN?=
	=?us-ascii?Q?ZP2tuyEoc2VR0BCKYuqZEnuMsM8b+Nz6m6K6WiWGHaUJivUdEFwbxXzMVSyC?=
	=?us-ascii?Q?Erp5CPPygekimc0VDYxkLDun4Lfwntb07AuJKbvLOo+vKl6wAf7AgxuRliTp?=
	=?us-ascii?Q?qUZhyZwfPUgAC3mZbYLoi9axSO2Y8o3EqRm70mDHdXEqkR/kp5jDrkA2KcD9?=
	=?us-ascii?Q?aiYhmB752uRcojPCG2uRIRsqsXcAhVQ9kLnsleFoBQhoare4LcWO1LAZn527?=
	=?us-ascii?Q?qxjRwI5mj/Z7kxNYLsDxyRX1q3wAoJnzY2H8NH/4+I+7qYY0HibOR6Cvzw93?=
	=?us-ascii?Q?dWLrqAqa9hGjg10wwVagdeLTwGUeMZ5QqYMwUoSSsu+jG/HFgYt2RAtZOJZC?=
	=?us-ascii?Q?ajQvYrcocVHmB2/e62mDDdkpAqsJ6YUSL27foJtk11OEFDIWffxN1Rbc36bM?=
	=?us-ascii?Q?yTZlSEqsfd6Attrbxm9BsV526BgZ+Dj4E4lYmYVkzi483OQxVa4Wc3OxnNba?=
	=?us-ascii?Q?kLKgZTUqGqJtfj3FIYeDJ6zbS7jU+jyetx7Wov/r1okt7ETaaiTdN1FWE2QU?=
	=?us-ascii?Q?fxFOV5s5eIW3lM2jrjpyKRa4dxSYMwTI5ewS4HH1yaeMxJNFjwyEMaFRijeh?=
	=?us-ascii?Q?tA71cIc7FzinzPJBV+pgnPeWT0h3ILfjMo6gOhjwCb2F2GZMIJ8Qw2UCx3ZQ?=
	=?us-ascii?Q?QOLBSpfCo1JMQQtoZl3xL+4DExGWfboEgCbdv5Z5q5xj6L2LHjQC0DRFcc+0?=
	=?us-ascii?Q?iNAwrKN4zYBe4gSfyZOGbTEkFp1dWlr1cn1C7XV8VX8cDkJU/aDxC82fNthh?=
	=?us-ascii?Q?7NtiDP9adrEZReTEATN5W4/Vdh5RDZ5A0Ff6M238X/6E7etl5h0o5bk52cZ4?=
	=?us-ascii?Q?CaGT+D6RbJmsm3EK3hBpOgMyELRuT2qzi/IHtqOh9QqSNNl1jU4Zom8S1WSg?=
	=?us-ascii?Q?zaLYdRm+Q3Id+UaEfyTOHkIlSziLJSBhseppUk0YfbG6kSw4cm6DWdYg5wXV?=
	=?us-ascii?Q?iNVFumbFc2mOd1NeUoUib1XG7mjf/MBXXLVaXlYXVsL+YFDovDkZrBy1xJDh?=
	=?us-ascii?Q?3I0QIqk9b4oJlynlxWqX9mqG+YUvEPZvvKpt7UyyHejciuYOECDOT13Pa2xc?=
	=?us-ascii?Q?QaCF7M+fmBizXJckCf5zgin7YSVTMm1u66WEio2uW8O7ahqGazzphxoxwX52?=
	=?us-ascii?Q?12Yy/EKOYlhOD9ZCt8zn/e4SAS2fozYKaHsENJN5y75t?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a5fe25-00db-411b-1651-08d9a0c32a31
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2021 01:17:13.8016 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zb0nlpiDQVi6hP2CxTIL9rA0Lj9ujTB8CmkxIMuIz8TU4FiH3ZPjVUPJlD7Uc3GVnwsA0V3PKX870Q6byNzucQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5890
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10159
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0
	suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
	adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111060005
X-Proofpoint-ORIG-GUID: BB5v6OVno30v7F4afHqD5xMuINTcBkMn
X-Proofpoint-GUID: BB5v6OVno30v7F4afHqD5xMuINTcBkMn
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v2 2/2] dax,
	pmem: Implement pmem based dax data recovery
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For /dev/pmem based dax, enable DAX_OP_RECOVERY mode for
dax_direct_access to translate 'kaddr' over a range that
may contain poison(s); and enable dax_copy_to_iter to
read as much data as possible up till a poisoned page is
encountered; and enable dax_copy_from_iter to clear poison
among a page-aligned range, and then write the good data over.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/md/dm.c       |  2 ++
 drivers/nvdimm/pmem.c | 75 ++++++++++++++++++++++++++++++++++++++++---
 fs/dax.c              | 24 +++++++++++---
 3 files changed, 92 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index dc354db22ef9..9b3dac916f22 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1043,6 +1043,7 @@ static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 	if (!ti)
 		goto out;
 	if (!ti->type->dax_copy_from_iter) {
+		WARN_ON(mode == DAX_OP_RECOVERY);
 		ret = copy_from_iter(addr, bytes, i);
 		goto out;
 	}
@@ -1067,6 +1068,7 @@ static size_t dm_dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 	if (!ti)
 		goto out;
 	if (!ti->type->dax_copy_to_iter) {
+		WARN_ON(mode == DAX_OP_RECOVERY);
 		ret = copy_to_iter(addr, bytes, i);
 		goto out;
 	}
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 3dc99e0bf633..8ae6aa678c51 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -260,7 +260,7 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
 
 	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
-					PFN_PHYS(nr_pages))))
+				 PFN_PHYS(nr_pages)) && mode == DAX_OP_NORMAL))
 		return -EIO;
 
 	if (kaddr)
@@ -303,20 +303,85 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
 }
 
 /*
- * Use the 'no check' versions of copy_from_iter_flushcache() and
- * copy_mc_to_iter() to bypass HARDENED_USERCOPY overhead. Bounds
- * checking, both file offset and device offset, is handled by
- * dax_iomap_actor()
+ * Even though the 'no check' versions of copy_from_iter_flushcache()
+ * and copy_mc_to_iter() are used to bypass HARDENED_USERCOPY overhead,
+ * 'read'/'write' aren't always safe when poison is consumed. They happen
+ * to be safe because the 'read'/'write' range has been guaranteed
+ * be free of poison(s) by a prior call to dax_direct_access() on the
+ * caller stack.
+ * But on a data recovery code path, the 'read'/'write' range is expected
+ * to contain poison(s), and so poison(s) is explicit checked, such that
+ * 'read' can fetch data from clean page(s) up till the first poison is
+ * encountered, and 'write' requires the range be page aligned in order
+ * to restore the poisoned page's memory type back to "rw" after clearing
+ * the poison(s).
+ * In the event of poison related failure, (size_t) -EIO is returned and
+ * caller may check the return value after casting it to (ssize_t).
+ *
+ * TODO: add support for CPUs that support MOVDIR64B instruction for
+ * faster poison clearing, and possibly smaller error blast radius.
  */
 static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i, int mode)
 {
+	phys_addr_t pmem_off;
+	size_t len, lead_off;
+	struct pmem_device *pmem = dax_get_private(dax_dev);
+	struct device *dev = pmem->bb.dev;
+
+	if (unlikely(mode == DAX_OP_RECOVERY)) {
+		lead_off = (unsigned long)addr & ~PAGE_MASK;
+		len = PFN_PHYS(PFN_UP(lead_off + bytes));
+		if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
+			if (lead_off || !(PAGE_ALIGNED(bytes))) {
+				dev_warn(dev, "Found poison, but addr(%p) and/or bytes(%#lx) not page aligned\n",
+					addr, bytes);
+				return (size_t) -EIO;
+			}
+			pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
+			if (pmem_clear_poison(pmem, pmem_off, bytes) !=
+						BLK_STS_OK)
+				return (size_t) -EIO;
+		}
+	}
+
 	return _copy_from_iter_flushcache(addr, bytes, i);
 }
 
 static size_t pmem_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i, int mode)
 {
+	int num_bad;
+	size_t len, lead_off;
+	unsigned long bad_pfn;
+	bool bad_pmem = false;
+	size_t adj_len = bytes;
+	sector_t sector, first_bad;
+	struct pmem_device *pmem = dax_get_private(dax_dev);
+	struct device *dev = pmem->bb.dev;
+
+	if (unlikely(mode == DAX_OP_RECOVERY)) {
+		sector = PFN_PHYS(pgoff) / 512;
+		lead_off = (unsigned long)addr & ~PAGE_MASK;
+		len = PFN_PHYS(PFN_UP(lead_off + bytes));
+		if (pmem->bb.count)
+			bad_pmem = !!badblocks_check(&pmem->bb, sector,
+					len / 512, &first_bad, &num_bad);
+		if (bad_pmem) {
+			bad_pfn = PHYS_PFN(first_bad * 512);
+			if (bad_pfn == pgoff) {
+				dev_warn(dev, "Found poison in page: pgoff(%#lx)\n",
+					pgoff);
+				return -EIO;
+			}
+			adj_len = PFN_PHYS(bad_pfn - pgoff) - lead_off;
+			dev_WARN_ONCE(dev, (adj_len > bytes),
+					"out-of-range first_bad?");
+		}
+		if (adj_len == 0)
+			return (size_t) -EIO;
+	}
+
 	return _copy_mc_to_iter(addr, bytes, i);
 }
 
diff --git a/fs/dax.c b/fs/dax.c
index bea6df1498c3..7640be6b6a97 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1219,6 +1219,8 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 		unsigned offset = pos & (PAGE_SIZE - 1);
 		const size_t size = ALIGN(length + offset, PAGE_SIZE);
 		const sector_t sector = dax_iomap_sector(iomap, pos);
+		long nr_page = PHYS_PFN(size);
+		int dax_mode = DAX_OP_NORMAL;
 		ssize_t map_len;
 		pgoff_t pgoff;
 		void *kaddr;
@@ -1232,8 +1234,13 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 		if (ret)
 			break;
 
-		map_len = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
-					    DAX_OP_NORMAL, &kaddr, NULL);
+		map_len = dax_direct_access(dax_dev, pgoff, nr_page, dax_mode,
+					    &kaddr, NULL);
+		if (unlikely(map_len == -EIO)) {
+			dax_mode = DAX_OP_RECOVERY;
+			map_len = dax_direct_access(dax_dev, pgoff, nr_page,
+						    dax_mode, &kaddr, NULL);
+		}
 		if (map_len < 0) {
 			ret = map_len;
 			break;
@@ -1252,11 +1259,20 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 		 */
 		if (iov_iter_rw(iter) == WRITE)
 			xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
-					map_len, iter, DAX_OP_NORMAL);
+					map_len, iter, dax_mode);
 		else
 			xfer = dax_copy_to_iter(dax_dev, pgoff, kaddr,
-					map_len, iter, DAX_OP_NORMAL);
+					map_len, iter, dax_mode);
 
+		/*
+		 * If dax data recovery is enacted via DAX_OP_RECOVERY,
+		 * recovery failure would be indicated by a -EIO return
+		 * in 'xfer' casted as (size_t).
+		 */
+		if ((ssize_t)xfer == -EIO) {
+			ret = -EIO;
+			break;
+		}
 		pos += xfer;
 		length -= xfer;
 		done += xfer;
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

