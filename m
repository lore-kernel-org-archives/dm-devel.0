Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C8ABC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jan 2022 21:12:17 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-76xXHlwhPrCxPL1rR47APw-1; Wed, 26 Jan 2022 16:12:12 -0500
X-MC-Unique: 76xXHlwhPrCxPL1rR47APw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C7131091DA0;
	Wed, 26 Jan 2022 21:12:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73F83E2F2;
	Wed, 26 Jan 2022 21:12:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E33FF4BB7C;
	Wed, 26 Jan 2022 21:12:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20QLC30d025998 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 Jan 2022 16:12:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6A4E81121319; Wed, 26 Jan 2022 21:12:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E8491120AB8
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 21:12:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C2862B16871
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 21:12:00 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-136-AmOCgbn4OKiCXc_Nu_YXug-1; Wed, 26 Jan 2022 16:11:56 -0500
X-MC-Unique: AmOCgbn4OKiCXc_Nu_YXug-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	20QKZEt3002911; Wed, 26 Jan 2022 21:11:36 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dswh9qmqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jan 2022 21:11:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20QL6Vj5020793;
	Wed, 26 Jan 2022 21:11:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by userp3020.oracle.com with ESMTP id 3drbcrx7r0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jan 2022 21:11:34 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by DM8PR10MB5494.namprd10.prod.outlook.com (2603:10b6:8:21::5) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4909.10; Wed, 26 Jan 2022 21:11:32 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%4]) with mapi id 15.20.4909.019;
	Wed, 26 Jan 2022 21:11:32 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Wed, 26 Jan 2022 14:11:09 -0700
Message-Id: <20220126211116.860012-1-jane.chu@oracle.com>
X-ClientProxiedBy: SA9PR13CA0112.namprd13.prod.outlook.com
	(2603:10b6:806:24::27) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3ea5bfb-bfdc-4db9-533e-08d9e1106d60
