Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 826A2C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 20 Apr 2022 02:05:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-rVVrXZIoMMCSPDUVUlgMmQ-1; Tue, 19 Apr 2022 22:05:45 -0400
X-MC-Unique: rVVrXZIoMMCSPDUVUlgMmQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F9D6805F46;
	Wed, 20 Apr 2022 02:05:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C7B4540D282A;
	Wed, 20 Apr 2022 02:05:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5CB0E19451F2;
	Wed, 20 Apr 2022 02:05:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9716119452D2
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Apr 2022 02:05:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 712EB46A391; Wed, 20 Apr 2022 02:05:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BC5D550874
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 02:05:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F25C101AA44
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 02:05:39 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-GH1gdxYBNbSQv9P6sN8xrQ-1; Tue, 19 Apr 2022 22:05:35 -0400
X-MC-Unique: GH1gdxYBNbSQv9P6sN8xrQ-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23K1trif012431; 
 Wed, 20 Apr 2022 02:04:57 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ffpbv7qhu-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 20 Apr 2022 02:04:56 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23K20Wr5038029; Wed, 20 Apr 2022 02:04:55 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3ffm88mv52-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 20 Apr 2022 02:04:55 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by SJ0PR10MB4557.namprd10.prod.outlook.com (2603:10b6:a03:2d4::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 02:04:53 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5164.025; Wed, 20 Apr 2022
 02:04:53 +0000
From: Jane Chu <jane.chu@oracle.com>
To: dan.j.williams@intel.com, bp@alien8.de, hch@infradead.org,
 dave.hansen@intel.com, peterz@infradead.org, luto@kernel.org,
 david@fromorbit.com, djwong@kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org
Date: Tue, 19 Apr 2022 20:04:28 -0600
Message-Id: <20220420020435.90326-1-jane.chu@oracle.com>
X-ClientProxiedBy: SN1PR12CA0112.namprd12.prod.outlook.com
 (2603:10b6:802:21::47) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c95634e-607e-4624-5d3b-08da227228c3
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4557:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB455781AA6A2F071926A79925F3F59@SJ0PR10MB4557.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: /UqPgiG2gKPBKyctzPrAApde3neFj3DZT3hl500Vr25rd45uL4QPIcUHgf1DYwgVZLqLp/DxKBEyF6QwvUvz5jaIxZmYQdNhIQ4o4bGpBx2Jofp43BMGlL4SMIFrXMT3A9AluZAod9M5Yeq+uREhTgk/6q0NbXoIIl3kCEPqfRTtVIl4DdfAvfUTXA3bvp8WsFitNt7h5wzglXr4ehEfHbV9lBNYfbyknbHTS65gJWq6xEqPT/rzjiKz1MusiJq0e4wxrFVKz/wMOrXD8jHNM/Eo8xbAwf8ptin3WgoDM9i5yJ75YiNnfQhRjrnO3t7kemMHrRRyBoUwFPhEr3SquOIpHv2yix0GyX2B2R8Bgyef+4gq1BKxuRg4K5X4xXpmv8mbYj2m/M9Nn9sqYBd2Sr6kI7asas4x7EPKr5KKLyTWrnUfHbnWIy4m0zN493azIABzbJ68RCHh0i0FFkts7pO/PreqBfEyToucp7SvCaTdFd1kFCzHSo4uTChqeBcYtSLneYoVI6EDNRmNWLuFyR7CZ/O15cBFXHiKEk4qZ9akzz3CTMSjJxZPVkmGRF/hvkGQVsHidEAA20t9LMMEl2P3hBJCKCIT8Shzo5badBIABpYd9GDnDQ5gGvvC+z157qX6e0PYQL67hTbBCl0qoyHn4zzChvepM5ShJujQSbnZjSZj+t9H6an6hcqA0nL9f/ikSfuCH5QoRNWM19sUPsbkw4QfVbsxosvG3bDyDqgs3idFsDeCFhiet3wpkQnIUYq3PjG485ZPveSv2puMatvtDfGaW7QCvd2fKzcHbEZmeXGcPNb3rYFSXv9m1YrQ
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66476007)(5660300002)(83380400001)(86362001)(4326008)(66556008)(316002)(2906002)(508600001)(1076003)(36756003)(66946007)(186003)(44832011)(966005)(6486002)(6512007)(8676002)(2616005)(921005)(7416002)(6666004)(52116002)(38100700002)(6506007)(8936002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9dUgSa34wAbOTRsVKWyiwku8CjcNtOBeL6KLFmMYhAwNrHD+ttVUKzhPr9rb?=
 =?us-ascii?Q?ZHDmYRRv6lhzlg6M40jtxfVnaqhj4nDcp7SzrHUnXzPx/5q5lri8SvgnOdqe?=
 =?us-ascii?Q?4ISWoJgh+8S6wLWL4dwXqg4+d42MHaGjXo0XoEEk4uA0mNsU4+MCSg9hqVSq?=
 =?us-ascii?Q?8BHENhK44s2PzROMiBnooNodI8y/WadEP1ZA9CWW/+Vu+5QL/KHsCYMNvdGN?=
 =?us-ascii?Q?dXWHr9vfY/innwvT0XjdBHKzVW/tKeujFHgF4RuJhgRS3zyDZrlNKRXf7F02?=
 =?us-ascii?Q?FU6LLSqW1jwN/1rXeNzN+KtVlG/VdjYddrj5D4CDw37cHzZx09ydm/gSUyrN?=
 =?us-ascii?Q?JrAIE1DV+8820f7XSoAczr0a3N6Cf+6nQzTR6gSDqODPfgOCAvz3P6HdAwMr?=
 =?us-ascii?Q?fSuaGSHaAFoPfibt5CIKXZOrvJoVOeOz+0OIBFNsFsa3AbP/MCsg3koK3y9D?=
 =?us-ascii?Q?L1J7/BdHAIUn+8OiQE1BRSQMFVen18624jUvQCFZg3ckc+V9xNOmvUVBv5ft?=
 =?us-ascii?Q?jGqPq47dG0IOwS30RZZSf7H+4omQeDcm/F6rfTjJcy9NHnEv5XvlcnYrsHCR?=
 =?us-ascii?Q?/SmPH463eqtMpzVKlb316gKExGPtbO/rl0zxzBO+p+JvuFf3Y/UB3Mx89xcz?=
 =?us-ascii?Q?sF72kIYM4qtDPV978pt8wC0iltHhoMY/7/e/bEAdh2A6x4MIfVD21eN4XNhY?=
 =?us-ascii?Q?RuI3a2pi16LjyYZFSpQbFxZEe23kQXf4h2Z7vGN+bqZjF0bL/Esle1FN/VxJ?=
 =?us-ascii?Q?Sp4dZzzu2mcrFALtN3PlTkYTggsV25z7wxZ7PotEGIIV4sjYhmPQoSo592go?=
 =?us-ascii?Q?dfUuWRTataZ1V6fohZgtQca9hrVLvIv1ORZh9jDcWjkn53luH23lIBXJLh+H?=
 =?us-ascii?Q?YZpOQTrdyQKyowZfiIG9qT+1GeBTXKmTgNZviCVWImeZ160V0ME4ReOamYHf?=
 =?us-ascii?Q?GvbusegXLH6g5gdnM98kIQ/t0be9ZWEGOT5X86ncD9QMhVdAM/49LsTXQz/V?=
 =?us-ascii?Q?0yXNYTBdSeqbM7400vbNOAQXj6yY+Tyti/l1hI5A/mw0zA78068icDV2upGv?=
 =?us-ascii?Q?k+9GNWq0o+nVxMNdGT3u/73qftp4UJYoIkWls3IIGSKY0rzZ3MBoy4KFdmy4?=
 =?us-ascii?Q?UiVpboI182AMfTGMvrIOaowoPOTFWXzjV+BDO+NW0qcaxu7DwPYcR1x3W0HU?=
 =?us-ascii?Q?1ntIN0vrG0TnZvTtmUj7xmW2GBcPbuxNyxtrWG+Yq+QA3u68PPz0m3lHAIoe?=
 =?us-ascii?Q?ukMNq4tiL6tFCWZ7DXf1uWwLWM5H7tnJ6SvkEqdqhOw3BDUepuS+rhGQ6sRR?=
 =?us-ascii?Q?Z8P4u3FHx4KctdBTjZpy9PBkTIAuio3WTJ6aVU2xU6smADHyNW89RPjpLDjV?=
 =?us-ascii?Q?E7cE4AQAtwJlq1+LArM+u3YPvSKhhmmfWrrKjQy/0varSQ7IRjz5PdsixGON?=
 =?us-ascii?Q?7QF4CHqCsJ+kuFRnHTzlmnXWC1WZ/HGJ1qRk9XEjkWDT0H9donzkC5oABZv5?=
 =?us-ascii?Q?Ex0x+v4lfu7cm4JbtCcWVLaAOjukr/h021UCPjcK7N9y+ef/t8IusYoEOhVK?=
 =?us-ascii?Q?Yx3W4BnrzeEaHv54vBESMNFisRtEmzdphJ2hxjSj0/BK3TkLJ6yuMH54Hc1A?=
 =?us-ascii?Q?aZNZeRSIS2WOimnqokLfoWAvzTssa0zpHndhbxdfahu8+0rMgOMuDNtO8LbY?=
 =?us-ascii?Q?TCZM2kAAsvgUAvdCfTiXJ5cZJ1RGEbOCxttPxTCDcnz33bwsXJMW4jRWdyJk?=
 =?us-ascii?Q?gtNoy9pa3TU55Qx8a5tvGTCQQRemXu0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c95634e-607e-4624-5d3b-08da227228c3
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 02:04:53.3728 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qSy1XBTdyC1iCNVs1IUPUZe/CdVFczukqGgWo5kDpUpUuUB9w1T+rdJmwxvI+YzckZfdD/kc+R/wI9aQ/fvxow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4557
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-19_08:2022-04-15,
 2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200008
X-Proofpoint-GUID: y2nRgij0bW6AMCfhsEVWIoL5Yjh74U4c
X-Proofpoint-ORIG-GUID: y2nRgij0bW6AMCfhsEVWIoL5Yjh74U4c
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v8 0/7] DAX poison recovery
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
v7 -> v8:
  - add a patch to teach the nfit driver to rely on mce->misc for poison
    granularity, suggested by Dan
  - add set_memory_present() helper to be invoked by set_mce_nospec() for
    better readibility, suggested by Dan
  - folded a trivial fix to comments in patch 2/NN, suggested by Boris,
    and more commit message comments from Boris
  - mode .recovery_write to dax_operation as dev_pagemap_ops is meant for
    device agnostic operations, suggested by Christoph
  - replace DAX_RECOVERY flag with enum dax_access_mode suggested by Dan
  - re-organized __pmem_direct_access as provided by Christoph
  - split [PATCH v7 4/6] into two patches: one introduces
    DAX_RECOVERY_WRITE, and the other introduces .recovery_write operation
  
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

