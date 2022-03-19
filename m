Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44ACAC4332F
	for <dm-devel@archiver.kernel.org>; Sat, 19 Mar 2022 07:51:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-kgIqnA1HNDa-4ug_tcHl7Q-1; Sat, 19 Mar 2022 03:51:36 -0400
X-MC-Unique: kgIqnA1HNDa-4ug_tcHl7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79E26833960;
	Sat, 19 Mar 2022 07:51:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 41C4640CF8F2;
	Sat, 19 Mar 2022 07:51:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C6D17194035B;
	Sat, 19 Mar 2022 07:51:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 38B5D1940341
 for <dm-devel@listman.corp.redhat.com>; Sat, 19 Mar 2022 07:51:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D934C9E61; Sat, 19 Mar 2022 07:51:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D3E129E60
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 07:51:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C1CD811E75
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 07:51:27 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-M9oU0-c7PkeqekbWQ8J-5A-1; Sat, 19 Mar 2022 03:51:25 -0400
X-MC-Unique: M9oU0-c7PkeqekbWQ8J-5A-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22J1VW7c017377; 
 Sat, 19 Mar 2022 06:29:00 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcg5pp-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 19 Mar 2022 06:29:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
 by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22J6MICS027495;
 Sat, 19 Mar 2022 06:28:59 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com
 (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
 by userp3020.oracle.com with ESMTP id 3ew8mfrwhv-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 19 Mar 2022 06:28:58 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by CY4PR10MB1798.namprd10.prod.outlook.com (2603:10b6:903:126::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sat, 19 Mar
 2022 06:28:57 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336%8]) with mapi id 15.20.5081.019; Sat, 19 Mar 2022
 06:28:56 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
 hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
 ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Sat, 19 Mar 2022 00:28:27 -0600
