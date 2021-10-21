Return-Path: <SRS0=XsJU=PJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110E2C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 02:20:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 83F98611EF
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 02:20:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 83F98611EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-nT1DWphpOhK_2r8tZr__5w-1; Wed, 20 Oct 2021 22:20:27 -0400
X-MC-Unique: nT1DWphpOhK_2r8tZr__5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A14B8806689;
	Thu, 21 Oct 2021 02:20:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8428679447;
	Thu, 21 Oct 2021 02:20:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5A5E31832DD4;
	Thu, 21 Oct 2021 02:20:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19L1A7o9028810 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 20 Oct 2021 21:10:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9196ABDC4C; Thu, 21 Oct 2021 01:10:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 88FC3C77DF
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 01:10:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0AE1858EEC
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 01:10:04 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-285-l4b5YwtAN3e5uLGL_cx9iQ-1; Wed, 20 Oct 2021 21:10:01 -0400
X-MC-Unique: l4b5YwtAN3e5uLGL_cx9iQ-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19KM5Sgc000812; Thu, 21 Oct 2021 00:12:02 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btkw4uaa6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 00:12:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L0BaoJ180521;
	Thu, 21 Oct 2021 00:12:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by userp3030.oracle.com with ESMTP id 3bqkv0x74x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 00:12:00 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB2759.namprd10.prod.outlook.com (2603:10b6:a02:b5::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17;
	Thu, 21 Oct 2021 00:11:58 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c]) by SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c%5]) with mapi id 15.20.4608.018;
	Thu, 21 Oct 2021 00:11:58 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Wed, 20 Oct 2021 18:10:58 -0600
Message-Id: <20211021001059.438843-6-jane.chu@oracle.com>
In-Reply-To: <20211021001059.438843-1-jane.chu@oracle.com>
References: <20211021001059.438843-1-jane.chu@oracle.com>
X-ClientProxiedBy: SN4PR0801CA0003.namprd08.prod.outlook.com
	(2603:10b6:803:29::13) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
Received: from brm-x62-16.us.oracle.com (2606:b400:8004:44::1d) by
	SN4PR0801CA0003.namprd08.prod.outlook.com
	(2603:10b6:803:29::13) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.4628.16 via Frontend Transport;
	Thu, 21 Oct 2021 00:11:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10ffa4db-15d3-499f-a894-08d9942765ba
