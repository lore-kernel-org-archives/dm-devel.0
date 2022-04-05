Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E4FC433FE
	for <dm-devel@archiver.kernel.org>; Tue,  5 Apr 2022 19:49:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-hnIBCUGdP86dvCnSKSXZVQ-1; Tue, 05 Apr 2022 15:49:03 -0400
X-MC-Unique: hnIBCUGdP86dvCnSKSXZVQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E23B8899ECB;
	Tue,  5 Apr 2022 19:49:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE9E1401E0B;
	Tue,  5 Apr 2022 19:49:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F3D51940369;
	Tue,  5 Apr 2022 19:49:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 75270193F6E6
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Apr 2022 19:48:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6966253AC; Tue,  5 Apr 2022 19:48:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6427553CF
 for <dm-devel@redhat.com>; Tue,  5 Apr 2022 19:48:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46E47185A79C
 for <dm-devel@redhat.com>; Tue,  5 Apr 2022 19:48:59 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-2-CJWZ4pPt21M5MTyUh5jA-1; Tue, 05 Apr 2022 15:48:52 -0400
X-MC-Unique: 2-CJWZ4pPt21M5MTyUh5jA-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235GxnFj012451; 
 Tue, 5 Apr 2022 19:48:32 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwcevwu-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 05 Apr 2022 19:48:32 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 235JaOxr002758; Tue, 5 Apr 2022 19:48:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3f6cx3tu81-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 05 Apr 2022 19:48:26 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BN6PR10MB1425.namprd10.prod.outlook.com (2603:10b6:404:42::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 19:48:24 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%7]) with mapi id 15.20.5123.030; Tue, 5 Apr 2022
 19:48:24 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
 hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
 ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, x86@kernel.org
Date: Tue,  5 Apr 2022 13:47:44 -0600
Message-Id: <20220405194747.2386619-4-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-1-jane.chu@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
X-ClientProxiedBy: SA9PR13CA0054.namprd13.prod.outlook.com
 (2603:10b6:806:22::29) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b14eafd5-565d-4d27-c9a8-08da173d3eab
