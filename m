Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15246C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  5 Apr 2022 19:48:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-K_0ZUJ2COH-Ya1oPsumffw-1; Tue, 05 Apr 2022 15:48:54 -0400
X-MC-Unique: K_0ZUJ2COH-Ya1oPsumffw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9189E899EC5;
	Tue,  5 Apr 2022 19:48:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DC393401E0C;
	Tue,  5 Apr 2022 19:48:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 06DBC1940369;
	Tue,  5 Apr 2022 19:48:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 26E0A1947BBD
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Apr 2022 19:48:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 047E2401E76; Tue,  5 Apr 2022 19:48:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F3CFC492C14
 for <dm-devel@redhat.com>; Tue,  5 Apr 2022 19:48:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D37F23801FE8
 for <dm-devel@redhat.com>; Tue,  5 Apr 2022 19:48:46 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-m9yrGEtSM5aI4FE7MJ1Xmw-1; Tue, 05 Apr 2022 15:48:45 -0400
X-MC-Unique: m9yrGEtSM5aI4FE7MJ1Xmw-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235JJVfN006418; 
 Tue, 5 Apr 2022 19:48:13 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31f34k-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 05 Apr 2022 19:48:13 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 235JapIr029836; Tue, 5 Apr 2022 19:48:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3f6cx3vpud-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 05 Apr 2022 19:48:12 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by CO6PR10MB5475.namprd10.prod.outlook.com (2603:10b6:303:13e::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 19:48:10 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%7]) with mapi id 15.20.5123.030; Tue, 5 Apr 2022
 19:48:09 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
 hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
 ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, x86@kernel.org
Date: Tue,  5 Apr 2022 13:47:41 -0600
Message-Id: <20220405194747.2386619-1-jane.chu@oracle.com>
X-ClientProxiedBy: SA9PR13CA0054.namprd13.prod.outlook.com
 (2603:10b6:806:22::29) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f68b033-1382-4494-ce8f-08da173d3646
