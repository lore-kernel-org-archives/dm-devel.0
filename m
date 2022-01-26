Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 346D1C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jan 2022 21:12:34 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-efEBhzoWOpOjDN1t08boew-1; Wed, 26 Jan 2022 16:12:31 -0500
X-MC-Unique: efEBhzoWOpOjDN1t08boew-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED1C418B9ECA;
	Wed, 26 Jan 2022 21:12:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A415BE2E8;
	Wed, 26 Jan 2022 21:12:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 49F0D1802E34;
	Wed, 26 Jan 2022 21:12:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20QLCEYf026054 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 Jan 2022 16:12:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0E625492D53; Wed, 26 Jan 2022 21:12:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09C08492D4E
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 21:12:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEA8F811E7A
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 21:12:13 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-153-MLqiM_TKOsydpszf7_VuRg-1; Wed, 26 Jan 2022 16:12:09 -0500
X-MC-Unique: MLqiM_TKOsydpszf7_VuRg-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	20QKZ2bT013145; Wed, 26 Jan 2022 21:12:01 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dsvmjfuyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jan 2022 21:12:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20QL5Mxw082682;
	Wed, 26 Jan 2022 21:12:00 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by aserp3030.oracle.com with ESMTP id 3dr7yjfe7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jan 2022 21:12:00 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB3368.namprd10.prod.outlook.com (2603:10b6:a03:150::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12;
	Wed, 26 Jan 2022 21:11:58 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%4]) with mapi id 15.20.4909.019;
	Wed, 26 Jan 2022 21:11:58 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Wed, 26 Jan 2022 14:11:16 -0700
Message-Id: <20220126211116.860012-8-jane.chu@oracle.com>
In-Reply-To: <20220126211116.860012-1-jane.chu@oracle.com>
References: <20220126211116.860012-1-jane.chu@oracle.com>
X-ClientProxiedBy: SA9PR13CA0112.namprd13.prod.outlook.com
	(2603:10b6:806:24::27) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0614ab3e-3043-4797-844a-08d9e1107cee
