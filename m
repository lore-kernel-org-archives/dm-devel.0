Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9874C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 19 Mar 2022 06:49:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-0BprXlzRPK2an6jKWJQkIw-1; Sat, 19 Mar 2022 02:49:34 -0400
X-MC-Unique: 0BprXlzRPK2an6jKWJQkIw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35A62100B8C8;
	Sat, 19 Mar 2022 06:49:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 03B14401053;
	Sat, 19 Mar 2022 06:49:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B222C194035B;
	Sat, 19 Mar 2022 06:49:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 633421940341
 for <dm-devel@listman.corp.redhat.com>; Sat, 19 Mar 2022 06:49:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E5750145B978; Sat, 19 Mar 2022 06:49:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E04A7140265E
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 06:49:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0B64811E78
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 06:49:27 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-ZhwU7xcrOYOoSQpLfdFc2w-1; Sat, 19 Mar 2022 02:49:24 -0400
X-MC-Unique: ZhwU7xcrOYOoSQpLfdFc2w-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22J1hWKI001709; 
 Sat, 19 Mar 2022 06:29:10 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0g5k1-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 19 Mar 2022 06:29:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
 by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22J6MkAJ028031;
 Sat, 19 Mar 2022 06:29:08 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com
 (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
 by userp3020.oracle.com with ESMTP id 3ew8mfrwjn-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 19 Mar 2022 06:29:08 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by CY4PR10MB1798.namprd10.prod.outlook.com (2603:10b6:903:126::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sat, 19 Mar
 2022 06:29:06 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336%8]) with mapi id 15.20.5081.019; Sat, 19 Mar 2022
 06:29:06 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
 hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
 ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Sat, 19 Mar 2022 00:28:28 -0600