X-MS-TrafficTypeDiagnostic: CO6PR10MB5475:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB54752AEE3D1F93ADA142BFE3F3E49@CO6PR10MB5475.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 5CQxApyeGkPA5GfNKjerl7dFkKIOW6z6NS9nq5dlPFy389+isTublyh/X1TXueOs1p4zNkMOpmLQy0IhXOfig0WLdMZ/3fq4mCMfdEui/et8xekDHBViJKrjGp1j9Jgv85d95fpPqY/m6i76gVATT3wJ+P8kJbXeR2vmXlNzNzsYTsxrwCk83cFq4F8Sj8UAsCWR2qUY2ey9dH+L6O5CsaI8bndiZjT1xm0kjpDPacuq7TxNZe7wHKOFY8GLEzw+W+8RhpftnttECNFXvDmxqOe4hq3qto/RNlH0etbldKalY01rVJn5B6wUuB/TpTSA9KR6fkCUI3cTI3bTRAA9jn63yrIXF3Ye0nA8IGvUsCYnXg8E1dYMjsXMjPyr59WdJc4/UdSx0wguGC63sMEWW4HwgsbPoi55PFUkGw/Hs7ftEspiRTt2pTUM7haT1Lih+XbQJWFV8YKkGBpX9OFNHr39RA4kN+L1oDgF68iOdUOsdutyvdVQ6e1JHbD466AdOZHc46+JGzaMRsw+1WN2Le2Pywxo+wU7Tpm1cgceDTPiXksqpV60vlXPp7oUBxhxe9v6kinHNtUBCys0+oa2Uctxq8sGAMWf9pT9/KfzKZuM+y0FxnX9MLkhnZlfeSrawut/HOAvUatxdsf8bhqAHBFwaSW1tm1qaC5+ODYR2Ecl+gzZ7p7nTZ/k5DkFgEVt8a/Gc1+AHAF9XKdGjUec+ekHUSMBeacCf4o1otvvW93UCH1oVPBN1Xg3HI1MvkuS/Y5viqbrWQyh1iPQzL/CMZhGylELVxTl6EpHJD5xhQ6deEHrlItQ5q8ISIXFAoIY
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(38100700002)(1076003)(186003)(2616005)(5660300002)(966005)(2906002)(316002)(6512007)(921005)(6486002)(8676002)(36756003)(6666004)(52116002)(6506007)(7416002)(508600001)(66946007)(8936002)(44832011)(83380400001)(66476007)(86362001)(66556008);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PCmukRxu47iVWcGbBqd6e1XpF4QapXqzlDwwDzG/+FVqln3b4zvprl+OuJjO?=
 =?us-ascii?Q?eg/L8OtmuVDVdNgYtrrELOJ7ZQxkH4MAh9OYqU2/sbSpGn2/nlmatIZrxFjK?=
 =?us-ascii?Q?Z9tiaXysoBo0e41MiC9JxO0f9BJYIcCIeDi/rjcsZOBYIwq07NxL/tM7+QOS?=
 =?us-ascii?Q?Bn87EaEVNIJeh7z5TrpxTMz8tcCMV7GWKZsBOEBhKuLhsd35IyyIDF6Oh0WU?=
 =?us-ascii?Q?MPzb+leUzukSpSixgo6aNuMj/uyqnvdlVMVd6L70KBZcfJzLH3JoUpWDCnGN?=
 =?us-ascii?Q?LXCMOYn7YgUiItLcD6CHh2VkVRqA0GRs9p3NFAfaU3Osk50HCCCKVccD7/4K?=
 =?us-ascii?Q?Ku0pM0ODl5nIN04YysEcuAF+Th5+G3bpFQ0FT++PYyN9PqzCf2an2vYfssKL?=
 =?us-ascii?Q?yH0NPh53KSJ5MJmmfTlbwT2eVN5XJcCb8tzWBFiFyn842fqtN3vCp26hBLnn?=
 =?us-ascii?Q?ziA6a3u6+q47Jhol5CssHbffaCkuE2X3t2z0Kz0R6Auf6ez4smiKpE/cZcjM?=
 =?us-ascii?Q?YbRarT39AlbYWgQvWzIISyBpaT8Z3dfSzPAIM4i3AT+22wEuSntVUo7xiHXB?=
 =?us-ascii?Q?8h7llIMHgnD4ajO1LD5S1G604K0DaHjnkdf4oLO79WFFULjqx1o0aO5BHbW+?=
 =?us-ascii?Q?xXh9XMYZxQ4WYCCZhYShEVcDZkncbrqpB9GbxZz04yAX2IjKJpckcHypfTPQ?=
 =?us-ascii?Q?VIVeEHs4QB0IT99TiEE01pilqI2Ydd0Bh4V77MYR3dDvo4dax9GIFk5zoCHF?=
 =?us-ascii?Q?zoV3fRD92S+4MrX6wRd39eCKjVKyNxz3DHawXw3Ew8WapLZ8lca4mTqoH897?=
 =?us-ascii?Q?AM1Cb7h6nmdFGNqQkLE1XFlje32PdBfpsxD2aURoHAy8PUyZigFPMzXVEPji?=
 =?us-ascii?Q?ygvrRKL3V7mkOEmu9aucAftego6LBVBQCuKSmoBHcqgIlXWD1rIIIpGjTwE7?=
 =?us-ascii?Q?Jc5DozUpC/ZF6SleShX50HcM857sPxFsZbtG6JIbHo6bSgjUYppkzVvMlJ5i?=
 =?us-ascii?Q?9yPAFt/vjQ+hYKSra0SJy23X1/6GClN8shlLxpeG7n/v9Mw60Z7XWTwYKvg8?=
 =?us-ascii?Q?PN9CKWrKxjH0pYLS6/mYJRJ8qZzxs6adsDVVuaDSD0duq1UccIQD0kpr2Ibu?=
 =?us-ascii?Q?NeXudZCHu5EuI26AB9M4dPBijY5TnXZUfbtQ5uWGeJGGqC05juOgVBVRFg8l?=
 =?us-ascii?Q?oMyf7+a2UvSXNqRbOLL4g7hPLi1srTtJl427f/JAJ5Q6CwV/Xrks/hPLiJmx?=
 =?us-ascii?Q?6QztdgCgDn0gvnktOzOz4Jf2meDbYFi2GGzZJYmPUBAyhHn3XD0xh/U9NTfw?=
 =?us-ascii?Q?ZXPj8Sj51csHWOeY3YkqAi9bfR/Ds5lgp0w1JD1uLf5o73KgXl7vEyHbmHhO?=
 =?us-ascii?Q?mjXUac/0vkttB67y+cvt581x8BLpElvlMfnASNcto8JSylPJMuFNA1W+DRfU?=
 =?us-ascii?Q?AjqC8AKOWlY0mBP9uIKWJ8+JZmwofN5xTIonpp3ypa88LsyM+O9z9u0N6a3q?=
 =?us-ascii?Q?lTN/fmc4qOXNHrDLZ5XlJ8pHd/tFKAleRvNNgpbMFm6xMl8W0rgg/wS3yqIM?=
 =?us-ascii?Q?qe3s/KFmlQoDzAd7QdmEAAx7nfatQW+SZIJQM5SfQ/WhywlOj+GwStacsFYL?=
 =?us-ascii?Q?i+FZTTKFUFBO4iLuJ+nDYzXNMYmIpGSvmcAKomjgKze7CZRC3+tZHB09op6E?=
 =?us-ascii?Q?1/OxV5MPcRy0V/UX7OZagVeyT0F0EEOfSo2AhzPPTThx+rAAfy1sNJkjKGFO?=
 =?us-ascii?Q?kg/5LfgYMT10q32uHoBECN/Ti7O6iEI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f68b033-1382-4494-ce8f-08da173d3646
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 19:48:09.9445 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3QqPLAxT5BSCUMOxVnzIzbG7qLGzsEE4wCsCt8tNK/N5LkygugM4dlgDt5pIcSivCX5Ym/TpGAY2RtBw8NyY/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5475
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-05_06:2022-04-04,
 2022-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204050110
