Return-Path: <SRS0=XsJU=PJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CD3C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 02:29:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7E401611CC
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 02:29:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7E401611CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-V6LXHCNdPM25dyYTA9PE5A-1; Wed, 20 Oct 2021 22:29:43 -0400
X-MC-Unique: V6LXHCNdPM25dyYTA9PE5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8301A1005E4D;
	Thu, 21 Oct 2021 02:29:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E65210023AB;
	Thu, 21 Oct 2021 02:29:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CFF534E9F5;
	Thu, 21 Oct 2021 02:29:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19L2TZdx001942 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 20 Oct 2021 22:29:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C657E40CFD11; Thu, 21 Oct 2021 02:29:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C009840CFD01
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 02:29:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2E56811E78
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 02:29:35 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-132-Nrw7KcfkO66xhfC8vX2aGQ-1; Wed, 20 Oct 2021 22:29:33 -0400
X-MC-Unique: Nrw7KcfkO66xhfC8vX2aGQ-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19KNjJrX019159; Thu, 21 Oct 2021 00:12:05 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btqyphuu9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 00:12:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L0BD3W010014;
	Thu, 21 Oct 2021 00:12:04 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
	by aserp3020.oracle.com with ESMTP id 3bqpj7vuvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 00:12:03 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB2759.namprd10.prod.outlook.com (2603:10b6:a02:b5::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17;
	Thu, 21 Oct 2021 00:12:02 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c]) by SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c%5]) with mapi id 15.20.4608.018;
	Thu, 21 Oct 2021 00:12:02 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Wed, 20 Oct 2021 18:10:59 -0600
Message-Id: <20211021001059.438843-7-jane.chu@oracle.com>
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
	Thu, 21 Oct 2021 00:12:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3086f6e0-b295-4ae8-3830-08d9942767f9