X-MS-TrafficTypeDiagnostic: DM8PR10MB5494:EE_
X-Microsoft-Antispam-PRVS: <DM8PR10MB54943DAE7FFE0FB8403EBB07F3209@DM8PR10MB5494.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: NQP06gsZBA/wEI6jUqkbEvHxFApIJ4nYXcR9CNPwQthQCNrm/8A8CW8EjG7kgwq0Akx8Aewy5mc0ASKG44j2/c/xEiNYDjhOjG8GIFNvV8nQNuf2KQdr0u6Vn8BaPHtNGnc1JXcly39Emzn8RHJnTANJ0EqXyyp39jipHiHwQeWY/d3o1MQAb9ScVBkWVcWJbu4+VUlk6NEbMk8vBE0yi30aE/Ioc57jk6LaOEonvqfcGG7nam4hVrhg2sJtcU4oNs2H1E8qE6/I1cCDvvgCkN2n47itBPJmM286JSfDKC6AhjnV2MZtU2M10EB/bR+b2YX8mIWGQNVaz449SvDugtQ7eBzeEFp7+L1JnZDZZ1iow94mljM7uvmgh1hbOfgHSn2S1RSGcBdlUdeDaqQlZi4sBgbsmFqUHI0/jpNoIZMeTe0RcDi1XdT86vzPwWNj3goPm2ZVecruws5a+xmWj8RHtRuaYzv0SpJdjhIc0o+v3BYlldboIrAI1IjdgCTqAKJ0MJk7zRVZaszdgkUR/1pylDzgdnfbu/bYU8czbTZ9u+NnTvao1kkqnZ/qGPjuujYDOtu1J1be/YUVBH4ZwosmJqGLWSTKeV/0DBUDI7W7O3VPYAdPrqmY5gHGX/tTUotpQB7SyfXOVCwAB43l0qE/AeA3Iwz0Gz5csiEcoEoSRV4EYwFVIEHQHXgjt+jGgYzIVQj40WGd5jndVFGSmMObvHMTt4xplGbOGBueWaFgTAWHIFFtCMZ9YYSkWljQqKLp17K28MOtosiLsmO8vJpJf+39hieqBnl+B+axEH7Nk6qWKRI9FUPAVz9pVH8i
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(66946007)(52116002)(86362001)(186003)(8676002)(6666004)(966005)(7416002)(6486002)(1076003)(8936002)(921005)(508600001)(4743002)(6512007)(66476007)(2906002)(6506007)(83380400001)(2616005)(5660300002)(66556008)(36756003)(44832011)(316002)(38100700002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GFArw88L5cgtzxkBktHATQBkapiRkYF1Ueo/JpOhe2EUBt5l47i/9sVrdXJq?=
	=?us-ascii?Q?tK2Jgipp/ZrkgC967JhMvvcK1K3lXSxTybdz3lyHlqayyqwyht7fIK4fHKPi?=
	=?us-ascii?Q?8zKY9ISh3xZv7GKEgG5/r5M0Zy6nTXv6TziR6t9YDSkcEBFD9NBGo3V5wuBi?=
	=?us-ascii?Q?+b6gt95q0btorvVb+eSj4okoLQDtt3qk9Tvt9ac9cEOpyT2Q0vz1k2ZrdnSB?=
	=?us-ascii?Q?oh8RB8qpqBvvH9eHylLBx9mdmYxTAPKww9eM4nfW5sUfnhPPcBJJUz98E9Wr?=
	=?us-ascii?Q?0QnINiExn4KNCMnTXBUC21rrdZ81+gYPsE5QLYkx/Pu0NoIAJjlfhw2MB9qJ?=
	=?us-ascii?Q?4vZ805veyWK99sa2y3lWC2rgEEbYQuiCH9yqSGVjBeVUFH5fGAZnn+PcSb7n?=
	=?us-ascii?Q?8k3NwlnVIlHzdx7QgDaNMM8+obeF4hIi9HZtxHZBf73IK1XkEikTHiAWKuiH?=
	=?us-ascii?Q?TQB/ShuzDGK94mnz38qOi2PV+x1QvN9fbYXFyAdpl98esb8783fnDoJAXyBx?=
	=?us-ascii?Q?oKG/sPw4are2b71hSGlWrmq3oCJdOOQSU+ekwqDoO31OwHUYjhfwY/AJSBg4?=
	=?us-ascii?Q?0q8ftJeeUNCpS9rV4KOpatk836uv0Jjv3RmldV9qt4TR+E0N7/0R9EwBZBhq?=
	=?us-ascii?Q?DjSbg33QMtpHNd6k8fjhyyymYfp7+dpzrYYTeoruSaqDu7YfrR0mVWQPYtBu?=
	=?us-ascii?Q?2/RMZVMjooy9QG6rGJg2R4AkQ38kF1scRC81JZCj6eQTbNsgs6nQRiXlUxZu?=
	=?us-ascii?Q?K1MFMOWEHd+i+ZcQLR3Ncv/QDJuMZaB2c+f9KNfgwEj/aDqMZY3P00Wvj1bS?=
	=?us-ascii?Q?ViolgYjgaU4JuFPvjZhCPYc+8hCcBTVKe6V9eziu5PMP0FKkAE7PtKaUnvMV?=
	=?us-ascii?Q?RRsiAG74kVq6RqRKwGFKxEG53kLinC0/l2WEiPIzDPANrGWvVbptsJSAkfhx?=
	=?us-ascii?Q?JpqohfTY40mnX5kiJo4a0iyoFniyQMkqTD0Crev4/BFvUCCECj8JA/yxnMxu?=
	=?us-ascii?Q?zEL1xIJxbz5lSjpEh2uiVY0JdV1235eVaLEyELoxf+y4aINMXUzAYTwEhg/x?=
	=?us-ascii?Q?p8LV6BDahmBPjQ1dsYbYaxFrETfmELwlMN87zulNXrbrgZZtF64QualV6DOw?=
	=?us-ascii?Q?JEECAvsw/67eBetpE1pHJHJDvEwUpMu6pmMKuZXYffroYe8BfUBGRIeiVFPY?=
	=?us-ascii?Q?zRN+ZoseOhbX08FxdTk8o+4fg8hlbGv7ASQIgwsBA+ZxccjVgzdp1z/TIojQ?=
	=?us-ascii?Q?UKVakIrqrcuwQJxJZFnpZN88LgaklEqc494IRYlacif+n8LL99MQoPlRzkNJ?=
	=?us-ascii?Q?H3bThcwuvk22wCPMffPJAye29Z0uUv3J171PZsfpeak+9lbmguE0OksmH5ef?=
	=?us-ascii?Q?lWAlSEKiYpezc2vsCAiAdsCg1R2AhcSpa0AJj28tVstBCHjLY1NKFKvc9U3l?=
	=?us-ascii?Q?6oYCc62v/yZtgIZjgIB4fvUY/jCigGycZ4+HtC7nFqbnEMxR/kh72CbXNpbF?=
	=?us-ascii?Q?RLJ/B0nzLuUVHnPhqVQU0mYdM9kQzyg6fdGfrqeW+0KxtZ7j1NZ0X5TPSrh+?=
	=?us-ascii?Q?CUd+L1VhQ+/hoZSE6QM/OC4z9M/LumP7sSVuAZPfmiteQ9QT6nB4mJTMTLgk?=
	=?us-ascii?Q?TFD55OL0+CiOf1WompW6DSloE5ZSlA803Z4KqVJ2AkEL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ea5bfb-bfdc-4db9-533e-08d9e1106d60
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 21:11:32.3047 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uiFRoDo7wg+3dslNnqoK9OEm59NGNi7BpIiRDjnex7Gt2urKzuZ3HN/3mHNTJ+Ifm9H/cafTy5OcJs0gWz5kfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5494
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10239
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	mlxscore=0 malwarescore=0
	spamscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=986
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2201260122
X-Proofpoint-ORIG-GUID: ApMTbeGZfrTeeXitQjSMI0Fn_BUNcJbu
X-Proofpoint-GUID: ApMTbeGZfrTeeXitQjSMI0Fn_BUNcJbu
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v4 0/7] DAX poison recovery
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