X-MS-TrafficTypeDiagnostic: BN6PR10MB1425:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB142504CAD71F9898A431CC24F3E49@BN6PR10MB1425.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 3M73AXR8AD9Xed3HGymjDfeqJxelryJAmZTNQ+Q74FFOnkorcQ2nSVd03vTSp7cmUtXq9evCkagsZciarNCfTzUtZfNAb+Xw1uipD1e3Rj/3ecIe1qX7T5kf42CLui5q1xYDTVuzo0xFkBxz7czQQWy4fDYFv64CsrH2brCak/4wylB/dEsK0g0JjKO6KZg1mO5tSkb3xInvv7p5/zndGSjTNi98kBXQd5T3a+Mxen/rVuowKw0x7c37oF8eoP0++quqLACBkXdYTgYECVBsAoMODEH6aKrglGi4JdqvRY9QhtAdaAfNh+ng9X8sDk3oWivpgEQboDedIZG3mmMKx74aPsbe3Z9deRXj3aCg+QCZYNT2U8a+8XM85r93z2nfY6YdfdertBHnrT29tW3AC0PjYZ9Noc84Lfu/YxsWvz9Yw/bcnlpR2d44jleRidvrj/VQLNyF33825q/YOx60zf1lYvdFltjlqHfDawUUb71L0KNAY9VT1a4QfwYL6wmX4V1qb1s0mm0k3t6dZuTJPbSB98GBxC7V/XG5aGtV12t5H4gKDCgvShLOoS9T8XTM4rCNQezcHWXJst5zrhuQex1DF+bDky1NlajKY6YDY/iUsYWE+8MYPEFVDFNilTKX8c1/ZFfKmTvT9Zt8LnhO4hAkZ/WDIwzMNeEzBOyYz6aBBni6qajS/sLJMyCeA8/dOvwhRdSsNPsNz05ZmRr5Ze3WIJIUoGA8GEljDokpmxLWWrssxNDZ3VL+7UZlg/DUVYyfcm7IEEtX8AXtKeqqBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8936002)(66946007)(5660300002)(86362001)(44832011)(36756003)(921005)(83380400001)(6666004)(2906002)(38100700002)(66556008)(6506007)(2616005)(8676002)(966005)(508600001)(66476007)(186003)(7416002)(1076003)(6486002)(52116002)(6512007)(316002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z+ncs8MZHhgqbdH60EYSct7kr2I8TNxY7VxYBVg44yrUq5POAj0rZkfCvNg7?=
 =?us-ascii?Q?09SZOy3n8oXkfNLJndiLUR3uBDTlE6tymdyNIlc70SaPuby3JNpoQvzpWH5Z?=
 =?us-ascii?Q?HufuXUKNvkej+qW2Sg8fAoJufwN2AO7e0RYYaAyXa/plPe/tvSnpK2Lu8XBn?=
 =?us-ascii?Q?0kJxIQUkqlS8BPsMx01kX+2Fd8RU3mHmK0Yh5Ypi8hGgA3j1aDJ5Yw0TgsaF?=
 =?us-ascii?Q?mjap5QSgQUIRknkQXfJaeGbRrPHOw8U9EIvlP8UoyMbrUOuGKvHEN+8VJaPS?=
 =?us-ascii?Q?h3u/19wMybzGzQBKXU9V6dJOwDrpscffziAV8xRNOctGkVSsPXHKfGg175Tz?=
 =?us-ascii?Q?tzY90HT2ojBakLBMVQnUUa19mTzU+z8A2DLQ6GmClgJ7fr70YYK8F0r73Ixj?=
 =?us-ascii?Q?9AA8bJV3WC1W43Rn+E4GPVGh3MD9JK+dWGnHgMr7Fe0JOKyufaayzNRRpYOs?=
 =?us-ascii?Q?iix7te0EhClezf/T3oNNmFtjh18x6LbO6wyeHcjjvDgpdktVo+D9HquYZxqO?=
 =?us-ascii?Q?fy1AgF6TBZ0YhZjKQf9xeYjV/r7jVXRgYwv7ARzVZct0ZoJhQ/jbhJLMsw9e?=
 =?us-ascii?Q?Ugqp302ntzFemSXcKOrHlZtAhObqcDakVLus+oIGXzwS7PzrWrAStoK/lIrN?=
 =?us-ascii?Q?4Jy34yEUu5ibY/1AvpxVdoIvX5QV44eBORraQ5tqsCFDstrjldyuwqI7lJoF?=
 =?us-ascii?Q?wog8/vZ/9fQjaHvCrNkY4zWvQpgU6coX+6QLruY5xmeMtbGB2PXwFxzKUOeQ?=
 =?us-ascii?Q?eeF0OmMqN+hKAZFr0xii/YPABhidRXEzieJm1H+mUUDJKEdp4hhrxRC7ryq0?=
 =?us-ascii?Q?sUhv8WfLQkriBKbiZuQdDp4cy+7gAInFDJBQOZ7vyfhKb9N8oTiZvrn/Uxfu?=
 =?us-ascii?Q?4GJmi6YchXuKa/Zrmn2qvUUqOyfwixRP876dq7+R7gyZ28UUgvG3UT++A3f2?=
 =?us-ascii?Q?2aSEXEh/UTalLGGi1BzuiPRFAJ2ePFJbjiiH3b2nOuO0pxHdJrLOR1JzTTdk?=
 =?us-ascii?Q?ohEypk16Swrif3GHRvSh+tvu07yBKNBBdbeIwpaQxUHQzWzv/ItEWggQlVg3?=
 =?us-ascii?Q?A1qx2MHjJ9KuY5q1W5XfZLRxQqiHl81JHOx5nLdZQCU6GoLDiS4gmiUJHtHa?=
 =?us-ascii?Q?p0bV90gEMvvSqJ7sG8GZlT/GUuemJF24wyqQRCNDavcBop6TIlVq5GjRdKH8?=
 =?us-ascii?Q?7hYrtpOB5ndApGKVwqwcLl0UCyPFVUmLQtO9h6xDi2T6wHMv9MwJsoJ8hfbL?=
 =?us-ascii?Q?hlKI85Yly/8Iq7mQMqmvfeJ3s7ax+jtGfLDXDStKOsM1q+by8wSUm+IJTaCS?=
 =?us-ascii?Q?XGWgSNti1437a2ylHCb2xq6Js2KXaMSUm3cRlQeHkFTizOz5WNw/9Q7AWew2?=
 =?us-ascii?Q?4GuEeshoqCDFbaelfRUfIUkbGNe12aS2IQRdg27FgJszYO0YZABr87yEU8ok?=
 =?us-ascii?Q?zvQ1FSJxMl1iUXi6Y0cPPW3lJYEtJzEDIaXOi6WaLBNWasrvCHHB4WcevHqx?=
 =?us-ascii?Q?eu1j4iysN/FH7nKmEx65M6jMfiuolqtRJVfTF+Qq8I1kwl/+VTFzakCGRWhN?=
 =?us-ascii?Q?WeAOClCpTQwINDLUnQiZKkq8hvJZs2KHYhXkkMXIqrJ/4DqvwZws/mq9k64p?=
 =?us-ascii?Q?Tew2IU5VN7+Qmdi43kMUYBhcen/QEFFMZ4J2MukTa4ZstlkPdhKabk2e9pqL?=
 =?us-ascii?Q?Y2bkFFsgmwONnLnfE56qP5AddGInCcQE/U8LJ2UaNqgT5NDo26kaJtUO78Rm?=
 =?us-ascii?Q?/3WHSJIfBWtBXWtRCf+BkJFcr3s++uc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b14eafd5-565d-4d27-c9a8-08da173d3eab
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 19:48:23.9966 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJFkgUJzCLR7p++waM+ie6SeYa5z2O8bpeZlWj8YgRtukscnw9axnPmKSPIKm+LVEVYowyiVzGtamO/ozHMyqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1425
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-05_06:2022-04-04,
 2022-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204050110
X-Proofpoint-ORIG-GUID: 3lIL0t-hjYA2tUvZz0iG8haTZhPPkWuy
X-Proofpoint-GUID: 3lIL0t-hjYA2tUvZz0iG8haTZhPPkWuy
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH v7 3/6] mce: fix set_mce_nospec to always unmap
 the whole page
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The set_memory_uc() approach doesn't work well in all cases.
For example, when "The VMM unmapped the bad page from guest
physical space and passed the machine check to the guest."
"The guest gets virtual #MC on an access to that page.
 When the guest tries to do set_memory_uc() and instructs
 cpa_flush() to do clean caches that results in taking another
 fault / exception perhaps because the VMM unmapped the page
 from the guest."

