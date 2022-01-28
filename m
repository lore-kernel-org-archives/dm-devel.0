Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFB34C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 21:32:57 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-rEe7K3EQNnqIK-YcsY4z8A-1; Fri, 28 Jan 2022 16:32:52 -0500
X-MC-Unique: rEe7K3EQNnqIK-YcsY4z8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FDFF190A7A0;
	Fri, 28 Jan 2022 21:32:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72BC01002390;
	Fri, 28 Jan 2022 21:32:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A49D04BB7C;
	Fri, 28 Jan 2022 21:32:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SLWffQ018731 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 16:32:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2356140885C7; Fri, 28 Jan 2022 21:32:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E9BD40885C2
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 21:32:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 022A53803536
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 21:32:41 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-601-8MyjUWYHOeOnKjSGCcDxLQ-1; Fri, 28 Jan 2022 16:32:37 -0500
X-MC-Unique: 8MyjUWYHOeOnKjSGCcDxLQ-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	20SK42js006498; Fri, 28 Jan 2022 21:32:15 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3duwub4cv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jan 2022 21:32:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20SLR0CD135108;
	Fri, 28 Jan 2022 21:32:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by aserp3020.oracle.com with ESMTP id 3dtaxd6un0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jan 2022 21:32:14 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by PH0PR10MB5753.namprd10.prod.outlook.com (2603:10b6:510:146::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8;
	Fri, 28 Jan 2022 21:32:12 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4930.018;
	Fri, 28 Jan 2022 21:32:12 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Fri, 28 Jan 2022 14:31:43 -0700
Message-Id: <20220128213150.1333552-1-jane.chu@oracle.com>
X-ClientProxiedBy: SN7PR04CA0071.namprd04.prod.outlook.com
	(2603:10b6:806:121::16) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b18ba58f-27f0-4bd3-a6d0-08d9e2a5a56a
X-MS-TrafficTypeDiagnostic: PH0PR10MB5753:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5753CDD3E6B3F624CCC1DD0AF3229@PH0PR10MB5753.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Ld5eEDj4gtAEuCiBlESLU8M3muro/3kzEcz1oT/PC6Twd8jGk+OEn82eSEcFQccS3tzlFBMPWgHjS5k42stV73hFdVZG/K8GmmDSNr9x379nPENSDMNayWscjnUCd4uCRqYCG+z5mdwtRK9YIYyE7rQN05rFAqS14clYF9DESRzHIhcBcbO1oGzoY81ibCjVWI4t7u1r/lYwH8+VzKCJr8IY5WtO7svZlTCapYzKVW7thKtBKEXZKyohKZnemCDaAzZP7zkmzftTp+QngUWrij/aG6zDFDShX4uYtKHvn4gUqQKSdv0OavUYglGduqrH854HXi6DSggdbdw7r0f0pZqLNN9IOPVbqdS7dfUolC6cE+9xx8zM2+9cf+T3AY6VnXmJjHDN7Po6cGQiZaHWGqqk7NngijQIckWTfqBmAJsLZ4jY/UHIMNPx2xWLrkgPGsKNOUf6PHY1Bc0wU7nE128tNNIAqbzsyEbhWMhHve5H1J9lGHPXnBj79UZT7gPzKWsJuE2kz/CBFslHf2UqWG6pIH9aqRXIgho5cv6aJzt5HyaDCYYZksVwDG6ONtDmTK6c+0fEdqqZFyaeTtOGmILkY2CwzA787rtbaa09eaDhvvazLe46PKZHHQYnXwe/uMGUiCweQf2+f/y57LUIHgkCmqHXIHD0IOx6VZAMrOAmyaNy7/ZxNiIhtUeOAKAB/fdqOmw7sy4Mrh0t0+qgFCjZzStac01Z5K4AGHMGyBugMdlHvSc9wlIHj5zTKgb8pyHXo6m1ckvof3vonbvk8aS+vMH+NUOEAKhtNDO9pQbOkElsaTxoy8ba1TdKT7ja
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(83380400001)(8676002)(36756003)(38100700002)(508600001)(86362001)(966005)(6486002)(2906002)(6666004)(2616005)(8936002)(6506007)(4743002)(316002)(52116002)(66556008)(6512007)(5660300002)(66476007)(66946007)(44832011)(1076003)(7416002)(186003)(921005);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QeNgDoR2oEIFcHYUqgpelv+yO+70Armqfzwcq+IZqSDWnYFYlOsOKPuPsqE/?=
	=?us-ascii?Q?qu+M8MrCYs/0Q+LJUSFs+GilXqZbpLWybZp/UeLMJ9Z2nz8WkBtju2wuYbRn?=
	=?us-ascii?Q?1lWPDc/J8sOIYFPa8zP34KdjRhnA/m2m1HfYTXks6qlIcvIzI1PqywpioD5D?=
	=?us-ascii?Q?dohiY/q1cZDkUKqgOQCHQFFsRwVNDSv0WIbmVmIbVNXItRCWu9Uw0uniQFqA?=
	=?us-ascii?Q?7NPFFHJa1Ylr899Pk3vFuyLpPuzOUKUMWRO/ttz1oKEXAtGQ3z1GN8GSKbKR?=
	=?us-ascii?Q?MTgk0RosH3gkUfKK8s6E0l86ZyflqEAoR/QJtZp9t0zR5gjrB5XvhEEpZfTZ?=
	=?us-ascii?Q?nAAZseK3JVq3OD3VdRezZdz67Nm/rlEb6AnXOm/xbNpPJS2A0nnlfyBRZA1O?=
	=?us-ascii?Q?d4H+wHTFA7HTw40SgYt2NDDLNJCxY+CFVm1zSb+57Bb0lN6kzrw6qlkNAZYZ?=
	=?us-ascii?Q?GR0qh3XDzb8XRTk/RZxftOduxZ+p6VvCAPb2LNHHOBaRck4kO4hClap+JkQr?=
	=?us-ascii?Q?ruuRfqNaH/v6fd/PRw697wmPujcW5GB3j9KNBXnw2KNIelaxZp7fOBQUlA8T?=
	=?us-ascii?Q?l+JL3uRDbcvkY6huz8t66kjsNNqsXnVTvfZBR2abULs5Y1eMYW7Onp2zNEdG?=
	=?us-ascii?Q?HdMiVeOWfGykp/Ppp+Y+X3jTyGzoZGuEiOfroQd+yT03SMF8Yf4r+1Ny3ngd?=
	=?us-ascii?Q?flax12uhGIYGF5T/kYWCuC9zkhbIMnooIsari6UIv2GiJ64KzDzQHi2EIEei?=
	=?us-ascii?Q?mihc6IoaGZPBt8rd13LzCBoyRCFp/rpzDMCeAInfZxq/V4wXJs07da68amPV?=
	=?us-ascii?Q?4RehxF3yn1l3c3e4jB7t6J1jloA1vj1J4v+MqIP4m172Vs8cjUGEpV/Pd5Fw?=
	=?us-ascii?Q?/MYyTKQHCfnPkNZg8YoGeuYaBIxU2dwK0mq96U7L4sjDKVrTsDi11rsbKPME?=
	=?us-ascii?Q?KyX2XVZxRSA0rlA2oG0WrfhjadExnlGQJaOge1JB5b5spjEW5oF8nEoWahtB?=
	=?us-ascii?Q?LBKaNW9XfF8LZdlgKiNvfDuh1gd/ihvPtiKlYJD9tbAqdcOieBkp94Lq/njE?=
	=?us-ascii?Q?QGszcJRtDbHXqk8e3R7D/Cuky96Qfa/rTtKGzHEb2hr2f6Fb/+fxwMS7FLJp?=
	=?us-ascii?Q?594pVeDHYU/9aqUiY0LXvnpChcp1hFCzBIYoPAECh/HEgdTFoPTxvaaLr02n?=
	=?us-ascii?Q?9epWTJePOw8tLJL2S36V8bocMjqJBwH+IpMtUX9IkOO38S95Tpgql9VszfQb?=
	=?us-ascii?Q?no8XDxG/VOO+UvggRg2gQ3GuGvt7ERMywEKkKlg29FDKeEO/DWkA5sW9rMpS?=
	=?us-ascii?Q?zF8V4bmVNKvpgoZQuXvT01axKqNySoIst459YxrobJixN1/gaPN5DZW9aKcj?=
	=?us-ascii?Q?pQ14atVFCSdCqiXY1rxhLKtF6SZMvib8+t1J7dshi/nGb+ci+4ko12hFAvXC?=
	=?us-ascii?Q?lLqoYr63DdGVPTvUQbokdhrUfnrw4vVSCiYynMqeAWFYjn/mK0pfSSChfIGz?=
	=?us-ascii?Q?ihLRhpMpt5OcVrTrKm5G8mJ+ykqQXBUS+Iwphvcb0Da1IfmKUntcWm+WfCIj?=
	=?us-ascii?Q?sI2oDJbv/3ecWwfT8hYEbEOPeCF51Xrt9/geYDNl4QAnBfvvyJfn5M/YRY89?=
	=?us-ascii?Q?tpPdZ04Rpg+4Nll5eJOTXd99SR+lePgEfLqvIValqNtf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18ba58f-27f0-4bd3-a6d0-08d9e2a5a56a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 21:32:12.6565 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OftMYtmjdyhIlZwlmIb+htrYucaXnHex9RA3JC22t0Aehou8TczUJUKyJPCwQTU7IPjtJO1aq3RoorrEFzADnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5753
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10241
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	bulkscore=0 mlxscore=0
	phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=965 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2201280122
X-Proofpoint-GUID: 0qtujOJIea7eKC6RgyC5BladzYcrKowV
X-Proofpoint-ORIG-GUID: 0qtujOJIea7eKC6RgyC5BladzYcrKowV
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
Subject: [dm-devel] [PATCH v5 0/7] DAX poison recovery
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

Change from v4:
  Fixed build errors reported by kernel test robot
Change from v3:
  Rebased to v5.17-rc1-81-g0280e3c58f92

v4:
https://lore.kernel.org/lkml/20220126211116.860012-1-jane.chu@oracle.com/T/
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
 include/linux/dax.h               | 30 ++++++++++
 include/linux/device-mapper.h     |  9 +++
 include/linux/set_memory.h        |  2 +-
 15 files changed, 306 insertions(+), 27 deletions(-)

-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