Message-Id: <20220319062833.3136528-1-jane.chu@oracle.com>
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2d9f55b-cbe1-4291-a40d-08da0971bf07
X-MS-TrafficTypeDiagnostic: CY4PR10MB1798:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB17980AE1BF3BF108A174C849F3149@CY4PR10MB1798.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 2Dq1Y3EysgEPbQKG8ZI3WDeNlBuTODkjc/kPAHJ2wHIYqx0piONDuuyF7IJ6u0jvMGAmBS7gz/YK35/WTziXcNfci2XUNlOiqUdpp9DfF4XQC2hSe1CjpelzBvSfYM8LE/6dQlaNfzr9EEAHOP3YZzpQxvLLzb2lPeAiZFMjmXu8XGBdSlM1suoqNYAnbbJWW1h6XmkgN3O00PROVNVBCZZlahm1qPnv90P5WbHka65fjXYNBW40Ggc3iiFzl8IJDMBIrHXRJYNw1mtazs3QRTkt8l6fhDz6IMpSFZ+uZCrIQKOM0LeskYcrlNRdX4u5IOpAyLO4EhgM6exi2JFjp3A90xJb/HR7wYW/vQ5L8WwhtTXsGI0QYlaDelPysSTmu9YzO3POPTku5l32N8U1ylPXW3Q4jUUHrVl4rofw3v163YeJJSnCzpqM8MhwEfKvP1HGOit8czUpjT17NjvxUFfVxxwHUynib2dJM1YE9VVsVbmLL1jy7L6mSJEwBqIHj05LqPCZH38EYZnsPjDLOJMGwqTvjNfiG20OGzvSYV3LzDE6Ce0T0wkgd0P0FgFhc4vdI8naJqcsugbhUSA3yC5RQvEDAOtTKMp2D3VQyA0ane+H1OQuiHRLt4DKQET0pfSqQSV+1j0zMul6aujYFAXHX8nRkqUuKRzwGAlU2yvyu8C2xIPZ7qXapZrqdM+Ir5THc0yvdCERfhfutxj3OhICqvrvk3o5R8CRrdZVBJemDukne4xgI1amxxfaa6kdqH4GmIvONPryoL5/nIqUXCMLeNgOe7O2hQneEDnrBXmgpVnBbjQGi3SVFVFMClcM
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(52116002)(6512007)(66476007)(8676002)(83380400001)(66556008)(316002)(6506007)(2906002)(38100700002)(66946007)(508600001)(44832011)(966005)(5660300002)(8936002)(7416002)(36756003)(1076003)(6486002)(86362001)(186003)(2616005)(921005)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q4GcftBlqGcRlNVsaCKLsBxGr3+lj3Q/zChm7r9PqZof1RM2cXU7avrZ2N7f?=
 =?us-ascii?Q?b+5eLRSznlfUO1MWw4Op8WnNalRJ5y78ekwwKjAl88RM4C3OCNmaUgEMNIVM?=
 =?us-ascii?Q?JBMDsnPkHeAgPqLQSsBqaCZ7oiJN/rVM0XVGe+lkxeBo1Z0Yi4OFpOGz6BBU?=
 =?us-ascii?Q?mVnWHL7XA2QGh/vukxoFI6pguAQfn2mJJNoF5WMJuGZDCNIg0wat/Kiv2+U8?=
 =?us-ascii?Q?Z0IAIZ4YtZ43h5ZAyZfRah8l2XHLVm4BwdE/4CWSQtt0uDdy2CEd60u7TzlC?=
 =?us-ascii?Q?rYaltOcT7+Ib2HcJqhS8oPvFd+m8jMfH9Dkm7WspnbX3QHtymNdQXyCN3TCK?=
 =?us-ascii?Q?QeB0GdbNnrJi5j6Jvq74cO191lS30V2SsVK6Uw0YCdUdOqKRzPCJ+xmd62F/?=
 =?us-ascii?Q?KJrQPpHPRXri8hIBTbs2jzRDpE5WNVPrnCVT6Gsx58gN0vevZcsUdIVK859N?=
 =?us-ascii?Q?jVlwcl0Pnx4lL7ZKlsT9ZpERVpzvz2WB7MHSiv3/ia2QiT5Xzxu0fUBUGgGm?=
 =?us-ascii?Q?pB9QW7xrV3xysT6O/q0d8f11SJfBWWmAvftVUaW0eblYqVCCsJy1ShrhkWhy?=
 =?us-ascii?Q?rVndFDBNAmyx66CpB5uaDM+u1ANOT4D/naPuZ2IAO0/K+Re3Y5kyPCZDeJxS?=
 =?us-ascii?Q?iN+umTU2aHO9xVCDeAiqqEJdQuRv2M+iYPR8p4+V6uFYELhZbkUpACXwEaZA?=
 =?us-ascii?Q?aqQGaKIiHyEJoVmhI5FJViHxVpz+bdmKjkHLf09VAQxeeJPtH2++gFSA0OHD?=
 =?us-ascii?Q?orp6aKpO9dLRUAwgnSXEjuVBXuJT/t7mw3lSNgbm48VIYqeLEqbJ25ZgsTBE?=
 =?us-ascii?Q?se3HRaGfp2o5ijIeO4RTkvZ2CTaMl/mKuNpBdmwJcTNdIu22pqSkvj2fDiDI?=
 =?us-ascii?Q?PElYNWcQsEqGXvfGzIzyM6Y8xKIqsfE+/i+4mM64d0QuG2L2VoSf86d4ym1b?=
 =?us-ascii?Q?h8+u1Uu4bnr7PU4Fs1FiWk64G/kb45gmKAh9tCeyO09Kskz0kNbuKD+NhsVg?=
 =?us-ascii?Q?IM2tGCGFzvhrGblCUWxwg8JaKMJqQrP9RX5neb3IDKbGET7ZyXQB6eHGY/pd?=
 =?us-ascii?Q?7WsIRQWiAcwrVwB/CDhKP0IHZjdYJlvPGFIvmqIjFsUestmlQ28uGC4XFdbc?=
 =?us-ascii?Q?AVpo7biH3ienXn9Z2SDA2XapKuJhZPS4TO5Vv/RzQvv24HyhEiaa/Aj+Suh+?=
 =?us-ascii?Q?1YLvwGeL2DFtQ2HxU4rkEas+rXrd3aoR9NsriEUldGlo2wFFIOLHel3LaOEO?=
 =?us-ascii?Q?Vz/h5O7Z9SsxYuJdGuDpYEWWwm4fI57blPJPwRdkPwfyi20/3MrdnufQxo/8?=
 =?us-ascii?Q?Pn2VvndvWhXwFQ/Y0bJLvU7bVG4M5+y4p88UghIEA2xeuvrJcfTrhnZYvjk8?=
 =?us-ascii?Q?gsRq6aWsVwAgVy2KJYex0ylYI9TyFCQI/et9mmwCmzpgppbNpv8rv5b124YZ?=
 =?us-ascii?Q?83mLZrtami4Ip6zCtPhh1fST5oUC7w6GMD5/Oo+YISDy/cL7kazwIw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d9f55b-cbe1-4291-a40d-08da0971bf07
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2022 06:28:56.8668 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s3/4BRPyacuYIQER7dSRk4zQcH61jKIaNtRIkQSZvxqKLjhXfHqUW2hPTEvyvDYXlhIVP/e9bcpb6eaPxFIyWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1798
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10290
 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203190038