In this series, dax recovery code path is independent of that of
normal write. Competing dax recovery threads are serialized,
racing read threads are guaranteed not overlapping with the
recovery process.

In this phase, the recovery granularity is page, future patch
will explore recovery in finer granularity.

Change from v3:
  Rebased to v5.17-rc1-81-g0280e3c58f92

v3:
https://lkml.org/lkml/2022/1/11/900
v2:
https://lore.kernel.org/all/20211106011638.2613039-1-jane.chu@oracle.com/
Disussions about marking poisoned page as 'np':
https://lore.kernel.org/all/CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com/

Jane Chu (7):
  mce: fix set_mce_nospec to always unmap the whole page
  dax: introduce dax device flag DAXDEV_RECOVERY
  dm: make dm aware of target's DAXDEV_RECOVERY capability
  dax: add dax_recovery_write to dax_op and dm target type
  pmem: add pmem_recovery_write() dax op
  dax: add recovery_write to dax_iomap_iter in failure path
  pmem: fix pmem_do_write() avoid writing to 'np' page

 arch/x86/include/asm/set_memory.h | 17 ++----
 arch/x86/kernel/cpu/mce/core.c    |  6 +-
 arch/x86/mm/pat/set_memory.c      |  8 ++-
 drivers/dax/super.c               | 41 +++++++++++++
 drivers/md/dm-linear.c            | 12 ++++
 drivers/md/dm-log-writes.c        | 12 ++++
 drivers/md/dm-stripe.c            | 13 ++++
 drivers/md/dm-table.c             | 33 +++++++++++
 drivers/md/dm.c                   | 27 +++++++++
 drivers/nvdimm/pmem.c             | 99 ++++++++++++++++++++++++++++---
 drivers/nvdimm/pmem.h             |  1 +
 fs/dax.c                          | 23 ++++++-
 include/linux/dax.h               | 33 +++++++++++
 include/linux/device-mapper.h     |  9 +++
 include/linux/set_memory.h        |  2 +-
 15 files changed, 309 insertions(+), 27 deletions(-)

-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