X-MS-TrafficTypeDiagnostic: BYAPR10MB2759:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2759FC4AB29B9CF7987A56BBF3BF9@BYAPR10MB2759.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: qmEX2epLGYlRwyw7bKWTM3QJ/xGFG7I1YYudye7DFk2+l6pvORl+GXJmNmye5hBZ7ZTKReYsQxxzQHYHbSXv2KrpLDrdBpEEWsI0BJq1gkAiUyk22sUfC7vgDzRNQfoXgaTgUJFloynJXEgWtv2nX6Ln3teGMIEebuE4kj6PzuL6gtVqckJoTdWCiCeueQg6/SX87kewfCEEWOfJiOkC+J8ehXVpPj0wmmI9N4aYzIlDZkEu88d56dkuq/Xm6ffMe3AwW8UA+x1xIgvrfvDLDfL5aF9OMMjwntWYc3xwirltZbGSwIx8SCpzVqt5gSVej1jhhj29M+DJWL8t9FVxRgZXd4SXvdFy92OvtQuZBWWz6CiHVTegsDFjMU2Gc+qpqDoVz523wvcTA0lIB/0cWt+f/LIz7ZSQ/21d5zPHO0MKSXHFVQPottVOjsoF3lt2ZxdouLnwJpMH5D8TjKGIiHGgx9jKontfoyCE+M0fVttg1yVcfjOAGb+tAc39hntT9UIloT8hId6SPHLySOAZd2CnBOIgN8zq2F3An/+D6CHG7Zw8t7t7M8zbzeuglclLPt7xANoWfKaGYW7uzKSvM0BMf8jdCAZ0m+ImCj4uRpaCOlPKJBSZir3KAUNHCOcdz2lT7Fcw5Q89nquLVKnVQyZMBF3ys0OCGX9id9UwFgX7Km/uLrgX4O1L+kSCbBq8t/zTHe9GBdyFXJX8R1ex+5LN/kfLgkXR8fQv8YVh7a4=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(316002)(5660300002)(1076003)(66946007)(66476007)(7416002)(38100700002)(83380400001)(36756003)(66556008)(921005)(508600001)(6486002)(8676002)(86362001)(186003)(7696005)(52116002)(8936002)(44832011)(2616005)(2906002)(309714004);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1qKRFLVA+L/hlQG4sjPnJIPupHiECM2Ie9obJ/FXDRNj8XIhi8XssVFOkGDk?=
	=?us-ascii?Q?JUhMGBTrUqYRfwt6DVYgz0/5ESqVZYXalBWdTq6/m4YyA/zztUGE+tVwAubu?=
	=?us-ascii?Q?YS7XATCr/7tBtQO0lMbqLO61L7pC1Y/oljTVD41lPCEGxiRq0sxTXx+Z00l0?=
	=?us-ascii?Q?iD6oD8/oTkN0Ycddar3UdkRtSSW6JnHhPlUq5GVSFDa3xEbB9Z2jhgEgAAFK?=
	=?us-ascii?Q?wMOi2jwZJA1BgxgejSyvUPHoJ7W6lML9bZII0GMEKn/Rkt+AgHhQv0EEEtDH?=
	=?us-ascii?Q?q/535BSf8S+g01KEApARLksHl0j4IN+jO97pfb0o6FbvjL3//ecJcHeZFFMA?=
	=?us-ascii?Q?1jHDbTUH2M32ecl7wyTgi5Dx3g2cwe+AXgof86g9wJxFFRYe00iBuVEwSl4C?=
	=?us-ascii?Q?sxnxboqNXjemazmCHxJ8y9NSSZW/CgpYKyClFNpV0UloPHXcvok+T2bK2Dgs?=
	=?us-ascii?Q?zY/n2FqW2srM36nAneXBiFcdvaJYArwytwT1ZCc9A9gWKiXnxZlfX/XJK5RT?=
	=?us-ascii?Q?w4kFdh5KPLWBBe+WLVo7FAttHoPrfvl9P6k7ZyGZK96TSgn5+uwy3j8WLqJp?=
	=?us-ascii?Q?aCwYsBNeiN85XnR40Mqrinl/7HgR+9b90VjL6UZIsKsOFx0tFAdFUm1GYM7C?=
	=?us-ascii?Q?rMLHbjsBuTB2i8EVFr88LBg+RjYeM4ZKGFXwHWg7N5mNbLGIk5M7LhVvfUcG?=
	=?us-ascii?Q?pocioU+lJZQmrAZpmApjSZz+I3JB7XNRUV1eSilj40O9v+KbGih+c3Q83plB?=
	=?us-ascii?Q?xtXHqSGYFzeNoJdAw1DL5v4c22W87SSLgY1li5WikENs82iQHY1j9DZaYygU?=
	=?us-ascii?Q?rKosvpOx/qQdBLCeEJCLwJ2vi0QKo7FTqt4QQZMZgfTB9dPscPmrqMky6QYJ?=
	=?us-ascii?Q?F30Fn5wsB8I2ae62gUsI4NgHfK378V//n96ScPtnI3nt8gcW9bhkuof0B0h3?=
	=?us-ascii?Q?Fi4/LcP+/b6abGqhM/+/VWq3/6vB2Dg/QSLMx2WLFZ2Vl2Ux+z0fNJogkApg?=
	=?us-ascii?Q?ujfTv6vVt8Fer/6i/ko5WfgoWX8fbB79IGQTOMR2ivmv0Bqi9NXQF6/aTjQg?=
	=?us-ascii?Q?mca1bHsLFjX8Er17fY65vPIedruROJj1f6dgMNXSSVtrvAOgg+zz+DcLwj0H?=
	=?us-ascii?Q?jXpV1JnaAfCbfJi1R1ggz6dsDdE8gPv0miZ21ySU3HNjf9hc7aGtgendMOoW?=
	=?us-ascii?Q?DSsZsNAqvoaRYk2jwdyHxKqBoH+Z3g6IJUvZGPvk5vci8FRzEbiYigo8cVLH?=
	=?us-ascii?Q?A6mh/93JtzQSVPQ1pFYUgRdxzK5oJOi4OliIiJ0UJt69Kraxiritk/EMtNSl?=
	=?us-ascii?Q?koQl/0pigSfUtqoFu1Cu5w11Oo48/bqXMC47wFxPRewtIw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ffa4db-15d3-499f-a894-08d9942765ba
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 00:11:58.2297 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jane.chu@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2759
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	suspectscore=0
	malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110210000