Since the driver has special knowledge to handle NP or UC,
let's mark the poisoned page with NP and let driver handle it
when it comes down to repair.

Please refer to discussions here for more details.
https://lore.kernel.org/all/CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com/

Now since poisoned page is marked as not-present, in order to
avoid writing to a 'np' page and trigger kernel Oops, also fix
pmem_do_write().

Fixes: 284ce4011ba6 ("x86/memory_failure: Introduce {set, clear}_mce_nospec()")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 arch/x86/kernel/cpu/mce/core.c |  6 +++---
 arch/x86/mm/pat/set_memory.c   | 18 ++++++------------
 drivers/nvdimm/pmem.c          | 31 +++++++------------------------
 include/linux/set_memory.h     |  4 ++--
 4 files changed, 18 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 981496e6bc0e..fa67bb9d1afe 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -579,7 +579,7 @@ static int uc_decode_notifier(struct notifier_block *nb, unsigned long val,
 
 	pfn = mce->addr >> PAGE_SHIFT;
 	if (!memory_failure(pfn, 0)) {
-		set_mce_nospec(pfn, whole_page(mce));
+		set_mce_nospec(pfn);
 		mce->kflags |= MCE_HANDLED_UC;
 	}
 
@@ -1316,7 +1316,7 @@ static void kill_me_maybe(struct callback_head *cb)
 
 	ret = memory_failure(p->mce_addr >> PAGE_SHIFT, flags);
 	if (!ret) {
-		set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
+		set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
 		sync_core();
 		return;
 	}
@@ -1342,7 +1342,7 @@ static void kill_me_never(struct callback_head *cb)
 	p->mce_count = 0;
 	pr_err("Kernel accessed poison in user space at %llx\n", p->mce_addr);
 	if (!memory_failure(p->mce_addr >> PAGE_SHIFT, 0))
-		set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
+		set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
 }
 
 static void queue_task_work(struct mce *m, char *msg, void (*func)(struct callback_head *))
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 93dde949f224..404ffcb3f2cb 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1926,13 +1926,8 @@ int set_memory_wb(unsigned long addr, int numpages)
 EXPORT_SYMBOL(set_memory_wb);
 
 #ifdef CONFIG_X86_64