X-Proofpoint-GUID: RmwJNbKd_ExqLUtVqUfRu_s3-RairxE7
X-Proofpoint-ORIG-GUID: RmwJNbKd_ExqLUtVqUfRu_s3-RairxE7
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH v6 0/6] DAX poison recovery
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In this series, dax recovery code path is independent of that of
normal write. Competing dax recovery threads are serialized,
racing read threads are guaranteed not overlapping with the
recovery process.

In this phase, the recovery granularity is page, future patch
will explore recovery in finer granularity.

Changelog:
v5->v6:
  . per Christoph, move set{clear}_mce_nospec() inline functions out
    of include/linux/set_memory.h and into arch/x86/mm/pat/set_memory.c
    file, so that no need to export _set_memory_present().
  . per Christoph, ratelimit warning message in pmem_do_write()
  . per both Christoph and Dan, switch back to adding a flag to
    dax_direct_access() instead of embedding the flag in kvaddr
  . suggestions from Christoph for improving code structure and
    readability
  . per Dan, add .recovery_write to dev_pagemap.ops instead of adding
    it to dax_operations, such that, the DM layer doesn't need to be
    involved explicitly in dax recoovery write
  . per Dan, is_bad_pmem() takes a seqlock, so no need to place it
    under recovery_lock. 
  Many thanks for both reviewers!
  
v4->v5:
  Fixed build errors reported by kernel test robot

v3->v4:
  Rebased to v5.17-rc1-81-g0280e3c58f92

References:
v4 https://lore.kernel.org/lkml/20220126211116.860012-1-jane.chu@oracle.com/T/
v3 https://lkml.org/lkml/2022/1/11/900
v2 https://lore.kernel.org/all/20211106011638.2613039-1-jane.chu@oracle.com/
Disussions about marking poisoned page as 'np'
https://lore.kernel.org/all/CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com/

Jane Chu (6):
  x86/mm: fix comment
  x86/mce: relocate set{clear}_mce_nospec() functions
  mce: fix set_mce_nospec to always unmap the whole page
  dax: add DAX_RECOVERY flag and .recovery_write dev_pgmap_ops
  pmem: refactor pmem_clear_poison()
  pmem: implement pmem_recovery_write()

 arch/x86/include/asm/set_memory.h |  52 ---------
 arch/x86/kernel/cpu/mce/core.c    |   6 +-
 arch/x86/mm/pat/set_memory.c      |  47 +++++++-
 drivers/dax/super.c               |  23 +++-
 drivers/md/dm-linear.c            |   4 +-
 drivers/md/dm-log-writes.c        |   5 +-
 drivers/md/dm-stripe.c            |   4 +-
 drivers/md/dm-target.c            |   2 +-
 drivers/md/dm-writecache.c        |   5 +-
 drivers/md/dm.c                   |   5 +-
 drivers/nvdimm/pmem.c             | 182 +++++++++++++++++++++---------
 drivers/nvdimm/pmem.h             |   3 +-
 drivers/s390/block/dcssblk.c      |   4 +-
 fs/dax.c                          |  32 +++++-
 fs/fuse/dax.c                     |   4 +-
 include/linux/dax.h               |  12 +-
 include/linux/device-mapper.h     |   2 +-
 include/linux/memremap.h          |   7 ++
 include/linux/set_memory.h        |  11 +-
 tools/testing/nvdimm/pmem-dax.c   |   2 +-
 20 files changed, 269 insertions(+), 143 deletions(-)

-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