X-MS-TrafficTypeDiagnostic: BYAPR10MB3368:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB336806D94FE5FF7C1EA07ED2F3209@BYAPR10MB3368.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: SKXbLBbM4GvlADn5ig1hchTxvfvvhDKEwQExu6dX21v9Al6ti/0N2EcRO9lcjI2uDZ8bD9MHbELZbylTAcC47XVX8bC2ce0V01OKFy/QwfazSEfwC+Gug9x1RRJUzaE3zRn7NjbZZkyZpJpOgvi/A9cZhs+9UCvu8z6o1D6ZN97uM5kz6mhS86cuwpyVdltwat73Eqr3ovO19tvfVcG9yS1iBDlS3fuf+xgwjLuTeXGzKCbp7LtnZdv0rBSSe9Dl9RIRDVlBM0BMiIETnhVyAFAwHi27nl21R/0Uxfhu4VjYWIDkHL2HLhiWStPwbdMXJNlVaohNMfkEsEf6tQ21MMTfIlI443N3pMfG2Uk6lHU7/hhxCJ/xvKnvxzwXomNMC1I89d2cURqrF1ysTaNy3hCpZpUTM/nIsTY2hm6QZjIyH3VduReJ2cK3yJXrGPYIs2yZh5+8vZLMcKtPNTtQiFLaX/DN0dfl4S2/s2H+bnSLD3jvzzLxauzUN88lIljJaFnTrCfPQB8PTncAT86WSurz4jirpf5yBBO7TQcjGVAJpx4+EBqn+2OLQNug3IHRnuQXKri8JYffbEgzCuTwxINYL0Ho4QbORW/sUsZDTNIqcgoHK8VVM81HSZkbpUec0X6k2FWXpMKmhssp5xzCgsU/hZ/blO0MN4fJfahVUhJUHQVGhFzoxud3t0+QPxaK
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(36756003)(316002)(7416002)(52116002)(6506007)(38100700002)(2616005)(8676002)(5660300002)(6666004)(86362001)(44832011)(8936002)(66556008)(2906002)(186003)(4744005)(6486002)(921005)(1076003)(508600001)(83380400001)(6512007)(66476007)(66946007);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EacyS6jr+wnJ1/UTCSK2YIg9Y0Dm0/yjVXKKRXP0YXOc6vdqzs4ut3ENUm+z?=
	=?us-ascii?Q?f5hXlxO6u6ktJo7J9dZu0XBWvhPW65uL+9slRozPUVe/5juQ0GxyMR2duKei?=
	=?us-ascii?Q?aeA/4UYjchQEgb5L9Ww1WTRV8W+LpJXUyMH5NswDmVsYb83BHpsIpTbQZ50C?=
	=?us-ascii?Q?NkIBUF8GZ0DmXsOW0EFKYRqwv4lXdjqfS8GZmm1MTHGQ61/eJa9R7wdJESOp?=
	=?us-ascii?Q?zMty8NVG2Nkop35gioDy6Emv1hiqxvbMySGvv6aw0MnF7nZzLQ+uYPi70ktI?=
	=?us-ascii?Q?ni7a4MFHvoN12dGvPlYF+O7epvmPBGzq2xf609Cz3nRf9YUNoyNuFT5TVli5?=
	=?us-ascii?Q?DVAC9iq69V7qhag2Y9oTJ2yTAKG2pnWP7Sk4hhy7Z3xCVB4wrreTkfrlq3V3?=
	=?us-ascii?Q?C9Uj9EmEXoBzajgqAQguTrH9pyZqut91Gg9kLqBRKQkTYnP4fwnS3Jd77z/Z?=
	=?us-ascii?Q?c5RFyQWMYT75mVlQCIm5MsAfxJXQd/lfNawlkG/+1NV/DyVzD1mRiyqxU5gr?=
	=?us-ascii?Q?qmdFhOyxLqvlwCwUsNwFJnhseE0E1W3FvG2wD9YR5X3Lw68mC00e0fY5QSx5?=
	=?us-ascii?Q?Z3Q3q4pWijCzXbYJuzRVIy7XGweOPCq4CfBK/M52tI4noz0+7rz9dN99+IJk?=
	=?us-ascii?Q?O1FZiHcUyqvEd+sRtrOOKSb/zP4Y6EQb01jm0iv7y+TqkgaDj1o7N59BKinj?=
	=?us-ascii?Q?oPq8kVr82DqJcIw5UMf1iFmcqOdtzLt7Jm95P2keRMNGlvqT/loX5n8ZSUjp?=
	=?us-ascii?Q?gvUtHQ0eUGs/1Wic0Z7RPqiFzVFXMI5EDQJWmm+bJHG0aqFBQnCu3F40fYm/?=
	=?us-ascii?Q?OOG/5LCXMfWab7I6vecCfdORfZvoD5boPZ1pM3g7EausZ+suzr2UUXKZQ1Wp?=
	=?us-ascii?Q?slgZalbJqidRGK9AJ3OZN6+LkM1thRZguarTccEc9OdmHHlsRYbbrqTaM8A9?=
	=?us-ascii?Q?xfavtHL1XaTH258nhG8omltYh46JCtSUNxHRKg3Q92ENWRr6UyRUvQXETQw6?=
	=?us-ascii?Q?Z6UznM1BlNmwwuskL889V7bgrp8Aa4oeCZolRUBr0MQjxN8ongsbDIL9h/mY?=
	=?us-ascii?Q?oWBCiem9tjKScKPfC1gGF1sLymhe9Sk6AMx3/DKAWrSUJdLA8dZOKvo3okzn?=
	=?us-ascii?Q?i7bQbJwMFScnoN1HYUK61P9jvt5iFjv5t/Y1U40JxKcb7wnJtfF2v3nlr4B0?=
	=?us-ascii?Q?eLbQst2iqueMDlVNBAXpvDD8d3i9OnFy0CYme+f+LPZNuxtaeSHCwt0n5nGS?=
	=?us-ascii?Q?b0SWQRBpLwLsYV3VnOuspb0XiFmMvYxAFbpgPiDuiTaS4BR97CCrXxiIU+lt?=
	=?us-ascii?Q?DlXGnbwDKnv+2KBnXx/AGmKSHVffD7kmnaILRQ8oWj/0GXJmVfDJLMCkuVW0?=
	=?us-ascii?Q?zdA53cKZr8IuDBDWmUxowulVS9Z8q6Ck6/ASCPoxWVC50PR43tG/T+hxvaYo?=
	=?us-ascii?Q?ONMdceKw0navVtdlrgROLyWXF4rblDnMQpFPV6qVdXyH7a8yRn9L8nAOcRKs?=
	=?us-ascii?Q?fL4oNFnmXbGXgR6YTv/OhvgL2kWn6Q1pWxI0XQ4riHNCWczpOKZNymomqI2F?=
	=?us-ascii?Q?mq2m0VjJkuj9p09aUqtai4mYKhuIOM2opFU7F35J3YecDqHV3eg+wpgni2hU?=
	=?us-ascii?Q?9TJ+NbVGjixFJnSPuQ6lZGN70azMri6CK7Fs4Juecc6k?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0614ab3e-3043-4797-844a-08d9e1107cee
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 21:11:58.3243 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ekIDsCVRvlxi7bqyxca7niqec3kmwOXWCvjCaJjVukVAwtJVKQ/EqOecitHABb3AlTOoHU/nhk5IP10CmrVgIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3368
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10239
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	phishscore=0 bulkscore=0
	suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2201260122
X-Proofpoint-GUID: EV1vOI7aqriyYxpcPMbwyuxDRqxWeZVL
X-Proofpoint-ORIG-GUID: EV1vOI7aqriyYxpcPMbwyuxDRqxWeZVL
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v4 7/7] pmem: fix pmem_do_write() avoid writing
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