-/*
- * Prevent speculative access to the page by either unmapping
- * it (if we do not require access to any part of the page) or
- * marking it uncacheable (if we want to try to retrieve data
- * from non-poisoned lines in the page).
- */
-int set_mce_nospec(unsigned long pfn, bool unmap)
+/* Prevent speculative access to a page by marking it not-present */
+int set_mce_nospec(unsigned long pfn)
 {
 	unsigned long decoy_addr;
 	int rc;
@@ -1954,10 +1949,7 @@ int set_mce_nospec(unsigned long pfn, bool unmap)
 	 */
 	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
 
-	if (unmap)
-		rc = set_memory_np(decoy_addr, 1);
-	else
-		rc = set_memory_uc(decoy_addr, 1);
+	rc = set_memory_np(decoy_addr, 1);
 	if (rc)
 		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
 	return rc;
@@ -1966,7 +1958,9 @@ int set_mce_nospec(unsigned long pfn, bool unmap)
 /* Restore full speculative operation to the pfn. */
 int clear_mce_nospec(unsigned long pfn)
 {
-	return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
+	unsigned long addr = (unsigned long) pfn_to_kaddr(pfn);
+
+	return change_page_attr_set(&addr, 1, __pgprot(_PAGE_PRESENT), 0);
 }
 EXPORT_SYMBOL_GPL(clear_mce_nospec);
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 58d95242a836..30c71a68175b 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -158,36 +158,19 @@ static blk_status_t pmem_do_write(struct pmem_device *pmem,
 			struct page *page, unsigned int page_off,
 			sector_t sector, unsigned int len)
 {
-	blk_status_t rc = BLK_STS_OK;
-	bool bad_pmem = false;
 	phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
 	void *pmem_addr = pmem->virt_addr + pmem_off;
 
-	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
-		bad_pmem = true;
+	if (unlikely(is_bad_pmem(&pmem->bb, sector, len))) {
+		blk_status_t rc = pmem_clear_poison(pmem, pmem_off, len);
 
-	/*
-	 * Note that we write the data both before and after
-	 * clearing poison.  The write before clear poison
-	 * handles situations where the latest written data is
-	 * preserved and the clear poison operation simply marks
-	 * the address range as valid without changing the data.
-	 * In this case application software can assume that an
-	 * interrupted write will either return the new good
-	 * data or an error.
-	 *
-	 * However, if pmem_clear_poison() leaves the data in an
-	 * indeterminate state we need to perform the write
-	 * after clear poison.
-	 */
+		if (rc != BLK_STS_OK)
+			pr_warn_ratelimited("%s: failed to clear poison\n", __func__);
+			return rc;
+	}
 	flush_dcache_page(page);
 	write_pmem(pmem_addr, page, page_off, len);
-	if (unlikely(bad_pmem)) {
-		rc = pmem_clear_poison(pmem, pmem_off, len);
-		write_pmem(pmem_addr, page, page_off, len);
-	}
-
-	return rc;
+	return BLK_STS_OK;
 }
 
 static void pmem_submit_bio(struct bio *bio)
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index d6263d7afb55..cde2d8687a7b 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -43,10 +43,10 @@ static inline bool can_set_direct_map(void)
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
 #ifdef CONFIG_X86_64
-int set_mce_nospec(unsigned long pfn, bool unmap);
+int set_mce_nospec(unsigned long pfn);
 int clear_mce_nospec(unsigned long pfn);
 #else
-static inline int set_mce_nospec(unsigned long pfn, bool unmap)
+static inline int set_mce_nospec(unsigned long pfn)
 {
 	return 0;
 }
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

