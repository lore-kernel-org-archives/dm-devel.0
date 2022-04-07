Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD88C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:16:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-qVl9XN18MKGcrVy7L08wDQ-1; Wed, 06 Apr 2022 23:15:59 -0400
X-MC-Unique: qVl9XN18MKGcrVy7L08wDQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FF75802803;
	Thu,  7 Apr 2022 03:15:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0156D2024CAE;
	Thu,  7 Apr 2022 03:15:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8E2DC194034B;
	Thu,  7 Apr 2022 03:15:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 96CEC194034B
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 03:15:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 85222428F16; Thu,  7 Apr 2022 03:15:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 800FF428EFD
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:15:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FB0C3C11C89
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:15:55 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-3K11OhGRN3SdgSnIafq5mg-1; Wed, 06 Apr 2022 23:15:53 -0400
X-MC-Unique: 3K11OhGRN3SdgSnIafq5mg-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2372avAj024455; 
 Thu, 7 Apr 2022 03:15:27 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tarf1-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:15:26 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23735a9N024750; Thu, 7 Apr 2022 03:15:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3f97tstrnt-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:15:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MWHPR10MB1711.namprd10.prod.outlook.com (2603:10b6:301:a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 03:15:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 03:15:23 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6cxk2io.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-15-hch@lst.de>
Date: Wed, 06 Apr 2022 23:15:21 -0400
In-Reply-To: <20220406060516.409838-15-hch@lst.de> (Christoph Hellwig's
 message of "Wed, 6 Apr 2022 08:05:03 +0200")
X-ClientProxiedBy: BYAPR07CA0057.namprd07.prod.outlook.com
 (2603:10b6:a03:60::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4633d708-a1a2-4a74-c466-08da1844dafa
X-MS-TrafficTypeDiagnostic: MWHPR10MB1711:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1711503F5A0BB2B0A400CFDE8EE69@MWHPR10MB1711.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Y4FiugFGeFbmb8PnjvBwaJ3cJzRDELCyJpKHCvmnkE9UifUQvtFOE9jpuffFklqEBxT2nOLbgIbcGsKuaPc03l+WeG7LZT12eCdWPYC/N3H4m1it5zxnChG55xziGjbUu3O0x6wjyxuIqifeGbOKFt8iZ31k+ed0BTPxJJ3o0mqTjAboiQTt6p2C9ZAvz9EzdfuMZHfyU5ePJV1sll71j155LElen4hzdJ2TWJVR8Ia4+ZmwhycQyRgLt1qqyS9qyB/9tcYTCyCKT4a8by00nBHziSInPwv6+UyWpG1pEnomwxpPOphlOzBCsh2jB/LFojDh8aR5hy3kuxHDC6/KAIYtWsr3wyaeukYTgK2pLlWZ5NWVJq+ZhznPcnzeaFnNtK5N4SNt3EN+sQPw/ap3j0RLnc14ouWvPPIoMjAnKZRFF8m8tp8tquk43Nq3Ei+n8+fnY1a//u3BeIXFiaHJBXcnzEOxgzM4UmITtMuaUu2WgiwIECluy6IMnrYVr7722GhrOpZxvyi3QM7ecgw6N3/wDNPUVkEbAelL/M4ah73PM/LrSmkfIY4ntwoYSvc8+K49oqRTTxXNehZYvA3B8wRq6mZDT6lcz7azc3QvA92khUlSvEgX15iJA622ZnzptQWWc+CcFkxcFKxfMNLRjH7OlaxkkBKvn5+sRBu4k0wSQxiOf98HSEkQfXYGGwA5rH66Ovk1Nw7Ha9epocawZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6506007)(316002)(66946007)(66476007)(66556008)(8676002)(4326008)(38100700002)(38350700002)(86362001)(83380400001)(6512007)(558084003)(6916009)(186003)(508600001)(7416002)(2906002)(36916002)(8936002)(6486002)(26005)(5660300002)(52116002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SXPUbwvAbIMrgeIGcXihtK7F/d/QeGf+2AY8X2keMtgxdICznYLcl/OTbR81?=
 =?us-ascii?Q?p34XhSf8oG1UMVRfKGeKqPQnahsKRaXvQKrtaRO9NptcM7/rnsdY756L18Af?=
 =?us-ascii?Q?I4uWb/uRnVH5TPp1C+yvwZw3jD+1Zmc5U3Xb+899RKKBTU6ffzqyLkaZiC8p?=
 =?us-ascii?Q?L7ft/gTgGuB5GRjQJdoZfBB6yy6u7B6g+iJLxmu9qsfE8iJzTLf6uyBPipzX?=
 =?us-ascii?Q?o6w0MDPcADUEQ9XrfvgNEwx544vxkCFk6fQhrzB+Si0qek8tYO4fLVcymyxM?=
 =?us-ascii?Q?bNouJJfhR8lG2Iu+7nbURE1U6KY2i09Emf6Tijrdhhtctwv8jbaU5eY/RJTS?=
 =?us-ascii?Q?+2H7eoez+NxaLnVtHol/9zz+JcmU9euyaXdF2nJUoDz7Z7w9h5+js9gmatqB?=
 =?us-ascii?Q?5tAD7/tEVC97V/7p0xpyg7viihtA3EP/CkdVem1F2UIVnHC3cn0ClgTDqh0z?=
 =?us-ascii?Q?UQE7rI+D15jyEngv9KbANg8cY/o3Xx7VvUMPVUeIA7PklPk/V82jbrYHqzBf?=
 =?us-ascii?Q?GNGTfD/V8DtpBPU1w5aodu4n51qaRyDn/7Ukz34HMfgym4dUafZt4ywk6mFY?=
 =?us-ascii?Q?7cF8qmbMNN0/Jym6fUxdFyZmj1ZPhE3KpRhQMlPX1VRtjojCNLuKWW8WMsU3?=
 =?us-ascii?Q?iEkv5gUfoHxTfJD67bDAUaUjOfSp49qIV5Hn0GS8TBHc3BaCA88wMgUANDg2?=
 =?us-ascii?Q?s0rKvytZWeYG5hRgfifaj75083wDQMfHCNG0VHNY5VdTkyrPo5IPf9A3nsfW?=
 =?us-ascii?Q?hBhof1VyzhZHUdFrx/hugS2+ClvX73CVxsnEUCN4u8DVbyZU1UpIEZK6Mti/?=
 =?us-ascii?Q?AETQyMtKhJ+0MiXh6VxBOoOQBrzb1ybyC7R6rFpyDUIVIMLFLVoVUes81XgI?=
 =?us-ascii?Q?7rlqF6J1H5chI/8ELw6GDZWmocQgYYg2QYwM3YfmKsz/jFSLSRasmdvXNVLU?=
 =?us-ascii?Q?3FD6nWJKeH1IXX/iyr2kavSGBFEpz3Z4WUE9btFEILS9Hl4qn2f0na9Qu4/B?=
 =?us-ascii?Q?fMMp6p5Zg5ANIMszgwzUMLtqEZGDtzA8YV1YGoNgDEePOCcq+p/QtQxIPKDL?=
 =?us-ascii?Q?c0W9INPhMFkk6FbxNJbcFlobGzsNMu7zhBAaivFoTCNX8WFTkidYXEzftn4i?=
 =?us-ascii?Q?cRQ70BeSLtZ2OLz/IFX/iPOsDCcCWw1T0WqACQnEd3bww9paMJA51fwRueYq?=
 =?us-ascii?Q?rU28YasdX08mTU1KFEA9KpJMXvgSRoZRvzzKpAvn+YFSd8zCQc/oN1U2freS?=
 =?us-ascii?Q?DA49MsFJCVYZFqYLxELZjiGLc5wf/Bx2nUZx3xlhOk+DyyjIFGXBJpGe2ZLo?=
 =?us-ascii?Q?VNDEOX4vG5OCkMuDfKHZauJ0UboyNot7unO9/27jzD3VDm8LWyWX0p3jJm2J?=
 =?us-ascii?Q?56uhP4r/Klu2KnNkI/81BCBJTM/yRwFoXGtD4nsBG7T+eVr8NXw3wu5BUmM9?=
 =?us-ascii?Q?d6THTGmAzLcwotonFFeAfWz85YW6pGjxIeCfoukgmSTXwFcLEyZg1C+swQYR?=
 =?us-ascii?Q?Cfp0i+2IgoLZ2br0IcUg66iWT4+SM1+Yudaffy0Hvt4jFGjR+lmEZA2wmhky?=
 =?us-ascii?Q?U/WsRCEYDnennvJYlkhMI9kMLN0czh6LJuibMaTFJoYpA107laQB3qSnx/9+?=
 =?us-ascii?Q?9K3lqVcI6jPcTan3jrbF7/C6kWuesos1BUq6lM7hfRwgrsoYQZ4P+Vopc04o?=
 =?us-ascii?Q?UisfB73KFvMMdCy44bEsH3TcS28MrKL3ZSLkNzwl7v9hQCdr5l38ANRpqxVv?=
 =?us-ascii?Q?vMoccR7eYgE3WBSKmhYvKiQTN0VV59k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4633d708-a1a2-4a74-c466-08da1844dafa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:15:23.8630 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4rE+Cty+MdB1lsa3xpRQOVZo5AIqezB8UTRn4pi2YZV5q5rlU8dbrHhIEVkj8tZ61PJI35Q7kugW5WJ/ugaefQRi6DJb1C4qHnVNCBMTQUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1711
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-06_13:2022-04-06,
 2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=925
 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070016
X-Proofpoint-ORIG-GUID: hg0fgzSyHHjuLAMFNKOZE-KrKC2qf3WF
X-Proofpoint-GUID: hg0fgzSyHHjuLAMFNKOZE-KrKC2qf3WF
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 14/27] block: add a
 bdev_max_zone_append_sectors helper
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
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org, linux-raid@vger.kernel.org,
 linux-bcache@vger.kernel.org, ceph-devel@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 ocfs2-devel@oss.oracle.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> Add a helper to check the max supported sectors for zone append based
> on the block_device instead of having to poke into the block layer
> internal request_queue.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

