Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70395C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Apr 2022 22:46:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-rAhAeWzkNV6QGu-vwx5k9A-1; Fri, 22 Apr 2022 18:46:30 -0400
X-MC-Unique: rAhAeWzkNV6QGu-vwx5k9A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90F1A1C05AA4;
	Fri, 22 Apr 2022 22:46:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 479EC56864E;
	Fri, 22 Apr 2022 22:46:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B8F991940355;
	Fri, 22 Apr 2022 22:46:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A74061940351
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Apr 2022 22:46:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9A93956864D; Fri, 22 Apr 2022 22:46:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 956DD56864C
 for <dm-devel@redhat.com>; Fri, 22 Apr 2022 22:46:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7614D3834C0B
 for <dm-devel@redhat.com>; Fri, 22 Apr 2022 22:46:26 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-dOKPDFxwNc23rZoatUK0QA-1; Fri, 22 Apr 2022 18:46:22 -0400
X-MC-Unique: dOKPDFxwNc23rZoatUK0QA-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23MKYfT9024754; 
 Fri, 22 Apr 2022 22:45:52 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9qdhb-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 22 Apr 2022 22:45:52 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23MMewWS005311; Fri, 22 Apr 2022 22:45:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3ffm8bpst3-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 22 Apr 2022 22:45:50 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB2550.namprd10.prod.outlook.com (2603:10b6:a02:b1::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 22:45:48 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 22:45:48 +0000
From: Jane Chu <jane.chu@oracle.com>
To: dan.j.williams@intel.com, bp@alien8.de, hch@infradead.org,
 dave.hansen@intel.com, peterz@infradead.org, luto@kernel.org,
 david@fromorbit.com, djwong@kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org
Date: Fri, 22 Apr 2022 16:45:02 -0600
Message-Id: <20220422224508.440670-2-jane.chu@oracle.com>
In-Reply-To: <20220422224508.440670-1-jane.chu@oracle.com>
References: <20220422224508.440670-1-jane.chu@oracle.com>
X-ClientProxiedBy: SN1PR12CA0057.namprd12.prod.outlook.com
 (2603:10b6:802:20::28) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8aa2a83-9940-4263-57c7-08da24b1d844
X-MS-TrafficTypeDiagnostic: BYAPR10MB2550:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB25503A82522192427C259E0EF3F79@BYAPR10MB2550.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: LO5z5Wm/1zJjg85z3zmIpfAq/rfTrZNxTHMCb9bgtIyyhYz/XBIf3knCn/3q8K/R+bUQId183VwdwE+tZzinwkbfoLvsbf1Q81UJ4gMBhzt6iUitqw4NpKJBWbiHQrA2UXPEYAm89dIZCRIQGXQ6ZLGlfWC+gvXq7iYkw5PItOoMxjGb1ptzGXGS9Q3vBcRAYHnF4D5Ron04EvC7e/GxxAcrWN3o1m+4fCforbI4awSRy30bDnOhHXJ0ogrfwpqV3g5XKqd9VjjSoLmvxzvqKF9gTulu3hpU+t7BJ7ScjJMWU/bjlSJGKovE4tNYIRomfId8kZ2O9tev3UNNnsvVsiTFJbT/pAF1dwaoX7cZVy5GPM/AEORsPljaSKttcIC0iYyPOCcwcgw3Pi508edvUqqbDa+w2rUwV0T8+10IOtJAbe8KXCWR7bqQeWL6gEgZ9acc4soqGbs52X8IYefvoVcpc63NJ/4KlEitPIZRxxhPGKtAss2AR6YrBFcw6Ghu2BK2F3O7/H3is/UL9devtJ298zKaexPQh79hYDlRSos6AbnBUtFYpVZXaQubX0UChm7vwCXfInF3vZO5ev13uUwoh9Rxxt8fyFtj3FnYc3PaWqN1ecqpWK0hxY0/BD8VoHWhCI+3XyNwviofeGZ1Gj2kWfF/bYC2OBhbEXfUrzNEiFhDLTTjwQG084gPHStgf0NYEZ8gf72cJk0PH6Kz7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6506007)(6666004)(6486002)(8936002)(508600001)(52116002)(83380400001)(36756003)(316002)(66556008)(66476007)(2906002)(8676002)(4326008)(66946007)(38100700002)(2616005)(86362001)(5660300002)(44832011)(186003)(6512007)(1076003)(7416002)(921005);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LI4ZXwYs8rmI88QdHZ/A4yj/ti26/5UzBRULKA4P1hbjNKbrqiRzhM7835YJ?=
 =?us-ascii?Q?h/JOCSOmQmvyGI2ilrkgMLswyhMiVtz+2vt6fM5fSwJJIV9qLZiZ6tb8g4fd?=
 =?us-ascii?Q?1F+V2LKvVqEGmu25/nEFSMAMu9y/Wmo6+N8rkgKy8eQLUr0YyEFLbiSiVVIy?=
 =?us-ascii?Q?OYOSGrfwkunLcDKnNClUDnMbnKFPGdaeTkGZqQqZUQ6ptm7UwsttGefYyUcA?=
 =?us-ascii?Q?z5S4S7ieAJY5p52jbp+YYxtFvn0dbdhlH4uswAOfo4lR67ju/+80pR7kG/3L?=
 =?us-ascii?Q?i0fk/2A+Tf7FRYZJig1uPl9Q+RDQb4RWk8Irozs+FJmHNjYn5gcmF/cojGl/?=
 =?us-ascii?Q?W9BEiXciAEbyM7SKrJBaokJKxzVXC7critMozjm7euF7IjRFBn7/dBESKWAG?=
 =?us-ascii?Q?KFy7nhpxDQcJ9/StDUKLHNYqjNgq3FiPOOmy4dFQx2i4CEanGp/+7S3+4A5c?=
 =?us-ascii?Q?8ku7k2o+D2mpERNRFyD3yJxVaqv1OVv+Yp3p4rv2dtr8l0JRpgSMM7QgNN5n?=
 =?us-ascii?Q?mTUNSI1NhhL4NQoPDnflodgsUGStZNdICVWvLjCleK61+69V8WhBMDjugWL6?=
 =?us-ascii?Q?I/5dir8aRqlP4v2I8idptBgHcRGq7ckU46CK6ebx0A1buNRUK62CqK1qlWCU?=
 =?us-ascii?Q?bGNWhKQ5jPnCJ7vrhlQj+Xw0pu+uVY7M2AzvBz0UtzKVmvEFDt3Y4LdBBxWo?=
 =?us-ascii?Q?MvKol0wIy2be9mcu7ea5gH2BtYJKGqQOYqWG/a5oCretnWREv83RStO1Fy0N?=
 =?us-ascii?Q?S2X7Pwra9p7jF/MMQOo/LtLyspz6IZs2IZMtVhw0ul+lfGuVMrkKIo+C9diD?=
 =?us-ascii?Q?sg0wQmCyoeGofJEj+lTaSXOPTvVSJTwqcXaTYo+QxAbdtRkrm27yPmUfAkCH?=
 =?us-ascii?Q?jyB3PAWjW3OQYoNjoj0jRx9dU6jnCJwPgEUCe4xBv28ovCEvrlSe7vfThsXS?=
 =?us-ascii?Q?/iBH8iAdeYQ4YJ9XhQF06PphXANN043HnL0pmpvupR8CcONf5LIc2W0rGAWi?=
 =?us-ascii?Q?rwMY9vdF6baJIaw+iq5skHhMaF0RIC6lnEacKUCY1gwRMhSG782P344QmobF?=
 =?us-ascii?Q?CMQQ4xOA1hO7yMaPnfN2vym6oS9WTFvFOTd+atclv8IzB49SP+hlp2gjGhBd?=
 =?us-ascii?Q?U8oqIZGO/P2NKZLonFucILNU9BCZkQiaVYvkodBrw3AvPsd5td6K1CSnQ5sp?=
 =?us-ascii?Q?+9QwP2IQ1fY0j6sPYoZj6r5zuZpMmwygFD6tgMg8TWr7/17sC7Jq77Pmpczs?=
 =?us-ascii?Q?/B5jtfLJ/6sA1gfZEXm0YE3KmWWLDosiVX/N6vlldqG4aIvg3FAKmi2RqFjv?=
 =?us-ascii?Q?k2bFMA9qMQitNna1W6xkKdQ9vBF82kTaQV27917vhJ2Cx7CnSHrq53iw6wGd?=
 =?us-ascii?Q?CMgxtm2zcXHwk/LY+kexdWPTjPgZ2NdzoTn/fNbC+yuRsvbh1dPfhZSfBnH+?=
 =?us-ascii?Q?YmJxKV0oG+lUX0Q9wiZTkcEMie61J97cbGyyhl8uLhyS0vHrGHXmKExvwi8o?=
 =?us-ascii?Q?+/YHlhWzHxWdA3k8ZJoDiD0g4o9Rng96Cwiwz/6c2LIv5pUyOWISEWW6i+j7?=
 =?us-ascii?Q?x7mteH94rBj44d33pe2rWxVQKoscjxPYxm+43D67ARDPTln+RbBefA07u7JE?=
 =?us-ascii?Q?2f8fhMm044hEXqHXyzrfChlPHC1TLVb6vU/fSIspVV6hNR1Gm07RTLRAAGzS?=
 =?us-ascii?Q?x4i2Tojk0xsqLIqoj589/lbOmXOw5vU/dLRYjjlklDUZBlJ7BWH92eGMlDe3?=
 =?us-ascii?Q?MjZUpgaoT1aM2gvuEgK++Y4b/xptGw0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8aa2a83-9940-4263-57c7-08da24b1d844
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 22:45:48.4858 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ECkFmRlDT6XwM9BRZMMzx2IFxkDGTRFFzjjn8D+jn04uxcNCyQs3fYEFkpY1JQ5zzC1OPTkUoHBtoEpzT+Ialw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2550
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-22_07:2022-04-22,
 2022-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204220095
X-Proofpoint-ORIG-GUID: Y2MmNMVRgnjk7fj0aoz3OJRLn1hv-Pxj
X-Proofpoint-GUID: Y2MmNMVRgnjk7fj0aoz3OJRLn1hv-Pxj
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v9 1/7] acpi/nfit: rely on mce->misc to determine
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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

