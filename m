Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B44C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 21:33:11 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-4JPHkajKMjOM3IzaXtk-WQ-1; Fri, 28 Jan 2022 16:33:05 -0500
X-MC-Unique: 4JPHkajKMjOM3IzaXtk-WQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FE2A190A7A5;
	Fri, 28 Jan 2022 21:33:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B1D456F87;
	Fri, 28 Jan 2022 21:33:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 302181809CBA;
	Fri, 28 Jan 2022 21:33:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SLWoZt018793 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 16:32:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F11D5401E26; Fri, 28 Jan 2022 21:32:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ECF544292CD
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 21:32:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D214B1C05EC4
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 21:32:49 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-630-rSPFYoG-MN6a0R4fTAhGmg-1; Fri, 28 Jan 2022 16:32:45 -0500
X-MC-Unique: rSPFYoG-MN6a0R4fTAhGmg-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	20SK47cf025842; Fri, 28 Jan 2022 21:32:39 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3duxnp4224-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jan 2022 21:32:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20SLQvDm134966;
	Fri, 28 Jan 2022 21:32:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by aserp3020.oracle.com with ESMTP id 3dtaxd6uyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jan 2022 21:32:37 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BLAPR10MB4866.namprd10.prod.outlook.com (2603:10b6:208:325::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17;
	Fri, 28 Jan 2022 21:32:35 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4930.018;
	Fri, 28 Jan 2022 21:32:35 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Fri, 28 Jan 2022 14:31:50 -0700
Message-Id: <20220128213150.1333552-8-jane.chu@oracle.com>
In-Reply-To: <20220128213150.1333552-1-jane.chu@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
X-ClientProxiedBy: SN7PR04CA0071.namprd04.prod.outlook.com
	(2603:10b6:806:121::16) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dad539e7-1599-4904-a4e1-08d9e2a5b332
X-MS-TrafficTypeDiagnostic: BLAPR10MB4866:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB48661462E6A36E8C4A3A476BF3229@BLAPR10MB4866.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ZltUfmli/SEkiU2MSJzaOXcUQ4q90o81k+T3l7wneDKvnTveUU9cSG+A4WLDMAc6EJzZmcnzN/oXonRIssVReJBr5A3mqsB79NCHm0GAXIrclw5y5noZrBWZPvHCG5bKeOXQmpbv5l6PJmX+C0GQ30m9jAxy0XBSNj0NMlsz0Nq3Vd//f3z4dYxyAE29k4szd+OhrWKACd5RksAyzAtcfvVWB6SIywXNEgcH6LhnLBi1P8gtBE+FOORqDADqMf1pE0bRSZz0tGCa2Rg4Pf82f8KJDAAskF/731HRJkZIx7XbPOvUjtp8YuoKWb4sYqMeApiFQcxvzVmktW0qZsYgiWPPiNZK7A5WgXH5oi5kf0N336PXou5WuFXcqSupxUxOtH5bjln2U04I9kpGdclblNUIltc9k1jzzt0E7BggIFEpQIr9JqgLt4OdVPrPjY3xlVU7rfGpPwr5F3DcIbd1Xiqt1wgvh58D/Wg1gA+PHiy+EWuibO5WikrmQtEEYjPP9rOd2s5IQoZo6I4AG0MjqXwMzscHS0W8Jza6MXxfeDBTI0V/Xr5ZWOmiD+kE8IiA8KJi/bCV9OUTQQbBA5/94S+LIUlHZH/IwOcJlJeS2lhFt5S08i92Gr3lbG1QvzQUgrsgVtLHoBUayPqHBbmG0s9NhA8dGbXkKHuSX+nDGZOPwN0gqTXSIfLRjsSs4YWI9eL0udqgYQX9gtiSgCk1hA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(921005)(2906002)(2616005)(52116002)(4744005)(6506007)(38100700002)(44832011)(36756003)(6486002)(6512007)(6666004)(83380400001)(186003)(316002)(7416002)(508600001)(86362001)(66476007)(5660300002)(66946007)(8936002)(66556008)(1076003)(8676002)(20210929001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LKSxtD2WWDXpkHIMbPhl3U83dMRp42GBfrsUp/BY9mwg2ZIAbfD7lIZ5r7iY?=
	=?us-ascii?Q?XwG5zBuYLwyvu+Aht4E8RWvpDzoNq+cDED06c0X86xPsLzWG006zk0EtZw7m?=
	=?us-ascii?Q?rCa0xWaDV/P/6oRmKbyqoRM39c2e/Q8WvQv82XZCpjJvaT+/FeZWtwsNWwRf?=
	=?us-ascii?Q?RgN0gyjGR6b139izkNaFcA8SGfCdC/qGb2BQ2LCBImLn3P6+F05UwDoycxBC?=
	=?us-ascii?Q?t7qoDYZVXq+9vgq3L6/JIVx8Km0lG623/IM06lKprk2WbbCEGdraLU2Y2ZPW?=
	=?us-ascii?Q?z08m+wfmmGsbW4QdmLrxtJ4IroAi9eLmioNtg04ToHc3I3yjeszCGDKGqMF0?=
	=?us-ascii?Q?ePKegV2/jVRglb6TOLVNLxXN8Zpows6eeHqKX0H1qfyD7wlGvpWAka50MFUQ?=
	=?us-ascii?Q?wrz7m3pRK/uF5mUYQJUYMGcJ9udL6UVMMVkkccgA+Ced0YyZhOhb1h/tKUbj?=
	=?us-ascii?Q?Ui8hEuqrIV3hhLYDLZ1eP9jniSHD8gbPQ7wYRoR71khsDuftxgz5TA5TMBgU?=
	=?us-ascii?Q?/jnsQQQQSC52/QjOPWZPH8nnAcb95wpXF04N68ffTqT9IN1LRofRhvk067Xx?=
	=?us-ascii?Q?ZoyP9e7FgB6n8i9oyfloYLLeZfNXF3SR1KjriB/lVaTWn7rxE7Y+z4zNfEHJ?=
	=?us-ascii?Q?R0ixFOcyJg1k5DHVID0+ZY6QaPhGxBAyZMRFW4GzM1qeUN2NnW2b7ICuo4D+?=
	=?us-ascii?Q?phBAZlui/4ZhIYNnHJCqOSlQRf7nfwaSvVLAINk9yaZ0vQKSJaVwQ5yEGyuv?=
	=?us-ascii?Q?LSKRK10ijdDt3eRwP6gBkUz7t0SC6v25VcKEAEh9tmtR23lW7H1A9Myhf53S?=
	=?us-ascii?Q?fpl7rPRkg8rJ5RAyRytmpUzS5cuDNcjIauSJ2/IBy3jyxZXdMhdoD1yLN/vd?=
	=?us-ascii?Q?eYXdKABR7yVgPxCNS/uIY2xs4TEc0P914y4vznna3cimb1dM2KeqmWzvseyK?=
	=?us-ascii?Q?h/IKbsEmItEYt1mooBAPLULzJWBEnOg5vJEW/cnX+EdRZ9btmRvGJCjHtppC?=
	=?us-ascii?Q?U/ulTCHSSzuWXnqo32vT/cjGgDeF8isa4mH/ApuWMiGs/Wzz2KktGTYpXTCY?=
	=?us-ascii?Q?4Xhd0wjFPztp3tK1YwWaE+N1F81x0CQrS4Eyd1tzh+tLWP4QR9+mKLMXEnUc?=
	=?us-ascii?Q?JOu+WiP6j+zKDUTcutZtQ5rhQfa4ZKj0QmsrxGDQ2NSTY6aPckQxM+vxSSPJ?=
	=?us-ascii?Q?AGys6z5n1NSq46wld1kfTEu+3fheIG3BrlmJyMglIRfAq7K9Kb1G/NfvjYxN?=
	=?us-ascii?Q?Gsh5dOUogcQW+fpwJ6Fj9YryR4c1Rv3flZVOx4LL5QSRgTervZyaQR4nfa6P?=
	=?us-ascii?Q?HzeVizMEkmBsM/i6OmywHOkY8l+66UpFv6JXe1kG8HlRJKXIvwbiHvfOGkyn?=
	=?us-ascii?Q?YZOsl8rGPob2rfQl6tq1qjQB+9kXFnLo1UhuJCHcpYMw/3ZMkTZdIn6hpHLS?=
	=?us-ascii?Q?y6nv2BEeVr90DNdj0nC9oP5Xclpr9p+vMDEUd7peenePi5OWqZkESLBCjioi?=
	=?us-ascii?Q?0u546IOalh6QYZzTHQUJY4Q2hfFsa1qekSPvL5ZBbpz1zEe0+yyIjHF77UBk?=
	=?us-ascii?Q?Ddlw5zoVIMa164zx/yOAKEbRdQlie5hHW8elTsWXHOiut15373n2pE9ZbZXY?=
	=?us-ascii?Q?zgmRBCekWrzW3efq8CzZs/Fc2MR6+Zvb2kyut5VqmWJk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dad539e7-1599-4904-a4e1-08d9e2a5b332
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 21:32:35.4963 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PIL8+19nqU/qKas+8j0GNk/OOHvh4m7rGoWdIOol7pAa/bfJHEefGhp5nxT/4rWZwzedFZPe7e8Qnh1H0bo06A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4866
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10241
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	bulkscore=0 mlxscore=0
	phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2201280122
X-Proofpoint-GUID: sMkB169Skh_pr8g4gZFJpHr2jWlnLt40
X-Proofpoint-ORIG-GUID: sMkB169Skh_pr8g4gZFJpHr2jWlnLt40
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v5 7/7] pmem: fix pmem_do_write() avoid writing
	to 'np' page
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

Since poisoned page is marked as not-present, the first of the
two back-to-back write_pmem() calls can only be made when there
is no poison in the range, otherwise kernel Oops.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/nvdimm/pmem.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index f2d6b34d48de..283890084d58 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -187,10 +187,15 @@ static blk_status_t pmem_do_write(struct pmem_device *pmem,
 	 * after clear poison.
 	 */
 	flush_dcache_page(page);
-	write_pmem(pmem_addr, page, page_off, len);
-	if (unlikely(bad_pmem)) {
-		rc = pmem_clear_poison(pmem, pmem_off, len);
+	if (!bad_pmem) {
 		write_pmem(pmem_addr, page, page_off, len);
+	} else {
+		rc = pmem_clear_poison(pmem, pmem_off, len);
+		if (rc == BLK_STS_OK)
+			write_pmem(pmem_addr, page, page_off, len);
+		else
+			pr_warn("%s: failed to clear poison\n",
+				__func__);
 	}
 
 	return rc;
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