X-MS-TrafficTypeDiagnostic: BYAPR10MB2759:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2759CF48A81FADD320728D33F3BF9@BYAPR10MB2759.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: SwUxeInXWh+dgh6GbaS/ZG2Nv9S0cNJ6M42dZaeHBDJs558Q90G0R2h30G+aA3dCh2LfzmJWyQA/ahTIb91NfBH9wHpRUhPbLz24LQwxTDi2nc/xAnN81kzemmPwmScfKMnCd7/XDyPhNWepbqP7QhOJG/zrvKDustSxzm/HfGh4o5epcm/eNGP6fBFBnssAbDxt2nCnv4qpz/1+OKzrUhVmjQ9c0/wPCAa9WFhx2pRUtBlj+iqMPv/AF4kvb6otCDzlfbF6S9YH6BBLGvXXCSjDPvAp3qZMIvPDeMPU2rWMuEXGxzjNGrYzFgxJbJb0TjgDCSMAT28yHD/I11P91WFAub1FnuSHFRk3aKzHaNcXYE10DyJwa+YvavKRJ69ZB3NiS2/JycT1JWrbsyPkIelWMNA26e/3FVsoy83xHacU916cXMiiVuI9rZAUsd39hJk88SVbBHi5f972R8ZvpNZx+xCVg9n4pXEM6ARcSocBkGxcAHXwPzA5d5jxD/wpZu/x3vBTcacXOaCpPicCnYwiaSSI9DWOBaxNAzNM9sM3P/jYeH1YUA/eaLlA9fubW+bxuFpxRaNZahyUxaK4AC1B65GAErZBXlHRpDPpSIyDVDI/ug4nOCZc7qlLl6ZeOLx2FaMycGoOyu2JjwI7/9n5XbMup6N64gRaHe8etM3IVwf7o8zfY5cDzPMdMpPW
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(316002)(5660300002)(1076003)(66946007)(66476007)(7416002)(38100700002)(83380400001)(36756003)(66556008)(921005)(508600001)(6486002)(8676002)(86362001)(186003)(7696005)(52116002)(8936002)(44832011)(2616005)(2906002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1JriRzLKMTs+EtHmGlcariODedtlWhYMtDDMliqQ+PnnOYwKb+N265nSqLb7?=
	=?us-ascii?Q?8TImsA4Pmr5rNPkLiMJLcMJtzDHoo9bxJeIzfLWjqjB+TJV/qy2JLPWxmUPE?=
	=?us-ascii?Q?cO473bekRvRPx32LXD+5J2ZBvmmaBBSUMlXCdK3+mZll4QjuDJ0+jPbTxT8c?=
	=?us-ascii?Q?J8E5Z5RkTcdxdlFJR+I9jo8VxRyNGJDvmpH0Z3uDKgEzlRX/C07RxtaXhwqq?=
	=?us-ascii?Q?c475/0ZCWr2829X+9FzM0tggHKJwGeVLLB21iIyZG5BW3iEtJDsSjNG5CWKO?=
	=?us-ascii?Q?NlU458r2dPNhZQgamu61TBQ48pimdGVZP3gIZ1h1lMB7FKhHMrBA2EIScmHT?=
	=?us-ascii?Q?9YM4qC0eIcO0bWwFvE5JhK3Va2FKziCN1gh482FtlfefF4ZB6maXsgA9L6wE?=
	=?us-ascii?Q?3F+wRWJ75CwPNSEkA2rkSXT0PrUUU8JHo4Ec90iopP10Z5yR6S/zlqu3AiWm?=
	=?us-ascii?Q?KxslpKSQMHgqVEYdiTCTuacobcyruTAU/cRpNxZFHjYKtEr37Mdcw3HWyA2Z?=
	=?us-ascii?Q?ViDB5NN4tgFilwSBcFHCOYcRw7TgDO7XWb/rRydso0C1zs4ZzEl0xs+zN45G?=
	=?us-ascii?Q?xx3q7dOKU0SSoToXmzYzWxb8hvniCBfxrb4rCSMftf38CJTcQHYLr4P9rOqM?=
	=?us-ascii?Q?mY3SrVDiW2c+JvM88GmR5hwhjBXUBEl2Lyz8SvRaSArKg1q9JasUbZvHXzue?=
	=?us-ascii?Q?KN6jZtKmRwy+29XBZSSoxbTsYjVbjxlzkg030EPGvGyudI2SLvgr4kY/ztmG?=
	=?us-ascii?Q?3p98F6isss1Qv3T9jlOBQJOj2ZavTBQMj5B7GkKmLKULreEB9fAKXMAuQ+NP?=
	=?us-ascii?Q?4mV/IUkmR7RwkoMFwhCBDANQ+VzRO8pcmSJNLS1jW9eHseVV8vP1ktu7mmG5?=
	=?us-ascii?Q?bycp7geH8gJK/zT4KpPmqq8yjBkQwJKeKfCNLy59Exc3U0T5FldExKael5dJ?=
	=?us-ascii?Q?vTE+Z00seULukXaTTKSJ6VnRTWIfiVT+hAC9UW90qjVU6aflWzlasKKCWFWY?=
	=?us-ascii?Q?4SHs8qoQF2x0cVRX2ln5ED8cCX44z3lCkknCULe9XyxKK87lu4OjvMrIQbZx?=
	=?us-ascii?Q?80+GsibrZcRIlcyPNwpVZgtOXfEWg5my2Ae8H7IJIlZPmy96I+0Y9TLi0wPy?=
	=?us-ascii?Q?SexNpj68zuim3kxt7xsEVW6ad51jnZPtwTgzpOZo3XJ/IAOF49aJXcswzWgA?=
	=?us-ascii?Q?xUg/HPAipIfuTuiRVYAHYkLH29pu9panYqfrB3FeLj5l6DIBhTqf1v8Pzkhh?=
	=?us-ascii?Q?xZngUX68nlU3KeSsKt9FJvrnPzInBPqPsTWS8TqeOoNFe7H/mG7R0mN5tYSg?=
	=?us-ascii?Q?v3/dtJeqUjuVbQbM1WoYTD4HRUc8Xbozeto1fjJ6YE1RTQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3086f6e0-b295-4ae8-3830-08d9942767f9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 00:12:02.0369 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jane.chu@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2759
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	spamscore=0 adultscore=0
	malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110210000
X-Proofpoint-ORIG-GUID: jlTJ0Uy0HZJPhubLMe06VMJMPNG1rwVD
X-Proofpoint-GUID: jlTJ0Uy0HZJPhubLMe06VMJMPNG1rwVD
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
Subject: [dm-devel] [PATCH 6/6] dm: Ensure dm honors DAXDEV_F_RECOVERY flag
	on dax only
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

dm_dax_direct_access() supports DAXDEV_F_RECOVERY, so it may
translate a poisoned range. But if dm_dax_copy_to/from_iter()
don't have a dax_copy_to/from_iter() foundation underneath,
performing load/store over poisoned range is dangerous and
should be avoided.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/md/dm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 764183ddebc1..5f7fe64d3c37 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1058,6 +1058,8 @@ static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 	if (!ti)
 		goto out;
 	if (!ti->type->dax_copy_from_iter) {
+		if (flags & DAXDEV_F_RECOVERY)
+			goto out;
 		ret = copy_from_iter(addr, bytes, i);
 		goto out;
 	}
@@ -1082,6 +1084,8 @@ static size_t dm_dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 	if (!ti)
 		goto out;
 	if (!ti->type->dax_copy_to_iter) {
+		if (flags & DAXDEV_F_RECOVERY)
+			goto out;
 		ret = copy_to_iter(addr, bytes, i);
 		goto out;
 	}
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

