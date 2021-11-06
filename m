Return-Path: <SRS0=0/af=PZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0110FC433F5
	for <dm-devel@archiver.kernel.org>; Sat,  6 Nov 2021 18:07:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 89E3860E09
	for <dm-devel@archiver.kernel.org>; Sat,  6 Nov 2021 18:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 89E3860E09
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-SWFDVnaYMpSYD5t5jig-Gg-1; Sat, 06 Nov 2021 14:07:00 -0400
X-MC-Unique: SWFDVnaYMpSYD5t5jig-Gg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6031F19253C2;
	Sat,  6 Nov 2021 18:06:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46A0617C58;
	Sat,  6 Nov 2021 18:06:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1DFB84E58F;
	Sat,  6 Nov 2021 18:06:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A6I6rGT012566 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 6 Nov 2021 14:06:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 28DE8404727D; Sat,  6 Nov 2021 18:06:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F0C94047272
	for <dm-devel@redhat.com>; Sat,  6 Nov 2021 18:06:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED4C6106656C
	for <dm-devel@redhat.com>; Sat,  6 Nov 2021 18:06:52 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-381-GobBZrVWMgeV5LiYw5-vZQ-1; Fri, 05 Nov 2021 21:17:37 -0400
X-MC-Unique: GobBZrVWMgeV5LiYw5-vZQ-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A5MiPKv007620; Sat, 6 Nov 2021 01:17:02 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7hwtkt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Nov 2021 01:17:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A615qcr064740;
	Sat, 6 Nov 2021 01:17:01 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by aserp3030.oracle.com with ESMTP id 3c5fra86a5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Nov 2021 01:17:00 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB5890.namprd10.prod.outlook.com (2603:10b6:a03:3ef::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13;
	Sat, 6 Nov 2021 01:16:57 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.013;
	Sat, 6 Nov 2021 01:16:57 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Fri,  5 Nov 2021 19:16:36 -0600
Message-Id: <20211106011638.2613039-1-jane.chu@oracle.com>
X-ClientProxiedBy: SJ0PR03CA0357.namprd03.prod.outlook.com
	(2603:10b6:a03:39c::32) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
Received: from brm-x62-16.us.oracle.com (2606:b400:8004:44::1c) by
	SJ0PR03CA0357.namprd03.prod.outlook.com (2603:10b6:a03:39c::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11
	via Frontend Transport; Sat, 6 Nov 2021 01:16:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e472e7d-d0d5-4b79-c217-08d9a0c32099
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5890:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5890E337003C5BA51796D6ADF38F9@SJ0PR10MB5890.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: IylPGcI1JhvnDtNX8MH++yHXpr28a84cIApx/8kkzUNwFa1EOWZ7UZ3x5oNbJxfl8Y9ud52gFWKzDdbmv4W1RvIr+t+Or7GwVleayEYy84HjvVM4ZIAk+EcEh79rwyQwdc6rahkOEsAV0N3lYaeSFkg2oG+eaij5oyuXFoWnp/okmCEmcg1yHEJXKiRxAueD7DF7Xpg4ay4sVFa276cTHzW4e0LopL0bKiHr1nB1eZvfUXDX1H56J2YInI+1Fc2pPidqmz/vAHCQa4MgocFZhtfXNQnZ5MVWDblNnFJK4jT9BXBIX2OY8M4g6e1Lf43K8/pFCWuHSGFPoSwUD52wt0vUb6oIeXBolwwtV2pb8hP1qXe65d9cWP9vHk64WhJ1KVVJU75uDARBrdLqefO3rW/h7h8+jZiUoOtApaUQQkdzIArOsvkpESlO7V1r8+moU05FSlQ3D5kht4fjLsmVexDobZGhFZIlbZWQUL4KaDr1LtWihELhACGB2rsiwj23bG4Q3gOAn5o2VMQZLX8tknsO8TKWg7zdQ+3jxMtDgac5ZKJAeBqD3x+vc9QY/5ldROgvJ5gJnQ5J1302QngvECbGVcTzGdY5YNfCRKPi7ztFYDSNCOA1iV9uUuMpCcLXopX1H7N8IzQcZ5MRJPbO5L72+PBTLAFzZhsPbEb5USHDNYai41Jgzti2Z80IedfXB9roxKu1XXWVosh2CM21NsXhNCZr01Y/Rc25lAvAmb3R/ptqhvXN3+7eI2wb9h1zdD8oA4H4otnN64azIRjkVB+JNsxXdJqPGx2j0fqIdeg=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(921005)(36756003)(8676002)(316002)(86362001)(66476007)(66946007)(508600001)(2906002)(44832011)(6486002)(83380400001)(2616005)(5660300002)(186003)(52116002)(7416002)(7696005)(1076003)(6666004)(966005)(38100700002)(8936002)(66556008);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5GoRDRRJw4dpzi+1Xyl6SzVjqXI9ML3IIdzK17ZKIDNsLQjRa/l0uAbPiuYX?=
	=?us-ascii?Q?mMOyUtCx2X0rKDovyX+r4qskFK2goLb+Y8c9RfHzUPiFOFI7PAevclk8vGUH?=
	=?us-ascii?Q?8SqBgO2iinX9rTmw8SJP/ZcQkfFUVctZ5rHo4gYV+CGYeBz3KK6/OuB5389T?=
	=?us-ascii?Q?nUKXRFYEGwJKppNJvmnEKwgfH+aqtKfzhqacnk5z+sWYPsCMFMK7N5WTrV2N?=
	=?us-ascii?Q?uUlcHNhbJTnS2bM5HgerUZtP5M4qAegWfQ7ZaogNk6rL42ruVNpKaWJWKIg4?=
	=?us-ascii?Q?lkCReM7cftjeWoLI7EH0JQSOHSHZlrsRz65zhmPKmaA62eV19XJOYxC1bCC3?=
	=?us-ascii?Q?heRcmdIQ6FbP8GeTrpeufkoWiTB93l1tVk9BYVEYl0ERIOkFp4SsDswwcYdN?=
	=?us-ascii?Q?n/tPn60uKX08ByEGcpG2bWRzViwGuH1MNY3xY0AuwWz9vkWjPjYehN2n9zMc?=
	=?us-ascii?Q?2Y6NT7Ekn1abmjdBsMLNqp0dhmBxUEf1HYXfRJXrqoBEB5XHs3trZ8gXCslX?=
	=?us-ascii?Q?Ck0dbQrMRR9LOiuBs+WME2VHLMjTbQaXg/FHkTXKIqnnYQ6FCk+OS5NiTKHQ?=
	=?us-ascii?Q?Q62vfO3HLCBoBbe+3j/TZM9aIPWyJszQMBbDGsyZex097rtb7xcPNze6pKd9?=
	=?us-ascii?Q?jJzsrXrrpVgIREaBCQT1zuJn3yyaq8jWsHnD6GtQTkDFmGulpe07F20V2dtO?=
	=?us-ascii?Q?hAGQzRayHIRb0J3LifgWbj65ZOjdtLYI5xOkPhHwTxX0kk6ONV14zxUcxW6h?=
	=?us-ascii?Q?dkb6Qney0DZnWSIpH1hopO8ea4POn94uIeeHUS5l7DLYNCmsqXKa+SqNWkuJ?=
	=?us-ascii?Q?xcMiPW0biETc7e3+dCyDzU9+fvqOJe02+0Ocw/JBkfEnKgoKRqw2MaPeRTV1?=
	=?us-ascii?Q?+OzMRAbNeU5Lkak0gbBJiGUkKx8dztL34k8E38+sVWTvAVqhWrHDiTVGkppS?=
	=?us-ascii?Q?1Ksll+QSYytw7oJDLeM3YHahvyIuFJKKpfwD8D0t6gCRh0svrjcd0RhPVPEF?=
	=?us-ascii?Q?8T4AW0DxyWcbpvT+2Ftjtsr19H1bVR3m451IBiEQ6g01u+t/dP5sPeAOHgdn?=
	=?us-ascii?Q?IS+8pUQhbIHj/wpnGRWTECOkSrHpsEqJJ5Umm9LFuIzQa+rftf6/dZ6Fh6ue?=
	=?us-ascii?Q?tRbhrI8ojyHO81y7iuTxLEAPPZFQOv05jsOVSwSDvLfnZ64ByCI0EMnewRnT?=
	=?us-ascii?Q?0HybeiS7+LPUB30iGBm43iYnhQqfNepfjWSP7ftqs2YUjTxglGfPNC73W6ts?=
	=?us-ascii?Q?WJtMj8rXcxqvegnQ3eIhk5oUrKviFpZVSQLe4taKaxVMUqyP3PAHaAk4xaX5?=
	=?us-ascii?Q?6x5eRqS06U/9dShq6qbBQu+5KaCBlw6RiZUPtic4VC97ABSVw5P4TPO1MYKt?=
	=?us-ascii?Q?UCrkJJO136az1illUGlJGxmwArWq+xObB5IeK0XIelN/hhjVH6uvyKh4krsa?=
	=?us-ascii?Q?zkskARTiWzW808VcUtE3NSRY5+YFEV3FwrKnH64TPixE9WAR5A+tzxFriZHa?=
	=?us-ascii?Q?4a94Km5X2mjEDL0A0plpp9udqErvJVpBEZpZ5bqEFRmJVq/ib2lPMHxR75y3?=
	=?us-ascii?Q?Zqi9lEYLyzkkfzLEKSP4DFPC6BAYcunGUrKfXBLrMbsnfkSSA0Hq5WV8sDGu?=
	=?us-ascii?Q?tHNdxdJ6UIx0+/QVbpQGM3qST8fGijdrgucs6G9pQt1s?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e472e7d-d0d5-4b79-c217-08d9a0c32099
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2021 01:16:57.7342 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zOnoP67j+UOVcGwWKVjVkVXmiALZy5zKemVk4hnRPh+dddKBjsVRcTb8z4kSTm7FFBreC2Z8aj4D5xq4iIobgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5890
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10159
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0
	suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
	adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111060005
X-Proofpoint-GUID: CPkNVKGBaWMZvCf0yu8jj_ZI2Mh2uXD8
X-Proofpoint-ORIG-GUID: CPkNVKGBaWMZvCf0yu8jj_ZI2Mh2uXD8
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v2 0/2] Dax poison recovery
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Up till now, the method commonly used for data recovery from
dax media error has been a combination of hole-punch followed
by a pwrite(2). The downside of this method is that it causes
fragmentation of the pmem backend, which brings a host of
very challenging issues.

This patch is an attempt to provide an alternative way for
dax users to perform data recovery from pmem media error without
fragmenting the pmem backend.

Dax media error may be manifested to user process via SIGBUS
with .si_code BUS_MCEERR_AR when a load instruction consumes
a poison in the media, or SIGBUS with .si_code BUS_ADRERR when
a page fault handler fails to resolve due to existing poison
record, or IO error returned from a block read or write.

With the patch in place, the way for user process to recover
the data can be just a pwrite(2) to a page aligned range without
the need to punch-a-hole. In case of BUS_MCEERR_AR, the range
is incidated by the signal payload: .si_addr and .si_addr_lsb.
In case of BUS_ADRERR, the range is the user mapping page size
starting from .si_addr. If the clue of media error come from
block IO error, the range is a stretch of the block IO range
to page aligned range.

Changes from v1:
- instead of giving user the say to start dax data recovery,
  let dax-filesystem decide when to enter data recovery mode.
  Hence 99% of the non-dax usage of pwrite and its variants
  aren't aware of dax specific recovering.
- Instead of exporting dax_clear_error() API that does one thing,
  combine dax {poison-clearing, error-record-update, writing-good-data}
  in one tight operation to better protect data integrity.
- some semantics and format fixes

v1: 
https://lore.kernel.org/lkml/20211029223233.GB449541@dread.disaster.area/T/
  
Jane Chu (2):
  dax: Introduce normal and recovery dax operation modes
  dax,pmem: Implement pmem based dax data recovery

 drivers/dax/super.c             | 15 +++---
 drivers/md/dm-linear.c          | 14 +++---
 drivers/md/dm-log-writes.c      | 19 +++++---
 drivers/md/dm-stripe.c          | 14 +++---
 drivers/md/dm-target.c          |  2 +-
 drivers/md/dm-writecache.c      |  8 +--
 drivers/md/dm.c                 | 16 +++---
 drivers/nvdimm/pmem.c           | 86 +++++++++++++++++++++++++++++----
 drivers/nvdimm/pmem.h           |  2 +-
 drivers/s390/block/dcssblk.c    | 13 +++--
 fs/dax.c                        | 32 +++++++++---
 fs/fuse/dax.c                   |  4 +-
 fs/fuse/virtio_fs.c             | 12 +++--
 include/linux/dax.h             | 18 ++++---
 include/linux/device-mapper.h   |  5 +-
 tools/testing/nvdimm/pmem-dax.c |  2 +-
 16 files changed, 187 insertions(+), 75 deletions(-)

-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