X-Proofpoint-GUID: hHg6cJzhgk-qeylf-mdBDyUZMKlvPFiT
X-Proofpoint-ORIG-GUID: hHg6cJzhgk-qeylf-mdBDyUZMKlvPFiT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v7 0/6] DAX poison recovery
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

In this series, dax recovery code path is independent of that of
normal write. Competing dax recovery threads are serialized,
racing read threads are guaranteed not overlapping with the
recovery process.

In this phase, the recovery granularity is page, future patch
will explore recovery in finer granularity.

Changelog:
v6 -> v7:
 . incorporated comments from Christoph, and picked up a reviewed-by
 . add x86@kernel.org per Boris
 . discovered pmem firmware doesn't reliably handle a request to clear
   poison over a large range (such as 2M), hence worked around the
   the feature by limiting the size of the requested range to kernel
   page size. 

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

 arch/x86/include/asm/set_memory.h |  52 -------
 arch/x86/kernel/cpu/mce/core.c    |   6 +-
 arch/x86/mm/pat/set_memory.c      |  43 +++++-
 drivers/dax/super.c               |  17 ++-
 drivers/md/dm-linear.c            |   4 +-
 drivers/md/dm-log-writes.c        |   5 +-
 drivers/md/dm-stripe.c            |   4 +-
 drivers/md/dm-target.c            |   2 +-
 drivers/md/dm-writecache.c        |   5 +-
 drivers/md/dm.c                   |   5 +-
 drivers/nvdimm/pmem.c             | 224 ++++++++++++++++++++++--------
 drivers/nvdimm/pmem.h             |   3 +-
 drivers/s390/block/dcssblk.c      |   4 +-
 fs/dax.c                          |  24 +++-
 fs/fuse/dax.c                     |   4 +-
 include/linux/dax.h               |  11 +-
 include/linux/device-mapper.h     |   2 +-
 include/linux/memremap.h          |   7 +
 include/linux/set_memory.h        |  11 +-
 tools/testing/nvdimm/pmem-dax.c   |   2 +-
 20 files changed, 285 insertions(+), 150 deletions(-)


base-commit: ae085d7f9365de7da27ab5c0d16b12d51ea7fca9
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