Jane Chu (7):
  acpi/nfit: rely on mce->misc to determine poison granularity
  x86/mce: relocate set{clear}_mce_nospec() functions
  mce: fix set_mce_nospec to always unmap the whole page
  dax: introduce DAX_RECOVERY_WRITE dax access mode
  dax: add .recovery_write dax_operation
  pmem: refactor pmem_clear_poison()
  pmem: implement pmem_recovery_write()

 arch/x86/include/asm/set_memory.h |  52 --------
 arch/x86/kernel/cpu/mce/core.c    |   6 +-
 arch/x86/mm/pat/set_memory.c      |  48 ++++++-
 drivers/acpi/nfit/mce.c           |   4 +-
 drivers/dax/super.c               |  14 +-
 drivers/md/dm-linear.c            |  15 ++-
 drivers/md/dm-log-writes.c        |  15 ++-
 drivers/md/dm-stripe.c            |  15 ++-
 drivers/md/dm-target.c            |   4 +-
 drivers/md/dm-writecache.c        |   7 +-
 drivers/md/dm.c                   |  25 +++-
 drivers/nvdimm/pmem.c             | 207 +++++++++++++++++++++---------
 drivers/nvdimm/pmem.h             |   6 +-
 drivers/s390/block/dcssblk.c      |   9 +-
 fs/dax.c                          |  22 +++-
 fs/fuse/dax.c                     |   4 +-
 include/linux/dax.h               |  22 +++-
 include/linux/device-mapper.h     |  13 +-
 include/linux/set_memory.h        |  10 +-
 tools/testing/nvdimm/pmem-dax.c   |   3 +-
 20 files changed, 351 insertions(+), 150 deletions(-)


base-commit: 028192fea1de083f4f12bfb1eb7c4d7beb5c8ecd
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

