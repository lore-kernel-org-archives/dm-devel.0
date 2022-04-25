Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 134B5C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 25 Apr 2022 11:57:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-IC4IhmnkMXGGat1KOUV5lQ-1; Mon, 25 Apr 2022 07:57:17 -0400
X-MC-Unique: IC4IhmnkMXGGat1KOUV5lQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD4B8899ED5;
	Mon, 25 Apr 2022 11:57:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EBAB840CF91E;
	Mon, 25 Apr 2022 11:57:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E2B0B1947BBF;
	Mon, 25 Apr 2022 11:57:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 807B81947BBE
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Apr 2022 11:57:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 34BE94679EF; Mon, 25 Apr 2022 11:57:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F5624679FC
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 11:57:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C8121014A62
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 11:57:08 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-PxI6-lFbOBetv0qrH-YIUA-1; Mon, 25 Apr 2022 07:57:06 -0400
X-MC-Unique: PxI6-lFbOBetv0qrH-YIUA-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23P9Oapr031660;
 Mon, 25 Apr 2022 11:57:02 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb5ju02f-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 25 Apr 2022 11:57:02 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23PBsvdP004747; Mon, 25 Apr 2022 11:57:01 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3fm7w268kc-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 25 Apr 2022 11:57:01 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN0PR10MB5126.namprd10.prod.outlook.com
 (2603:10b6:408:129::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Mon, 25 Apr
 2022 11:56:59 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5164.025; Mon, 25 Apr 2022
 11:56:59 +0000
Date: Mon, 25 Apr 2022 14:56:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <YmaMgPr8bM/0PFUi@kili>
X-ClientProxiedBy: ZR0P278CA0090.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::23) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bf822e7-7b71-42d7-61af-08da26b2b3ee
X-MS-TrafficTypeDiagnostic: BN0PR10MB5126:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB51265CB6EBE8FDE54D7F6CF18EF89@BN0PR10MB5126.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 9uf7c9gWcht337zbdr5ZpNqP8Ri0MlPTSmny1SZRoyp95AkQpZ7LCEWqzwwh3QVgtW8octZBxZk1qGFpylT7HZH+hLhhEPlkG05I0BPx/joWcnOaIAzJWSP4817D9OMv3cHqeHBvoqdUOE5AEB2PCucWWQSMF9HCAwfhwhNtsfr9D3yX6B2jLtLl3RZqRr5aPTt0LURYnFpIQVIFfP2EHW6xhuArhp3hSTLB5qW5YIdhCXIFZmds1sXe2Ykp2DqjblOwCcxYsXw1sO6K36IiUEgBv55wX9DgR85sIRgT5EQ9dSmMelNOVSwHHCWuwdLpgwpTNrIPjR+J27mk5IU4/h+zw34Ez3CTDDECGBLTDf1LHGHvYl905JTrsCY9qpj04tBS8nNUo/s3YJBkwB7rasbGHM5eQ0Jy3DO7cdSj7w2TEsJhwCVQnZczOjgLPyGKgnFgYFRZPeCHLG4yRfUduo99MM+TSF0CB866d31dA+HRroH9V7zmr6wmuHASFBjefbI/t9hjq6zchMIqKXLUv3cCOfFf7jQfgfOBsWX/aOppKuE+kx+0mx278qGCPAiHhCOA1+T9N/Sr2AIF5IAxfxVfUxy0fhXlmWjIvWBZFu4PA1kQjVTtW/poLbISg75f3ofhBl3V3ZReP+wYwCPIvzOr12sZdibAyaICzgb9ZXZSSyBUNdUeRG6ELM8NZqgL81lLrMC6Dy2tvQNOujjkTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MWHPR1001MB2365.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(7916004)(366004)(86362001)(66556008)(44832011)(66946007)(316002)(4326008)(8676002)(52116002)(5660300002)(8936002)(186003)(83380400001)(26005)(6486002)(508600001)(6506007)(9686003)(6666004)(6512007)(4744005)(66476007)(54906003)(110136005)(38100700002)(33716001)(38350700002)(2906002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IlBpg61Q0vvMk9rz8LJmgFaC1iKwRlzI1w5CCHO9hOakSF2MMduOzNYCXPz6?=
 =?us-ascii?Q?rSIrXlSBxuPK4zz5jbfrOQgZNY6dUoLda/b/M4c4CTzCPL3pjdDY3nRUnGUA?=
 =?us-ascii?Q?J9Nl9UGqQEPdW0t46Ow8AgLKMm8Q4Fz66z+z2WnmqMeKP4wAGJ1RKPihUKkD?=
 =?us-ascii?Q?3h4XiLuS796Nz4sbvew3ayTgf6nP8ciMN0PT7mBw4pWjw3p9wc627OZMYg4G?=
 =?us-ascii?Q?bsthwQaYk4krsGk1rdZ2M1QUTWWPMO/HTxk7nWSYoYlfBoB/8jMFTBOb47Oi?=
 =?us-ascii?Q?vElnWKBUmNE6/5NSlaXYieGay/yIzMAYsI/kmrh4QQKMjrT08oShQrXd2drn?=
 =?us-ascii?Q?8mcRO8pmbiLXiC875McVZilhIczTa6KRnvBa7A8Vph1gKxgOfGHm3jilcHHy?=
 =?us-ascii?Q?00qrX/LXMrENUCoIcGoPbhQ+ekciF+Ycq2Gx4Pv+8ziAYesY+MoJGNWTWnYV?=
 =?us-ascii?Q?AYDLmlaP1OuAq/c0aIgrfyQiWAemRHJmY5tz8k0Os/ykAjEdGuqOPX7bW/XV?=
 =?us-ascii?Q?ra59eMiB+vh9vQ3q0iKsg4uiGLZtLsxGH+OmXL/2ecFH0PlTHOyPOfG+i1eB?=
 =?us-ascii?Q?6ngUrFn5BRDTACxhpVXC6NnFtLUbKZshUpqA7k8arDvJNwBzFpyP0QYOv4oH?=
 =?us-ascii?Q?w79YoFlVuOqxXGddaj0bkvnI2E9UPfuKSDxwz6n+AR53JfYF/kjcggCwOSkC?=
 =?us-ascii?Q?/UPBiIekPFvn98BSZ8dGc+boj0X2ASp5D5cPAU8YqLm5qoKO1z7T+xnL4+2H?=
 =?us-ascii?Q?ls8YrK0XngnfI9Htx7whPE751cQqL1339LeNQKDVPzwwi2QNgd6ooLIb7DaR?=
 =?us-ascii?Q?/ClaOT9yWkiYH+kEelP0CcUCaI8xmptuRIS3LlVJCiozPtgA5qCwWM3aDH6M?=
 =?us-ascii?Q?vQJoMnjw9G5rzyd87xQJ2APsRGenoN2kovNAvmNS/fpc14E48TAVrS29gN5H?=
 =?us-ascii?Q?KQuNyVv0JfViMa9nR0PZU5UyC4S6mjFifWX6LE6QQo3PUTCxl0Hb1rAWuYb4?=
 =?us-ascii?Q?/5UNCgxpvxn67iHbQVv8UCujZpqFA3QBgUQ57VOZGbfkaoZRetNPb8spsQO9?=
 =?us-ascii?Q?TbWxSnaXmdk/6BngvDCy3Hbsp9NNxFn/4j50yZJQnhf13IP9wRNCPyJGwVCx?=
 =?us-ascii?Q?+65hhCEybGUNNyVIjedgrHKmAJ3vtZ58G1/5iNKLwSwn6qG8xwFNVRfpCp7l?=
 =?us-ascii?Q?8Q000P13HK/9issf77ydH4ol7tnY4q+dXUuVqcx3mMgKSZnVaXWsdV2jRXQF?=
 =?us-ascii?Q?6u+D6ros3ER83ylKw2scOrgHcGZ57q49RV7dBf5lXhAj5f7XPkMWOlD3vi/G?=
 =?us-ascii?Q?1FWhrlwL6pu2H5mO5oDaCpHSCptZ+oRbSVscmXm9JF2wCCLgHQbyjjXVdfI1?=
 =?us-ascii?Q?1/rz/3fKjJT0r7m1nma/3/UrdgX3v7WyU8uBN7tRaAkGEH7b4jKThSskUDdI?=
 =?us-ascii?Q?deopPcqxWWvIAyR83BPmVW0GzQHDawsnl/9OwIvEOj2JyrkTxc7AefpPjU7t?=
 =?us-ascii?Q?obwp06W5SjWUKjh0w2w8AuP37eL6X5xA6TZG7JQ8JYTdct7Ak/Tc3Gbu6c/8?=
 =?us-ascii?Q?FCzb/dwNJjYm8Kf+TrbhbuDSaZS/04WI3K/PWEzriwVxjS9JIsvf9BQbgkxi?=
 =?us-ascii?Q?Bp6ugl15d5X9rb4t3DsQj1MzL3G724rf77RCKudMODKLvQtxUt3oMK70mzMV?=
 =?us-ascii?Q?hvLxgk9vV/+ohkKuiZXcQ2eLI+WRYMORGYK+aYKbZrnZhGhKwfKo3Ii41sd0?=
 =?us-ascii?Q?q06fDbRF/NFRi31fml2x3GoW4aZFQso=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf822e7-7b71-42d7-61af-08da26b2b3ee
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 11:56:59.2062 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YQvGKRwXdiOCkqtxjOfeKrV0P/H4CrHv6ZCIoF09gcBmWRrFhinSy00qYzn7WmFhJvJ3Uw+nEsPmERmnlYg+dcyE8ONk0JMlVgSAYelk7VE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5126
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-25_06:2022-04-25,
 2022-04-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204250053
X-Proofpoint-GUID: j62BFL0wDx7z03HWVNXn3rKjlSXUIoqp
X-Proofpoint-ORIG-GUID: j62BFL0wDx7z03HWVNXn3rKjlSXUIoqp
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH] dm integrity: fix error code in
 dm_integrity_ctr()
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
Cc: kernel-janitors@vger.kernel.org, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The "r" variable shadows an earlier "r" that has function scope.  It
means that we accidentally return success instead of an error code.
Smatch has a warning for this:

	drivers/md/dm-integrity.c:4503 dm_integrity_ctr()
	warn: missing error code 'r'

Fixes: 7eada909bfd7 ("dm: add integrity target")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/md/dm-integrity.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 36ae30b73a6e..3d5a0ce123c9 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4494,8 +4494,6 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	if (should_write_sb) {
-		int r;
-
 		init_journal(ic, 0, ic->journal_sections, 0);
 		r = dm_integrity_failed(ic);
 		if (unlikely(r)) {
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