X-Proofpoint-GUID: 2GNaifIXaztcZirYLUBeXCikFjLzvFMM
X-Proofpoint-ORIG-GUID: 2GNaifIXaztcZirYLUBeXCikFjLzvFMM
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
X-Mailman-Approved-At: Wed, 20 Oct 2021 22:18:51 -0400
Subject: [dm-devel] [PATCH 5/6] dax,
	pmem: Add data recovery feature to pmem_copy_to/from_iter()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When DAXDEV_F_RECOVERY flag is set, pmem_copy_to_iter() shall read
as much data as possible up till the first poisoned page is
encountered, and pmem_copy_from_iter() shall try to clear poison(s)
within the page aligned range prior to writing.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/nvdimm/pmem.c | 72 ++++++++++++++++++++++++++++++++++++++++---
 fs/dax.c              |  5 +++
 2 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index e2a1c35108cd..c456f84d2f6f 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -305,21 +305,83 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
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
+ * However with the introduction of DAXDEV_F_RECOVERY, the 'read'/'write'
+ * range may contain poison(s), so the functions perform explicit check
+ * on poison, and 'read' end up fetching only non-poisoned page(s) up
+ * till  the first poison is encountered while 'write' require the range
+ * is page aligned in order to restore the poisoned page's memory type
+ * back to "rw" after clearing the poison(s).
+ * In the event of poison related failure, (size_t) -EIO is returned and
+ * caller may check the return value after casting it to (ssize_t).
  */
 static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 	void *addr, size_t bytes, struct iov_iter *i, unsigned long flags)
 {
+	phys_addr_t pmem_off;
+	size_t len, lead_off;
+	struct pmem_device *pmem = dax_get_private(dax_dev);
+	struct device *dev = pmem->bb.dev;
+
+	if (flags & DAXDEV_F_RECOVERY) {
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
+					BLK_STS_OK)
+				return (size_t) -EIO;
+		}
+	}
+
 	return _copy_from_iter_flushcache(addr, bytes, i);
 }
 
 static size_t pmem_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 	void *addr, size_t bytes, struct iov_iter *i, unsigned long flags)
 {
-	return _copy_mc_to_iter(addr, bytes, i);
+	int num_bad;
+	size_t len, lead_off;
+	unsigned long bad_pfn;
+	bool bad_pmem = false;
+	size_t adj_len = bytes;
+	sector_t sector, first_bad;
+	struct pmem_device *pmem = dax_get_private(dax_dev);
+	struct device *dev = pmem->bb.dev;
+
+	if (flags & DAXDEV_F_RECOVERY) {
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
+					 pgoff);
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
+	return _copy_mc_to_iter(addr, adj_len, i);
 }
 
 static const struct dax_operations pmem_dax_ops = {
diff --git a/fs/dax.c b/fs/dax.c
index 69433c6cd6c4..b9286668dc46 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1246,6 +1246,11 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 			xfer = dax_copy_to_iter(dax_dev, pgoff, kaddr,
 					map_len, iter, dax_flag);
 
+		if ((ssize_t)xfer == -EIO) {
+			ret = -EIO;
+			break;
+		}
+
 		pos += xfer;
 		length -= xfer;
 		done += xfer;
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

