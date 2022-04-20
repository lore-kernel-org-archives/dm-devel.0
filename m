Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32E9BC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 20 Apr 2022 02:05:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-tiS64RlSPci9Cx8aiuRRoA-1; Tue, 19 Apr 2022 22:05:51 -0400
X-MC-Unique: tiS64RlSPci9Cx8aiuRRoA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A22C3C02B91;
	Wed, 20 Apr 2022 02:05:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0500E145BA71;
	Wed, 20 Apr 2022 02:05:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C9ED81947BBF;
	Wed, 20 Apr 2022 02:05:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5EBD019452D2
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Apr 2022 02:05:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 514C8112C067; Wed, 20 Apr 2022 02:05:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BF7D112C063
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 02:05:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC5623C02B8D
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 02:05:45 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-dAFb5tGeOLCryJ-NuM-EjQ-1; Tue, 19 Apr 2022 22:05:42 -0400
X-MC-Unique: dAFb5tGeOLCryJ-NuM-EjQ-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JMYKLu019412; 
 Wed, 20 Apr 2022 02:05:03 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ffm7cqh32-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 20 Apr 2022 02:05:02 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23K20grK037450; Wed, 20 Apr 2022 02:05:01 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3ffm843twf-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 20 Apr 2022 02:05:01 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by SJ0PR10MB4557.namprd10.prod.outlook.com (2603:10b6:a03:2d4::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 02:05:00 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5164.025; Wed, 20 Apr 2022
 02:05:00 +0000
From: Jane Chu <jane.chu@oracle.com>
To: dan.j.williams@intel.com, bp@alien8.de, hch@infradead.org,
 dave.hansen@intel.com, peterz@infradead.org, luto@kernel.org,
 david@fromorbit.com, djwong@kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org
Date: Tue, 19 Apr 2022 20:04:29 -0600
Message-Id: <20220420020435.90326-2-jane.chu@oracle.com>
In-Reply-To: <20220420020435.90326-1-jane.chu@oracle.com>
References: <20220420020435.90326-1-jane.chu@oracle.com>
X-ClientProxiedBy: SN1PR12CA0112.namprd12.prod.outlook.com
 (2603:10b6:802:21::47) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82d48990-a8e4-4d49-f883-08da22722c79
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4557:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB455700AE1D705D421CB8C57AF3F59@SJ0PR10MB4557.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: mkFgsxeJSrnrDLYPv78FAmi5RzYwbqxGZDmGt9QkvEaDqMs8fX1blEMk0WJkFWKOGzbWDEi5gf1s0ZVGDo1+35q031qcPS+89dey+u6fPkkXGdOhSsLcr4MC9w2Y4uxVaVdBaDj85bmPP/4eVAL6E37IgZ8C8+VaOMdxuShOTSexIyS0c3+omZdfenfcrmlivTYKNlEPbWyOOJMD5F3T7jumt52QST7VdtSf4Yo9WWWK6HBYSx2V9txnUkjMMZo/fKdlL7SH7Adn+IMmQnhAfSeOQVzV6Ygjxnh9C+xAfhvPYl7Blw9EukGYtj1PQ0zR53sg09UYgqmxgfNans4sSvbdsJLqFlccvNHo8fyV34ArxtXZ8jLj/MSv93aprl2jgeyKKI4mYuFN/XAiKx9RY1mh45ZV0cPbzUln1paz75Fq9ZVjcVcv2AJi6Nhz0nIdVSC5Xd1FAoIjywXjjmMTlmcW50UqNzNTE3zQvWdQYKKipp0PvItM0K0ON82AlJhelSNQW/Jqh6U0ZhI2jL49OcGVtW04kYNftTmiJUGAa58vYOHmtJN+/y8Tgpk3NbcKP9C7qEFH5dEKsO+UkfhJS4Ml6oGGrIyQiIt5mwl4yy82Fj4roUVBV6fIiQcopyAKWpPltDFUWwSIBRNSvd4touzZlwaa7KKrK7pxvBHRV4Jrxc0yMAgNrvP/9eupjWxb
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66476007)(5660300002)(83380400001)(86362001)(4326008)(66556008)(316002)(2906002)(508600001)(1076003)(36756003)(66946007)(186003)(44832011)(6486002)(6512007)(8676002)(2616005)(921005)(7416002)(6666004)(52116002)(38100700002)(6506007)(8936002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DKFoPMwrg2wdl3hrgu7kaw9B/f7ZCwkxKY3YNzZjhRH+Klz3953uWx9cYmoc?=
 =?us-ascii?Q?Liv6eCUaTR6Lk6k200N3XlNDNir4mnqFegIzan/OQO5WZexyo8K8L3v5UZUE?=
 =?us-ascii?Q?/dci3B4T6CPSNH40bI9wHie7kuYljVqMc3PrjPTO/kA8YL+6+JCPWWw7JReQ?=
 =?us-ascii?Q?JxpggWfx0kpypcdgLGN9XfSN23kEXIOQYQG0d5I/bjNVFLXW71BEGd984szb?=
 =?us-ascii?Q?204O62fhdliHZ+FWR8mdrf/pbNnCuccZr23JG+JaszB32qNHcC6egPhb88HT?=
 =?us-ascii?Q?YfYc3zP9KakLkN3l50IfKEfXfv2BthzdEHeTk+y62mTJfeF2nD8PNI59nZWS?=
 =?us-ascii?Q?PJp0VhkYXfcZF53tiFHcRYi4wOrrQMnFibYtf/4ZTj9nvsExUFw44tlj9F5u?=
 =?us-ascii?Q?82eVAisZ+40G3kcom2eqxD5tbwN3H9EmVo1l46UNDl2Ed9d8zjzEAuTxSmK2?=
 =?us-ascii?Q?mFSSsN4dXayLozClWmX5CmKF0PVuFWQqRzctB3DaaY+j61ql7h3CEqwQtIMg?=
 =?us-ascii?Q?m7hrcU3N9ywnezFrDNj3abstaKhpl48tU17gKEwODleSSnUH1AlF46VLum40?=
 =?us-ascii?Q?qcnL0kc5oxal2RGru8euH1u0W44q1G7SjNGwjyOLycvZInc79Zw1DJ9aEn51?=
 =?us-ascii?Q?rYFMP22T7dRERlCw/4MK84AEvxvsNkjZimuQ69gRRqgwofTGInV3b987E1Qn?=
 =?us-ascii?Q?PcBP2egrmNyG48H014p1Y7QasIbnMWBAkNcq3nknODxYunOpflm6WDsIHOuN?=
 =?us-ascii?Q?i0PTCJLFm0Ggco4NwyGBCNqoiXrEcgMNiL48QXFsPOIrFV4VMb7eP2IeX6jE?=
 =?us-ascii?Q?a8IHxNrLtlLmo4/q1sqbzz3KBeH7jibQ3kMCWOoDVAjar8fz7rqvpxQZmEoQ?=
 =?us-ascii?Q?sPTAzI1bxDo8/DBZoXbruqbhIEMUDg7TrT3nvPLmECvTlrk+GBmtdNfycUlw?=
 =?us-ascii?Q?ohCDF0IYLzspJ9Lk59AvuSMDRq1fAMR1cyR2Qrie9iIJuzFZpODZWfJGFeCB?=
 =?us-ascii?Q?95GYD0417BA9V/kfPnlxLVHbJFFVflPev3VqDp3LwJsN/YMSBwfgChgQXYVc?=
 =?us-ascii?Q?oyXMnFdkP01ufh79D7OuESAh8ArRZBgZ2Kbp9HFmjjQyx+6IuNe0qxe5s0b/?=
 =?us-ascii?Q?z06k8JzuHS9qblWsdHu3vly8Ty6HtAJsKifGe0wWSElnxpHc/wyJdwVI7blS?=
 =?us-ascii?Q?wKlUiax4GGwOeAJTmfTnfvc7WjSPtREeq6lTb60XLNeUpx5d65gqhDbOM0tZ?=
 =?us-ascii?Q?U+tfXtNra0i1K77Kpxcqk051OcJmIhSDosv5qKlzdNSitsALdJMN39Dn+tOp?=
 =?us-ascii?Q?hTXZuyLqF5L5eXgVmJJFClbuVALtaiXXPEbtcESu4xM7YBVUIbBpwg3JUFvq?=
 =?us-ascii?Q?RMTwDdDnXmReinpHb3DAZSqzdD/qFcdlc/Yywd+Lyb3iZ4z3fGAhSzh6Yx14?=
 =?us-ascii?Q?wHgsD+LT06QszjPRRf2gUf9M6UcH6GmeB3U/iRZKyvDpV7+gMGCL0oUZymcH?=
 =?us-ascii?Q?UOFJWrnyzxGFq36K/QLgBsgUs7Kc/6lpHv4qOfYKToI/Swq5fNj5SxUxeF8O?=
 =?us-ascii?Q?fu/CkP732fRLrdBMcvarjYchJFZYB3GCCLRXIuZtGlIsfupO5w1VW6+j97dc?=
 =?us-ascii?Q?0fR8yZQDgfOedJ1sfH4wxy+1M2oJZe/c+mWR3OTUc5677EBm6j3cUdAMKdm3?=
 =?us-ascii?Q?Fnlq91Yz2mWgAMf9G1upptiab19GQ75XFoboZQ6LZBfjIhv8R26GMh14hgMn?=
 =?us-ascii?Q?s57dth+Jtb44ChvgE1KZUQLHiJoxL8M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d48990-a8e4-4d49-f883-08da22722c79
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 02:04:59.8996 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9okA32EIfG/nLytrqLdf+rBBn2moceoZHakPJdCb3EBMr14UY6VgyuPFdhUoqBpknsTU+jAF7YZKXYh5EYRhWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4557
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-19_08:2022-04-15,
 2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200008
X-Proofpoint-GUID: TPF3GHbqNR-zZ2v2WWQNeapTBB3Uony9
X-Proofpoint-ORIG-GUID: TPF3GHbqNR-zZ2v2WWQNeapTBB3Uony9
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v8 1/7] acpi/nfit: rely on mce->misc to determine
 poison granularity
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

nfit_handle_mec() hardcode poison granularity at L1_CACHE_BYTES.
Instead, let the driver rely on mce->misc register to determine
the poison granularity.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/acpi/nfit/mce.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
index ee8d9973f60b..d48a388b796e 100644
--- a/drivers/acpi/nfit/mce.c
+++ b/drivers/acpi/nfit/mce.c
@@ -32,6 +32,7 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
 	 */
 	mutex_lock(&acpi_desc_lock);
 	list_for_each_entry(acpi_desc, &acpi_descs, list) {
+		unsigned int align = 1UL << MCI_MISC_ADDR_LSB(mce->misc);
 		struct device *dev = acpi_desc->dev;
 		int found_match = 0;
 
@@ -63,8 +64,7 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
 
 		/* If this fails due to an -ENOMEM, there is little we can do */
 		nvdimm_bus_add_badrange(acpi_desc->nvdimm_bus,
-				ALIGN(mce->addr, L1_CACHE_BYTES),
-				L1_CACHE_BYTES);
+				ALIGN_DOWN(mce->addr, align), align);
 		nvdimm_region_notify(nfit_spa->nd_region,
 				NVDIMM_REVALIDATE_POISON);
 
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