Message-Id: <20220319062833.3136528-2-jane.chu@oracle.com>
In-Reply-To: <20220319062833.3136528-1-jane.chu@oracle.com>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9caddc3-7e76-46d1-809e-08da0971c4bb
X-MS-TrafficTypeDiagnostic: CY4PR10MB1798:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1798CAC8F55A764B3050D216F3149@CY4PR10MB1798.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: N5bGlc+erw/EVNfrGAuQsEybCZ3gcdK69SDlfloAagjkZnFIrVgrcGv2mLxIvuuwOaica3k2TVXwvQ2oKomCKSKdhiHfQydvQ4caQ7ZtT1tS/1X3q8EtBMGHAOiwYahakTJNhBLb+NDRRVJi/Uzccm0THsE4mub5enIDM3ntXv58bSxyE8pMY7MBnG343x42zbTAXlqBwYSdb4B7faucg3OlGW0xIULRb/pGkvUmyKRLETck4fzX6xO/vRtKBxngEDux2gxeckUa2WVCheWXDIK1oUwfhAXVM0mA5hJaxOIvjQzyx2I2mLtSXixzdN4EGXDkOWlpXy7Q1pO3e4v6iZKSJ5LO9zN0GsxtUnVMxtdCXm68RCj/FLFYOSjawgx7ZUnxVBCedybNo5/ZpOpCTUoNxlmqokFbal4slS0aN9zRl3wPgAw/Xwl08+O42iPw3yLDIeiIQM/d+x/TCbnS2eyvwkPgcOB4LoOX9hL49NY3LUC0eWBVgggDOt3HgMeSQ+PmdkuFO7IHW6/P2+F20JMcR+evlmIvFDdGkAMiy9w+3/2r3y/wxI2btBs0jLnkLWYOmGK2B/iWNuopNDKESet9zwzG1PecVcxxSPcgNjKe/DTeHl9rMD58XifusdGli/GWmLvwDcsjaXMvecK0ZAjmDi3YSsAaJMqEBcqaE/HmBoTVngA2FHSiIbBNMhRg9Wsd8fMJtPc09WS4J17CIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(52116002)(6512007)(66476007)(8676002)(83380400001)(66556008)(316002)(6506007)(2906002)(38100700002)(66946007)(508600001)(44832011)(5660300002)(8936002)(7416002)(4744005)(36756003)(1076003)(6486002)(86362001)(186003)(2616005)(921005)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mwYwvJZo19hXF07BhyUXxGivvBuBW0S+2vhfW2Gzn1c48V+6gu3IFpzhbk+a?=
 =?us-ascii?Q?en3Af7rJQgq+IszkMR4LTUfllaILZWyZNEDC+W0nTS9tucHPU7Sybh9RJqE/?=
 =?us-ascii?Q?cFPULaVDDromGdJ6jf3bA6vGgrpavB5Cc6hHu+fokfNBTI27GH/D6qmTfpc/?=
 =?us-ascii?Q?1TfHbj3o3plTtiDQxg3pKs+IQM/w31QCSA1rrgqmt6OtUXeLVlUvlln1a9OL?=
 =?us-ascii?Q?GSuSsm9H3jYCp0JgqRrXJDfmqIHQxLxM+VyQ6wh1tHzmqpb8FYh+/EfgwPRI?=
 =?us-ascii?Q?GB6bzDSn4YBZFww5YLY89Suv93pmfmpBmoXPadsDtmT4BRqKwgZBxkj4k1yQ?=
 =?us-ascii?Q?y0MIMAys8UzneQNYKiz+fP8F8mFvgysAuMQVsCXTmhN4B/7KinjekED3nv+y?=
 =?us-ascii?Q?rktPNImC9BBjByTnoi125mtwEseei2XIehBKi6Ifrb60Ex3VDUVdU9n0CeWQ?=
 =?us-ascii?Q?VKM6V0aXrLvq0MT3hIlD6Ofl6HVqTW74ig85RpY2YQHE0w3ghA+TW/BIVPre?=
 =?us-ascii?Q?CQz1sG43pZ92eu0ZNpdjq99nfQ1vRy3uf5s4ABdPH5kZonWGO9XEkbKnAS53?=
 =?us-ascii?Q?VziJdkULsWTbGhm1c7MUyMWaxDDBYIA3RfEP9QuSvo36XxtScskxzh7Xr3/L?=
 =?us-ascii?Q?vpkJOPi1T8kzE0gZBB4Iq/7CBjNKpTNqjwNChwHIHLs6KHs+JXT298fyJqy9?=
 =?us-ascii?Q?G/JaAJPTRhO1Hdyy7pR3pfDA9dcDZU8k0E36VjfNcnrHZ/Cjr6RHJtY6Ffjv?=
 =?us-ascii?Q?6PR9Jko8qR4PzBHMNQ0UHHVhx/l36b6nPVZRgJSVaKkzZAc5PlSISFCFNT8L?=
 =?us-ascii?Q?vfAC7JQe2GCXawZGYtkm3R/ZaB+URoN+4/rypJ9T6lqmWlvBtM9babLfFXUl?=
 =?us-ascii?Q?/Fw05OojyP7hnrHWig6RB78MprVL3Pb9hA2xOJ3g7A/yLWHyN5JhXU2AGGZ4?=
 =?us-ascii?Q?jK1t5XNF2rT9xvKIpjDfwb+qVidAa6pRTZAROvlcSjcGJcI/90RLW9NhAcXe?=
 =?us-ascii?Q?iBQM+ALB+myyYD0WNHBkQc7/r+IbGtiMEQDLDgwKoy8ZnQu8s4s+CVTKMcPE?=
 =?us-ascii?Q?+K86pkbGXce5e81BtH1swhkn7CY602WHba4jm0puWEjiYrT7KQ2ix7u1kopH?=
 =?us-ascii?Q?hs7/+/E8d2aNZ5i6bFphJav9vG1D5m7UTIHwlQZGptTdaKb0IBO7p0+kKOkk?=
 =?us-ascii?Q?WGdeZm6CptGr481KR8C0dfmJ/bSM99+G8YTzVAuQ4AD3uOvjq89EkPDYOnQP?=
 =?us-ascii?Q?pSA0UdUvW5aDHnSC9CZNeSzZN2nMZ/TBSHR8JClMMXpiRHQh91TMt5STMi4L?=
 =?us-ascii?Q?aeLR6tsH3D2rfiXgznSn/bMK4IWBesrkjHcdDyrkYKCigpQKmsMj7RYjufg4?=
 =?us-ascii?Q?oSsE62T8GcGmWAPymAd5EMj8rk0A7wi3XcpzFf+QD5ten1zai35Ixaf7/Cnw?=
 =?us-ascii?Q?VcGgYJZ1qy+HNzeYKlVIIrKn8Il1t3ouBeYa4OA3df3hnMJRYcVMNUo/toqb?=
 =?us-ascii?Q?3519Qq1Oz+d4CeI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9caddc3-7e76-46d1-809e-08da0971c4bb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2022 06:29:06.6495 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bQQsYdQeD6pUtDnOf4J+sI3axJsdWuvKFK8pzJTMVHu4WgQyWozFWqfJla0inFnkA2sUTPJS9dzo31vfLsuQSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1798
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10290
 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=826 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203190038
X-Proofpoint-GUID: ilkLvOq1iKrCtLQGpAotQwpPApzqyRw0
X-Proofpoint-ORIG-GUID: ilkLvOq1iKrCtLQGpAotQwpPApzqyRw0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v6 1/6] x86/mm: fix comment
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There is no _set_memory_prot internal helper, while coming across
the code, might as well fix the comment.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 arch/x86/mm/pat/set_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index b4072115c8ef..042cfac6272b 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1816,7 +1816,7 @@ static inline int cpa_clear_pages_array(struct page **pages, int numpages,
 }
 
 /*
- * _set_memory_prot is an internal helper for callers that have been passed
+ * __set_memory_prot is an internal helper for callers that have been passed
  * a pgprot_t value from upper layers and a reservation has already been taken.
  * If you want to set the pgprot to a specific page protocol, use the
  * set_memory_xx() functions.
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

